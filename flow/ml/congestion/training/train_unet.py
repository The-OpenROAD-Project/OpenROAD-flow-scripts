"""
Train the U-Net congestion predictor.

Usage:
  cd flow
  python3 ml/congestion/training/train_unet.py \
      --data-dir ml/congestion/data \
      --checkpoint-dir ml/congestion/checkpoints \
      --epochs 100
"""

import argparse
import os
import sys

import torch
import torch.nn as nn
from torch.utils.data import DataLoader

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "models"))
sys.path.insert(0, os.path.join(os.path.dirname(__file__)))

from dataset import CongestionDataset, split_dataset
from metrics import compute_all
from unet import CongestionUNet


def _loss(pred, batch, device):
    heatmap_loss = nn.functional.mse_loss(pred.heatmap, batch["heatmap"].to(device))
    hotspot_loss = nn.functional.binary_cross_entropy(
        pred.hotspot, batch["hotspot"].to(device)
    )
    score_loss = nn.functional.mse_loss(pred.score, batch["score"].to(device))
    return heatmap_loss + hotspot_loss + 0.1 * score_loss


def train(args):
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"Device: {device}")

    dataset = CongestionDataset(args.data_dir, augment=True)
    train_set, val_set, _ = split_dataset(dataset)
    print(f"Train: {len(train_set)}  Val: {len(val_set)}")

    train_loader = DataLoader(train_set, batch_size=args.batch_size, shuffle=True,
                              num_workers=2, pin_memory=True)
    val_loader   = DataLoader(val_set,   batch_size=args.batch_size, shuffle=False,
                              num_workers=2, pin_memory=True)

    model = CongestionUNet(in_channels=4, base_features=32).to(device)
    optimizer = torch.optim.AdamW(model.parameters(), lr=args.lr, weight_decay=1e-4)
    scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(
        optimizer, T_max=args.epochs, eta_min=1e-6
    )

    os.makedirs(args.checkpoint_dir, exist_ok=True)
    best_val_loss = float("inf")

    for epoch in range(1, args.epochs + 1):
        model.train()
        train_loss = 0.0
        for batch in train_loader:
            x = batch["x"].to(device)
            pred = model(x)
            loss = _loss(pred, batch, device)
            optimizer.zero_grad()
            loss.backward()
            nn.utils.clip_grad_norm_(model.parameters(), 1.0)
            optimizer.step()
            train_loss += loss.item()
        train_loss /= len(train_loader)

        model.eval()
        val_loss = 0.0
        val_metrics = {"heatmap_mae": 0, "hotspot_iou": 0,
                       "score_mae": 0, "score_pearson": 0}
        with torch.no_grad():
            for batch in val_loader:
                x = batch["x"].to(device)
                pred = model(x)
                val_loss += _loss(pred, batch, device).item()
                m = compute_all(pred, {k: v.to(device) for k, v in batch.items()
                                       if k != "x"})
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
            f"score_mae={val_metrics['score_mae']:.4f}  "
            f"pearson={val_metrics['score_pearson']:.4f}"
        )

        if val_loss < best_val_loss:
            best_val_loss = val_loss
            ckpt = os.path.join(args.checkpoint_dir, "unet_best.pt")
            torch.save(model.state_dict(), ckpt)
            print(f"  -> saved {ckpt}")

    torch.save(model.state_dict(),
               os.path.join(args.checkpoint_dir, "unet_last.pt"))
    print(f"Training complete. Best val loss: {best_val_loss:.4f}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--data-dir",       default="ml/congestion/data")
    ap.add_argument("--checkpoint-dir", default="ml/congestion/checkpoints")
    ap.add_argument("--epochs",  type=int,   default=100)
    ap.add_argument("--batch-size", type=int, default=8)
    ap.add_argument("--lr",      type=float, default=1e-3)
    train(ap.parse_args())


if __name__ == "__main__":
    main()
