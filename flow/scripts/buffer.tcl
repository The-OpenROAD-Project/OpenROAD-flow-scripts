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

set floatingNetObjs ""
foreach net [get_nets *] {
  set pinCount [expr [llength [get_pins -of $net]] + [llength [get_ports -of $net]]]

  if {$pinCount == 1} {
    lappend floatingNetObjs $net
  }
}

# Print user message
if {[llength $floatingNetObjs] > 0} {
  puts "\n---------------------------------------------------------------------"
  puts "WARNING: [llength $floatingNetObjs] floating nets"
  # foreach net $floatingNetObjs {
  #   puts " - [get_full_name $net]"
  # }
}


################################################################################
# 3a) Handle Tie High
################################################################################

# Setup tie cell information
# ------------------------------------------------------------------------------
set tieHiCellName [lindex $::env(TIEHI_CELL_AND_PORT) 0]
set tieHiLibCell [get_lib_cells */$tieHiCellName]
set tieHiCellOutPin [lindex $::env(TIEHI_CELL_AND_PORT) 1]
set tieHiObjs [get_cells -filter "ref_name == $tieHiCellName"]


# Search for Tie Hie nets
set tieHiHighFanoutNetObjs ""
foreach net [get_nets -of $tieHiObjs] {
  set pinCount [llength [get_pins -of $net]]

  if {$pinCount > [expr $::env(MAX_FANOUT) + 1]} {
    lappend tieHiHighFanoutNetObjs $net
  }
}

# Print user message
if {[llength $tieHiHighFanoutNetObjs] > 0} {
  puts "\n---------------------------------------------------------------------"
  puts "[llength $tieHiHighFanoutNetObjs] tie high nets with high fanout exist"
  foreach net $tieHiHighFanoutNetObjs {
    puts -nonewline " - [get_full_name $net]"
    puts " ([llength [get_pins -of $net]] pins)"
  }
}

# Iterate through nets
foreach netObj $tieHiHighFanoutNetObjs {
  set netName [get_full_name $netObj]
  set tieHiSrcPinObj    [get_pins -of $netObj -filter "direction == output"]
  set tieHiSinkPinObjs  [get_pins -of $netObj -filter "direction == input"]


  set numTieHiCells [expr round(ceil([llength $tieHiSinkPinObjs] * 1.0 / $::env(MAX_FANOUT)))]

  delete_instance [get_full_name [get_cells -of $tieHiSrcPinObj]]
  delete_net $netObj

  set tieHiConnectCnt 0
  for {set i 0} {$i < $numTieHiCells} {incr i} {
    make_instance $netName\_$i $tieHiLibCell
    make_net $netName\_$i
    connect_pin $netName\_$i $netName\_$i/$tieHiCellOutPin

    set loopLimit [expr min($::env(MAX_FANOUT),[expr [llength $tieHiSinkPinObjs] - $tieHiConnectCnt])]
    for {set j 0} {$j < $loopLimit} {incr j} {
      connect_pin $netName\_$i [lindex $tieHiSinkPinObjs $tieHiConnectCnt]
      incr tieHiConnectCnt
    }
  }

  puts "Created $numTieHiCells tie high cells for $tieHiConnectCnt sinks"
}

################################################################################
# 3b) Handle Tie Low
# Same as Tie Hi (Should probably make it a function)
################################################################################


# Setup tie cell information
# ------------------------------------------------------------------------------
set tieLoCellName [lindex $::env(TIELO_CELL_AND_PORT) 0]
set tieLoLibCell [get_lib_cells */$tieLoCellName]
set tieLoCellOutPin [lindex $::env(TIELO_CELL_AND_PORT) 1]
set tieLoObjs [get_cells -filter "ref_name == $tieLoCellName"]



# Search for Tie Hie nets
set tieLoHighFanoutNetObjs ""
foreach net [get_nets -of $tieLoObjs] {
  set pinCount [llength [get_pins -of $net]]

  if {$pinCount > [expr $::env(MAX_FANOUT) + 1]} {
    lappend tieLoHighFanoutNetObjs $net
  }
}

# Print user message
if {[llength $tieLoHighFanoutNetObjs] > 0} {
  puts "\n---------------------------------------------------------------------"
  puts "[llength $tieLoHighFanoutNetObjs] tie low nets with high fanout exist"
  foreach net $tieLoHighFanoutNetObjs {
    puts -nonewline " - [get_full_name $net]"
    puts " ([llength [get_pins -of $net]] pins)"
  }
}

# Iterate through nets
foreach netObj $tieLoHighFanoutNetObjs {
  set netName [get_full_name $netObj]
  set tieLoSrcPinObj    [get_pins -of $netObj -filter "direction == output"]
  set tieLoSinkPinObjs  [get_pins -of $netObj -filter "direction == input"]


  set numTieLoCells [expr round(ceil([llength $tieLoSinkPinObjs] * 1.0 / $::env(MAX_FANOUT)))]

  delete_instance [get_full_name [get_cells -of $tieLoSrcPinObj]]
  delete_net $netObj

  set tieLoConnectCnt 0
  for {set i 0} {$i < $numTieLoCells} {incr i} {
    make_instance $netName\_$i $tieLoLibCell
    make_net $netName\_$i
    connect_pin $netName\_$i $netName\_$i/$tieLoCellOutPin

    set loopLimit [expr min($::env(MAX_FANOUT),[expr [llength $tieLoSinkPinObjs] - $tieLoConnectCnt])]
    for {set j 0} {$j < $loopLimit} {incr j} {
      connect_pin $netName\_$i [lindex $tieLoSinkPinObjs $tieLoConnectCnt]
      incr tieLoConnectCnt
    }
  }

  puts "Created $numTieLoCells tie low cells for $tieLoConnectCnt sinks"
}


################################################################################
# 4) Handle Other High Fanout nets
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

# Remove clock from list
set clkNetObj [get_nets $::env(CLOCK_PORT)]
if {$clkNetObj == ""} {
  puts "Error: Cannot find toplevel clock net - $::env(CLOCK_PORT). Check design configuration"
  exit -1
}
set idx [lsearch $highFanoutNetObjs $clkNetObj]
set highFanoutNetObjs [lreplace $highFanoutNetObjs $idx $idx]


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

