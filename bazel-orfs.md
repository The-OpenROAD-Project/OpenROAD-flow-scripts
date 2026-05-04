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
load("@bazel-orfs//:openroad.bzl", "orfs_design")
load("@orfs_designs//:designs.bzl", "DESIGNS")

exports_files(glob(["*"]))

orfs_design(designs = DESIGNS)
```

If `flow/designs/src/<n>/BUILD.bazel` is missing, add:

```starlark
exports_files(glob(["*.v", "*.sv"], allow_empty = True), visibility = ["//visibility:public"])
filegroup(name = "verilog", srcs = glob(["*.v", "*.sv"], allow_empty = True), visibility = ["//visibility:public"])
```

A design counts as CI-tested iff `rules-base.json` exists; without it
the generated targets get `tags = ["manual"]`.

## Local bazel-orfs

Replace the `git_override` for `bazel-orfs` and `bazel-orfs-verilog` in
`MODULE.bazel` with `local_path_override` pointing at the checkout
(and `…/verilog` for the latter).

## Parallelism

Each OpenROAD invocation takes `-threads <nproc>`. A wildcard
`bazelisk test` runs designs in parallel and overcommits the host. Cap
with `--jobs=N`.
