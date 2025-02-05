#!/usr/bin/env bash

# Get the directory where the script is located
script_dir="$(dirname "${BASH_SOURCE[0]}")"

dependencies=""
if [[ "$#" -eq 0 ]]; then
  echo "Installing dependencies for Ray Tune and Vizier"
  dependencies="ray,vizier"
elif [[ "$#" -ne 1 ]] || ([[ "$1" != "ray" ]] && [[ "$1" != "vizier" ]]); then
  echo "Please specify whether 'ray' or 'vizier' dependencies should be installed" >&2
  exit 1
else
  dependencies="$1"
fi

# Define the virtual environment name
venv_name="autotuner_env"
python3 -m venv "$script_dir/$venv_name"
source "$script_dir/$venv_name/bin/activate"
pip3 install -e "$script_dir[$dependencies]"
deactivate
