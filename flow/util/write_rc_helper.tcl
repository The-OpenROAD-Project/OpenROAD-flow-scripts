# Helpers for Nets Data
#===============================================================================

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

proc write_nets_rc_csv { filename grt_var rcx_var } {
  upvar 1 $grt_var grt_net_name_to_rc
  upvar 1 $rcx_var rcx_net_name_to_rc

  set tech [ord::get_db_tech]
  set stream [open $filename "w"]

  puts -nonewline $stream "# stack:"
  foreach layer [$tech getLayers] {
    set routing [expr [$layer getRoutingLevel] != 0]
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
      puts -nonewline $stream "$net_name,$net_type,"
      puts -nonewline $stream [concat \
        [format "%.3e" $grt_net_res] "," [format "%.3e" $grt_net_cap] "," \
        [format "%.3e" $rcx_net_res] "," [format "%.3e" $rcx_net_cap]]

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

# Helpers for Segments Data
#===============================================================================

# This function only works if each routing wire shape corresponds
# to one parasitic resistive model.
proc fetch_segments_rc { net_to_segments_var } {
  upvar 1 $net_to_segments_var net_to_segments

  foreach sta_net [get_nets -hierarchical *] {
    set db_net [sta::sta_to_db_net $sta_net]
    set type [$db_net getSigType]

    if { !([string equal $type "CLOCK"] || [string equal $type "SIGNAL"]) } {
      continue
    }

    set wire [$db_net getWire]

    if { $wire eq "NULL" } {
      continue
    }

    set segments {}
    set seen_shape_ids {}
    foreach rseg [$db_net getRSegs] {
      set shape [$wire getShape [$rseg getShapeId]]

      # We skip vias as they have no capacitance in RCX.
      if { ![$shape isSegment] } {
        continue
      }

      set shape_id [$rseg getShapeId]

      if { $shape_id in $seen_shape_ids } {
        error "Could not fetch segment parasitics data: shape\
               $shape_id on net [$db_net getName] has multiple rsegs."
      }

      set layer [[$shape getTechLayer] getName]

      set width [$shape getDX]
      set height [$shape getDY]
      set length_um [ord::dbu_to_microns [expr { max($width, $height) }]]

      # Default corner
      set corner 0
      set resistance [$rseg getResistance $corner]
      set capacitance [$rseg getTotalCapacitance $corner]

      lappend segments $layer $length_um $resistance $capacitance
      lappend seen_shape_ids $shape_id
    }

    set net_to_segments([get_full_name $sta_net]) $segments
  }
}

proc write_segments_rc_csv { filename net_to_segments_var } {
  upvar 1 $net_to_segments_var net_to_segments

  set stream [open $filename "w"]

  # First, write a header listing the routing layers in stack order.
  puts -nonewline $stream "# routing layers:"
  foreach layer [[ord::get_db_tech] getLayers] {
    if { [$layer getRoutingLevel] != 0 } {
      puts -nonewline $stream " [$layer getName]"
    }
  }

  puts $stream ""

  # Then, write the parasitics data of each wire segment.
  foreach sta_net [get_nets -hierarchical *] {
    set net_name [get_full_name $sta_net]

    if { ![info exists net_to_segments($net_name)] } {
      continue
    }

    set db_net [sta::sta_to_db_net $sta_net]
    set type [$db_net getSigType]
    set net_type [expr { $type eq "CLOCK" ? "clock" : "signal" }]

    foreach {layer length_um resistance capacitance} $net_to_segments($net_name) {
      puts $stream [format "%s,%s,%s,%.3e,%.3e,%.3e" \
        $net_name $net_type $layer $length_um $resistance $capacitance]
    }
  }

  close $stream
}
