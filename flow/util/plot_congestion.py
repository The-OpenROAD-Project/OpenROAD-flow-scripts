import matplotlib.pyplot as plt
import numpy as np
import sys
import re
import os


def usage(script):
    print(
        f"Usage: {script} <sweep_name> <output_png> <congestion_file...> <sweep_value...>",
        file=sys.stderr,
    )
    print(
        "Provide an even number of trailing arguments split equally between files and values.",
        file=sys.stderr,
    )


if len(sys.argv) < 5:
    usage(sys.argv[0])
    sys.exit(2)

sweep = sys.argv[1]
output = sys.argv[2]
remainder = sys.argv[3:]
if len(remainder) % 2 != 0:
    print("Error: trailing arguments must be an even count.", file=sys.stderr)
    usage(sys.argv[0])
    sys.exit(2)

files = remainder[: len(remainder) // 2]
values = remainder[len(remainder) // 2 :]

# count lines in each file and divide by 3 and create a list of those
# numbers
congestion = []
for file in files:
    with open(file, "r") as f:
        lines = f.readlines()
        congestion.append(len(lines) // 4)

# xy plot of density vs DRC errors
x = list(map(float, values))
y = congestion
plt.plot(x, y, "o-")
plt.xlabel(sweep)
plt.ylabel("DRC Errors")
plt.title(sweep + " vs DRC Errors")
plt.grid()
plt.yscale("log")
plt.savefig(output)
