#!/usr/bin/env python3
import argparse
import json
import subprocess
import os
import time
import yaml
from pathlib import Path
import optuna

# Small designs for fast broad search
SMALL_TARGETS = [
    "//flow/designs/sky130hd/gcd:gcd_tune_gpl",
    "//flow/designs/asap7/gcd:gcd_tune_gpl"
]

# Large designs for detailed search
LARGE_TARGETS = [
    "//flow/designs/sky130hd/jpeg:jpeg_encoder_tune_gpl",
    "//flow/designs/sky130hd/riscv32i:riscv_tune_gpl",
    "//flow/designs/asap7/mock-cpu:mock_cpu_tune_gpl"
]

def parse_metrics(target_label):
    pkg, name = target_label.split(":")
    pkg_path = pkg.replace("//", "")
    
    platform = pkg_path.split("/")[-2]
    # The target name is e.g. "jpeg_encoder_tune_gpl"
    design_name = name.replace("_tune_gpl", "")
    
    workspace_dir = os.environ.get("BUILD_WORKSPACE_DIRECTORY", ".")
    report_file = Path(workspace_dir) / "bazel-bin" / pkg_path / "results" / platform / design_name / "tune_gpl" / "target_function.txt"
    
    if report_file.exists():
        with open(report_file, "r") as f:
            try:
                wns = float(f.read().strip())
                return wns
            except ValueError:
                pass
    return None

def run_experiment(targets, params):
    cmd = ["bazelisk", "build"]
    for k, v in params.items():
        cmd.append(f"--define={k}={v}")
    for k, v in params.items():
        cmd.append(f"--action_env={k}={v}")
        
    cmd.extend(targets)
    
    print(f"Running: {' '.join(cmd)}")
    workspace_dir = os.environ.get("BUILD_WORKSPACE_DIRECTORY", ".")
    result = subprocess.run(cmd, capture_output=True, text=True, cwd=workspace_dir)
    
    if result.returncode != 0:
        print(f"Build failed for params {params}")
        return None
        
    score = 0
    valid = True
    for t in targets:
        wns = parse_metrics(t)
        if wns is None:
            valid = False
            break
        score += wns
        
    if valid:
        return score / len(targets)
    return None

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", default="study_results.yaml")
    parser.add_argument("--pdk", choices=["sky130hd", "asap7", "all"], default="all")
    args = parser.parse_args()
    
    if args.pdk == "sky130hd":
        small_targets = ["//flow/designs/sky130hd/gcd:gcd_tune_gpl"]
        large_targets = ["//flow/designs/sky130hd/jpeg:jpeg_encoder_tune_gpl", "//flow/designs/sky130hd/riscv32i:riscv_tune_gpl"]
    elif args.pdk == "asap7":
        small_targets = ["//flow/designs/asap7/gcd:gcd_tune_gpl"]
        large_targets = ["//flow/designs/asap7/mock-cpu:mock_cpu_tune_gpl"]
    else:
        small_targets = SMALL_TARGETS
        large_targets = LARGE_TARGETS
    
    print("Starting Phase 1: Broad search on small designs (15 minutes budget)")
    
    study = optuna.create_study(direction="maximize")
    
    start_time = time.time()
    budget_phase1 = 15 * 60 # 15 minutes
    
    def objective(trial):
        wl_penalty = trial.suggest_float("GPL_WIRELENGTH_PENALTY", 0.01, 10.0, log=True)
        timing_span = trial.suggest_float("GPL_TIMING_SPAN_CLOCK_PERCENT", 0.0, 0.5)
        tighten_clock = trial.suggest_float("TIGHTEN_CLOCK_PERIOD", 0.0, 0.2)
        
        params = {
            "GPL_WIRELENGTH_PENALTY": wl_penalty,
            "GPL_TIMING_SPAN_CLOCK_PERCENT": timing_span,
            "TIGHTEN_CLOCK_PERIOD": tighten_clock
        }
        
        score = run_experiment(small_targets, params)
        if score is None:
            raise optuna.exceptions.TrialPruned()
            
        return score
        
    study.optimize(objective, timeout=budget_phase1)
    
    print("Phase 1 complete. Best trial so far:")
    print(study.best_trial)
    
    completed_trials = [t for t in study.trials if t.state == optuna.trial.TrialState.COMPLETE]
    completed_trials.sort(key=lambda t: t.value, reverse=True)
    
    print("\nStarting Phase 2: Detailed search on large designs (6 hours budget)")
    budget_phase2 = 6 * 3600 # 6 hours
    
    if not completed_trials:
        print("No completed trials from Phase 1. Exiting.")
        return
        
    # Measure time for 1 sample
    print(f"Measuring time for 1 sample on {large_targets}...")
    sample_params = completed_trials[0].params
    t0 = time.time()
    run_experiment(large_targets, sample_params)
    t1 = time.time()
    time_per_sample = t1 - t0
    
    print(f"Time for 1 sample: {time_per_sample:.2f} seconds")
    
    if time_per_sample > 0:
        N = int(budget_phase2 / time_per_sample)
    else:
        N = 1
        
    N = max(1, min(N, len(completed_trials)))
    print(f"Budget allows for {N} samples. Taking top {N} candidates from Phase 1.")
    
    top_candidates = completed_trials[:N]
    phase2_results = []
    
    best_phase2_params = None
    best_phase2_score = float('-inf')
    
    for candidate in top_candidates:
        print(f"Evaluating candidate: {candidate.params}")
        score = run_experiment(large_targets, candidate.params)
        
        if score is not None:
            phase2_results.append({"params": candidate.params, "score": score})
            if score > best_phase2_score:
                best_phase2_score = score
                best_phase2_params = candidate.params
                
    print("\nStudy complete.")
    print(f"Best overall parameters from Phase 2: {best_phase2_params} with score {best_phase2_score}")
    
    workspace_dir = os.environ.get("BUILD_WORKSPACE_DIRECTORY", ".")
    output_path = Path(workspace_dir) / args.output
    with open(output_path, "w") as f:
        yaml.dump({"best_parameters": best_phase2_params, "score": best_phase2_score, "all_results": phase2_results}, f)

if __name__ == "__main__":
    main()
