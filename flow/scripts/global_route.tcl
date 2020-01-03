if {![info exists standalone] || $standalone} {
  # Read process files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }
  read_lef $::env(OBJECTS_DIR)/merged_padded.lef
  
  # Read design files
  read_def $::env(RESULTS_DIR)/4_cts.def
}

set_wire_rc -layer $::env(WIRE_RC_LAYER)
fastroute -capacity_adjustment 0.15 -max_routing_layer $::env(MAX_ROUTING_LAYER) \
  -output_file $::env(RESULTS_DIR)/route.guide

if {![info exists standalone] || $standalone} {
  exit
}
