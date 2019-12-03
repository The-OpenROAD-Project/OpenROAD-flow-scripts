# Scripts should not exit
set standalone 0

# Read design inputs
foreach libFile $::env(LIB_FILES) {
  read_liberty $libFile
}

read_lef $::env(OBJECTS_DIR)/merged.lef
read_verilog $::env(RESULTS_DIR)/1_1_yosys.v
link_design $::env(DESIGN_NAME)
read_sdc $::env(SDC_FILE)

source $::env(SCRIPTS_DIR)/buffer.tcl 
source $::env(SCRIPTS_DIR)/verilog2def.tcl
