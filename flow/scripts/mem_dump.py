import argparse
import json
import sys


def format_ram_table_from_json(data, max_bits=None):
    formatting = "{:>5} | {:>5} | {:>6} | {:<20} | {:<80}\n"
    table = formatting.format("Rows", "Width", "Bits", "Module", "Instances")
    table += "-" * len(table) + "\n"
    max_ok = True
    for module_name, module_info in data["modules"].items():
        cells = module_info["cells"]
        for cell in cells.values():
            if not cell["type"].startswith("$mem"):
                continue
            parameters = cell["parameters"]
            size = int(parameters["SIZE"], 2)
            width = int(parameters["WIDTH"], 2)
            instances = [
                mname + "." + cell_name
                for mname, minfo in data["modules"].items()
                for cell_name, cell in minfo["cells"].items()
                if cell["type"] == module_name
            ]
            bits = size * width * len(instances)
            table += formatting.format(
                size, width, bits, module_name, ", ".join(instances)
            )
            if max_bits is not None and bits > max_bits:
                max_ok = False
    return table, max_ok


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("file")
    parser.add_argument("-m", "--max-bits", type=int, default=None)
    args = parser.parse_args()

    with open(args.file, "r") as file:
        json_data = json.load(file)

    src_files = set()
    for module_name, module_info in json_data["modules"].items():
        for cell in list(module_info["cells"].values()) + [module_info]:
            if "src" not in cell["attributes"]:
                continue
            src_file = cell["attributes"]["src"].split(":")[0]
            src_files.add(src_file)

    print("Source files actually used in the design:")
    print(" " + "\n ".join(src_files))

    print("Memories found in the design:")
    formatted_table, max_ok = format_ram_table_from_json(json_data, args.max_bits)
    print(formatted_table)
    if not max_ok:
        sys.exit(
            "ERROR: Synthesized memory size exceeds maximum allowed bits "
            + str(args.max_bits)
        )
