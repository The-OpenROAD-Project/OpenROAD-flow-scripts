"""
GraphSAGE congestion predictor with three output heads.

Node features (8):
  [area_norm, is_macro, is_seq, is_buf, fanin_norm, fanout_norm, x_norm, y_norm]

The GNN produces per-node embeddings which are scattered onto a 2D grid,
then fed to the same spatial heads as the U-Net for a fair comparison.

Output: CongestionOutput namedtuple (same as unet.py)
  .heatmap  (B, 10, H, W)
  .hotspot  (B,  1, H, W)
  .score    (B,  1)
"""

from collections import namedtuple

import torch
import torch.nn as nn
from torch_geometric.nn import SAGEConv, LayerNorm

from heads import HeatmapHead, HotspotHead, ScoreHead

CongestionOutput = namedtuple("CongestionOutput", ["heatmap", "hotspot", "score"])

NODE_FEATURES = 8   # see docstring above
EMBED_DIM     = 64  # node embedding dimension


def _scatter_to_grid(
    node_feats: torch.Tensor,
    x_norm: torch.Tensor,
    y_norm: torch.Tensor,
    batch: torch.Tensor,
    grid: int,
    batch_size: int,
) -> torch.Tensor:
    """
    Scatter node embeddings onto (batch_size, C, grid, grid) by averaging
    all nodes that fall into the same grid cell.
    """
    C = node_feats.shape[1]
    canvas = torch.zeros(batch_size, C, grid, grid,
                         device=node_feats.device, dtype=node_feats.dtype)
    count  = torch.zeros(batch_size, 1, grid, grid,
                         device=node_feats.device, dtype=node_feats.dtype)

    gx = (x_norm * (grid - 1)).long().clamp(0, grid - 1)
    gy = (y_norm * (grid - 1)).long().clamp(0, grid - 1)

    for n in range(node_feats.shape[0]):
        b  = batch[n].item()
        ix = gx[n].item()
        iy = gy[n].item()
        canvas[b, :, iy, ix] += node_feats[n]
        count[b,  0, iy, ix] += 1.0

    canvas = canvas / (count + 1e-9)
    return canvas


class CongestionGNN(nn.Module):
    """
    3-layer GraphSAGE encoder → scatter to spatial grid → shared heads.
    """

    def __init__(self, grid: int = 64, embed_dim: int = EMBED_DIM):
        super().__init__()
        self.grid = grid

        self.proj = nn.Linear(NODE_FEATURES, embed_dim)

        self.sage1 = SAGEConv(embed_dim, embed_dim)
        self.norm1 = LayerNorm(embed_dim)
        self.sage2 = SAGEConv(embed_dim, embed_dim)
        self.norm2 = LayerNorm(embed_dim)
        self.sage3 = SAGEConv(embed_dim, embed_dim)
        self.norm3 = LayerNorm(embed_dim)

        self.act = nn.ReLU(inplace=True)

        # Project from node embed_dim to a spatial channel count
        # that matches the head input expectations
        self.to_spatial = nn.Linear(embed_dim, 32)

        self.heatmap_head = HeatmapHead(32, num_layers=10)
        self.hotspot_head = HotspotHead(32)
        self.score_head   = ScoreHead(32)

    def forward(
        self,
        x: torch.Tensor,         # (N, 8)  node features
        edge_index: torch.Tensor, # (2, E)
        batch: torch.Tensor,      # (N,)    batch assignment
        x_norm: torch.Tensor,     # (N,)    normalised x position [0,1]
        y_norm: torch.Tensor,     # (N,)    normalised y position [0,1]
    ) -> CongestionOutput:
        batch_size = int(batch.max().item()) + 1

        h = self.act(self.proj(x))

        h = self.act(self.norm1(self.sage1(h, edge_index)))
        h = self.act(self.norm2(self.sage2(h, edge_index)))
        h = self.act(self.norm3(self.sage3(h, edge_index)))

        # Project to spatial channels before scattering
        h_spatial = self.act(self.to_spatial(h))  # (N, 32)

        grid_feats = _scatter_to_grid(
            h_spatial, x_norm, y_norm, batch, self.grid, batch_size
        )  # (B, 32, grid, grid)

        return CongestionOutput(
            heatmap=self.heatmap_head(grid_feats),
            hotspot=self.hotspot_head(grid_feats),
            score=self.score_head(grid_feats),
        )
