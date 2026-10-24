# A macro's grid for abutment: rails, M5 straps, and M8 straps as the pins
# the parent's M9 lands on. No ring: nothing at the edge the band abuts.
# The macro routes signals on M2-M8; M9 belongs to the parent's grid.
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDD$} -power
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSS$} -ground
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}
define_pdn_grid -name {top} -voltage_domains {CORE} -pins {M8}
add_pdn_stripe -grid {top} -layer {M1} -width {0.018} -pitch {0.54} -offset {0} -followpins
add_pdn_stripe -grid {top} -layer {M2} -width {0.018} -pitch {0.54} -offset {0} -followpins
add_pdn_stripe -grid {top} -layer {M5} -width {0.12} -spacing {0.072} -pitch {2.976} \
  -offset {1.5} -extend_to_core_ring
add_pdn_stripe -grid {top} -layer {M8} -width {0.16} -spacing {0.16} -pitch {2.16} \
  -offset {0.5} -extend_to_boundary
add_pdn_connect -grid {top} -layers {M1 M2}
add_pdn_connect -grid {top} -layers {M2 M5}
add_pdn_connect -grid {top} -layers {M5 M8}
