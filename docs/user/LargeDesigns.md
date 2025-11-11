# Tips on building large design

Large designs can quickly result in unmanageable turnaround times for tweaking and fixing if the design contains behavioral memory models, because these memories are by default translated to flip flops.

ORFS has a `SYNTH_MEMORY_MAX_BITS` that limits the size of inferred memories that are translated to flip flops to avoid doomed synthesis runs that will "running forever", instead ORFS will error out early, normally within minutes.

Behavioral models of memories are used in simulation and FPGA tools oftentimes automatically combine hard memory macros with some extra logic to match the behavioral model. OpenROAD does not do such automatic memory inference and matching against real memories or fakemem.

## Doing a screening build

Before deciding how to set up a flow, it is useful to do a "screening build". All we're intersted in here is to know which modules we have and their relative sizes. This can help us identify memories that have not been successfully inferred by Yosys, which will manifest itself as very long synthesis times and appear in the OpenROAD hierarchical view with a large number of instances.

The [minimal build configuration](flow/designs/asap7/minimal/README.md)
 can be useful to do a screening build.

Options useful for a screening build are, check out [config.mk](flow/designs/asap7/minimal/config.mk):

- `SYNTH_HIERARCHICAL=1` and `SYNTH_MINIMUM_KEEP_SIZE=0`, to see all modules in the hierarchical OpenROAD view
- `SYNTH_MEMORY_MAX_BITS=1024`, set a low threshold initially to get an error with list of memories in the system that will need to be dealt with in some way
- `SYNTH_MOCK_LARGE_MEMORIES=1` enabled after first seeing the error report with memories. This sets the number of rows in memories larger than `SYNTH_MEMORY_MAX_BITS` to 1, so that synthesis will complete.

## Next steps on memories

- If you're taping out, write some wrapper Verilog for real memories.
- fakemem can be a good option if available for your PDK. fakemem also needs manually written Verilog wrappers, just like real memories.
- For architectural exploration, `SYNTH_MOCK_LARGE_MEMORIES=1` could give you adequate timing accuracy and is convenient.
