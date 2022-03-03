#!/usr/bin/env python3
import re
import sys
import gzip
import argparse  # argument parsing

# Parse and validate arguments
# ==============================================================================
parser = argparse.ArgumentParser(
    description='Replaces occurrences of cells in def or verilog files')
parser.add_argument('--patterns', '-p', required=True,
                    help='List of search patterns')
parser.add_argument('--inputFile', '-i', required=True,
                    help='Input File')
parser.add_argument('--outputFile', '-o', required=True,
                    help='Output File')
args = parser.parse_args()


# Convert * wildcards to regex wildcards
patternList = args.patterns.replace('*','.*').split()

# Read input file
print("Opening file for replace:",args.inputFile)
if args.inputFile.endswith(".gz") or args.inputFile.endswith(".GZ"):
    f = gzip.open(args.inputFile, 'rt', encoding="utf-8")
else:
    f = open(args.inputFile, encoding="utf-8")
content = f.read().encode("ascii", "ignore").decode("ascii")
f.close()

# Pattern to match a cell header
pattern = r"(^\s*cell\s*\(\s*([\"]*"+"[\"]*|[\"]*".join(patternList)+"[\"]*)\)\s*\{)"

# print(pattern)
replace = r"\1\n    dont_use : true;"
content, count = re.subn(pattern, replace, content, 0, re.M)
print("Marked", count, "cells as dont_use")


# Yosys-abc throws an error if original_pin is found within the liberty file.
# removing
pattern = r"(.*original_pin.*)"
replace = r"/* \1 */;"
content, count = re.subn(pattern, replace, content)
print("Commented", count, "lines containing \"original_pin\"")

# Yosys, does not like properties that start with : !, without quotes
pattern = r":\s+(!.*)\s+;"
replace = r': "\1" ;'
content, count = re.subn(pattern, replace, content)
print("Replaced malformed functions", count)

# Write output file
print("Writing replaced file:",args.outputFile)
f = open(args.outputFile, "w")
f.write(content)
f.close()
