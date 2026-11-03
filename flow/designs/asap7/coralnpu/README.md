# coralnpu on asap7

[CoralNPU](https://github.com/google-coral/coralnpu) is Google's open
RISC-V core for edge machine learning: an in-order scalar core that
dispatches up to four instructions a cycle, with a float unit, an ITCM
and a DTCM, and AXI ports. The top is `CoreMiniAxi`.

Its memories are generated: the five TCM banks as SRAM macros with
their byte write masks (`AUTO_MEMORIES`), and the integer and
floating-point register files as standard cells by OpenROAD's
`generate_ram` (`AUTO_MEMORIES_REGFILES`), every word with its
asynchronous reset. What is left as flip-flops is a handful of queues
of two or three entries.

## Results

The whole flow at a 1,900 ps clock, in about 90 minutes:

| stage | worst setup slack | achieved period |
|---|---|---|
| CTS | +4.6 ps | 1,895 ps |
| global route | +6.2 ps | 1,894 ps |
| final, extracted parasitics | -108 ps | 2,008 ps |

Standard cells take 19,411 µm² and the five SRAM macros 13,965 µm².
Detailed route ends with no DRC errors. CTS takes 2.7 minutes and
global route 9.1; detailed route takes an hour.

The worst path at the end runs from the debug module's request queue
through the CSRs, the float core and the load/store unit to the
retirement buffer, in and out of the kept units.
The generated register files' write enables close with 36 ps to spare.

## Where the RTL comes from

`../../src/coralnpu/CoreMiniAxi.sv` is generated from coralnpu's source
at the commit pinned in `../../src/coralnpu/generate/MODULE.bazel`, by
Bazel from that directory:

    cd flow/designs/src/coralnpu/generate
    bazelisk run //:update

`generate/CoreMiniAxiGenerator.scala` elaborates coralnpu's `CoreAxi` with the
parameters of coralnpu's own `CoreMiniAxi` build (128-bit fetch and
load/store, float with Zfbfmin), in a wrapper that ties the test enable
`te` to 0, so synthesis removes the test-mode reset bypasses and clock
gate overrides. firtool runs without the verification layers and
without register randomization. To move to a newer coralnpu, change the
commit and its `sha256` in `MODULE.bazel` and run `//:update`.

## Memories

- The ITCM (one bank) and DTCM (four banks) are coralnpu's `Sram`,
  512 x 128, one read-write port and a 16-lane byte mask.
  `sram.memories` names its pins (`ADDITIONAL_MEMORIES`), and
  `AUTO_MEMORIES` replaces it with a generated macro.
- `Regfile` and `FRegfile` keep their words as separate registers, with
  no array for yosys to infer. `surgery.py` (`SYNTH_VERILOG_SURGERY`)
  moves them into modules of their own, `Regfile_rf` and `FRegfile_rf`,
  and `generate_ram` builds those from `Regfile_rf.regfile` and
  `FRegfile_rf.regfile`. The integer register file has nine
  combinational reads (eight read ports and the debug port) and six
  writes; the floating-point one four reads and two writes.
- The largest array left is a ROM, the divider's SRT bound table
  (128 x 83), which yosys maps to logic. `SYNTH_MEMORY_MAX_BITS` counts
  ROMs today and stops synthesis on it; the design builds once a ROM
  is no longer counted, a separate change.

## Surgery

`surgery.py` recognises each register file token for token, comments
and whitespace aside, and anything else stops the build. It moves
storage and changes no function: each register file before and after
the surgery was simulated side by side on the same random inputs,
every output compared every cycle (200,000 cycles, resets included,
read and write addresses biased to collide), and a deliberate error in
the moved storage, a write port's mask dropped or the write priority
swapped, is caught within 20 cycles.
