# Command arguments

ORFS runs OpenROAD commands such as `global_placement`,
`clock_tree_synthesis` and `detailed_route`. To change what one of them is
called with, set the variable named after the command, in upper case, with
`_ARGS` after it. It holds only what you want different, written with the
command's own options, as the command's help prints them:

```make
export CLOCK_TREE_SYNTHESIS_ARGS = -sink_clustering_size 30 ~-repair_clock_nets
export REPAIR_TIMING_ARGS        = -setup_margin 0.05 grt:-setup_margin 0.1 floorplan:off
export REPORT_METRICS_ARGS       = off cts:on
```

The flow's own arguments stay, except where you change them. The log shows
the command as it ran and, for each edit that changed it, the call, the edit
and the variable it came from:

```
[cts.main] clock_tree_synthesis: -sink_clustering_size 30 (CLOCK_TREE_SYNTHESIS_ARGS)
[cts.main] clock_tree_synthesis: ~-repair_clock_nets (CLOCK_TREE_SYNTHESIS_ARGS)
clock_tree_synthesis -sink_clustering_enable -sink_clustering_size 30
```

## The grammar

| Written | Meaning |
|---|---|
| `-option value` | set the value |
| `-flag` | add the flag |
| `~-option` | delete the option, and its value if it has one, where it is passed |
| `on` / `off` | run the command / don't run it |
| `stage:` in front of any of these | only in that stage: `synth`, `floorplan`, `place`, `cts`, `grt`, `route` or `final` |
| `stage.call:` in front | only at that call (see the table below) |
| `{a b}` or `"a b"` | a value with spaces in it, as in Tcl |

Within one variable, a call edit beats a stage edit, a stage edit beats an
unscoped one, and later beats earlier. A syntax error stops the flow before
the stage runs, with a message that says where it is.

## Layers

| From highest to lowest | Where |
|---|---|
| `<COMMAND>_ARGS` | a design's `config.mk`, a `FLOW_VARIANT` block, the command line or the shell environment |
| deprecated variables | `CTS_CLUSTER_SIZE` and the others, wherever they are set |
| `PLATFORM_ARGS` | a platform's `config.mk` |
| the flow | ORFS's own arguments, written in the stage scripts |
| nothing passed | OpenROAD's own default |

For each option, the highest layer that mentions it decides. Make picks each
variable's value first, as for every ORFS variable
([Flow Variables](./FlowVariables.md)): `make REPAIR_TIMING_ARGS=...` on the
command line replaces the design's whole value of that variable, and the
layers below it stay.

A platform sets its defaults in one variable, each edit starting with the
command it is for:

```make
export PLATFORM_ARGS = rtl_macro_placer:-min_channel_size {20 20} \
                       detailed_route:-disable_via_gen
```

## Use cases

A design changes clock tree synthesis:

```make
export CLOCK_TREE_SYNTHESIS_ARGS = -sink_clustering_size 30
```

A flow variant skips repair before CTS and reports only at CTS:

```make
ifeq ($(FLOW_VARIANT),fast)
  export REPAIR_TIMING_ARGS  = floorplan:off place:off
  export REPORT_METRICS_ARGS = off cts:on
endif
```

A one-off experiment from the command line, quoted for the shell:

```sh
make DESIGN_CONFIG=designs/asap7/gcd/config.mk REPAIR_TIMING_ARGS='grt:-setup_margin 0.1'
```

The same from the shell environment, used when the design doesn't set the
variable with `=`:

```sh
export REPORT_METRICS_ARGS='off cts:on'
make DESIGN_CONFIG=designs/asap7/gcd/config.mk
```

## Commands and calls

| Command | Calls |
|---|---|
| `balance_row_usage` | `place.main` |
| `buffer_ports` | `place.main` |
| `clock_tree_synthesis` | `cts.main` |
| `cluster_flops` | `place.main` |
| `detailed_placement` | `place.main`, `cts.main`, `cts.repair_timing`, `grt.repair_design`, `grt.repair_timing` |
| `detailed_route` | `route.main` |
| `global_placement` | `place.skip_io`, `place.main` |
| `global_route` | `grt.main`, the first route; the incremental routes after repair take `-allow_congestion` from it |
| `improve_placement` | `place.main` |
| `place_pins` | `place.main` |
| `repair_antennas` | `grt.main`, `route.main` |
| `repair_design` | `place.main`, `grt.main` |
| `repair_tie_fanout` | `floorplan.tielo`, `floorplan.tiehi` |
| `repair_timing` | `floorplan.main`, `place.main`, `cts.main`, `grt.main`, `grt.wns`, `grt.recover_power` |
| `report_metrics` | named after the report: `cts.cts_final` for the report "cts final", `grt.global_route_post_repair_timing`, ... |
| `rtl_macro_placer` | `floorplan.main` |

`report_metrics` takes only `on` and `off`.

## Deprecated variables

The variables that passed one option to one command, or switched one step on
or off, are deprecated. Each still works, ranks between `PLATFORM_ARGS` and
`<COMMAND>_ARGS`, and warns with the line that replaces it:

```
[WARNING] CTS_CLUSTER_SIZE=30 is deprecated: write CLOCK_TREE_SYNTHESIS_ARGS = -sink_clustering_size 30
```

[Flow Variables](./FlowVariables.md) lists each one with its replacement.
`CTS_ARGS` and `RTLMP_ARGS` still replace the flow's arguments, and
`DETAILED_ROUTE_ARGS` does too while it holds a plain command line, with no
`~`, `on`, `off` or scope; when that command line differs from the same text
read as edits, the log says which `~-option` deletions keep it.

## Implementation

`flow/scripts/args_grammar.bzl` is the grammar, written in the subset of
Python that is also Starlark, so a Bazel build can `load()` it: to stop at
analysis on a syntax error, and to give each stage only its own edits.
`flow/scripts/args.py` runs it for the stage scripts, which call it through
`command_args` and `command_runs` in `flow/scripts/util.tcl`.
`flow/test/test_args.py` tests both.
