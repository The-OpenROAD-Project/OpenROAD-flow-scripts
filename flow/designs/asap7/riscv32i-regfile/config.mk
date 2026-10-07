# riscv32i with its register file built by AUTO_MEMORIES_REGFILES rather
# than synthesised to flip-flops: the same RTL, constraints and
# utilisation. Not in AUTO_MEMORIES_MACRO_PLACE, so the generated netlist
# is inlined in synthesis. Minutes to global route, the case to measure
# the generator on; docs/user/AutoMemories.md has the numbers.
export DESIGN_NICKNAME = riscv32i-regfile

include designs/asap7/riscv32i/config.mk

export AUTO_MEMORIES          = 1
export AUTO_MEMORIES_REGFILES = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/regfile.regfile
