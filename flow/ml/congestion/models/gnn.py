"""
Pre-placement congestion predictor: GNN encoder + CNN decoder.

Takes a post-synthesis netlist graph (no placement coordinates) and predicts
a spatial congestion heatmap over the floorplan grid.

Node features (6):
  [area_norm, is_macro, is_seq, is_buf, fanin_norm, fanout_norm]

Architecture:
  1. Linear projection + 3-layer GraphSAGE encoder
  2. Global mean+max pooling → graph-level vector
  3. Seed MLP → reshape to (B, decoder_dim, 4, 4) spatial seed
  4. CNN decoder: 4×4 → grid×grid via bilinear upsample + conv
  5. Shared output heads (same as U-Net — fair comparison)

Why global pool + decoder instead of scatter-to-grid?
  Scatter-to-grid needs placement coordinates to know where each node goes on
  the spatial canvas. Pre-placement, those don't exist. Global pooling collapses
  the netlist into a topology fingerprint; the decoder learns to translate that
  fingerprint into a spatial congestion pattern purely from training signal.

Output: CongestionOutput namedtuple
  .heatmap  (B, 10, H, W)  — per-layer overflow fraction
  .hotspot  (B,  1, H, W)  — binary congestion mask
  .score    (B,  1)         — scalar congestion severity
"""

import math
from collections import namedtuple

import torch
import torch.nn as nn
import torch.nn.functional as F
from torch_geometric.nn import SAGEConv, LayerNorm, global_mean_pool, global_max_pool

from heads import HeatmapHead, HotspotHead, ScoreHead

CongestionOutput = namedtuple("CongestionOutput", ["heatmap", "hotspot", "score"])

NODE_FEATURES = 6   # area_norm, is_macro, is_seq, is_buf, fanin_norm, fanout_norm
EMBED_DIM     = 64
DECODER_DIM   = 64
SEED_SIZE     = 4   # spatial seed is SEED_SIZE × SEED_SIZE before upsampling


def _build_decoder(decoder_dim: int, out_channels: int, grid: int) -> nn.Sequential:
    """
    Build a CNN decoder that upsamples a (decoder_dim, SEED_SIZE, SEED_SIZE)
    spatial seed to (out_channels, grid, grid).

    Uses bilinear upsample + Conv2d rather than ConvTranspose2d to avoid
    checkerboard artefacts. Each stage doubles the spatial resolution.
    """
    n_steps = int(math.log2(grid // SEED_SIZE))
    assert SEED_SIZE * (2 ** n_steps) == grid, \
        f"grid={grid} must be SEED_SIZE={SEED_SIZE} × a power of 2"

    layers = []
    in_ch = decoder_dim
    for i in range(n_steps):
        out_ch = out_channels if i == n_steps - 1 else decoder_dim
        layers += [
            nn.Upsample(scale_factor=2, mode="bilinear", align_corners=False),
            nn.Conv2d(in_ch, out_ch, kernel_size=3, padding=1, bias=False),
            nn.BatchNorm2d(out_ch),
            nn.ReLU(inplace=True),
        ]
        in_ch = out_ch
    return nn.Sequential(*layers)


class CongestionGNN(nn.Module):

    def __init__(
        self,
        grid: int = 64,
        embed_dim: int = EMBED_DIM,
        decoder_dim: int = DECODER_DIM,
        spatial_channels: int = 32,  # channels fed into the output heads
    ):
        super().__init__()
        self.grid        = grid
        self.decoder_dim = decoder_dim

        # ── Encoder ───────────────────────────────────────────────────────
        self.proj  = nn.Linear(NODE_FEATURES, embed_dim)

        self.sage1 = SAGEConv(embed_dim, embed_dim)
        self.norm1 = LayerNorm(embed_dim)
        self.sage2 = SAGEConv(embed_dim, embed_dim)
        self.norm2 = LayerNorm(embed_dim)
        self.sage3 = SAGEConv(embed_dim, embed_dim)
        self.norm3 = LayerNorm(embed_dim)

        # ── Graph → spatial seed ──────────────────────────────────────────
        # Concatenate mean and max pool → 2*embed_dim graph fingerprint,
        # then project to a flat spatial seed and reshape.
        self.seed_mlp = nn.Sequential(
            nn.Linear(2 * embed_dim, decoder_dim * SEED_SIZE * SEED_SIZE),
            nn.ReLU(inplace=True),
        )

        # ── CNN decoder ───────────────────────────────────────────────────
        self.decoder = _build_decoder(decoder_dim, spatial_channels, grid)

        # ── Output heads (identical to U-Net for fair comparison) ─────────
        self.heatmap_head = HeatmapHead(spatial_channels, num_layers=10)
        self.hotspot_head = HotspotHead(spatial_channels)
        self.score_head   = ScoreHead(spatial_channels)

    def forward(
        self,
        x: torch.Tensor,          # (N, 6)  node features
        edge_index: torch.Tensor,  # (2, E)  COO edges
        batch: torch.Tensor,       # (N,)    batch assignment per node
    ) -> CongestionOutput:

        # Encode
        h = F.relu(self.proj(x))
        h = F.relu(self.norm1(self.sage1(h, edge_index)))
        h = F.relu(self.norm2(self.sage2(h, edge_index)))
        h = F.relu(self.norm3(self.sage3(h, edge_index)))

        # Global pool: mean + max → graph fingerprint
        h_mean = global_mean_pool(h, batch)          # (B, embed_dim)
        h_max  = global_max_pool(h, batch)           # (B, embed_dim)
        h_global = torch.cat([h_mean, h_max], dim=1) # (B, 2*embed_dim)

        # Project to spatial seed
        seed = self.seed_mlp(h_global)                       # (B, D*S*S)
        B = seed.shape[0]
        seed = seed.view(B, self.decoder_dim, SEED_SIZE, SEED_SIZE)

        # Decode to spatial feature map
        spatial = self.decoder(seed)  # (B, spatial_channels, grid, grid)

        return CongestionOutput(
            heatmap=self.heatmap_head(spatial),
            hotspot=self.hotspot_head(spatial),
            score=self.score_head(spatial),
        )
