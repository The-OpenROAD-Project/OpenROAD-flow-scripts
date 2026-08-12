#!/usr/bin/env python3
import argparse
import itertools
import json
import subprocess
import os
import yaml
from pathlib import Path

# The small/smoke test set
SMOKE_TARGETS = [
    "//flow/designs/sky130hd/gcd:gcd_route",
    "//flow/designs/asap7/gcd:gcd_route",
    "//flow/designs/asap7/uart:uart_route"
]

# The large/main campaign test set
LARGE_TARGETS = [
    "//flow/designs/sky130hd/ibex:ibex_core_route",
    "//flow/designs/sky130hd/jpeg:jpeg_encoder_route",
    "//flow/designs/sky130hd/microwatt:microwatt_route",
    "//flow/designs/sky130hd/riscv32i:riscv_route",
    "//flow/designs/asap7/mock_array:mock_array_route",
    "//flow/designs/asap7/swerv:swerv_wrapper_route",
    "//flow/designs/asap7/rocket:RocketTile_route"
]

# Grid of hyper-parameters
PARAM_GRID = {
    "GPL_WIRELENGTH_PENALTY": [0.1, 0.25, 0.5],
    "GPL_TIMING_SPAN_CLOCK_PERCENT": [0.05, 0.10, 0.15]
}

def parse_metrics(target_label):
    """
    Given a target like //flow/designs/sky130hd/gcd:gcd_route,
    find its bazel-bin directory and parse the route metrics.
    """
    # e.g. //flow/designs/sky130hd/gcd:gcd_route -> bazel-bin/flow/designs/sky130hd/gcd/gcd_route
    pkg, name = target_label.split(":")
    pkg_path = pkg.replace("//", "")
    bin_dir = Path("bazel-bin") / pkg_path / name / "reports"
    
    # Check for the route timing report
    wns = None
    tns = None
    report_file = bin_dir / "route" / "6_1_fill_route_timing.rpt"
    if not report_file.exists():
        # Fallback to grt timing if route doesn't exist
        report_file = bin_dir / "grt" / "5_route_timing.rpt"
        
    if report_file.exists():
        with open(report_file, "r") as f:
            for line in f:
                if "wns" in line.lower():
                    try:
                        wns = float(line.split()[-1])
                    except ValueError:
                        pass
                if "tns" in line.lower():
                    try:
                        tns = float(line.split()[-1])
                    except ValueError:
                        pass
    return {"wns": wns, "tns": tns}

def run_experiment(targets, params):
    """Run bazelisk build on the targets with the given params."""
    cmd = ["bazelisk", "build"]
    for k, v in params.items():
        cmd.append(f"--define={k}={v}")
    cmd.extend(targets)
    
    print(f"Running: {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=True, text=True)
    
    if result.returncode != 0:
        print(f"Build failed for params {params}")
        return None
        
    results = {}
    for t in targets:
        results[t] = parse_metrics(t)
    return results

def compute_best_params(all_results):
    """Simple pareto-optimal/best selection based on average WNS."""
    best_params = None
    best_score = float('-inf')
    
    for run in all_results:
        metrics = run["results"]
        if not metrics:
            continue
            
        score = 0
        valid = True
        for t, m in metrics.items():
            if m["wns"] is None:
                valid = False
                break
            score += m["wns"]  # Higher WNS (closer to 0 or positive) is better
            
        if valid and score > best_score:
            best_score = score
            best_params = run["params"]
            
    return best_params

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--campaign", choices=["smoke", "large"], default="smoke")
    parser.add_argument("--output", default="study_results.yaml")
    args = parser.parse_args()
    
    targets = SMOKE_TARGETS if args.campaign == "smoke" else LARGE_TARGETS
    
    keys, values = zip(*PARAM_GRID.items())
    combinations = [dict(zip(keys, v)) for v in itertools.product(*values)]
    
    all_results = []
    
    for params in combinations:
        metrics = run_experiment(targets, params)
        all_results.append({
            "params": params,
            "results": metrics
        })
        
    best = compute_best_params(all_results)
    
    final_output = {
        "campaign": args.campaign,
        "best_parameters": best,
        "all_results": all_results
    }
    
    with open(args.output, "w") as f:
        yaml.dump(final_output, f, default_flow_style=False)
        
    print(f"Study complete. Results saved to {args.output}")
    print(f"Best parameters: {best}")

if __name__ == "__main__":
    main()
