#!/usr/bin/env bash

# Get the directory of the current script
script_dir="$(dirname "${BASH_SOURCE[0]}")"

# Check if the activation script exists
venv_path="$script_dir/autotuner_env/bin/activate"
if [ ! -f "$venv_path" ]; then
  echo "Error: Virtual environment activation script not found at $venv_path"
  echo "Please run installer.sh for installing the packages."
  exit 1
fi

# Source the activation script to activate the virtual environment
source "$venv_path"
echo "Virtual environment activated successfully."
