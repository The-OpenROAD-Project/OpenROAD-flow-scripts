import matplotlib.pyplot as plt
import numpy as np
import sys
import re
import os


sweep = sys.argv[1]
output = sys.argv[2]
remainder = sys.argv[3:]
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
