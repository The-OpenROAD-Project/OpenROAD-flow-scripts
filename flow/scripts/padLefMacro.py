#!/usr/bin/env python3
import re
import sys
import os
import argparse  # argument parsing

# Parse and validate arguments
# ==============================================================================
parser = argparse.ArgumentParser(
    description='Adds padding to the right of all macros in a lef file')
parser.add_argument('--padding', '-p', required=True,
                    help='Padding')
parser.add_argument('--exclude', '-e', required=False,
                    default='ENDCAPTIE* FILL* WELLTAP* tsmc65lp_*',
                    help='exclude')
parser.add_argument('--inputLef', '-i', required=True,
                    help='Input Lef')
parser.add_argument('--outputLef', '-o', required=True,
                    help='Output Lef')
args = parser.parse_args()


# Function used by re.sub
def replace_pad(match):
  m = match.groups()
  skip = 0

  # Check if it's a MACRO to be skipped
  for pattern in args.exclude.split():
    if re.match(pattern, m[0]):
      print('Skipping LEF padding for MACRO ', m[0])
      skip = 1
      break

  # Don't pad if skip
  if skip:
    new_x = m[2]
  else:
    new_x = str(round(float(m[2]) + float(args.padding), 2))

  replace = r"MACRO " + m[0] + m[1] + "SIZE " + new_x + " BY " + m[3] + m[4] + "END"
  return replace

print(os.path.basename(__file__),": Padding technology lef file")

# Read input file
f = open(args.inputLef)
content = f.read()
f.close()

# Perform match
pattern = r"MACRO\s+(\S+)(.*?)SIZE (\S+) BY (\S+)(.*?)END"
result, count = re.subn(pattern, replace_pad, content, 0, re.S)

# Write output file
f = open(args.outputLef, "w")
f.write(result)
f.close()

# Check
if count < 1:
  print("WARNING: Replacement pattern not found")
  # sys.exit(1)

print(os.path.basename(__file__),": Finished")
