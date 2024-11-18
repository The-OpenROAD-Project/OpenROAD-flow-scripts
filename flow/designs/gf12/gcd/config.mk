export DESIGN_NICKNAME = gcd_$(TRACK_OPTION)_$(TECH_OPTION)
export DESIGN_NAME = gcd
export PLATFORM    = gf12

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NAME)/gcd.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

# These values must be multiples of placement site
export DIE_AREA    = 0 0 99.96 100.128
export CORE_AREA   = 9.996 10.08 89.964 90.048

export GLOBAL_PLACEMENT_ARGS = -skip_initial_place

ifeq ($(USE_FILL),1)
export DESIGN_TYPE = CELL
else
export DESIGN_TYPE = CELL_NODEN
endif

export SKIP_GATE_CLONING = 1

