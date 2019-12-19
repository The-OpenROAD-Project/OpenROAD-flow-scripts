#!/usr/bin/env python3
import re
import sys
import os
import argparse  # argument parsing

# Parse and validate arguments
# ==============================================================================
parser = argparse.ArgumentParser(
    description='Fixes ioPlacer pins to be exactly on the die boundary')
parser.add_argument('--inputDef', '-i', required=True,
                    help='Input DEF')
parser.add_argument('--outputDef', '-o', required=True,
                    help='Output DEF')
parser.add_argument('--margin', '-m', required=True,
                    help='Margin')
# This margin is calculated automatically according to the technology rules
# based on metal min with and will be unique based on the selected metals and
# platform
args = parser.parse_args()


print(os.path.basename(__file__),": Fixing Pins in Def file")


# Function used by re.sub
def replace_coords(match):
  # print(match.groups())

  # Left-side
  if match[1] == str(margin):
    return "PLACED ( 0 " + match[2] + " ) N"
  # Bottom-side
  elif match[2] == str(margin):
    return "PLACED ( " + match[1] + " 0 ) N"
  # Right-side
  elif match[1] == str(width - margin):
    return "PLACED ( "+ str(width) + " " + match[2] + " ) N"
  # Bottom-side
  elif match[2] == str(height - margin):
    return "PLACED ( " + match[1] + " " + str(height) + " ) N"
  # Shouldn't happen
    print("Warning")
    return match[0]

margin = int(args.margin)

# Open Def File
f = open(args.inputDef)
content = f.read()
f.close()

# Find width and height
dieAreaPattern = r"DIEAREA *\( *\d+ *\d+ *\) *\( *(\d+) *(\d+) *\)"
# dieAreaPattern = r"(DIEAREA.*)"
m = re.search(dieAreaPattern, content)

width = int(m.group(1))
height = int(m.group(2))


# Perform replacement
placePattern = r"PLACED \( (\d+) (\d+) \) N"
result, count = re.subn(placePattern, replace_coords, content, 0, re.S)

# Write output
f = open(args.outputDef, "w")
f.write(result)
f.close()

if count < 1:
  print("WARNING: Replacement pattern not found")

print(os.path.basename(__file__),": Finished")
