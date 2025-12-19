export PLATFORM               = asap7

export DESIGN_NAME            = aes_cipher_top
export DESIGN_NICKNAME        = aes

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ABC_AREA                 = 1

export CORE_UTILIZATION         = 40
export CORE_ASPECT_RATIO        = 1
export CORE_MARGIN              = 2
export PLACE_DENSITY            = 0.65
export TNS_END_PERCENT          = 100
export EQUIVALENCE_CHECK       ?=   1
export REMOVE_CELLS_FOR_EQY     = TAPCELL*

ifeq ($(FLOW_VARIANT),top)
	export DESIGN_NAME = aes_cipher_top
	export SYNTH_BLACKBOXES = aes_key_expand_128
else ifeq ($(FLOW_VARIANT),blackbox)
	export DESIGN_NAME = aes_key_expand_128
else ifeq ($(FLOW_VARIANT),combine)
	export EQUIVALENCE_CHECK = 0
# List blackbox twice to demonstrates that duplicate modules are ignored.
	export SYNTH_NETLIST_FILES = \
	 $(WORK_HOME)/results/$(PLATFORM)/$(DESIGN_NICKNAME)/top/1_synth.v \
	 $(WORK_HOME)/results/$(PLATFORM)/$(DESIGN_NICKNAME)/blackbox/1_synth.v \
	 $(WORK_HOME)/results/$(PLATFORM)/$(DESIGN_NICKNAME)/blackbox/1_synth.v
endif
