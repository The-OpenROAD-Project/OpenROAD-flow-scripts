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
  global countFail, countL, countB, countR, countT

  # Left-side
  if match[1] == str(margin):
    countL += 1
    return "PLACED ( 0 " + match[2] + " ) N"
  # Bottom-side
  elif match[2] == str(margin):
    countB += 1
    return "PLACED ( " + match[1] + " 0 ) N"
  # Right-side
  elif match[1] == str(width - margin):
    countR += 1
    return "PLACED ( "+ str(width) + " " + match[2] + " ) N"
  # Top-side
  elif match[2] == str(height - margin):
    countT += 1
    return "PLACED ( " + match[1] + " " + str(height) + " ) N"
  # Shouldn't happen
  else:
    countFail += 1
    return "PLACED ( " + match[1] + " " + match[2] + " ) N"

margin = int(args.margin)
countFail = 0
countL = 0
countB = 0
countR = 0
countT = 0

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

print("Replacements made: L:" + str(countL) + " B:" + str(countB) + " R:" + str(countR) + " T:" + str(countT))

if countFail > 0:
  print("WARNING: Failed to make " + str(countFail) + " replacements" )

# Write output
f = open(args.outputDef, "w")
f.write(result)
f.close()

if count < 1:
  print("WARNING: Replacement pattern not found")

print(os.path.basename(__file__),": Finished")
