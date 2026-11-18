####################################
# voltage domains
####################################
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}
####################################
# standard cell grid
####################################
define_pdn_grid -name {block} -voltage_domains {CORE}
add_pdn_stripe -grid {block} -layer {Metal1} -width {0.900} -pitch {5.040} -offset {0} -followpins
add_pdn_stripe -grid {block} -layer {Metal4} -width {4.480} -spacing {0.56} -pitch {44.8} \
  -offset {22.4}
add_pdn_stripe -grid {block} -layer {Metal5} -width {4.480} -pitch {89.6} -offset {44.8}
add_pdn_connect -grid {block} -layers {Metal1 Metal4}
add_pdn_connect -grid {block} -layers {Metal4 Metal5}
####################################
# Block grids
####################################
define_pdn_grid -macro -cells uart_rx -halo "2.0 2.0 2.0 2.0" -voltage_domains {CORE} \
  -name BlocksGrid
add_pdn_connect -grid {BlocksGrid} -layers {Metal4 Metal5}
