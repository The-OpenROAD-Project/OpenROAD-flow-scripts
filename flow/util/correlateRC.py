#!/usr/bin/env python3

# Script for generating and comparing per-layer parasitics values.
# These values are used by set_layer_rc and will be the base
# values for the parasitics estimations across the flow.
#
# Both input files are written by "make write_rc": the set_layer_rc and
# set_wire_rc values are fitted from the segments data, while the plots
# compare the GRT estimates against the RCX values of the nets.

from sys import exit, stderr
from collections import defaultdict

import argparse
import numpy as np
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt

# Auxiliary variables to catch swapped input .csv files.
SEGMENTS_COLUMNS = 6
NETS_MIN_COLUMNS = 7

# Helper functions
# =============================================================================


# sklearn's default baseline model for scoring the fit i.e., measuring R² is
# "predict the mean" which is not the proper model for our regressions since
# both R and C are through-origin fits - the R² computation doesn't behave
# well for var(y) ≈ 0 - so we compute R² manually with a "predict zero"
# baseline model.
def compute_through_origin_fit_score(model, inputs, observed):
    sum_squared_observed = (observed**2).sum()
    if sum_squared_observed == 0:
        return "No data"
    score = 1.0 - ((observed - model.predict(inputs)) ** 2).sum() / sum_squared_observed
    return f"{score:.4f}"


# Parse and validate arguments
# =============================================================================


def parse_args():
    parser = argparse.ArgumentParser(
        description="Determines layer capacitance and resistance values for OpenROAD flow designs"
    )
    parser.add_argument(
        "-cap_unit", required=False, default="pf", help="capacitance unit ff|pf"
    )
    parser.add_argument(
        "-res_unit", required=False, default="kohm", help="resistance unit ohm|kohm"
    )
    parser.add_argument(
        "-plot_cap",
        required=False,
        action="store_true",
        default=False,
        help="Plot grt/rcx capacitance differences",
    )
    parser.add_argument(
        "-plot_res",
        required=False,
        action="store_true",
        default=False,
        help="Plot grt/rcx resistance differences",
    )
    parser.add_argument(
        "-nets_rc_file",
        required=False,
        nargs="+",
        default=[],
        metavar="FILE",
        help="Net RC csv file(s) written by make write_rc, required for the plots",
    )
    parser.add_argument(
        "-segments_rc_file",
        required=True,
        nargs="+",
        metavar="FILE",
        help="Segment RC csv file(s) written by make write_rc, used to fit the layer RC values",
    )
    args = parser.parse_args()

    if (args.plot_cap or args.plot_res) and not args.nets_rc_file:
        parser.error("-nets_rc_file is required to plot the grt/rcx differences")

    return args


# Parser Helpers
# =============================================================================


def read_nets_rc(file_names):
    nets = []

    for file_name in file_names:
        print(f"Reading {file_name}.")
        with open(file_name) as file:
            for line in file:
                line = line.strip()

                if not line or line.startswith("#"):
                    continue

                tokens = line.split(",")

                if len(tokens) < NETS_MIN_COLUMNS:
                    print(f"Malformed net RC line: {line}", file=stderr)
                    exit(1)

                nets.append(
                    {
                        "file_name": file_name,
                        "name": tokens[0],
                        "type": tokens[1],
                        "grt_res": float(tokens[2]),
                        "grt_cap": float(tokens[3]),
                        "rcx_res": float(tokens[4]),
                        "rcx_cap": float(tokens[5]),
                    }
                )

    if not nets:
        print("No net RC data found.", file=stderr)
        exit(1)

    for key, name in (
        ("grt_res", "GRT resistance"),
        ("grt_cap", "GRT capacitance"),
        ("rcx_res", "RCX resistance"),
        ("rcx_cap", "RCX capacitance"),
    ):
        count = sum(1 for net in nets if net[key] == 0.0)

        if count > 0:
            print(f"Found {count} nets with zero {name}.")

    return nets


def read_segments_rc(file_names):
    layer_segments = defaultdict(
        lambda: {"lengths": [], "resistances": [], "capacitances": []}
    )
    layer_net_type_length = defaultdict(lambda: defaultdict(float))
    routing_layers = []
    routing_layers_line = None

    for file_name in file_names:
        print(f"Reading {file_name}.")
        with open(file_name) as file:
            for line in file:
                if line.startswith("# routing layers: "):
                    if routing_layers_line is None:
                        routing_layers = (
                            line.removeprefix("# routing layers: ").strip().split(" ")
                        )
                        routing_layers_line = line
                    elif routing_layers_line != line:
                        print("Layer stack inconsistent.", file=stderr)
                        exit(1)
                    continue

                line = line.strip()

                if not line or line.startswith("#"):
                    continue

                tokens = line.split(",")

                if len(tokens) != SEGMENTS_COLUMNS:
                    print(f"Malformed segment RC line: {line}", file=stderr)
                    exit(1)

                net_type = tokens[1]
                layer = tokens[2]
                length = float(tokens[3])

                layer_segments[layer]["lengths"].append(length)
                layer_segments[layer]["resistances"].append(float(tokens[4]))
                layer_segments[layer]["capacitances"].append(float(tokens[5]))
                layer_net_type_length[layer][net_type] += length

    if not routing_layers:
        print("No routing layers header found in the segment RC data.", file=stderr)
        exit(1)

    if not layer_segments:
        print("No segment RC data found.", file=stderr)
        exit(1)

    for key, name in (("resistances", "resistance"), ("capacitances", "capacitance")):
        count = sum(
            1
            for segments in layer_segments.values()
            for value in segments[key]
            if value == 0.0
        )
        if count > 0:
            print(f"Found {count} segments with zero {name}.")

    return routing_layers, layer_segments, layer_net_type_length


# Plot Helpers
# =============================================================================


def plot_grt_rcx_diff(nets, quantity, name, unit, scale, discrepancy_threshold):
    differences = []
    differences_percent = []

    for net in nets:
        grt_value = net[f"grt_{quantity}"]
        rcx_value = net[f"rcx_{quantity}"]

        if grt_value <= 0.0 or rcx_value <= 0.0:
            continue

        difference = grt_value - rcx_value

        if abs(difference) > discrepancy_threshold:
            print(f"Large discrepancy: {net['file_name']} {net['name']} {difference}")

        differences.append(difference / scale)
        differences_percent.append(difference / rcx_value * 100)

    if not differences:
        print(f"No net {name.lower()} data to plot.", file=stderr)
        exit(1)

    # Generate histograms
    num_bins = 200
    fig = plt.figure()
    fig.suptitle(f"Difference between GRT est. and RCX {name}")
    plt.subplot(2, 2, 1)
    plt.hist(differences, num_bins, facecolor="blue", alpha=0.5)
    plt.ylabel("# Nets")
    plt.xlabel(
        "{} ({})\n\nMean: {:.3f}{}\nStd. dev: {:.3f}{}".format(
            name, unit, np.mean(differences), unit, np.std(differences), unit
        )
    )

    plt.subplot(2, 2, 2)
    plt.hist(
        differences_percent, num_bins, range=(-1000, 1000), facecolor="blue", alpha=0.5
    )
    plt.ylabel("# Nets")
    plt.xlabel(
        "%\n\nMean: {:.3f}%\nStd. dev: {:.3f}%".format(
            np.mean(differences_percent), np.std(differences_percent)
        )
    )
    plt.show()


################################################################

args = parse_args()

# kohm/ff nangate45, asap7
# kohm/pf sky130hd, sky130hs

res_unit = args.res_unit
if res_unit == "ohm":
    res_scale = 1
elif res_unit == "kohm":
    res_scale = 1e3
else:
    print("Unknown resistance unit.")
    exit(1)

cap_unit = args.cap_unit
if cap_unit == "ff":
    cap_scale = 1e-15
elif cap_unit == "pf":
    cap_scale = 1e-12
else:
    print("Unknown capacitance unit.")
    exit(1)

routing_layers, layer_segments, layer_net_type_length = read_segments_rc(
    args.segments_rc_file
)

################################################################

# Use linear regression to find the layer resistances and capacitances.

print("\nUnits: resistance [{}/um], capacitance [{}/um]".format(res_unit, cap_unit))

# Note that the .csv data comes from ODB which stores capacitance in fF.
cap_ff_to_f = 1e-15

layer_models = {}
for layer_name in routing_layers:
    # There may be routing layers with no segments, so we check if the
    # layer exists in the dict.
    if layer_name not in layer_segments:
        continue

    # sklearn requires the input to be 2D, so we reshape to add a dimension
    # to the list.
    lengths = np.array(layer_segments[layer_name]["lengths"]).reshape(-1, 1)
    resistances = np.array(layer_segments[layer_name]["resistances"])
    capacitances_ff = np.array(layer_segments[layer_name]["capacitances"])

    res_model = LinearRegression(fit_intercept=False).fit(lengths, resistances)
    cap_model = LinearRegression(fit_intercept=False).fit(lengths, capacitances_ff)
    layer_models[layer_name] = (
        res_model,
        cap_model,
        lengths,
        resistances,
        capacitances_ff,
    )

# Print R² table
print("{:<13s} | {:>8s} | {:>8s}".format("\nLayer", "Res R²", "Cap R²"))
print("-" * 34)
for layer_name, (
    res_model,
    cap_model,
    lengths,
    resistances,
    capacitances_ff,
) in layer_models.items():
    r_sq_res = compute_through_origin_fit_score(res_model, lengths, resistances)
    r_sq_cap = compute_through_origin_fit_score(cap_model, lengths, capacitances_ff)
    print("{:<12s} | {:>8s} | {:>8s}".format(layer_name, r_sq_res, r_sq_cap))
print("-" * 34)
print("")

for layer_name, (
    res_model,
    cap_model,
    lengths,
    resistances,
    capacitances_ff,
) in layer_models.items():
    print(
        "set_layer_rc -layer {} -resistance {:.5E} -capacitance {:.5E}".format(
            layer_name,
            res_model.coef_[0] / res_scale,
            cap_model.coef_[0] * cap_ff_to_f / cap_scale,
        )
    )
print("")


def wire_rc_fit(target_net_type=None):
    total_length = 0.0
    total_resistance = 0.0
    total_capacitance = 0.0

    for layer_name, (res_model, cap_model, lengths, _, _) in layer_models.items():
        if target_net_type is not None:
            layer_length = sum(
                layer_net_type_length[layer_name][net_type]
                for net_type in target_net_type
            )
        else:
            layer_length = float(lengths.sum())

        total_resistance += res_model.coef_[0] * layer_length
        total_capacitance += cap_model.coef_[0] * layer_length
        total_length += layer_length

    if total_length == 0.0:
        return None

    return (
        total_resistance / total_length / res_scale,
        total_capacitance / total_length * cap_ff_to_f / cap_scale,
    )


resistance, capacitance = wire_rc_fit()

print(
    "set_wire_rc -resistance {:.5E} -capacitance {:.5E}".format(resistance, capacitance)
)

for net_type in ["signal", "clock"]:
    result = wire_rc_fit([net_type])

    if result is None:
        print("[Warning] No {} nets were found.".format(net_type))
        continue

    resistance, capacitance = result

    print(
        "set_wire_rc -{} -resistance {:.5E} -capacitance {:.5E}".format(
            net_type, resistance, capacitance
        )
    )
print("")

################################################################

# The plots come after the commands so that a plot with no data does not
# withhold them.

if args.nets_rc_file:
    nets = read_nets_rc(args.nets_rc_file)

    if args.plot_cap:
        plot_grt_rcx_diff(nets, "cap", "Capacitance", cap_unit, cap_scale, 1e-12)

    if args.plot_res:
        plot_grt_rcx_diff(nets, "res", "Resistance", res_unit, res_scale, 1e3)
