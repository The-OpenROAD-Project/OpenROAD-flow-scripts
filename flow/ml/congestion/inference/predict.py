"""
Run congestion inference on a single design using either model.

Usage:
  cd flow
  # Extract features first (inside Docker):
  util/docker_shell openroad -python ml/congestion/data_collection/extract_features.py \
      --odb results/nangate45/aes/base/3_5_place_dp.odb \
      --out ml/congestion/data/nangate45_aes_features.npz

  # Then predict (on the host):
  python3 ml/congestion/inference/predict.py \
      --features ml/congestion/data/nangate45_aes_features.npz \
      --model unet \
      --checkpoint ml/congestion/checkpoints/unet_best.pt \
      --out-dir ml/congestion/data
"""

import argparse
import os
import sys

import numpy as np
import torch

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "models"))


def _load_model(model_name: str, checkpoint: str, device: torch.device):
    if model_name == "unet":
        from unet import CongestionUNet
        model = CongestionUNet(in_channels=4, base_features=32)
    elif model_name == "swin":
        from swin import CongestionSwin
        model = CongestionSwin(in_channels=4)
    elif model_name == "gnn":
        from gnn import CongestionGNN
        model = CongestionGNN()
    else:
        raise ValueError(f"Unknown model: {model_name}")

    model.load_state_dict(torch.load(checkpoint, map_location=device))
    model.to(device)
    model.eval()
    return model


def predict(args):
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    print(f"Device: {device}  Model: {args.model}")

    feat = np.load(args.features)
    x = np.stack([
        feat["cell_density"],
        feat["macro_density"],
        feat["pin_density"],
        feat["fanout_density"],
    ], axis=0).astype(np.float32)
    x_t = torch.from_numpy(x).unsqueeze(0).to(device)

    model = _load_model(args.model, args.checkpoint, device)

    with torch.no_grad():
        if args.model == "gnn":
            G = x.shape[-1]
            N = G * G
            # Build sparse 8-neighbor edge_index (matches training)
            rows, cols = [], []
            for iy in range(G):
                for ix in range(G):
                    src = iy * G + ix
                    for dy in [-1, 0, 1]:
                        for dx in [-1, 0, 1]:
                            if dy == 0 and dx == 0:
                                continue
                            ny_, nx_ = iy + dy, ix + dx
                            if 0 <= ny_ < G and 0 <= nx_ < G:
                                rows.append(src)
                                cols.append(ny_ * G + nx_)
            edge_index = torch.tensor([rows, cols], dtype=torch.long, device=device)
            ys = torch.arange(G).float() / (G - 1)
            xs = torch.arange(G).float() / (G - 1)
            yy, xx = torch.meshgrid(ys, xs, indexing="ij")
            x_norm = xx.flatten().to(device)
            y_norm = yy.flatten().to(device)
            feats = x_t.permute(0, 2, 3, 1).reshape(N, 4)
            feats = torch.cat([feats, torch.zeros(N, 4, device=device)], dim=1)
            batch_vec = torch.zeros(N, dtype=torch.long, device=device)
            out = model(feats, edge_index, batch_vec, x_norm, y_norm)
        else:
            out = model(x_t)

    heatmap = out.heatmap.squeeze(0).cpu().numpy()   # (10, H, W)
    hotspot = out.hotspot.squeeze(0).squeeze(0).cpu().numpy()  # (H, W)
    score   = float(out.score.squeeze().cpu())

    os.makedirs(args.out_dir, exist_ok=True)
    tag = os.path.basename(args.features).replace("_features.npz", "")
    prefix = os.path.join(args.out_dir, f"{tag}_{args.model}")

    np.save(f"{prefix}_heatmap.npy",  heatmap)
    np.save(f"{prefix}_hotspot.npy",  hotspot)

    print(f"Score: {score:.4f}")
    print(f"Hotspot cells: {(hotspot > 0.5).sum()}/{hotspot.size}")

    layer_names = [f"metal{i+1}" for i in range(10)]
    for i, name in enumerate(layer_names):
        print(f"  {name}: mean={heatmap[i].mean()*100:.1f}%  max={heatmap[i].max()*100:.1f}%")

    # Visualise if matplotlib is available
    try:
        import matplotlib
        matplotlib.use("Agg")
        import matplotlib.pyplot as plt

        fig, axes = plt.subplots(2, 6, figsize=(22, 8))
        for i, name in enumerate(layer_names):
            ax = axes[i // 5, i % 5]
            im = ax.imshow(heatmap[i], vmin=0, vmax=1, cmap="hot", origin="lower")
            ax.set_title(name, fontsize=9)
            ax.axis("off")
            plt.colorbar(im, ax=ax, fraction=0.046)

        # Hotspot in last cell
        ax = axes[1, 5]
        ax.imshow(hotspot, vmin=0, vmax=1, cmap="Reds", origin="lower")
        ax.set_title("Hotspot", fontsize=9)
        ax.axis("off")

        plt.suptitle(f"{tag} — {args.model.upper()}  score={score:.4f}", fontsize=12)
        plt.tight_layout()
        img_path = f"{prefix}_vis.png"
        plt.savefig(img_path, dpi=150, bbox_inches="tight")
        plt.close()
        print(f"Visualisation -> {img_path}")
    except ImportError:
        pass


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--features",   required=True)
    ap.add_argument("--model",      choices=["unet", "swin", "gnn"], default="unet")
    ap.add_argument("--checkpoint", required=True)
    ap.add_argument("--out-dir",    default="ml/congestion/data")
    predict(ap.parse_args())


if __name__ == "__main__":
    main()
