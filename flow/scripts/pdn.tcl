source $::env(SCRIPTS_DIR)/load.tcl
load_design 2_5_floorplan_tapcell.odb 1_synth.sdc

source $::env(PDN_TCL)
pdngen

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

if {[info exists ::env(GALLERY_REPORT)]  && $::env(GALLERY_REPORT) != 0} {
  write_def $::env(RESULTS_DIR)/2_floorplan.def
}
write_db $::env(RESULTS_DIR)/2_6_floorplan_pdn.odb
