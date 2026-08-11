"""
Dataset loader for the thermal prediction track.

Pairs placement feature maps with HotSpot thermal labels:
  Input  (*_features.npz):       x          (5, 64, 64)  float32
  Target (*_thermal_labels.npz): thermal_map (64, 64)    float32  [°C]

Channel layout:
  0: cell_density      — raw placement density
  1: macro_density
  2: pin_density
  3: fanout_density
  4: cell_density_blur — Gaussian-blurred cell density (σ=BLUR_SIGMA cells)
                         approximates lateral thermal diffusion; gives the
                         model a pre-spread view of the power distribution

A sample is included only when BOTH files exist for the same label prefix.

Normalisation strategy — per-sample:
  Each thermal map is independently min-max normalised to [0, 1] within that
  sample. This is intentional: the absolute temperatures from HotSpot vary
  wildly across process nodes and die sizes (a 50 µm asap7 die at 500 mW
  runs at ~2000 °C in simulation; a 0.24 mm nangate45 ibex die at the same
  power runs at ~100 °C). What matters for hotspot prediction is the
  *relative* distribution within a design, not the cross-design scale.

  Consequence: t_min / t_max on the dataset object are per-sample extremes
  stored as lists; train_thermal.py no longer writes a global thermal_norm.json.
  Inference normalises the input the same way (subtract its own min, divide by
  its own range) and produces a relative heatmap [0, 1].

Augmentation (optional, applied during training):
  - Random horizontal flip
  - Random vertical flip
  Both the input and target are flipped identically to preserve correspondence.
"""

import os
import glob
from typing import Optional

import numpy as np
import torch
from scipy.ndimage import gaussian_filter
from torch.utils.data import Dataset, Subset, random_split

# Gaussian blur radius (in grid cells) used to approximate lateral thermal
# diffusion for the pre-diffused input channel. σ=3 on a 64×64 grid spans
# ~3 cells — a conservative approximation; real spreading is larger but the
# model learns the residual from training data.
BLUR_SIGMA = 3.0


class ThermalDataset(Dataset):

    def __init__(self, data_dir: str, augment: bool = False):
        self.augment = augment

        feat_files = {
            os.path.basename(p).replace("_features.npz", ""): p
            for p in glob.glob(os.path.join(data_dir, "*_features.npz"))
        }
        therm_files = {
            os.path.basename(p).replace("_thermal_labels.npz", ""): p
            for p in glob.glob(os.path.join(data_dir, "*_thermal_labels.npz"))
        }

        keys = sorted(feat_files.keys() & therm_files.keys())
        if not keys:
            raise RuntimeError(
                f"No matched feature+thermal pairs found in {data_dir}.\n"
                f"  Feature files  : {len(feat_files)}\n"
                f"  Thermal files  : {len(therm_files)}\n"
                "Run extract_features.py and extract_thermal_labels.py first."
            )

        self.pairs = [(feat_files[k], therm_files[k]) for k in keys]
        self.keys  = keys

        # Per-sample temperature ranges for reference / diagnostics.
        self.t_mins: list[float] = []
        self.t_maxs: list[float] = []
        for _, tp in self.pairs:
            t = np.load(tp)["thermal_map"].astype(np.float32)
            self.t_mins.append(float(t.min()))
            self.t_maxs.append(float(t.max()))

        # Dataset-level properties kept for logging convenience.
        self.t_min = min(self.t_mins)
        self.t_max = max(self.t_maxs)

    def __len__(self):
        return len(self.pairs)

    def __getitem__(self, idx):
        feat_path, therm_path = self.pairs[idx]

        feat = np.load(feat_path)
        cell = feat["cell_density"].astype(np.float32)
        blurred = gaussian_filter(cell, sigma=BLUR_SIGMA)
        # Normalise blurred channel to [0,1] so it stays on the same scale as
        # the raw density inputs (which are already [0,1] from extraction).
        b_max = blurred.max()
        blurred = blurred / b_max if b_max > 0 else blurred
        x = np.stack([
            cell,
            feat["macro_density"],
            feat["pin_density"],
            feat["fanout_density"],
            blurred,
        ]).astype(np.float32)   # (5, 64, 64)

        therm = np.load(therm_path)
        t = therm["thermal_map"].astype(np.float32)   # (64, 64)  °C

        # Per-sample normalisation: each design is independently [0, 1].
        t_lo, t_hi = float(t.min()), float(t.max())
        denom = (t_hi - t_lo) if t_hi > t_lo else 1.0
        t_norm = np.clip((t - t_lo) / denom, 0.0, 1.0)

        x_t      = torch.from_numpy(x)
        target_t = torch.from_numpy(t_norm).unsqueeze(0)  # (1, 64, 64)

        if self.augment:
            if torch.rand(1).item() > 0.5:
                x_t      = torch.flip(x_t,      dims=[2])
                target_t = torch.flip(target_t, dims=[2])
            if torch.rand(1).item() > 0.5:
                x_t      = torch.flip(x_t,      dims=[1])
                target_t = torch.flip(target_t, dims=[1])

        return {"x": x_t, "thermal": target_t, "t_min": t_lo, "t_max": t_hi}

    def denormalize(self, t_norm: torch.Tensor, t_min: float, t_max: float) -> torch.Tensor:
        """Convert per-sample normalised [0,1] back to °C."""
        return t_norm * (t_max - t_min) + t_min


def split_thermal_dataset(
    dataset: ThermalDataset,
    train_frac: float = 0.7,
    val_frac:   float = 0.15,
    seed: int = 42,
) -> tuple[Subset, Subset, Subset]:
    n     = len(dataset)
    n_tr  = max(1, int(n * train_frac))
    n_val = max(1, int(n * val_frac))
    n_te  = max(0, n - n_tr - n_val)
    return random_split(
        dataset, [n_tr, n_val, n_te],
        generator=torch.Generator().manual_seed(seed),
    )
