# Performs RTL-to-GDS in a single script
# No checkpointing is performed

set standalone 0

# Synthesis
source -verbose $::env(SCRIPTS_DIR)/yosys.tcl

# Read process / design
read_lef $::env(OBJECTS_DIR)/merged_padded.lef
foreach libFile $::env(LIB_FILES) {
  read_liberty $libFile
}
read_verilog $::env(RESULTS_DIR)/1_1_yosys.v
link_design $::env(DESIGN_NAME)
read_sdc $::env(SDC_FILE)

# Pre-placement buffering
set_wire_rc -layer $::env(WIRE_RC_LAYER)
source -verbose $::env(SCRIPTS_DIR)/buffer.tcl

# Floorplan
source -verbose $::env(SCRIPTS_DIR)/verilog2def.tcl
source -verbose $::env(SCRIPTS_DIR)/io_placement.tcl
source -verbose $::env(SCRIPTS_DIR)/tdms_place.tcl
source -verbose $::env(SCRIPTS_DIR)/macro_place.tcl
source -verbose $::env(SCRIPTS_DIR)/pdn.tcl
source -verbose $::env(SCRIPTS_DIR)/tapcell.tcl

# Place
source -verbose $::env(SCRIPTS_DIR)/global_place.tcl
source -verbose $::env(SCRIPTS_DIR)/detail_place.tcl

# CTS
source -verbose $::env(SCRIPTS_DIR)/cts.tcl

# Save output for global route
write_def $::env(RESULTS_DIR)/4_cts.def

# Route
source -verbose $::env(SCRIPTS_DIR)/global_route.tcl

# Detail route not integrated yet
source -verbose $::env(SCRIPTS_DIR)/tritonRoute.tcl

# Finishing
source -verbose $::env(SCRIPTS_DIR)/klayout.tcl

exit
