#
# Extracts and returns module names from Verilog file
#
proc get_module_names { file_path } {
  set module_list [list]
  if { [catch { set fid [open $file_path r] } err] } {
    error "Failed to open file $file_path: $err"
  }

  set regex {^[ \t]*module[ \t]+([A-Za-z_$][A-Za-z0-9_$]*)}

  while { [gets $fid line] >= 0 } {
    if { [regexp -nocase $regex $line match_all module_name] } {
      lappend module_list $module_name
    }
  }

  close $fid
  return $module_list
}

#
# Builds dfflegalize arg list
#
proc get_dfflegalize_args { file_path } {
  set legalize_args [list]
  set module_names [get_module_names $file_path]
  foreach module_name $module_names {
    lappend legalize_args -cell $module_name x
  }
  return $legalize_args
}

source $::env(SCRIPTS_DIR)/synth_preamble.tcl
read_checkpoint $::env(RESULTS_DIR)/1_1_yosys_canonicalize.rtlil

hierarchy -check -top $::env(DESIGN_NAME)

if { $::env(SYNTH_GUT) } {
  # /deletes all cells at the top level, which will quickly optimize away
  # everything else, including macros.
  delete $::env(DESIGN_NAME)/c:*
}

if { [env_var_exists_and_non_empty SYNTH_KEEP_MODULES] } {
  foreach module $::env(SYNTH_KEEP_MODULES) {
    select -module $module
    setattr -mod -set keep_hierarchy 1
    select -clear
  }
}

if { [env_var_exists_and_non_empty SYNTH_HIER_SEPARATOR] } {
  scratchpad -set flatten.separator $::env(SYNTH_HIER_SEPARATOR)
}

set synth_full_args [env_var_or_empty SYNTH_ARGS]
if { [env_var_exists_and_non_empty SYNTH_OPERATIONS_ARGS] } {
  set synth_full_args [concat $synth_full_args $::env(SYNTH_OPERATIONS_ARGS)]
} else {
  set synth_full_args [concat $synth_full_args \
    "-extra-map $::env(FLOW_HOME)/platforms/common/lcu_kogge_stone.v"]
}
if { [env_var_exists_and_non_empty SYNTH_OPT_HIER] } {
  set synth_full_args [concat $synth_full_args -hieropt]
}

if { !$::env(SYNTH_HIERARCHICAL) } {
  # Perform standard coarse-level synthesis script, flatten right away
  synth -flatten -run :fine {*}$synth_full_args
} else {
  # Perform standard coarse-level synthesis script,
  # defer flattening until we have decided what hierarchy to keep
  synth -run :fine

  if { [env_var_exists_and_non_empty SYNTH_MINIMUM_KEEP_SIZE] } {
    set ungroup_threshold $::env(SYNTH_MINIMUM_KEEP_SIZE)
    puts "Keep modules above estimated size of
      $ungroup_threshold gate equivalents"

    convert_liberty_areas
    keep_hierarchy -min_cost $ungroup_threshold
  } else {
    keep_hierarchy
  }

  # Re-run coarse-level script, this time do pass -flatten
  synth -flatten -run coarse:fine {*}$synth_full_args
}


if { $::env(SYNTH_MOCK_LARGE_MEMORIES) } {
  memory_collect
  set select [tee -q -s result.string select -list t:\$mem_v2]
  set report_file [open $::env(REPORTS_DIR)/synth_mocked_memories.txt "w"]
  foreach path [split [string trim $select] "\n"] {
    set index [string first "/" $path]
    set module [string range $path 0 [expr { $index - 1 }]]
    set instance [string range $path [expr { $index + 1 }] end]

    set width [rtlil::get_param -uint $module $instance WIDTH]
    set size [rtlil::get_param -uint $module $instance SIZE]
    set nbits [expr $width * $size]
    puts "Memory $path has dimensions $size x $width = $nbits"
    if { $nbits > $::env(SYNTH_MEMORY_MAX_BITS) } {
      rtlil::set_param -uint $module $instance SIZE 1
      puts "Shrunk memory $path from $size rows to 1"
      puts -nonewline $report_file "$module:\n  width: $width\n  size: $size\n"
      if { $::env(SYNTH_KEEP_MOCKED_MEMORIES) } {
        select -module $module
        setattr -mod -set keep_hierarchy 1
        select -clear
      }
    }
  }
  close $report_file
}

json -o $::env(RESULTS_DIR)/mem.json
# Run report and check here so as to fail early if this synthesis run is doomed
exec -- $::env(PYTHON_EXE) $::env(SCRIPTS_DIR)/mem_dump.py \
  --max-bits $::env(SYNTH_MEMORY_MAX_BITS) $::env(RESULTS_DIR)/mem.json

if { [env_var_exists_and_non_empty SYNTH_RETIME_MODULES] } {
  select $::env(SYNTH_RETIME_MODULES)
  opt -fast -full
  memory_map
  opt -full
  techmap
  abc -dff -script $::env(SCRIPTS_DIR)/abc_retime.script
  select -clear
}

if {
  [env_var_exists_and_non_empty SYNTH_WRAPPED_OPERATORS] ||
  [env_var_exists_and_non_empty SWAP_ARITH_OPERATORS]
} {
  source $::env(SCRIPTS_DIR)/synth_wrap_operators.tcl
} else {
  synth -top $::env(DESIGN_NAME) -run fine: {*}$synth_full_args
}

# Get rid of indigestibles
chformal -remove
delete t:\$print

# rename registers to have the verilog register name in its name
# of the form \regName$_DFF_P_. We should fix yosys to make it the reg name.
# At least this is predictable.
renames -wire

# Optimize the design
opt -purge

# Technology mapping of adders
if {
  [env_var_exists_and_non_empty ADDER_MAP_FILE] &&
  ![env_var_exists_and_non_empty SYNTH_WRAPPED_OPERATORS] &&
  ![env_var_exists_and_non_empty SWAP_ARITH_OPERATORS]
} {
  # extract the full adders
  extract_fa
  # map full adders
  techmap -map $::env(ADDER_MAP_FILE)
  techmap
  # Quick optimization
  opt -fast -purge
}

# Technology mapping of latches
if { [env_var_exists_and_non_empty LATCH_MAP_FILE] } {
  techmap -map $::env(LATCH_MAP_FILE)
}

# Technology mapping of flip-flops
# dfflibmap only supports one liberty file
if { [env_var_exists_and_non_empty DFF_LIB_FILE] } {
  dfflibmap -liberty $::env(DFF_LIB_FILE) {*}$lib_dont_use_args
} elseif { [env_var_exists_and_non_empty DFF_MAP_FILE] } {
  set legalize_args [get_dfflegalize_args $::env(DFF_MAP_FILE)]
  dfflegalize {*}$legalize_args
  techmap -map $::env(DFF_MAP_FILE)
} else {
  dfflibmap {*}$lib_args {*}$lib_dont_use_args
}
opt

# Replace undef values with defined constants
setundef -zero

if {
  ![env_var_exists_and_non_empty SYNTH_WRAPPED_OPERATORS] &&
  ![env_var_exists_and_non_empty SWAP_ARITH_OPERATORS]
} {
  log_cmd abc {*}$abc_args
} else {
  scratchpad -set abc9.script $::env(SCRIPTS_DIR)/abc_speed_gia_only.script
  # crop out -script from arguments
  set abc_args [lrange $abc_args 2 end]
  log_cmd abc_new {*}$abc_args
  delete {t:$specify*}
}

# Splitting nets resolves unwanted compound assign statements in
# netlist (assign {..} = {..})
splitnets

# Remove unused cells and wires
opt_clean -purge

# Technology mapping of constant hi- and/or lo-drivers
hilomap -singleton \
  -hicell {*}$::env(TIEHI_CELL_AND_PORT) \
  -locell {*}$::env(TIELO_CELL_AND_PORT)

# Insert buffer cells for pass through wires
insbuf -buf {*}$::env(MIN_BUF_CELL_AND_PORTS)

# Reports
tee -o $::env(REPORTS_DIR)/synth_check.txt check

tee -o $::env(REPORTS_DIR)/synth_stat.txt stat {*}$lib_args

# check the design is composed exclusively of target cells, and
# check for other problems
if {
  ![env_var_exists_and_non_empty SYNTH_WRAPPED_OPERATORS] &&
  ![env_var_exists_and_non_empty SWAP_ARITH_OPERATORS]
} {
  check -assert -mapped
} else {
  # Wrapped operator synthesis leaves around $buf cells which `check -mapped`
  # gets confused by, once Yosys#4931 is merged we can remove this branch and
  # always run `check -assert -mapped`
  check -assert
}

# Write synthesized design
write_verilog -nohex -nodec $::env(RESULTS_DIR)/1_2_yosys.v
# One day a more sophisticated synthesis will write out a modified
# .sdc file after synthesis. For now, just copy the input .sdc file,
# making synthesis more consistent with other stages.
log_cmd exec cp $::env(SDC_FILE) $::env(RESULTS_DIR)/1_synth.sdc
