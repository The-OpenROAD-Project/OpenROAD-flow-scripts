####################################
# global connections
####################################
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDD$} -power
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDDPE$}
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDDCE$}
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VPWR}
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {vdd}
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSS$} -ground
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSSE$}
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VGND}

add_global_connection -net {VDD} -inst_pattern {u_vdd_.*} -pin_pattern {VCCD} -power
add_global_connection -net {VSS} -inst_pattern {u_vss_.*} -pin_pattern {VSSD} -ground
global_connect
####################################
# voltage domains
####################################
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}
####################################
# standard cell grid
####################################
define_pdn_grid -name {grid} -voltage_domains {CORE}
add_pdn_stripe -grid {grid} -layer {met1} -width {0.49} -pitch {5.44} -offset {0} -followpins
add_pdn_ring -grid {grid} -layers {met4 met5} -widths {3 3} -spacings {1.6 1.6} -pad_offsets {10 10} -connect_to_pads -starts_with POWER
add_pdn_stripe -grid {grid} -layer {met4} -width {0.96} -pitch {56.0} -offset {2} -extend_to_core_ring
add_pdn_stripe -grid {grid} -layer {met5} -width {1.60} -pitch {56.0} -offset {2} -extend_to_core_ring
add_pdn_connect -grid {grid} -layers {met1 met4}
add_pdn_connect -grid {grid} -layers {met4 met5}
####################################
# macro grids
####################################
####################################
# grid for: pads
####################################
define_pdn_grid -name {pads} -voltage_domains {CORE} -macro \
    -halo {0.0 0.0 0.0 0.0} \
    -cells {sky130_ef_io__gpiov2_pad_wrapped
      sky130_ef_io__com_bus_slice_10um
      sky130_ef_io__com_bus_slice_1um
      sky130_ef_io__com_bus_slice_20um
      sky130_ef_io__com_bus_slice_5um
      sky130_ef_io__corner_pad
      sky130_ef_io__vccd_hvc_pad
      sky130_ef_io__vccd_lvc_pad
      sky130_ef_io__vdda_hvc_pad
      sky130_ef_io__vdda_lvc_pad
      sky130_ef_io__vddio_hvc_pad
      sky130_ef_io__vddio_lvc_pad
      sky130_ef_io__vssa_hvc_pad
      sky130_ef_io__vssa_lvc_pad
      sky130_ef_io__vssd_hvc_pad
      sky130_ef_io__vssd_lvc_pad
      sky130_ef_io__vssio_hvc_pad
      sky130_ef_io__vssio_lvc_pad} \
    -grid_over_boundary
####################################
# grid for: CORE_macro_grid_1
####################################
define_pdn_grid -name {CORE_macro_grid_1} -voltage_domains {CORE} -macro -orient {R0 R180 MX MY} -halo {0.0 0.0 0.0 0.0} -default -grid_over_boundary
add_pdn_stripe -grid {CORE_macro_grid_1} -layer {met4} -width {0.93} -pitch {20.0} -offset {2}
add_pdn_connect -grid {CORE_macro_grid_1} -layers {met3 met4}
add_pdn_connect -grid {CORE_macro_grid_1} -layers {met4 met5}
