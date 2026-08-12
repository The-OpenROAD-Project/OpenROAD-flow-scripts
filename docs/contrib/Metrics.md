# Metrics

The [OpenROAD-flow-scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts)
repository contains source files (e.g., LEF/DEF, Verilog, SDC, Liberty,
RC extraction) and configuration files (e.g. `config.mk`) that enable the user to run
a small set of example designs through our complete RTL-to-GDS flow.

To keep track of the quality of the results, each design directory holds a
rules file that gates the flow:

``` text
flow/designs/<platform>/<design>/rules-base.json
```

The file name comes from `RULES_JSON`, defined in
[`flow/util/utils.mk`](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/blob/master/flow/util/utils.mk):

``` makefile
export RULES_JSON ?= $(DESIGN_DIR)/rules-$(FLOW_VARIANT).json
```

`FLOW_VARIANT` defaults to `base`, which is why the committed file is
`rules-base.json`. A run with a non-default `FLOW_VARIANT` looks for
`rules-<variant>.json`, or you can point `RULES_JSON` at any file explicitly.

Each entry in the rules file is a metric name, a reference value, and a
comparison operator. For example:

``` json
{
    "synth__design__instance__area__stdcell": {
        "value": 43.1,
        "compare": "<="
    },
    "detailedplace__design__violations": {
        "value": 0,
        "compare": "=="
    }
}
```

An entry may also carry `"level": "warning"`, which reports a mismatch without
failing the build.

The values a run is measured against are collected by
`flow/util/genMetrics.py` into `$(REPORTS_DIR)/metadata.json`
(`reports/<platform>/<design>/<variant>/metadata.json`). That file is generated
output — it is not committed. `flow/util/checkMetadata.py` compares it against
the rules file.

## Checking against the rules

The evaluation checks key metrics (e.g., worst slack, number of DRCs) to
ensure that changes do not degrade the results.

After you make a significant change — e.g., fixing a bug in a piece of code, or
changing a configuration variable such as `PLACE_DENSITY` — review the results
and compare them against the rules. To perform the check, run:

``` shell
cd OpenROAD-flow-scripts/flow
# clean_metadata is only required if you need to re-run the check
make [clean_metadata] metadata
```

`make metadata` runs three steps in order: `finish` (the full flow),
`metadata-generate` (write `metadata.json`), and `metadata-check` (compare it
against `RULES_JSON`). The check log is written to
`$(REPORTS_DIR)/metadata-check.log`.

If you only changed synthesis, you can gate a synthesis-only run against the
synthesis subset of the same rules file, without running the rest of the flow:

``` shell
make metadata-synth
```

If the check reports any error, review it to make sure the change in metrics is
expected and justifiable. If so, proceed to the next section to update the
reference values.

## Update process

Updating the rules file is mandatory if a metric became worse than the value
allowed by `rules-base.json` (see the previous section on how to perform the
check). It is also a good idea to update it when your change improves a metric,
so that the improvement is not silently lost later.

To update the rules file for a design, from a tree that has just been measured
(so `metadata.json` exists):

``` shell
cd OpenROAD-flow-scripts/flow
make update_ok
```

`update_ok` is an alias for `update_rules`. It runs `flow/util/genRuleFile.py`
with `--failing --tighten`, which:

- relaxes rules the current run fails, using the measured value plus a margin,
  so that small run-to-run variation does not break the flow; and
- tightens rules the current run passes by a wide margin, so improvements are
  locked in.

The new file is written to `$(REPORTS_DIR)/rules.json` and then copied over
`$(RULES_JSON)` — that copy is the file you commit.

If you need to overwrite every rule from the current run rather than only the
failing and improved ones, use:

``` shell
make update_rules_force
```

This runs `genRuleFile.py --update`. Prefer `make update_ok`; use the forced
variant only when the metric set itself changed.

## Reference metadata (`metadata-<variant>-ok.json`)

There is a second, optional file per design:

``` shell
# writes flow/designs/<platform>/<design>/metadata-base-ok.json
make update_metadata
```

This copies the current `metadata.json` next to the design as
`metadata-$(FLOW_VARIANT)-ok.json`. It is **not** what gates the flow — nothing
in `make metadata` reads it. It is consumed only by
`flow/util/genReportTable.py` when building the golden-vs-current report table,
and almost no design commits one. Update the rules file, not this one, unless
you are specifically working on that report.
