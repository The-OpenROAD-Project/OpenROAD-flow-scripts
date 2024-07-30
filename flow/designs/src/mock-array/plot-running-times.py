import subprocess
import os
import re
from matplotlib import pyplot as plt
import numpy as np
from matplotlib import cm
import itertools


def run():
    test_design = "make DESIGN_CONFIG=designs/asap7/mock-array/config.mk"

    times = []

    # measure three variables at the time.
    measurements = {
        "datawidth": (("MOCK_ARRAY_DATAWIDTH",), (8,)),
        "arraysize": (("MOCK_ARRAY_WIDTH", "MOCK_ARRAY_HEIGHT"), (8,)),
        "pitches": (("MOCK_ARRAY_TABLE",), ("8 8 4 4 5 5",)),
        "elementsize": (("MOCK_ARRAY_SCALE",), (45, 80, 160, 320, 640)),
    }
    measure_ids = sorted(measurements.keys())

    for measurement in itertools.product(
        *map(lambda key: measurements[key][1], measure_ids)
    ):
        variant = "-".join(map(str, measurement)).replace(" ", "-")
        print(f"testiong {variant}")
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

        if not os.path.exists(f"results/asap7/mock-array_Element/{variant}/"):
            print(f"Measuring {variant}")
            for cmd in (
                test_design + " verilog",
                test_design,
            ):
                returncode = subprocess.call(cmd, env=env, shell=True)
                if returncode != 0:
                    print("Skipping variant, doesn't compile: " + variant)
        result = subprocess.check_output(
            test_design + " elapsed", shell=True, env=env
        ).decode("utf-8")

        # Modify pattern to capture the stage of interest
        # Log                       Elapsed seconds
        # logname                            40
        pattern = r"^5_2_route\s+(\d+)$"
        match = re.search(pattern, result, re.MULTILINE)
        if match is None:
            print("Variant skipped: " + variant)
            continue
        value = int(match.group(1))
        sample = list(measurement) + [value]
        print(" ".join(map(str, sample)))
        times.append(sample)

    dimensions = sum(map(lambda id: len(measurements[id][1]) > 1, measure_ids))
    if dimensions == 3:
        # 4 dimensional plot
        # plt.rcParams["figure.figsize"] = [7.00, 3.50]
        plt.rcParams["figure.autolayout"] = True
        fig = plt.figure()
        ax = fig.add_subplot(111, projection="3d")

        transposed = list(map(list, zip(*times)))

        norm = plt.Normalize(min(transposed[-1]), max(transposed[-1]))
        colors = cm.viridis(norm(transposed[-1]))

        cbar = fig.colorbar(cm.ScalarMappable(norm=norm, cmap=cm.viridis), ax=ax)
        cbar.set_label("running time/seconds")

        img = ax.scatter(*transposed, c=colors, alpha=1)

        ax.set_xlabel(measure_ids[0])
        ax.set_ylabel(measure_ids[1])
        ax.set_zlabel(measure_ids[2])
        plt.show()
    elif dimensions == 1:
        list(enumerate(map(lambda id: len(measurements[id][1]) > 1, measure_ids)))
        measure = next(
            (
                i
                for i, e in enumerate(
                    map(lambda id: len(measurements[id][1]) > 1, measure_ids)
                )
                if e
            ),
            -1,
        )

        fig, ax = plt.subplots()
        x = np.array(list(map(lambda m: m[measure], times)))
        y = np.array(list(map(lambda m: m[-1], times)))

        # Calculate the best-fit line
        # slope, intercept = np.polyfit(x, y, 1)
        # trendline = slope * x + intercept

        # Create the plot
        ax.plot(
            x, y, marker="o", color="red", label="detailed route/seconds"
        )  # Plot the data points
        # ax.plot(x, trendline, '-', label='Trendline')  # Plot the trendline

        # Customize the plot
        ax.set_xlabel(measure_ids[measure])
        ax.set_ylabel("Running time / seconds")
        # ax.set_yscale('log')
        ax.set_title("Detailed routing time")
        ax.legend()

        # Display the plot
        plt.show()


if __name__ == "__main__":
    run()
