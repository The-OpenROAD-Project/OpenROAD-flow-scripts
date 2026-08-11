"""
Thermal prediction inference — run a trained U-Net on a placed design.

The model predicts a per-sample normalised thermal heatmap [0, 1] where 1 is
the hottest point in that specific design. Normalisation is per-sample (not
global), so no external norm JSON is needed.

Two usage modes:

  1. From pre-extracted feature file (no OpenROAD needed):
       python3 ml/congestion/inference/predict_thermal.py \\
           --features   ml/congestion/data/<label>_features.npz \\
           --checkpoint ml/congestion/checkpoints/thermal_best.pt \\
           --out        predicted_thermal.npz

  2. From a placed ODB (requires openroad/orfs-ml:latest and extracts features
     automatically via docker_shell):
       python3 ml/congestion/inference/predict_thermal.py \\
           --odb        /work/results/<platform>/<design>/<tag>/3_place.odb \\
           --checkpoint ml/congestion/checkpoints/thermal_best.pt \\
           --out        predicted_thermal.npz

Output (.npz):
  thermal_pred_norm  (64, 64) float32  relative hotspot map [0, 1]

Run from flow/ directory.
"""

import argparse
import os
import subprocess
import sys
import tempfile

import numpy as np
import torch

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "models"))

from unet import CongestionUNet


def _parse_args():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    group = ap.add_mutually_exclusive_group(required=True)
    group.add_argument("--features",
                       help="Pre-extracted *_features.npz from extract_features.py")
    group.add_argument("--odb",
                       help="Placed ODB (3_place.odb) — features extracted automatically")

    ap.add_argument("--checkpoint", required=True,
                    help="Path to thermal_best.pt checkpoint")
    ap.add_argument("--out", required=True,
                    help="Output .npz path for predicted thermal map")
    ap.add_argument("--base-features", type=int, default=32,
                    help="base_features used when training (default 32)")
    ap.add_argument("--grid", type=int, default=64,
                    help="Grid size (must match training, default 64)")
    return ap.parse_args()


def _extract_features_from_odb(odb_path: str, grid: int) -> str:
    """Run extract_features.py inside docker_shell and return path to temp npz."""
    tmp = tempfile.mktemp(suffix="_features.npz")
    cont_out = f"/work/{os.path.basename(tmp)}"
    feat_script = "/work/ml/congestion/data_collection/extract_features.py"

    cmd = [
        "util/docker_shell", "openroad", "-python", feat_script,
        "--odb", odb_path, "--out", cont_out, "--grid", str(grid),
    ]
    print(f"[predict] Extracting features from {odb_path} ...")
    result = subprocess.run(cmd, capture_output=False, stdin=subprocess.DEVNULL)
    if result.returncode != 0:
        raise RuntimeError(
            "Feature extraction failed. Make sure you have OR_IMAGE set or "
            "that the ODB path is accessible inside the container."
        )
    # docker_shell mounts flow/ as /work, so the file is at flow/<basename>
    host_out = os.path.basename(tmp)
    if not os.path.exists(host_out):
        raise RuntimeError(f"Feature file not found at {host_out} after extraction.")
    return host_out


def load_features(features_path: str) -> torch.Tensor:
    """Load *_features.npz and return (1, 4, H, W) tensor."""
    npz = np.load(features_path)
    x = np.stack([
        npz["cell_density"],
        npz["macro_density"],
        npz["pin_density"],
        npz["fanout_density"],
    ]).astype(np.float32)
    return torch.from_numpy(x).unsqueeze(0)  # (1, 4, H, W)


def predict(args):
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    model = CongestionUNet(
        in_channels=4,
        base_features=args.base_features,
        num_heatmap_layers=1,
    ).to(device)
    state = torch.load(args.checkpoint, map_location=device)
    model.load_state_dict(state)
    model.eval()
    print(f"[predict] Loaded checkpoint: {args.checkpoint}")

    tmp_feat = None
    if args.features:
        feat_path = args.features
    else:
        feat_path = _extract_features_from_odb(args.odb, args.grid)
        tmp_feat = feat_path

    x = load_features(feat_path).to(device)

    with torch.no_grad():
        out = model(x)
    # Per-sample normalised output [0, 1]: 1 = predicted hottest point in design.
    thermal_norm = out.heatmap[0, 0].cpu().numpy().astype(np.float32)

    print(f"[predict] Relative hotspot map: "
          f"min={thermal_norm.min():.3f}  max={thermal_norm.max():.3f}  "
          f"mean={thermal_norm.mean():.3f}")

    np.savez(args.out, thermal_pred_norm=thermal_norm)
    print(f"[predict] Saved → {args.out}")

    if tmp_feat and os.path.exists(tmp_feat):
        os.remove(tmp_feat)


if __name__ == "__main__":
    predict(_parse_args())
