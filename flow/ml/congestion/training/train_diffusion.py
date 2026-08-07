"""
Train the DDPM congestion diffusion model.

Diffusion models train much slower than discriminative models — expect 3-5x
longer per epoch than U-Net. Use --timesteps 200 for faster iteration.

Usage:
  cd flow
  python3 ml/congestion/training/train_diffusion.py \
      --data-dir ml/congestion/data \
      --checkpoint-dir ml/congestion/checkpoints \
      --epochs 200 --timesteps 1000
"""

import argparse
import os
import sys

import torch
from torch.utils.data import DataLoader

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "models"))
sys.path.insert(0, os.path.join(os.path.dirname(__file__)))

from dataset import CongestionDataset, split_dataset
from diffusion import CongestionDiffusion


def train(args):
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"Device: {device}  Timesteps: {args.timesteps}")

    dataset = CongestionDataset(args.data_dir, augment=True)
    train_set, val_set, _ = split_dataset(dataset)
    print(f"Train: {len(train_set)}  Val: {len(val_set)}")

    train_loader = DataLoader(train_set, batch_size=args.batch_size, shuffle=True,
                              num_workers=2, pin_memory=True)
    val_loader   = DataLoader(val_set,   batch_size=args.batch_size, shuffle=False,
                              num_workers=2, pin_memory=True)

    model = CongestionDiffusion(timesteps=args.timesteps).to(device)
    n_params = sum(p.numel() for p in model.parameters() if p.requires_grad)
    print(f"Parameters: {n_params:,}")

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
            x_feat    = batch["x"].to(device)
            x_heatmap = batch["heatmap"].to(device)
            loss = model.compute_loss(x_feat, x_heatmap)
            optimizer.zero_grad()
            loss.backward()
            torch.nn.utils.clip_grad_norm_(model.parameters(), 1.0)
            optimizer.step()
            train_loss += loss.item()
        train_loss /= len(train_loader)

        model.eval()
        val_loss = 0.0
        with torch.no_grad():
            for batch in val_loader:
                x_feat    = batch["x"].to(device)
                x_heatmap = batch["heatmap"].to(device)
                val_loss += model.compute_loss(x_feat, x_heatmap).item()
        val_loss /= len(val_loader)

        scheduler.step()
        print(f"Epoch {epoch:3d}/{args.epochs}  train={train_loss:.4f}  val={val_loss:.4f}")

        if val_loss < best_val_loss:
            best_val_loss = val_loss
            ckpt = os.path.join(args.checkpoint_dir, "diffusion_best.pt")
            torch.save(model.state_dict(), ckpt)
            print(f"  -> saved {ckpt}")

    torch.save(model.state_dict(),
               os.path.join(args.checkpoint_dir, "diffusion_last.pt"))
    print(f"Training complete. Best val loss: {best_val_loss:.4f}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--data-dir",       default="ml/congestion/data")
    ap.add_argument("--checkpoint-dir", default="ml/congestion/checkpoints")
    ap.add_argument("--epochs",     type=int,   default=200)
    ap.add_argument("--timesteps",  type=int,   default=1000)
    ap.add_argument("--batch-size", type=int,   default=4)
    ap.add_argument("--lr",         type=float, default=2e-4)
    train(ap.parse_args())


if __name__ == "__main__":
    main()
