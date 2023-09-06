import subprocess
import os
import re
from matplotlib import pyplot as plt
import numpy as np
from matplotlib import cm
import itertools
import argparse

def run(platform):
    test_design = "make DESIGN_CONFIG=designs/asap7/mock-registerfile/config.mk"

    values = {}

    # measure three variables at the time.
    measurements = {
        "registers": (("MOCK_REGISTERFILE_REGISTERS",), (16,)),
        "width": (("MOCK_REGISTERFILE_WIDTH",), (64,)),
        "ports": (
            ("MOCK_REGISTERFILE_READ_PORTS","MOCK_REGISTERFILE_WRITE_PORTS"),
            (2,4,8,16,32),
        ),
    }
    measure_ids = sorted(measurements.keys())

    for measurement in itertools.product(
        *map(lambda key: measurements[key][1], measure_ids)
    ):
        variant = "-".join(map(str, measurement)).replace(" ", "-")
        print(f"testing {variant}")
        env_change = {"FLOW_VARIANT": variant, "PLATFORM":platform}
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

        if not os.path.exists(f"results/{platform}/mock-registerfile/{variant}/5_route.odb"):
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
    clock_period = [value[0] for value in values.values()]
    area = [value[1] for value in values.values()]
    read_write_ports = list(map(int, map(lambda k:k[measure_ids.index('ports')], values.keys())))


    # Create the initial figure and axis
    fig, ax1 = plt.subplots()

    # Make the first plot
    ax1.set_xlabel('Read_Write_Ports')
    ax1.set_ylabel('Clock Period', color='tab:blue')
    ax1.plot(read_write_ports, clock_period, 'o-', color='tab:blue')
    ax1.tick_params(axis='y', labelcolor='tab:blue')

    # Create the second axis object
    ax2 = ax1.twinx()
    ax2.set_ylabel('Area', color='tab:red')
    ax2.plot(read_write_ports, area, 's-', color='tab:red')
    ax2.tick_params(axis='y', labelcolor='tab:red')

    # Finally, show the plot
    plt.title("Clock Period and Area vs. Read_Write_Ports\n4 registers 8 bit registers")
    plt.show()


if __name__ == "__main__":
   parser = argparse.ArgumentParser(description='Process some arguments.')
   parser.add_argument('--platform', default='asap7', help='Specify the platform. Default is asap7.')
   args = parser.parse_args()
   run(args.platform)
