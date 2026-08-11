"""
Extract pre-placement netlist graph features from a post-synthesis ODB.

Runs after synthesis (1_synth.odb exists) but before placement — no physical
coordinates are used. Produces a graph.npz that GraphCongestionDataset pairs
with a *_labels.npz for pre-placement congestion prediction training.

Node = one instance (standard cell or macro).
Edge = one driver→sink connection through a shared net.

Node features (6):
  [area_norm, is_macro, is_seq, is_buf, fanin_norm, fanout_norm]

  area_norm    — cell master area / max cell area in design  [0, 1]
  is_macro     — 1 if hard macro (isBlock), else 0
  is_seq       — 1 if sequential cell (name contains FF/DFF/REG/LATCH), else 0
  is_buf       — 1 if buffer or inverter (isBuf / isInverter), else 0
  fanin_norm   — number of input iterms / max fanin in design  [0, 1]
  fanout_norm  — number of nets driven / max fanout in design  [0, 1]

Edge weight:
  1 / fanout of the driving net — high-fanout nets contribute less per edge
  since each individual connection carries less routing pressure.

High-fanout nets (above --fanout-cap) are skipped entirely. Nets above this
threshold are almost always clocks, resets, or scan enables that span the whole
die uniformly — including every connection would add O(N) edges per global net
and swamp the GNN's message passing with clock topology at the cost of local
logic structure.

Output (*_graph.npz):
  node_features  (N, 6)   float32
  edge_index     (2, E)   int64    COO format
  edge_weight    (E,)     float32
  node_names     (N,)     str      instance names (for debugging)
  num_macros     (1,)     int64

Run inside Docker via util/docker_shell:
  openroad -python extract_netlist_features.py \\
      --odb  <results_dir>/1_synth.odb \\
      --out  /work/ml/congestion/data/<label>_graph.npz \\
      [--fanout-cap 100]
"""

import argparse

import numpy as np
from openroad import Design, Tech


def _parse_args():
    ap = argparse.ArgumentParser()
    ap.add_argument("--odb",        required=True,
                    help="Post-synthesis ODB (1_synth.odb)")
    ap.add_argument("--out",        required=True,
                    help="Output *_graph.npz path")
    ap.add_argument("--fanout-cap", type=int, default=100,
                    help="Skip nets with fanout above this (clocks/resets). Default 100.")
    return ap.parse_args()


_SEQ_KEYWORDS = {"FF", "DFF", "REG", "LATCH", "SDC", "SDF", "FD"}


def _is_sequential(master_name: str) -> bool:
    upper = master_name.upper()
    return any(kw in upper for kw in _SEQ_KEYWORDS)


def extract_netlist_features(odb_path: str, fanout_cap: int = 100) -> dict:
    tech   = Tech()
    design = Design(tech)
    design.readDb(odb_path)
    block  = design.getBlock()

    insts = list(block.getInsts())
    if not insts:
        raise RuntimeError("No instances found — is this a post-synthesis ODB?")

    # ── Pass 1: collect per-instance stats ────────────────────────────────
    inst_index  = {}   # inst → node index
    areas       = []
    is_macro    = []
    is_seq      = []
    is_buf      = []
    fanin_list  = []
    fanout_list = []
    node_names  = []

    for idx, inst in enumerate(insts):
        inst_index[inst.getName()] = idx
        master = inst.getMaster()

        area = master.getWidth() * master.getHeight()
        areas.append(area)
        is_macro.append(1.0 if master.isBlock() else 0.0)
        is_seq.append(1.0 if _is_sequential(master.getName()) else 0.0)
        is_buf.append(1.0 if (master.isBuf() or master.isInverter()) else 0.0)
        node_names.append(inst.getName())

        fanin  = sum(1 for it in inst.getITerms() if it.isInputSignal())
        fanout = sum(1 for it in inst.getITerms() if it.isOutputSignal())
        fanin_list.append(fanin)
        fanout_list.append(fanout)

    N = len(insts)
    areas      = np.array(areas,       dtype=np.float32)
    fanin_arr  = np.array(fanin_list,  dtype=np.float32)
    fanout_arr = np.array(fanout_list, dtype=np.float32)

    # Normalise to [0, 1]
    area_norm   = areas    / (areas.max()      + 1e-9)
    fanin_norm  = fanin_arr  / (fanin_arr.max()  + 1e-9)
    fanout_norm = fanout_arr / (fanout_arr.max()  + 1e-9)

    node_features = np.stack([
        area_norm,
        np.array(is_macro,  dtype=np.float32),
        np.array(is_seq,    dtype=np.float32),
        np.array(is_buf,    dtype=np.float32),
        fanin_norm,
        fanout_norm,
    ], axis=1)  # (N, 6)

    # ── Pass 2: build edges from nets ─────────────────────────────────────
    # For each net: find the driver iterm (output) and all sink iterms (input).
    # Add one directed edge driver→sink per sink.
    # Skip nets above fanout_cap (clocks, resets, scan chains).
    edge_src     = []
    edge_dst     = []
    edge_weights = []

    skipped_nets = 0
    for net in block.getNets():
        iterms = list(net.getITerms())
        if not iterms:
            continue

        # Collect driver(s) and sinks
        drivers = []
        sinks   = []
        for it in iterms:
            inst = it.getInst()
            if inst is None:
                continue
            name = inst.getName()
            if name not in inst_index:
                continue
            if it.isOutputSignal():
                drivers.append(inst_index[name])
            else:
                sinks.append(inst_index[name])

        net_fanout = len(sinks)
        if net_fanout > fanout_cap:
            skipped_nets += 1
            continue
        if not drivers or not sinks:
            continue

        weight = 1.0 / max(net_fanout, 1)
        for d in drivers:
            for s in sinks:
                edge_src.append(d)
                edge_dst.append(s)
                edge_weights.append(weight)

    if not edge_src:
        raise RuntimeError(
            "No edges found. Check that the ODB is post-synthesis "
            "and contains connected nets."
        )

    edge_index  = np.array([edge_src, edge_dst], dtype=np.int64)   # (2, E)
    edge_weight = np.array(edge_weights,          dtype=np.float32) # (E,)

    num_macros = int(sum(is_macro))

    print(f"  Instances : {N}  (macros: {num_macros})")
    print(f"  Edges     : {edge_index.shape[1]}  "
          f"(skipped {skipped_nets} high-fanout nets > {fanout_cap})")
    print(f"  Seq cells : {int(sum(is_seq))}  "
          f"Buffers: {int(sum(is_buf))}")

    return {
        "node_features": node_features,
        "edge_index":    edge_index,
        "edge_weight":   edge_weight,
        "node_names":    np.array(node_names),
        "num_macros":    np.array([num_macros], dtype=np.int64),
    }


def main():
    args = _parse_args()
    print(f"[netlist] Reading {args.odb}")
    data = extract_netlist_features(args.odb, args.fanout_cap)
    np.savez(args.out, **data)
    print(f"[netlist] Saved → {args.out}")


if __name__ == "__main__":
    main()
