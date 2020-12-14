# SKY130 Standard SRAM configurations

This directory contains configurations for the standard SRAM configurations
that are generated.

They fall into the following categories;

 * Single port with byte write SRAM suitable for RISC-V and other processor
   main memory.

 * Pseudo-dual port SRAM (one write, one read) suitable for FIFOs.

 * True dual port SRAM (two read/write ports) suitable for high speed data
   sharing between two devices.

 * Dual access SRAM (one read/write, one read port) suitable for applications
   which need to read two data values every cycle (such as register files).

Currently supported sizes are 1kbytes, 2kbytes and 4kbytes. Larger arrays will
be supported in the future.

As the OpenRAM memory generator is freely available, you can also generate
memories of your own configuration and are not restricted to these pre-built
memory configurations.
