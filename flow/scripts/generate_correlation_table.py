import subprocess
import os
from pathlib import Path
import pandas as pd

# Large study target list (Global Route stage for speed)
TARGETS = [
    ("sky130hd", "gcd", "//flow/designs/sky130hd/gcd:gcd_grt"),
    ("sky130hd", "jpeg", "//flow/designs/sky130hd/jpeg:jpeg_encoder_grt"),
    ("sky130hd", "riscv32i", "//flow/designs/sky130hd/riscv32i:riscv_grt"),
    ("asap7", "gcd", "//flow/designs/asap7/gcd:gcd_grt"),
    ("asap7", "mock-cpu", "//flow/designs/asap7/mock-cpu:mock_cpu_grt"),
]

def parse_stage_metrics(platform, design_name, stage):
    workspace_dir = os.environ.get("BUILD_WORKSPACE_DIRECTORY", ".")
    stage_file_map = {
        "3_place": "3_3_place_gp.json",
        "5_grt": "5_1_grt.json"
    }
    json_filename = stage_file_map.get(stage, f"{stage}.json")
    
    # Path in bazel-bin
    json_file = Path(workspace_dir) / "bazel-bin" / "flow" / "designs" / platform / design_name / "logs" / platform / design_name / "base" / json_filename
    if not json_file.exists():
        # Try alternate design folder structure if design_name differs from package
        for candidate in (Path(workspace_dir) / "bazel-bin" / "flow" / "designs" / platform).rglob(json_filename):
            json_file = candidate
            break

    if not json_file.exists():
        return None, None, None

    try:
        import json
        with open(json_file) as f:
            data = json.load(f)
            prefix = "globalplace" if "3_place" in stage else "globalroute"
            fmax = data.get(f"{prefix}__timing__fmax", None)
            ws = data.get(f"{prefix}__timing__setup__ws", None)
            tns = data.get(f"{prefix}__timing__setup__tns", None)
            return fmax, ws, tns
    except Exception as e:
        return None, None, None


def generate_table():
    workspace_dir = os.environ.get("BUILD_WORKSPACE_DIRECTORY", ".")
    rows = []

    for platform, design_name, target in TARGETS:
        p_fmax, p_ws, p_tns = parse_stage_metrics(platform, design_name, "3_place")
        g_fmax, g_ws, g_tns = parse_stage_metrics(platform, design_name, "5_grt")

        if p_fmax is None or g_fmax is None:
            print(f"Building {target}...")
            cmd = ["bazelisk", "build", target]
            res = subprocess.run(cmd, cwd=workspace_dir, capture_output=True, text=True)
            if res.returncode != 0:
                print(f"Warning: Build failed for {target}")
                rows.append({
                    "PDK": platform,
                    "Design": design_name,
                    "Place Fmax (MHz)": "N/A (Build Failed)",
                    "GRT Fmax (MHz)": "N/A",
                    "Place WS": "N/A",
                    "GRT WS": "N/A",
                    "Fmax Ratio (GRT/Place)": "N/A",
                    "Status": "Build Error"
                })
                continue
            p_fmax, p_ws, p_tns = parse_stage_metrics(platform, design_name, "3_place")
            g_fmax, g_ws, g_tns = parse_stage_metrics(platform, design_name, "5_grt")

        if p_fmax is None or g_fmax is None:
            rows.append({
                "PDK": platform,
                "Design": design_name,
                "Place Fmax (MHz)": "N/A",
                "GRT Fmax (MHz)": "N/A",
                "Place WS": "N/A",
                "GRT WS": "N/A",
                "Fmax Ratio (GRT/Place)": "N/A",
                "Status": "Missing Data"
            })
            continue

        p_fmax_mhz = p_fmax / 1e6
        g_fmax_mhz = g_fmax / 1e6
        ratio = g_fmax_mhz / p_fmax_mhz if p_fmax_mhz != 0 else 0.0

        status = "Good Correlation" if ratio >= 0.85 else ("Moderate Divergence" if ratio >= 0.70 else "Poor Correlation")

        unit = "ps" if platform == "asap7" else "ns"
        rows.append({
            "PDK": platform,
            "Design": design_name,
            "Place Fmax (MHz)": f"{p_fmax_mhz:.1f}",
            "GRT Fmax (MHz)": f"{g_fmax_mhz:.1f}",
            "Place WS": f"{p_ws:.2f} {unit}",
            "GRT WS": f"{g_ws:.2f} {unit}",
            "Fmax Ratio (GRT/Place)": f"{ratio:.3f}",
            "Status": status
        })

    df = pd.DataFrame(rows)
    # Simple custom markdown table formatting without tabulate dependency
    headers = list(df.columns)

    lines = [
        "| " + " | ".join(headers) + " |",
        "| " + " | ".join(["---"] * len(headers)) + " |"
    ]
    for _, row in df.iterrows():
        lines.append("| " + " | ".join(str(val) for val in row) + " |")
    md_table = "\n".join(lines)
    
    print("\n" + "="*80)
    print("PLACE vs GLOBAL ROUTE (GRT) TIMING CORRELATION STUDY")
    print("="*80 + "\n")
    print(md_table)
    print("\n" + "="*80 + "\n")

    out_path = Path(workspace_dir) / "correlation_table.md"
    with open(out_path, "w") as f:
        f.write("# Place vs Global Route Timing Correlation Study\n\n")
        f.write(md_table + "\n")

if __name__ == "__main__":
    generate_table()
