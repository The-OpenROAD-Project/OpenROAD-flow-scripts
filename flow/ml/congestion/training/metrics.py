"""
Evaluation metrics for the three congestion outputs.

  heatmap_mae   — mean absolute error on per-layer congestion values
  hotspot_iou   — intersection-over-union on the binary hotspot mask
  score_mae     — absolute error on the scalar design-level score
  score_pearson — Pearson correlation between predicted and true scores
"""

import torch
import torch.nn.functional as F


def heatmap_mae(pred: torch.Tensor, target: torch.Tensor) -> torch.Tensor:
    """MAE over (B, 10, H, W) tensors."""
    return F.l1_loss(pred, target)


def hotspot_iou(pred: torch.Tensor, target: torch.Tensor,
                threshold: float = 0.5) -> torch.Tensor:
    """
    IoU between binarised predicted hotspot and ground-truth hotspot.
    pred, target: (B, 1, H, W) float in [0, 1]
    """
    pred_bin   = (pred   > threshold).float()
    target_bin = (target > threshold).float()

    intersection = (pred_bin * target_bin).sum(dim=(1, 2, 3))
    union        = (pred_bin + target_bin).clamp(0, 1).sum(dim=(1, 2, 3))
    iou          = intersection / (union + 1e-9)
    return iou.mean()


def score_mae(pred: torch.Tensor, target: torch.Tensor) -> torch.Tensor:
    """MAE on scalar congestion scores. pred, target: (B, 1)"""
    return F.l1_loss(pred, target)


def score_pearson(pred: torch.Tensor, target: torch.Tensor) -> torch.Tensor:
    """Pearson correlation coefficient between predicted and true scores."""
    p = pred.squeeze(1)
    t = target.squeeze(1)
    if p.numel() < 2:
        return torch.tensor(0.0, device=pred.device)
    vp = p - p.mean()
    vt = t - t.mean()
    r = (vp * vt).sum() / (vp.norm() * vt.norm() + 1e-9)
    return r


def compute_all(pred_out, batch) -> dict:
    """
    Compute all metrics given a CongestionOutput and a data batch dict.
    Returns a plain dict of float values.
    """
    return {
        "heatmap_mae":   heatmap_mae(pred_out.heatmap, batch["heatmap"]).item(),
        "hotspot_iou":   hotspot_iou(pred_out.hotspot, batch["hotspot"]).item(),
        "score_mae":     score_mae(pred_out.score,     batch["score"]).item(),
        "score_pearson": score_pearson(pred_out.score, batch["score"]).item(),
    }
