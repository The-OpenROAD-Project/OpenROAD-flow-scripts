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

  #
  # Resize to fill the channels and edge gap
  #
  set resize_by [expr round($channel_width_in_microns * $units)]
  set shapeSet0 [odb::orSets $shapes]
  set shapeSet1 [odb::bloatSet $shapeSet0 $resize_by]

  #
  # Clip result to the core area
  #
  set core [$block getCoreArea]
  set xl [$core xMin]
  set yl [$core yMin]
  set xh [$core xMax]
  set yh [$core yMax]
  set core_rect [odb::newSetFromRect $xl $yl $xh $yh]
  set shapeSet [odb::andSet $shapeSet1 $core_rect]

  #
  # Output the blockages
  #
  set rects [odb::getRectangles $shapeSet]
  foreach rect $rects {
      set b [odb::dbBlockage_create $block \
                 [$rect xMin] [$rect yMin] [$rect xMax] [$rect yMax]]
      $b setSoft
  }

  odb::destroySet $shapeSet
  odb::destroySet $shapeSet1
  odb::destroySet $shapeSet0
  odb::destroySet $core_rect

  foreach shape $shapes {
        odb::destroySet $shape
  }
}

