#!/bin/bash

# Get the directory where the script is located
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $script_dir

# Check if the Python version is 3.8
required_version="3.8"
python_version=$(python3.8 --version 2>&1)
if [[ $python_version != "Python $required_version"* ]]; then
    echo "Error: Python $required_version is required. Current version: $python_version"
    exit 1
fi

# Define the virtual environment name
venv_name="autotuner_env"
python3.8 -m venv "$script_dir/$venv_name"
source "$script_dir/$venv_name/bin/activate"
pip3 install -U -r requirements.txt
deactivate
