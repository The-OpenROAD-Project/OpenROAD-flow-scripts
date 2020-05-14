proc block_channels {channel_width_in_microns} {
  set tech [ord::get_db_tech]
  set units [$tech getDbUnitsPerMicron]
  set block [ord::get_db_block]

  #
  # Collect up all the macros
  #
  set shapes {}
  foreach inst [$block getInsts] {
    if {[[$inst getMaster] getType] == "BLOCK"} {
      set box [$inst getBBox]
      lappend shapes [odb::newSetFromRect [$box xMin] [$box yMin] [$box xMax] [$box yMax]]
    }
  }

  # Put a halo around the core to block the outside edges between
  # the macros and the core area.
  set core [$block getCoreArea]
  set xl [$core xMin]
  set yl [$core yMin]
  set xh [$core xMax]
  set yh [$core yMax]

  lappend shapes [odb::newSetFromRect [expr $xl - 100] $yl $xl $yh]
  lappend shapes [odb::newSetFromRect $xh $yl [expr $xh + 100] $yh]
  lappend shapes [odb::newSetFromRect $xl [expr $yl - 100] $xh $yl]
  lappend shapes [odb::newSetFromRect $xl $yh $xh [expr $yh + 100]]

  #
  # Resize to fill the channels and edge gap
  #
  set resize_by [expr round($channel_width_in_microns / 2 * $units)]
  set shapeSet [odb::orSets $shapes]
  set shapeSet [odb::bloatSet $shapeSet $resize_by]
  set shapeSet [odb::shrinkSet $shapeSet $resize_by]

  #
  # Clip result to the core area (ie remove the halo)
  #
  set core_rect [odb::newSetFromRect $xl $yl $xh $yh]
  set shapeSet [odb::andSet $shapeSet $core_rect]

  #
  # Output the blockages
  #
  set rects [odb::getRectangles $shapeSet]
  foreach rect $rects {
    odb::dbBlockage_create $block \
        [$rect xMin] [$rect yMin] [$rect xMax] [$rect yMax]
  }
}

