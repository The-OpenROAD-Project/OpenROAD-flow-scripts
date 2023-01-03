####################################
# global connections
####################################
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDD$} -power
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDDPE$}
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDDCE$}
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VPWR}
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VPB}
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSS$} -ground
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSSE$}
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VGND}
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VNB}
global_connect
####################################
# voltage domains
####################################
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}
####################################
# standard cell grid
####################################
define_pdn_grid -name {grid} -voltage_domains {CORE}
add_pdn_stripe -grid {grid} -layer {met1} -width {0.48} -pitch {5.44} -offset {0} -followpins

set db [::ord::get_db]
set dbu_per_uu [[$db getTech] getDbUnitsPerMicron]
set block [[$db getChip] getBlock]
set core_bbox [$block getCoreArea]
set core_width [$core_bbox dx]
set core_height [$core_bbox dy]

set core_width [expr $core_width / $dbu_per_uu ]
set core_height [expr $core_height / $dbu_per_uu ]

# Use multiples of the met4 pitch (0.92um)
if [ expr $core_height < 100 ] {
    add_pdn_stripe -grid {grid} -layer {met4} -width {1.600} -pitch {27.600} -offset {13.800} -snap_to_grid
} else {
    add_pdn_stripe -grid {grid} -layer {met4} -width {3.200} -pitch {74.520} -offset {37.260} -snap_to_grid
}

# Use multiples of the met5 pitch (3.4um)
if [ expr $core_width < 100 ] {
    add_pdn_stripe -grid {grid} -layer {met5} -width {1.600} -pitch {27.200} -offset {13.600} -snap_to_grid
} else {
    add_pdn_stripe -grid {grid} -layer {met5} -width {3.200} -pitch {74.800} -offset {37.400} -snap_to_grid
}

add_pdn_connect -grid {grid} -layers {met1 met4}
add_pdn_connect -grid {grid} -layers {met4 met5}
####################################
# macro grids
####################################
####################################
# grid for: CORE_macro_grid_1
####################################
define_pdn_grid -name {CORE_macro_grid_1} -voltage_domains {CORE} -macro -orient {R0 R180 MX MY} -halo {2.0 2.0 2.0 2.0} -default -grid_over_boundary
add_pdn_connect -grid {CORE_macro_grid_1} -layers {met4 met5}
####################################
# grid for: CORE_macro_grid_2
####################################
define_pdn_grid -name {CORE_macro_grid_2} -voltage_domains {CORE} -macro -orient {R90 R270 MXR90 MYR90} -halo {2.0 2.0 2.0 2.0} -default -grid_over_boundary
add_pdn_connect -grid {CORE_macro_grid_2} -layers {met4 met5}
