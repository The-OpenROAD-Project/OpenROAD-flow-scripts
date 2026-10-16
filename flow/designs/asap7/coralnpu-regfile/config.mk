export DESIGN_NICKNAME = coralnpu-regfile

include designs/asap7/coralnpu/config.mk

# Regfile's 31 words, moved by surgery.py --regfile into Regfile_rf, as
# a generated register file of standard cells inlined in their place.
export SYNTH_VERILOG_SURGERY_ARGS = --regfile
export AUTO_MEMORIES_REGFILES     = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/Regfile_rf.regfile
