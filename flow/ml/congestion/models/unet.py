"""
U-Net congestion predictor with three output heads.

Input:  (B, 4, H, W)  — cell_density, macro_density, pin_density, fanout_density
Output: CongestionOutput namedtuple
  .heatmap  (B, 10, H, W)  per-layer congestion [0, 1]
  .hotspot  (B,  1, H, W)  hotspot probability  [0, 1]
  .score    (B,  1)        design-level score   [0, 1]
"""

from collections import namedtuple

import torch
import torch.nn as nn

from heads import HeatmapHead, HotspotHead, ScoreHead

CongestionOutput = namedtuple("CongestionOutput", ["heatmap", "hotspot", "score"])


class _ConvBlock(nn.Module):
    def __init__(self, in_ch: int, out_ch: int):
        super().__init__()
        self.block = nn.Sequential(
            nn.Conv2d(in_ch, out_ch, 3, padding=1, bias=False),
            nn.BatchNorm2d(out_ch),
            nn.ReLU(inplace=True),
            nn.Conv2d(out_ch, out_ch, 3, padding=1, bias=False),
            nn.BatchNorm2d(out_ch),
            nn.ReLU(inplace=True),
        )

    def forward(self, x):
        return self.block(x)


class CongestionUNet(nn.Module):
    """
    4-level U-Net.  base_features doubles at each encoder level.
    The bottleneck features are fed to all three heads.
    """

    def __init__(self, in_channels: int = 4, base_features: int = 32):
        super().__init__()
        f = base_features

        # Encoder
        self.enc1 = _ConvBlock(in_channels, f)
        self.enc2 = _ConvBlock(f,      f * 2)
        self.enc3 = _ConvBlock(f * 2,  f * 4)
        self.enc4 = _ConvBlock(f * 4,  f * 8)

        self.pool = nn.MaxPool2d(2)

        # Bottleneck
        self.bottleneck = _ConvBlock(f * 8, f * 16)

        # Decoder
        self.up4   = nn.ConvTranspose2d(f * 16, f * 8, 2, stride=2)
        self.dec4  = _ConvBlock(f * 16, f * 8)

        self.up3   = nn.ConvTranspose2d(f * 8, f * 4, 2, stride=2)
        self.dec3  = _ConvBlock(f * 8,  f * 4)

        self.up2   = nn.ConvTranspose2d(f * 4, f * 2, 2, stride=2)
        self.dec2  = _ConvBlock(f * 4,  f * 2)

        self.up1   = nn.ConvTranspose2d(f * 2, f, 2, stride=2)
        self.dec1  = _ConvBlock(f * 2,  f)

        # Output heads (all operate on the full-resolution decoder output)
        self.heatmap_head = HeatmapHead(f, num_layers=10)
        self.hotspot_head = HotspotHead(f)
        self.score_head   = ScoreHead(f)

    def forward(self, x: torch.Tensor) -> CongestionOutput:
        e1 = self.enc1(x)
        e2 = self.enc2(self.pool(e1))
        e3 = self.enc3(self.pool(e2))
        e4 = self.enc4(self.pool(e3))

        b  = self.bottleneck(self.pool(e4))

        d4 = self.dec4(torch.cat([self.up4(b),  e4], dim=1))
        d3 = self.dec3(torch.cat([self.up3(d4), e3], dim=1))
        d2 = self.dec2(torch.cat([self.up2(d3), e2], dim=1))
        d1 = self.dec1(torch.cat([self.up1(d2), e1], dim=1))

        return CongestionOutput(
            heatmap=self.heatmap_head(d1),
            hotspot=self.hotspot_head(d1),
            score=self.score_head(d1),
        )
