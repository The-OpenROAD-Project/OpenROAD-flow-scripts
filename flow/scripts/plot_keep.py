# Load two files passed on the command line with dictionaries
# of the format below, then plot XY scatter plot of the data
#
# rvdff_WIDTH13 13
# rvdff_WIDTH14 14


import sys
import matplotlib.pyplot as plt


def load_data(filename):
    data = {}
    with open(filename) as f:
        for line in f:
            key, value = line.split()[0:2]
            data[key] = float(value)
    return data


def plot_data(x, y):
    plt.scatter(x, y)
    plt.xlabel("Yosys gate equivalents")
    plt.ylabel("OpenROAD area (um^2)")
    plt.show()


def main():
    if len(sys.argv) != 3:
        print("Usage: {} datafile1 datafile2".format(sys.argv[0]))
        sys.exit(1)
    data1 = load_data(sys.argv[1])
    data2 = load_data(sys.argv[2])
    keys = set(data1.keys()) & set(data2.keys())
    max_value = 3000
    x = [data1[key] for key in keys if data1[key] < max_value and data2[key] < max_value]
    y = [data2[key] for key in keys if data1[key] < max_value and data2[key] < max_value]
    plot_data(x, y)


if __name__ == "__main__":
    main()
