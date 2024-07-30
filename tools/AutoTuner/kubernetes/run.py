""" This script is meant to be run from a pod in the same Kubernetes namespace
as your Ray cluster.
"""

from collections import Counter
import sys
import time
import ray


@ray.remote
def gethostname(x):
    import platform

    time.sleep(2)
    return x + (platform.node(),)


def main():
    """
    Check that objects can be transferred from each node to each other node.
    """
    results = [gethostname.remote(gethostname.remote(())) for _ in range(10)]
    print(Counter(ray.get(results)))
    sys.stdout.flush()

    print("Success!")
    sys.stdout.flush()


if __name__ == "__main__":
    ray.init("ray://127.0.0.1:10001")
    main()
