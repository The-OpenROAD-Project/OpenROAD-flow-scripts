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

