# fish out values from single source of truth: config.py
set vals [regexp -all -inline {\S+} [exec sh -c {cd designs/asap7/mock-array && python3 -c "import config;print(f'{config.rows} {config.cols} {config.pitch_x} {config.pitch_y} {config.array_offset_x} {config.array_offset_y} {config.placement_grid_x} {config.placement_grid_y}')"}]]
lassign $vals rows cols pitch_x pitch_y array_offset_x array_offset_y placement_grid_x placement_grid_y

set block [ord::get_db_block]
set units [$block getDefUnits]

for {set row 0} {$row < $rows} {incr row} {
  for {set col 0} {$col < $cols} {incr col} {
    set inst [$block findInst [format "ces_%d_%d" $row $col]]

    set x [expr round((($array_offset_x + (($placement_grid_x * $pitch_x) * $col)) * $units))]
    set y [expr round((($array_offset_y + (($placement_grid_y * $pitch_y) * $row)) * $units))]

    # belt and suspenders check... ASAP7 macro placement must be aligned to 0.048um
    if {$x % 48 != 0} {
        error "x=$x is not divisible by 48"
    }
    if {$y % 48 != 0} {
        error "y=$y is not divisible by 48"
    }

    $inst setOrient R0
    $inst setOrigin $x $y
    $inst setPlacementStatus FIRM
  }
}
