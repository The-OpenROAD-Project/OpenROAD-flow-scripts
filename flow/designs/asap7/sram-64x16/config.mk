export DESIGN_NAME            = SramBridge
export DESIGN_NICKNAME        = SramBridge

export VERILOG_FILES = designs/src/sram-64x16/*.sv

export SDC_FILE               = designs/asap7/sram-64x16/constraints.sdc

export PLATFORM               = asap7

export PLACE_DENSITY          = 0.30

# match SRAM
export CORNER = WC

# Pins location, obstruction settings
  export ADDITIONAL_LEFS = designs/asap7/sram-64x16/lef/SRAM2RW16x32_x4.lef
# voltage, and temperature (PVT) corner for setup and hold timing analysis
# contain descriptions of what each pin does, the delays depending on the load given in tables, and power information
# choose one 'corner'
export ADDITIONAL_LIBS = designs/asap7/sram-64x16/lib/SRAM2RW16x32_lib/SRAM2RW16x32_PVT_0P63V_100C.lib
# Entire detailed layout
export ADDITIONAL_GDS  = designs/asap7/sram-64x16/gds/SRAM2RW16x32_x4.gds

export CORE_UTILIZATION       = 15
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY          = 0.65

export RTLMP_FLOW = True

export DETAILED_ROUTE_ARGS=-bottom_routing_layer M2 -top_routing_layer M7 -save_guide_updates -verbose 1 -drc_report_iter_step 5 -droute_end_iter 30

export MACRO_HALO_X            = 3
export MACRO_HALO_Y            = 3
#export MACRO_PLACE_HALO        = 3
