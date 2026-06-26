####################################
# global connections
####################################
add_global_connection -net {vdd} -inst_pattern {.*} -pin_pattern {^vdd$} -power
add_global_connection -net {vss} -inst_pattern {.*} -pin_pattern {^vss$} -ground
global_connect
####################################
# voltage domains
####################################
set_voltage_domain -name {CORE} -power {vdd} -ground {vss}
####################################
# standard cell grid (backside power: BPR followpins + BM1/BM2 mesh)
####################################
define_pdn_grid -name {grid} -voltage_domains {CORE} -pins {BM2}
add_pdn_stripe -grid {grid} -layer {BPR} -width {0.032} -pitch {0.144} -offset {0} -followpins
# BM1 perpendicular to BPR; modest mesh density.
add_pdn_stripe -grid {grid} -layer {BM1} -width {0.224} -spacing {0.112} \
  -pitch {1.792} -offset {0.896}
# BM2 perpendicular to BM1, wider for lower IR.
add_pdn_stripe -grid {grid} -layer {BM2} -width {0.448} -spacing {0.112} \
  -pitch {1.792} -offset {0.896}
add_pdn_connect -grid {grid} -layers {BPR BM1}
add_pdn_connect -grid {grid} -layers {BM1 BM2}
