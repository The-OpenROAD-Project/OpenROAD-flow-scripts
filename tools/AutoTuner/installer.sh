#!/bin/bash

# Get the directory where the script is located
script_dir="$(dirname "${BASH_SOURCE[0]}")"
cd $script_dir

# Check if the Python version is 3.8
required_version="3.8"
if command -v python${required_version} &> /dev/null ; then
    echo "Found python${required_version}"
else
    echo "Error: Python ${required_version} is required."
    exit 1
fi

# Define the virtual environment name
venv_name="autotuner_env"
python${required_version} -m venv "$script_dir/$venv_name"
source "$script_dir/$venv_name/bin/activate"
pip3 install -U -r requirements.txt
deactivate
