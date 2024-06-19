#!/usr/bin/env bash

set -eoux pipefail

cd "$(dirname $(readlink -f $0))/../"

# Setting args (and setting default values for testing)
AT_TEST_SLUG=${2:-resume_check}

echo "Now running $AT_TEST_SLUG"

# change directory to ../
# cd ..
# echo "Install dependencies in Venv"
# python3 -m venv .venv
# source .venv/bin/activate
# pip install -r tools/AutoTuner/requirements.txt


if [ $AT_TEST_SLUG == "resume_check" ]; then
    echo "Now running args.resume check"
    python3 -m unittest tools.AutoTuner.test.resume_check
fi
