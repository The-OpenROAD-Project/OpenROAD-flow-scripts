yosys -import

source $::env(SCRIPTS_DIR)/util.tcl
erase_non_stage_variables synth

# If using a cached, gate level netlist, then copy over to the results dir with
# preserve timestamps flag set. If you don't, subsequent runs will cause the
# floorplan step to be re-executed.
if { [env_var_exists_and_non_empty SYNTH_NETLIST_FILES] } {
  if { [llength $::env(SYNTH_NETLIST_FILES)] == 1 } {
    log_cmd exec cp -p $::env(SYNTH_NETLIST_FILES) $::env(RESULTS_DIR)/1_2_yosys.v
  } else {
    # The date should be the most recent date of the files, but to
    # keep things simple we just use the creation date
    log_cmd exec cat {*}$::env(SYNTH_NETLIST_FILES) > $::env(RESULTS_DIR)/1_2_yosys.v
  }
  log_cmd exec cp -p $::env(SDC_FILE) $::env(RESULTS_DIR)/1_synth.sdc
  if { [env_var_exists_and_non_empty CACHED_REPORTS] } {
    log_cmd exec cp -p {*}$::env(CACHED_REPORTS) $::env(REPORTS_DIR)/.
  }
  exit
}

proc read_checkpoint { file } {
  # We are reading a Yosys checkpoint
  if { [file extension $file] == ".json" } {
    read_json $file
  } else {
    read_rtlil $file
  }
}

proc read_design_sources { } {
  # We are reading Verilog sources
  source $::env(SCRIPTS_DIR)/synth_stdcells.tcl

  # Setup verilog include directories
  set vIdirsArgs ""
  if { [env_var_exists_and_non_empty VERILOG_INCLUDE_DIRS] } {
    foreach dir $::env(VERILOG_INCLUDE_DIRS) {
      lappend vIdirsArgs "-I$dir"
    }
    set vIdirsArgs [join $vIdirsArgs]
  }

  if { [env_var_equals SYNTH_HDL_FRONTEND slang] } {
    plugin -i slang

    set slang_args [list \
      -D SYNTHESIS --keep-hierarchy --compat=vcs --ignore-assertions --top $::env(DESIGN_NAME) \
      {*}$vIdirsArgs {*}[env_var_or_empty VERILOG_DEFINES]]

    # slang requires all files at once
    lappend slang_args {*}$::env(VERILOG_FILES)

    # Add clock gate cell definition, if available
    if { [env_var_exists_and_non_empty CLKGATE_MAP_FILE] } {
      lappend slang_args $::env(CLKGATE_MAP_FILE)
    }

    # Apply top-level parameters
    dict for {key value} [env_var_or_empty VERILOG_TOP_PARAMS] {
      lappend slang_args -G "$key=$value"
    }

    # Apply module blackboxing based on module names as they appear
    # in the input, that is before any module name mangling done
    # by elaboration and synthesis
    if { [env_var_exists_and_non_empty SYNTH_BLACKBOXES] } {
      foreach m $::env(SYNTH_BLACKBOXES) {
        lappend slang_args --blackboxed-module "$m"
      }
    }

    # Add user arguments
    lappend slang_args {*}$::env(SYNTH_SLANG_ARGS)

    yosys read_slang {*}$slang_args

    # Workaround for yosys-slang#119
    setattr -unset init
  } elseif { [env_var_equals SYNTH_HDL_FRONTEND verific] } {
    if { [env_var_exists_and_non_empty VERILOG_INCLUDE_DIRS] } {
      verific -vlog-incdir {*}$::env(VERILOG_INCLUDE_DIRS)
    }
    if { [env_var_exists_and_non_empty VERILOG_DEFINES] } {
      verific -vlog-define {*}$::env(VERILOG_DEFINES)
    }
    verific -sv2012 {*}$::env(VERILOG_FILES)
    verific -import -no-split-complex-ports $::env(DESIGN_NAME)

    dict for {key value} [env_var_or_empty VERILOG_TOP_PARAMS] {
      # Apply top-level parameters
      chparam -set $key $value $::env(DESIGN_NAME)
    }

    if { [env_var_exists_and_non_empty SYNTH_BLACKBOXES] } {
      error "Non-empty SYNTH_BLACKBOXES unsupported with HDL frontend \"verific\""
    }
  } elseif { ![env_var_exists_and_non_empty SYNTH_HDL_FRONTEND] } {
    verilog_defaults -push
    if { [env_var_exists_and_non_empty VERILOG_DEFINES] } {
      verilog_defaults -add {*}$::env(VERILOG_DEFINES)
    }
    foreach file $::env(VERILOG_FILES) {
      read_verilog -defer -sv {*}$vIdirsArgs $file
    }
    # Read platform specific mapfile for OPENROAD_CLKGATE cells
    if { [env_var_exists_and_non_empty CLKGATE_MAP_FILE] } {
      read_verilog -defer $::env(CLKGATE_MAP_FILE)
    }
    verilog_defaults -pop

    dict for {key value} [env_var_or_empty VERILOG_TOP_PARAMS] {
      # Apply top-level parameters
      chparam -set $key $value $::env(DESIGN_NAME)
    }

    if { [env_var_exists_and_non_empty SYNTH_BLACKBOXES] } {
      hierarchy -check -top $::env(DESIGN_NAME)
      foreach m $::env(SYNTH_BLACKBOXES) {
        blackbox $m
      }
    }
  } else {
    error "Unrecognized HDL frontend: $::env(SYNTH_HDL_FRONTEND)"
  }
}

if { $::env(ABC_AREA) } {
  puts "Using ABC area script."
  set abc_script $::env(SCRIPTS_DIR)/abc_area.script
} else {
  puts "Using ABC speed script."
  set abc_script $::env(SCRIPTS_DIR)/abc_speed.script
}

# Create argument list for stat
set lib_args ""
foreach lib $::env(LIB_FILES) {
  append lib_args "-liberty $lib "
}

# Exclude dont_use cells. This includes macros that are specified via
# LIB_FILES and ADDITIONAL_LIBS that are included in LIB_FILES.
set lib_dont_use_args ""
if { [env_var_exists_and_non_empty DONT_USE_CELLS] } {
  foreach cell $::env(DONT_USE_CELLS) {
    lappend lib_dont_use_args -dont_use $cell
  }
}

# Technology mapping for cells
set abc_args [list -script $abc_script \
  {*}$lib_args {*}$lib_dont_use_args -constr $::env(OBJECTS_DIR)/abc.constr]

if { [env_var_exists_and_non_empty SDC_FILE_CLOCK_PERIOD] } {
  puts "Extracting clock period from SDC file: $::env(SDC_FILE_CLOCK_PERIOD)"
  set fp [open $::env(SDC_FILE_CLOCK_PERIOD) r]
  set clock_period [string trim [read $fp]]
  if { $clock_period != "" } {
    puts "Setting clock period to $clock_period"
    lappend abc_args -D $clock_period
  }
  close $fp
}

set constr [open $::env(OBJECTS_DIR)/abc.constr w]
puts $constr "set_driving_cell $::env(ABC_DRIVER_CELL)"
puts $constr "set_load $::env(ABC_LOAD_IN_FF)"
close $constr

proc convert_liberty_areas { } {
  cellmatch -derive_luts =A:liberty_cell
  # find a reference nand2 gate
  set found_cell ""
  set found_cell_area ""
  # iterate over all cells with a nand2 signature
  foreach cell [tee -q -s result.string select -list-mod =*/a:lut=4'b0111 %m] {
    if { ![rtlil::has_attr -mod $cell area] } {
      puts "Cell $cell missing area information"
      continue
    }
    set area [rtlil::get_attr -string -mod $cell area]
    if { $found_cell == "" || $area < $found_cell_area } {
      set found_cell $cell
      set found_cell_area $area
    }
  }
  if { $found_cell == "" } {
    error "reference nand2 cell not found"
  }

  # convert the area on all Liberty cells to a gate number equivalent
  foreach box [tee -q -s result.string select -list-mod =A:area =A:liberty_cell %i] {
    set area [rtlil::get_attr -mod -string $box area]
    set gate_eq [expr int($area / $found_cell_area)]
    rtlil::set_attr -mod -uint $box gate_cost_equivalent $gate_eq
  }
}
