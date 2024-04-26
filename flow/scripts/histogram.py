import matplotlib.pyplot as plt
import sys
import os


def create_histogram():
    lines = [line for line in sys.stdin]

    name = lines[0]
    clock_period = f"{float(lines[1])*1000000000000:.2f}"

    slack_values = [float(line) for line in lines[2:]]

    plt.hist(slack_values, bins=10)
    plt.title(f"Endpoint slack histogram register to register paths for {name} with Clock Period {clock_period} ps")
    plt.ylabel("Endpoint count")
    plt.show()


if __name__ == "__main__":
    pid = os.fork()

    if pid > 0:
        sys.exit()

    create_histogram()
