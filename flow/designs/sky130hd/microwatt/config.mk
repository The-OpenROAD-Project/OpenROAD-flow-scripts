export DESIGN_NICKNAME = microwatt
export DESIGN_NAME = microwatt
export PLATFORM    = sky130hd

export VERILOG_FILES_BLACKBOX = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/*.v
export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v \
                       $(VERILOG_FILES_BLACKBOX)))

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export DIE_AREA   = 0 0 3020 3610
export CORE_AREA  = 10 10 3010 3600

export PLACE_DENSITY ?= 0.2

export microwatt_DIR = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)

export ADDITIONAL_GDS  = $(wildcard $(microwatt_DIR)/gds/*.gds.gz)

export ADDITIONAL_LEFS  = $(wildcard $(microwatt_DIR)/lef/*.lef)

export ADDITIONAL_LIBS = $(wildcard $(microwatt_DIR)/lib/*.lib)

export SYNTH_HIERARCHICAL = 1

export MACRO_PLACE_HALO = 100 100

# We use large placement blockages to try eliminating the channels between
# RAMs in order to make that space inaccessible for GPL. Experiments have
# showed that connections crossing the RAMs vertically can be painful to
# route.
export MACRO_BLOCKAGE_HALO = 151

# There's less space due to the adapted blockage halos, so GPL requires a
# higher density in order to run.
export PLACE_DENSITY = 0.19

# CTS tuning
export CTS_BUF_DISTANCE = 600
export SKIP_GATE_CLONING = 1
export CTS_CLUSTER_SIZE = 10
export CTS_CLUSTER_DIAMETER = 50

export SETUP_SLACK_MARGIN = 0.2

# GRT non-default config
export FASTROUTE_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/fastroute.tcl

# This is high, some SRAMs should probably be converted
# to real SRAMs and not instantiated as flops
export SYNTH_MEMORY_MAX_BITS = 42000

