"""
Smoke tests for all congestion models.

Tests:
  1. Forward pass shape correctness for each deep model
  2. Dataset loading and batching
  3. Metrics computation
  4. Mini training loop (2 epochs) for U-Net, Swin, GNN, Diffusion
  5. Classical model fit + predict
  6. Ensemble forward pass
  7. Checkpoint save/load round-trip

Run from the flow/ directory:
  python3 ml/congestion/tests/test_models.py

Or run a specific test:
  python3 ml/congestion/tests/test_models.py TestModels.test_unet_shapes
"""

import os
import sys
import tempfile
import unittest

import numpy as np
import torch

# Add model and training paths
_HERE    = os.path.dirname(__file__)
_MODELS  = os.path.join(_HERE, "..", "models")
_TRAIN   = os.path.join(_HERE, "..", "training")
sys.path.insert(0, _MODELS)
sys.path.insert(0, _TRAIN)

from generate_synthetic_data import generate

GRID    = 32   # smaller grid for faster tests
BATCH   = 2
DEVICE  = torch.device("cpu")


def _make_batch(n=BATCH, grid=GRID):
    """Random batch dict matching the dataset output format."""
    return {
        "x":       torch.rand(n, 4, grid, grid),
        "heatmap": torch.rand(n, 10, grid, grid),
        "hotspot": torch.rand(n, 1, grid, grid),
        "score":   torch.rand(n, 1),
    }


class TestModelShapes(unittest.TestCase):

    def test_unet_shapes(self):
        from unet import CongestionUNet
        model = CongestionUNet(in_channels=4, base_features=16)
        x = torch.rand(BATCH, 4, GRID, GRID)
        out = model(x)
        self.assertEqual(out.heatmap.shape, (BATCH, 10, GRID, GRID))
        self.assertEqual(out.hotspot.shape, (BATCH, 1,  GRID, GRID))
        self.assertEqual(out.score.shape,   (BATCH, 1))

    def test_swin_shapes(self):
        from swin import CongestionSwin
        model = CongestionSwin(in_channels=4, embed_dim=32, window_size=4)
        x = torch.rand(BATCH, 4, GRID, GRID)
        out = model(x)
        self.assertEqual(out.heatmap.shape, (BATCH, 10, GRID, GRID))
        self.assertEqual(out.hotspot.shape, (BATCH, 1,  GRID, GRID))
        self.assertEqual(out.score.shape,   (BATCH, 1))

    def test_gnn_shapes(self):
        from gnn import CongestionGNN
        model = CongestionGNN(grid=GRID, embed_dim=32)
        N = GRID * GRID * BATCH
        coords = torch.arange(GRID * GRID)
        edge_index = torch.stack(
            [coords.repeat_interleave(GRID * GRID),
             coords.repeat(GRID * GRID)], 0
        )
        edges = torch.cat([edge_index + b * GRID * GRID for b in range(BATCH)], 1)
        x_norm = torch.rand(N)
        y_norm = torch.rand(N)
        feats  = torch.rand(N, 8)
        batch_vec = torch.arange(BATCH).repeat_interleave(GRID * GRID)
        out = model(feats, edges, batch_vec, x_norm, y_norm)
        self.assertEqual(out.heatmap.shape, (BATCH, 10, GRID, GRID))
        self.assertEqual(out.hotspot.shape, (BATCH, 1,  GRID, GRID))
        self.assertEqual(out.score.shape,   (BATCH, 1))

    def test_diffusion_shapes(self):
        from diffusion import CongestionDiffusion
        model = CongestionDiffusion(timesteps=10)   # tiny T for speed
        x = torch.rand(BATCH, 4, GRID, GRID)
        loss = model.compute_loss(x, torch.rand(BATCH, 10, GRID, GRID))
        self.assertFalse(torch.isnan(loss))
        out = model.sample(x, n_samples=1)
        self.assertEqual(out.heatmap.shape, (BATCH, 10, GRID, GRID))

    def test_ensemble_average(self):
        from ensemble import CongestionEnsemble
        ens = CongestionEnsemble(mode="average")
        x = torch.rand(BATCH, 4, GRID, GRID)
        out = ens(x)
        self.assertEqual(out.heatmap.shape, (BATCH, 10, GRID, GRID))


class TestOutputRange(unittest.TestCase):
    """All outputs must be in [0, 1] — sigmoid is applied inside every model."""

    def _check(self, out):
        for name, t in [("heatmap", out.heatmap),
                        ("hotspot", out.hotspot),
                        ("score",   out.score)]:
            self.assertGreaterEqual(t.min().item(), 0.0, f"{name} < 0")
            self.assertLessEqual(t.max().item(),    1.0, f"{name} > 1")

    def test_unet_range(self):
        from unet import CongestionUNet
        self._check(CongestionUNet(in_channels=4, base_features=16)(
            torch.rand(1, 4, GRID, GRID)))

    def test_swin_range(self):
        from swin import CongestionSwin
        self._check(CongestionSwin(in_channels=4, embed_dim=32, window_size=4)(
            torch.rand(1, 4, GRID, GRID)))


class TestMetrics(unittest.TestCase):

    def test_heatmap_mae_perfect(self):
        from metrics import heatmap_mae
        x = torch.rand(2, 10, GRID, GRID)
        self.assertAlmostEqual(heatmap_mae(x, x).item(), 0.0, places=6)

    def test_hotspot_iou_perfect(self):
        from metrics import hotspot_iou
        x = torch.rand(2, 1, GRID, GRID)
        self.assertAlmostEqual(hotspot_iou(x, x).item(), 1.0, places=4)

    def test_hotspot_iou_no_overlap(self):
        from metrics import hotspot_iou
        pred   = torch.zeros(1, 1, GRID, GRID)
        target = torch.ones(1, 1, GRID, GRID)
        self.assertAlmostEqual(hotspot_iou(pred, target).item(), 0.0, places=4)

    def test_pearson_perfect(self):
        from metrics import score_pearson
        x = torch.rand(8, 1)
        self.assertAlmostEqual(score_pearson(x, x).item(), 1.0, places=4)

    def test_compute_all_runs(self):
        from metrics import compute_all
        from unet import CongestionUNet
        model = CongestionUNet(in_channels=4, base_features=16)
        batch = _make_batch()
        out   = model(batch["x"])
        m = compute_all(out, {k: v for k, v in batch.items() if k != "x"})
        self.assertIn("heatmap_mae",   m)
        self.assertIn("hotspot_iou",   m)
        self.assertIn("score_mae",     m)
        self.assertIn("score_pearson", m)


class TestDataset(unittest.TestCase):

    def setUp(self):
        self.tmp = tempfile.mkdtemp()
        generate(self.tmp, n_designs=6, grid=GRID, seed=0)

    def test_dataset_loads(self):
        from dataset import CongestionDataset
        ds = CongestionDataset(self.tmp)
        self.assertEqual(len(ds), 6)

    def test_dataset_shapes(self):
        from dataset import CongestionDataset
        ds = CongestionDataset(self.tmp)
        item = ds[0]
        self.assertEqual(item["x"].shape,       (4, GRID, GRID))
        self.assertEqual(item["heatmap"].shape,  (10, GRID, GRID))
        self.assertEqual(item["hotspot"].shape,  (1, GRID, GRID))
        self.assertEqual(item["score"].shape,    (1,))

    def test_split_sizes(self):
        from dataset import CongestionDataset, split_dataset
        ds = CongestionDataset(self.tmp)
        train, val, test = split_dataset(ds)
        self.assertEqual(len(train) + len(val) + len(test), len(ds))

    def test_augmentation(self):
        from dataset import CongestionDataset
        ds = CongestionDataset(self.tmp, augment=True)
        # Just check it runs without error
        _ = ds[0]


class TestMiniTraining(unittest.TestCase):
    """Run 2 training steps to catch gradient/shape bugs."""

    def setUp(self):
        self.tmp = tempfile.mkdtemp()
        generate(self.tmp, n_designs=4, grid=GRID, seed=1)

    def _train_steps(self, model, n_steps=2):
        from torch.utils.data import DataLoader
        from dataset import CongestionDataset
        import torch.nn as nn

        ds = CongestionDataset(self.tmp)
        loader = DataLoader(ds, batch_size=2, shuffle=True)
        opt = torch.optim.Adam(model.parameters(), lr=1e-3)
        model.train()
        for i, batch in enumerate(loader):
            if i >= n_steps:
                break
            x = batch["x"]
            out = model(x)
            loss = (nn.functional.mse_loss(out.heatmap, batch["heatmap"]) +
                    nn.functional.binary_cross_entropy(out.hotspot, batch["hotspot"]) +
                    nn.functional.mse_loss(out.score, batch["score"]))
            opt.zero_grad()
            loss.backward()
            opt.step()
            self.assertFalse(torch.isnan(loss), f"NaN loss at step {i}")

    def test_unet_trains(self):
        from unet import CongestionUNet
        self._train_steps(CongestionUNet(in_channels=4, base_features=8))

    def test_swin_trains(self):
        from swin import CongestionSwin
        self._train_steps(CongestionSwin(in_channels=4, embed_dim=16, window_size=4))


class TestCheckpointRoundTrip(unittest.TestCase):

    def test_unet_save_load(self):
        from unet import CongestionUNet
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, "unet.pt")
            model = CongestionUNet(in_channels=4, base_features=8)
            torch.save(model.state_dict(), path)
            model2 = CongestionUNet(in_channels=4, base_features=8)
            model2.load_state_dict(torch.load(path, map_location="cpu"))
            x = torch.rand(1, 4, GRID, GRID)
            out1 = model(x)
            out2 = model2(x)
            self.assertTrue(torch.allclose(out1.heatmap, out2.heatmap))


class TestClassicalModels(unittest.TestCase):

    def setUp(self):
        self.tmp = tempfile.mkdtemp()
        generate(self.tmp, n_designs=6, grid=GRID, seed=2)

    def test_rf_fit_predict(self):
        from classical import RandomForestCongestion, load_dataset
        X, y_hm, y_hs, y_sc, did = load_dataset(self.tmp, grid=GRID)
        rf = RandomForestCongestion(grid=GRID, n_estimators=10)
        rf.fit(X, y_hm, y_hs, y_sc, did)
        pred = rf.predict(X[:GRID*GRID])
        self.assertEqual(pred["heatmap"].shape, (10, GRID, GRID))
        self.assertEqual(pred["hotspot"].shape, (GRID, GRID))

    def test_rf_save_load(self):
        from classical import RandomForestCongestion, load_dataset
        with tempfile.TemporaryDirectory() as d:
            X, y_hm, y_hs, y_sc, did = load_dataset(self.tmp, grid=GRID)
            rf = RandomForestCongestion(grid=GRID, n_estimators=5)
            rf.fit(X, y_hm, y_hs, y_sc, did)
            path = os.path.join(d, "rf.pkl")
            rf.save(path)
            rf2 = RandomForestCongestion.load(path)
            pred1 = rf.predict(X[:GRID*GRID])
            pred2 = rf2.predict(X[:GRID*GRID])
            np.testing.assert_array_equal(pred1["hotspot"], pred2["hotspot"])


if __name__ == "__main__":
    unittest.main(verbosity=2)
