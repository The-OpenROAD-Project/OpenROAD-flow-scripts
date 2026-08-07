"""
Side-by-side evaluation of U-Net vs GNN on the held-out test set.

Usage:
  cd flow
  python3 ml/congestion/inference/evaluate.py \
      --data-dir ml/congestion/data \
      --unet-checkpoint ml/congestion/checkpoints/unet_best.pt \
      --gnn-checkpoint  ml/congestion/checkpoints/gnn_best.pt
"""

import argparse
import os
import sys

import torch
from torch.utils.data import DataLoader

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "models"))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "training"))

from dataset import CongestionDataset, split_dataset
from metrics import compute_all
from unet import CongestionUNet
from gnn import CongestionGNN


def _eval_model(model, loader, device, is_gnn=False, grid=64):
    model.eval()
    totals = {"heatmap_mae": 0, "hotspot_iou": 0, "score_mae": 0, "score_pearson": 0}
    n = 0

    N = grid * grid
    coords = torch.arange(N)
    edge_index_full = torch.stack(
        [coords.repeat_interleave(N), coords.repeat(N)], dim=0
    ).to(device)

    with torch.no_grad():
        for batch in loader:
            x = batch["x"].to(device)
            B = x.shape[0]

            if is_gnn:
                feats = x.permute(0, 2, 3, 1).reshape(B * N, 4)
                feats = torch.cat([feats, torch.zeros(B * N, 4, device=device)], dim=1)
                ys = torch.arange(grid).float() / (grid - 1)
                xs = torch.arange(grid).float() / (grid - 1)
                yy, xx = torch.meshgrid(ys, xs, indexing="ij")
                x_norm = xx.flatten().repeat(B).to(device)
                y_norm = yy.flatten().repeat(B).to(device)
                batch_vec = torch.arange(B, device=device).repeat_interleave(N)
                edges = torch.cat(
                    [edge_index_full + b * N for b in range(B)], dim=1
                )
                pred = model(feats, edges, batch_vec, x_norm, y_norm)
            else:
                pred = model(x)

            m = compute_all(pred, {k: v.to(device) for k, v in batch.items()
                                   if k != "x"})
            for k in totals:
                totals[k] += m[k]
            n += 1

    return {k: v / n for k, v in totals.items()}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--data-dir",          default="ml/congestion/data")
    ap.add_argument("--unet-checkpoint",   default="ml/congestion/checkpoints/unet_best.pt")
    ap.add_argument("--gnn-checkpoint",    default="ml/congestion/checkpoints/gnn_best.pt")
    ap.add_argument("--grid", type=int,    default=64)
    ap.add_argument("--batch-size", type=int, default=4)
    args = ap.parse_args()

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"Device: {device}")

    dataset = CongestionDataset(args.data_dir)
    _, _, test_set = split_dataset(dataset)
    test_loader = DataLoader(test_set, batch_size=args.batch_size, shuffle=False)
    print(f"Test samples: {len(test_set)}")

    results = {}

    if os.path.exists(args.unet_checkpoint):
        unet = CongestionUNet(in_channels=4, base_features=32).to(device)
        unet.load_state_dict(torch.load(args.unet_checkpoint, map_location=device))
        results["U-Net"] = _eval_model(unet, test_loader, device, is_gnn=False)
    else:
        print(f"U-Net checkpoint not found: {args.unet_checkpoint}")

    if os.path.exists(args.gnn_checkpoint):
        gnn = CongestionGNN(grid=args.grid).to(device)
        gnn.load_state_dict(torch.load(args.gnn_checkpoint, map_location=device))
        results["GNN"]  = _eval_model(gnn, test_loader, device, is_gnn=True,
                                      grid=args.grid)
    else:
        print(f"GNN checkpoint not found: {args.gnn_checkpoint}")

    if not results:
        print("No checkpoints found — train the models first.")
        return

    # Print comparison table
    metrics = ["heatmap_mae", "hotspot_iou", "score_mae", "score_pearson"]
    header  = f"{'Metric':<20}" + "".join(f"{m:>12}" for m in results)
    print("\n" + header)
    print("-" * len(header))
    for metric in metrics:
        row = f"{metric:<20}"
        for model_name, m in results.items():
            val = m[metric]
            row += f"{val:>12.4f}"
        print(row)

    # Highlight winner per metric
    print("\nBetter model per metric (↓ = lower is better, ↑ = higher is better):")
    better_lower = {"heatmap_mae", "score_mae"}
    for metric in metrics:
        vals = {m: r[metric] for m, r in results.items()}
        if metric in better_lower:
            winner = min(vals, key=vals.get)
        else:
            winner = max(vals, key=vals.get)
        print(f"  {metric:<20} → {winner}")


if __name__ == "__main__":
    main()
