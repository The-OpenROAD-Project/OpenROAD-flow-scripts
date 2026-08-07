"""
PyTorch dataset for congestion prediction.

Each sample is a pair of .npz files:
  <tag>_features.npz  — cell_density, macro_density, pin_density, fanout_density
  <tag>_labels.npz    — heatmap, hotspot, score

Returns a dict with tensor keys matching model input/output names.
"""

import glob
import os

import numpy as np
import torch
from torch.utils.data import Dataset


class CongestionDataset(Dataset):
    def __init__(self, data_dir: str, grid: int = 64, augment: bool = False):
        self.augment = augment
        self.samples = []

        feature_files = sorted(glob.glob(os.path.join(data_dir, "*_features.npz")))
        for feat_path in feature_files:
            tag = os.path.basename(feat_path).replace("_features.npz", "")
            label_path = os.path.join(data_dir, f"{tag}_labels.npz")
            if os.path.exists(label_path):
                self.samples.append((feat_path, label_path))

        if not self.samples:
            raise FileNotFoundError(
                f"No paired feature/label .npz files found in {data_dir}"
            )

    def __len__(self):
        return len(self.samples)

    def __getitem__(self, idx):
        feat_path, label_path = self.samples[idx]

        feat  = np.load(feat_path)
        label = np.load(label_path)

        # Stack the four input channels: (4, H, W)
        x = np.stack([
            feat["cell_density"],
            feat["macro_density"],
            feat["pin_density"],
            feat["fanout_density"],
        ], axis=0).astype(np.float32)

        heatmap = label["heatmap"].astype(np.float32)   # (10, H, W)
        hotspot = label["hotspot"].astype(np.float32)   # (H, W)
        score   = float(label["score"])

        if self.augment:
            x, heatmap, hotspot = self._augment(x, heatmap, hotspot)

        return {
            "x":       torch.from_numpy(x),
            "heatmap": torch.from_numpy(heatmap),
            "hotspot": torch.from_numpy(hotspot).unsqueeze(0),  # (1, H, W)
            "score":   torch.tensor([score], dtype=torch.float32),
        }

    @staticmethod
    def _augment(x, heatmap, hotspot):
        """Random horizontal/vertical flip — preserves physical validity."""
        if np.random.rand() > 0.5:
            x       = np.flip(x,       axis=2).copy()
            heatmap = np.flip(heatmap, axis=2).copy()
            hotspot = np.flip(hotspot, axis=1).copy()
        if np.random.rand() > 0.5:
            x       = np.flip(x,       axis=1).copy()
            heatmap = np.flip(heatmap, axis=1).copy()
            hotspot = np.flip(hotspot, axis=0).copy()
        return x, heatmap, hotspot


def split_dataset(dataset: CongestionDataset, val_frac: float = 0.15,
                  test_frac: float = 0.15, seed: int = 42):
    """Return (train, val, test) subsets."""
    from torch.utils.data import random_split
    n     = len(dataset)
    n_val  = max(1, int(n * val_frac))
    n_test = max(1, int(n * test_frac))
    n_train = n - n_val - n_test
    return random_split(dataset, [n_train, n_val, n_test],
                        generator=torch.Generator().manual_seed(seed))
