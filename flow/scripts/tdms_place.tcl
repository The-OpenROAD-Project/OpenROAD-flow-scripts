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
  read_def $::env(RESULTS_DIR)/2_2_floorplan_io.def
  read_sdc $::env(RESULTS_DIR)/1_synth.sdc
}

proc find_macros {} {
  set macros ""

  set db [::ord::get_db]
  set block [[$db getChip] getBlock]
  foreach inst [$block getInsts] {
    set inst_master [$inst getMaster]

    # BLOCK means MACRO cells
    if { [string match [$inst_master getType] "BLOCK"] } {
      append macros " " $inst
    }
  }
  return $macros
}

if {[find_macros] != ""} {
    #@workaround crash
    if {$::env(DESIGN_NICKNAME)!="bp_single"} {
	set_wire_rc -layer $::env(WIRE_RC_LAYER)
    }
    global_placement -timing_driven -density $::env(PLACE_DENSITY)
} else {
    puts "No macros found: Skipping global_placement"
}

if {![info exists standalone] || $standalone} {
  write_def $::env(RESULTS_DIR)/2_3_floorplan_tdms.def
  exit
}
