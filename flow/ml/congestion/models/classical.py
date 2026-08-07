"""
Classical ML baselines: Random Forest and XGBoost congestion predictors.

These operate on flattened per-cell feature vectors rather than 2D grids.
They predict all three outputs (heatmap, hotspot, score) but as numpy arrays,
not PyTorch tensors, so they have their own train/predict interface.

The heatmap and hotspot are predicted per grid cell independently;
the score is predicted as a single value from global aggregated features.

Usage:
  from classical import RandomForestCongestion, XGBoostCongestion
  model = XGBoostCongestion(grid=64)
  model.fit(X_train, y_heatmap_train, y_hotspot_train, y_score_train)
  out = model.predict(X_test)
"""

import numpy as np


def _flatten_features(features_npz: dict, grid: int = 64) -> np.ndarray:
    """
    Convert a features .npz dict into a flat per-cell feature matrix.
    Returns (grid*grid, n_features) array.
    Each row is one grid cell; columns are the 4 channel values + positional coords.
    """
    cell   = features_npz["cell_density"].flatten()
    macro  = features_npz["macro_density"].flatten()
    pin    = features_npz["pin_density"].flatten()
    fanout = features_npz["fanout_density"].flatten()

    ys = np.arange(grid) / (grid - 1)
    xs = np.arange(grid) / (grid - 1)
    yy, xx = np.meshgrid(ys, xs, indexing="ij")
    y_pos = yy.flatten()
    x_pos = xx.flatten()

    return np.stack([cell, macro, pin, fanout, x_pos, y_pos], axis=1)


def load_dataset(data_dir: str, grid: int = 64):
    """
    Load all paired .npz files and return flat arrays ready for classical ML.

    Returns:
      X            (N * grid*grid, 6)  per-cell features
      y_heatmap    (N * grid*grid, 10) per-cell per-layer congestion
      y_hotspot    (N * grid*grid,)    per-cell binary hotspot
      y_score      (N,)                per-design score
      design_ids   (N * grid*grid,)    which design each cell belongs to
    """
    import glob
    import os
    import numpy as np

    feature_files = sorted(glob.glob(os.path.join(data_dir, "*_features.npz")))
    X_list, hmap_list, hot_list, score_list, did_list = [], [], [], [], []

    for i, feat_path in enumerate(feature_files):
        tag = os.path.basename(feat_path).replace("_features.npz", "")
        label_path = os.path.join(data_dir, f"{tag}_labels.npz")
        if not os.path.exists(label_path):
            continue

        feat  = np.load(feat_path)
        label = np.load(label_path)

        x_flat = _flatten_features(feat, grid)        # (grid^2, 6)
        hmap   = label["heatmap"].reshape(10, -1).T   # (grid^2, 10)
        hot    = label["hotspot"].flatten()            # (grid^2,)
        score  = float(label["score"])

        X_list.append(x_flat)
        hmap_list.append(hmap)
        hot_list.append(hot)
        score_list.append(score)
        did_list.append(np.full(len(x_flat), i))

    if not X_list:
        raise FileNotFoundError(f"No paired .npz files in {data_dir}")

    return (
        np.vstack(X_list),
        np.vstack(hmap_list),
        np.concatenate(hot_list),
        np.array(score_list),
        np.concatenate(did_list),
    )


class RandomForestCongestion:
    """Random Forest baseline — one RF per output type."""

    def __init__(self, grid: int = 64, n_estimators: int = 200, n_jobs: int = -1):
        from sklearn.ensemble import RandomForestRegressor, RandomForestClassifier
        self.grid = grid
        self.rf_heatmap = [
            RandomForestRegressor(n_estimators=n_estimators, n_jobs=n_jobs,
                                  random_state=42)
            for _ in range(10)
        ]
        self.rf_hotspot = RandomForestClassifier(n_estimators=n_estimators,
                                                 n_jobs=n_jobs, random_state=42)
        self.rf_score   = RandomForestRegressor(n_estimators=n_estimators,
                                                n_jobs=n_jobs, random_state=42)

    def fit(self, X, y_heatmap, y_hotspot, y_score, design_ids):
        print("Fitting Random Forest heatmap (10 layers)...")
        for i in range(10):
            self.rf_heatmap[i].fit(X, y_heatmap[:, i])
            print(f"  layer {i+1}/10 done")

        print("Fitting Random Forest hotspot...")
        self.rf_hotspot.fit(X, y_hotspot)

        print("Fitting Random Forest score (design-level)...")
        # Score model uses per-design aggregated features
        n_designs = int(design_ids.max()) + 1
        X_design  = np.array([X[design_ids == d].mean(0) for d in range(n_designs)])
        self.rf_score.fit(X_design, y_score)
        print("Done.")

    def predict(self, X, design_id: int = 0) -> dict:
        heatmap = np.stack(
            [self.rf_heatmap[i].predict(X) for i in range(10)], axis=1
        )  # (N, 10)
        heatmap = heatmap.T.reshape(10, self.grid, self.grid)

        hotspot_flat = self.rf_hotspot.predict(X)
        hotspot = hotspot_flat.reshape(self.grid, self.grid)

        X_design = X.mean(0, keepdims=True)
        score = float(self.rf_score.predict(X_design)[0])

        return {"heatmap": heatmap, "hotspot": hotspot, "score": score}

    def save(self, path: str):
        import pickle
        with open(path, "wb") as f:
            pickle.dump(self, f)

    @staticmethod
    def load(path: str):
        import pickle
        with open(path, "rb") as f:
            return pickle.load(f)


class XGBoostCongestion:
    """XGBoost baseline — gradient-boosted trees per output."""

    def __init__(self, grid: int = 64, n_estimators: int = 300,
                 learning_rate: float = 0.05, max_depth: int = 6):
        self.grid          = grid
        self.n_estimators  = n_estimators
        self.learning_rate = learning_rate
        self.max_depth     = max_depth
        self.xgb_heatmap   = []
        self.xgb_hotspot   = None
        self.xgb_score     = None

    def _make_reg(self):
        from xgboost import XGBRegressor
        return XGBRegressor(
            n_estimators=self.n_estimators,
            learning_rate=self.learning_rate,
            max_depth=self.max_depth,
            n_jobs=-1,
            random_state=42,
            tree_method="hist",
        )

    def _make_cls(self):
        from xgboost import XGBClassifier
        return XGBClassifier(
            n_estimators=self.n_estimators,
            learning_rate=self.learning_rate,
            max_depth=self.max_depth,
            n_jobs=-1,
            random_state=42,
            tree_method="hist",
            use_label_encoder=False,
            eval_metric="logloss",
        )

    def fit(self, X, y_heatmap, y_hotspot, y_score, design_ids):
        print("Fitting XGBoost heatmap (10 layers)...")
        self.xgb_heatmap = []
        for i in range(10):
            m = self._make_reg()
            m.fit(X, y_heatmap[:, i])
            self.xgb_heatmap.append(m)
            print(f"  layer {i+1}/10 done")

        print("Fitting XGBoost hotspot...")
        self.xgb_hotspot = self._make_cls()
        self.xgb_hotspot.fit(X, y_hotspot.astype(int))

        print("Fitting XGBoost score (design-level)...")
        n_designs = int(design_ids.max()) + 1
        X_design  = np.array([X[design_ids == d].mean(0) for d in range(n_designs)])
        self.xgb_score = self._make_reg()
        self.xgb_score.fit(X_design, y_score)
        print("Done.")

    def predict(self, X) -> dict:
        heatmap = np.stack(
            [m.predict(X) for m in self.xgb_heatmap], axis=1
        ).T.reshape(10, self.grid, self.grid)

        hotspot = self.xgb_hotspot.predict(X).reshape(self.grid, self.grid)

        X_design = X.mean(0, keepdims=True)
        score = float(self.xgb_score.predict(X_design)[0])

        return {"heatmap": heatmap, "hotspot": hotspot, "score": score}

    def save(self, path: str):
        import pickle
        with open(path, "wb") as f:
            pickle.dump(self, f)

    @staticmethod
    def load(path: str):
        import pickle
        with open(path, "rb") as f:
            return pickle.load(f)
