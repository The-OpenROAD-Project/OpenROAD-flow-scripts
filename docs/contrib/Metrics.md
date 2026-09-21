# Metrics

The [OpenROAD-flow-scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts)
repository contains source files (e.g., LEF/DEF, Verilog, SDC, Liberty,
RC extraction) and configuration files (e.g. `config.mk`) that enable the user to run
a small set of example designs through our complete RTL-to-GDS flow.

To keep track of the quality of the results, every CI run uploads its metrics
to the [QoR dashboard](https://dashboard.precisioninno.com). The dashboard
stores one rule per tracked metric and design (a comparison direction and a
tolerance), and judges a run against a real baseline build: the latest
`master` build by default. That check is the QoR gate in `make metadata`.

The values a run is measured against are collected by
`flow/util/genMetrics.py` into `$(REPORTS_DIR)/metadata.json`
(`reports/<platform>/<design>/<variant>/metadata.json`). That file is generated
output — it is not committed. `flow/util/checkQorMetrics.py` sends its numeric
values to the dashboard and reports the verdict.

## Checking against the dashboard

The evaluation checks key metrics (e.g., worst slack, number of DRCs) to
ensure that changes do not degrade the results.

After you make a significant change — e.g., fixing a bug in a piece of code, or
changing a configuration variable such as `PLACE_DENSITY` — review the results
and compare them against the baseline. To perform the check, run:

``` shell
cd OpenROAD-flow-scripts/flow
# clean_metadata is only required if you need to re-run the check
make [clean_metadata] metadata
```

`make metadata` runs three steps in order: `finish` (the full flow),
`metadata-generate` (write `metadata.json`), and `metadata-check` (send it to
the dashboard). The check log is written to
`$(REPORTS_DIR)/metadata-check.log`. It lists every failed rule with the
baseline value, the current value, the limit, and the delta, and ends with a
`QoR check: PASS`, `FAIL`, or `INCONCLUSIVE` line.

A `FAIL` verdict fails the target. An `INCONCLUSIVE` verdict does not: the
dashboard had no baseline for the design, evaluated nothing, or could not be
reached, so the check did not run. Read the `[WARN]` lines to see which.
Pass `--strict` to `checkQorMetrics.py` to get distinct exit codes instead
(2 inconclusive, 3 unreachable).

Two environment variables shape the comparison:

- `DASHBOARD_API_KEY` grants access to private platforms. Without it, a
  private design reports as inconclusive, not as an authentication error.
- `DASHBOARD_JOB_NAME` names the Jenkins pipeline whose `master` builds are the
  baseline. The default is `OpenROAD-flow-scripts-Public`.

If you only changed synthesis, you can gate a synthesis-only run, without
running the rest of the flow. Only the `synth__` and `constraints__` metrics
are sent, so only their rules are evaluated:

``` shell
make metadata-synth
```

To check every run under `reports/` at once, or to pin the baseline to a
specific commit, call the script directly:

``` shell
cd OpenROAD-flow-scripts/flow
./util/checkQorMetrics.py                     # sweep, log in reports/inline-check.log
./util/checkQorMetrics.py --base-commit <sha> # pin the baseline build
./util/checkQorMetrics.py --verbose           # show passing rules too
```

If the check reports a failed rule, review it to make sure the change in
metrics is expected and justifiable. If so, say so in the pull request: the
baseline moves with `master`, so a merged change becomes the new baseline
without a file update. Rule tolerances live in the dashboard, not in this
repository.

## Removed: rules files (`rules-<variant>.json`)

Before the dashboard check, each design directory held a
`rules-<variant>.json` file with absolute limits, and
`flow/util/checkMetadata.py` compared `metadata.json` against it. Those
files, that script, `flow/util/genRuleFile.py`, and the `RULES_JSON`
variable were removed. The make targets `update_ok`, `update_rules`, and
`update_rules_force` still exist as stubs that print a deprecation warning
and do nothing, so an old wrapper script does not break. Rule tolerances
live in the dashboard, so there is nothing to regenerate locally after an
accepted QoR change.

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
and almost no design commits one.
