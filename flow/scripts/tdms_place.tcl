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
  source $::env(SCRIPTS_DIR)/read_liberty.tcl

  # Read design files
  read_def $::env(RESULTS_DIR)/2_2_floorplan_io.def
  read_sdc $::env(RESULTS_DIR)/1_synth.sdc
  if [file exists $::env(PLATFORM_DIR)/derate.tcl] {
    source $::env(PLATFORM_DIR)/derate.tcl
  }
} else {
  puts "Starting TDMS placement"
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

# Set res and cap
source $::env(PLATFORM_DIR)/setRC.tcl
set_dont_use $::env(DONT_USE_CELLS)

if {[find_macros] != ""} {
  if {[info exists ::env(RTLMP_FLOW)]} {
    puts "RTLMP flow enabled. Skipping tdms place."
  } else {
    global_placement -density $::env(PLACE_DENSITY) \
                   -pad_left $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT) \
                   -pad_right $::env(CELL_PAD_IN_SITES_GLOBAL_PLACEMENT)
  }
} else {
  puts "No macros found: Skipping global_placement"
}

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_def $::env(RESULTS_DIR)/2_3_floorplan_tdms.def
}
