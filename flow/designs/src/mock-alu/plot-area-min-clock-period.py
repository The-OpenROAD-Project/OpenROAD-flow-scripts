import subprocess
import os
import re
from matplotlib import pyplot as plt
import numpy as np
from matplotlib import cm
import itertools


def run():
    test_design = "make DESIGN_CONFIG=designs/asap7/mock-alu/config.mk"

    values = {}

    # measure three variables at the time.
    measurements = {
        # "datawidth": (("MOCK_ALU_WIDTH",), (8, 16, 32, 64)),
        "operations": (
            ("MOCK_ALU_OPERATIONS",),
            (
                "MAC_BRENTKUNG",
                "MULT_BRENTKUNG",
                "MULT_HANCARLSON",
                "MULT_INFERRED",
                "MULT_KOGGESTONE",
                "MULT_RIPPLE"
                # "ADD",
                # "ADD8",
                # "ADD16",
                # "ADD32",
                # "MUX1,MUX2",
                # "MUX1,MUX2,MUX3,MUX4",
                # "MUX1,MUX2,MUX3,MUX4,MUX5,MUX6,MUX7,MUX8",
                # "ADD",
                # "AND,OR,XOR",
                # "OR",
                # "SHL,SHR,SRA",
                # "ADD,SUB,SETCC_EQ,SETCC_NE,SETCC_LT,SETCC_ULT,SETCC_LE,SETCC_ULE",
                # "MULT",
                # "AND,OR,XOR,SHL,SHR,SRA,ADD,SUB,SETCC_EQ,SETCC_NE,SETCC_LT,SETCC_ULT,SETCC_LE,SETCC_ULE",
                # "AND,OR,XOR,SHL,SHR,SRA,ADD,SUB,SETCC_EQ,SETCC_NE,SETCC_LT,SETCC_ULT,SETCC_LE,SETCC_ULE,MULT",
            ),
        ),
    }
    measure_ids = sorted(measurements.keys())

    for measurement in itertools.product(
        *map(lambda key: measurements[key][1], measure_ids)
    ):
        variant = "-".join(map(str, measurement)).replace(" ", "-")
        print(f"testing {variant}")
        env_change = {"FLOW_VARIANT": variant}
        for e in itertools.chain(
            *map(
                lambda measure: map(
                    lambda var: {var: measure[1]}, measurements[measure[0]][0]
                ),
                zip(measure_ids, measurement),
            )
        ):
            u = dict(map(lambda item: (item[0], str(item[1])), e.items()))
            env_change.update(u)
        env = os.environ.copy()
        env.update(env_change)

        if not os.path.exists(f"results/asap7/mock-alu/{variant}/5_route.odb"):
            print(f"Measuring {variant}")
            for cmd in (
                test_design + " verilog",
                test_design + " route",
            ):
                returncode = subprocess.call(cmd, env=env, shell=True)
                if returncode != 0:
                    print("Skipping variant, doesn't compile: " + variant)
        input_string = "report_design_area\nreport_clock_min_period\n"
        result = subprocess.check_output(
            test_design + " open_route",
            shell=True,
            env=env,
            input=input_string,
            text=True,
        )

        m = re.search(r"period_min\s*=\s*(\d+\.\d+)", result)
        if m:
            min_period = float(m.group(1))
        if m is None:
            print("Variant skipped: " + variant)
            continue
        m = re.search(r"Design area (\d+) u.*", result)
        if m:
            design_area = float(m.group(1))
        if m is None:
            print("Variant skipped: " + variant)
            continue
        values[measurement] = [min_period, design_area]

    # Splitting the dictionary into x and y coordinates, and labels
    x_coords = [value[0] for value in values.values()]
    y_coords = [value[1] for value in values.values()]
    labels = list(values.keys())

    # Creating the scatter plot
    plt.scatter(x_coords, y_coords, color="red")

    def custom_wrap(text, max_len=30):
        line, length = "", 0

        for part in text.split(","):
            if length + len(part) > max_len:
                yield line
                line, length = part, len(part)
            else:
                line = f"{line},{part}" if line else part
                length += len(part) + 1

        yield line

    # Annotating each point with its label
    for i, label in enumerate(labels):
        plt.annotate("\n".join(custom_wrap(label[0])), (x_coords[i], y_coords[i]))

    # Displaying the plot
    plt.xlabel("minimum period/ps")
    plt.ylabel("area/u^2")
    plt.title("ALU Operations and minimum period and area")
    plt.grid(True)

    # plt.gca().invert_xaxis()
    # plt.gca().invert_yaxis()
    plt.show()


if __name__ == "__main__":
    run()
