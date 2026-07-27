proc write_nets_rc_csv { filename } {
  upvar 1 grt grt_net_name_to_rc
  upvar 1 rcx rcx_net_name_to_rc

  set tech [ord::get_db_tech]
  set stream [open $filename "w"]

  puts -nonewline $stream "# stack:"
  foreach layer [[ord::get_db_tech] getLayers] {
    set routing [expr [$layer getRoutingLevel] != 0]
    set is_routing([$layer getNumber]) $routing
    set is_routing([$layer getNumber]) $routing
    puts -nonewline $stream " [$layer getName]"
    if { $routing } {
      puts -nonewline $stream "(routing)"
    } else {
      # insert via resistance information
      set via_resist [$layer getResistance]
      if { $via_resist != 0.0 } {
        puts -nonewline $stream "([format %.4e $via_resist])"
      }
    }
  }
  puts $stream ""

  set use_drt_data [env_var_exists_and_non_empty CORRELATE_DRT_WIRELENGTH]

  foreach net [get_nets *] {
    set db_net [sta::sta_to_db_net $net]
    set type [$db_net getSigType]
    if {
      ([string equal $type "CLOCK"] || [string equal $type "SIGNAL"]) &&
      (!$use_drt_data || [$db_net getWire] ne "NULL")
    } {
      set net_name [get_full_name $net]
      lassign $grt_net_name_to_rc($net_name) grt_net_res grt_net_cap
      lassign $rcx_net_name_to_rc($net_name) rcx_net_res rcx_net_cap
      set net_type [expr { [string equal $type "CLOCK"] ? "clock" : "signal" }]
      puts -nonewline $stream "[get_full_name $net],$net_type,"
      puts -nonewline $stream [concat \
        [format "%.3e" $grt_net_res] "," [format "%.3e" $grt_net_cap] "," \
        [format "%.3e" $rcx_net_res] "," [format "%.3e" $rcx_net_cap]]
      set db_net [sta::sta_to_db_net $net]

      if { $use_drt_data } {
        set layer_lengths [drt::route_layer_lengths [$db_net getWire]]
      } else {
        set layer_lengths [grt::route_layer_lengths $db_net]
      }

      for { set layer 0 } { $layer < [$tech getLayerCount] } { incr layer } {
        set length [lindex $layer_lengths $layer]
        if { $is_routing($layer) } {
          puts -nonewline $stream ",[ord::dbu_to_microns $length]"
        } else {
          puts -nonewline $stream ",$length"
        }
      }

      puts $stream ""
    }
  }
  close $stream
}

proc fetch_nets_rc { var_name } {
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
  return [rsz::sum_parasitic_network_resist $net]
}

proc net_wire_cap { net } {
  return [$net wire_capacitance [sta::cmd_scene] max]
}
