export DESIGN_NICKNAME = riscv32i
export DESIGN_NAME = riscv_top
export PLATFORM    = asap7

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
export ADDITIONAL_LEFS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/*.lib))

export DIE_AREA = 0 0 200 200
export CORE_AREA = 5 5 190 190

export PLACE_DENSITY = 0.40
