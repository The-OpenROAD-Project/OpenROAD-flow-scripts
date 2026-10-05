# Stage summaries in the log

Every flow stage ends its log with a short summary: what the stage did,
whether that is a problem, and where to look in the GUI. The GUI shows
everything, but not what to look for; the summary builds that mental
model from the log alone, and gives an issue report the numbers a
maintainer asks for first.

A healthy stage prints a few lines. A stage that failed, or that left a
problem worth fixing, also draws a picture that makes the cause visible.

## Reading a summary

```
== ORFS 2_2_floorplan_macro FAIL MPL-0065  riscv32i/asap7/mplfail - OR bazel-nostamp 0:01.70 189MB 16thr
 what: place macros in the core, leaving room for std cells
 inst 8.79k  util 85.8%  macros 4  setup ws -956 tns -993k
 area 2.48kum^2  hold ws 33 tns 0  (time in ps)
 vars: CORE_UTILIZATION=85* CORE_MARGIN=5 PLACE_DENSITY_LB_ADDON=0.10
       RTLMP_MIN_CHANNEL_SIZE=8,8 TNS_END_PERCENT=100 (*make cmdline)
 error: The movable cells do not fit in the macro placement area.
 why: macros+std cells need 158% of core
 +--------------------------------+  core 54x54um = 2.9k um^2
 |                                |  macros 4, 49% of core
 |  +-------+-------+--------+-+  |  macros+ch  #################....... 113%
 |  |.+---+.|.+---+.|.+----+.|:|  |  std/dens   #######.................  45%
 |  |.|A  |.|.|A  |.|.|A   |.|:|  |  total      ######################## 158%
 |  |.|   |.|.|   |.|.|    |.|:|  |                            ^ core full
 |  |.|   |.|.|   |.|.|    |.|:|  |  1 macro left over:
 ...
 |  +--------------------------+  |
 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|
 +--------------------------------+
 packed by area, what fits?  : std cells at density 0.82  X 58% of core over
 warn 1003 (STA-1212 x1001, GPL-0302 x1, ORD-0012 x1)  err 1
 issue: make macro_place_issue  (packages this stage to reproduce)
 GUI: make gui_2_1_floorplan; lower CORE_UTILIZATION or PLACE_DENSITY, or
      RTLMP_MIN_CHANNEL_SIZE
```

- **Header**: the stage, its verdict (`OK`, `WARN`, `FAIL` and the
  message ID), design/platform/variant, OpenROAD version, runtime, peak
  memory and threads. Every summary starts with `== ORFS`, so
  `grep '^== ORFS' logs/.../*.log` lists the whole run.
- **what**: what the stage is for, for readers new to the flow.
- **Key metrics**: the same two lines on every stage (instances,
  utilization, macros, area, setup and hold worst slack, TNS and
  violating endpoints), with the change this stage made in parentheses.
  Reading them down the log shows where a number started to go wrong.
  Dim values were carried over from an earlier stage.
- **vars** (on `WARN` and `FAIL`): the settings the design config or the
  make command line (`*`) chose that this stage reads.
- **error** and **why**: the stage's error, and what the picture found.
- **The picture**: one per stage concern, below.
- **Footer**: warnings by message ID, the `make <script>_issue` target
  that packages a reproducer, and a `GUI:` line saying which target to
  open, which view, and where to zoom.

## What each stage draws

| Stage | Picture | Warns when |
|---|---|---|
| `2_2_floorplan_macro` | Macros to scale in the core. On failure: packed by area with half of `RTLMP_MIN_CHANNEL_SIZE` around each, std cells poured in at the placer's density, the excess spilling out of the core, and an area budget. | — (explains `MPL` failures) |
| `3_3_place_gp` | Cell density and RUDY wire demand maps, overflow and HPWL sparklines, target density, timing-driven and routability area. | target density below what the design can reach (GPL-0302), routability inflation over 20%, ending with cells still overlapping |
| `5_1_grt` | Routing use/capacity over all layers on the die with overflow as `X`, the worst hotspots numbered, a per-layer table, and the placement density under the worst hotspot: local pile-up or design-wide shortage. | any overflow |
| `5_2_route` | DRC count per iteration, on a log scale; when DRCs remain, by type and where, over the global route congestion map. | DRCs left |
| timing stages | Setup and hold endpoint slack histograms; zero is a bin edge, so the bins left of `\|` are the violators. | the stage cost more than a tenth of the clock period of setup slack, or hold violations remain after CTS |
| `4_1_cts` | Each clock net: sinks, tree and leaf buffers, levels, buffers from sink to root, fanout distribution; skew and hold repair. | skew over 10% of the period, hold buffers over 5% of instances, a tree unbalanced by more than two buffers |
| `6_report` | Always: signoff numbers, each key metric through the flow with the stage that moved it the wrong way most, and the longest stages. | — |

A failure is explained by the picture for the tool that raised it (the
message ID prefix), else by the stage's own picture.

Negative slack alone, or busy but not overflowing gcells, do not warn:
many designs are over-constrained on purpose, and asap7 M2 runs hot on
healthy designs. A warning that fires on healthy runs teaches people to
ignore it.

## Terminal and log

The log always gets plain 7-bit ASCII at 80 columns, so it reads the
same in CI, in an issue and in `grep`. An interactive terminal gets the
same summary in colour, drawn with [rich](https://github.com/Textualize/rich):
heat maps in viridis with two rows per character, solid macro blocks,
sparklines. Colour never carries anything the ASCII lacks. rich is
optional (`pip install rich`); without it the terminal gets the ASCII and
a one-line hint to install it. `NO_COLOR` and `FORCE_COLOR` work as
usual.

## Turning it off

`SKIP_STAGE_ART=1` skips both the snapshot and the summary; see
[Flow Variables](FlowVariables.md#SKIP_STAGE_ART).

## Drawing a summary again

The summary is drawn from what the stage left behind, so it can be drawn
again, or worked on, from a finished run:

```
python3 flow/util/stage_art.py --stage 5_1_grt --no-log --full \
    --log-dir flow/logs/asap7/gcd/base --reports-dir flow/reports/asap7/gcd/base
```

- `--no-log`: print only, do not append to the log.
- `--full`: draw the picture even when all is well.
- `--svg FILE`: also save the colour rendering as SVG.

## How it works

`flow.sh` runs each stage script through `scripts/run_stage.tcl`, which
sources it and then calls `stage_art_snapshot` from
`scripts/stage_art.tcl`. On failure it snapshots the design as it was
when the error hit, then re-raises the stage's error unchanged. The
snapshot, `$REPORTS_DIR/<stage>.art.json`, is a few KB whatever the
design size: the probes listed for the stage in `::stage_art_probes`
read the in-memory design through plain odb, sta and grt calls, so they
work without the GUI, and bin maps to a fixed grid.

`flow.sh` then runs `util/stage_art.py`, which reads the snapshot, the
stage's metrics (`$LOG_DIR/<stage>.json`, and earlier stages' for the
changes) and its log. Where both say something, it prefers what the
stage actually ran with, e.g. the `rtl_macro_placer` command line in the
log over the environment.

## Known issues

Found while building this, not fixed here:

- The OpenROAD GUI's power density heat map adds switching power for
  its "Leakage" option and leakage power for its "Switching" option
  (`src/web/src/heatMapCore.cpp`, `PowerDensityDataSource`).
- Warning counts per message ID in the metrics can exceed both the
  total and what the log shows: on asap7, `flow__warnings__count` is 12
  while `flow__warnings__count:STA-1212` is 1001, the liberty reader's
  "timing group from output port" warnings that the log suppresses. The
  summary's warning line adds up the per-ID counts.
- OpenSTA's `with_output_to_variable` evaluates its body in its own
  scope and swallows errors, so a body that uses the caller's variables
  silently captures nothing. `stage_art.tcl` passes it a command with
  the variables already substituted.
- From `5_3_fillcell` on, the key metrics' instance count includes
  filler cells; the final report's trend leaves them out.
- Stages run in one OpenROAD process (`scripts/flow.tcl`) and the Yosys
  stages do not get a summary: they do not go through `flow.sh`.

## Adding a picture

A picture is a function in a `util/stage_art_*.py` module, listed in
`PANEL_MODULES` in `util/stage_art.py`:

```python
from stage_art import panel


@panel(stems=["3_5_place_dp"], tools=["DPL"])
def panel_detail_place(doc, st):
    """Detailed placement: how far cells moved to become legal."""
    moved = st.metrics.get("dpl__instance__displacement__max")
    if moved is None:
        return None, None
    doc.add(" max displacement %.1fum" % moved)
    if moved > 10:
        return "cells moved up to %.0fum" % moved, "make gui_3_5_place_dp"
    return None, None
```

It returns a reason, which makes the stage `WARN` (or explains a
`FAIL`), and a `GUI:` hint. Data it needs from the design goes in a
`stage_art_<probe>` proc in `scripts/stage_art.tcl` and in the stage's
probe list. `Frame` draws the die to scale, with `heat` maps, `box`,
`outline` and `mark`. Tests in `flow/test/test_stage_art.py` render
trimmed copies of real runs from `flow/test/stage_art/` and check that
each picture shows what it is for.
