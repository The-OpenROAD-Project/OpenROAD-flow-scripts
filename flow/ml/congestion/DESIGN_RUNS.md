# ML Pipeline — Development Log

This file is the **canonical development log** for the ML work on the `congestion-ml` branch.
Every significant change, decision, and planned next step is recorded here so the project can
be resumed from a cold start without losing context. Update it after every working session.

---

## Project Overview

**Goal:** Add ML-based prediction capabilities that OpenROAD currently lacks.

**Primary track: Thermal prediction** (branch focus as of 2026-08-10)

| Track | Input | Model | Labels | Status |
|---|---|---|---|---|
| **Thermal prediction** | Post-placement ODB | U-Net (`models/unet.py`) | HotSpot thermal maps | Extractor + pipeline wired; awaiting data |
| Pre-placement congestion | Post-synthesis netlist graph | GNN (`models/gnn.py`) | GRT congestion maps | Deprioritised — code kept, not actively developed |

**Why thermal is the focus:**
- OpenROAD has no thermal solver at all. HotSpot runs take minutes; a trained U-Net
  surrogate runs in milliseconds and can be embedded directly into the ORFS flow.
- Pre-placement congestion prediction (GNN) is a useful capability but not urgent —
  it remains in the codebase and the pipeline still extracts netlist graphs for free,
  but it is not the primary development target on this branch.

---

## Codebase Map

```
flow/ml/
├── Dockerfile                          # Custom image: ORFS + HotSpot + Python ML packages
├── congestion/
│   ├── DESIGN_RUNS.md                  # This file — canonical dev log
│   ├── data/                           # Extracted .npz datasets (features + labels)
│   ├── data_collection/
│   │   ├── extract_features.py         # Post-placement features from ODB (4 channels, 64x64)
│   │   ├── extract_labels.py           # Congestion labels from GRT ODB
│   │   ├── extract_thermal_labels.py   # Thermal labels via HotSpot
│   │   ├── extract_netlist_features.py # Pre-placement netlist graph (Track 1 GNN input)
│   │   ├── extract_existing.sh         # Batch extract from pre-existing ORFS result dirs
│   │   └── batch_run.sh                # Helper for manual batch runs
│   ├── models/
│   │   ├── unet.py                     # U-Net: spatial features → congestion/thermal heatmap
│   │   ├── gnn.py                      # GNN: netlist graph → congestion heatmap
│   │   └── heads.py                    # Shared output heads (heatmap, hotspot, score)
│   ├── training/
│   │   ├── dataset.py                  # CongestionDataset loader + split_dataset
│   │   ├── metrics.py                  # heatmap_mae, hotspot_iou, score_pearson, compute_all
│   │   ├── train_unet.py               # U-Net training script
│   │   └── train_gnn.py                # GNN training script
│   ├── inference/
│   │   ├── evaluate.py                 # Evaluate all models on held-out test set
│   │   └── predict.py                  # Single-design inference
│   ├── pipeline/
│   │   ├── run_pipeline.py             # Automated ORFS data collection pipeline
│   │   ├── designs.json                # Design configs for pipeline runs
│   │   └── logs/                       # Per-run error logs + summary logs
│   ├── tests/
│   │   ├── test_models.py              # Smoke tests: shapes, ranges, training, checkpoints
│   │   └── generate_synthetic_data.py  # Synthetic .npz generator for tests
│   └── checkpoints/
│       ├── unet_best.pt / unet_last.pt
│       └── gnn_best.pt  / gnn_last.pt
└── data/                               # Pre-placement GNN data from prior experiments
    ├── *_graph.npz                     # Netlist graphs (Track 1 input features)
    ├── *_congestion.npy                # Congestion maps (Track 1 labels)
    └── *_floorplan.npz                 # Floorplan data (larger designs)
```

---

## Changelog

### 2026-08-13 — Cell-type weighted power model + full 48-sample retrain

**Root cause of previous near-flat thermal maps:**
The old `build_power_grid()` used uniform cell area as the power proxy — every cell weighted
equally. Sequential cells (DFFs) and clock cells (ICG, CLKBUF) dissipate 3–5× more power than
combinational logic. This produced near-uniform power grids → near-flat HotSpot output (ΔT ≈ 0–2°C).

**`data_collection/extract_thermal_labels.py` — cell-type weighted power model:**

Added `_cell_power_weight(master_name, master_type_str)` function:
- Clock cells (CLKBUF, CLKINV, CKBUF, CKINV, ICG, CLKGATE, __CLK, __DLCLK): **5× weight**
- Sequential (DFF, SDFF, LATCH, __DFX, __DLX, __DLAT, FD_, _FD_): **3× weight**
- Macros (BLOCK master type): **2× weight**
- Combinational: **1× weight**

Rewrote `build_power_grid()` to accumulate `area_um2 × weight` into `weighted_grid`,
then rescale to `total_power_w` so absolute power is preserved while spatial distribution
reflects cell activity. Prints per-type breakdown at runtime (count, weighted-power %).

**Re-extraction of all 48 samples:**
Previous run failed with `FileNotFoundError: 'hotspot'` because `OR_IMAGE` was not set,
so Docker used `openroad/orfs:latest` (no HotSpot) instead of `openroad/orfs-ml:latest`.
Fix: always set `OR_IMAGE=openroad/orfs-ml:latest` before running `extract_thermal_batch.sh`.

```bash
cd flow && OR_IMAGE=openroad/orfs-ml:latest bash ml/congestion/data_collection/extract_thermal_batch.sh --force
```
Result: **passed=48, failed=0** (skipped=48 = features already extracted).

**U-Net retrain on 48 samples (100 epochs, CPU):**
- Dataset: 48 samples, T range 87–148°C (real thermal gradients confirmed)
- Split: train=33, val=7, test=8
- Best val MSE: **0.02912** at epoch 70
- Final val MAE: ~0.138 normalized ≈ ~8°C absolute error
- Train/val gap after epoch 70 indicates mild overfitting at 33 samples

```bash
OR_IMAGE=openroad/orfs-ml:latest util/docker_shell python3 /work/ml/congestion/training/train_thermal.py \
    --data-dir /work/ml/congestion/data \
    --checkpoint-dir /work/ml/congestion/checkpoints
```

**Visualization report (`inference/visualize_thermal.py`) — per-design correlation:**

Run from `flow/` on host (matplotlib not in orfs-ml image):
```bash
python3 ml/congestion/inference/visualize_thermal.py \
    --data-dir ml/congestion/data \
    --checkpoint ml/congestion/checkpoints/thermal_best.pt \
    --out thermal_report.html
```

Full per-design results (baseline for future model comparisons):

| Design | Corr | MAE (norm) | T range (°C) |
|---|---|---|---|
| asap7_aes_base | +0.821 | 0.115 | 110–110 |
| asap7_jpeg_hi_util_75 | NaN | 0.249 | 110–110 |
| asap7_jpeg_pipeline_85 | +0.858 | 0.089 | 110–110 |
| nangate45_adder4_base | +0.894 | 0.093 | 110–110 |
| nangate45_aes_base | +0.941 | 0.076 | 108–112 |
| nangate45_ariane133_base | +0.891 | 0.130 | 109–130 |
| nangate45_ariane133_util_60 | +0.675 | 0.156 | 115–121 |
| nangate45_ariane136_base | +0.940 | 0.083 | 87–148 |
| nangate45_dynamic_node_base | +0.954 | 0.065 | 109–111 |
| nangate45_gcd_base | +0.848 | 0.134 | 110–110 |
| nangate45_gcd_hi_util | +0.199 | 0.277 | 110–110 |
| nangate45_ibex_ar_05 | +0.858 | 0.096 | 108–112 |
| nangate45_ibex_ar_15 | +0.737 | 0.158 | 109–111 |
| nangate45_ibex_ar_20 | +0.823 | 0.138 | 107–112 |
| nangate45_ibex_base | +0.912 | 0.095 | 108–112 |
| nangate45_ibex_hi_util | +0.923 | 0.086 | 109–111 |
| nangate45_ibex_pipeline_85 | +0.902 | 0.118 | 109–111 |
| nangate45_ibex_util_60 | +0.931 | 0.114 | 109–111 |
| nangate45_ibex_util_70 | +0.938 | 0.088 | 109–111 |
| nangate45_jpeg_ar_05 | +0.974 | 0.064 | 109–112 |
| nangate45_jpeg_ar_15 | +0.690 | 0.148 | 110–112 |
| nangate45_jpeg_ar_20 | +0.616 | 0.149 | 110–112 |
| nangate45_jpeg_base | +0.814 | 0.101 | 110–112 |
| nangate45_jpeg_hi_util | +0.781 | 0.156 | 110–112 |
| nangate45_jpeg_pipeline_88 | +0.795 | 0.147 | 110–112 |
| nangate45_jpeg_util_60 | +0.542 | 0.167 | 109–113 |
| nangate45_jpeg_util_70 | +0.879 | 0.078 | 109–112 |
| nangate45_jpeg_util_90 | +0.781 | 0.156 | 110–112 |
| nangate45_swerv_ar_05 | +0.807 | 0.135 | 108–114 |
| nangate45_swerv_ar_15 | +0.822 | 0.105 | 108–114 |
| nangate45_swerv_ar_20 | +0.647 | 0.166 | 107–114 |
| nangate45_swerv_base | +0.741 | 0.104 | 109–113 |
| nangate45_swerv_hi_util | +0.766 | 0.146 | 109–113 |
| nangate45_swerv_pipeline_80 | +0.771 | 0.132 | 109–113 |
| nangate45_swerv_util_60 | +0.734 | 0.109 | 109–113 |
| nangate45_swerv_util_70 | +0.761 | 0.108 | 109–113 |
| nangate45_tinyRocket_base | +0.331 | 0.265 | 110–112 |
| sky130hd_aes_base | +0.787 | 0.113 | 111–113 |
| sky130hd_gcd_base | +0.668 | 0.152 | 110–110 |
| sky130hd_ibex_base | +0.816 | 0.268 | 110–116 |
| sky130hd_jpeg_base | +0.887 | 0.157 | 111–119 |
| sky130hd_riscv32i_ar_05 | +0.908 | 0.115 | 108–113 |
| sky130hd_riscv32i_ar_15 | +0.967 | 0.054 | 109–112 |
| sky130hd_riscv32i_ar_20 | +0.791 | 0.147 | 109–112 |
| sky130hd_riscv32i_base | +0.824 | 0.097 | 108–112 |
| sky130hd_riscv32i_pipeline_65 | +0.971 | 0.070 | 109–112 |
| sky130hd_riscv32i_util_60 | +0.967 | 0.074 | 108–112 |
| sky130hd_riscv32i_util_70 | +0.957 | 0.069 | 109–112 |

Summary: 13 designs ≥0.9 (excellent), ~30 designs 0.6–0.9 (good), 3 designs <0.6 (poor),
1 NaN (asap7_jpeg_hi_util_75, flat map). Mean corr across non-NaN designs: ~0.80.

**Known issue — asap7 flat maps:**
All asap7 designs show ΔT≈0°C (110–110°C). The cell naming in asap7 (`BUF_X1`, `DFF_X1`)
does not match the substring patterns in `_cell_power_weight` (which expect e.g. `CLKBUF`,
`DFF` not preceded by `_`). Fix needed: add asap7-specific patterns or use master type
flags more aggressively instead of name patterns.

**Warnings fixed in `visualize_thermal.py`:**
- `tight_layout` warning: switched colorbar subplot to `layout="constrained"` in `plt.subplots`
- `invalid value in divide` from `np.corrcoef`: wrapped in `np.errstate(invalid="ignore")`
  (NaN result is expected for flat maps and rendered correctly in HTML)

**Docker path note:**
`util/docker_shell` mounts the workspace to `/work` but `cd`s to `/OpenROAD-flow-scripts/flow`
inside the container. Always use absolute `/work/...` paths when passing scripts and data
directories to docker_shell. Relative paths resolve to the baked-in image path, not the
mounted workspace.

---

### 2026-08-11 — Option A: pre-diffused input channel + data expansion plan

**`training/thermal_dataset.py` — added 5th input channel (pre-diffused cell density):**
- Added `scipy.ndimage.gaussian_filter(cell_density, sigma=3.0)` as channel 4.
- Normalised blurred channel to [0,1] independently before stacking.
- Rationale: U-Net has no knowledge of thermal diffusion (heat spreading laterally).
  The blurred channel approximates the Green's function kernel of the steady-state
  heat equation, giving the model a "pre-spread" view of the power distribution.
  The model then learns the residual between this approximation and the true HotSpot output.
- Input shape: (4, 64, 64) → (5, 64, 64).

**`training/train_thermal.py` + `inference/visualize_thermal.py`:** `in_channels=4 → 5`.

**`data_collection/generate_variants.sh` — new script for ORFS flow variant generation:**
- Generates utilization variants (60%, 70%, 90%) for ibex, jpeg, swerv, ariane133, riscv32i.
- Generates aspect-ratio variants (0.5, 1.5, 2.0) for ibex, jpeg, swerv, riscv32i.
- Run with `--dry-run` to preview make commands without executing them.
- Adds ~24 new training samples (from 26 → ~50) once extracted.
- `adder4` and `gcd` intentionally excluded — near-flat thermal maps (ΔT ≈ 0) add noise.

**Alternative model options noted for future (not yet implemented):**
- **Option B** — Physics-informed Laplacian loss: `L_total = L_mse + λ·||∇²T_pred||²`
  Penalises non-smooth gradients without needing PDE solver. ~20 lines in train_thermal.py.
- **Option C** — Fourier Neural Operator (FNO): operates in frequency domain via FFT.
  Theoretically most principled for PDE solutions (∇·(k∇T)+Q=0). Needs new models/fno.py.
  Recommended once dataset exceeds 60 samples.
- **Option D** — Swin Transformer: global attention = larger effective receptive field.
  Already existed in repo (deleted). Better than U-Net for large dies (ariane136 ΔT=54°C).
  Needs 50+ samples to outperform U-Net reliably.

**Next steps:**
1. Retrain with 5-channel input: `python3 ml/congestion/training/train_thermal.py --data-dir ml/congestion/data --checkpoint-dir ml/congestion/checkpoints --epochs 200`
2. Run variant generation (dry-run first to check): `bash ml/congestion/data_collection/generate_variants.sh --dry-run`
3. Run for real (takes several hours): `bash ml/congestion/data_collection/generate_variants.sh`
4. Re-extract thermal labels for new variants: `bash ml/congestion/data_collection/extract_thermal_batch.sh`
5. Retrain again on expanded dataset (~50 samples).

---

### 2026-08-10 — Thermal training pipeline: per-sample normalisation + timeout fix

**Root cause of "21 designs failed" in batch:**
The original batch script had no per-design timeout. Large designs (ariane133, ariane136,
swerv) take 40+ minutes for ODB loading alone in OpenROAD Python mode. The batch ran the
first 5 small/fast designs successfully (asap7 ×3 + nangate45/adder4/aes), then appeared
to stall on ariane133 (which actually completed after 41 min). The remaining designs were
simply waiting in sequence.

**Current dataset: 8 complete pairs** (6 nangate45 + 2 asap7, extracted 2026-08-10):
- asap7: aes_base, jpeg_hi_util_75, jpeg_pipeline_85
- nangate45: adder4_base, aes_base, ariane133_base, gcd_base, ibex_base

**`data_collection/extract_thermal_batch.sh` — timeout support added:**
- Default 3600s (1 hour) per extractor call via `timeout "$TIMEOUT_S" util/docker_shell ...`
- Exit code 124 = timeout → prints `[TIMEOUT]` message rather than generic `[FAIL]`
- `--timeout N` flag to override from command line
- Skip counter now also incremented for features (was only counting thermal skips)

**`training/thermal_dataset.py` — switched to per-sample normalisation:**
- Each thermal map is independently normalised to [0,1] using its own min/max.
  Reason: HotSpot absolute temperatures vary ~100× across process nodes and die sizes
  (asap7 50µm die at 500mW → 2000°C; nangate45 ibex 0.24mm die → 100°C). The ML model
  needs to learn spatial hotspot patterns, not cross-process temperature scales.
- `__getitem__` now returns `{"x", "thermal", "t_min", "t_max"}` per sample.
- `denormalize()` signature updated to take explicit `(t_norm, t_min, t_max)`.
- Dataset-level `self.t_min` / `self.t_max` kept as per-sample lists for diagnostics.

**`training/train_thermal.py` — updated for per-sample norm:**
- Removed `thermal_norm.json` write (no longer a global constant).
- Val metric is now `val_mae (norm)` [0,1] instead of °C (meaningless cross-process).

**`inference/predict_thermal.py` — updated for per-sample norm:**
- Removed `--norm` argument (no external norm JSON needed).
- Output `.npz` now contains only `thermal_pred_norm` (relative heatmap [0,1]).
- 1.0 = predicted hottest point in that specific design.

**Smoke test:** 5-epoch training run on 8 samples converged (val MSE 0.061 on 1 val sample).
GPU used (CUDA available). Full training pipeline verified end-to-end.

---

### 2026-08-10 — Thermal inference script + U-Net fix

**`models/unet.py`** — added `num_heatmap_layers` parameter to `CongestionUNet.__init__`
(default 10 for congestion, backwards-compatible). For thermal, pass `num_heatmap_layers=1`
to get a proper 1-channel output instead of wasting 9 unused channels.

**`training/train_thermal.py`** — updated to use `num_heatmap_layers=1` and removed the
`pred.heatmap[:, :1, :, :]` channel-slice hack. Now uses `pred.heatmap` directly.

**`inference/predict_thermal.py`** — inference script for trained thermal model.

Two usage modes:
- `--features <npz>` (no OpenROAD needed): loads pre-extracted feature file, runs model,
  outputs predicted thermal map in normalised [0,1] and °C forms.
- `--odb <path>` (auto-extracts): calls `extract_features.py` via `docker_shell` internally,
  then runs model. Requires `OR_IMAGE=openroad/orfs-ml:latest` or base image with OpenROAD.

Outputs `thermal_pred_norm` (64×64), `thermal_pred_c` (64×64 in °C), and normalisation
constants to a `.npz`. Run from `flow/`:
```bash
python3 ml/congestion/inference/predict_thermal.py \\
    --features ml/congestion/data/<label>_features.npz \\
    --checkpoint ml/congestion/checkpoints/thermal_best.pt \\
    --norm ml/congestion/checkpoints/thermal_norm.json \\
    --out predicted_thermal.npz
```

---

### 2026-08-10 — extract_thermal_batch.sh bug fixes (3 iterations)

**Bug 1 — doubled `results/results/` path:**
`find results -name "3_place.odb"` returns relative paths starting with `results/`.
The strip `${HOST_ODB#*/flow/results/}` expected an absolute path and stripped nothing,
so `cont_odb=/work/results/results/asap7/...` was passed to docker.
Fix: `${HOST_ODB#results/}` strips the leading `results/` from relative paths.

**Bug 2 — skip-check path had extra `flow/` prefix:**
`feat_host="flow/ml/..."` was wrong because the script already `cd`s into `flow/`.
Fix: `feat_host="ml/..."`.

**Bug 3 — `docker run -i` consumed the `find` pipe (only 1 design processed):**
`docker_shell` always passes `-i` to `docker run`, which attaches the container stdin
to the script's own stdin. Since the while loop reads from process substitution
`< <(find ... | sort)`, docker consumed all remaining ODB paths after the first
container exited. Only one design was ever processed.
Fix: added `</dev/null` to each `util/docker_shell` call so docker gets a dead stdin.

**Bug 4 — `extract_thermal_labels.py` singular matrix (`lupdcmp`) on small dies:**
asap7 die (50×50 µm) at 64×64 grid gives 0.78 µm cells — too small for HotSpot's
block RC model (conductance matrix becomes ill-conditioned).
Fix: `_adaptive_hotspot_grid()` caps the HotSpot grid to keep cells ≥ 5 µm
(gives 10×10 for asap7), runs HotSpot at that resolution, then bilinearly upsamples
to 64×64. Also added 1% uniform power floor to all cells to prevent zero-power rows
from causing singular matrix independently of die size.

---

### 2026-08-10 — Thermal training infrastructure

Three new files to support thermal model training:

**`data_collection/extract_thermal_batch.sh`** — batch extraction over all existing
`3_place.odb` files on disk (26 found). Runs `extract_features.py` + `extract_thermal_labels.py`
for each, writes paired `*_features.npz` + `*_thermal_labels.npz` to `ml/congestion/data/`.
Idempotent — already-extracted files are skipped. Run with:
```bash
cd flow && export OR_IMAGE=openroad/orfs-ml:latest
bash ml/congestion/data_collection/extract_thermal_batch.sh
```

**`training/thermal_dataset.py`** — `ThermalDataset`: finds matched `*_features.npz` +
`*_thermal_labels.npz` pairs, normalises thermal maps to [0,1] using dataset-wide
min/max, applies random H/V flips for augmentation. `split_thermal_dataset()` for
train/val/test splits. Stores `t_min`/`t_max` for °C de-normalisation at inference.

**`training/train_thermal.py`** — trains `CongestionUNet` on thermal data. Uses
`pred.heatmap[:, :1, :, :]` (first heatmap channel) as the thermal output — MSE loss
only, no hotspot/score heads. Saves `thermal_best.pt`, `thermal_last.pt`, and
`thermal_norm.json` (normalisation constants) to `checkpoints/`.

---

### 2026-08-10 — Pipeline run results + bug analysis

Run: `python3 ml/congestion/pipeline/run_pipeline.py` (WITHOUT `OR_IMAGE=openroad/orfs-ml:latest`).

| Design | Result | Notes |
|---|---|---|
| asap7/jpeg @ 85% | SUCCESS | data collected — no thermal files (OR_IMAGE not set) |
| sky130hd/riscv32i @ 65% | SUCCESS | data collected — no thermal files |
| nangate45/swerv @ 80% | FAILED_GRT_80 | see bug below |
| nangate45/ibex @ 85% | SUCCESS | data collected — no thermal files |
| nangate45/jpeg | FAILED_SYNTH @ 78% | see bug below |

**No thermal files were produced** — must set `OR_IMAGE=openroad/orfs-ml:latest` for HotSpot to run.
Run `extract_thermal_batch.sh` to collect thermal labels from all existing ODB files.

**Bug: swerv ODB-0269 root cause (updated)**
The REPORTS_DIR fix did not resolve ODB-0269. Root cause: `OPT_POST_GRT_WNS=0` (nangate45 default)
causes `global_route -end_incremental` to re-route modified nets after `recover_power`, and that
specific call fails writing markers. The REPORTS_DIR path itself is constructed correctly (confirmed
from log: `congestion_post_repair_design.rpt` was written). The failing path is the subsequent
`congestion_post_repair_timing.rpt` call, where OpenROAD can't open the markers file.
**Fix:** Set `OPT_POST_GRT_WNS=1` for GRT stage in `_make()` — switches to WNS repair path
which does not trigger the bug. Now applied in `run_pipeline.py`.
**Note:** swerv@80% `3_place.odb` EXISTS (placement succeeded before GRT failed) → thermal extraction works.

**Bug: jpeg FAILED_SYNTH at 78% (retry from GRT-0232 at 88%)**
Yosys phase completed (1_2_yosys.v produced). The OpenROAD step producing `1_synth.odb` failed.
`pipeline_78/` directory has yosys outputs but no `1_synth.odb`. Likely a dependency or objects-dir
issue with the fresh `pipeline_78` objects directory. Unrelated to CORE_UTILIZATION (synth doesn't
use utilization). No 3_place.odb exists so no thermal data from this design/tag.
Next attempt: add jpeg to designs.json with explicit `"utilization": 80` to avoid the 88%→GRT-0232
retry path and test directly at 80%.

---

### 2026-08-10 — Branch focus narrowed to thermal solver

User decision: `thermal-solver` branch is now **thermal modeling only**. Pre-placement
congestion prediction (GNN track) is deprioritised. Rationale: OpenROAD has no thermal
solver at all, making this the higher-value gap to fill. The GNN codebase is kept intact
and the pipeline still runs netlist extraction as a free step, but thermal is the active
development target.

---

### 2026-08-10 — Pre-placement netlist extractor + pipeline integration

Wrote `data_collection/extract_netlist_features.py` and wired it into `run_pipeline.py`
as step 0 of `extract_data()`.

**What `extract_netlist_features.py` does:**

Runs inside `openroad -python` on a post-synthesis ODB (`1_synth.odb`). No placement
coordinates are read — the extractor is intentionally blind to physical layout. It:

1. Iterates all instances to collect per-node stats: master area, master type flags
   (isBlock, isBuf, isInverter), sequential detection (name pattern match against
   FF/DFF/REG/LATCH/FD), fanin/fanout counts
2. Normalises area, fanin, fanout to [0, 1] relative to design max
3. Iterates all nets, finds driver→sink ITerms, skips nets above `--fanout-cap` (default 100)
   to drop clocks/resets that would create O(N) edges and swamp topology signal
4. Assigns `edge_weight = 1 / fanout` so high-fanout nets contribute less per connection
5. Saves `node_features (N,6)`, `edge_index (2,E)`, `edge_weight (E,)`, `node_names (N,)`,
   `num_macros` to `*_graph.npz`

**Node features (6):** `[area_norm, is_macro, is_seq, is_buf, fanin_norm, fanout_norm]`
This matches `NODE_FEATURES = 6` in `models/gnn.py` exactly — no changes to the model needed.

**Pipeline integration:** Step 0 in `extract_data()`, non-fatal. Uses `{results_dir}/1_synth.odb`
as input, writes `{data_dir}/{out_label}_graph.npz` alongside the congestion labels so
`GraphCongestionDataset` can pair them by name for GNN training.

**Run manually:**
```bash
OR_IMAGE=openroad/orfs-ml:latest util/docker_shell openroad -python \
    /work/ml/congestion/data_collection/extract_netlist_features.py \
    --odb /work/results/<platform>/<design>/<tag>/1_synth.odb \
    --out /work/ml/congestion/data/<label>_graph.npz
```

---

### 2026-08-10 — Branch renamed from congestion-ml to thermal-solver

```bash
git branch -m congestion-ml thermal-solver
```

---

### 2026-08-10 — Thermal extraction wired into pipeline

Added thermal label extraction as step 3 in `extract_data()` inside `run_pipeline.py`.
Every successful pipeline run now produces three output files per design:
- `*_features.npz` — placement features (existing, step 1)
- `*_labels.npz` — congestion labels from GRT (existing, step 2)
- `*_thermal_labels.npz` — HotSpot thermal map from placement ODB (new, step 3)

Thermal extraction is non-fatal: if HotSpot is not found in the container
(i.e. running with the base `openroad/orfs:latest` image), it logs a warning
and skips without failing the run. Congestion data is always saved.

To enable thermal extraction, run the pipeline with the custom image:
```bash
OR_IMAGE=openroad/orfs-ml:latest python3 ml/congestion/pipeline/run_pipeline.py
```

---

### 2026-08-10 — GNN rewrite: Option B (global pool + CNN decoder)

Rewrote `models/gnn.py` to remove scatter-to-grid and replace it with a
global pool + CNN decoder that doesn't need placement coordinates.

**Why:** The original GNN used placement (x, y) coordinates to scatter node
embeddings onto a spatial grid. Pre-placement, those coordinates don't exist.
Option A (RUDY-estimated positions) was considered but rejected — feeding wrong
position estimates would teach the model incorrect spatial correlations and
cap accuracy. Option B is architecturally correct for the task.

**New architecture:**
1. Linear projection + 3-layer GraphSAGE encoder (same as before)
2. Global mean + max pool → graph fingerprint (B, 2×embed_dim)
3. Seed MLP → reshape to (B, decoder_dim, 4, 4) spatial seed
4. CNN decoder: 4×4 → 64×64 via bilinear upsample + Conv2d + BatchNorm + ReLU
5. Same output heads as U-Net (heatmap, hotspot, score)

**Input changed:** NODE_FEATURES reduced from 8 to 6 — dropped x_norm and y_norm
since they don't exist pre-placement. Forward signature simplified to
`(x, edge_index, batch)` — no x_norm/y_norm arguments.

**New files:**
- `training/graph_dataset.py` — `GraphCongestionDataset` loads `*_graph.npz` +
  `*_labels.npz` pairs; `graph_collate` handles variable-size graphs in a batch
- `training/train_gnn.py` — rewritten to use `GraphCongestionDataset` with real
  netlist graphs instead of the fake grid-to-graph conversion placeholder

**Existing graph data note:** `flow/ml/data/*_congestion.npy` files are shape (10,)
per-layer global scores, NOT spatial maps — incompatible with our spatial task.
The graph_dataset pairs `*_graph.npz` with `*_labels.npz` (spatial, from
extract_labels.py) by matching design names in the same directory.

All 16 tests pass.

---

### 2026-08-10 — Codebase cleanup and pivot to two focused tracks

**Decision:** Pivoted from comparing all model architectures to two focused tracks
(pre-placement congestion + thermal). The original goal of comparing Swin/RF/Diffusion/Ensemble
was abandoned because:
- OpenROAD already has post-route congestion maps — post-placement ML adds no unique value
- Pre-placement prediction and thermal modeling are genuine gaps OpenROAD lacks
- The six-model comparison was blocked by data quality anyway (only 2 usable training samples)

**Removed:**

| File | Reason |
|---|---|
| `models/swin.py` + `training/train_swin.py` | Requires spatial grid input — not available pre-placement; U-Net is simpler and better suited for thermal |
| `models/classical.py` + `training/train_classical.py` | RF/XGBoost cannot output 64×64 spatial heatmaps |
| `models/diffusion.py` + `training/train_diffusion.py` | Generative model — slow inference, not a regression task, neither track needs sampling |
| `models/ensemble.py` | Premature — the two active tasks are now separate, not competing on the same problem |
| `checkpoints/swin_*.pt`, `checkpoints/rf.pkl` | Stale checkpoints for removed models |
| `model/` (directory) | Old single-model directory from early experiments, superseded by `models/` |
| `flow/ml/floorplan/` | Old floorplan experiment directory, no source code remaining, just a checkpoint |
| `flow/rsults/` | Typo directory (should be `results/`), contained one stale `clock_period.txt` |

**Added:**

| File | Purpose |
|---|---|
| `data_collection/extract_thermal_labels.py` | Reads a placed ODB, uses cell area as power proxy, writes HotSpot `.flp`/`.ptrace`, runs HotSpot, parses `.steady` output into a `thermal_map` + `power_grid` `.npz` |
| `flow/ml/Dockerfile` | Extends `openroad/orfs:latest` with HotSpot v7.0 and Python ML packages |

**Discovered:** `flow/ml/data/` contains prior pre-placement GNN experiments with netlist
`*_graph.npz` files and `*_congestion.npy` labels for ~15 nangate45/sky130hd designs including
larger ones (ariane133, black_parrot, mempool_group, microwatt). This data is directly usable
for Track 1 without any new ORFS runs.

---

### 2026-08-10 — Pipeline bug fixes

**Bug 1 — ODB-0269 (swerv@80%):**
`REPORTS_DIR` was not passed to `make` in `run_pipeline.py`. ORFS defaulted it to
`reports/<platform>/<design>/base`, causing OpenROAD to construct an empty markers file path.
GRT itself completed successfully (routing congestion 1.3175 — genuinely congested), but make
exited non-zero and the ODB was never written.
**Fix:** Derive `REPORTS_DIR` from `RESULTS_DIR` by substituting `/work/results/` → `/work/reports/`
and pass it explicitly in `_make()`.

**Bug 2 — GRT-0232 not retried (jpeg@88%):**
`[ERROR GRT-0232] Routing congestion too high` was treated as an unexpected failure, so the
pipeline gave up instead of retrying at a lower utilization. FLW-0024 and DPL-0038 triggered
retry; GRT-0232 should too.
**Fix:** Added `GRT0232_RE` pattern to the retry logic alongside FLW-0024 and DPL-0038.

**Bug 3 — Summary not persisted:**
Pipeline summary was only printed to stdout. If the terminal closed, the run history was lost.
**Fix:** Summary now also written to `pipeline/logs/summary_<timestamp>.log`.

---

### 2026-08-10 — Docker image (`openroad/orfs-ml:latest`)

Built a custom Docker image extending the ORFS base with HotSpot and ML packages.
Motivated by the thermal track needing HotSpot, which is not in the ORFS base image.

**Build:**
```bash
docker build -t openroad/orfs-ml:latest flow/ml/
```

**Use (instead of plain `util/docker_shell`):**
```bash
OR_IMAGE=openroad/orfs-ml:latest util/docker_shell <cmd>
# or export for the whole session:
export OR_IMAGE=openroad/orfs-ml:latest
```

`docker_shell` image resolution: `-i flag > $OR_IMAGE env var > default openroad/orfs:latest`

**Contents added over base:**
- HotSpot v7.0 compiled from source → `/usr/local/bin/hotspot`
- Python packages: numpy, scipy, scikit-learn, torch, torch-geometric

**Verify:**
```bash
OR_IMAGE=openroad/orfs-ml:latest util/docker_shell which hotspot
```

---

### 2026-08-09 — Pipeline run results

Ran `run_pipeline.py` with designs.json configured as:

| Design | Target util | Result | Data |
|---|---|---|---|
| asap7/jpeg | 85% | SUCCESS | 0% hotspots — no congestion signal |
| sky130hd/riscv32i | 65% | SUCCESS | 0% hotspots — no congestion signal |
| nangate45/swerv | 80% | FAILED_GRT_80 | ODB-0269 bug (see bug fix above) |
| nangate45/ibex | 85% | SUCCESS | 0% hotspots — still no congestion signal |
| nangate45/jpeg | 88% | FAILED_GRT_88 | GRT-0232 bug (see bug fix above) |

**Observation:** All three successes produced 0% hotspots. The only designs producing
useful congestion signal remain nangate45/swerv@85% (32.5%) and nangate45/jpeg@85% (6.1%).
Data starvation in the 10–70% hotspot range is the primary blocker for model training.

---

### Prior sessions — Initial pipeline and models

- Built U-Net (4-level, 3-head), GNN (GraphSAGE + grid scatter), Swin, RF/XGBoost,
  Ensemble, Diffusion models (Swin/RF/Ensemble/Diffusion later removed — see cleanup above)
- Built `run_pipeline.py` automated data collection pipeline
- Built `extract_features.py` (placement ODB → 4-channel 64×64 feature map) and
  `extract_labels.py` (GRT ODB → heatmap/hotspot/score labels)
- Ran manual high-utilization design runs; only swerv@85% and jpeg@85% produced useful data
- Ran `extract_existing.sh` to harvest existing ORFS result dirs; all produced 89–99%
  hotspot rates (extreme congestion, not useful for calibrated training)

---

## Known Blockers

| Issue | Symptom | Fix / Workaround |
|---|---|---|
| FLW-0024 density > 1.0 | `Place density exceeds 1.0` at placement | Lower `CORE_UTILIZATION` or use different platform |
| PDN file not found (sky130hd) | `gcd/grid_strategy-M1-M4-M7.tcl` missing | Add `PDN_TCL=/OpenROAD-flow-scripts/flow/platforms/sky130hd/pdn.tcl` |
| PDN file not found (asap7) | `asap7/gcd/grid_strategy-M1-M4-M7.tcl` missing | Add `PDN_TCL=/OpenROAD-flow-scripts/flow/platforms/asap7/openRoad/pdn/grid_strategy-M1-M2-M5-M6.tcl` (capital R in openRoad) |
| `No rule to make target 2_1_floorplan.sdc` | `make grt` on fresh dir | Run synth → floorplan → grt sequentially, never skip |
| OPENROAD_HIERARCHICAL=1 | Wrong PDN file references | Skip design or explicitly override `PDN_TCL` |
| SYNTH_HIERARCHICAL=1 | Broken make dependency chain | Skip design entirely |
| Sky130hd util ceiling | Platform overhead eats ~25% of core area; safe max ~65% | Use nangate45 or asap7 instead |

---

## Dataset Summary (congestion labels)

**Target range for useful training: 10–70% hotspots.** Both extremes (~0% and ~98%) hurt calibration.

| File key | Hotspots | % | Notes |
|---|---|---|---|
| nangate45_swerv_hi_util | 1331/4096 | 32.5% | **Best congestion signal** |
| nangate45_jpeg_hi_util | 250/4096 | 6.1% | Mild signal |
| nangate45_jpeg_2 | 3961/4096 | 96.7% | Extreme — extract_existing |
| nangate45_jpeg_10 | 4051/4096 | 98.9% | Extreme — extract_existing |
| nangate45_aes_0 | 4015/4096 | 98.0% | Extreme — extract_existing |
| nangate45_aes_8 | 3646/4096 | 89.0% | Extreme — extract_existing |
| nangate45_coyote_6 | 3996/4096 | 97.6% | Extreme — extract_existing |
| nangate45_swerv_4 | 4052/4096 | 98.9% | Extreme — extract_existing |
| sky130hd_ariane_7 | 4055/4096 | 99.0% | Extreme — extract_existing |
| sky130hd_gcd_1/9 | ~98% | Extreme | extract_existing |
| sky130hd_ibex_3/11 | ~97–99% | Extreme | extract_existing |
| sky130hd_tinyRocket_5 | 4067/4096 | 99.3% | Extreme — extract_existing |
| Everything else | 0/4096 | 0% | No congestion signal |

---

## Design Run History

### nangate45

| Design | Util | Outcome | Notes |
|---|---|---|---|
| gcd | 85% | FAILED CTS | Never reached GRT |
| ibex | 80% | SUCCESS | 0% hotspots |
| ibex | 85% | SUCCESS | 0% hotspots |
| jpeg | 85% | SUCCESS | 6.1% hotspots — mild signal |
| jpeg | 88% | FAILED GRT-0232 | Too congested to route (pipeline bug now fixed) |
| swerv | 80% | FAILED ODB-0269 | GRT actually finished congested; pipeline bug now fixed |
| swerv | 85% | SUCCESS | 32.5% hotspots — best signal |
| swerv | 90% | FAILED FLW-0024 | Density > 1.0 |
| dynamic_node | 85% | FAILED FLW-0024 | Only 521 instances, too small |
| ariane133 | any | SKIPPED | SYNTH_HIERARCHICAL=1 |
| tinyRocket | any | SKIPPED | Uses SRAMs (fakeram) |

### sky130hd

| Design | Util | Outcome | Notes |
|---|---|---|---|
| jpeg | 85% | FAILED FLW-0024 | 93% effective util after tapcells/PDN |
| jpeg | 75% | FAILED FLW-0024 | RSZ buffer insertion pushes density > 1.0 |
| ibex | any | SKIPPED | OPENROAD_HIERARCHICAL=1 |
| riscv32i | 65% | SUCCESS | 0% hotspots — sky130hd overhead too high |

### asap7

| Design | Util | Outcome | Notes |
|---|---|---|---|
| aes | baseline | SUCCESS | 0% hotspots |
| ethmac | 85% | FAILED FLW-0024 | Only 458 instances, too small |
| jpeg | 85% | SUCCESS | 0% hotspots |
| ibex | — | NOT YET | Candidate |
| mock-alu | — | NOT YET | Candidate |
| mock-cpu | — | NOT YET | Candidate |

---

## Planned Next Steps

### Immediate

1. **Collect remaining 18 thermal label files** (run overnight):
   ```bash
   cd flow && export OR_IMAGE=openroad/orfs-ml:latest
   bash ml/congestion/data_collection/extract_thermal_batch.sh 2>&1 | tee batch_thermal.log
   ```
   Already-extracted designs (8) will be skipped. Large designs (ariane136, swerv x3, tinyRocket)
   take ~40 min each; full run will take 4–6 hours. Script now has 1-hour per-design timeout.

2. **Train U-Net once 20+ samples are collected:**
   ```bash
   cd flow && python3 ml/congestion/training/train_thermal.py \
       --data-dir ml/congestion/data \
       --checkpoint-dir ml/congestion/checkpoints \
       --epochs 200
   ```
   Checkpoint saved to `ml/congestion/checkpoints/thermal_best.pt`.
   **Note:** normalisation is now per-sample (not global) — no `thermal_norm.json` needed.

### Short term

3. **Evaluate thermal model** on held-out designs:
   ```bash
   python3 ml/congestion/inference/predict_thermal.py \
       --features ml/congestion/data/<label>_features.npz \
       --checkpoint ml/congestion/checkpoints/thermal_best.pt \
       --out predicted_thermal.npz
   ```
   Output is a relative hotspot map [0,1] — visualise with matplotlib.

4. **Add per-design evaluate loop** to `inference/evaluate.py` for thermal track.

### Medium term

5. **Power model improvement** — current thermal extractor uses cell area as a
   leakage-power proxy. Better options:
   - Use per-cell `staticPower` from Liberty (via OpenROAD STA) for process-accurate values
   - Scale total power proportional to die area so power density is constant across designs
     (fixes the unrealistic absolute temperatures caused by 500 mW fixed power on tiny asap7 dies)

6. **Expose as OpenROAD command** — once model quality is good, wrap prediction as a
   Python/Tcl callable that runs inside the ORFS flow at the placement stage.

7. **Add more designs** — asap7/ibex, asap7/mock-cpu for more thermal variety.
