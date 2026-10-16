export DESIGN_NICKNAME = coralnpu-regfile-exmem

include designs/asap7/coralnpu/config.mk

# coralnpu-regfile's generated register file and coralnpu-exmem's
# EX/MEM register together.
export SYNTH_VERILOG_SURGERY_ARGS = --regfile --address-register
export AUTO_MEMORIES_REGFILES     = $(DESIGN_HOME)/$(PLATFORM)/coralnpu-regfile/Regfile_rf.regfile

# The clock, just under what the EX/MEM register lets the design reach.
export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/coralnpu-regfile-exmem/constraint.sdc
