export DESIGN_NICKNAME = microwatt
export DESIGN_NAME = microwatt
export PLATFORM    = sky130hd

export VERILOG_FILES_BLACKBOX = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/IPs/*.v
export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v \
                       $(VERILOG_FILES_BLACKBOX)))

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export DIE_AREA   = 0 0 3020 3610
export CORE_AREA  = 10 10 3010 3600

export microwatt_DIR = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)

export ADDITIONAL_GDS  = $(wildcard $(microwatt_DIR)/gds/*.gds.gz)

export ADDITIONAL_LEFS  = $(wildcard $(microwatt_DIR)/lef/*.lef)

export ADDITIONAL_LIBS = $(wildcard $(microwatt_DIR)/lib/*.lib)

export SYNTH_HIERARCHICAL = 1

export PLACE_DENSITY = 0.3

export MACRO_PLACE_HALO = 60 60

# CTS tuning
export CTS_BUF_DISTANCE = 600
export SKIP_GATE_CLONING = 1
export CTS_CLUSTER_SIZE = 10
export CTS_CLUSTER_DIAMETER = 50

export SETUP_SLACK_MARGIN = 0.2

# GRT non-default config
export FASTROUTE_TCL = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/fastroute.tcl

ifeq ($(SYNTH_MOCK_LARGE_MEMORIES),1)
    # ca. 3 minutes to run make synth
    #
    # These module names comes from the error report when setting SYNTH_MEMORY_MAX_BITS=2048
    # and SYNTH_MOCK_LARGE_MEMORIES=0
    #
    # The goal is to run through the flow quickly to learn what we can
    # about the design without getting bogged down in memory issues.
    export SYNTH_MEMORY_MAX_BITS ?= 1024
else
    export SYNTH_MEMORY_MAX_BITS ?= 42000
endif
