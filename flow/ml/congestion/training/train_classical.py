"""
Train Random Forest and XGBoost congestion baselines.

Usage:
  cd flow
  python3 ml/congestion/training/train_classical.py \
      --data-dir ml/congestion/data \
      --checkpoint-dir ml/congestion/checkpoints
"""

import argparse
import os
import sys

import numpy as np
from sklearn.model_selection import GroupShuffleSplit

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "models"))

from classical import RandomForestCongestion, XGBoostCongestion, load_dataset


def train(args):
    print("Loading dataset...")
    X, y_heatmap, y_hotspot, y_score, design_ids = load_dataset(args.data_dir)
    print(f"Cells: {X.shape[0]}  Designs: {len(y_score)}")

    # Split by design (not by cell) to avoid data leakage
    gss = GroupShuffleSplit(n_splits=1, test_size=0.2, random_state=42)
    train_idx, val_idx = next(gss.split(X, groups=design_ids))

    X_train,    X_val    = X[train_idx],          X[val_idx]
    hmap_train, hmap_val = y_heatmap[train_idx],  y_heatmap[val_idx]
    hot_train,  hot_val  = y_hotspot[train_idx],  y_hotspot[val_idx]
    did_train,  did_val  = design_ids[train_idx], design_ids[val_idx]

    # Remap design ids to contiguous range for train/val subsets
    u, inv = np.unique(did_train, return_inverse=True)
    score_train = y_score[u]
    did_train_r = inv

    u_v, inv_v = np.unique(did_val, return_inverse=True)
    score_val  = y_score[u_v]

    os.makedirs(args.checkpoint_dir, exist_ok=True)

    # --- Random Forest ---
    print("\n=== Random Forest ===")
    rf = RandomForestCongestion(n_estimators=200)
    rf.fit(X_train, hmap_train, hot_train, score_train, did_train_r)

    val_pred = rf.predict(X_val)
    _print_metrics("RF", val_pred, hmap_val, hot_val, score_val)

    rf_path = os.path.join(args.checkpoint_dir, "rf.pkl")
    rf.save(rf_path)
    print(f"Saved -> {rf_path}")

    # --- XGBoost ---
    print("\n=== XGBoost ===")
    try:
        xgb = XGBoostCongestion(n_estimators=300)
        xgb.fit(X_train, hmap_train, hot_train, score_train, did_train_r)

        val_pred = xgb.predict(X_val)
        _print_metrics("XGB", val_pred, hmap_val, hot_val, score_val)

        xgb_path = os.path.join(args.checkpoint_dir, "xgb.pkl")
        xgb.save(xgb_path)
        print(f"Saved -> {xgb_path}")
    except ImportError:
        print("xgboost not installed — skipping. Install with: pip install xgboost")


def _print_metrics(name, pred, y_heatmap, y_hotspot, y_score):
    from sklearn.metrics import mean_absolute_error, jaccard_score
    from scipy.stats import pearsonr

    hmap_flat  = pred["heatmap"].reshape(10, -1).T
    hmap_mae   = mean_absolute_error(y_heatmap, hmap_flat)

    hot_flat   = pred["hotspot"].flatten()
    hot_bin    = (hot_flat > 0.5).astype(int)
    hot_iou    = jaccard_score(y_hotspot.astype(int), hot_bin, zero_division=0)

    score_mae  = abs(pred["score"] - y_score.mean())
    r, _       = pearsonr([pred["score"]] * len(y_score), y_score) if len(y_score) > 1 \
                 else (0.0, 1.0)

    print(f"  [{name}] heatmap_mae={hmap_mae:.4f}  hotspot_iou={hot_iou:.4f}  "
          f"score_mae={score_mae:.4f}  pearson={r:.4f}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--data-dir",       default="ml/congestion/data")
    ap.add_argument("--checkpoint-dir", default="ml/congestion/checkpoints")
    train(ap.parse_args())


if __name__ == "__main__":
    main()
