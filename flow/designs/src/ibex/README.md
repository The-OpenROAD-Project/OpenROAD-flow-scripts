### Summary
Ibex is a small 32 bit RISC-V CPU core (RV32IMC/EMC) with a two stage pipeline, previously known as zero-riscy. https://www.lowrisc.org
It has about 26,000 cells

### Source
Cloned from https://github.com/lowRISC/ibex (commit 010985a39555bbbee969296e1da4f3bd0b502e63)

### Modifications
- Default configuration from Repository
- Performed elaboration using genus (no SystemVerilog support in yosys)
- Disabled clock gating in the elaborated design. Not supported by TritonCTS
- Added timing constraints
- Added LICENSE