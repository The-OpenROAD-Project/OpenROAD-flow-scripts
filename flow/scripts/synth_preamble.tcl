yosys -import

if {[info exist ::env(CACHED_NETLIST)]} {
  exec cp $::env(CACHED_NETLIST) $::env(RESULTS_DIR)/1_1_yosys.v
  if {[info exist ::env(CACHED_REPORTS)]} {
    exec cp {*}$::env(CACHED_REPORTS) $::env(REPORTS_DIR)/.
  }
  exit
}

# Setup verilog include directories
set vIdirsArgs ""
if {[info exist ::env(VERILOG_INCLUDE_DIRS)]} {
  foreach dir $::env(VERILOG_INCLUDE_DIRS) {
    lappend vIdirsArgs "-I$dir"
  }
  set vIdirsArgs [join $vIdirsArgs]
}


# Read verilog files
foreach file $::env(VERILOG_FILES) {
  read_verilog -defer -sv {*}$vIdirsArgs $file
}




# Read standard cells and macros as blackbox inputs
# These libs have their dont_use properties set accordingly
read_liberty -lib {*}$::env(DONT_USE_LIBS)

# Apply toplevel parameters (if exist)
if {[info exist ::env(VERILOG_TOP_PARAMS)]} {
  dict for {key value} $::env(VERILOG_TOP_PARAMS) {
    chparam -set $key $value $::env(DESIGN_NAME)
  }
}

# Read platform specific mapfile for OPENROAD_CLKGATE cells
if {[info exist ::env(CLKGATE_MAP_FILE)]} {
  read_verilog -defer $::env(CLKGATE_MAP_FILE)
}

# Mark modules to keep from getting removed in flattening
if {[info exist ::env(PRESERVE_CELLS)]} {
  # Expand hierarchy since verilog was read in with -defer
  hierarchy -check -top $::env(DESIGN_NAME)
  foreach cell $::env(PRESERVE_CELLS) {
    select -module $cell
    setattr -mod -set keep_hierarchy 1
    select -clear
  }
}



if {[info exist ::env(BLOCKS)]} {
  hierarchy -check -top $::env(DESIGN_NAME)
  foreach block $::env(BLOCKS) {
    blackbox $block
    puts "blackboxing $block"
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

if {[info exist ::env(SDC_FILE_CLOCK_PERIOD)] && [file isfile $::env(SDC_FILE_CLOCK_PERIOD)]} {
  puts "\[FLOW\] Extracting clock period from SDC file: $::env(SDC_FILE_CLOCK_PERIOD)"
  set fp [open $::env(SDC_FILE_CLOCK_PERIOD) r]
  set clock_period [string trim [read $fp]]
  if {$clock_period != ""} {
    puts "\[FLOW\] Setting clock period to $clock_period"
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
