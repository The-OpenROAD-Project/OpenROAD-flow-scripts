export PLATFORM                = asap7

export DESIGN_NICKNAME         = coralnpu
export DESIGN_NAME             = CoreMiniAxi

export VERILOG_FILES           = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/$(DESIGN_NAME).sv

# The integer and floating-point register files' words moved into
# modules of their own, Regfile_rf and FRegfile_rf.
export SYNTH_VERILOG_SURGERY   = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/surgery.py

# The five TCM banks (ITCM one, DTCM four) are coralnpu's Sram, 512 x
# 128, an array with one read-write port and a 16-lane byte mask;
# sram.memories names its pins, and AUTO_MEMORIES replaces it with a
# generated macro, mask and all.
export AUTO_MEMORIES           = 1
export ADDITIONAL_MEMORIES     = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/sram.memories

# The integer and floating-point register files, moved by surgery.py
# into Regfile_rf and FRegfile_rf, built by generate_ram as standard
# cells inlined in their place.
export AUTO_MEMORIES_REGFILES  = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/Regfile_rf.regfile \
                                 $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/FRegfile_rf.regfile

export SDC_FILE                = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export SYNTH_HDL_FRONTEND     ?= slang

export CORE_UTILIZATION        = 65

# coralnpu's units, kept by name: the core, its fetch, dispatch,
# register files, load/store unit, CSRs and FPU, and the two AXI
# bridges. The ALUs, branch units, multiplier and divider are small and
# belong with the dispatch and writeback around them. The size
# threshold is out of reach so that the list alone decides.
export SYNTH_HIERARCHICAL      = 1
export SYNTH_KEEP_MODULES      = SCore UncachedFetch DispatchV2 Regfile FRegfile LsuV3 Csr FloatCore AxiSlave DBus2AxiV2
export SYNTH_MINIMUM_KEEP_SIZE = 1000000000
export OPENROAD_HIERARCHICAL   = 1

export RTLMP_MIN_CHANNEL_SIZE = 4 4
