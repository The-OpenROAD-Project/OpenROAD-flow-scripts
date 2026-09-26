from sys import exit, stderr
from collections import defaultdict

import argparse
import numpy as np
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt

# The header of each .csv names its data and lists the layer stack it was
# written for, so it catches both swapped and mismatched input files.
NETS_HEADER = "# Net RC: "
SEGMENTS_HEADER = "# Segment RC: "

ROW_COLUMNS = 6

# The .csv data comes from ODB which stores capacitance in fF.
CAP_FF_TO_F = 1e-15

# Parsing
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


def resolve_units(args):
    res_unit = args.res_unit
    if res_unit == "ohm":
        res_scale = 1
    elif res_unit == "kohm":
        res_scale = 1e3
    else:
        print("Unknown resistance unit.", file=stderr)
        exit(1)

    cap_unit = args.cap_unit
    if cap_unit == "ff":
        cap_scale = 1e-15
    elif cap_unit == "pf":
        cap_scale = 1e-12
    else:
        print("Unknown capacitance unit.", file=stderr)
        exit(1)

    return res_unit, res_scale, cap_unit, cap_scale


def read_nets_rc(file_names):
    nets = []
    routing_layers = []
    header_line = None

    for file_name in file_names:
        print(f"Reading {file_name}.")
        # Each file has to bring its own header, so that a file of another kind
        # is not read against the header of the previous one.
        file_header_line = None

        with open(file_name) as file:
            for line in file:
                line = line.strip()

                if line.startswith(NETS_HEADER):
                    if header_line is not None and header_line != line:
                        print("Layer stack inconsistent.", file=stderr)
                        exit(1)
                    header_line = line
                    file_header_line = line
                    routing_layers = [
                        layer.removesuffix("(routing)")
                        for layer in line.removeprefix(NETS_HEADER).split()
                        if layer.endswith("(routing)")
                    ]
                    continue

                if not line or line.startswith("#"):
                    continue

                if file_header_line is None:
                    print(f"No net RC header found in {file_name}.", file=stderr)
                    exit(1)

                tokens = line.split(",")

                if len(tokens) != ROW_COLUMNS:
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

    return nets, routing_layers


def read_segments_rc(file_names):
    layer_segments = defaultdict(
        lambda: {"lengths": [], "resistances": [], "capacitances": []}
    )
    layer_net_type_length = defaultdict(lambda: defaultdict(float))
    routing_layers = []
    header_line = None

    for file_name in file_names:
        print(f"Reading {file_name}.")
        # Each file has to bring its own header, so that a file of another kind
        # is not read against the header of the previous one.
        file_header_line = None

        with open(file_name) as file:
            for line in file:
                line = line.strip()

                if line.startswith(SEGMENTS_HEADER):
                    if header_line is not None and header_line != line:
                        print("Layer stack inconsistent.", file=stderr)
                        exit(1)
                    header_line = line
                    file_header_line = line
                    routing_layers = line.removeprefix(SEGMENTS_HEADER).split()
                    continue

                if not line or line.startswith("#"):
                    continue

                if file_header_line is None:
                    print(f"No segment RC header found in {file_name}.", file=stderr)
                    exit(1)

                tokens = line.split(",")

                if len(tokens) != ROW_COLUMNS:
                    print(f"Malformed segment RC line: {line}", file=stderr)
                    exit(1)

                net_type = tokens[1]
                layer = tokens[2]
                length = float(tokens[3])

                if layer not in routing_layers:
                    print(f"Layer {layer} is not in the header.", file=stderr)
                    exit(1)

                layer_segments[layer]["lengths"].append(length)
                layer_segments[layer]["resistances"].append(float(tokens[4]))
                layer_segments[layer]["capacitances"].append(float(tokens[5]))
                layer_net_type_length[layer][net_type] += length

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


# Fitting
# =============================================================================


def fit_layer_models(routing_layers, layer_segments):
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

    return layer_models


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


def wire_rc_fit(
    layer_models, layer_net_type_length, res_scale, cap_scale, target_net_type=None
):
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
        total_capacitance / total_length * CAP_FF_TO_F / cap_scale,
    )


# Report
# =============================================================================


def print_fit_scores(layer_models, res_unit, cap_unit):
    print("\nUnits: resistance [{}/um], capacitance [{}/um]".format(res_unit, cap_unit))

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


def print_layer_rc(layer_models, res_scale, cap_scale):
    for layer_name, (res_model, cap_model, _, _, _) in layer_models.items():
        print(
            "set_layer_rc -layer {} -resistance {:.5E} -capacitance {:.5E}".format(
                layer_name,
                res_model.coef_[0] / res_scale,
                cap_model.coef_[0] * CAP_FF_TO_F / cap_scale,
            )
        )
    print("")


def print_wire_rc(layer_models, layer_net_type_length, res_scale, cap_scale):
    result = wire_rc_fit(layer_models, layer_net_type_length, res_scale, cap_scale)

    if result is None:
        print("[Warning] No layer was fitted.")
        return

    resistance, capacitance = result

    print(
        "set_wire_rc -resistance {:.5E} -capacitance {:.5E}".format(
            resistance, capacitance
        )
    )

    for net_type in ["signal", "clock"]:
        result = wire_rc_fit(
            layer_models, layer_net_type_length, res_scale, cap_scale, [net_type]
        )

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


# Plot
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
