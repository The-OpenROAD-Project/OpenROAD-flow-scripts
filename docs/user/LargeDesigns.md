# Tips on building large design

Large designs can quickly result in unmanageable turnaround times for tweaking and fixing if the design contains behavioral memory models, because these memories are by default translated to flip flops.

ORFS has a `SYNTH_MEMORY_MAX_BITS` that limits the size of inferred memories that are translated to flip flops to avoid doomed synthesis runs that will "running forever", instead ORFS will error out early, normally within minutes.

Behavioral models of memories are used in simulation and FPGA tools oftentimes automatically combine hard memory macros with some extra logic to match the behavioral model. OpenROAD does not do such automatic memory inference and matching against real memories or fakemem.

## Finding memories translated to flip flops

- `SYNTH_MEMORY_MAX_BITS=1024`, set a low threshold initially to get an error with list of memories in the system that will need to be dealt with in some way
- `SYNTH_MOCK_LARGE_MEMORIES=1` enabled after first seeing the error report with memories. This sets the number of rows in memories larger than `SYNTH_MEMORY_MAX_BITS` to 1, so that synthesis will complete.
- `SYNTH_HIERARCHICAL=1` and `SYNTH_MINIMUM_KEEP_SIZE=0`, to see all modules in the hierarchical OpenROAD view and spot modules with an unexpectedly large number of instances

## Next steps on memories

- If you're taping out, write some wrapper Verilog for real memories.
- fakemem can be a good option if available for your PDK. fakemem also needs manually written Verilog wrappers, just like real memories.
- For architectural exploration, `SYNTH_MOCK_LARGE_MEMORIES=1` could give you adequate timing accuracy and is convenient.
