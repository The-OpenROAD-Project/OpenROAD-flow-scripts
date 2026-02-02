import argparse
import json
import sys


def find_top_modules(data):
    top_module = []
    instantiations = set(
        [
            cell["type"]
            for minfo2 in data["modules"].values()
            for cell in minfo2["cells"].values()
        ]
    )
    for mname in data["modules"].keys():
        if mname not in instantiations:
            top_module.append(mname)
    return top_module


def find_cells_by_type_in_module(
    module_name, data, target_type, current_path, matching_cells
):
    for cell_name, cell in data["modules"][module_name]["cells"].items():
        cell_path = (
            f"{current_path}.{module_name}.{cell_name}"
            if current_path
            else f"{module_name}.{cell_name}"
        )
        if cell["type"] == target_type:
            matching_cells.append(cell_path)
        elif cell["type"] in data["modules"]:
            matching_cells.extend(
                find_cells_by_type_in_module(
                    cell["type"], data, target_type, cell_path, []
                )
            )
    return matching_cells


def find_cells_by_type(top_modules, data, module_name, current_path=""):
    names = []
    for top_module in top_modules:
        names.extend(
            find_cells_by_type_in_module(
                top_module, data, module_name, current_path, []
            )
        )
    return names


def format_ram_table_from_json(data, max_bits=None):
    top_modules = find_top_modules(data)
    formatting = "{:>5} | {:>5} | {:>6} | {:<20} | {:<80}\n"
    table = formatting.format("Rows", "Width", "Bits", "Module", "Instances")
    table += "-" * len(table) + "\n"

    max_ok = True
    entries = []

    for module_name, module_info in data["modules"].items():
        for cell in module_info["cells"].values():
            if not cell["type"].startswith("$mem"):
                continue
            parameters = cell["parameters"]
            size = int(parameters["SIZE"], 2)
            width = int(parameters["WIDTH"], 2)
            instances = find_cells_by_type(top_modules, data, module_name)
            instance_bits = size * width
            bits = instance_bits * len(instances)

            entries.append((size, width, bits, module_name, ", ".join(instances)))

            if max_bits is not None and instance_bits > max_bits:
                max_ok = False

    entries.sort(key=lambda x: x[2], reverse=True)

    for entry in entries:
        table += formatting.format(*entry)

    # ---- Summary statistics ----
    total_bits = sum(e[2] for e in entries)

    largest_instance_bits = 0
    largest_instance_module = None

    for size, width, _, module, _ in entries:
        instance_bits = size * width
        if instance_bits > largest_instance_bits:
            largest_instance_bits = instance_bits
            largest_instance_module = module

    summary = {
        "memory_count": len(entries),
        "largest_instance_bits": largest_instance_bits,
        "largest_instance_module": largest_instance_module,
        "largest_total_bits": entries[0][2] if entries else 0,
        "total_bits": total_bits,
    }

    return table, max_ok, summary


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
    formatted_table, max_ok, summary = format_ram_table_from_json(
        json_data, args.max_bits
    )

    print(formatted_table)

    print("Summary:")
    print(f"- Total inferred memories: {summary['memory_count']}")
    print(
        f"- Largest single memory instance: "
        f"{summary['largest_instance_bits']} bits "
        f"(module {summary['largest_instance_module']})"
    )
    print(f"- Total inferred memory bits (all instances): {summary['total_bits']}")

    if args.max_bits is not None:
        status = "OK" if max_ok else "FAIL"
        print(f"- SYNTH_MEMORY_MAX_BITS: {args.max_bits}")
        print(f"- Status: {status}")

        if not max_ok:
            sys.exit(
                f"Error: Synthesized memory size {args.max_bits} exceeds SYNTH_MEMORY_MAX_BITS"
            )
