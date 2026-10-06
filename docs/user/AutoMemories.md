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

## Register files

A register file, many read and write ports over a few words, is no
SRAM: FakeRAM's single-port model does not describe it, and synthesised
to flops its mux trees are placed by a placer that does not know they
are an array. `AUTO_MEMORIES_REGFILES` lists spec files, one per RTL
module, and OpenROAD's `generate_regfile` builds each as an array of
placed standard cells: a flop per bit, its write mux beside it, the read
trees in columns. The spec names the module, its words and bits, its
read and write ports by the module's own port names, and the cells:

```
module RegFile
mode netlist
words 16
bits 8
clock clock
read io_r0_addr io_r0_data
write io_w0_addr io_w0_data io_w0_en
cell flop DFFHQNx1_ASAP7_75t_R
...
```

`generate_regfile` checks the spec against the module's ports, then
writes `<m>.v` (the cells), `<m>.lef` (an abstract, its pins where
their connections land in the array) and `<m>.lib`/`<m>_pre_layout.lib`
(a timing model) beside the FakeRAM views. The module joins
`blackboxes.txt`, so synthesis and macro placement see a macro.

In `mode netlist` (the usual one) the macro dissolves into its cells at
the end of macro placement (`regfile_dissolve.tcl`): the array's core
lands FIRM where the macro was placed, flipped as the macro was, on the
parent's rows; the address decode is left to global placement and the
resizer, and dead logic is eliminated as at synthesis. From there on it
is standard cells. `mode macro` keeps the macro to the end.

Listed register files appear in `memories.json` with kind `regfile`;
the rest have kind `fakeram` or `flops`. `designs/asap7/regfile` is the
smallest example.

Moving parts of this into OpenROAD, the dissolve in particular, is left
for later: it would make them faster, testable at unit level and
maintained with the database they edit.

### Designs to measure it on

What a register file of placed cells buys is a shorter minimum clock
period (the read mux trees are columns, not a cloud) and a shorter
build (fewer cells for synthesis, placement and the resizer to work
on). The ORFS designs whose register file is flip-flops today and its
own module, the seam a spec needs, measured as flops against
`AUTO_MEMORIES_REGFILES`:

| Design | Module | Today | Shape | Ready? |
|---|---|---|---|---|
| asap7/riscv32i | `regfile` | flip-flops: `reg [31:0] rf[31:0]`, mapped to flops (no AUTO_MEMORIES) | 32 x 32, 2R1W, x0 reads 0 | Yes: the ports are the spec's (`zero_word 0`). Also exercises `OPENROAD_HIERARCHICAL=1` beside two FakeRAM macros. |
| asap7/ibex | `ibex_register_file_ff` | flip-flops: `RegFile = RegFileFF`, the default | 32 x 32, 2R1W, x0 reads 0 | Not yet: `test_en_i` and `dummy_instr_id_i` are ports the array does not use, which a spec cannot yet name, and `rst_ni` resets the flops to 0 where the generator's flops have no reset (the ISA leaves x1-x31 undefined after reset). |
| asap7/cva6 | `ariane_regfile` (`ariane_regfile_ff.sv`) | flip-flops: cv32a65x has `FpgaEn` 0 | 32 x 32, 2R1W | Not yet: the ports are packed arrays (`raddr_i[1:0][4:0]`), one port per slice, which a spec cannot yet address; asynchronous reset as ibex. |
| asap7/swerv_wrapper | `dec_gpr_ctl_*` | flip-flops | 32 x 32, 4R3W | Not yet: read enables, bank ids and scan ports around the array need a seam in the RTL. |

coralnpu's `Regfile` (8R4W) and `FRegfile` (3R2W) carry their
scoreboard and bypass logic in the same module, and picorv32 and
tinyRocket keep their register file inside the CPU module: those need a
seam in their RTL first.

`designs/asap7/regfile` is the smallest case, for turnaround rather
than measurement.

### Status: a prototype, slower and bigger on riscv32i

`designs/asap7/riscv32i-regfile` is riscv32i with its register file
generated; the study case for what the generator gets wrong, because it
reaches global route in minutes. To global route, against
`designs/asap7/riscv32i`:

| | flops | register file |
|---|---|---|
| minimum period (950 ps clock, global-route parasitics) | 954 ps | 998 ps |
| place to global route, stage time | 211 s | 536 s |
| core area | 4 012 um2 (62 %) | 7 573 um2 (45 %) |
| standard-cell area, without taps | 1 284 um2 | 1 413 um2 |
| failing endpoints after global route | 79 | 992 |

Synthesis takes a second either way: a 32 x 32 file is too small for
its synthesis time to show, which is where the larger files of a large
core are expected to gain.

Why it is slower: every failing endpoint is a flop of the array, all
within 50 ps, and the worst path runs from the instruction through the
array's read path -- the address decode as three serial AND2 stages,
the word select, five levels of OR2 -- into the ALU and back to the
array's write mux: 232 ps from `instr` to read data. The flops
version's same loop closes. `repair_timing` then spends its time at CTS
and global route on 992 endpoints it cannot fix.

Why it is bigger: standard-cell area is within a tenth of the flops',
and the array's cells fill 58 % of its box. The core is bigger because
`riscv32i-regfile/config.mk` sets 45 % utilisation: at riscv32i's 62 %
no macro placement fits the array beside the four FakeRAMs.

The rest is the generator's to fix: decode as a tree sized for its
fanout, a read tree of AO22 and NAND/NOR rather than AND2 and OR2,
cells the resizer may swap in place.

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
- [AUTO_MEMORIES_REGFILES](FlowVariables.md#AUTO_MEMORIES_REGFILES)
