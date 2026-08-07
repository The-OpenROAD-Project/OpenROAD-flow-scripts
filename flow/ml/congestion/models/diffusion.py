"""
Denoising Diffusion Probabilistic Model (DDPM) for congestion heatmap generation.

Conditioned on the 4-channel placement feature grid, the diffusion model learns
to generate realistic congestion heatmaps by iteratively denoising Gaussian noise.

Key advantage over deterministic models: produces a *distribution* of possible
congestion maps — the variance tells you where the model is uncertain.

Architecture:
  Condition encoder (small U-Net) → time embedding → denoising U-Net
  The denoising U-Net takes (noisy_heatmap ‖ condition_features) as input.

Output: CongestionOutput (heatmap only — hotspot and score derived from heatmap)
  For uncertainty: call sample() multiple times and compute std across samples.

Reference: Ho et al. 2020 "Denoising Diffusion Probabilistic Models"
"""

from collections import namedtuple
import math

import torch
import torch.nn as nn
import torch.nn.functional as F

CongestionOutput = namedtuple("CongestionOutput", ["heatmap", "hotspot", "score"])


class _SinusoidalPE(nn.Module):
    """Sinusoidal timestep embedding."""
    def __init__(self, dim: int):
        super().__init__()
        self.dim = dim

    def forward(self, t: torch.Tensor) -> torch.Tensor:
        half = self.dim // 2
        freq = torch.exp(
            -math.log(10000) * torch.arange(half, device=t.device) / (half - 1)
        )
        args = t[:, None].float() * freq[None]
        return torch.cat([args.sin(), args.cos()], dim=-1)


class _ResBlock(nn.Module):
    def __init__(self, in_ch: int, out_ch: int, time_dim: int):
        super().__init__()
        self.conv1 = nn.Conv2d(in_ch, out_ch, 3, padding=1)
        self.conv2 = nn.Conv2d(out_ch, out_ch, 3, padding=1)
        self.time_proj = nn.Linear(time_dim, out_ch)
        self.norm1 = nn.GroupNorm(8, out_ch)
        self.norm2 = nn.GroupNorm(8, out_ch)
        self.skip  = nn.Conv2d(in_ch, out_ch, 1) if in_ch != out_ch else nn.Identity()
        self.act   = nn.SiLU()

    def forward(self, x, t_emb):
        h = self.act(self.norm1(self.conv1(x)))
        h = h + self.time_proj(self.act(t_emb))[:, :, None, None]
        h = self.act(self.norm2(self.conv2(h)))
        return h + self.skip(x)


class _DenoiseUNet(nn.Module):
    """Small U-Net that predicts the noise added at timestep t."""

    def __init__(self, in_ch: int, base: int = 64, time_dim: int = 128):
        super().__init__()
        self.time_mlp = nn.Sequential(
            _SinusoidalPE(base),
            nn.Linear(base, time_dim),
            nn.SiLU(),
            nn.Linear(time_dim, time_dim),
        )

        self.enc1 = _ResBlock(in_ch,      base,     time_dim)
        self.enc2 = _ResBlock(base,       base * 2, time_dim)
        self.enc3 = _ResBlock(base * 2,   base * 4, time_dim)
        self.bot  = _ResBlock(base * 4,   base * 4, time_dim)
        self.dec3 = _ResBlock(base * 8,   base * 2, time_dim)
        self.dec2 = _ResBlock(base * 4,   base,     time_dim)
        self.dec1 = _ResBlock(base * 2,   base,     time_dim)
        self.pool = nn.MaxPool2d(2)
        self.up3  = nn.ConvTranspose2d(base * 4, base * 4, 2, stride=2)
        self.up2  = nn.ConvTranspose2d(base * 2, base * 2, 2, stride=2)
        self.up1  = nn.ConvTranspose2d(base,     base,     2, stride=2)
        self.out  = nn.Conv2d(base, 10, 1)

    def forward(self, x: torch.Tensor, t: torch.Tensor) -> torch.Tensor:
        t_emb = self.time_mlp(t)
        e1 = self.enc1(x,           t_emb)
        e2 = self.enc2(self.pool(e1), t_emb)
        e3 = self.enc3(self.pool(e2), t_emb)
        b  = self.bot(self.pool(e3),  t_emb)
        d3 = self.dec3(torch.cat([self.up3(b),  e3], 1), t_emb)
        d2 = self.dec2(torch.cat([self.up2(d3), e2], 1), t_emb)
        d1 = self.dec1(torch.cat([self.up1(d2), e1], 1), t_emb)
        return self.out(d1)


class CongestionDiffusion(nn.Module):
    """
    DDPM conditioned on placement features.

    Training: call compute_loss(x_feat, x_heatmap)
    Inference: call sample(x_feat, n_samples=1) for point estimate,
               or n_samples > 1 for uncertainty quantification.
    """

    def __init__(self, timesteps: int = 1000, in_channels: int = 4):
        super().__init__()
        self.T = timesteps

        # Denoising network: input = (noisy heatmap [10ch] ‖ condition [4ch]) = 14ch
        self.denoiser = _DenoiseUNet(in_ch=10 + in_channels, base=64)

        # Noise schedule (linear beta)
        betas  = torch.linspace(1e-4, 0.02, timesteps)
        alphas = 1.0 - betas
        alpha_cumprod = torch.cumprod(alphas, dim=0)
        self.register_buffer("betas",       betas)
        self.register_buffer("alphas",      alphas)
        self.register_buffer("alpha_bar",   alpha_cumprod)
        self.register_buffer("sqrt_ab",     alpha_cumprod.sqrt())
        self.register_buffer("sqrt_1m_ab",  (1 - alpha_cumprod).sqrt())

    def _add_noise(self, x0: torch.Tensor, t: torch.Tensor):
        """Forward diffusion: q(x_t | x_0)"""
        eps = torch.randn_like(x0)
        mean = self.sqrt_ab[t, None, None, None] * x0
        std  = self.sqrt_1m_ab[t, None, None, None]
        return mean + std * eps, eps

    def compute_loss(self, x_feat: torch.Tensor,
                     x_heatmap: torch.Tensor) -> torch.Tensor:
        """
        Training loss: predict noise added at random timestep.
        x_feat:    (B, 4, H, W)  placement features (condition)
        x_heatmap: (B, 10, H, W) ground-truth congestion heatmap
        """
        B = x_feat.shape[0]
        t = torch.randint(0, self.T, (B,), device=x_feat.device)
        x_t, eps = self._add_noise(x_heatmap, t)
        inp = torch.cat([x_t, x_feat], dim=1)   # (B, 14, H, W)
        eps_pred = self.denoiser(inp, t)
        return F.mse_loss(eps_pred, eps)

    @torch.no_grad()
    def sample(self, x_feat: torch.Tensor,
               n_samples: int = 1) -> CongestionOutput:
        """
        Reverse diffusion: generate congestion heatmap from noise.
        Returns mean over n_samples; if n_samples > 1, also usable for uncertainty.
        """
        B, _, H, W = x_feat.shape
        device = x_feat.device
        samples = []

        for _ in range(n_samples):
            x = torch.randn(B, 10, H, W, device=device)
            for t_val in reversed(range(self.T)):
                t = torch.full((B,), t_val, device=device, dtype=torch.long)
                inp = torch.cat([x, x_feat], dim=1)
                eps_pred = self.denoiser(inp, t)

                alpha     = self.alphas[t_val]
                alpha_bar = self.alpha_bar[t_val]
                beta      = self.betas[t_val]

                x0_pred = (x - (1 - alpha_bar).sqrt() * eps_pred) / alpha_bar.sqrt()
                x0_pred = x0_pred.clamp(-1, 1)

                if t_val > 0:
                    noise = torch.randn_like(x)
                    x = (alpha.sqrt() * x0_pred +
                         (1 - alpha).sqrt() * noise)
                else:
                    x = x0_pred

            samples.append(x.sigmoid())  # map to [0, 1]

        heatmap = torch.stack(samples, dim=0).mean(0)   # (B, 10, H, W)
        hotspot = (heatmap.max(dim=1, keepdim=True).values > 0.5).float()
        score   = heatmap.mean(dim=(1, 2, 3), keepdim=False).unsqueeze(1)

        return CongestionOutput(heatmap=heatmap, hotspot=hotspot, score=score)

    def forward(self, x: torch.Tensor) -> CongestionOutput:
        """Inference-mode forward — wraps sample() for API compatibility."""
        return self.sample(x, n_samples=1)
