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

With `AUTO_MEMORIES=1`, a pre-synthesis yosys pass
(`scripts/memories/extract_memories.tcl`) elaborates `VERILOG_FILES`
into `$(RESULTS_DIR)/memories_inferred.json`, and
`scripts/memories/gen_memories.py` reads that netlist and writes:

| File | Content |
| --- | --- |
| `$(RESULTS_DIR)/memories.json` | Inventory of every detected memory: geometry, full pin list with pin functions, behavioral model, and whether it was converted (`idiomatic`) with a reason. |
| `$(RESULTS_DIR)/memories/<m>.lib` | Generated Liberty view per converted memory. |
| `$(RESULTS_DIR)/memories/<m>_pre_layout.lib` | Ideal-clock (zero clock-tree insertion) variant for pre-CTS consumers that select lib files themselves. The Makefile flow uses `<m>.lib` throughout. |
| `$(RESULTS_DIR)/memories/<m>.lef` | Abstract LEF per converted memory. |
| `$(RESULTS_DIR)/memories/blackboxes.txt` | `<module> <area>` per converted module — what synthesis blackboxes, and the area in um² its `.lib` states, which `SYNTH_MINIMUM_KEEP_SIZE` costs it by. |

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

Yosys infers the memories. `scripts/memories/extract_memories.tcl`
reads the design sources with the design's frontend, runs `hierarchy`,
`proc` and `memory -nomap`, and writes the netlist as JSON.
`scripts/memories/detect.py` then takes each `$mem_v2` cell in it:

- depth and width from `SIZE` and `WIDTH`, read and write port counts
  from `RD_PORTS` and `WR_PORTS`, and write-mask lanes from the width
  of `WR_EN`. Read-write ports are not inferred; a `.memories` override
  can describe them (see below).
- pins named `R<n>_clk/addr/en/data` and `W<n>_clk/addr/en/data`, plus
  `W<n>_mask` when there are mask lanes.
- the module's name when the `$mem_v2` is the only cell in its module,
  otherwise the cell's name.

Two consequences, documented as deliberate scope:

- **Module boundary only.** Synthesis blackboxes converted memories by
  module name, so only a memory alone in its module is replaced by a
  macro. A memory inferred next to other logic is named after its
  cell, which matches no module.
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
      "name": "small_array",
      "idiomatic": true,
      "reason": "forced: a macro despite the floors"
    }
  ]
}
```

Entries merge by name onto the detected set: fields the override
carries win, everything else (geometry, pins) is kept from detection. A
`.memories` entry naming a module the scanner never found is taken
whole — it must then describe its pins itself.

## Generated views

The views come from FakeRAM2.0's asap7 backend
(`tools/FakeRAM2.0/orfs_asap7/generate.py`), which `gen_memories.py` runs
as `run.py --orfs_asap7_backend`.
Every converted memory becomes a FakeRAM2.0 single-port RAM of its depth
and width. Its other ports and write-mask lanes are not modelled, and the
views use FakeRAM2.0's pin names, not the memory's own.

The `.lib` has `bus()` groups `addr_in`, `wd_in` and `rd_out` and pins
`clk`, `we_in` and `ce_in`. Inputs have setup/hold constraints, `rd_out`
has a clock-to-out arc, and pins have `internal_power()` records under a
`power_lut_template`. `<m>_pre_layout.lib` has the same content as
`<m>.lib`.

Timing, power and leakage are FakeRAM2.0's built-in asap7 defaults,
the same for every memory. Only area and bus widths depend on the
memory. Each bit is 2 contacted poly pitches by 10 fin pitches, and the
bit array gets 20% extra in each direction: that is the `.lib` area.
The `.lef` size is at least that array, rounded up to a multiple of
0.19 µm in width and 1.4 µm in height; a shallow memory is made taller
to leave room for its pins.

The `.lef` is a `CLASS BLOCK` abstract with signal pins on M4 stacked up
the left edge, alternating horizontal M4 `VDD`/`VSS` straps across the
macro (which the platform's PDN macro grid connects to M5), and an `OBS`
covering M1 to M4.

## Platform support

**asap7 only.** `gen_memories.py` rejects any other platform. The
asap7 process parameters (layers, pin pitch, poly and fin pitch, snap grid)
are constants in `ASAP7_PROCESS_CONFIG` in
`tools/FakeRAM2.0/orfs_asap7/generate.py`, not read from the platform.
Another PDK would need its own backend there.

## Trying it

```shell
make DESIGN_CONFIG=designs/asap7/tinyRocket/config.mk synth floorplan
```

The generator can also be run standalone, on the
`memories_inferred.json` that run leaves in the results directory, to
inspect what it would do:

```shell
python3 flow/scripts/memories/gen_memories.py \
  --platform asap7 --out-dir /tmp/mems --json /tmp/memories.json \
  --yosys-json flow/results/asap7/tinyRocket/base/memories_inferred.json
```

## Consuming from bazel-orfs

Everything downstream keys off generated files, so a build system can
declare them as ordinary stage outputs and transitive dependencies.

A sandboxed build system, where only declared outputs survive a step and
only declared inputs are present, needs three things:

- `memories.json` and the `memories/` directory declared as outputs of
  canonicalization. `memories/` has to be a directory rather than a file
  list: the per-memory file names are only known once the RTL is
  scanned.
- both staged into every later step, because the flow reads them by
  globbing the results dir (`load.tcl` takes `memories/*.lef`,
  `read_liberty.tcl` takes `memories/*.lib`) rather than through a
  variable.
- `memories_inferred.json` staged into synthesis as well. Nothing reads
  it there, but `make` walks the prerequisites of `yosys-dependencies`
  before running it, and each one depends on the next:

  ```make
  yosys-dependencies:                     $(RESULTS_DIR)/memories.json
  $(RESULTS_DIR)/memories.json:           $(RESULTS_DIR)/memories_inferred.json ...
  $(RESULTS_DIR)/memories_inferred.json:  $(VERILOG_FILES) ...
  ```

  With the far end of that chain absent, make rebuilds
  `memories_inferred.json` -- re-running detection at a point in the
  flow where the design is no longer the original RTL -- and then tries
  to rewrite `memories.json`.

bazel-orfs implements this.

## Variables

- [AUTO_MEMORIES](FlowVariables.md#AUTO_MEMORIES)
- [ADDITIONAL_MEMORIES](FlowVariables.md#ADDITIONAL_MEMORIES)
