# E12: a clustered global-place scorer for macro-placement selection

## The question

A macro placement is a draw from a distribution, not an optimum. Seeding
RTL-MP (`rtl_macro_placer -random_seed`) on asap7 `swerv_wrapper` gives 24
placements whose downstream macro-path timing spans ~300 ps, and the
placer's own annealing cost cannot tell which is which: it predicts area,
not period. Selection therefore needs a *score* measured after the fact.

The established score is a fast global placement over every standard
cell, timing- and routability-driven off — the **flat** rung. It ranks
the ground truth (macro-path mean, measured at global route after the
entire production tail) at Spearman **rho +0.72 [0.48, 0.84]**.

**E12 asks whether that placement can be run on RTL-MP's own std-cell
clusters instead** — roughly an order of magnitude fewer movables — and
still rank. Ranking is the only requirement. A scorer that is uniformly
20% optimistic ranks perfectly; rank inversions are the enemy, absolute
error never was.

## The gate

One criterion, fixed before the first run:

> rho(clustered HPWL vs grt `macro_paths_mean`) must land inside the flat
> scorer's interval, **[0.48, 0.84]**, over all 24 candidates.

A failing verdict is a result. The truth includes
`repair_design`/`repair_timing`/CTS/route, so rho(clustered) − rho(flat)
*is* the measured price of the abstraction, repair-blindness included.
Note that a clustered netlist forfeits the repair rung structurally —
`repair_timing` works on real cells, not soft clusters — so any gap gets
closed by field surrogates or by promoting survivors to the flat rung,
never by running repair on clusters.

Two gates run in order, and gate 0 comes first for a reason: the
candidate placements were never archived, only their scores, so this
experiment regenerates them. Until the regenerated flat scores reproduce
the archived ones, any clustered number is measuring the rig.

| Gate | Question | Failure means |
|---|---|---|
| 0 | Do the regenerated flat scores reproduce `score_vs_flow_swerv.json` exactly? | The rig drifted (different OpenROAD, lost patch, different floorplan). Stop. |
| 1 | Is rho(clustered) inside [0.48, 0.84] over 24/24 candidates? | The reduction costs ranking accuracy. Report it. |

## Pre-registered configuration

At n = 24 a Spearman interval is roughly ±0.2 wide, so choosing the best
of several settings after seeing the numbers would be selection on noise
and would void the gate. **These values define the gate run:**

| Setting | Value | Why it is not a knob |
|---|---|---|
| `E12_HALO_HOPS` | 1 | Cells within one hop of a macro pin stay individual movables. Clustering smears exactly the pin geometry the live KPI reads; the hop count is a small integer, not a searched value. |
| `E12_OVERFLOW` | 0.6 | A dimensionless placement invariant. Ranking power was measured to saturate by overflow ~0.6, so the convergence tail buys nothing. Validated once, against archived trajectories. |
| `E12_LARGE_NET_THRESHOLD` | 50 | The value RTL-MP's own clustering uses to ignore global nets. Mirrored rather than chosen. |
| `E12_BIN_GRID_COUNT` | 0 (gpl's own default) | Not tuned for the gate run. |
| cluster level | leaf clusters only | Interior nodes of the hierarchy would double-count their descendants. |
| score readout | full signal-net HPWL | The flat rung's scalar, for a like-for-like comparison. |
| build | non-GPU | Determinism holds only there; the GPU HPWL/scatter backends are documented as thread-order tolerant. |

Everything else — hops 0 and 2, the macro cone readout, `-bin_grid_count`
sweeps, `-disable_pin_density_adjust`, filler coarsening, net bundling —
is **exploratory**, reported as a rho-versus-cost curve. A setting that
beats the primary earns a second, pre-registered confirmation run; it
does not get retroactively promoted.

## Why the coarsening is applied once, on the base floorplan

The cluster partition comes from connectivity and module hierarchy, not
from macro positions, so it is derived once from the shared base
floorplan and reused by every candidate. That is not only a saving. It
means every candidate is scored through the *identical* coarsening, so
the distortion the reduction introduces is common-mode — and common-mode
distortion does not create rank inversions. A partition re-derived per
candidate would, and must not be used however tempting.

## Running it

Every flow target is a `bazelisk run` executable taking `KEY=VALUE`
overrides, and every one of them needs `E12_OUT_DIR` — the evidence
directory is an input to the analysis, not a build artifact, so it is
named explicitly rather than declared as an output.

```sh
EV=$PWD/e12_evidence          # anywhere outside the source tree
mkdir -p "$EV"

# Step 0 -- regenerate the candidates and re-measure them flat. Writes
# cand_s<N>.{json,place.tcl,odb} and base_floorplan.{odb,sdc}.
#
# Candidates run SERIALLY on the bazel-orfs pin ORFS currently uses: the
# fork facility that makes them cheap is not present, and the script
# detects that and falls back rather than failing. The upstream campaign
# measured 65 candidates/h forked against 23.8 serial, so budget hours
# rather than the ~25 minutes a forked run takes -- or start with E12_K=1.
bazelisk run //flow/test/macro_e12:swerv_candidates -- E12_OUT_DIR=$EV

# Probe first. One candidate is enough to exercise every step below, and
# it is what the pre-campaign checks need.
bazelisk run //flow/test/macro_e12:swerv_candidates -- E12_OUT_DIR=$EV E12_K=1

# Step 1 -- dump RTL-MP's cluster partition from the base floorplan, once.
bazelisk run //flow/test/macro_e12:swerv_dump_clusters -- E12_OUT_DIR=$EV

# Step 2 -- score ONE candidate per process. This is mandatory, not
# stylistic: gpl's Replace::reset() does not clear its cluster list, and
# gpl writes GCell locations back into odb, so process isolation is what
# makes scoring report-only.
for seed in $(seq 0 23); do
  bazelisk run //flow/test/macro_e12:swerv_score_clustered -- \
      E12_OUT_DIR=$EV E12_TAG=cand_s$seed
done

# Step 3 -- the verdict.
bazelisk run //flow/test/macro_e12:grade_e12 -- \
    --truth $PWD/flow/test/macro_e12/score_vs_flow_swerv.json \
    --evidence-dir $EV --out $EV/e12_verdict.json
```

### Check seed 0 before spending the campaign

Score one candidate and read it against the early-kill criteria:
**overflow never reaching 0.6**, or gpl reporting divergence. A diverged
candidate must be recorded as a failure and never scored — gpl silently
reverts to its minimum-HPWL snapshot, which yields a number that looks
like a score and is not one.

Read `clusters_declared` and `clustered_insts` in the leaf at the same
time. If the movable count barely fell, the reduction is being cancelled
somewhere and there is no point measuring 24 of them yet.

### The determinism check, before the campaign and not after

The scores must be bit-identical across thread counts. That should hold
by construction — gpl's density scatter accumulates into int64 bins, so
the sum is over a fixed multiset — but "should" is not a measurement:

```sh
for t in 1 2 8 8; do
  bazelisk run //flow/test/macro_e12:swerv_score_clustered -- \
      E12_OUT_DIR=$EV E12_TAG=cand_s0 E12_THREADS=$t
  mv $EV/cand_s0.clustered.json $EV/cand_s0.t$t.$RANDOM.json
done
# hpwl_dbu and cone_hpwl_dbu must be identical in all four files.
grep -h '"hpwl_dbu"\|"cone_hpwl_dbu"' $EV/cand_s0.t*.json | sort -u
```

Two runs at t=8 are included on purpose: they separate genuine
thread-count sensitivity from plain run-to-run irreproducibility.

The gate's own logic is tested without OpenROAD at all:

```sh
bazelisk test //flow/test/macro_e12:grade_e12_test
```

That test also recomputes five published numbers from the committed
archive (+0.72, +0.82, +0.57, +0.65, +0.47). If it fails, the archive or
the statistics moved and every E12 number is void.

## Files

| File | Role |
|---|---|
| `macro_e12.tcl` | Step 0: candidate generation plus the flat control rung. |
| `dump_clusters.tcl` | Step 1: RTL-MP's cluster partition, from `-keep_clustering_data`. |
| `score_clustered.tcl` | Step 2: the clustered scorer. |
| `e12_lib.tcl` | Shared helpers: the macro-pin BFS, the HPWL readout, leaf writing. |
| `extract_lib.tcl` | The KPI instrument, vendored verbatim. Do not "improve" it: the archived numbers were measured with it. |
| `grade_e12.py` | Step 3: the gate. |
| `e12_stats.py` | Spearman and bootstrap CI, vendored verbatim, stdlib only. |
| `score_vs_flow_swerv.json` | The committed archive: 24 candidates, ground truth and flat score. |

## What is deliberately not here

`rtl_macro_placer -candidates k` — clustering once, racing k seeded
anneals in-process under a knob-free dominance rule and committing
exactly one winner — is the point of all this, and it belongs in
OpenROAD rather than in an ORFS patch. It is planned only if this gate
passes, which is the whole reason the gate exists.
