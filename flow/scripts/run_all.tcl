# Performs RTL-to-GDS in a single script
# No checkpointing is performed

set standalone 0

# Synthesis
yosys scripts/synth.tcl

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
source $::env(SCRIPTS_DIR)/buffer.tcl

# Floorplan
source $::env(SCRIPTS_DIR)/verilog2def.tcl
source $::env(SCRIPTS_DIR)/io_placement.tcl
if {[info exist env(RUN_MACRO_PLACEMENT)] && $::env(RUN_MACRO_PLACEMENT)} {
  source $::env(SCRIPTS_DIR)/tdms_place.tcl
  source $::env(SCRIPTS_DIR)/macro_place.tcl
}
source $::env(SCRIPTS_DIR)/pdn.tcl
source $::env(SCRIPTS_DIR)/tapcell.tcl

# Place
source $::env(SCRIPTS_DIR)/global_place.tcl
#source $::env(SCRIPTS_DIR)/resize.tcl
source $::env(SCRIPTS_DIR)/detail_place.tcl

# CTS
source $::env(SCRIPTS_DIR)/cts.tcl

# Save output for global route
write_def $::env(RESULTS_DIR)/4_cts.def

# Route
source $::env(SCRIPTS_DIR)/global_route.tcl

# Detail route not integrated yet
TritonRoute $::env(OBJECTS_DIR)/TritonRoute.param

# Finishing
magic -dnull -noconsole -T $::env(MAGIC_TECH_FILE) $::env(SCRIPTS_DIR)/magic.tcl
exit
