#!/usr/bin/env bash

# Get the directory where the script is located
script_dir="$(dirname "${BASH_SOURCE[0]}")"

# Define the virtual environment name
venv_name="autotuner_env"
python3 -m venv "$script_dir/$venv_name"
source "$script_dir/$venv_name/bin/activate"
pip3 install -U -r $script_dir/requirements.txt
deactivate
