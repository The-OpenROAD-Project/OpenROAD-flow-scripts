#!/usr/bin/env python3

import re
import sys


def process_header(filename, sclname):
    with open(filename, "r") as fh:
        for line in fh:
            if re.search(r"library\s*\(", line):
                print(f"library ({sclname}) {{")
                continue
            if re.match(r"^[\t ]*cell\s*\(", line):
                break
            print(line, end="")


def process_cells(filename):
    with open(filename, "r") as fh:
        flag = 0  # brace depth
        for line in fh:
            # Match 'cell ( ... )' with optional whitespace
            if re.match(r"^[\t ]*cell\s*\(", line):
                if flag != 0:
                    raise RuntimeError(
                        "Error! new cell before finishing the previous one!"
                    )
                print()  # print blank line like Perl
                print(line, end="")
                flag = 1  # entering a cell block
            elif flag > 0:
                # Increase/decrease brace depth
                flag += line.count("{")
                flag -= line.count("}")
                print(line, end="")

                # Optionally: reset flag to 0 here if it's finished
                # But not necessary unless you're adding post-processing


def main():
    if len(sys.argv) < 3:
        print("use: mergeLib.py new_library_name lib1 lib2 lib3 ....")
        sys.exit(1)

    sclname = sys.argv[1]
    files = sys.argv[2:]

    process_header(files[0], sclname)
    for file in files:
        process_cells(file)
    print("\n}")


if __name__ == "__main__":
    main()
