Mock ALU
========

A mock ALU that can be configured in different sizes to generate
interesting test-cases.

By default, the ALU is 64 bit wide.

The Verilog files here are generated from the Chisel in `src/` and checked
in. To regenerate them, run `./verilog.sh`, which needs `sbt`.
`MOCK_ALU_WIDTH`, `MOCK_ALU_OPERATIONS` and `PLATFORM` in the environment
override its defaults.
