proc report_wire_caps { count } {
  set nets [lsort -command net_wire_cap_less [get_nets *]]
  set i 0
  foreach net $nets {
    set wire_cap [net_wire_cap $net]
    puts "[get_full_name $net] [sta::format_capacitance $wire_cap 3]"
    if { $i >= $count } {
      break
    }
    incr i
  }
}

proc net_wire_cap_less { net1 net2 } {
  expr [net_wire_cap $net1] < [net_wire_cap $net2]
}

proc report_var_caps { var_name count } {
  upvar 1 $var_name var
  global cap_var_name

  set cap_var_name $var_name
  set nets [lsort -command net_var_cap_less [get_nets *]]
  set i 0
  foreach net $nets {
    set net_name [get_full_name $net]
    puts "$net_name [sta::format_capacitance $var($net_name) 3]"
    if { $i >= $count } {
      break
    }
    incr i
  }
}

proc write_caps_csv { filename } {
  upvar 1 gpl cap_var1
  upvar 1 grt cap_var2
  upvar 1 rcx cap_var3

  set max_layer_name $::env(MAX_ROUTING_LAYER)
  set max_layer [[[ord::get_db_tech] findLayer $max_layer_name] getRoutingLevel]
  set min_layer_name $::env(MIN_ROUTING_LAYER)
  set min_layer [[[ord::get_db_tech] findLayer $min_layer_name] getRoutingLevel]
  set stream [open $filename "w"]
  foreach net [get_nets *] {
    set net_name [get_full_name $net]
    set wire_cap1 $cap_var1($net_name)
    set wire_cap2 $cap_var2($net_name)
    set wire_cap3 $cap_var3($net_name)
    puts -nonewline $stream "[get_full_name $net],[format %.3e $wire_cap1],[format %.3e $wire_cap2],[format %.3e $wire_cap3]"
    set db_net [sta::sta_to_db_net $net]
    set layer_lengths [grt::route_layer_lengths $db_net]
    for {set layer $min_layer} {$layer <= $max_layer} {incr layer} {
      set layer_name [[[ord::get_db_tech] findRoutingLayer $layer] getName]
      set length [lindex $layer_lengths $layer]
      puts -nonewline $stream ",$layer_name,[ord::dbu_to_microns $length]"
    }
    puts $stream ""
  }
  close $stream
}

proc record_wire_caps { var_name } {
  upvar 1 $var_name var

  foreach net [get_nets *] {
    set net_name [get_full_name $net]
    set var($net_name) [net_wire_cap $net]
  }
}

proc net_wire_cap { net } {
  return [$net wire_capacitance [sta::cmd_corner] max]
}

proc net_pin_cap { net } {
  return [$net pin_capacitance [sta::cmd_corner] max]
}

proc net_wire_cap_less { net1 net2 } {
  expr [net_wire_cap $net1] < [net_wire_cap $net2]
}

proc net_var_cap_less { net1 net2 } {
  global var_cap_less_name
  upvar 2 $var_cap_less_name cap_var

  set net_name1 [get_full_name $net1]
  set net_name2 [get_full_name $net2]
  expr $cap_var($net_name1) < $cap_var($net_name2)
}

proc compare_wire_caps { count cap_var_name ref_var_name } {
  global var_cap_less_name

  set i 0
  # implicit arg to net_var_cap_less
  set var_cap_less_name $ref_var_name
  set nets [lsort -command net_var_cap_less [get_nets *]]
  puts "net               fanout   [format %5s $cap_var_name] [format %5s $ref_var_name]  wire total"
  puts "                            wire  wire delta delta"
  set wire_sum 0.0
  set total_sum 0.0
  foreach net $nets {
    lassign [compare_wire_caps1 $net $cap_var_name $ref_var_name $wire_sum $total_sum] \
      wire_sum total_sum
    if { $i >= $count } {
      break
    }
    incr i
  }
  set wire_avg [expr $wire_sum / $count]
  set total_avg [expr $total_sum / $count]
  puts "                                       ----- -----"
  puts "                                       [format %+4.0f $wire_avg]% [format %+4.0f $total_avg]%"
}

proc compare_net_wire_caps { net_name cap_var_name ref_var_name } {
  upvar 1 $cap_var_name cap_var
  upvar 1 $ref_var_name ref_var
  global var_cap_less_name

  puts "net               fanout   [format %5s $cap_var_name] [format %5s $ref_var_name]  wire total"
  puts "                            wire  wire delta delta"
  compare_wire_caps1 [get_net $net_name] $cap_var_name $ref_var_name 0.0 0.0
}

proc compare_wire_caps1 { net cap_var_name ref_var_name wire_sum total_sum f } {
  upvar 2 $cap_var_name cap_var
  upvar 2 $ref_var_name ref_var

  set net_name [get_full_name $net]
  set pin_cap [net_pin_cap $net]
  set wire_cap $cap_var($net_name)
  set wire_cap_ref $ref_var($net_name)
  if { $wire_cap_ref != 0.0 } {
    set wire_delta [expr ($wire_cap - $wire_cap_ref) / $wire_cap_ref * 100]
  } else {
    set wire_delta 0.0
  }
  set wire_sum [expr $wire_sum + $wire_delta]
  
  set total_cap [expr $pin_cap + $wire_cap]
  set total_cap_ref [expr $pin_cap + $wire_cap_ref]
  if { $total_cap_ref != 0.0 } {
    set total_delta [expr ($total_cap - $total_cap_ref) / $total_cap_ref * 100]
  } else {
    set total_delta 0.0
  }
  set total_sum [expr $total_sum + $total_delta]
  
  set fanout [llength [get_pins -of $net -filter "direction == input"]]
  puts $f "$net_name,$fanout,$wire_cap,$wire_cap_ref,$wire_delta%,$total_delta%"
  return [list $wire_sum $total_sum]
}

# adjustment is percent to adjust (ie, 10 for +10%).
proc write_layer_rc_cmds { adjustment } {
  foreach layer [[ord::get_db_tech] getLayers] {
    if { [$layer getRoutingLevel] > 0 } {
      set res_per_sq [$layer getResistance]
      set wire_width [ord::dbu_to_microns [$layer getWidth]]
      # Convert ohms/square to resistance/wire_length (ohms/micron)
      set res [expr $res_per_sq / $wire_width]

      set cap_edge [$layer getEdgeCapacitance]
      set cap_area [$layer getCapacitance]
      # Convert pF/um to F/um.
      set cap [expr ($cap_edge * 2.0 + $wire_width * $cap_area) * 1e-12 / (1.0 + $adjustment / 100.0)]
      puts "set_layer_rc -layer [$layer getConstName] -resistance [format %.4e [sta::resistance_sta_ui $res]] -capacitance [format %.4e [sta::capacitance_sta_ui $cap]]"
    }
  }
}
