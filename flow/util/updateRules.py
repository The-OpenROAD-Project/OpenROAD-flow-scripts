import json
import argparse
import os
from genRuleFile import update_rules
from genRuleFile import get_metrics

# Create the argument parser
parser = argparse.ArgumentParser(description='Process some integers.')

parser.add_argument('--keyFile',
                    type=str,
                    help='Service account credentials key file')
parser.add_argument('--overwrite',
                    action='store_true',
                    default=False,
                    help='Overwrite the golden metrics')
parser.add_argument('--apiURL',
                    type=str,
                    default="http://localhost:80",
                    help='Set API Base URL to get golden metrics')
parser.add_argument('--commitSHA',
                    type=str,
                    default="",
                    help='commit for the metrics used to update the rules')

# Parse the arguments
args = parser.parse_args()

# make sure the working dir is flow/
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))

platforms = list()
for root, dirs, files in os.walk('platforms'):
    for dir_name in dirs:
        if dir_name not in ['common', 'sky130hd_fakestack', 'sky130ram', 'sky130io']:
            platforms.append(dir_name)
    break

output = ''
for designsDir, dirs, files in sorted(os.walk('designs', topdown=False)):

    dirList = designsDir.split(os.sep)
    if len(dirList) != 3:
        continue

    dataFile = os.path.join(designsDir, f'rules-base.json')
    if not os.path.exists(dataFile):
        continue

    platform = dirList[1]
    if platform not in platforms:
        continue

    design = dirList[2]
    metrics = get_metrics(args.commitSHA,  # commit
                          platform,  # platform
                          design,  # design
                          args.apiURL  # backend url
                          )
    if metrics is None:
        output += f"Failed to update rule for {platform}/{design}\n"
        continue

    update_rules(designsDir,  # design directory
                 "base",  # variant
                 metrics,  # metrics needed for update, default is {} in case of file
                 args.overwrite  # overwrite flag, default is false
                 )

print()
print(output)
