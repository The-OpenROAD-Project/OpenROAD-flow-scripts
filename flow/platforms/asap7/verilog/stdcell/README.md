ASAP7 behavioral model files
============================

These are unmodified files from
https://github.com/The-OpenROAD-Project/asap7sc7p5t_28/tree/main/Verilog

Note that some tools, notably Verilator, might struggle with some
of the SystemVerilog features used by the behavioral logic files in
the ASAP7 PDK.

To work around this ORFS re-implements some behavioral such as the dff.v
and empty.v to allow for post-synthesis simulation to use OpenSTA
read_power_activities features.


