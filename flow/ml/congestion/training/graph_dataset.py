"""
Dataset for pre-placement congestion prediction.

Expects pairs of files in the same directory:
  <label>_graph.npz    — netlist graph from extract_netlist_features.py
  <label>_labels.npz   — spatial congestion labels from extract_labels.py

graph.npz keys:
  node_features  (N, 6)   float32  [area_norm, is_macro, is_seq, is_buf, fanin_norm, fanout_norm]
  edge_index     (2, E)   int64    COO edge list
  edge_weight    (E,)     float32  (stored but not used by current model)

labels.npz keys:
  heatmap  (10, grid, grid)  float32  per-layer overflow fraction [0, 1]
  hotspot  (grid, grid)      uint8    binary congestion mask
  score    scalar            float32  mean overflow
"""

import os
from pathlib import Path

import numpy as np
import torch
from torch.utils.data import Dataset, random_split


class GraphCongestionDataset(Dataset):
    """
    Loads (graph, congestion_labels) pairs for pre-placement GNN training.

    Each item is a dict:
      node_features  (N, 6)   torch.float32
      edge_index     (2, E)   torch.long
      batch          (N,)     torch.long    — all zeros (single graph per item;
                                              collation handled by collate_fn)
      heatmap        (10, G, G) torch.float32
      hotspot        (1, G, G)  torch.float32
      score          (1,)      torch.float32
    """

    def __init__(self, data_dir: str, grid: int = 64):
        self.grid = grid
        self.samples = []  # list of (graph_path, labels_path)

        data_dir = Path(data_dir)
        for graph_file in sorted(data_dir.glob("*_graph.npz")):
            # Derive the base label name: strip "_graph" suffix
            base = graph_file.stem[: -len("_graph")]
            labels_file = data_dir / f"{base}_labels.npz"
            if labels_file.exists():
                self.samples.append((graph_file, labels_file))

        if not self.samples:
            raise RuntimeError(
                f"No (*_graph.npz, *_labels.npz) pairs found in {data_dir}. "
                "Run extract_netlist_features.py and extract_labels.py first."
            )

    def __len__(self):
        return len(self.samples)

    def __getitem__(self, idx):
        graph_path, labels_path = self.samples[idx]

        g = np.load(graph_path, allow_pickle=False)
        node_features = torch.from_numpy(g["node_features"])   # (N, 6)
        edge_index    = torch.from_numpy(g["edge_index"])      # (2, E)
        N = node_features.shape[0]

        l = np.load(labels_path)
        heatmap = torch.from_numpy(l["heatmap"].astype(np.float32))  # (10, G, G)
        hotspot = torch.from_numpy(l["hotspot"].astype(np.float32)).unsqueeze(0)  # (1, G, G)
        score   = torch.tensor([float(l["score"])], dtype=torch.float32)

        return {
            "node_features": node_features,
            "edge_index":    edge_index,
            "batch":         torch.zeros(N, dtype=torch.long),
            "heatmap":       heatmap,
            "hotspot":       hotspot,
            "score":         score,
        }


def graph_collate(items: list) -> dict:
    """
    Collate a list of single-graph dicts into a batched dict.

    Offsets edge_index node indices per graph so all graphs can share
    a single edge_index tensor, and builds the batch assignment vector.
    This is the standard PyG mini-batch construction done manually so
    we don't need a full PyG DataLoader.
    """
    node_feats_list = []
    edge_index_list = []
    batch_list      = []
    heatmaps        = []
    hotspots        = []
    scores          = []

    node_offset = 0
    for b_idx, item in enumerate(items):
        N = item["node_features"].shape[0]
        node_feats_list.append(item["node_features"])
        edge_index_list.append(item["edge_index"] + node_offset)
        batch_list.append(torch.full((N,), b_idx, dtype=torch.long))
        heatmaps.append(item["heatmap"])
        hotspots.append(item["hotspot"])
        scores.append(item["score"])
        node_offset += N

    return {
        "node_features": torch.cat(node_feats_list, dim=0),
        "edge_index":    torch.cat(edge_index_list, dim=1),
        "batch":         torch.cat(batch_list,      dim=0),
        "heatmap":       torch.stack(heatmaps),
        "hotspot":       torch.stack(hotspots),
        "score":         torch.stack(scores),
    }


def split_graph_dataset(
    dataset: GraphCongestionDataset,
    train_frac: float = 0.7,
    val_frac:   float = 0.15,
    seed: int = 42,
) -> tuple:
    """Split into (train, val, test) subsets."""
    n     = len(dataset)
    n_tr  = max(1, int(n * train_frac))
    n_val = max(1, int(n * val_frac))
    n_te  = max(0, n - n_tr - n_val)
    # Ensure sizes sum to n
    n_tr = n - n_val - n_te
    return random_split(
        dataset, [n_tr, n_val, n_te],
        generator=torch.Generator().manual_seed(seed),
    )
