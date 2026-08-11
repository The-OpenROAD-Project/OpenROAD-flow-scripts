"""
Train the U-Net thermal predictor.

Input  : 4-channel 64×64 placement feature map  (*_features.npz)
Target : 64×64 normalised thermal map            (*_thermal_labels.npz)

Loss: MSE on the normalised thermal map (continuous regression — no BCE head).
The model outputs only the heatmap head; hotspot and score heads are ignored
for this task. At inference time, denormalize with dataset.denormalize() to
recover °C values.

Usage (from flow/):
  python3 ml/congestion/training/train_thermal.py \\
      --data-dir ml/congestion/data \\
      --checkpoint-dir ml/congestion/checkpoints \\
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

from thermal_dataset import ThermalDataset, split_thermal_dataset
from unet import CongestionUNet


def _loss(pred_heatmap: torch.Tensor, target: torch.Tensor) -> torch.Tensor:
    return nn.functional.mse_loss(pred_heatmap, target)


def train(args):
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"Device: {device}")

    dataset = ThermalDataset(args.data_dir, augment=True)
    print(f"Dataset: {len(dataset)} samples")
    print(f"  Per-sample T range: {dataset.t_min:.1f}°C – {dataset.t_max:.1f}°C  "
          f"(each sample normalised independently)")

    if len(dataset) < 3:
        print("WARNING: fewer than 3 samples — results will not generalise. "
              "Run extract_thermal_batch.sh to collect more data first.")

    train_set, val_set, test_set = split_thermal_dataset(dataset)
    print(f"  Train: {len(train_set)}  Val: {len(val_set)}  Test: {len(test_set)}")

    train_loader = DataLoader(train_set, batch_size=args.batch_size, shuffle=True,
                              num_workers=2, pin_memory=True)
    val_loader   = DataLoader(val_set,   batch_size=args.batch_size, shuffle=False,
                              num_workers=2, pin_memory=True)

    # U-Net: 4-channel input, 1-channel thermal output.
    # num_heatmap_layers=1 gives a single temperature map — no wasted channels.
    # base_features=32 gives ~7M parameters — appropriate for 64×64 spatial task.
    # in_channels=5: cell, macro, pin, fanout + Gaussian-blurred cell density
    # (pre-diffused channel approximates lateral thermal spreading).
    model = CongestionUNet(in_channels=5, base_features=32, num_heatmap_layers=1).to(device)
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
            x      = batch["x"].to(device)
            target = batch["thermal"].to(device)
            pred   = model(x)
            thermal_pred = pred.heatmap  # (B, 1, H, W) — single thermal channel
            loss = _loss(thermal_pred, target)
            optimizer.zero_grad()
            loss.backward()
            nn.utils.clip_grad_norm_(model.parameters(), 1.0)
            optimizer.step()
            train_loss += loss.item()
        train_loss /= len(train_loader)

        model.eval()
        val_loss = 0.0
        val_mae_norm = 0.0  # normalised MAE [0, 1]
        with torch.no_grad():
            for batch in val_loader:
                x      = batch["x"].to(device)
                target = batch["thermal"].to(device)
                pred   = model(x)
                thermal_pred = pred.heatmap  # (B, 1, H, W)
                val_loss += _loss(thermal_pred, target).item()
                val_mae_norm += (thermal_pred - target).abs().mean().item()

        val_loss     /= len(val_loader)
        val_mae_norm /= len(val_loader)

        scheduler.step()

        print(
            f"Epoch {epoch:3d}/{args.epochs}  "
            f"train_mse={train_loss:.5f}  val_mse={val_loss:.5f}  "
            f"val_mae={val_mae_norm:.4f} (norm)"
        )

        if val_loss < best_val_loss:
            best_val_loss = val_loss
            ckpt = os.path.join(args.checkpoint_dir, "thermal_best.pt")
            torch.save(model.state_dict(), ckpt)
            print(f"  -> saved {ckpt}")

    torch.save(
        model.state_dict(),
        os.path.join(args.checkpoint_dir, "thermal_last.pt"),
    )
    print(f"Training complete.  Best val MSE: {best_val_loss:.5f}")


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--data-dir",       default="ml/congestion/data",
                    help="Directory containing *_features.npz and *_thermal_labels.npz")
    ap.add_argument("--checkpoint-dir", default="ml/congestion/checkpoints")
    ap.add_argument("--epochs",     type=int,   default=100)
    ap.add_argument("--batch-size", type=int,   default=8)
    ap.add_argument("--lr",         type=float, default=1e-3)
    train(ap.parse_args())


if __name__ == "__main__":
    main()
