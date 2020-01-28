################################################################################
# This script is intended to be run in the OpenSTA/Resizer framework.
#
# Purpose: It reads an input verilog file (from yosys) and performs buffering on
#          high fanout nets to reduce routing/congestion issues experienced by
#          tools further down in the flow.
#          - For high fanout nets from tie-hi/low cells, the script adds more
#            of the tie cells instead of buffering
#          - The primary clock net ($::env(CLOCK_PORT)) is excluded from buffering
#          - Other high fanout nets are buffered using an algorithm that attempts
#            to implement a balanced tree
# Author: Tutu Ajayi
#
################################################################################


################################################################################
# 1) Open the design
################################################################################
if {![info exists standalone] || $standalone} {
  # Read liberty files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }

  # Read tech LEF
  read_lef $::env(OBJECTS_DIR)/merged.lef

  # Read verilog
  read_verilog $::env(RESULTS_DIR)/1_1_yosys.v

  # Link the design
  link_design $::env(DESIGN_NAME)

  # Read sdc
  read_sdc $::env(SDC_FILE)
}

puts "Max Fanout Settings: $::env(MAX_FANOUT)"

################################################################################
# 2) Search for floating nets and print them out
################################################################################

puts "\n---------------------------------------------------------------------"
puts "Floating Nets:"
report_floating_nets -verbose


################################################################################
# 3) Handle Other High Fanout nets
################################################################################


# Setup buffer cell information
# ------------------------------------------------------------------------------
set bufferCell [lindex $::env(MIN_BUF_CELL_AND_PORTS) 0]
set bufferLibCellObj [get_lib_cells */$bufferCell]
set bufferCellInPin [lindex $::env(MIN_BUF_CELL_AND_PORTS) 1]
set bufferCellOutPin [lindex $::env(MIN_BUF_CELL_AND_PORTS) 2]


# Search for high fanout nets
set highFanoutNetObjs ""
foreach net [get_nets *] {
  set pinCount [llength [get_pins -of $net]]

  if {$pinCount > [expr $::env(MAX_FANOUT) + 1]} {
    lappend highFanoutNetObjs $net
  }
}

# Remove clocks from list
foreach clk [get_clocks *] {
  set clkNetObj [get_net -of [get_name [get_property $clk sources]]]
  puts "Skipping buffering for clk: [get_name $clk]"
  set idx [lsearch $highFanoutNetObjs $clkNetObj]
  set highFanoutNetObjs [lreplace $highFanoutNetObjs $idx $idx]

}

# Print user message
if {[llength $highFanoutNetObjs] > 0} {
  puts "[llength $highFanoutNetObjs] High Fanout out nets exist"
  foreach net $highFanoutNetObjs {
    puts -nonewline " - [get_full_name $net]"
    puts " ([llength [get_pins -of $net]] pins)"
  }
}



################################################################################
# Process each high fanout net
################################################################################
foreach netObj $highFanoutNetObjs {
  puts "\n---------------------------------------------------------------------"
  puts "Buffering Net: [get_full_name $netObj]"

  set netSrcObj    [get_pins -of $netObj -filter "direction == output"]
  # The source may fail to set if it's a toplevel port. Falling back to that
  set netSrcObjisPort 0
  if {$netSrcObj == ""} {
    set netSrcObj [get_ports -of $netObj]
    set netSrcObjisPort 1
  }

  # HACK ALERT:
  # Removing the last entry in the sink list... really hope this is this is
  # the pin associated with a Port.
  set netSinkPinObjs  [get_pins -of $netObj -filter "direction == input"]
  if {$netSrcObjisPort} {
    set netSinkPinObjs [lreplace $netSinkPinObjs [expr [llength $netSinkPinObjs] -1] [expr [llength $netSinkPinObjs] -1]]
  }

  set netSinkPinCnt   [llength $netSinkPinObjs]

  puts "Source Pin: [get_full_name $netSrcObj]"
  puts "Sink Pin Count: $netSinkPinCnt"


  # Figure out how many levels of buffering are required
  set iterator $netSinkPinCnt
  set bufferHier ""
  while {$iterator > $::env(MAX_FANOUT)} {
    set iterator [expr $iterator * 1.0 / $::env(MAX_FANOUT)]
    lappend bufferHier [expr round(ceil($iterator))]
  }

  set bufferHier [lreverse $bufferHier]
  puts "Buffer Hierarchy: $bufferHier"

  set numLevels [llength $bufferHier]
  puts "Number of levels: $numLevels"

  # Disconnect all sinks
  # ------------------------------------------------------------------------------
  foreach var $netSinkPinObjs {
    disconnect_pin $netObj $var
  }



  # Simple procedure to format buffer names
  # ------------------------------------------------------------------------------
  proc bufName {node} {
    return buf_[join $node "_"]
  }

  # Simple procedure to format buffer net names
  # ------------------------------------------------------------------------------
  proc bufNetName {node} {
    return bufnet_[join $node "_"]
  }

  # This procedure calculates the next buffer node based on the number of levels
  # and the maximum fanout.
  # The goal is to increment the indexes in the nodeBuffer while respecting max
  # fanout.
  # e.g with Fanout at 10:
  #     "0 0 0"-> "0 0 1"
  #     "0 0 9"-> "0 1 0"
  #     "0 1 9"-> "0 2 0"
  # ------------------------------------------------------------------------------
  proc nextBuffer {curBuffer} {
    # global ::env(MAX_FANOUT)
    set levels [llength $curBuffer]

    # ----------------------------------------------------------------------------
    set incrDone 0
    set nxtBuffer ""

    # iterate through each level and calculate the index
    for {set i [expr $levels-1]} {$i >= 0} {incr i -1} {
      if {$incrDone} {
        # if increment is already done, preserve the index number
        set nxtBuffer "[lindex $curBuffer $i] $nxtBuffer"

        } elseif {[lindex $curBuffer $i] == [expr $::env(MAX_FANOUT) - 1]} {
        # if current level is at max fanout then reset to zero
        set nxtBuffer "0 $nxtBuffer"

        } else {
        # increment level by 1
        set nxtBuffer "[expr [lindex $curBuffer $i] + 1] $nxtBuffer"
        set incrDone 1
      }
    }

    return $nxtBuffer
  }

  # Prepare loop variables
  # ------------------------------------------------------------------------------
  set currentSinkCnt 0
  set levels [llength $bufferHier]
  for {set i 0} {$i < $levels} {incr i} {
    lappend curBuffer 0
  }
  # puts "DEBUG: Init Buffer: $curBuffer"
  set createBufferCnt 0


  # Loop through buffer node space connecting sinks along the way
  # ------------------------------------------------------------------------------
  while {$currentSinkCnt < $netSinkPinCnt} {

    # If first leaf buffer, create all parents
    if {[lindex $curBuffer end] == 0} {

      for {set i 1} {$i < $levels} {incr i} {
        # If parent does not not exist
        set parentBuf [lrange $curBuffer 0 end-$i]
        if {[get_cells -quiet [bufName $parentBuf]] == ""} {
          # puts "DEBUG: Make parent buf instance [bufName $parentBuf]"
          make_instance [bufName $parentBuf] $bufferLibCellObj
          incr createBufferCnt
          make_net [bufNetName $parentBuf]
          connect_pin [bufNetName $parentBuf] [bufName $parentBuf]/$bufferCellOutPin
          if {$i == [expr $levels-1]} {
            # Connect top level buffer to source node
            # puts "DEBUG: Connect buf pin ([bufName $parentBuf]/$bufferCellInPin) to root net ($netObj)"
            connect_pin $netObj [bufName $parentBuf]/$bufferCellInPin
            } else {
            # Connect buffer to parent buffer
            # puts "DEBUG: Connect buf pin ([bufName $parentBuf]/$bufferCellInPin) to parent buf ([bufNetName [lrange $parentBuf 0 end-1]])"
            connect_pin [bufNetName [lrange $parentBuf 0 end-1]] [bufName $parentBuf]/$bufferCellInPin
          }
        }
      }
    }


    # create leaf buffer
    # ----------------------------------------------------------------------------
    # puts "DEBUG: Create leaf buffer [bufName $curBuffer]"
    make_instance [bufName $curBuffer] $bufferLibCellObj
    incr createBufferCnt
    make_net [bufNetName $curBuffer]
    connect_pin [bufNetName $curBuffer] [bufName $curBuffer]/$bufferCellOutPin

    set sinkConnectCnt [expr min($::env(MAX_FANOUT),[expr $netSinkPinCnt - $currentSinkCnt])]
    # puts "DEBUG: Connect $sinkConnectCnt sinks"

    for {set i 0} {$i < $sinkConnectCnt} {incr i} {
      # puts "DEBUG: Connect sink ([lindex $netSinkPinObjs $currentSinkCnt]) to leaf buffer ([bufNetName $curBuffer])"
      connect_pin [bufNetName $curBuffer] [lindex $netSinkPinObjs $currentSinkCnt]
      incr currentSinkCnt
    }

    # connect leaf buffer to parent/root
    if {$levels == 1} {
      # puts "DEBUG: Connect leaf buf pin ([bufName $curBuffer]/$bufferCellInPin) to root net ($netObj)"
      connect_pin $netObj [bufName $curBuffer]/$bufferCellInPin
      } else {
      # puts "DEBUG: Connect leaf buf pin ([bufName $curBuffer]/$bufferCellInPin) to parent bufnet ([bufNetName [lrange $curBuffer 0 end-1]])"
      connect_pin [bufNetName [lrange $curBuffer 0 end-1]] [bufName $curBuffer]/$bufferCellInPin
    }

    set curBuffer [nextBuffer $curBuffer]
    # puts "DEBUG: Set Current Buffer: [bufName $curBuffer]"
    # puts "DEBUG: Current Sink Count: $currentSinkCnt"

  }

  puts "Created $createBufferCnt buffers for net [get_full_name $netObj]"

}


puts "\nSaving verilog+sdc..."
write_verilog $::env(RESULTS_DIR)/1_2_buffer.v
write_sdc $::env(RESULTS_DIR)/1_synth.sdc



# final report
report_checks > $::env(REPORTS_DIR)/1_synth_checks.rpt
report_tns > $::env(REPORTS_DIR)/1_synth_tns.rpt
report_wns > $::env(REPORTS_DIR)/1_synth_wns.rpt


if {![info exists standalone] || $standalone} {
  exit
}

