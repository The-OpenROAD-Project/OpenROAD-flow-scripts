### Summary
black_parrot_2019_03_28 Full 64-bit RISC-V Core with Cache Coherence Directory  ~65K gates

### Source
Cloned from README (commit a6b8be03ed88467269efabeaf168459d14199c69)

### Modifications
- Performed elaboration using genus (no SystemVerilog support in yosys)
- Generated memory using bsg_fakeram ( https://github.com/bespoke-silicon-group/bsg_fakeram )
- Hardened memory blocks
- Added timing constraints