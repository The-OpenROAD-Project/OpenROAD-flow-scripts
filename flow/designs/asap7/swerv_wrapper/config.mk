export DESIGN_NAME = swerv_wrapper
export PLATFORM    = asap7

export SYNTH_HIERARCHICAL = 1
export RTLMP_FLOW = True

export VERILOG_FILES = ./designs/src/swerv/swerv_wrapper.sv2v.v \
                       ./designs/$(PLATFORM)/swerv_wrapper/macros.v
export SDC_FILE      = ./designs/$(PLATFORM)/swerv_wrapper/constraint.sdc

export ADDITIONAL_LEFS = $(sort $(wildcard ./designs/$(PLATFORM)/swerv_wrapper/lef/*.lef))
export ADDITIONAL_LIBS = $(sort $(wildcard ./designs/$(PLATFORM)/swerv_wrapper/lib/*.lib))

export DIE_AREA    = 0 0 550 600
export CORE_AREA   = 5 5 545 595 

export HAS_IO_CONSTRAINTS = 1
export PLACE_PINS_ARGS = -exclude left:* -exclude right:* 
export PLACE_DENSITY_LB_ADDON = 0.20
export CTS_BUF_CELL  = BUFx8_ASAP7_75t_R

export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 3
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 2

export FASTROUTE_TCL = ./designs/$(PLATFORM)/swerv_wrapper/fastroute.tcl
