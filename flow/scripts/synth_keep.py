import json
import sys


def count_cells(module, modules):
    count = 0
    for name, cell in module["cells"].items():
        if cell["type"] in modules:
            count += count_cells(modules[cell["type"]], modules)
        else:
            count += 1
    count += sum(map(lambda net: len(net['bits']),
                     module.get('netnames', dict()).values()))
    return count


def main(args):
    threshold = int(args[2])
    with open(args[0], "r") as f:
        synth = json.load(f)

    print("Preserving hierarchical modules...")
    with open(args[1], "w") as f:
        for name, module in synth["modules"].items():
            if count_cells(module, synth["modules"]) > threshold:
                f.write("select -module {\\" + name + "}\n")
                f.write("setattr -mod -set keep_hierarchy 1\n")
                f.write("select -clear\n")


if __name__ == "__main__":
    main(sys.argv[1:])
