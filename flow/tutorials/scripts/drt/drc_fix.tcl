source "helpers.tcl"

read_lef ../../../platforms/sky130hd/lef/sky130_fd_sc_hd.tlef
read_lef ../../../platforms/sky130hd/lef/sky130_fd_sc_hd_merged.lef
read_def ./gcd/4_cts.def
read_sdc ./gcd/gcd.sdc

# global_route
set_global_routing_layer_adjustment met1-met5 0.5
set_routing_layers -signal met1-met5
set_macro_extension 2
global_route -guide_file [make_result_file route.guide] \
             -congestion_iterations 100 \
             -verbose

source ../../../platforms/sky130hd/setRC.tcl
set_propagated_clock [all_clocks]
estimate_parasitics -global_routing

# detail_route
# 2 CORES enough to run this design, change if needed
set_thread_count 2
set drc_rpt [make_result_file 5_route_drc.rpt]
set maze_log [make_result_file maze.log]
detailed_route -output_drc $drc_rpt \
               -output_maze $maze_log \
               -bottom_routing_layer met1 \
               -top_routing_layer met5 \
               -verbose 1
set route_def [make_result_file 5_route.def]
write_def $route_def
puts "Number of DRC Violations = [detailed_route_num_drvs]"
