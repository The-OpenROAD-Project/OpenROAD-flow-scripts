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

retry_count=0
max_retries=5
success=false

while [[ $retry_count -lt $max_retries ]]; do
    if pip3 cache purge && pip3 install --no-cache-dir -U -r "$script_dir/requirements.txt"; then
        success=true
        break
    else
        retry_count=$((retry_count + 1))
        echo "Attempt $retry_count failed. Retrying in 1 minute..."
        sleep 60
    fi
done

if [ "$success" = false ]; then
    echo "Failed to install requirements after $max_retries attempts."
    deactivate
    exit 1
fi

pip3 install --no-cache-dir -e "$script_dir[$dependencies]"
deactivate
