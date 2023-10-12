export PLATFORM               = asap7

export DESIGN_NAME            = aes_cipher_top

export VERILOG_FILES = $(sort $(wildcard aes/*.v))
export SDC_FILE      = constraints.sdc

export ABC_AREA               = 1

export CORE_UTILIZATION       = 20
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.65

export SYNTH_HIERARCHICAL = 1
export RTLMP_FLOW = True

export PLACE_PINS_ARGS = -annealing

# Generous routing at top level
export MIN_ROUTING_LAYER      = M2
export MAX_ROUTING_LAYER      = M9

# Ignore power at this exploratory level
export GND_NETS_VOLTAGES      = ""
export PWR_NETS_VOLTAGES      = ""

# The macros are very small so use a smaller halo
export MACRO_PLACE_HALO        ?= 5 5

export ADDITIONAL_LEFS += $(WORK_HOME_READ)/results/$(PLATFORM)/aes_sbox/$(FLOW_VARIANT)/aes_sbox.lef
export ADDITIONAL_LIBS += $(WORK_HOME_READ)/results/$(PLATFORM)/aes_sbox/$(FLOW_VARIANT)/aes_sbox.lib
export ADDITIONAL_GDS_FILES += $(WORK_HOME_READ)/results/$(PLATFORM)/aes_sbox/$(FLOW_VARIANT)/6_final.gds

export ADDITIONAL_LEFS += $(WORK_HOME_READ)/results/$(PLATFORM)/aes_rcon/$(FLOW_VARIANT)/aes_rcon.lef
export ADDITIONAL_LIBS += $(WORK_HOME_READ)/results/$(PLATFORM)/aes_rcon/$(FLOW_VARIANT)/aes_rcon.lib
export ADDITIONAL_GDS_FILES += $(WORK_HOME_READ)/results/$(PLATFORM)/aes_rcon/$(FLOW_VARIANT)/6_final.gds

export PDN_TCL = $(PLATFORM_DIR)/openRoad/pdn/BLOCKS_grid_strategy.tcl
