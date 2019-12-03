### Summary
SweRV RISC-V Core 1.1 from Western Digital
The `swerv` hierarchy currently has about 100,000 cells

### Source
Cloned from https://github.com/westerndigitalcorporation/swerv_eh1 (commit 3ef7e65f3bd38659c594992f218eec7622666caf)

### Modifications
- Default configuration from Repository
- Performed elaboration using genus (no SystemVerilog support in yosys)
- Disabled clock gating in the elaborated design. Not supported by TritonCTS
- Commented out the contents of dmi_wrapper (the debug core). TritonCTS does not currently handle designs with multiple clocks
- Added timing constraints
- Added LICENSE