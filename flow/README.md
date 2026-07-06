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

## Logic equivalence checking (LEC)

Every design gets per-stage
[kepler-formal](https://github.com/keplertech/kepler-formal)
equivalence checks, all tagged `manual`:

| Target | Checks |
|---|---|
| `<n>_lec_synth` | Canonicalized RTL (`<n>_canon_v`, written from the yosys canonicalize checkpoint) vs the yosys synthesis netlist — SEC, using kepler-formal's pre-synthesis `.v` support. A failure implicates synthesis, not canonicalization. |
| `<n>_lec_<stage>` | Adjacent-pair gate-level LEC along the flow: synth↔floorplan, floorplan↔place, place↔cts, cts↔route, route↔final, on netlists written from each stage's `.odb` (physical-only cells removed). |
| `<n>_syn_lec_synth` | Flat designs only: the OpenROAD built-in synth (`_syn` variant) netlist vs the same canonicalized RTL. |

Each check runs kepler-formal at **build** time (`lec_check`; the
verdict and log are cached build artifacts) and pairs with an instant
`<target>_test` that only asserts the recorded verdict, so `bazelisk
test` sweeps never time out on SAT runtimes. Build first — SAT solving
is memory-hungry, so cap parallelism per the section above — then run
the tests:

```bash
bazelisk build //flow:lec_check --jobs=4   # or individual <n>_lec_* targets
bazelisk test  //flow:lec_test
```

Hierarchical designs (`OPENROAD_HIERARCHICAL=1`) are read with `-hier`
and produce hierarchical netlists.
