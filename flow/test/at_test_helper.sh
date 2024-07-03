#!/usr/bin/env bash

set -eoux pipefail

cd "$(dirname $(readlink -f $0))/../"

# Setting args (and setting default values for testing)
AT_TEST_SLUG=${2:-ref_file_check}

echo "Now running $AT_TEST_SLUG"

# change directory to ../
cd ..
echo "Install dependencies in Venv"
python3 -m venv .venv
source .venv/bin/activate
pip install -r tools/AutoTuner/requirements.txt
    

if [ $AT_TEST_SLUG == "ref_file_check" ]; then
    echo "Now running reference file check"
    python3 -m unittest tools.AutoTuner.test.ref_file_check        
fi
