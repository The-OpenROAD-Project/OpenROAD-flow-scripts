##############################
# Do not modify
source $env(OPDN_SRC)/src/analyze_power_grid.tcl
##############################
#
#Modify from here

# Read lef
read_lef $::env(TECH_LEF)
read_lef $::env(SC_LEF)
if {[info exist ::env(ADDITIONAL_LEFS)]} {
    foreach lef $::env(ADDITIONAL_LEFS) {
      read_lef $lef
    }
}

# Read liberty files
foreach libFile $::env(LIB_FILES) {
  read_liberty $libFile
}


read_def $env(RESULTS_DIR)/3_place.def
read_sdc $env(RESULTS_DIR)/3_place.sdc


analyze_power_grid -verbose
