# A timing model's clock pin carries min_clock_tree_path and
# max_clock_tree_path: the earliest and the latest clock arrival at a
# register inside the block, measured from the pin. A parent's CTS
# balances the block by its max (cts LatencyBalancer: pin arrival plus
# max_clock_tree_path against the parent's registers), so a max below the
# min is a model that clocks the block late in every parent that reads
# it. Refuse it here, where it is made.
proc check_clock_tree_paths { lib_file } {
  set stream [open $lib_file r]
  set text [read $stream]
  close $stream
  set pins [regexp -all -inline -indices {pin\("([^"]+)"\)} $text]
  set re {timing_type : (min|max)_clock_tree_path;\s*}
  append re {cell_rise\(scalar\) \{\s*values\("([^"]+)"\);\s*\}\s*}
  append re {cell_fall\(scalar\) \{\s*values\("([^"]+)"\);}
  array set tree {}
  set parsed 0
  foreach {all min_max rise fall} [regexp -all -inline -indices $re $text] {
    incr parsed
    set at [lindex $all 0]
    set pin ""
    foreach {group name} $pins {
      if { [lindex $group 0] > $at } {
        break
      }
      set pin [string range $text {*}$name]
    }
    set tree($pin,[string range $text {*}$min_max]) \
      [list [string range $text {*}$rise] [string range $text {*}$fall]]
  }
  # A model written in a form the expression does not read would pass
  # unchecked; stop on it instead.
  set written [regexp -all {timing_type : (min|max)_clock_tree_path;} $text]
  if { $parsed != $written } {
    utl::error FLW 31 "[file tail $lib_file]: read $parsed of its $written\
      clock tree paths; check_clock_tree_paths.tcl does not know the form\
      of the others."
  }
  foreach key [lsort [array names tree *,max]] {
    set pin [string range $key 0 end-4]
    if { ![info exists tree($pin,min)] } {
      continue
    }
    foreach edge {rise fall} min $tree($pin,min) max $tree($pin,max) {
      if { $max < $min } {
        utl::error FLW 30 "[file tail $lib_file]: clock pin $pin's\
          max_clock_tree_path ($edge $max) is below its min_clock_tree_path\
          ($edge $min); a parent's CTS balances the block by the max and\
          would clock it late."
      }
    }
  }
}
