"""
Train the pre-placement GNN congestion predictor.

Loads (*_graph.npz, *_labels.npz) pairs from data_dir.
Graph features come from extract_netlist_features.py (post-synthesis, no placement).
Labels come from extract_labels.py (GRT congestion maps).

Usage:
  cd flow
  python3 ml/congestion/training/train_gnn.py \\
      --data-dir  ml/congestion/data \\
      --ckpt-dir  ml/congestion/checkpoints \\
      --epochs    100
"""

import argparse
import os
import sys

import torch
import torch.nn as nn
from torch.utils.data import DataLoader

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "models"))
sys.path.insert(0, os.path.join(os.path.dirname(__file__)))

from graph_dataset import GraphCongestionDataset, graph_collate, split_graph_dataset
from metrics import compute_all
from gnn import CongestionGNN


def _loss(pred, batch, device):
    heatmap_loss = nn.functional.mse_loss(
        pred.heatmap, batch["heatmap"].to(device)
    )
    hotspot_loss = nn.functional.binary_cross_entropy(
        pred.hotspot, batch["hotspot"].to(device)
    )
    score_loss = nn.functional.mse_loss(
        pred.score, batch["score"].to(device)
    )
    return heatmap_loss + hotspot_loss + 0.1 * score_loss


def train(args):
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"Device: {device}")

    dataset = GraphCongestionDataset(args.data_dir, grid=args.grid)
    train_set, val_set, test_set = split_graph_dataset(dataset)
    print(f"Pairs found: {len(dataset)}  "
          f"train={len(train_set)}  val={len(val_set)}  test={len(test_set)}")

    train_loader = DataLoader(
        train_set, batch_size=args.batch_size, shuffle=True,
        collate_fn=graph_collate, num_workers=0,
    )
    val_loader = DataLoader(
        val_set, batch_size=args.batch_size, shuffle=False,
        collate_fn=graph_collate, num_workers=0,
    )

    model = CongestionGNN(grid=args.grid).to(device)
    optimizer = torch.optim.AdamW(model.parameters(), lr=args.lr, weight_decay=1e-4)
    scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(
        optimizer, T_max=args.epochs, eta_min=1e-6
    )

    os.makedirs(args.ckpt_dir, exist_ok=True)
    best_val_loss = float("inf")

    for epoch in range(1, args.epochs + 1):
        model.train()
        train_loss = 0.0
        for batch in train_loader:
            x          = batch["node_features"].to(device)
            edge_index = batch["edge_index"].to(device)
            batch_vec  = batch["batch"].to(device)

            pred = model(x, edge_index, batch_vec)
            loss = _loss(pred, batch, device)
            optimizer.zero_grad()
            loss.backward()
            nn.utils.clip_grad_norm_(model.parameters(), 1.0)
            optimizer.step()
            train_loss += loss.item()
        train_loss /= len(train_loader)

        model.eval()
        val_loss = 0.0
        val_metrics = {"heatmap_mae": 0.0, "hotspot_iou": 0.0,
                       "score_mae":   0.0, "score_pearson": 0.0}
        with torch.no_grad():
            for batch in val_loader:
                x          = batch["node_features"].to(device)
                edge_index = batch["edge_index"].to(device)
                batch_vec  = batch["batch"].to(device)
                pred = model(x, edge_index, batch_vec)
                val_loss += _loss(pred, batch, device).item()
                m = compute_all(pred, {k: v.to(device) for k, v in batch.items()
                                       if k in ("heatmap", "hotspot", "score")})
                for k in val_metrics:
                    val_metrics[k] += m[k]

        val_loss /= len(val_loader)
        for k in val_metrics:
            val_metrics[k] /= len(val_loader)

        scheduler.step()

        print(
            f"Epoch {epoch:3d}/{args.epochs}  "
            f"train={train_loss:.4f}  val={val_loss:.4f}  "
            f"hmap_mae={val_metrics['heatmap_mae']:.4f}  "
            f"hot_iou={val_metrics['hotspot_iou']:.4f}  "
            f"pearson={val_metrics['score_pearson']:.4f}"
        )

        if val_loss < best_val_loss:
            best_val_loss = val_loss
            ckpt = os.path.join(args.ckpt_dir, "gnn_best.pt")
            torch.save(model.state_dict(), ckpt)
            print(f"  -> saved {ckpt}")

    torch.save(model.state_dict(), os.path.join(args.ckpt_dir, "gnn_last.pt"))
    print(f"Training complete. Best val loss: {best_val_loss:.4f}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--data-dir",   default="ml/congestion/data")
    ap.add_argument("--ckpt-dir",   default="ml/congestion/checkpoints")
    ap.add_argument("--epochs",     type=int,   default=100)
    ap.add_argument("--batch-size", type=int,   default=4)
    ap.add_argument("--grid",       type=int,   default=64)
    ap.add_argument("--lr",         type=float, default=1e-3)
    train(ap.parse_args())


if __name__ == "__main__":
    main()
