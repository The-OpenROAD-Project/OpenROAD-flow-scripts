source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_5_floorplan_tapcell.odb 1_synth.sdc "Starting PDN generation"

if {[info exist ::env(PDN_TCL)]} {
  source $::env(PDN_TCL)
  pdngen -verbose
} elseif {[info exist ::env(PDN_CFG)]} {
  pdngen $::env(PDN_CFG) -verbose
}

if { [info exists ::env(POST_PDN_TCL)] && [file exists $::env(POST_PDN_TCL)] } {
  source $::env(POST_PDN_TCL)
}

# Check all supply nets
set block [ord::get_db_block]
foreach net [$block getNets] {
    set type [$net getSigType]
    if {$type == "POWER" || $type == "GROUND"} {
# Temporarily disable due to CI issues
#        puts "Check supply: [$net getName]"
#        check_power_grid -net [$net getName]
    }
}

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $::env(RESULTS_DIR)/2_6_floorplan_pdn.odb
}
