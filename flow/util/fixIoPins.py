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
  global countFail, countWest, countSouth, countEast, countNorth

  # West side
  if match.group(1) == str(margin):
    countWest += 1
    return "PLACED ( 0 " + match.group(2) + " ) E + LAYER " + match.group(3) + " ( " + str(margin*-1) + " 0 ) ( " + str(margin) + " " + str(margin*2) + " )"
  # South side
  elif match.group(2) == str(margin):
    countSouth += 1
    return "PLACED ( " + match.group(1) + " 0 ) N + LAYER " + match.group(3) + " ( " + str(margin*-1) + " 0 ) ( " + str(margin) + " " + str(margin*2) + " )"
  # East side
  elif match.group(1) == str(width - margin):
    countEast += 1
    return "PLACED ( "+ str(width) + " " + match.group(2) + " ) W + LAYER " + match.group(3) + " ( " + str(margin*-1) + " 0 ) ( " + str(margin) + " " + str(margin*2) + " )"
  # North side
  elif match.group(2) == str(height - margin):
    countNorth += 1
    return "PLACED ( " + match.group(1) + " " + str(height) + " ) S + LAYER " + match.group(3) + " ( " + str(margin*-1) + " 0 ) ( " + str(margin) + " " + str(margin*2) + " )"
  # Shouldn't happen
  else:
    countFail += 1
    return match.group(0)

margin = int(args.margin)
countFail = 0
countWest = 0
countSouth = 0
countEast = 0
countNorth = 0

# Open Def File
f = open(args.inputDef)
content = f.read()
f.close()

# Find width and height
dieAreaPattern = r"DIEAREA *\( *\d+ *\d+ *\) *\( *(\d+) *(\d+) *\)"
m = re.search(dieAreaPattern, content)

width = int(m.group(1))
height = int(m.group(2))


# Perform replacement
placePattern = r"PLACED \( (\d+) (\d+) \) N \+ LAYER (\S+) \( \S+ \S+ \) \( \S+ \S+ \)"
result, count = re.subn(placePattern, replace_coords, content, 0, re.S)

print("Replacements made - West:" + str(countWest) + " South:" + str(countSouth) + " East:" + str(countEast) + " North:" + str(countNorth))

if countFail > 0:
  print("WARNING: Failed to make " + str(countFail) + " replacements" )

# Write output
f = open(args.outputDef, "w")
f.write(result)
f.close()

if count < 1:
  print("WARNING: Replacement pattern not found")

print(os.path.basename(__file__),": Finished")
