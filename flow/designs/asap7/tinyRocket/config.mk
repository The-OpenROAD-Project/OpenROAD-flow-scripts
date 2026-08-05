export DESIGN_NICKNAME = tinyRocket
export DESIGN_NAME = RocketTile
export PLATFORM    = asap7

# The generic tinyRocket sources only: unlike the nangate45 tinyRocket
# there is no hand-written platform memory-mapping file and no
# checked-in fakeram .lib/.lef — AUTO_MEMORIES detects the memory
# wrapper modules and generates macro views for them instead.
export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/AsyncResetReg.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ClockDivider2.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ClockDivider3.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/plusarg_reader.v \
                       $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/freechips.rocketchip.system.TinyConfig.v

export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export AUTO_MEMORIES = 1
# tag_array (4x25) falls below the idiomatic-macro floors, but this RTL
# provides no behavioral fallback (the wrapper instantiates a
# tag_array_ext module the sources never define), so its conversion is
# forced via a .memories override.
export ADDITIONAL_MEMORIES = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/tag_array.memories

export CORE_UTILIZATION = 40
export CORE_MARGIN      = 2

export PLACE_DENSITY_LB_ADDON = 0.10
export MACRO_PLACE_HALO = 2 2

export TNS_END_PERCENT = 100
