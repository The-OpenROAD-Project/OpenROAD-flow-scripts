source $::env(SCRIPTS_DIR)/read_liberty.tcl

read_lef $::env(TECH_LEF)
read_lef $::env(SC_LEF)
if {[info exist ::env(ADDITIONAL_LEFS)]} {
  foreach lef $::env(ADDITIONAL_LEFS) {
    read_lef $lef
  }
}

read_def $::env(RESULTS_DIR)/3_3_place_gp.def


write_db $::env(RESULTS_DIR)/3_3_place_gp.odb
exit
