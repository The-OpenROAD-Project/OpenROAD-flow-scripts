# Metrics

The [OpenROAD-flow-scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts)
repository contains source files (e.g., LEF/DEF, Verilog, SDC, Liberty,
RC extraction) and configuration files (e.g. `config.mk`) that enable the user to run
a small set of example designs through our complete RTL-to-GDS flow.

To keep track of the quality of the results, every CI run uploads its metrics
to the [QoR dashboard](https://dashboard.precisioninno.com). The dashboard
stores one rule per tracked metric and design (a comparison direction and a
tolerance), and judges a run against a real baseline build: the `master`
build at the run's merge base by default. That check is the QoR gate in
`make metadata`.

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
`QoR check: PASS`, `FAIL`, `INCONCLUSIVE`, or `ERROR` line.

A `FAIL` verdict fails the target. So does `ERROR`, which means
`metadata.json` was missing, malformed, or held no numeric metric. An
`INCONCLUSIVE` verdict does not fail the target: the dashboard had no
baseline for the design, evaluated nothing, or could not be reached, so the
check did not run. Read the `[WARN]` lines to see which. Pass `--strict` to
`checkQorMetrics.py` to get distinct exit codes instead (2 inconclusive,
3 unreachable).

The check runs as the commit `metadata.json` records. The dashboard searches
its default baseline pipelines in order and takes a `master` build that has the
design: the one at the commit's merge base with `master`. A commit on `master`
is its own merge base, so a run of a `master` commit, such as a downloaded CI
artifact, is compared against that commit's own build.

The dashboard finds the merge base through GitHub, so it cannot find one for a
commit that was never pushed. The check handles that commit itself: when no
remote branch in your checkout contains the commit, it computes
`git merge-base <commit> origin/master` locally and pins the baseline to that
build. A commit that is on a remote, or that is not in your checkout at all, is
left to the dashboard.

When the dashboard has no `master` build at the merge base, or no merge base,
it compares against the latest `master` build instead (the latest one before
the commit, if it knows the commit's date). That build may be newer than the
commit's base, so changes merged since then can show up as regressions or hide
real ones, and the result moves with `master`. The report warns whenever this
happens; set `DASHBOARD_BASE_COMMIT` to compare against an exact build instead.

These environment variables shape the comparison:

- `DASHBOARD_API_KEY` grants access to private platforms. Without it, a
  private design has no baseline and reports as inconclusive, not as an
  authentication error.
- `DASHBOARD_JOB_NAME` checks the run as a build of that CI pipeline instead,
  with the pipeline's rules for the branch checked out in this repository: the
  previous build on a trunk branch such as `master`, the merge base on any
  other branch. A CI job, whose checkout has no branch, also sets
  `DASHBOARD_BRANCH` and `DASHBOARD_COMMIT` (or passes `--branch` and
  `--commit`).
- `DASHBOARD_MERGE_BASE` (`--merge-base`) names the ref an unpushed commit's
  merge base is computed against, `origin/master` by default. Set it to your
  upstream ref if `origin` is a fork with an outdated `master`, or to `none` to
  leave unpushed commits to the dashboard. It does not apply together with
  `DASHBOARD_BASE_COMMIT` or `DASHBOARD_JOB_NAME`.
- `DASHBOARD_BASE_COMMIT` (`--base-commit`) pins the baseline to the build of
  that commit. Nothing else is tried: if that commit has no build of the
  design, the check is inconclusive.
- `DASHBOARD_API_URL` (`--api-url`) points the check at another deployment and
  takes precedence over `--beta`.

If you only changed synthesis, you can gate a synthesis-only run, without
running the rest of the flow. Only the `synth__` and `constraints__` metrics
are sent, so only their rules are evaluated:

``` shell
make metadata-synth
```

To check every run under `reports/` at once, call the script directly:

``` shell
cd OpenROAD-flow-scripts/flow
./util/checkQorMetrics.py                     # sweep, log in reports/inline-check.log
./util/checkQorMetrics.py --base-commit <sha> # pin the baseline build
./util/checkQorMetrics.py --verbose           # show passing rules and absent metrics
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

## Removed: golden metadata (`metadata-<variant>-ok.json`)

A design directory could also hold a `metadata-<variant>-ok.json` copy of a
known-good `metadata.json`, written by `make update_metadata`. Only
`flow/util/genReportTable.py` read it, to color a golden-versus-current
metrics table in the CI report. That table and the golden files were
removed; the script now writes only the per-design image galleries.
`make update_metadata` is a stub that prints a deprecation warning. The
baseline for a run is the `master` build on the dashboard.
