import argparse
import json
import os
import sys


def format_ram_table_from_json(data, max_bits=None):
    formatting = "{:<15} | {:<15} | {:<15} | {:<50}\n"
    table = formatting.format("Rows",
                              "Width",
                              "Total bits",
                              "Name")
    table += "-"*len(table) + "\n"
    max_ok = True
    for module_name, module_info in data["modules"].items():
        cells = module_info["cells"]
        for memory, cell in cells.items():
            if not cell["type"].startswith("$mem"):
                continue
            parameters = cell["parameters"]
            size = int(parameters["SIZE"], 2)
            width = int(parameters["WIDTH"], 2)
            bits = size * width
            table += formatting.format(size,
                                       width,
                                       bits,
                                       module_name + "." + memory)
            if max_bits is not None and bits > max_bits:
                max_ok = False
    return table, max_ok


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("file")
    parser.add_argument("-m", "--max-bits", type=int, default=None)
    args = parser.parse_args()

    with open(args.file, 'r') as file:
        json_data = json.load(file)
    formatted_table, max_ok = format_ram_table_from_json(json_data, args.max_bits)
    print(formatted_table)
    if not max_ok:
        sys.exit("ERROR: Synthesized memory size exceeds maximum allowed bits " + str(args.max_bits))
