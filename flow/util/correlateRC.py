#!/usr/bin/env python3

# Script for generating and comparing per-layer parasitics values.
# These values are used by set_layer_rc and will be the base
# values for the parasitics estimations across the flow.
#
# Both input files are written by "make write_rc": the set_layer_rc and
# set_wire_rc values are fitted from the segments data, while the plots
# compare the GRT estimates against the RCX values of the nets.

from correlateRCHelper import (
    fit_layer_models,
    parse_args,
    plot_grt_rcx_diff,
    print_fit_scores,
    print_layer_rc,
    print_wire_rc,
    read_nets_rc,
    read_segments_rc,
    resolve_units,
)

args = parse_args()
res_unit, res_scale, cap_unit, cap_scale = resolve_units(args)

routing_layers, layer_segments, layer_net_type_length = read_segments_rc(
    args.segments_rc_file
)

# Use linear regression to find the layer resistances and capacitances.
layer_models = fit_layer_models(routing_layers, layer_segments)

print_fit_scores(layer_models, res_unit, cap_unit)
print_layer_rc(layer_models, res_scale, cap_scale)
print_wire_rc(layer_models, layer_net_type_length, res_scale, cap_scale)

# The plots come after the commands so that a plot with no data does not
# withhold them.
if args.plot_cap or args.plot_res:
    nets, nets_routing_layers = read_nets_rc(args.nets_rc_file)

    if nets_routing_layers != routing_layers:
        print("[Warning] The nets and the segments data have different routing")
        print("layers, are the files from different platforms?")

    if args.plot_cap:
        plot_grt_rcx_diff(nets, "cap", "Capacitance", cap_unit, cap_scale, 1e-12)

    if args.plot_res:
        plot_grt_rcx_diff(nets, "res", "Resistance", res_unit, res_scale, 1e3)
elif args.nets_rc_file:
    print("The nets RC data is only read to plot, so it was skipped.")
