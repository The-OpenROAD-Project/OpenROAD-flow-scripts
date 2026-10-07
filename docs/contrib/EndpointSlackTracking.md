# Tracking Endpoint Slack Across Flow Steps

When working on an optimization (resizing, buffering, CTS, repair timing,
...) it is useful to see how the slack of each timing endpoint moves from
one flow step to the next, not just how WNS/TNS change. ORFS can record the
setup and hold slack of every endpoint at the end of every flow step
(`1_synth`, `2_1_floorplan`, ..., `3_3_place_gp`, ..., `6_final`) and compare
any two steps, including a scatter plot of slack (x: earlier step, y: later
step).

## Recording

Set `REPORT_ENDPOINT_SLACK=1`:

``` shell
cd flow
make DESIGN_CONFIG=designs/nangate45/gcd/config.mk REPORT_ENDPOINT_SLACK=1
```

Every step then writes `$(REPORTS_DIR)/<step>_endpoint_slack.json`, e.g.
`3_3_place_gp_endpoint_slack.json`. The snapshot is taken by
`write_endpoint_slack` in `flow/scripts/util.tcl`, called from
`orfs_write_db` so the step name is the name of the `.odb` the step writes.
It works in the single-process `flow/scripts/flow.tcl` flow as well. Steps
that just copy their input (`orfs_copy_db`, e.g. `5_3_fillcell` without fill
cells) re-time the design if it is loaded, or else copy the previous step's
snapshot. Intermediate `.odb` files written through `orfs_write_db` (e.g. CTS
`save_progress`) also get a snapshot; `*-failed` ones don't.

So that all steps are timed the same way, parasitics are estimated before
reporting as in `open.tcl`, based on the step number:

| Steps | Parasitics |
| --- | --- |
| 1, 2 | none (cells are not placed) |
| 3, 4 | `estimate_parasitics -placement` |
| 5, 6 | `estimate_parasitics -global_routing` if global routes exist |

The parasitics model is recorded in each snapshot and shown by
`endpointSlack.py`. Slack changes between steps with different models (e.g.
`2_4_floorplan_pdn` to `3_1_place_gp_skip_io`, or `4_1_cts` to `5_1_grt`)
include the change of model. Detailed routing is not extracted, so
`5_2_route` and later steps show global routing estimates; `6_finish.rpt`,
which uses the extracted SPEF, can differ.

Each file contains `design`, `step`, `parasitics`, `time_unit` (seconds per
time unit of the values) and `endpoints`: a map from every endpoint pin
(`sta::endpoints`) to `[setup slack, hold slack]`, `null` where the endpoint
is unconstrained. The slack is the pin's worst slack over all path groups
and clocks (`get_property $pin slack_max|slack_min`). On asap7/swerv_wrapper
(about 30k endpoints) a snapshot is about 1 MB and takes about 10 s, mostly
the timing update.

## Analysis

`flow/util/endpointSlack.py` only uses the Python standard library.

``` shell
R=reports/nangate45/gcd/base

# Steps in execution order with parasitics, WNS, TNS and violation counts
python3 util/endpointSlack.py list $R

# Compare consecutive steps across the whole run; --html also writes a
# scatter for every step vs. its successor and an index.html to a directory
python3 util/endpointSlack.py track $R --html track

# Compare two steps; -o writes an interactive HTML scatter
python3 util/endpointSlack.py compare \
  $R/3_5_place_dp_endpoint_slack.json $R/4_1_cts_endpoint_slack.json \
  --unit ps -o compare.html

# Flatten all snapshots into one CSV (one row per endpoint per step)
python3 util/endpointSlack.py export $R -o slack.csv
```

For setup and hold, `compare` reports:

- endpoints in both steps, and how many improved, degraded, stayed the
  same, became violating (`newly failing`) or stopped violating
  (`newly passing`), with statistics of the slack change (B - A).
  Improved, degraded and unchanged exclude endpoints with positive slack in
  both steps, which are not being optimized;
- endpoints only in A or only in B, i.e. added or removed from the netlist;
- endpoints in both netlists but constrained in only one of them;
- how well the two steps agree on the critical endpoints (see below).

Unconstrained endpoints, such as the outputs of CTS dummy load cells, are
ignored.

### Agreement metrics

Correlation over all endpoints is dominated by endpoints with large positive
slack and is close to 1 even when the critical endpoints change a lot (0.9997
for setup on asap7/swerv_wrapper from `3_5_place_dp` to `4_1_cts`). The
metrics are therefore measured on a critical set: the worst K endpoints of A
or of B (`--critical K`, default 1000), excluding endpoints with positive
slack in both steps, which are not being optimized. When fewer than K
endpoints violate, the critical set is the endpoints violating in either
step; when nothing violates (often hold) it is empty and the metrics are
reported as `-`.

| Metric | Meaning |
| --- | --- |
| `spearman` | Spearman rank correlation of A and B slack (ties get average ranks): is the order of the critical endpoints preserved? |
| `top agreement` | Fraction of the critical set that is in the worst K of both steps. |
| `bias`, `MAE`, `RMSE`, `max\|delta\|` | Mean, mean absolute, root mean square and maximum absolute slack change B - A, i.e. distance from the y = x line. |
| `violator recall` | Of the endpoints violating in B, the fraction already violating in A (over all endpoints). |
| `violator precision` | Of the endpoints violating in A, the fraction still violating in B (over all endpoints). |

They are printed by `compare` and `track`, shown in the HTML stats, and
the `track` index has Spearman, top agreement and MAE columns for every step
transition.

Times are shown in `--unit` (default ns) with a fixed number of digits after
the decimal point (3 for ns, 1 for ps, or `--digits`), in a fixed-width font
in the HTML.
Slack changes smaller than half the last displayed digit (0.5 ps with the
default ns and 3 digits), or `--tolerance` in `--unit`, count as unchanged
for the improved/degraded counts, the tables of most degraded and improved
endpoints and the `track` row colors. Otherwise numerical noise, e.g. a few
femtoseconds between `5_1_grt` and `5_2_route`, shows up as changes that
display as 0.

`--worst N` restricts the endpoints in both to the union of the worst N
endpoints of A and of B, to focus on the critical part of the design.

The HTML is self-contained (no network access needed). It has:

- WNS, TNS and violation counts of both steps;
- a scatter of endpoint slack with a y = x line, where above the line means
  the endpoint improved. It is drawn on a canvas so it handles hundreds of
  thousands of endpoints. Drag to zoom, double-click to reset, hover for
  the endpoint name;
- a setup/hold toggle;
- tables of the most degraded and most improved endpoints, excluding
  endpoints with positive slack in both steps, and of the endpoints only in
  one step.

`track --html DIR` writes the same page for every step and its successor
(`<step>__<next step>.html`, with previous/next links) and `DIR/index.html`,
a table of every transition with WNS/TNS and the improved, degraded, newly
failing and newly passing counts for setup and hold. Endpoints with positive
slack in both steps are not considered. Transitions where no considered
endpoint changed (e.g. `2_2_floorplan_macro` to `2_3_floorplan_tapcell`) are
greyed out, and transitions where every considered endpoint improved, for
setup and hold, are green.

For other analyses, import the module (e.g. from a notebook):
`load_snapshot()`, `load_dir()`, `summary()`, `compare()`, `movement()`,
`metrics()` and `spearman()`
return plain Python dicts and lists.

## Testing

`flow/test/test_endpointSlack.py` covers loading and comparison with
synthetic snapshots and runs in the util CI job:

``` shell
python3 flow/test/test_endpointSlack.py
```
