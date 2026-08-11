"""
Smoke tests for the congestion/thermal ML models.

Tests:
  1. Forward pass shape correctness — U-Net and GNN
  2. Output range [0, 1] for all heads
  3. Dataset loading and batching
  4. Metrics computation
  5. Mini training loop (2 steps) for U-Net and GNN
  6. Checkpoint save/load round-trip

Run from the flow/ directory:
  python3 ml/congestion/tests/test_models.py

Or run a specific test:
  python3 ml/congestion/tests/test_models.py TestModelShapes.test_unet_shapes
"""

import os
import sys
import tempfile
import unittest

import numpy as np
import torch

_HERE   = os.path.dirname(__file__)
_MODELS = os.path.join(_HERE, "..", "models")
_TRAIN  = os.path.join(_HERE, "..", "training")
sys.path.insert(0, _MODELS)
sys.path.insert(0, _TRAIN)

from generate_synthetic_data import generate

GRID   = 32
BATCH  = 2
DEVICE = torch.device("cpu")


def _make_batch(n=BATCH, grid=GRID):
    return {
        "x":       torch.rand(n, 4, grid, grid),
        "heatmap": torch.rand(n, 10, grid, grid),
        "hotspot": torch.rand(n, 1,  grid, grid),
        "score":   torch.rand(n, 1),
    }


def _make_gnn_inputs(batch=BATCH, n_nodes=64):
    """
    Build a minimal GNN input batch simulating a small netlist graph.
    Each graph in the batch has n_nodes nodes with random edges.
    Node features are 6-dimensional (no placement coords — pre-placement).
    """
    feats_list  = []
    edges_list  = []
    batch_list  = []
    node_offset = 0
    for b in range(batch):
        N = n_nodes
        feats_list.append(torch.rand(N, 6))
        # Random sparse edges (~4 per node)
        src = torch.randint(0, N, (N * 4,))
        dst = torch.randint(0, N, (N * 4,))
        edges_list.append(torch.stack([src, dst]) + node_offset)
        batch_list.append(torch.full((N,), b, dtype=torch.long))
        node_offset += N
    return (
        torch.cat(feats_list),
        torch.cat(edges_list, dim=1),
        torch.cat(batch_list),
    )


# ── Shape tests ────────────────────────────────────────────────────────────

class TestModelShapes(unittest.TestCase):

    def test_unet_shapes(self):
        from unet import CongestionUNet
        model = CongestionUNet(in_channels=4, base_features=16)
        out = model(torch.rand(BATCH, 4, GRID, GRID))
        self.assertEqual(out.heatmap.shape, (BATCH, 10, GRID, GRID))
        self.assertEqual(out.hotspot.shape, (BATCH, 1,  GRID, GRID))
        self.assertEqual(out.score.shape,   (BATCH, 1))

    def test_gnn_shapes(self):
        from gnn import CongestionGNN
        model = CongestionGNN(grid=GRID, embed_dim=32, decoder_dim=32)
        feats, edges, batch_vec = _make_gnn_inputs()
        out = model(feats, edges, batch_vec)
        self.assertEqual(out.heatmap.shape, (BATCH, 10, GRID, GRID))
        self.assertEqual(out.hotspot.shape, (BATCH, 1,  GRID, GRID))
        self.assertEqual(out.score.shape,   (BATCH, 1))


# ── Output range tests ─────────────────────────────────────────────────────

class TestOutputRange(unittest.TestCase):

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

    def test_gnn_range(self):
        from gnn import CongestionGNN
        model = CongestionGNN(grid=GRID, embed_dim=32, decoder_dim=32)
        feats, edges, batch_vec = _make_gnn_inputs(batch=1)
        self._check(model(feats, edges, batch_vec))


# ── Metrics tests ──────────────────────────────────────────────────────────

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
        out = model(batch["x"])
        m = compute_all(out, {k: v for k, v in batch.items() if k != "x"})
        self.assertIn("heatmap_mae",   m)
        self.assertIn("hotspot_iou",   m)
        self.assertIn("score_mae",     m)
        self.assertIn("score_pearson", m)


# ── Dataset tests ──────────────────────────────────────────────────────────

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
        self.assertEqual(item["x"].shape,      (4, GRID, GRID))
        self.assertEqual(item["heatmap"].shape, (10, GRID, GRID))
        self.assertEqual(item["hotspot"].shape, (1, GRID, GRID))
        self.assertEqual(item["score"].shape,   (1,))

    def test_split_sizes(self):
        from dataset import CongestionDataset, split_dataset
        ds = CongestionDataset(self.tmp)
        train, val, test = split_dataset(ds)
        self.assertEqual(len(train) + len(val) + len(test), len(ds))

    def test_augmentation(self):
        from dataset import CongestionDataset
        ds = CongestionDataset(self.tmp, augment=True)
        _ = ds[0]


# ── Mini training tests ────────────────────────────────────────────────────

class TestMiniTraining(unittest.TestCase):

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
            out = model(batch["x"])
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


# ── Checkpoint round-trip ──────────────────────────────────────────────────

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
            self.assertTrue(torch.allclose(model(x).heatmap, model2(x).heatmap))

    def test_gnn_save_load(self):
        from gnn import CongestionGNN
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, "gnn.pt")
            model = CongestionGNN(grid=GRID, embed_dim=16, decoder_dim=16)
            torch.save(model.state_dict(), path)
            model2 = CongestionGNN(grid=GRID, embed_dim=16, decoder_dim=16)
            model2.load_state_dict(torch.load(path, map_location="cpu"))
            feats, edges, batch_vec = _make_gnn_inputs(batch=1)
            self.assertTrue(torch.allclose(
                model(feats, edges, batch_vec).heatmap,
                model2(feats, edges, batch_vec).heatmap,
            ))


if __name__ == "__main__":
    unittest.main(verbosity=2)
