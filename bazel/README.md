# OpenROAD-flow-scripts and Bazel integration

Think in Make, test with Make, get Bazel performance, caching, and parallelism.

## How it works

`config.mk` is the canonical DSL for defining ORFS designs. The Bazel integration
auto-generates `orfs_flow()` targets from these config.mk files using a Python parser,
so you never need to maintain separate BUILD files for your designs.

```
config.mk  -->  config_mk_parser.py  -->  orfs_flow() targets  -->  Bazel build
```

The `bazel-orfs` package defines the rules that drive the ORFS Makefile-based flow
through Bazel, giving you:

- **Caching**: unchanged stages are not re-run
- **Parallelism**: independent designs and stages build concurrently
- **Reproducibility**: hermetic builds with pinned tool versions
- **Zero-docker mode**: everything runs from local sources, no Docker image required

## Quick start

Install [Bazelisk](https://github.com/bazelbuild/bazelisk), then:

```bash
# Build GCD synthesis for ASAP7
bazel build @orfs_designs//asap7/gcd:gcd_synth

# Build full RTL-to-GDSII flow
bazel build //flow/designs/asap7/gcd:gcd_final

# Build for a different PDK
bazel build //flow/designs/sky130hd/gcd:gcd_final
```

## Adding a new design

Just create a `config.mk` file in `flow/designs/<platform>/<design>/`:

```makefile
export PLATFORM = asap7
export DESIGN_NAME = my_design
export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NAME)/*.v))
export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
export CORE_UTILIZATION = 50
```

Bazel targets auto-appear at `//flow/designs/<platform>/<design>:<design_name>_<stage>`.

## Incremental caching

Bazel only re-runs stages whose inputs changed. The variable metadata from
`flow/scripts/variables.yaml` defines which ORFS variables affect which stages.

For example, if you modify only `CORE_UTILIZATION` in
`flow/designs/asap7/gcd/config.mk`, then:

```bash
bazel build //flow/designs/asap7/gcd:gcd_place
```

This re-runs from floorplan onward but **skips synthesis entirely** — because
`variables.yaml` defines `CORE_UTILIZATION` as only affecting floorplan and
later stages, not synthesis. The cached synthesis result is reused.

## config.mk DSL

The config.mk DSL is a restricted subset of Make. Supported features:

| Feature | Example |
|---------|---------|
| Variable assignment | `export VAR = value` |
| Conditional default | `export VAR ?= value` |
| Clear/immediate | `export VAR :=` |
| Line continuations | `export FILES = a.v \`<br>`  b.v` |
| Path variables | `$(DESIGN_HOME)`, `$(PLATFORM)`, `$(DESIGN_NAME)`, `$(DESIGN_NICKNAME)` |
| Glob patterns | `$(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NAME)/*.v))` |
| Hierarchical blocks | `export BLOCKS = sub_macro1 sub_macro2` |

Run the linter to check your config.mk for unsupported features:

```bash
python3 bazel/config_mk_parser.py --lint flow/designs/asap7/gcd/config.mk
```

## Zero-docker mode

The default configuration uses no Docker image. All tools, scripts, PDKs, and
flow infrastructure come from the local repository:

- **Scripts**: `//flow:makefile` and `//flow:makefile_yosys`
- **PDKs**: `//flow:asap7`, `//flow:sky130hd`, etc.
- **OpenROAD**: built from `tools/OpenROAD/` or system-installed

To switch to a Docker-based configuration, set the `image` attribute:

```starlark
orfs.default(
    image = "docker.io/openroad/orfs:tag",
    sha256 = "the-hash",
)
```

## Dependency version management

`bazel-orfs` is referenced in `MODULE.bazel`. To use a local checkout:

```starlark
local_path_override(
    module_name = "bazel-orfs",
    path = "/path/to/local/bazel-orfs",
)
```

Details on usage and flow definitions are in the `bazel-orfs`
[README](https://github.com/The-OpenROAD-Project/bazel-orfs?tab=readme-ov-file#usage).

