# bazel-orfs Beta Test

This is an early integration of [bazel-orfs](https://github.com/The-OpenROAD-Project/bazel-orfs)
into OpenROAD-flow-scripts. It lets you build ORFS designs with Bazel
using the same `config.mk` files you already have.

**Status**: beta -- 59 designs across 6 public PDK platforms have
`orfs_design()` enabled. 53 pass QoR tests; 6 designs are blocked on
upstream fixes (see below). Platforms without public PDK files (gf12,
gf55, rapidus2hp) are not wired up.

## Quick Start

```bash
# Install bazelisk (one-time) -- see https://github.com/bazelbuild/bazelisk
# Then, from the ORFS root:

# Synthesize gcd on asap7 (downloads Docker image on first run)
bazelisk build //flow/designs/asap7/gcd:gcd_synth

# Run through floorplan
bazelisk build //flow/designs/asap7/gcd:gcd_floorplan

# Full flow through final
bazelisk build //flow/designs/asap7/gcd:gcd_final

# Run the test (includes QoR regression check)
bazelisk test //flow/designs/asap7/gcd:gcd_test

# List all targets for a design
bazelisk query //flow/designs/asap7/gcd:all
```

## Available Targets Per Design

Each enabled design gets these targets automatically from its `config.mk`:

| Target suffix | What it does |
|---|---|
| `_synth` | Yosys synthesis |
| `_floorplan` | Floorplan + I/O placement |
| `_place` | Global + detailed placement |
| `_cts` | Clock tree synthesis |
| `_grt` | Global routing |
| `_route` | Detailed routing |
| `_final` | Final optimization + fill |
| `_generate_abstract` | LEF/LIB abstract for hierarchical use |
| `_generate_metadata` | Flow metadata (logs, reports) |
| `_test` | Full flow + QoR regression check |

Each stage depends on the previous one, so building `_final` runs the
entire flow.

## Working Designs (53 passing tests + 6 blocked)

All designs below have `orfs_design()` enabled. Designs marked
**(blocked)** fail due to upstream issues in bazel-orfs or the
design's verilog sources.

### asap7 (18 designs)

| Design | DESIGN_NAME | Notes |
|--------|-------------|-------|
| `gcd` | gcd | smoketest, ~1 min |
| `gcd-ccs` | gcd | CCS lib model |
| `aes` | aes_cipher_top | medium |
| `aes-block` | aes_cipher_top | block variant |
| `aes-mbff` | aes_cipher_top | MBFF |
| `aes_lvt` | aes_cipher_top | LVT cells |
| `ethmac` | ethmac | Ethernet MAC |
| `ethmac_lvt` | ethmac | LVT cells |
| `ibex` | ibex_core | RISC-V core (slang) |
| `jpeg` | jpeg_encoder | JPEG encoder |
| `jpeg_lvt` | jpeg_encoder | LVT cells |
| `uart` | uart | UART |
| `riscv32i` | riscv_top | RISC-V RV32I |
| `riscv32i-mock-sram` | riscv_top | **(blocked)** PSM-0069 VDD connectivity |
| `mock-cpu` | mock_cpu | mock CPU with FIFO |
| `swerv_wrapper` | swerv_wrapper | SweRV EH1 |
| `cva6` | cva6 | CVA6 RISC-V (~63 min) |
| `mock-alu` | MockAlu | mock ALU |

### sky130hd (7 designs)

| Design | DESIGN_NAME | Notes |
|--------|-------------|-------|
| `gcd` | gcd | smoketest |
| `aes` | aes_cipher_top | medium |
| `ibex` | ibex_core | RISC-V core |
| `jpeg` | jpeg_encoder | JPEG encoder |
| `riscv32i` | riscv | RISC-V RV32I |
| `chameleon` | soc_core | SoC with macros |
| `microwatt` | microwatt | POWER ISA core |

### nangate45 (16 designs)

| Design | DESIGN_NAME | Notes |
|--------|-------------|-------|
| `gcd` | gcd | smoketest |
| `aes` | aes_cipher_top | medium |
| `ibex` | ibex_core | RISC-V core |
| `jpeg` | jpeg_encoder | JPEG encoder |
| `dynamic_node` | dynamic_node_top_wrap | NoC router |
| `swerv` | swerv | SweRV EH1 |
| `tinyRocket` | RocketTile | RISC-V Rocket |
| `ariane133` | ariane | hierarchical |
| `ariane136` | ariane | hierarchical |
| `black_parrot` | black_parrot | **(blocked)** MPL-0020 macro name mismatch |
| `bp_be_top` | bp_be_top | BP back-end |
| `bp_fe_top` | bp_fe_top | BP front-end |
| `bp_multi_top` | bp_multi_top | **(blocked)** OpenROAD crash in CTS |
| `bp_quad` | black_parrot | **(blocked)** yosys check -assert fails |
| `mempool_group` | mempool_group | **(blocked)** SV macro undefined in synth |
| `swerv_wrapper` | swerv_wrapper | SweRV wrapped |

### gf180 (6 designs)

| Design | DESIGN_NAME | Notes |
|--------|-------------|-------|
| `aes` | aes_cipher_top | medium |
| `aes-hybrid` | aes_cipher_top | hybrid variant |
| `ibex` | ibex_core | RISC-V core |
| `jpeg` | jpeg_encoder | JPEG encoder |
| `riscv32i` | riscv | RISC-V RV32I |
| `uart-blocks` | uart | hierarchical with uart_rx block |

### ihp-sg13g2 (7 designs)

| Design | DESIGN_NAME | Notes |
|--------|-------------|-------|
| `gcd` | gcd | smoketest |
| `aes` | aes_cipher_top | medium |
| `ibex` | ibex_core | RISC-V core |
| `jpeg` | jpeg_encoder | JPEG encoder |
| `riscv32i` | riscv | RISC-V RV32I |
| `spi` | spi | SPI controller |
| `i2c-gpio-expander` | I2cGpioExpanderTop | **(blocked)** PAD-0102 IO pad instance not found |

### sky130hs (5 designs)

| Design | DESIGN_NAME | Notes |
|--------|-------------|-------|
| `gcd` | gcd | smoketest |
| `aes` | aes_cipher_top | medium |
| `ibex` | ibex_core | RISC-V core |
| `jpeg` | jpeg_encoder | JPEG encoder |
| `riscv32i` | riscv | RISC-V RV32I |

## Designs Not Supported

### No VERILOG_FILES (minimal)

`asap7/minimal` is a test design with no `VERILOG_FILES` in config.mk
(empty SDC). Not expected to work with `orfs_designs`.

### Platforms without public PDK

gf12, gf55, and rapidus2hp have design directories but no platform
files in the open-source repo. These are skipped entirely.

## How to Add More Designs

1. Create `flow/designs/<platform>/<design>/BUILD.bazel`:

```starlark
load("@bazel-orfs//:openroad.bzl", "orfs_design")
load("@orfs_designs//:designs.bzl", "DESIGNS")

exports_files(glob(["*"]))

orfs_design(designs = DESIGNS)
```

2. If `flow/designs/src/<name>/BUILD.bazel` doesn't exist, create it:

```starlark
exports_files(
    glob(["*.v", "*.sv"], allow_empty = True),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "verilog",
    srcs = glob(include = ["*.v", "*.sv"], allow_empty = True),
    visibility = ["//visibility:public"],
)
```

3. Run `bazelisk query //flow/designs/<platform>/<design>:all` to verify.

## Using a Local bazel-orfs Checkout

To iterate on bazel-orfs rules locally, replace the `git_override` in
`MODULE.bazel`:

```starlark
# Comment out the git_override block, then add:
local_path_override(
    module_name = "bazel-orfs",
    path = "/path/to/your/bazel-orfs",
)
```

Also update the `bazel-orfs-verilog` override:

```starlark
local_path_override(
    module_name = "bazel-orfs-verilog",
    path = "/path/to/your/bazel-orfs/verilog",
)
```

## Key Differences from Make

- **Incremental**: Bazel caches every stage. Changing `PLACE_DENSITY`
  in `config.mk` rebuilds only floorplan onward -- synthesis is cached.
- **Hermetic**: Tools come from a Docker image (extracted automatically).
  No `make install` or `PATH` setup needed.
- **Parallel**: Independent designs build in parallel automatically.
- **Reproducible**: Same inputs always produce the same outputs.

## Performance Notes

Each OpenROAD invocation uses `-threads <nproc>` (all available cores).
When Bazel runs many designs in parallel, the machine becomes heavily
overcommitted. On a 48-core machine, 50+ OpenROAD instances may run
simultaneously during a full `bazelisk test ...`, each requesting 48
threads.

To limit parallelism:

```bash
# Limit to 4 concurrent OpenROAD invocations
bazelisk test --jobs=4 ...
```

A full test suite run (53 designs, 6 platforms) takes roughly 4-5 hours
on a 48-core machine with default parallelism (overcommitted). Individual
design times vary from ~1 minute (gcd) to ~63 minutes (cva6 on asap7).

## Updating Metric Thresholds

When OpenROAD or flow scripts change, metric thresholds in
`rules-base.json` may go stale. To update them for a specific design:

```bash
# Rebuilds the design and writes updated thresholds back to source
bazelisk run //flow/designs/asap7/aes-block:aes_cipher_top_update
```

The target name follows the pattern `<design_name>_update` where
`<design_name>` comes from `DESIGN_NAME` in `config.mk`.

## Equivalence Checking (eqy)

Some designs (e.g. `aes`) set `EQUIVALENCE_CHECK=1` in their
`config.mk` to enable equivalence checking of repair_timing. The
actual `eqy` tool invocation is gated by a separate `RUN_EQY`
variable (default 0), so builds don't fail when eqy is not installed.
CI sets `RUN_EQY=1` when eqy is available.

## Workflow: Unmerged Commits

This PR serves as a working branch against master. Commits here are
spun off as separate, focused PRs for review. Once a PR merges, this
branch is rebased on master to drop the merged commit. The branch is
force-pushed after each rebase so the PR commit list is always the
source of truth for what's pending.

Filing of PRs is throttled to avoid overwhelming maintainers --
submitting too many at once just causes "maintainer packet dropping"
where reviews stall.

## Known Limitations

- The Docker image is pinned; updating it requires changing
  `MODULE.bazel`.
- Platforms without public PDK files (gf12, gf55, rapidus2hp) are not
  supported.
- **black_parrot**: macro_placement.tcl references macro names that
  don't match the synthesized netlist (MPL-0020).
- **bp_multi_top**: OpenROAD crashes (SIGSEGV) during CTS timing
  analysis.
- **bp_quad**: yosys `check -assert` finds 9 problems during synthesis.
- **i2c-gpio-expander**: IO pad instance `sg13g2_IOPad_io_gpio_3` not
  found during floorplan (PAD-0102).
- **mempool_group**: SystemVerilog macros (`AXI_TYPEDEF_RESP_T` etc.)
  are undefined -- likely a missing include path in the bazel build.
- **riscv32i-mock-sram**: VDD connectivity check fails at final stage
  (PSM-0069) -- fakeram macro power pins are unconnected.
- This is a beta -- expect rough edges. File issues at
  https://github.com/The-OpenROAD-Project/bazel-orfs/issues
