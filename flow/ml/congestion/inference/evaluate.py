"""
Side-by-side evaluation of all congestion models on the held-out test set.

Models evaluated (if checkpoints exist):
  U-Net      checkpoints/unet_best.pt
  GNN        checkpoints/gnn_best.pt
  Swin       checkpoints/swin_best.pt
  Ensemble   (unet + swin averaged — no checkpoint needed)
  Diffusion  checkpoints/diffusion_best.pt
  RF         checkpoints/rf.pkl
  XGBoost    checkpoints/xgb.pkl

Usage:
  cd flow
  python3 ml/congestion/inference/evaluate.py \
      --data-dir ml/congestion/data \
      --checkpoint-dir ml/congestion/checkpoints
"""

import argparse
import os
import sys

import numpy as np
import torch
from torch.utils.data import DataLoader

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "models"))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "training"))

from dataset import CongestionDataset, split_dataset
from metrics import compute_all
from unet import CongestionUNet
from gnn import CongestionGNN
from swin import CongestionSwin
from ensemble import CongestionEnsemble
from diffusion import CongestionDiffusion
from classical import RandomForestCongestion, XGBoostCongestion, load_dataset


def _load_deep(model_cls, ckpt, device, **kwargs):
    m = model_cls(**kwargs).to(device)
    m.load_state_dict(torch.load(ckpt, map_location=device))
    m.eval()
    return m


def _eval_deep(model, loader, device, grid=64, is_gnn=False, is_diffusion=False):
    totals = {"heatmap_mae": 0, "hotspot_iou": 0, "score_mae": 0, "score_pearson": 0}
    n = 0
    N = grid * grid
    coords = torch.arange(N)
    edge_full = torch.stack([coords.repeat_interleave(N), coords.repeat(N)], 0).to(device)

    with torch.no_grad():
        for batch in loader:
            x = batch["x"].to(device)
            B = x.shape[0]

            if is_gnn:
                feats = x.permute(0, 2, 3, 1).reshape(B * N, 4)
                feats = torch.cat([feats, torch.zeros(B * N, 4, device=device)], 1)
                ys = torch.arange(grid).float() / (grid - 1)
                xs = torch.arange(grid).float() / (grid - 1)
                yy, xx = torch.meshgrid(ys, xs, indexing="ij")
                x_norm = xx.flatten().repeat(B).to(device)
                y_norm = yy.flatten().repeat(B).to(device)
                bv = torch.arange(B, device=device).repeat_interleave(N)
                edges = torch.cat([edge_full + b * N for b in range(B)], 1)
                pred = model(feats, edges, bv, x_norm, y_norm)
            elif is_diffusion:
                pred = model.sample(x, n_samples=1)
            else:
                pred = model(x)

            m = compute_all(pred, {k: v.to(device) for k, v in batch.items()
                                   if k != "x"})
            for k in totals:
                totals[k] += m[k]
            n += 1

    return {k: v / n for k, v in totals.items()}


def _eval_classical(model, data_dir, grid=64):
    from classical import load_dataset
    from sklearn.metrics import mean_absolute_error, jaccard_score
    from scipy.stats import pearsonr

    X, y_heatmap, y_hotspot, y_score, design_ids = load_dataset(data_dir, grid)

    # Use same 20% test split as deep models (GroupShuffleSplit seed=42)
    from sklearn.model_selection import GroupShuffleSplit
    gss = GroupShuffleSplit(n_splits=1, test_size=0.2, random_state=42)
    _, test_idx = next(gss.split(X, groups=design_ids))

    X_test   = X[test_idx]
    hmap_gt  = y_heatmap[test_idx]
    hot_gt   = y_hotspot[test_idx].astype(int)

    pred = model.predict(X_test)
    hmap_flat = pred["heatmap"].reshape(10, -1).T
    hot_flat  = (pred["hotspot"].flatten() > 0.5).astype(int)

    hmap_mae = mean_absolute_error(hmap_gt, hmap_flat)
    hot_iou  = jaccard_score(hot_gt, hot_flat, zero_division=0)

    return {
        "heatmap_mae":   hmap_mae,
        "hotspot_iou":   hot_iou,
        "score_mae":     0.0,     # design-level score not easily split
        "score_pearson": 0.0,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--data-dir",        default="ml/congestion/data")
    ap.add_argument("--checkpoint-dir",  default="ml/congestion/checkpoints")
    ap.add_argument("--grid",   type=int, default=64)
    ap.add_argument("--batch",  type=int, default=4)
    args = ap.parse_args()

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"Device: {device}\n")

    dataset = CongestionDataset(args.data_dir)
    _, _, test_set = split_dataset(dataset)
    loader = DataLoader(test_set, batch_size=args.batch, shuffle=False)
    print(f"Test samples: {len(test_set)}\n")

    ckpt = lambda name: os.path.join(args.checkpoint_dir, name)
    results = {}

    # Deep models
    deep_models = [
        ("U-Net",     "unet_best.pt",      lambda c: _load_deep(CongestionUNet, c, device, in_channels=4, base_features=32), False, False),
        ("GNN",       "gnn_best.pt",       lambda c: _load_deep(CongestionGNN,  c, device, grid=args.grid), True,  False),
        ("Swin",      "swin_best.pt",      lambda c: _load_deep(CongestionSwin, c, device, in_channels=4), False, False),
        ("Diffusion", "diffusion_best.pt", lambda c: _load_deep(CongestionDiffusion, c, device), False, True),
    ]

    for name, fname, loader_fn, is_gnn, is_diff in deep_models:
        path = ckpt(fname)
        if not os.path.exists(path):
            print(f"  {name}: checkpoint not found ({path}), skipping")
            continue
        print(f"Evaluating {name}...")
        model = loader_fn(path)
        results[name] = _eval_deep(model, loader, device,
                                   grid=args.grid, is_gnn=is_gnn, is_diffusion=is_diff)

    # Ensemble (no checkpoint — uses loaded U-Net + Swin)
    if "U-Net" in results and "Swin" in results:
        print("Evaluating Ensemble (U-Net + Swin average)...")
        ens = CongestionEnsemble(
            mode="average",
            unet_checkpoint=ckpt("unet_best.pt"),
            swin_checkpoint=ckpt("swin_best.pt"),
            device=device,
        ).to(device).eval()
        results["Ensemble"] = _eval_deep(ens, loader, device)

    # Classical models
    for name, fname, cls in [("RF", "rf.pkl", RandomForestCongestion),
                              ("XGBoost", "xgb.pkl", XGBoostCongestion)]:
        path = ckpt(fname)
        if not os.path.exists(path):
            print(f"  {name}: checkpoint not found ({path}), skipping")
            continue
        print(f"Evaluating {name}...")
        model = cls.load(path)
        results[name] = _eval_classical(model, args.data_dir, args.grid)

    if not results:
        print("\nNo checkpoints found — train the models first.")
        return

    # Print comparison table
    metrics = ["heatmap_mae", "hotspot_iou", "score_mae", "score_pearson"]
    col_w = 12
    header = f"{'Model':<12}" + "".join(f"{m:>{col_w}}" for m in metrics)
    print("\n" + "=" * len(header))
    print(header)
    print("-" * len(header))
    for model_name, m in results.items():
        row = f"{model_name:<12}" + "".join(f"{m[k]:>{col_w}.4f}" for k in metrics)
        print(row)
    print("=" * len(header))

    # Winners
    better_lower = {"heatmap_mae", "score_mae"}
    print("\nBest model per metric:")
    for metric in metrics:
        vals = {m: r[metric] for m, r in results.items()}
        winner = (min if metric in better_lower else max)(vals, key=vals.get)
        direction = "↓" if metric in better_lower else "↑"
        print(f"  {metric:<20} {direction}  {winner}  ({vals[winner]:.4f})")


if __name__ == "__main__":
    main()
