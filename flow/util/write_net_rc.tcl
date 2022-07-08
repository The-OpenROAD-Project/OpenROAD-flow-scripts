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

proc write_rc_csv { filename } {
  upvar 1 gpl rc_var1
  upvar 1 grt rc_var2
  upvar 1 rcx rc_var3

  set max_layer_name $::env(MAX_ROUTING_LAYER)
  set max_layer [[[ord::get_db_tech] findLayer $max_layer_name] getRoutingLevel]
  set min_layer_name $::env(MIN_ROUTING_LAYER)
  set min_layer [[[ord::get_db_tech] findLayer $min_layer_name] getRoutingLevel]
  set stream [open $filename "w"]
  foreach net [get_nets *] {
    set net_name [get_full_name $net]
    lassign $rc_var1($net_name) wire_res1 wire_cap1
    lassign $rc_var2($net_name) wire_res2 wire_cap2
    lassign $rc_var3($net_name) wire_res3 wire_cap3
    puts -nonewline $stream "[get_full_name $net],[format %.3e $wire_res1],[format %.3e $wire_cap1],[format %.3e $wire_res2],[format %.3e $wire_cap2],[format %.3e $wire_res3],[format %.3e $wire_cap3]"
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

proc record_wire_rc { var_name } {
  upvar 1 $var_name var

  foreach net [get_nets *] {
    set net_name [get_full_name $net]
    set wire_res [net_wire_res $net]
    set wire_cap [net_wire_cap $net]
    set var($net_name) [list $wire_res $wire_cap]
  }
}

# Only works or makes sense for 2 pin nets.
proc net_wire_res { net } {
  set pins [get_pins -of_object $net]
  if { [llength $pins] == 2 } {
    lassign $pins pin1 pin2
    if { [$pin1 is_driver] } {
      set drvr $pin1
    } else {
      set drvr $pin2
    }
    lassign [sta::find_pi_elmore $drvr rise max] c2 rpi c1
    return $rpi
  } else {
    return 0.0
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
  lassign $cap_var($net_name1) res1 cap1
  lassign $cap_var($net_name2) res2 cap2
  expr $cap1 < $cap2
}

proc compare_wire_rc { count var_name ref_var_name } {
  global var_cap_less_name

  set i 0
  # implicit arg to net_var_cap_less
  set var_cap_less_name $ref_var_name
  set nets [lsort -command net_var_cap_less [get_nets *]]
  puts "net                 fanout    [format %5s $var_name]    [format %5s $ref_var_name]  wire total   [format %5s $var_name]    [format %5s $ref_var_name]"
  puts "                                cap      cap delta delta     res      res delta"
  set res_sum 0.0
  set res_count 0
  set cap_sum 0.0
  set total_cap_sum 0.0
  foreach net $nets {
    lassign [compare_wire_rc1 $net $var_name $ref_var_name] \
      res_delta res_count cap_delta total_delta
    set res_sum [expr $res_sum + $res_delta]
    set res_count [expr $res_count + $res_count]
    set cap_sum [expr $cap_sum + $cap_delta]
    set total_cap_sum [expr $total_cap_sum + $total_delta]
    if { $i >= $count } {
      break
    }
    incr i
  }
  set res_avg [expr $res_sum / $count]
  set cap_avg [expr $cap_sum / $count]
  set total_cap_avg [expr $total_cap_sum / $count]
  puts "                                             ----- -----                  -----"
  puts "                                             [format %+4.0f $cap_avg]% [format %+4.0f $total_cap_avg]%                  [format %+4.0f $res_avg]%"
}

proc compare_net_wire_rc { net_name var_name ref_var_name } {
  upvar 1 $var_name cap_var
  upvar 1 $ref_var_name ref_var
  global var_cap_less_name

  puts "net                 fanout    [format %5s $var_name]    [format %5s $ref_var_name]  wire total"
  puts "                                cap      cap delta delta"
  compare_wire_rc1 [get_net $net_name] $var_name $ref_var_name
}

proc compare_wire_rc1 { net var_name ref_var_name } {
  upvar 2 $var_name rc_var
  upvar 2 $ref_var_name ref_var

  set net_name [get_full_name $net]
  set pin_cap [net_pin_cap $net]
  lassign $rc_var($net_name) res wire_cap
  lassign $ref_var($net_name) res_ref wire_cap_ref

  if { $res != 0.0 } {
    set res_delta [expr ($res - $res_ref) / $res_ref * 100]
    set res_count 1
  } else {
    set res_delta 0.0
    set res_count 0
  }

  if { $wire_cap_ref != 0.0 } {
    set cap_delta [expr ($wire_cap - $wire_cap_ref) / $wire_cap_ref * 100]
  } else {
    set cap_delta 0.0
  }
  
  set total_cap [expr $pin_cap + $wire_cap]
  set total_cap_ref [expr $pin_cap + $wire_cap_ref]
  if { $total_cap_ref != 0.0 } {
    set total_delta [expr ($total_cap - $total_cap_ref) / $total_cap_ref * 100]
  } else {
    set total_delta 0.0
  }
  
  set fanout [llength [get_pins -of $net -filter "direction == input"]]

  puts -nonewline "[format %-20s $net_name] [format %5d $fanout] [format %8s [sta::format_capacitance $wire_cap 3]] [format %8s [sta::format_capacitance $wire_cap_ref 3]] [format %4.0f $cap_delta]% [format %4.0f $total_delta]%"
  if { $res > 0.0 } {
    puts "[format %8s [sta::format_resistance $res 3]] [format %8s [sta::format_resistance $res_ref 3]] [format %4.0f $res_delta]%"
  } else {
    puts ""
  }
  return [list $res_delta $res_count $cap_delta $total_delta]
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
