yosys -import

source $::env(SCRIPTS_DIR)/util.tcl
erase_non_stage_variables synth

if {[env_var_exists_and_non_empty CACHED_NETLIST]} {
  log_cmd exec cp $::env(CACHED_NETLIST) $::env(RESULTS_DIR)/1_1_yosys.v
  log_cmd exec cp $::env(SDC_FILE) $::env(RESULTS_DIR)/1_synth.sdc
  if {[env_var_exists_and_non_empty CACHED_REPORTS]} {
    log_cmd exec cp {*}$::env(CACHED_REPORTS) $::env(REPORTS_DIR)/.
  }
  exit
}

# Setup verilog include directories
set vIdirsArgs ""
if {[env_var_exists_and_non_empty VERILOG_INCLUDE_DIRS]} {
  foreach dir $::env(VERILOG_INCLUDE_DIRS) {
    lappend vIdirsArgs "-I$dir"
  }
  set vIdirsArgs [join $vIdirsArgs]
}


# Read verilog files
foreach file $::env(VERILOG_FILES) {
  if {[file extension $file] == ".rtlil"} {
    read_rtlil $file
  } elseif {[file extension $file] == ".json"} {
    read_json $file
  } else {
    read_verilog -defer -sv {*}$vIdirsArgs $file
  }
}




# Read standard cells and macros as blackbox inputs
# These libs have their dont_use properties set accordingly
read_liberty -overwrite -setattr liberty_cell -lib {*}$::env(DONT_USE_LIBS)
read_liberty -overwrite -setattr liberty_cell \
  -unit_delay -wb -ignore_miss_func -ignore_buses {*}$::env(DONT_USE_LIBS)

# Apply toplevel parameters (if exist)
if {[env_var_exists_and_non_empty VERILOG_TOP_PARAMS]} {
  dict for {key value} $::env(VERILOG_TOP_PARAMS) {
    chparam -set $key $value $::env(DESIGN_NAME)
  }
}

# Read platform specific mapfile for OPENROAD_CLKGATE cells
if {[env_var_exists_and_non_empty CLKGATE_MAP_FILE]} {
  read_verilog -defer $::env(CLKGATE_MAP_FILE)
}

# Mark modules to keep from getting removed in flattening
if {[env_var_exists_and_non_empty PRESERVE_CELLS]} {
  # Expand hierarchy since verilog was read in with -defer
  hierarchy -check -top $::env(DESIGN_NAME)
  foreach cell $::env(PRESERVE_CELLS) {
    select -module $cell
    setattr -mod -set keep_hierarchy 1
    select -clear
  }
}

if {$::env(ABC_AREA)} {
  puts "Using ABC area script."
  set abc_script $::env(SCRIPTS_DIR)/abc_area.script
} else {
  puts "Using ABC speed script."
  set abc_script $::env(SCRIPTS_DIR)/abc_speed.script
}

# Technology mapping for cells
# ABC supports multiple liberty files, but the hook from Yosys to ABC doesn't
set abc_args [list -script $abc_script \
      -liberty $::env(DONT_USE_SC_LIB) \
      -constr $::env(OBJECTS_DIR)/abc.constr]

# Exclude dont_use cells. This includes macros that are specified via
# LIB_FILES and ADDITIONAL_LIBS that are included in LIB_FILES.
if {[env_var_exists_and_non_empty DONT_USE_CELLS]} {
  foreach cell $::env(DONT_USE_CELLS) {
    lappend abc_args -dont_use $cell
  }
}

if {[env_var_exists_and_non_empty SDC_FILE_CLOCK_PERIOD] && [file isfile $::env(SDC_FILE_CLOCK_PERIOD)]} {
  puts "Extracting clock period from SDC file: $::env(SDC_FILE_CLOCK_PERIOD)"
  set fp [open $::env(SDC_FILE_CLOCK_PERIOD) r]
  set clock_period [string trim [read $fp]]
  if {$clock_period != ""} {
    puts "Setting clock period to $clock_period"
    lappend abc_args -D $clock_period
  }
  close $fp
}

# Create argument list for stat
set stat_libs ""
foreach lib $::env(DONT_USE_LIBS) {
  append stat_libs "-liberty $lib "
}

set constr [open $::env(OBJECTS_DIR)/abc.constr w]
puts $constr "set_driving_cell $::env(ABC_DRIVER_CELL)"
puts $constr "set_load $::env(ABC_LOAD_IN_FF)"
close $constr

proc convert_liberty_areas {} {
  cellmatch -derive_luts =A:liberty_cell
  # find a reference nand2 gate
  set found_cell ""
  set found_cell_area ""
  # iterate over all cells with a nand2 signature
  foreach cell [tee -q -s result.string select -list-mod =*/a:lut=4'b0111 %m] {
    if {! [rtlil::has_attr -mod $cell area]} {
      puts "Cell $cell missing area information"
      continue
    }
    set area [rtlil::get_attr -string -mod $cell area]
    if {$found_cell == "" || [expr $area < $found_cell_area]} {
      set found_cell $cell
      set found_cell_area $area
    }
  }
  if {$found_cell == ""} {
    error "reference nand2 cell not found"
  }

  # convert the area on all Liberty cells to a gate number equivalent
  foreach box [tee -q -s result.string select -list-mod =A:area =A:liberty_cell %i] {
    set area [rtlil::get_attr -mod -string $box area]
    set gate_eq [expr int($area / $found_cell_area)]
    rtlil::set_attr -mod -uint $box gate_cost_equivalent $gate_eq
  }
}
