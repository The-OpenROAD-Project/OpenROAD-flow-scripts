tinyRocket on asap7
-------------------

Rocket Chip's `TinyConfig` tile (`RocketTile`): a 32-bit Rocket core
with its instruction and data caches. It is the one ORFS design that
takes `AUTO_MEMORIES` end to end, and the quickest way to see what it
does with a real core: synthesis to global route in minutes.

What makes it unique among the designs:

- **Its memories are found, not hand-mapped.** The Rocket Chip generator
  leaves the cache arrays as black boxes (`*_ext`); `memories.v` gives
  them behavioral models in firtool's read-write port convention, and
  `AUTO_MEMORIES` infers them, checks them against its macro floors and
  generates FakeRAM `.lib`/`.lef` views for those that pass. Nothing is
  mapped by hand, unlike nangate45's tinyRocket (a platform file mapping
  each `*_ext` onto a fakeram macro) or the designs that instantiate
  their macros explicitly.
- **SRAMs and a register file in one design, both identified by yosys.**
  `results/.../memories.json`, the inventory, lists every memory yosys
  infers and what became of it:

  | memory | shape | becomes |
  |---|---|---|
  | `data_arrays_0_ext` (dcache data) | 64 x 32, one read-write port, 4 byte lanes | FakeRAM macro |
  | `data_arrays_0_0_ext` (icache data) | 64 x 32, one read-write port | FakeRAM macro |
  | `tag_array_ext` (icache tags) | 4 x 25 | flip-flops: below the macro floors |
  | `Rocket._T_288`, the integer register file | 31 x 32, two combinational reads, one write | flip-flops: an array inline in the core, the shape no SRAM model describes |
  | TileLink queue entries | 2 words each | flip-flops |

  So the design exercises the SRAM path and shows the register file a
  CPU core really has, side by side, which no other design does.
- **Fast turnaround.** A real core with macros, yet small enough to
  iterate on: synthesis is about half a minute, floorplan to global route
  a few minutes.

To see the inventory and the generated views after synthesis:

    make DESIGN_CONFIG=designs/asap7/tinyRocket/config.mk synth
    cat results/asap7/tinyRocket/base/memories.json
    ls results/asap7/tinyRocket/base/memories/

`docs/user/AutoMemories.md` describes `AUTO_MEMORIES`.
