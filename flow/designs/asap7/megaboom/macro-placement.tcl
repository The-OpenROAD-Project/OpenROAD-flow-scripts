# pre place all macro
# 
set block    [ord::get_db_block]
set units    [$block getDefUnits]

set coreArea [$block getCoreArea]
set xMin     [$coreArea xMin]
set yMin     [$coreArea yMin]

# macro pins on M4 starts with an offset of 0.012 from the bottom
# of the macro; then, will need to adjust the placement of the macro
# such that the pins will be on M4 grid
set x $xMin
set y [expr $yMin - int(0.012 * $units)]

# the algorithm is to place macro such what if 2 macros are side by side,
# the macro should be flip alternately
set orientList [list R0 MY]
set flag 1
foreach instName [list \
                    coreplex/RocketTile/frontend/icache/_T_850/_T_850_ext/u_ram \
                    coreplex/RocketTile/frontend/icache/_T_869/_T_850_ext/u_ram \
                    coreplex/RocketTile/frontend/icache/_T_888/_T_850_ext/u_ram \
                    coreplex/RocketTile/frontend/icache/_T_907/_T_850_ext/u_ram \
                    coreplex/RocketTile/dcache/data/_T_118/_T_80_ext/u_ram_bank_0 \
                    coreplex/RocketTile/dcache/data/_T_118/_T_80_ext/u_ram_bank_1 \
                    coreplex/RocketTile/dcache/data/_T_215/_T_80_ext/u_ram_bank_0 \
                    coreplex/RocketTile/dcache/data/_T_215/_T_80_ext/u_ram_bank_1 \
                    coreplex/RocketTile/dcache/data/_T_253/_T_80_ext/u_ram_bank_0 \
                    coreplex/RocketTile/dcache/data/_T_253/_T_80_ext/u_ram_bank_1 \
                    coreplex/RocketTile/dcache/data/_T_80/_T_80_ext/u_ram_bank_0 \
                    coreplex/RocketTile/dcache/data/_T_80/_T_80_ext/u_ram_bank_1 \
                    coreplex/RocketTile/core/bpd_stage/br_predictor/counters/h_table/h_table/smem/smem_0_ext/u_regfile \
                    coreplex/RocketTile/dcache/meta/_T_157/_T_157_ext/u_ram_bank_0 \
                    coreplex/RocketTile/dcache/meta/_T_157/_T_157_ext/u_ram_bank_1 \
                    coreplex/RocketTile/dcache/meta/_T_157/_T_157_ext/u_ram_bank_2 \
                    coreplex/RocketTile/dcache/meta/_T_157/_T_157_ext/u_ram_bank_3 \
                    coreplex/RocketTile/frontend/icache/tag_array/tag_array_ext/u_ram_bank_0 \
                    coreplex/RocketTile/frontend/icache/tag_array/tag_array_ext/u_ram_bank_1 \
                    coreplex/RocketTile/frontend/icache/tag_array/tag_array_ext/u_ram_bank_2 \
                    coreplex/RocketTile/frontend/icache/tag_array/tag_array_ext/u_ram_bank_3 \
                    coreplex/RocketTile/core/bpd_stage/br_predictor/counters/p_table/p_table_0/smem/u_smem_ext/u_regfile \
                    coreplex/RocketTile/core/bpd_stage/br_predictor/counters/p_table/p_table_1/smem/u_smem_ext/u_regfile \
                    coreplex/RocketTile/core/bpd_stage/br_predictor/brob/entries_info/u_entries_info_ext/u_regfile \
              ] {
  set orient [lindex $orientList $flag]
  puts "====> instance $instName"
  set inst   [$block findInst $instName]
  if {$inst == "NULL"} {
    puts "ERROR ====> instance $instName"
  }

  set bbox   [$inst getBBox]
  set w      [$bbox getDX]
  set h      [$bbox getDY]

  set x      [expr $x + ($flag * $w)]

  $inst setPlacementStatus UNPLACE
  $inst setOrient $orient
  $inst setOrigin $x $y
  $inst setPlacementStatus FIRM

  set x      [expr $x + ([expr {! $flag}] * $w) + ((4 * $units) * ($flag + 1))]

  set bx1 [expr $x + ($flag * $w)]
  set by1 [expr $x + ([expr {! $flag}] * $w)]
  set bx2 [expr $y]
  set by2 [expr $y + $h]

  set flag   [expr {! $flag}]
}
