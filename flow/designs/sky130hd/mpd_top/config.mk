export DESIGN_NICKNAME = mpd_top
export DESIGN_NAME = mpd_top
export PLATFORM    = sky130hd

export VERILOG_FILES = $(sort $(wildcard ./designs/src/aes/*.v))
export VERILOG_FILES += ./designs/src/mpd_top/power_control.v
export VERILOG_FILES += ./designs/src/mpd_top/mpd_top.v

export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION = 20
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2

export PLACE_DENSITY = 0.65

# IR drop estimation supply net name to be analyzed and supply voltage variable
# For multiple nets: PWR_NETS_VOLTAGES  = "VDD1 1.8 VDD2 1.2"
export PWR_NETS_VOLTAGES  = "VDD 1.8"
export GND_NETS_VOLTAGES  = "VSS 0.0"
