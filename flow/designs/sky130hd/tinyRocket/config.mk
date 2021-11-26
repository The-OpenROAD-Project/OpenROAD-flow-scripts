export DESIGN_NICKNAME = tinyRocket
export DESIGN_NAME = RocketTile
export PLATFORM    = sky130hd

export VERILOG_FILES = ./designs/src/$(DESIGN_NICKNAME)/AsyncResetReg.v \
                       ./designs/src/$(DESIGN_NICKNAME)/ClockDivider2.v \
                       ./designs/src/$(DESIGN_NICKNAME)/ClockDivider3.v \
                       ./designs/src/$(DESIGN_NICKNAME)/plusarg_reader.v \
                       ./designs/src/$(DESIGN_NICKNAME)/freechips.rocketchip.system.TinyConfig.v \
                       ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/freechips.rocketchip.system.TinyConfig.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/*.lib))

export CORE_UTILIZATION = 20
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2

