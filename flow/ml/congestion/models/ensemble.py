"""
Ensemble congestion predictor — combines U-Net and Swin outputs.

Two modes:
  'average'  — simple average of both models' predictions (no extra training)
  'learned'  — a small learned weighting network trained on top of frozen base models

Input:  (B, 4, H, W)  — same as U-Net / Swin
Output: CongestionOutput namedtuple
"""

from collections import namedtuple

import torch
import torch.nn as nn

from heads import HeatmapHead, HotspotHead, ScoreHead
from unet import CongestionUNet
from swin import CongestionSwin

CongestionOutput = namedtuple("CongestionOutput", ["heatmap", "hotspot", "score"])


class _LearnedFusion(nn.Module):
    """
    Tiny network that takes concatenated predictions from two models
    and learns optimal per-pixel weights.
    Input:  (B, 2*10, H, W) for heatmap, (B, 2, H, W) for hotspot
    Output: (B, 10, H, W) and (B, 1, H, W)
    """
    def __init__(self):
        super().__init__()
        self.heatmap_fuse = nn.Sequential(
            nn.Conv2d(20, 32, 3, padding=1),
            nn.ReLU(inplace=True),
            nn.Conv2d(32, 10, 1),
            nn.Sigmoid(),
        )
        self.hotspot_fuse = nn.Sequential(
            nn.Conv2d(2, 16, 3, padding=1),
            nn.ReLU(inplace=True),
            nn.Conv2d(16, 1, 1),
            nn.Sigmoid(),
        )
        self.score_fuse = nn.Sequential(
            nn.Linear(2, 8),
            nn.ReLU(inplace=True),
            nn.Linear(8, 1),
            nn.Sigmoid(),
        )

    def forward(self, out_a, out_b):
        heatmap = self.heatmap_fuse(torch.cat([out_a.heatmap, out_b.heatmap], dim=1))
        hotspot = self.hotspot_fuse(torch.cat([out_a.hotspot, out_b.hotspot], dim=1))
        score   = self.score_fuse(torch.cat([out_a.score, out_b.score], dim=1))
        return CongestionOutput(heatmap=heatmap, hotspot=hotspot, score=score)


class CongestionEnsemble(nn.Module):
    """
    Ensemble of U-Net + Swin Transformer.

    mode='average': no extra parameters, works without retraining
    mode='learned': trains a small fusion head on top of frozen base models
    """

    def __init__(self, mode: str = "average",
                 unet_checkpoint: str = None,
                 swin_checkpoint: str = None,
                 device: torch.device = None):
        super().__init__()
        assert mode in ("average", "learned")
        self.mode = mode

        dev = device or torch.device("cpu")

        self.unet = CongestionUNet(in_channels=4, base_features=32)
        self.swin = CongestionSwin(in_channels=4)

        if unet_checkpoint:
            self.unet.load_state_dict(
                torch.load(unet_checkpoint, map_location=dev)
            )
        if swin_checkpoint:
            self.swin.load_state_dict(
                torch.load(swin_checkpoint, map_location=dev)
            )

        if mode == "learned":
            # Freeze base models — only train the fusion head
            for p in self.unet.parameters():
                p.requires_grad_(False)
            for p in self.swin.parameters():
                p.requires_grad_(False)
            self.fusion = _LearnedFusion()
        else:
            self.fusion = None

    def forward(self, x: torch.Tensor) -> CongestionOutput:
        out_u = self.unet(x)
        out_s = self.swin(x)

        if self.mode == "average":
            return CongestionOutput(
                heatmap=(out_u.heatmap + out_s.heatmap) / 2,
                hotspot=(out_u.hotspot + out_s.hotspot) / 2,
                score  =(out_u.score   + out_s.score)   / 2,
            )
        else:
            return self.fusion(out_u, out_s)
