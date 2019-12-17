#!/usr/bin/env python3
import re
import sys
import argparse  # argument parsing

# Parse and validate arguments
# ==============================================================================
parser = argparse.ArgumentParser(
    description='Merges lefs together')
parser.add_argument('--inputLef', '-i', required=True,
                    help='Input Lef', nargs='+')
parser.add_argument('--outputLef', '-o', required=True,
                    help='Output Lef')
args = parser.parse_args()


f = open(args.inputLef[0])
content = f.read()
f.close()

# Find the
content = re.sub("END LIBRARY","",content)


for lefFile in args.inputLef[1:]:
  f = open(lefFile)
  snippet = f.read()
  f.close()

  pattern = r".*?(MACRO.*)(END LIBRARY)"
  replace = r"\1"

  result,count = re.subn(pattern, replace, snippet, 1, re.S)

  if count > 0:
    content += result
  else:
    print("ERROR: Pattern not found")
    sys.exit(1)

content += "END LIBRARY"


f = open(args.outputLef, "w")
f.write(content)
f.close()