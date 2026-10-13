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
| `<n>_test` | Full flow + QoR check |

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

The QoR check is the dashboard check described in
`docs/contrib/Metrics.md`. The committed `rules-base.json` files it used
to read were removed, so bazel-orfs no longer has that file to mark a
design as CI-tested. Until bazel-orfs picks another marker, its generated
test targets carry `tags = ["manual"]` for every design.

## Parallelism

Each OpenROAD invocation takes `-threads <nproc>`. A wildcard
`bazelisk test` runs designs in parallel and overcommits the host. Cap
with `--jobs=N`.
