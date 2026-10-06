# riscv32i with its register file built by AUTO_MEMORIES_REGFILES rather
# than synthesised to flip-flops: the same RTL and constraints. The study
# case for why a generated register file is slower and bigger than the
# flops it replaces -- minutes to global route, simple to build, and both
# are true of it today. docs/user/AutoMemories.md has the numbers.
export DESIGN_NICKNAME = riscv32i-regfile

include designs/asap7/riscv32i/config.mk

export CORE_UTILIZATION = 45

export AUTO_MEMORIES          = 1
export AUTO_MEMORIES_REGFILES = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/regfile.regfile
