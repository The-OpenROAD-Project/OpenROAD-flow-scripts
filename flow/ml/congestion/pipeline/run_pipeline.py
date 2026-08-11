#!/usr/bin/env python3
"""
Automated ORFS congestion data collection pipeline.

Runs synth -> floorplan -> grt for each design in designs.json,
automatically retrying at lower utilization on FLW-0024, then
extracts features + labels on success.

Run from the flow/ directory:
    python3 ml/congestion/pipeline/run_pipeline.py

Flags:
    --stop-on-error   Pause on any unexpected failure and ask whether to skip
                      or abort. Without this flag, failures are logged and the
                      pipeline continues to the next design.

Error logs are written to pipeline/logs/<platform>_<design>_<stage>.log
for any failure not auto-handled by the pipeline.

Add new designs by editing pipeline/designs.json.
"""

import argparse
import json
import multiprocessing
import re
import subprocess
import sys
from datetime import datetime
from pathlib import Path

# flow/ directory (4 levels up from this file)
FLOW_DIR = Path(__file__).resolve().parents[3]
LOG_DIR = Path(__file__).parent / "logs"
NPROC = multiprocessing.cpu_count()
MIN_UTIL = 55       # don't try below this utilization
UTIL_STEP = 10      # drop by this much on FLW-0024

FLW0024_RE = re.compile(r"\[ERROR FLW-0024\]")
DPL0038_RE = re.compile(r"\[ERROR DPL-0038\]")   # legalizer: utilization > 100% after CTS
PDN_MISSING_RE = re.compile(r"No rule to make target '.*grid_strategy.*\.tcl'")
GRT0116_RE = re.compile(r"\[ERROR GRT-0116\]|Global routing finished with congestion")
GRT0232_RE = re.compile(r"\[ERROR GRT-0232\]")   # congestion too high: retry at lower util

STOP_ON_ERROR = False  # set by --stop-on-error flag


# ── Helpers ────────────────────────────────────────────────────────────────

def log(msg):
    print(f"[PIPELINE] {msg}", flush=True)


def write_error_log(label: str, stage: str, output: str):
    """Write full command output to a log file for post-mortem inspection."""
    LOG_DIR.mkdir(exist_ok=True)
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = LOG_DIR / f"{label}_{stage}_{ts}.log"
    log_file.write_text(output)
    log(f"Error log written to: {log_file.relative_to(FLOW_DIR)}")
    return log_file


def handle_failure(label: str, stage: str, output: str) -> bool:
    """
    Log a failure. If --stop-on-error, ask the user what to do.
    Returns True to skip this design, False to abort the whole pipeline.
    """
    write_error_log(label, stage, output)
    # Show last 20 lines as a quick summary
    tail = "\n".join(output.splitlines()[-20:])
    print(f"\n--- Last 20 lines of output ---\n{tail}\n---")

    if not STOP_ON_ERROR:
        log("Skipping design and continuing (run with --stop-on-error to pause here).")
        return True  # skip, continue pipeline

    print("\n[PIPELINE] Unknown failure. Options:")
    print("  s = skip this design and continue")
    print("  q = quit the pipeline")
    while True:
        choice = input("  Choice [s/q]: ").strip().lower()
        if choice == "s":
            return True
        if choice == "q":
            return False
        print("  Please enter 's' or 'q'.")


def container_to_host(container_path: str) -> Path:
    """Map /work/... container path to the host filesystem equivalent."""
    assert container_path.startswith("/work/"), f"Expected /work/... path, got: {container_path}"
    return FLOW_DIR / container_path[len("/work/"):]


def run(args: list, timeout=7200) -> tuple[int, str]:
    """
    Run a command from FLOW_DIR, streaming output to stdout in real time.
    Returns (returncode, full_output_string).
    """
    str_args = [str(a) for a in args]
    log(f"$ {' '.join(str_args)}")
    buf = []
    try:
        proc = subprocess.Popen(
            str_args,
            cwd=str(FLOW_DIR),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            # DEVNULL stdin makes docker_shell's `test -t 0` fail,
            # so it won't pass -ti to docker — eliminates TTY output noise.
            stdin=subprocess.DEVNULL,
            text=True,
        )
        for line in proc.stdout:
            sys.stdout.write(line)
            sys.stdout.flush()
            buf.append(line)
        proc.wait(timeout=timeout)
        return proc.returncode, "".join(buf)
    except subprocess.TimeoutExpired:
        proc.kill()
        proc.wait()
        log("TIMEOUT — process killed.")
        return -1, "".join(buf) + "\nTIMEOUT"


def _make(stage, design, platform, util, results_dir, objects_dir, pdn_tcl=None):
    """Run a single ORFS make stage with the correct DESIGN_CONFIG.

    ORFS requires DESIGN_CONFIG (not DESIGN+PLATFORM) to load the correct RTL
    sources and platform config. Passing only DESIGN= defaults to gcd/config.mk.

    Stages must be run sequentially. The tricky part is the "2_1_floorplan" stage:
    the Makefile's do-copy macro generates:
        2_floorplan.sdc: 2_1_floorplan.sdc
    but 2_1_floorplan.sdc is a side-effect of floorplan.tcl with no explicit rule.
    On a fresh RESULTS_DIR, "make floorplan" therefore fails immediately with
    "No rule to make target 2_1_floorplan.sdc". Workaround: first target the
    explicit ODB file (which HAS a do-step rule), causing 2_1_floorplan.sdc to be
    written as a side-effect. Then "make floorplan" succeeds because the file exists.
    """
    design_config = f"./designs/{platform}/{design}/config.mk"
    if stage == "2_1_floorplan":
        # Target the explicit ODB file, not the phony floorplan target.
        # This rule exists (generated by do-step) and writes 2_1_floorplan.sdc
        # as a side-effect, which unblocks the subsequent "make floorplan".
        target = f"{results_dir}/2_1_floorplan.odb"
    else:
        target = stage
    # Derive reports_dir from results_dir by substituting the path prefix.
    # ORFS defaults REPORTS_DIR to reports/<platform>/<design>/base, which
    # causes ODB-0269 (empty markers path) when RESULTS_DIR uses a custom tag.
    reports_dir = results_dir.replace("/work/results/", "/work/reports/")
    cmd = [
        "util/docker_shell", "make", target,
        f"DESIGN_CONFIG={design_config}",
        f"CORE_UTILIZATION={util}",
        f"RESULTS_DIR={results_dir}",
        f"OBJECTS_DIR={objects_dir}",
        f"REPORTS_DIR={reports_dir}",
        f"-j{NPROC}",
    ]
    if stage == "grt":
        cmd.append("PLACE_DENSITY_LB_ADDON=0.0")
        # ODB-0269: global_route -end_incremental fails writing markers for the
        # recover_power re-route step (triggered when OPT_POST_GRT_WNS=0, the
        # nangate45 default). Enabling OPT_POST_GRT_WNS=1 skips that block and
        # runs the WNS repair path instead, which does not trigger the bug.
        cmd.append("OPT_POST_GRT_WNS=1")
    if pdn_tcl:
        cmd.append(f"PDN_TCL={pdn_tcl}")
    return run(cmd)


# ── Extraction ─────────────────────────────────────────────────────────────

def extract_data(results_dir: str, out_label: str) -> bool:
    """
    Extract features, congestion labels, thermal labels, and netlist graph
    from a completed GRT run.

    Four extractions per run:
      0. extract_netlist_features.py — pre-placement netlist graph (GNN input) → *_graph.npz
      1. extract_features.py         — placement features (4-channel 64×64)    → *_features.npz
      2. extract_labels.py           — GRT congestion labels (heatmap/hotspot)  → *_labels.npz
      3. extract_thermal_labels.py   — HotSpot thermal map from placement ODB   → *_thermal_labels.npz

    Steps 0 and 3 are non-fatal: failures are logged and the pipeline continues.
    Steps 1 and 2 (features + congestion labels) are required — failure returns False.

    Thermal extraction requires openroad/orfs-ml:latest (has HotSpot installed).
    Run the pipeline with: OR_IMAGE=openroad/orfs-ml:latest python3 ...
    """
    results_host = container_to_host(results_dir)

    # Prefer grt-failed.odb (congested) over clean grt.odb
    grt_odb = None
    for name in ("5_1_grt-failed.odb", "5_1_grt.odb"):
        if (results_host / name).exists():
            grt_odb = f"{results_dir}/{name}"
            break

    if not grt_odb:
        log("No GRT ODB found — skipping extraction.")
        return False

    place_odb = f"{results_dir}/3_place.odb"
    if not (results_host / "3_place.odb").exists():
        log("3_place.odb not found — skipping extraction.")
        return False

    data_dir  = "/work/ml/congestion/data"
    graph_out   = f"{data_dir}/{out_label}_graph.npz"
    feat_out    = f"{data_dir}/{out_label}_features.npz"
    label_out   = f"{data_dir}/{out_label}_labels.npz"
    thermal_out = f"{data_dir}/{out_label}_thermal_labels.npz"

    # ── 0. Pre-placement netlist graph (GNN input, Track 1) ───────────────
    synth_odb = f"{results_dir}/1_synth.odb"
    if (results_host / "1_synth.odb").exists():
        log(f"Extracting netlist graph from {synth_odb}")
        rc, out = run([
            "util/docker_shell", "openroad", "-python",
            "/work/ml/congestion/data_collection/extract_netlist_features.py",
            "--odb", synth_odb, "--out", graph_out,
        ], timeout=300)
        if rc != 0:
            log("Netlist graph extraction failed or timed out — continuing without graph.")
        else:
            log(f"Saved: {graph_out}")
    else:
        log("1_synth.odb not found — skipping netlist graph extraction.")

    # ── 1. Placement features ──────────────────────────────────────────────
    log(f"Extracting placement features from {place_odb}")
    rc, _ = run([
        "util/docker_shell", "openroad", "-python",
        "/work/ml/congestion/data_collection/extract_features.py",
        "--odb", place_odb, "--out", feat_out,
    ], timeout=300)
    if rc != 0:
        log("Feature extraction failed or timed out.")
        return False

    # ── 2. Congestion labels ───────────────────────────────────────────────
    log(f"Extracting congestion labels from {grt_odb}")
    rc, _ = run([
        "util/docker_shell", "openroad", "-python",
        "/work/ml/congestion/data_collection/extract_labels.py",
        "--odb", grt_odb, "--out", label_out,
    ], timeout=300)
    if rc != 0:
        log("Label extraction failed or timed out.")
        return False

    # ── 3. Thermal labels (requires HotSpot in OR_IMAGE) ──────────────────
    log(f"Extracting thermal labels from {place_odb}")
    rc, out = run([
        "util/docker_shell", "openroad", "-python",
        "/work/ml/congestion/data_collection/extract_thermal_labels.py",
        "--odb", place_odb, "--out", thermal_out,
    ], timeout=300)
    if rc != 0:
        if "hotspot: not found" in out or "No such file" in out:
            log("HotSpot not found in container — skipping thermal extraction. "
                "Run with OR_IMAGE=openroad/orfs-ml:latest to enable it.")
        else:
            log("Thermal extraction failed or timed out — skipping.")
    else:
        log(f"Saved: {thermal_out}")

    log(f"Saved: {feat_out}")
    log(f"Saved: {label_out}")
    return True


# ── Per-design runner ───────────────────────────────────────────────────────

def run_design(cfg: dict) -> dict:
    platform = cfg["platform"]
    design = cfg["design"]
    start_util = cfg.get("utilization", 85)
    pdn_tcl = cfg.get("pdn_tcl")

    result = {
        "platform": platform,
        "design": design,
        "status": "UNKNOWN",
        "utilization": None,
        "data_collected": False,
    }

    log(f"{'='*60}")
    log(f"Design: {platform}/{design}  start_util={start_util}%")
    log(f"{'='*60}")

    label = f"{platform}_{design}"

    # Stages run sequentially: synth → 2_1_floorplan (bootstrap) → floorplan → grt.
    # The bootstrap step is critical: "make floorplan" fails on a fresh RESULTS_DIR
    # because 2_floorplan.sdc depends on 2_1_floorplan.sdc, which has no explicit
    # make rule. Targeting 2_1_floorplan.odb directly writes 2_1_floorplan.sdc as a
    # side-effect, so the subsequent "make floorplan" can find it.
    util = start_util
    while util >= MIN_UTIL:
        tag = f"pipeline_{util}"
        results_dir = f"/work/results/{platform}/{design}/{tag}"
        objects_dir = f"/work/objects/{platform}/{design}/{tag}"
        host_dir = container_to_host(results_dir)

        # If a successful GRT ODB already exists, skip straight to extraction.
        existing_grt = next(
            (host_dir / n for n in ("5_1_grt-failed.odb", "5_1_grt.odb")
             if (host_dir / n).exists()),
            None,
        )
        if existing_grt is not None:
            log(f"GRT ODB already exists at {util}%, skipping to extraction.")
            out_label = f"{platform}_{design}_pipeline_{util}"
            result["status"] = "SUCCESS"
            result["utilization"] = util
            result["data_collected"] = extract_data(results_dir, out_label)
            return result

        shared = (design, platform, util, results_dir, objects_dir, pdn_tcl)

        # ── Synth ──────────────────────────────────────────────────────────
        if (host_dir / "1_synth.odb").exists():
            log(f"Synth already done at {util}%, skipping.")
        else:
            log(f"Running synth at {util}%")
            rc, out = _make("synth", *shared)
            if rc != 0:
                result["status"] = "FAILED_SYNTH"
                handle_failure(label, f"synth_{util}", out)
                return result

        # ── Floorplan sub-step 2_1 (bootstrap) ────────────────────────────
        # Must run before "make floorplan". The Makefile's do-copy rule:
        #   2_floorplan.sdc: 2_1_floorplan.sdc
        # ...requires 2_1_floorplan.sdc, which has no explicit rule, so
        # "make floorplan" fails on a fresh dir with "No rule to make target".
        # Targeting 2_1_floorplan.odb directly (which HAS a do-step rule)
        # writes 2_1_floorplan.sdc as a side-effect, unblocking make floorplan.
        if (host_dir / "2_1_floorplan.odb").exists():
            log(f"Floorplan sub-step 2_1 already done at {util}%, skipping.")
        else:
            log(f"Running floorplan sub-step 2_1 at {util}%")
            rc, out = _make("2_1_floorplan", *shared)
            if rc != 0:
                result["status"] = f"FAILED_FLOORPLAN_{util}"
                handle_failure(label, f"floorplan_2_1_{util}", out)
                return result

        # ── Floorplan (full: 2_2 macro_place → 2_3 tapcell → 2_4 PDN) ────
        if (host_dir / "2_floorplan.odb").exists():
            log(f"Floorplan already done at {util}%, skipping.")
        else:
            log(f"Running floorplan at {util}%")
            rc, out = _make("floorplan", *shared)
            if PDN_MISSING_RE.search(out):
                result["status"] = "FAILED_PDN_MISSING"
                log("PDN file not found. Add correct pdn_tcl to designs.json.")
                write_error_log(label, f"floorplan_{util}", out)
                return result
            if rc != 0:
                result["status"] = f"FAILED_FLOORPLAN_{util}"
                handle_failure(label, f"floorplan_{util}", out)
                return result

        # ── GRT (includes place + CTS) ─────────────────────────────────────
        log(f"Running GRT at {util}%")
        rc, out = _make("grt", *shared)

        if FLW0024_RE.search(out) or DPL0038_RE.search(out) or GRT0232_RE.search(out):
            if FLW0024_RE.search(out):
                error_code = "FLW-0024"
            elif DPL0038_RE.search(out):
                error_code = "DPL-0038"
            else:
                error_code = "GRT-0232"
            new_util = util - UTIL_STEP
            log(f"{error_code} at {util}% — retrying at {new_util}%")
            util = new_util
            continue

        # GRT-0116 = routing finished with congestion = exactly what we want.
        # rc may be non-zero when GRT exits with congestion, but the ODB is written.
        grt_ok = (rc == 0) or GRT0116_RE.search(out)
        if not grt_ok:
            result["status"] = f"FAILED_GRT_{util}"
            log(f"GRT failed with unexpected error at {util}%.")
            handle_failure(label, f"grt_{util}", out)
            return result

        out_label = f"{platform}_{design}_pipeline_{util}"
        result["status"] = "SUCCESS"
        result["utilization"] = util
        result["data_collected"] = extract_data(results_dir, out_label)
        return result

    result["status"] = "FAILED_ALL_UTILS"
    log(f"Density errors persisted down to {MIN_UTIL}% — giving up on {platform}/{design}.")
    return result


# ── Main ───────────────────────────────────────────────────────────────────

def main():
    global STOP_ON_ERROR
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--stop-on-error", action="store_true",
                        help="Pause on unexpected failures instead of skipping silently")
    args = parser.parse_args()
    STOP_ON_ERROR = args.stop_on_error

    designs_file = Path(__file__).parent / "designs.json"
    with open(designs_file) as f:
        designs = json.load(f)

    log(f"Loaded {len(designs)} design(s) from {designs_file.name}")
    if STOP_ON_ERROR:
        log("--stop-on-error active: will pause on unexpected failures.")

    results = []
    for cfg in designs:
        result = run_design(cfg)
        results.append(result)

    lines = [
        "",
        "=" * 60,
        "PIPELINE SUMMARY",
        "=" * 60,
    ]
    for r in results:
        key = f"{r['platform']}/{r['design']}"
        status = r["status"]
        if status == "SUCCESS":
            data = "data collected" if r["data_collected"] else "extraction failed"
            lines.append(f"  {key}: SUCCESS @ {r['utilization']}%  ({data})")
        else:
            lines.append(f"  {key}: {status}")
    lines.append("=" * 60)

    summary = "\n".join(lines)
    print(summary)

    LOG_DIR.mkdir(exist_ok=True)
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    summary_file = LOG_DIR / f"summary_{ts}.log"
    summary_file.write_text(summary.lstrip("\n") + "\n")
    log(f"Summary written to: {summary_file.relative_to(FLOW_DIR)}")


if __name__ == "__main__":
    if not (FLOW_DIR / "Makefile").exists():
        print(f"ERROR: Must be run from flow/ directory or its subdirectory.")
        print(f"       Detected FLOW_DIR={FLOW_DIR}")
        sys.exit(1)
    main()
