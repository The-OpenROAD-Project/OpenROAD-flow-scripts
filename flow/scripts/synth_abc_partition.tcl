# Technology mapping with one abc call per register group
# (SYNTH_ABC_PARTITION).
#
# abc maps a netlist against a single delay target, the netlist's own
# critical path, and recovers area on every cone that is faster than that.
# A cone that is not the deepest one in the module is rebuilt smaller and
# slower, even when it limits the design.  Mapping each register group
# separately gives every group its own critical path.
#
# Flops (liberty cells after dfflibmap) are grouped by name with bit indices
# and the "$_DFF..." suffix removed.  A group's cone is the still-unmapped
# combinational fan-in of its flops' inputs.  Groups are mapped largest cone
# first; logic shared by several groups goes to the first group that
# reaches it.  Groups with fewer than min_cells unmapped cells, and anything
# left over, are mapped by one final abc call.
proc synth_abc_partition { abc_args min_cells } {
  set top $::env(DESIGN_NAME)
  set groups [dict create]
  foreach cell [tee -q -s result.string select -list "$top/t:*" "$top/t:\$*" %d] {
    set name [string range $cell [string length "$top/"] end]
    regsub {\$_.*$} $name {} key
    regsub -all {\[[0-9]+\]} $key {} key
    if { $key ne "" } {
      dict incr groups $key
    }
  }

  # '?' stands for the '[' or '$' after the base name; groups whose name
  # extends this one (acc vs. acc_next) are removed from the selection.
  set keys [dict keys $groups]
  set sized {}
  foreach key $keys {
    set sel [list "$top/$key?*"]
    foreach other $keys {
      if { $other ne $key && [string match "$key*" $other] } {
        lappend sel "$top/$other?*" %d
      }
    }
    select -set abc_partition_group {*}$sel
    # select -count returns "<n> objects."
    regexp {[0-9]+} [tee -q -s result.string select -count \
      @abc_partition_group %ci1 %cie* "$top/t:\$_*" %i] n
    lappend sized [list $key $n $sel]
  }

  set i 0
  foreach group [lsort -integer -decreasing -index 1 $sized] {
    lassign $group key n sel
    if { $n < $min_cells } {
      continue
    }
    select -set abc_partition_group {*}$sel
    select -set abc_partition_cone \
      @abc_partition_group %ci1 %cie* "$top/t:\$_*" %i
    regexp {[0-9]+} [tee -q -s result.string select -count @abc_partition_cone] left
    if { $left < $min_cells } {
      continue
    }
    puts "abc partition [incr i]: $key, $left cells"
    log_cmd abc {*}$abc_args @abc_partition_cone
  }
  puts "abc partition: remaining logic"
  log_cmd abc {*}$abc_args "t:\$_*"
  select -clear
}
