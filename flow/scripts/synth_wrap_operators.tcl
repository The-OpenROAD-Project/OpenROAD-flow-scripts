# Set arithmetic operator modules. Default is the first module in the list.
set deferred_cells {
  {
    \$alu
    ALU_{A_WIDTH}_{A_SIGNED}_{B_WIDTH}_{B_SIGNED}_{Y_WIDTH}{%unused}
    {HAN_CARLSON -map +/choices/han-carlson.v}
    {KOGGE_STONE -map +/choices/kogge-stone.v}
    {SKLANSKY -map +/choices/sklansky.v}
    {BRENT_KUNG}
  }
  {
    \$macc
    MACC_{CONFIG}_{Y_WIDTH}{%unused}
    {BOOTH -max_iter 1 -map $::env(SCRIPTS_DIR)/synth_wrap_operators-booth.v}
    {BASE -map +/choices/han-carlson.v}
  }
}

# Reorder the modules based on envar
proc reorder_deferred_cells { deferred_cells_var index env_var } {
  upvar $deferred_cells_var deferred_cells

  if { ![info exists ::env($env_var)] } {
    return
  }

  set cell_def [lindex $deferred_cells $index]

  # Build lookup dict
  set choice_map {}
  foreach choice [lrange $cell_def 2 end] {
    dict set choice_map [lindex $choice 0] $choice
  }

  # Build new choices
  set new_choices {}
  foreach name [split $::env($env_var) ","] {
    if { [dict exists $choice_map $name] } {
      lappend new_choices [dict get $choice_map $name]
    } else {
      puts "Warning: Unknown choice '$name' ignored for $env_var"
    }
  }

  # Replace cell
  lset deferred_cells $index [linsert $new_choices 0 {*}[lrange $cell_def 0 1]]
}

# Apply custom orders
reorder_deferred_cells deferred_cells 0 SYNTH_WRAPPED_ADDERS
reorder_deferred_cells deferred_cells 1 SYNTH_WRAPPED_MULTIPLIERS

techmap {*}[join [lmap cell $deferred_cells { string cat "-dont_map [lindex $cell 0]" }] " "]

foreach info $deferred_cells {
  set type [lindex $info 0]
  set naming_template [lindex $info 1]
  # default architecture and its suffix
  set default [lindex $info 2]
  set default_suffix [lindex $default 0]

  log -header "Generating architectural options for $type"
  log -push

  wrapcell \
    -setattr arithmetic_operator \
    -setattr copy_pending \
    -formatattr implements_operator $naming_template \
    -formatattr architecture $default_suffix \
    -formatattr source_cell $type \
    -name ${naming_template}_${default_suffix} \
    t:$type r:A_WIDTH>=10 r:Y_WIDTH>=14 %i %i

  # make per-architecture copies of the unmapped module
  foreach modname [tee -q -s result.string select -list-mod A:arithmetic_operator A:copy_pending %i] { # tclint-disable-line line-length
    setattr -mod -unset copy_pending $modname

    # iterate over non-default architectures
    foreach arch [lrange $info 3 end] {
      set suffix [lindex $arch 0]
      set base [rtlil::get_attr -string -mod $modname implements_operator]
      set newname ${base}_${suffix}
      yosys copy $modname $newname
      yosys setattr -mod -set architecture \"$suffix\" $newname
    }
  }

  # iterate over all architectures, both the default and non-default
  foreach arch [lrange $info 2 end] {
    set suffix [lindex $arch 0]
    set extra_map_args [lrange $arch 1 end]

    # map all operator copies which were selected to have this architecture
    techmap -map +/techmap.v {*}$extra_map_args A:source_cell=$type A:architecture=$suffix %i

    # booth isn't able to map all $macc configurations: catch if this is one
    # of those and delete the option
    delete A:source_cell=$type A:architecture=$suffix %i t:\$macc %m %i
  }

  log -pop
}

opt -fast -full
memory_map
opt -full
# Get rid of indigestibles
chformal -remove
setattr -mod -set abc9_script {"+&dch;&nf -R 5;"} A:arithmetic_operator
setattr -mod -set abc9_box 1 A:arithmetic_operator
techmap -map +/techmap.v -map +/choices/han-carlson.v
