export DESIGN_NICKNAME = murax
export DESIGN_NAME = de1_murax_franz
export PLATFORM    = ihp-sg13g2

export VHDL_FILES = $(DESIGN_HOME)/src/murax/murax_pkg.vhd \
                    $(DESIGN_HOME)/src/murax/murax_ram.vhd \
                    $(DESIGN_HOME)/src/murax/de1_murax_franz.vhd

export SYNTH_HDL_FRONTEND = ghdl

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION = 20 
export CORE_ASPECT_RATIO = 1

export SYNTH_MEMORY_MAX_BITS = 8196

export PLACE_DENSITY = 0.65
export TNS_END_PERCENT = 100

export USE_FILL = 1

export REMOVE_ABC_BUFFERS = 1


