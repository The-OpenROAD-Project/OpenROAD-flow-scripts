yosys -import

if {[info exist ::env(CACHED_NETLIST)]} {
  exec cp $::env(CACHED_NETLIST) $::env(RESULTS_DIR)/1_1_yosys.v
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


# read verilog files
foreach file $::env(VERILOG_FILES) {
  read_verilog -defer -sv {*}$vIdirsArgs $file
}


# Read blackbox stubs of standard cells. This allows for standard cell (or
# structural netlist) support in the input verilog
read_verilog -defer $::env(BLACKBOX_V_FILE)

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

# Use hierarchy to automatically generate blackboxes for known memory macro.
# Pins are enumerated for proper mapping
if {[info exist ::env(BLACKBOX_MAP_TCL)]} {
  hierarchy -top $::env(DESIGN_NAME)
  source $::env(BLACKBOX_MAP_TCL)
}


# generic synthesis
synth  -top $::env(DESIGN_NAME) -flatten

# Optimize the design
opt -purge

# technology mapping of latches
if {[info exist ::env(LATCH_MAP_FILE)]} {
  techmap -map $::env(LATCH_MAP_FILE)
}

# technology mapping of flip-flops
dfflibmap -liberty $::env(OBJECTS_DIR)/merged.lib
opt

set constr [open $::env(OBJECTS_DIR)/abc.constr w]
puts $constr "set_driving_cell $::env(ABC_DRIVER_CELL)"
puts $constr "set_load $::env(ABC_LOAD_IN_FF)"
close $constr

# Technology mapping for cells
if {[info exist ::env(ABC_CLOCK_PERIOD_IN_PS)]} {
  abc -D [expr $::env(ABC_CLOCK_PERIOD_IN_PS)] \
      -liberty $::env(OBJECTS_DIR)/merged.lib \
      -constr $::env(OBJECTS_DIR)/abc.constr
} else {
  puts "WARNING: No clock period constraints detected in design"
  abc -liberty $::env(OBJECTS_DIR)/merged.lib \
      -constr $::env(OBJECTS_DIR)/abc.constr
}

# replace undef values with defined constants
setundef -zero

# Splitting nets resolves unwanted compound assign statements in netlist (assign {..} = {..})
splitnets

# remove unused cells and wires
opt_clean -purge

# technology mapping of constant hi- and/or lo-drivers
hilomap -singleton \
        -hicell {*}$::env(TIEHI_CELL_AND_PORT) \
        -locell {*}$::env(TIELO_CELL_AND_PORT)

# insert buffer cells for pass through wires
insbuf -buf {*}$::env(MIN_BUF_CELL_AND_PORTS)

# reports
tee -o $::env(REPORTS_DIR)/synth_check.txt check
tee -o $::env(REPORTS_DIR)/synth_stat.txt stat -liberty $::env(OBJECTS_DIR)/merged.lib

# write synthesized design
write_verilog -noattr -noexpr -nohex -nodec $::env(RESULTS_DIR)/1_1_yosys.v
