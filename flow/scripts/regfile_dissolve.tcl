# Register files in `mode netlist` (AUTO_MEMORIES_REGFILES) dissolve into
# their cells here, right after macro placement: to synthesis and to the
# macro placer each was a macro, its abstract's pins where its wires
# connect, so the placer chose its location and flip; from here on it is
# standard cells in the parent's rows. Before tapcells and the power grid,
# which see only cells.
#
# For each macro instance of a listed module, in the instance's module:
# every cell of the generator's structural netlist (memories/<m>.v) is
# created as <instance>/<cell>, the nets between them as
# <instance>/<net>, and each port's net is the net the macro's pin was
# on; the macro goes. The core -- the cells memories/<m>.place lists --
# is placed FIRM where the generator laid it out, through the macro's
# location and flip; the rest, the periphery (address decode), is left
# unplaced for global placement to place and the resizer to size.
# eliminate_dead_logic then removes what the parent never reads, as the
# synthesis ODB step does for every other cell.

proc regfile_netlist { file } {
  # one instance per line, as generate_regfile writes it:
  #   MASTER \name (.PIN(net), .PIN(\net ), ...);
  set cells {}
  set f [open $file r]
  while { [gets $f line] >= 0 } {
    if { ![regexp {^\s*(\S+)\s+\\?(\S+)\s*\((.*)\);\s*$} $line -> master name body] } {
      continue
    }
    set conns {}
    foreach {- pin net} [regexp -all -inline {\.(\w+)\(\s*\\?([^ )]+)\s*\)} $body] {
      lappend conns $pin $net
    }
    lappend cells [list $master $name $conns]
  }
  close $f
  return $cells
}

proc regfile_place_file { file } {
  set place [dict create]
  set f [open $file r]
  while { [gets $f line] >= 0 } {
    lassign $line name x y orient
    if { $name ne "" } { dict set place $name [list $x $y $orient] }
  }
  close $f
  return $place
}

proc regfile_flip_x { o } { return [dict get {R0 MX MX R0 MY R180 R180 MY} $o] }
proc regfile_flip_y { o } { return [dict get {R0 MY MY R0 MX R180 R180 MX} $o] }
proc regfile_row_kind { o } { return [expr { $o in {R0 MY} ? "R0" : "MX" }] }

# A cell is on the core's boundary when one of its nets reaches a port or
# a cell outside the core; a net is the core's own when every terminal of
# it is a placed cell of the core.
proc regfile_boundary_cell { inst placed } {
  foreach it [$inst getITerms] {
    set net [$it getNet]
    if { $net eq "NULL" } { continue }
    if { [llength [$net getBTerms]] > 0 } { return 1 }
    foreach other [$net getITerms] {
      if { ![dict exists $placed [[$other getInst] getName]] } { return 1 }
    }
  }
  return 0
}
proc regfile_internal_net { net placed } {
  if { [llength [$net getBTerms]] > 0 } { return 0 }
  foreach it [$net getITerms] {
    if { ![dict exists $placed [[$it getInst] getName]] } { return 0 }
  }
  return 1
}

set regfile_list "$::env(RESULTS_DIR)/memories/regfiles.txt"
set regfile_modules {}
if { [env_var_equals AUTO_MEMORIES 1] && [file exists $regfile_list] } {
  set f [open $regfile_list r]
  set regfile_modules [split [string trim [read $f]] "\n"]
  close $f
  set regfile_modules [lsearch -all -inline -not -exact $regfile_modules ""]
}
if { [llength $regfile_modules] > 0 } {
  set block [ord::get_db_block]
  set db [ord::get_db]
  set core [$block getCoreArea]
  set dbu [[ord::get_db_tech] getDbUnitsPerMicron]
  # the parent's rows by their bottom, for the parity check
  set row_orient [dict create]
  set row_h 0
  set site_w 0
  foreach row [$block getRows] {
    set bb [$row getBBox]
    dict set row_orient [$bb yMin] [$row getOrient]
    set row_h [expr { [$bb yMax] - [$bb yMin] }]
    set site_w [[$row getSite] getWidth]
  }
  set dissolved 0
  set fixups {}
  foreach module $regfile_modules {
    set macros {}
    foreach inst [$block getInsts] {
      if { [[$inst getMaster] getName] eq $module } { lappend macros $inst }
    }
    if { [llength $macros] == 0 } {
      utl::info FLW 9 "register file $module: no instance in the design (removed as dead logic)"
      continue
    }
    set cells [regfile_netlist "$::env(RESULTS_DIR)/memories/$module.v"]
    set place [regfile_place_file "$::env(RESULTS_DIR)/memories/$module.place"]
    foreach macro $macros {
      set path [$macro getName]
      set parent [$macro getModule]
      set master [$macro getMaster]
      set W [$master getWidth]
      set H [$master getHeight]
      set bb [$macro getBBox]
      set flip [$macro getOrient]
      if { $flip ni {R0 MX MY R180} } {
        utl::error FLW 10 "register file $path is placed $flip;\
          a register file flips, it does not rotate"
      }
      # snap the corner to the site and row grid of the core
      set X [expr {
        [$core xMin]
        + int(round(([$bb xMin] - [$core xMin]) / double($site_w))) * $site_w
      }]
      set Y [expr {
        [$core yMin]
        + int(round(([$bb yMin] - [$core yMin]) / double($row_h))) * $row_h
      }]
      # the macro's pins are the module's port bits; the nets they were on,
      # flat and in the macro's module. A cell on the flat net alone is
      # cut off from its module's net: STA propagates the clock through
      # the hierarchy and never reaches it.
      set ports [dict create]
      foreach mt [$master getMTerms] { dict set ports [$mt getName] 1 }
      set port_net [dict create]
      set port_modnet [dict create]
      foreach it [$macro getITerms] {
        set net [$it getNet]
        if { $net ne "NULL" } { dict set port_net [[$it getMTerm] getName] $net }
        set modnet [$it getModNet]
        if { $modnet ne "NULL" } { dict set port_modnet [[$it getMTerm] getName] $modnet }
      }
      # The macro placer's halo is a blockage tied to the macro; destroyed
      # with it, its instance id goes to one of the new cells and global
      # placement refuses a blockage on a movable cell (GPL-0003).
      foreach bl [$block getBlockages] {
        set owner [$bl getInstance]
        if { $owner ne "NULL" && [$owner getId] == [$macro getId] } {
          odb::dbBlockage_destroy $bl
        }
      }
      odb::dbInst_destroy $macro
      set placed [dict create]
      set placed_insts {}
      foreach cell $cells {
        lassign $cell mname name conns
        set m [$db findMaster $mname]
        if { $m eq "NULL" } {
          utl::error FLW 11 "register file $module: no master $mname for $name"
        }
        set inst [odb::dbInst_create $block $m "$path/$name" 0 $parent]
        foreach {pin netname} $conns {
          if { [dict exists $port_net $netname] } {
            set net [dict get $port_net $netname]
          } elseif { [dict exists $ports $netname] } {
            # a port bit the parent leaves unconnected
            continue
          } else {
            set full "$path/$netname"
            set net [$block findNet $full]
            if { $net eq "NULL" } { set net [odb::dbNet_create $block $full] }
          }
          set it [$inst findITerm $pin]
          if { $it eq "NULL" } {
            continue
          } elseif { [dict exists $port_modnet $netname] } {
            $it connect $net [dict get $port_modnet $netname]
          } else {
            $it connect $net
          }
        }
        if { [dict exists $place $name] } {
          lassign [dict get $place $name] cx cy o
          set w [$m getWidth]
          set h [$m getHeight]
          set x [expr { $cx }]
          set y [expr { $cy }]
          if { $flip in {MX R180} } {
            set y [expr { $H - $cy - $h }]
            set o [regfile_flip_x $o]
          }
          if { $flip in {MY R180} } {
            set x [expr { $W - $cx - $w }]
            set o [regfile_flip_y $o]
          }
          $inst setOrient $o
          $inst setLocation [expr { $X + $x }] [expr { $Y + $y }]
          dict set placed [$inst getName] 1
          lappend placed_insts $inst
        }
      }
      # Row parity: a core row lands on a parent row of its own kind, or
      # the whole core moves up one row.
      if { [llength $placed_insts] > 0 } {
        set probe [lindex $placed_insts 0]
        set py [[$probe getBBox] yMin]
        if {
          [dict exists $row_orient $py]
          && [regfile_row_kind [dict get $row_orient $py]] ne [regfile_row_kind [$probe getOrient]]
        } {
          foreach inst $placed_insts {
            set l [$inst getLocation]
            $inst setLocation [lindex $l 0] [expr { [lindex $l 1] + $row_h }]
          }
          set Y [expr { $Y + $row_h }]
        }
      }
      if {
        $X < [$core xMin] || $Y < [$core yMin]
        || $X + $W > [$core xMax] || $Y + $H > [$core yMax]
      } {
        set w_um [expr { $W / double($dbu) }]
        set h_um [expr { $H / double($dbu) }]
        set x_um [expr { $X / double($dbu) }]
        set y_um [expr { $Y / double($dbu) }]
        utl::error FLW 4 "register file $path ($module, $w_um x $h_um um)\
          at $x_um $y_um um leaves the core"
      }
      set placed_names {}
      foreach inst $placed_insts { lappend placed_names [$inst getName] }
      lappend fixups [list $module $path $flip $X $Y [llength $cells] $placed $placed_names]
      incr dissolved
    }
  }
  if { $dissolved > 0 } {
    # What the parent never reads or writes, as at the synthesis ODB: a
    # bit no one reads takes its column of the core with it. Before the
    # core is fixed, which the elimination would respect.
    log_cmd eliminate_dead_logic
    # Cut the rows around the macros now, as tapcell would: cut_rows
    # leaves a row that holds a fixed cell uncut (ODB-0386), so once the
    # core is FIRM a row it shares with a macro would run on under the
    # macro and take an endcap there.
    set cut_args {}
    if { [env_var_exists_and_non_empty TAP_CELL_NAME] } {
      lappend cut_args -endcap_master $::env(TAP_CELL_NAME)
    }
    if { [env_var_exists_and_non_empty MACRO_ROWS_HALO_X] } {
      lappend cut_args -halo_width_x $::env(MACRO_ROWS_HALO_X)
    }
    if { [env_var_exists_and_non_empty MACRO_ROWS_HALO_Y] } {
      lappend cut_args -halo_width_y $::env(MACRO_ROWS_HALO_Y)
    }
    log_cmd cut_rows {*}$cut_args
  }
  set row_boxes {}
  foreach row [$block getRows] { lappend row_boxes [$row getBBox] }
  foreach fixup $fixups {
    lassign $fixup module path flip X Y ncells placed placed_names
    set placed_insts {}
    foreach name $placed_names {
      set inst [$block findInst $name]
      if { $inst eq "NULL" } {
        dict unset placed $name
      } else {
        lappend placed_insts $inst
      }
    }
    foreach inst $placed_insts {
      set bb [$inst getBBox]
      set on_row 0
      foreach rb $row_boxes {
        if {
          [$bb xMin] >= [$rb xMin] && [$bb xMax] <= [$rb xMax]
          && [$bb yMin] == [$rb yMin]
        } {
          set on_row 1
          break
        }
      }
      if { !$on_row } {
        utl::error FLW 14 "register file $module at $path: [$inst getName]\
          is on no row once the rows are cut around the macros"
      }
      $inst setPlacementStatus FIRM
    }
    # The core is final: FIRM keeps the legaliser off it, dont_touch
    # keeps the resizer off it. Two kinds of cell are excepted. The
    # flops: CTS has to rewire their clock pins and a dont_touch
    # instance refuses (ODB-0370). The boundary cells, any with a pin on
    # a net that leaves the core: the parent's repair_design has to
    # buffer the nets that reach the core and cannot reconnect a
    # dont_touch load (RSZ-3006). They stay FIRM, so nothing resizes
    # them: OpenROAD keeps a fixed cell's footprint.
    foreach inst $placed_insts {
      if { ![[$inst getMaster] isSequential] && ![regfile_boundary_cell $inst $placed] } {
        $inst setDoNotTouch 1
      }
    }
    # The wires between the core's own cells are the generator's too:
    # repair_design buffers a net by inserting a cell before its loads,
    # and a dont_touch load refuses (ODB-1211, then RSZ-3006 fails the
    # stage). A net that leaves the core stays repairable. A violation
    # left inside is the generator's to fix.
    # Each net once: a net that leaves the core would otherwise be
    # rechecked from every one of its pins (the reset, the clock).
    set internal_nets 0
    set seen_nets [dict create]
    foreach inst $placed_insts {
      foreach it [$inst getITerms] {
        set net [$it getNet]
        if { $net eq "NULL" || [dict exists $seen_nets $net] } { continue }
        dict set seen_nets $net 1
        if { [$net isDoNotTouch] } { continue }
        if { [regfile_internal_net $net $placed] } {
          $net setDoNotTouch 1
          incr internal_nets
        }
      }
    }
    set dead [expr { [llength $placed_names] - [llength $placed_insts] }]
    set at_x [expr { $X / double($dbu) }]
    set at_y [expr { $Y / double($dbu) }]
    utl::info FLW 6 "register file $module at $path: $ncells cells,\
      [llength $placed_insts] FIRM ($flip at $at_x $at_y um), $dead dead,\
      $internal_nets internal nets dont_touch"
  }
  # Every flop of a dissolved core is one STA sees clocked: an unclocked
  # one is no timing endpoint, and placement and repair would work blind
  # to the paths through the array until CTS rewires its clock.
  if { $dissolved > 0 && [llength [all_clocks]] > 0 } {
    set clocked [dict create]
    foreach cell [all_registers -cells -clock [all_clocks]] {
      dict set clocked [[sta::sta_to_db_inst $cell] getName] 1
    }
    foreach fixup $fixups {
      lassign $fixup module path
      foreach name [lindex $fixup 7] {
        set inst [$block findInst $name]
        if {
          $inst ne "NULL" && [[$inst getMaster] isSequential]
          && ![dict exists $clocked $name]
        } {
          utl::error FLW 13 "register file $module at $path: STA sees no clock on $name"
        }
      }
    }
  }
}
