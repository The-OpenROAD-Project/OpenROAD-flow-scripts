# core voltage domain
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}

# stdcell grid
define_pdn_grid -name {grid} -voltage_domains {CORE} -pins {Metal4 Metal5}
add_pdn_stripe -grid {grid} -layer {Metal1} -width {0.44} -pitch {7.56} -offset {0} \
  -followpins
add_pdn_ring -grid {grid} -layers {Metal4 Metal5} -widths {3.0} -spacings {2.0} \
  -core_offsets {4.5}
add_pdn_stripe -grid {grid} -layer {Metal4} -width {2.0} -pitch {40.0} -offset {10.0} \
  -extend_to_core_ring
add_pdn_stripe -grid {grid} -layer {Metal5} -width {2.0} -pitch {40.0} -offset {10.0} \
  -extend_to_core_ring
add_pdn_connect -grid {grid} -layers {Metal1 Metal4}
add_pdn_connect -grid {grid} -layers {Metal4 Metal5}
