export DESIGN_NICKNAME = tinyRocket
export DESIGN_NAME = RocketTile
export PLATFORM    = asap7

# The generic tinyRocket sources and behavioral models of the memories
# the generator leaves as black boxes (memories.v): unlike the nangate45
# tinyRocket there is no hand-written platform memory-mapping file and
# no checked-in fakeram .lib/.lef -- AUTO_MEMORIES detects the memories
# and generates macro views for them instead.
export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/AsyncResetReg.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ClockDivider2.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ClockDivider3.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/plusarg_reader.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/freechips.rocketchip.system.TinyConfig.v \
                       $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/memories.v

export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export AUTO_MEMORIES = 1
export CORE_UTILIZATION = 40
export CORE_MARGIN      = 2

export PLACE_DENSITY_LB_ADDON = 0.10
export RTLMP_MIN_CHANNEL_SIZE = 4 4

export TNS_END_PERCENT = 100
