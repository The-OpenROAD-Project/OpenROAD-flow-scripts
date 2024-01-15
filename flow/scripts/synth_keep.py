import json
import sys


def main(args):
    threshold = int(args[2])
    with open(args[0], "r") as f:
        synth = json.load(f)

    print("Preserving hierarchical modules...")
    with open(args[1], "w") as f:
        for name, module in synth["modules"].items():
            if len(module["cells"]) > threshold:
                f.write("select -module {\\" + name + "}\n")
                f.write("setattr -mod -set keep_hierarchy 1\n")
                f.write("select -clear\n")


if __name__ == "__main__":
    main(sys.argv[1:])
