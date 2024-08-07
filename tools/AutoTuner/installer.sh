#!/usr/bin/env bash

# Get the directory where the script is located
script_dir="$(dirname "${BASH_SOURCE[0]}")"
cd $script_dir

# Define the virtual environment name
venv_name="autotuner_env"
python${required_version} -m venv "$script_dir/$venv_name"
source "$script_dir/$venv_name/bin/activate"
pip3 install -U -r requirements.txt
deactivate
