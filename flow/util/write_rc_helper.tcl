# Helpers for Nets Data
#===============================================================================

proc fetch_nets_rc { var_name } {
  upvar 1 $var_name var

  foreach db_net [[ord::get_db_block] getNets] {
    set sta_net [sta::db_net_to_sta $db_net]
    set wire_res [net_wire_res $sta_net]
    set wire_cap [net_wire_cap $sta_net]
    set var([$db_net getName]) [list $wire_res $wire_cap]
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

  # First, write a header naming the data and listing the layer stack, which
  # is only read back as a fingerprint of the stack.
  puts -nonewline $stream "# Net RC:"
  foreach layer [$tech getLayers] {
    puts -nonewline $stream " [$layer getName]"
    if { [$layer getRoutingLevel] != 0 } {
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

  # Then, write the parasitics data of each net.
  foreach db_net [[ord::get_db_block] getNets] {
    set type [$db_net getSigType]

    if { !([string equal $type "CLOCK"] || [string equal $type "SIGNAL"]) } {
      continue
    }

    set net_name [$db_net getName]
    set net_type [expr { $type eq "CLOCK" ? "clock" : "signal" }]

    lassign $grt_net_name_to_rc($net_name) grt_net_res grt_net_cap
    lassign $rcx_net_name_to_rc($net_name) rcx_net_res rcx_net_cap

    puts $stream [format "%s,%s,%.3e,%.3e,%.3e,%.3e" \
      $net_name $net_type $grt_net_res $grt_net_cap $rcx_net_res $rcx_net_cap]
  }

  close $stream
}

# Helpers for Segments Data
#===============================================================================

# This function only works if each routing wire shape corresponds
# to one parasitic resistive model.
proc fetch_segments_rc { net_to_segments_var } {
  upvar 1 $net_to_segments_var net_to_segments

  foreach db_net [[ord::get_db_block] getNets] {
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

    set net_to_segments([$db_net getName]) $segments
  }
}

proc write_segments_rc_csv { filename net_to_segments_var } {
  upvar 1 $net_to_segments_var net_to_segments

  set stream [open $filename "w"]

  # First, write a header naming the data and listing the routing layers in
  # stack order.
  puts -nonewline $stream "# Segment RC:"
  foreach layer [[ord::get_db_tech] getLayers] {
    if { [$layer getRoutingLevel] != 0 } {
      puts -nonewline $stream " [$layer getName]"
    }
  }

  puts $stream ""

  # Then, write the parasitics data of each wire segment.
  foreach db_net [[ord::get_db_block] getNets] {
    set net_name [$db_net getName]

    if { ![info exists net_to_segments($net_name)] } {
      continue
    }

    set type [$db_net getSigType]
    set net_type [expr { $type eq "CLOCK" ? "clock" : "signal" }]

    foreach {layer length_um resistance capacitance} $net_to_segments($net_name) {
      puts $stream [format "%s,%s,%s,%.3e,%.3e,%.3e" \
        $net_name $net_type $layer $length_um $resistance $capacitance]
    }
  }

  close $stream
}
