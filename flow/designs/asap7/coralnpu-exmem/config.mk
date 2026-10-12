export DESIGN_NICKNAME = coralnpu-exmem

include designs/asap7/coralnpu/config.mk

# LsuV1's inputs registered by surgery.py --address-register: the
# EX/MEM register between dispatch and the load/store unit.
export SYNTH_VERILOG_SURGERY_ARGS = --address-register

# The clock, just under what the EX/MEM register lets the design reach.
export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/coralnpu-exmem/constraint.sdc
