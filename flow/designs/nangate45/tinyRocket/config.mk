export DESIGN_NICKNAME = tinyRocket
export DESIGN_NAME = RocketTile
export PLATFORM    = nangate45

export SYNTH_HIERARCHICAL = 1
export SYNTH_MINIMUM_KEEP_SIZE ?= 5000

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/AsyncResetReg.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ClockDivider2.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ClockDivider3.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/plusarg_reader.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/freechips.rocketchip.system.TinyConfig.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/freechips.rocketchip.system.TinyConfig.v

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/*.lib))

export CORE_UTILIZATION       = 60
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.75
