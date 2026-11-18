# core voltage domain
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}

# stdcell grid
define_pdn_grid -name {grid} -voltage_domains {CORE} -pins {TopMetal1 TopMetal2}
add_pdn_stripe -grid {grid} -layer {Metal1} -width {0.44} -pitch {7.56} -offset {0} \
  -followpins -extend_to_core_ring
add_pdn_ring -grid {grid} -layers {Metal5 TopMetal1} -widths {8.0} -spacings {5.0} \
  -core_offsets {4.5} -connect_to_pads
add_pdn_stripe -grid {grid} -layer {TopMetal1} -width {4.0} -pitch {60.0} -offset {10.0} \
  -extend_to_core_ring
add_pdn_stripe -grid {grid} -layer {TopMetal2} -width {4.0} -pitch {60.0} -offset {10.0} \
  -extend_to_core_ring
add_pdn_connect -grid {grid} -layers {Metal1 TopMetal1}
add_pdn_connect -grid {grid} -layers {Metal5 TopMetal1}
add_pdn_connect -grid {grid} -layers {Metal5 TopMetal2}
add_pdn_connect -grid {grid} -layers {TopMetal1 TopMetal2}

define_pdn_grid \
  -name {CORE_macro_grid_1} -voltage_domains {CORE} \
  -macro -cells {I2cDeviceCtrl} -grid_over_boundary
add_pdn_connect -grid {CORE_macro_grid_1} -layers {Metal4 TopMetal1}
add_pdn_connect -grid {CORE_macro_grid_1} -layers {Metal5 TopMetal1}
