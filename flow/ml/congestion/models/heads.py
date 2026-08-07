"""
Shared output heads used by both U-Net and GNN.

All three heads take a feature tensor and produce one of:
  HeatmapHead  → (B, 10, H, W)  per-layer congestion in [0, 1]
  HotspotHead  → (B,  1, H, W)  binary-ish congestion mask in [0, 1]
  ScoreHead    → (B,  1)        scalar design-level congestion score
"""

import torch
import torch.nn as nn


class HeatmapHead(nn.Module):
    """Projects feature map to per-layer congestion heatmap."""

    def __init__(self, in_channels: int, num_layers: int = 10):
        super().__init__()
        self.conv = nn.Sequential(
            nn.Conv2d(in_channels, in_channels, 3, padding=1),
            nn.ReLU(inplace=True),
            nn.Conv2d(in_channels, num_layers, 1),
            nn.Sigmoid(),
        )

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        return self.conv(x)


class HotspotHead(nn.Module):
    """Projects feature map to a binary congestion hotspot mask."""

    def __init__(self, in_channels: int):
        super().__init__()
        self.conv = nn.Sequential(
            nn.Conv2d(in_channels, in_channels // 2, 3, padding=1),
            nn.ReLU(inplace=True),
            nn.Conv2d(in_channels // 2, 1, 1),
            nn.Sigmoid(),
        )

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        return self.conv(x)


class ScoreHead(nn.Module):
    """Global-average-pools the feature map down to a scalar score."""

    def __init__(self, in_channels: int):
        super().__init__()
        self.pool = nn.AdaptiveAvgPool2d(1)
        self.fc = nn.Sequential(
            nn.Flatten(),
            nn.Linear(in_channels, 64),
            nn.ReLU(inplace=True),
            nn.Linear(64, 1),
            nn.Sigmoid(),
        )

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        return self.fc(self.pool(x))
