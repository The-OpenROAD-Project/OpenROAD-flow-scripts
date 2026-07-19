# AUTO_MEMORIES: generated memory macros

**Experimental.** AUTO_MEMORIES detects memories in a design's RTL
before synthesis and generates abstract `.lib`/`.lef` macro views for
them, so an existing design gets macro-based synthesis and physical
design results — including RTL-MP macro placement — without a memory
compiler or hand-maintained fakeram files.

The intended audience is flows built on top of ORFS (for example
bazel-orfs based in-house flows) that need early, reasonable physical
results on designs whose memories exist only as behavioral RTL. Support
posture: if it works for you, great; if it needs fixing, the report is
itself a welcome signal that someone is using it.

## What it does

With `AUTO_MEMORIES=1`, a pre-synthesis step runs
`scripts/memories/gen_memories.py` over `VERILOG_FILES` and writes:

| File | Content |
| --- | --- |
| `$(RESULTS_DIR)/memories.json` | Inventory of every detected memory: geometry, full pin list with pin functions, behavioral model, and whether it was converted (`idiomatic`) with a reason. |
| `$(RESULTS_DIR)/memories/<m>.lib` | Generated Liberty view per converted memory. |
| `$(RESULTS_DIR)/memories/<m>_pre_layout.lib` | Ideal-clock (zero clock-tree insertion) variant for pre-CTS consumers that select lib files themselves. The Makefile flow uses `<m>.lib` throughout. |
| `$(RESULTS_DIR)/memories/<m>.lef` | Abstract LEF per converted memory. |
| `$(RESULTS_DIR)/memories/blackboxes.txt` | Names of the converted modules — what synthesis blackboxes. |

Synthesis (canonicalization) blackboxes the converted modules so the
liberty view wins over their behavioral bodies; floorplan through final
read the generated `.lib`/`.lef` alongside `ADDITIONAL_LIBS`/
`ADDITIONAL_LEFS`. Everything downstream keys off the files above —
nothing else passes between the generator and the flow. That file-based
handoff is what lets build systems (e.g. bazel-orfs) declare the
generated artifacts as ordinary stage outputs and transitive
dependencies of the remaining stages.

Memories that are *not* converted stay in the netlist and synthesize to
flip-flops, like any other RTL.

## How memories are detected

Detection is a fast Python scan (`scripts/memories/detect.py`) for
modules whose entire port list follows the firtool (CIRCT) memory port
convention: every port named `<R|W|RW><n>_<function>`, e.g. `R0_addr`,
`W0_en`, `RW0_wdata`, including the subword-split forms `RW0_wdata_3` /
`W0_mask_2`. This is what Chisel/firtool emits for module-separated
memories, and what the rocket-chip generation of Chisel emitted (the
in-tree tinyRocket design).

Two consequences, documented as deliberate scope:

- **Module boundary only.** A memory embedded inside a larger module
  (a bare `reg [7:0] mem [0:255]` next to other logic) is not detected.
  Yosys's memory-inference pass sees those; FPGA tools extract them
  into block RAMs. Wiring yosys up as the detector — or growing such a
  pass in OpenROAD SYN, which currently has no memory inference and
  therefore cannot be leaned on here either — is future work; this
  feature punts on it with the simple scanner.
- **No banking.** Each detected memory maps to exactly one macro. A
  memory too wide, too deep, or too ported for a single sensible macro
  is not decomposed across several macros — a future extension.

## The idiomatic gate

Not every detected memory should be a macro. `scripts/memories/
idiomatic.py` applies simple floors (minimum depth 16, minimum capacity
256 bits, at most 4 ports); memories below them are cheaper as
flip-flops than as a macro paying the fixed control/decode/sense-amp
floor. Rejected memories are kept in `memories.json` with
`"idiomatic": false` and a reason.

To overrule the gate, list a `.memories` file in `ADDITIONAL_MEMORIES`:

```json
{
  "version": 1,
  "memories": [
    {
      "name": "tag_array",
      "idiomatic": true,
      "reason": "forced: the RTL provides no behavioral fallback"
    }
  ]
}
```

Entries merge by name onto the detected set: fields the override
carries win, everything else (geometry, pins) is kept from detection. A
`.memories` entry naming a module the scanner never found is taken
whole — it must then describe its pins itself. The
`designs/asap7/tinyRocket` design demonstrates the forced-conversion
case: its `tag_array` wrapper is 4 entries deep (rejected by the gate)
but instantiates a module the sources never define, so flops are not an
option and the design forces conversion.

## Generated views

The `.lib` mirrors the structural shape OpenROAD's abstract writer
produces for hardened blocks: `bus()` groups **with per-bit `pin()`
records** (a bus without per-bit siblings makes yosys silently drop bit
connections at parent instances), per-port clock pins with
`min/max_clock_tree_path` arcs, setup/hold constraints on inputs,
clock-to-out arcs on outputs, and `internal_power()` records under a
`power_lut_template` so SAIF-driven power reporting is non-zero.

The `.lef` is an abstract following the conventions of the platform's
fakeram abstracts: `CLASS BLOCK`, per-bit signal pin pads stacked along
the macro edge, interleaved horizontal power/ground straps the
platform's PDN macro grid connects to, and a full-footprint multi-layer
`OBS`.

Timing and area come from simple parametric models
(`scripts/memories/liberty.py`, `scripts/memories/sram_area_model.py`):
log2(rows) decode depth and √bits bit-line scaling for timing; an area
model anchored to published 7 nm SP-SRAM figures (Suzuki et al., ISSCC
2018). These are budgetary models — good enough to make floorplanning,
placement, and timing behave representatively; not sign-off numbers.

## Platform support

**asap7 only.** The emitters are split into general structure
(`liberty.py`, `lef.py`, parameterized by a `PdkParams`) and platform
constants (`pdk_asap7.py`: pins and power straps on M4 — where the
platform's PDN macro grid connects — pin pad/pitch, strap geometry,
OBS layers, nominal voltage). Generalizing to other PDKs means
providing their `PdkParams` — the code seam exists, the calibration
work does not. `AUTO_MEMORIES=1` on any other platform fails with a
clear error.

## Trying it

```shell
# Unit tests (fast, no EDA tools):
bazelisk test //flow:memories_tests

# The demo design:
make DESIGN_CONFIG=designs/asap7/tinyRocket/config.mk synth floorplan
```

The generator can also be run standalone to inspect what it would do:

```shell
python3 flow/scripts/memories/gen_memories.py \
  --platform asap7 --out-dir /tmp/mems --json /tmp/memories.json \
  --verilog flow/designs/src/tinyRocket/freechips.rocketchip.system.TinyConfig.v
```

## Variables

- [AUTO_MEMORIES](FlowVariables.md#AUTO_MEMORIES)
- [ADDITIONAL_MEMORIES](FlowVariables.md#ADDITIONAL_MEMORIES)
