#!/usr/bin/env python3
"""
Checks flow metrics against the QoR dashboard's rules
(https://dashboard.precisioninno.com).

The check POSTs a run's numeric metrics from metadata.json to the dashboard,
which compares them against a real baseline build -- the latest master build
by default -- using the thresholds it stores in rule_configs. This is the QoR
gate behind `make metadata`. Rule tolerances live in the dashboard, not in
this repository, and the baseline moves with master, so a merged change
becomes the new baseline without a file update.

Two modes:

    # One run, as `make metadata-check` calls it. --platform and --design name
    # the run for the dashboard; --variant defaults to base.
    ./util/checkQorMetrics.py --metadata reports/asap7/gcd/base/metadata.json \
        -p asap7 -d gcd

    # Sweep every reports/<platform>/<design>/<variant>/metadata.json.
    export DASHBOARD_API_KEY=plt_...       # optional; needed for private platforms
    ./util/checkQorMetrics.py

Exit status: 1 when the dashboard reports a failed rule for any checked run,
0 otherwise. A run the dashboard could not judge -- no baseline, nothing
evaluated, or the service unreachable -- is reported as a warning and does not
fail the check: the check did not run, which is not the same as failing it.
--strict turns those into exit 2 (inconclusive) and 3 (unreachable) for a CI
caller that wants to tell them apart. A missing or unreadable --metadata file
is a usage error and exits 1.
"""

import argparse
import concurrent.futures
import json
import os
import re
import sys
import time
import urllib.error
import urllib.request

# Run from flow/ the way the other report scripts do (genReport.py,
# genReportTable.py, uploadMetadata.py), so the walk root below is theirs.
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))

REPORTS_FOLDER = "reports"
METADATA_FILENAME = "metadata.json"
LOG_FILENAME = f"{REPORTS_FOLDER}/inline-check.log"

SKIPPED_PLATFORMS = ["sky130hd_fakestack", "src"]
SKIPPED_FLOW_VARIANT_KEYWORDS = ["test", "tune"]

API_URL = "https://dashboard.precisioninno.com/api"
BETA_API_URL = "https://beta.dashboard.precisioninno.com/api"

CHECK_PATH = "/compare/check/inline"
REQUEST_TIMEOUT = 60

RETRY_ATTEMPTS = 3
RETRY_BACKOFF_SECONDS = 1.0
RETRYABLE_STATUS = frozenset({429, 500, 502, 503, 504})

DEFAULT_JOB_NAME = "OpenROAD-flow-scripts-Public"

# metadata.json records the ORFS commit, but genMetrics.py writes the strings
# "git not on PATH" / "not a git repo" / "N/A" there when it cannot resolve one.
SHA_RE = re.compile(r"^[0-9a-f]{40}$")
COMMIT_KEY = "run__flow__scripts_commit"

# NAME_W must match the first field width in ROW_FMT.
NAME_W = 46
ROW_FMT = "| {:46} | {:>12} | {:>12} | {:>12} | {:>7} |"
BANNER = "-" * 79


def fit(text, width):
    """Truncate to keep the columns aligned; a trailing '*' marks a cut name."""
    return text if len(text) <= width else text[: width - 1] + "*"


def fmt_value(value):
    """Render a metric value without inventing precision it does not have."""
    if value is None:
        return "n/a"
    # The API is trusted to send finite numbers here, but a report is not worth
    # crashing over: show whatever arrived rather than raise. json.loads accepts
    # the NaN/Infinity literals, and int() rejects both.
    try:
        number = float(value)
        if number == int(number) and abs(number) < 1e15:
            return str(int(number))
        return f"{number:.4f}"
    except (TypeError, ValueError, OverflowError):
        return str(value)


def fmt_delta(value):
    """Same tolerance as fmt_value, with the sign the delta column wants."""
    if value is None:
        return "n/a"
    try:
        return f"{float(value):+.2f}"
    except (TypeError, ValueError):
        return str(value)


def find_runs(reports_dir):
    """Returns (runs, missing) for every flow run under reports_dir.

    runs holds (platform, design, variant, metadata_path); missing holds the
    (platform, design, variant) of a run directory with no metadata.json. The
    caller reports those rather than this function, so the warning survives
    --platform/--design/--variant filtering and reaches the log file.

    Uses relpath rather than the `len(dir.split(os.sep)) != 4` idiom the other
    report scripts use: that one counts segments from the repo root, so it only
    works while the walk root stays a single path segment.
    """
    runs, missing = [], []
    for current, _, files in sorted(os.walk(reports_dir)):
        relative = os.path.relpath(current, reports_dir)
        parts = relative.split(os.sep)
        if relative == "." or len(parts) != 3:
            continue

        platform, design, variant = parts
        if platform in SKIPPED_PLATFORMS:
            continue
        if any(word in variant for word in SKIPPED_FLOW_VARIANT_KEYWORDS):
            continue
        if METADATA_FILENAME not in files:
            missing.append((platform, design, variant))
            continue

        runs.append(
            (platform, design, variant, os.path.join(current, METADATA_FILENAME))
        )
    return runs, missing


def load_metadata(path, only_prefix=None):
    """Returns (metrics, commit_sha). Metrics is empty if the file is unusable.

    only_prefix keeps just the metrics whose name starts with one of the given
    prefixes. The dashboard evaluates only the metrics it receives, so sending
    the synth__ subset gates a synthesis-only run without a separate rule set.
    """
    try:
        with open(path, encoding="utf-8") as metadata_file:
            raw = json.load(metadata_file)
    except (OSError, json.JSONDecodeError) as error:
        print(f"[WARN] Could not read {path}: {error}")
        return {}, ""

    # The API takes a name -> number map, so every string value is dropped. That
    # includes constraints__clocks__details, which is a list and is the clock
    # period source for timing rules -- the dashboard reads it from the baseline build
    # instead, so a baseline predating that metric degrades a PeriodPadding rule
    # to a plain percentage band. Such a rule reports ruleSource
    # 'rule_config_no_period' below rather than failing quietly.
    metrics = {
        key: value
        for key, value in raw.items()
        if isinstance(value, (int, float)) and not isinstance(value, bool)
    }

    # __iter__N keys are numeric and would pass the filter, but ingestion folds
    # the iteration index into a separate column, so no metric definition matches
    # them and the dashboard discards them server-side. Dropping them here keeps the
    # reported metric count honest.
    metrics = {key: value for key, value in metrics.items() if "__iter__" not in key}

    if only_prefix:
        metrics = {
            key: value
            for key, value in metrics.items()
            if any(key.startswith(prefix) for prefix in only_prefix)
        }

    commit = str(raw.get(COMMIT_KEY, ""))
    return metrics, commit if SHA_RE.match(commit) else ""


def post_check(endpoint, api_key, payload):
    """POSTs one run, retrying transient failures.

    Returns (response, error_message); one of them is None.
    """
    request = urllib.request.Request(
        endpoint,
        data=json.dumps(payload).encode("utf-8"),
        method="POST",
        headers={
            "Content-Type": "application/json",
            "Accept": "application/json",
        },
    )
    # Never accept the key as a flag: argv is visible to every other user on the
    # machine through ps.
    if api_key:
        request.add_header("X-Api-Key", api_key)

    error_message = None
    for attempt in range(1, RETRY_ATTEMPTS + 1):
        try:
            with urllib.request.urlopen(request, timeout=REQUEST_TIMEOUT) as response:
                return json.loads(response.read().decode("utf-8")), None
        except urllib.error.HTTPError as error:
            body = error.read().decode("utf-8", errors="replace").strip()
            error_message = f"HTTP {error.code}: {body[:400]}"
            if error.code not in RETRYABLE_STATUS:
                return None, error_message
        except Exception as error:  # urllib raises a wide family; none is fatal here
            error_message = str(error)

        # Linear, not exponential: the whole sweep runs under one developer's
        # attention, and the failures worth waiting out are seconds long.
        if attempt < RETRY_ATTEMPTS:
            time.sleep(RETRY_BACKOFF_SECONDS * attempt)

    return None, f"{error_message} (after {RETRY_ATTEMPTS} attempts)"


def check_run(run, endpoint, api_key, base_commit, job_name, only_prefix=None):
    """Checks one (platform, design, variant) and returns a result dict."""
    platform, design, variant, metadata_path = run
    result = {
        "platform": platform,
        "design": design,
        "variant": variant,
        "status": "error",
        "response": None,
        "error": None,
        "metric_count": 0,
    }

    # One run's surprise must not take down the sweep: this is called from a
    # thread pool, so an escaping exception would surface out of pool.map and
    # skip the report for every other run. Report it as this run's error and let
    # the other runs finish; exit_code() turns it into the documented status.
    try:
        metrics, commit = load_metadata(metadata_path, only_prefix)
        if not metrics:
            result["error"] = f"no numeric metrics in {metadata_path}"
            return result
        result["metric_count"] = len(metrics)

        payload = {
            "CommitSha": commit,
            "BranchName": "",
            "PipelineId": "",
            "JobName": job_name,
            "PlatformName": platform,
            "DesignName": design,
            "VariantName": variant,
            "Metrics": metrics,
            "IsLocal": True,
        }
        if base_commit:
            payload["BaseCommitSha"] = base_commit

        response, error = post_check(endpoint, api_key, payload)
        if error is not None:
            result["error"] = error
            return result

        # render_run reads the response as a mapping. A well-formed endpoint
        # always sends one, but a proxy error page or a bare JSON list would
        # not, so reject it here instead of raising a level up.
        if not isinstance(response, dict):
            result["error"] = f"unexpected response type: {type(response).__name__}"
            return result

        result["response"] = response
        result["status"] = response.get("status", "unknown")
    except Exception as error:  # reported as this run's error, never raised
        result["error"] = f"{type(error).__name__}: {error}"
        result["response"] = None
        result["status"] = "error"
    return result


def render_run(result, verbose):
    """Builds the report lines for one run."""
    identity = f"{result['platform']}/{result['design']}/{result['variant']}"
    lines = [BANNER]

    if result["status"] == "error":
        lines.append(f"[ERROR] {identity}: {result['error']}")
        return lines

    response = result["response"]
    strategy = response.get("baselineStrategy") or "none"

    if result["status"] == "no_baseline":
        lines.append(
            f"[WARN] {identity}: no baseline to compare against "
            f"(strategy={strategy}). Nothing was checked."
        )
        return lines

    totals = response.get("totals", {})
    passed = totals.get("passed", 0)
    failed = totals.get("failed", 0)
    missing = totals.get("missingFromBaseline", 0)
    prefix = "[ERROR]" if failed else "[INFO]"

    lines.append(
        f"{prefix} {identity}: {result['status'].upper()} — "
        f"{passed} passed, {failed} failed, {missing} missing "
        f"({result['metric_count']} metrics sent)"
    )
    lines.append(
        f"[INFO] baseline build {response.get('baseBuildId')} "
        f"({(response.get('baseCommitSha') or '?')[:12]}, {strategy})"
    )

    if result["status"] == "inconclusive":
        lines.append(
            "[WARN] Nothing was evaluated. The design may not be ingested yet, "
            "or the platform is private and no DASHBOARD_API_KEY was set."
        )

    metrics = response.get("metrics", [])
    shown = metrics if verbose else [m for m in metrics if m.get("status") == "fail"]
    shown = [m for m in shown if m.get("status") != "missing_from_baseline"]

    if shown:
        lines.append(ROW_FMT.format("Metric", "Baseline", "Current", "Limit", "Delta%"))
        lines.append(
            ROW_FMT.format("-" * NAME_W, "-" * 12, "-" * 12, "-" * 12, "-" * 7)
        )
        for metric in sorted(shown, key=lambda m: m.get("metricName", "")):
            delta = metric.get("deltaPct")
            lines.append(
                ROW_FMT.format(
                    fit(metric.get("metricName", "?"), NAME_W),
                    fmt_value(metric.get("baseValue")),
                    fmt_value(metric.get("targetValue")),
                    fmt_value(metric.get("thresholdValue")),
                    fmt_delta(delta),
                )
            )

    absent = sorted(
        metric.get("metricName", "?")
        for metric in metrics
        if metric.get("status") == "missing_from_baseline"
    )
    if absent:
        lines.append(
            "[WARN] Rules not evaluated, metric absent from the baseline build: "
            + ", ".join(absent)
        )

    # A rule that fell back reports a different threshold than the one it was
    # configured with, so surface it. thresholdPct is deliberately not shown in
    # the table above: it is meaningless for Metric and Direct modes, where the
    # limit is derived from a reference metric or is the baseline itself.
    for metric in metrics:
        source = metric.get("ruleSource")
        if source in (None, "rule_config", "none"):
            continue
        lines.append(
            f"[WARN] {metric.get('metricName')}: rule fell back to "
            f"{metric.get('mode')} ({source})."
        )

    return lines


def summarize(results):
    """Builds the trailing summary lines."""
    counts = {}
    for result in results:
        counts[result["status"]] = counts.get(result["status"], 0) + 1

    failing = [
        f"{r['platform']}/{r['design']}/{r['variant']}"
        for r in results
        if r["status"] == "fail"
    ]

    lines = [BANNER]
    lines.append(
        "[INFO] QoR dashboard check summary: "
        f"{len(results)} run(s), "
        f"{counts.get('pass', 0)} passed, "
        f"{counts.get('fail', 0)} failed, "
        f"{counts.get('inconclusive', 0)} inconclusive, "
        f"{counts.get('no_baseline', 0)} without a baseline, "
        f"{counts.get('error', 0)} not reached"
    )
    if failing:
        lines.append(f"[ERROR] Failing runs: {', '.join(sorted(failing))}")
    else:
        lines.append("[INFO] No run failed a QoR dashboard rule.")

    # Last line, fixed vocabulary: a log classifier (Jenkins reads
    # metadata-check.log) matches this instead of the counts above.
    lines.append(f"QoR check: {verdict(results)}")
    return lines


def verdict(results):
    """Overall verdict for a set of runs: FAIL, PASS, or INCONCLUSIVE.

    FAIL wins over everything: one failed rule is a regression no matter how the
    other runs did. PASS needs every run to have passed. Anything else -- no
    baseline, nothing evaluated, a request that never got an answer -- is
    INCONCLUSIVE: the check did not run for at least one run.
    """
    statuses = {result["status"] for result in results}
    if "fail" in statuses:
        return "FAIL"
    if statuses == {"pass"}:
        return "PASS"
    return "INCONCLUSIVE"


def exit_code(results, strict):
    """Maps the results to the process exit status.

    1 on FAIL. 0 on PASS. INCONCLUSIVE is 0 unless strict, where a run the
    service never answered (status 'error') is 3 and any other inconclusive
    outcome is 2, matching the contract the Jenkins inline check uses.
    """
    overall = verdict(results)
    if overall == "FAIL":
        return 1
    if overall == "PASS" or not strict:
        return 0
    if any(result["status"] == "error" for result in results):
        return 3
    return 2


def write_log(lines):
    """Saves the report, replacing whatever an earlier sweep left behind.

    Called on every path that gets as far as having something to report, so the
    documented log always describes the run that just finished rather than a
    stale sweep. The one path that skips it is a missing reports/ directory:
    the log lives inside it, so there is nothing there to go stale.
    """
    log_path = os.path.abspath(LOG_FILENAME)
    try:
        os.makedirs(os.path.dirname(log_path), exist_ok=True)
        with open(log_path, "w", encoding="utf-8") as log_file:
            log_file.write("\n".join(lines) + "\n")
        print(f"[INFO] Report written to {log_path}")
    except OSError as error:
        print(f"[WARN] Could not write {log_path}: {error}")


def parse_args(argv):
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--beta",
        action="store_true",
        help=f"Check against {BETA_API_URL} instead of {API_URL}.",
    )
    parser.add_argument(
        "--base-commit",
        help="Pin the baseline to this commit's build instead of latest master.",
    )
    parser.add_argument(
        "--job-name",
        default=os.environ.get("DASHBOARD_JOB_NAME", DEFAULT_JOB_NAME),
        help="Canonical Jenkins job-folder name the dashboard uses to scope the master "
        f"baseline to a pipeline. Default: {DEFAULT_JOB_NAME}. Override for a "
        "secure/private branch whose master-equivalent builds elsewhere, e.g. "
        "OpenROAD-flow-scripts-Private.",
    )
    parser.add_argument(
        "--metadata",
        "-m",
        help="Check this one metadata.json instead of sweeping reports/. "
        "Requires --platform and --design to name the run for the dashboard.",
    )
    parser.add_argument(
        "--only-prefix",
        nargs="+",
        default=None,
        metavar="PREFIX",
        help="Send only metrics whose name starts with one of these prefixes, "
        "e.g. synth__ constraints__ to gate a synthesis-only run.",
    )
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Exit 2 when a run is inconclusive and 3 when the dashboard was "
        "unreachable, instead of 0 with a warning.",
    )
    parser.add_argument(
        "--platform",
        "-p",
        help="Only check this platform. With --metadata: the run's platform.",
    )
    parser.add_argument(
        "--design",
        "-d",
        help="Only check this design. With --metadata: the run's design.",
    )
    parser.add_argument(
        "--variant",
        help="Only check this flow variant. With --metadata: the run's variant "
        "(default: base).",
    )
    parser.add_argument(
        "--jobs",
        "-j",
        type=int,
        default=8,
        help="Concurrent requests. Default: 8.",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Report every rule-checked metric, not only the failing ones.",
    )
    args = parser.parse_args(argv)
    if args.metadata and not (args.platform and args.design):
        parser.error("--metadata requires --platform and --design")
    return args


def sweep_runs(args):
    """Returns (runs, header) for sweep mode, or (None, header) with nothing to do.

    The header carries the warnings for run directories without a metadata.json,
    built after the --platform/--design/--variant filter so a scoped sweep does
    not warn about designs it was never asked to check.
    """
    reports_dir = REPORTS_FOLDER
    if not os.path.isdir(reports_dir):
        print(f"[ERROR] No reports directory at {reports_dir}. Run the flow first.")
        return None, []

    runs, missing = find_runs(reports_dir)

    def selected(entry):
        """Applies --platform/--design/--variant to a run or a missing entry."""
        platform, design, variant = entry[0], entry[1], entry[2]
        return (
            (not args.platform or platform == args.platform)
            and (not args.design or design == args.design)
            and (not args.variant or variant == args.variant)
        )

    runs = [run for run in runs if selected(run)]
    missing = [entry for entry in missing if selected(entry)]

    header = [
        f"[WARN] No {METADATA_FILENAME} for {platform} {design} {variant}."
        for platform, design, variant in missing
    ]

    if not runs:
        header.append(
            f"[WARN] No flow run with a {METADATA_FILENAME} "
            f"found under {reports_dir}."
        )
        for line in header:
            print(line)
        write_log(header)
        return None, header

    return runs, header


def run_check(argv=None):
    args = parse_args(argv)

    endpoint = (BETA_API_URL if args.beta else API_URL) + CHECK_PATH
    api_key = os.environ.get("DASHBOARD_API_KEY", "")

    if args.metadata:
        # Single-run mode: the caller (make metadata-check) names the run and
        # tees stdout into its own log, so no sweep log is written here.
        if not os.path.isfile(args.metadata):
            print(f"[ERROR] No {args.metadata}. Run `make metadata-generate` first.")
            return 1
        runs = [(args.platform, args.design, args.variant or "base", args.metadata)]
        header = []
    else:
        runs, header = sweep_runs(args)
        if runs is None:
            # Nothing to check is not a failed check. Strict callers get the
            # inconclusive code so CI can tell "no reports" from a pass.
            return 2 if args.strict else 0

    # Printed now so a long sweep is not silent, and kept for the log file: a
    # saved report is unreadable without knowing which deployment answered it and
    # whether the caller had a key.
    header.append(f"[INFO] Checking {len(runs)} run(s) against {endpoint}")
    if not api_key:
        header.append(
            "[INFO] No DASHBOARD_API_KEY set — checking public data only. "
            "Private platforms will report as inconclusive, not as an auth error."
        )
    if args.base_commit:
        header.append(f"[INFO] Baseline pinned to commit {args.base_commit}")
    if args.only_prefix:
        prefixes = " ".join(args.only_prefix)
        header.append(f"[INFO] Sending only metrics prefixed {prefixes}")
    for line in header:
        print(line)

    # pool.map keeps input order, so the report reads in a stable
    # platform/design/variant order no matter which requests finish first.
    workers = max(1, min(args.jobs, len(runs)))
    with concurrent.futures.ThreadPoolExecutor(max_workers=workers) as pool:
        results = list(
            pool.map(
                lambda run: check_run(
                    run,
                    endpoint,
                    api_key,
                    args.base_commit,
                    args.job_name,
                    args.only_prefix,
                ),
                runs,
            )
        )

    body = []
    for result in results:
        body.extend(render_run(result, args.verbose))
    body.extend(summarize(results))

    for line in body:
        print(line)

    if not args.metadata:
        write_log(header + body)

    return exit_code(results, args.strict)


if __name__ == "__main__":
    sys.exit(run_check())
