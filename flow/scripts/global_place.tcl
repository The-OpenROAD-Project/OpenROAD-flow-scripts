if {![info exists standalone] || $standalone} {
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

  # Read design files
  read_def $::env(RESULTS_DIR)/2_floorplan.def
  read_sdc $::env(RESULTS_DIR)/2_floorplan.sdc
}
 
# Don't need set_wire_rc until TD is implemented!
#
# set_wire_rc -layer $::env(WIRE_RC_LAYER)

# For routability-driven (RD) feature, FR needs routing resource adjustments.
FastRoute::add_layer_adjustment 2 $::env(REPLACE_FASTROUTE_RESOURCE_ADJ_23)
FastRoute::add_layer_adjustment 3 $::env(REPLACE_FASTROUTE_RESOURCE_ADJ_23)
for {set i 4} {$i <= 10} {
  FastRoute::add_layer_adjustment $i $::env(REPLACE_FASTROUTE_RESOURCE_ADJ_OTHER)
}

# unidirectional routing=true
FastRoute::set_unidirectional_routing true

global_placement -density $::env(PLACE_DENSITY) \
    -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
    -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)

if {![info exists standalone] || $standalone} {
  write_def $::env(RESULTS_DIR)/3_1_place_gp.def
  exit
}
