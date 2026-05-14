# bazel-orfs

Bazel front-end for the ORFS Make flow. Designs declared via
`config.mk` are exposed as Bazel targets through
[bazel-orfs](https://github.com/The-OpenROAD-Project/bazel-orfs).

## Targets

For a design at `flow/designs/<platform>/<design>/` with `DESIGN_NAME =
<n>`:

| Target | Output |
|---|---|
| `<n>_synth` | Yosys synthesis |
| `<n>_floorplan` | Floorplan + I/O placement |
| `<n>_place` | Placement |
| `<n>_cts` | Clock tree synthesis |
| `<n>_grt` | Global routing |
| `<n>_route` | Detailed routing |
| `<n>_final` | Final + fill |
| `<n>_generate_abstract` | LEF/LIB abstract |
| `<n>_test` | Full flow + QoR check against `rules-base.json` |
| `<n>_update` | Rebuild and write thresholds back to `rules-base.json` |

Stages depend on the previous, so `_final` runs the whole flow.

```bash
bazelisk build //flow/designs/asap7/gcd:gcd_synth
bazelisk test  //flow/designs/asap7/gcd:gcd_test
bazelisk run   //flow/designs/asap7/gcd:gcd_update
bazelisk query //flow/designs/asap7/...:*
```

## Adding a design

```starlark
# flow/designs/<platform>/<design>/BUILD.bazel
load("//flow/designs:design.bzl", "design")

design()
```

If `flow/designs/src/<n>/BUILD.bazel` is missing, add:

```starlark
load("//flow/designs:design.bzl", "files")

files("verilog")
```

A design counts as CI-tested iff `rules-base.json` exists; without it
the generated targets get `tags = ["manual"]`.

## Parallelism

Each OpenROAD invocation takes `-threads <nproc>`. A wildcard
`bazelisk test` runs designs in parallel and overcommits the host. Cap
with `--jobs=N`.

## Running a full sweep without overburdening the host

To verify every design under one or more platforms (e.g. before
bumping `bazel-orfs` or `tools/yosys`), drive `bazelisk test` per
platform with `--keep_going` so one failure doesn't mask the rest,
and split big designs into their own invocations so routing/synth
don't overcommit RAM.

```bash
# 1. Install the make-flow toolchain too, so failures can be
#    cross-checked against `make DESIGN_CONFIG=...`.
(cd tools/OpenROAD && bazelisk run //:install)

# 2. List actual test targets per platform (capture before running
#    so the sweep is reproducible).
bazelisk query 'tests(//flow/designs/asap7/...)'
bazelisk query 'tests(//flow/designs/sky130hd/...)'

# 3. Small/fast designs in one parallel invocation; each big design
#    in its own sequential invocation. 16-core / 30 GiB box:
bazelisk test --keep_going \
  //flow/designs/asap7/aes/... //flow/designs/asap7/gcd/... \
  //flow/designs/asap7/uart/... //flow/designs/sky130hd/gcd/...   # etc.

for big in cva6 ibex jpeg riscv32i swerv_wrapper; do
  bazelisk test --keep_going //flow/designs/asap7/${big}/...
done
```

Heuristic: hierarchical / RISC-V cores / image-processing designs
run solo; everything else batches. Use `--jobs=N` to cap parallel
OpenROAD invocations if the host still thrashes.

## Triaging a failing `_test`

For each failing `<design>_test`, decide which bucket it falls into:

1. **Trivial config fix.** Missing variable in
   `flow/scripts/variables.yaml`, a typo in `config.mk`, a missing
   `exports_files()` for a cross-design SDC/Verilog reference, etc.
   Fix in place; `variables.yaml` is the single source of truth
   bazel-orfs validates against.

2. **Yosys-environment false positive (OpenROAD is idempotent given
   the same netlist).** Bazel-built yosys and make-built yosys
   produce different `1_2_yosys.v` for the same RTL, and that
   netlist drift can move QoR past `rules-base.json` thresholds
   even when OpenROAD itself is bit-deterministic. Confirm with:

   ```bash
   bazelisk run @bazel-orfs//:make-yosys-netlist \
       //flow/designs/asap7/<design>:<design>_test
   ```

   All stages MATCH in the `bazel+make-netlist` column → false
   positive, ignore (or relax the threshold). Any DIFFER → real
   bazel-vs-make OpenROAD divergence — file the per-stage SHA
   matrix as an issue. `@bazel-orfs//:yosys-check` is the
   reverse-direction wrapper (bazel's netlist into make).

   Full workflow + interpretation, the `SYNTH_NETLIST_FILES` manual
   override, and the `BLOCKS=` caveat live in
   [`@bazel-orfs//:TESTING.md`](https://github.com/The-OpenROAD-Project/bazel-orfs/blob/main/TESTING.md)
   under "Debugging OpenROAD determinism (bazel vs make)".

3. **Real bug (both flows fail at the same stage).** `.odb` SHAs may
   still differ (yosys version) but the failure mode matches.
   Generate an issue tarball from the make flow:

   ```bash
   cd flow
   make <stage>_issue DESIGN_CONFIG=designs/<plat>/<design>/config.mk \
                      ISSUE_TAG=<plat>-<design>-<short>
   ```

   `flow/util/utils.mk` auto-generates `<script>_issue` targets for
   every script in `flow/scripts/` (`floorplan_issue`,
   `global_route_issue`, `detail_route_issue`, `final_issue`, …).
