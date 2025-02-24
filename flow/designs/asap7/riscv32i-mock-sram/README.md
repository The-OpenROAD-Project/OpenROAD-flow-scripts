mock sram example
-----------------

To mock an SRAM means to take the behavioral Verilog and create a
scaled down version while still using all the input/outputs. This can
be useful when no fake sram is available from the PDK or the existing
fake srams are not a great match for the SRAMs used in the design.

Typically this is done by reducing the number of rows, such as from 128
to 4 in this case. The unused address bits are xor'ed together the
unused address bits so that all input/outputs of the module are still in
use.

This gives us a mock .lef and .lib file.

Mocking for non-SRAM purposes
-----------------------------

The mocking technique illustrated here can also be used for other cases
where hard macros are not immediately available or suitable, indeed it
can be used for entire modules that are not currently fleshed out
during early architectural exploration stages:

- register file, of pivotal importance for CPU performance and the design
  thereof is critical for performance. A register file's defining feature
  is that it has a very large number of ports and relatively few rows, so
  fake SRAMs are generally not suitable to model a register file.
- multipliers, barrel shifters and other highly PDK specific and optimized
  macros.
