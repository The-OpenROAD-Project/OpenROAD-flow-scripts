"""
Swin Transformer congestion predictor with three output heads.

Uses windowed self-attention to capture both local and long-range spatial
dependencies — addresses the main weakness of the U-Net (purely local convolutions).

Input:  (B, 4, H, W)  — same 4-channel grid as U-Net
Output: CongestionOutput namedtuple
  .heatmap  (B, 10, H, W)
  .hotspot  (B,  1, H, W)
  .score    (B,  1)

Architecture:
  Patch embed → 4 Swin stages (window attention + shifted window attention)
  → upsample back to full resolution → shared heads
"""

from collections import namedtuple
import math

import torch
import torch.nn as nn
import torch.nn.functional as F

from heads import HeatmapHead, HotspotHead, ScoreHead

CongestionOutput = namedtuple("CongestionOutput", ["heatmap", "hotspot", "score"])


def _window_partition(x: torch.Tensor, window_size: int):
    """(B, H, W, C) → (num_windows*B, window_size, window_size, C)"""
    B, H, W, C = x.shape
    x = x.view(B, H // window_size, window_size, W // window_size, window_size, C)
    return x.permute(0, 1, 3, 2, 4, 5).contiguous().view(-1, window_size, window_size, C)


def _window_reverse(windows: torch.Tensor, window_size: int, H: int, W: int):
    """(num_windows*B, window_size, window_size, C) → (B, H, W, C)"""
    B = int(windows.shape[0] / (H * W / window_size / window_size))
    x = windows.view(B, H // window_size, W // window_size, window_size, window_size, -1)
    return x.permute(0, 1, 3, 2, 4, 5).contiguous().view(B, H, W, -1)


class _WindowAttention(nn.Module):
    def __init__(self, dim: int, window_size: int, num_heads: int):
        super().__init__()
        self.window_size = window_size
        self.num_heads   = num_heads
        self.scale       = (dim // num_heads) ** -0.5

        self.qkv  = nn.Linear(dim, dim * 3, bias=False)
        self.proj = nn.Linear(dim, dim)

        # Relative position bias table
        self.rel_pos_bias = nn.Embedding(
            (2 * window_size - 1) ** 2, num_heads
        )
        coords = torch.arange(window_size)
        grid   = torch.stack(torch.meshgrid(coords, coords, indexing="ij"))
        flat   = grid.flatten(1)
        rel    = flat[:, :, None] - flat[:, None, :]
        rel    = rel.permute(1, 2, 0).contiguous()
        rel[:, :, 0] += window_size - 1
        rel[:, :, 1] += window_size - 1
        rel[:, :, 0] *= 2 * window_size - 1
        self.register_buffer("rel_index", rel.sum(-1))

    def forward(self, x: torch.Tensor, mask=None) -> torch.Tensor:
        B_, N, C = x.shape
        qkv = self.qkv(x).reshape(B_, N, 3, self.num_heads, C // self.num_heads)
        q, k, v = qkv.permute(2, 0, 3, 1, 4).unbind(0)
        attn = (q @ k.transpose(-2, -1)) * self.scale
        attn = attn + self.rel_pos_bias(self.rel_index.view(-1)).view(
            self.window_size ** 2, self.window_size ** 2, -1
        ).permute(2, 0, 1).unsqueeze(0)
        if mask is not None:
            attn = attn.view(B_ // mask.shape[0], mask.shape[0], self.num_heads,
                             N, N) + mask.unsqueeze(1).unsqueeze(0)
            attn = attn.view(-1, self.num_heads, N, N)
        attn = attn.softmax(dim=-1)
        x = (attn @ v).transpose(1, 2).reshape(B_, N, C)
        return self.proj(x)


class _SwinBlock(nn.Module):
    def __init__(self, dim: int, num_heads: int, window_size: int, shift: bool):
        super().__init__()
        self.shift       = shift
        self.window_size = window_size
        self.norm1 = nn.LayerNorm(dim)
        self.norm2 = nn.LayerNorm(dim)
        self.attn  = _WindowAttention(dim, window_size, num_heads)
        self.mlp   = nn.Sequential(
            nn.Linear(dim, dim * 4),
            nn.GELU(),
            nn.Linear(dim * 4, dim),
        )

    def forward(self, x: torch.Tensor, H: int, W: int, attn_mask=None):
        B, L, C = x.shape
        shortcut = x
        x = self.norm1(x).view(B, H, W, C)

        if self.shift:
            shift = self.window_size // 2
            x = torch.roll(x, shifts=(-shift, -shift), dims=(1, 2))

        x_win = _window_partition(x, self.window_size)
        x_win = x_win.view(-1, self.window_size ** 2, C)
        x_win = self.attn(x_win, mask=attn_mask)
        x_win = x_win.view(-1, self.window_size, self.window_size, C)
        x = _window_reverse(x_win, self.window_size, H, W)

        if self.shift:
            x = torch.roll(x, shifts=(shift, shift), dims=(1, 2))

        x = x.view(B, L, C)
        x = shortcut + x
        x = x + self.mlp(self.norm2(x))
        return x


class _PatchMerge(nn.Module):
    """Downsample spatial resolution 2× and double channels."""
    def __init__(self, dim: int):
        super().__init__()
        self.norm = nn.LayerNorm(4 * dim)
        self.reduction = nn.Linear(4 * dim, 2 * dim, bias=False)

    def forward(self, x: torch.Tensor, H: int, W: int):
        B, L, C = x.shape
        x = x.view(B, H, W, C)
        x0 = x[:, 0::2, 0::2, :]
        x1 = x[:, 1::2, 0::2, :]
        x2 = x[:, 0::2, 1::2, :]
        x3 = x[:, 1::2, 1::2, :]
        return self.reduction(self.norm(torch.cat([x0, x1, x2, x3], dim=-1)
                                       .view(B, -1, 4 * C)))


class CongestionSwin(nn.Module):
    """
    Tiny Swin Transformer for 64×64 congestion grids.
    embed_dim=64, depths=[2,2,6,2], num_heads=[2,4,8,16], window_size=4
    """

    def __init__(self, in_channels: int = 4, embed_dim: int = 64,
                 window_size: int = 4):
        super().__init__()
        self.window_size = window_size

        # Patch embedding: 1×1 conv treats each pixel as a patch
        self.patch_embed = nn.Sequential(
            nn.Conv2d(in_channels, embed_dim, 3, padding=1),
            nn.LayerNorm([embed_dim, 64, 64]),  # spatial LN before flattening
        )

        depths    = [2, 2, 6, 2]
        num_heads = [2, 4, 8, 16]
        dims      = [embed_dim * (2 ** i) for i in range(4)]

        self.stages  = nn.ModuleList()
        self.merges  = nn.ModuleList()
        for i, (d, nh) in enumerate(zip(depths, num_heads)):
            stage = nn.ModuleList([
                _SwinBlock(dims[i], nh, window_size, shift=(j % 2 == 1))
                for j in range(d)
            ])
            self.stages.append(stage)
            if i < 3:
                self.merges.append(_PatchMerge(dims[i]))

        # Decoder: upsample back to full resolution with skip-free bilinear upsampling
        decoder_dim = embed_dim
        self.decoder = nn.Sequential(
            nn.Conv2d(dims[-1], decoder_dim * 4, 1),
            nn.PixelShuffle(2),           # 8×8 → 16×16
            nn.ReLU(inplace=True),
            nn.Conv2d(decoder_dim, decoder_dim * 4, 1),
            nn.PixelShuffle(2),           # 16×16 → 32×32
            nn.ReLU(inplace=True),
            nn.Conv2d(decoder_dim, decoder_dim * 4, 1),
            nn.PixelShuffle(2),           # 32×32 → 64×64
            nn.ReLU(inplace=True),
        )

        self.heatmap_head = HeatmapHead(decoder_dim, num_layers=10)
        self.hotspot_head = HotspotHead(decoder_dim)
        self.score_head   = ScoreHead(decoder_dim)

    def forward(self, x: torch.Tensor) -> CongestionOutput:
        B = x.shape[0]

        # Patch embed: (B, embed_dim, H, W)
        feat = self.patch_embed(x)
        H, W = feat.shape[2], feat.shape[3]

        # Flatten to sequence: (B, H*W, C)
        feat = feat.flatten(2).transpose(1, 2)

        cur_H, cur_W = H, W
        for i, stage in enumerate(self.stages):
            for block in stage:
                feat = block(feat, cur_H, cur_W)
            if i < len(self.merges):
                feat = self.merges[i](feat, cur_H, cur_W)
                cur_H, cur_W = cur_H // 2, cur_W // 2

        # Reshape back to spatial: (B, C, H', W')
        C = feat.shape[-1]
        feat = feat.view(B, cur_H, cur_W, C).permute(0, 3, 1, 2)

        # Decode back to full resolution
        decoded = self.decoder(feat)  # (B, embed_dim, H, W)

        return CongestionOutput(
            heatmap=self.heatmap_head(decoded),
            hotspot=self.hotspot_head(decoded),
            score=self.score_head(decoded),
        )
