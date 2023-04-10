#!/usr/bin/env python3

# This scripts attempts to generate elasped time in seconds for all the steps
# in the flow and prints it in a table
# ---------------------------------------------------------------------------

import pathlib
import os
import argparse  # argument parsing

# Parse and validate arguments
# ==============================================================================
parser = argparse.ArgumentParser(
    description='Print elapsed time for every step in the flow')
parser.add_argument('--logDir', '-d', required=True,
                    help='Log files directory')
args = parser.parse_args()

if not args.logDir:
    print('[ERROR] Please add a logDir'
          '-d/--logDir.')
    parser.print_help()
    sys.exit(1)

# Loop on all log files in the directory
for f in sorted(pathlib.Path(args.logDir).glob('**/[0-9]_*.log')):
    # Extract Elapsed Time line from log file
    for line in open(str(f)):
        elapsedTime = 0
        
        if 'Elapsed time' in line:
            # Extract the portion that has the time
            timePor = line.strip().replace('Elapsed time: ', '')
            # Remove the units from the time portion
            timePor = timePor.split('[h:]', 1)[0]
            # Ensure that hours, min and seconds are separated by ':' not '.'
            timePor = timePor.replace('.',':')
            # Calculate elapsed time that has this format 'h:m:s'
            timeList = timePor.split(':', 2)
            elapsedTime = int(timeList[0])*3600 + int(timeList[1])*60 + int(timeList[2])
    
    # Print the name of the step and the corresponding elapsed time
    print('%-25s %10s' % (os.path.splitext(os.path.basename(str(f)))[0], elapsedTime))


