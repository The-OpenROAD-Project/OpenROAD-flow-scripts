#!/usr/bin/env bash

# Get the directory of the current script
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Check if the activation script exists
VENV_PATH="$SCRIPT_DIR/autotuner_env/bin/activate"
if [ ! -f "$VENV_PATH" ]; then
  echo "Error: Virtual environment activation script not found at $VENV_PATH"
  echo "Please run installer.sh for installing the packages."
  exit 1
fi

# Source the activation script to activate the virtual environment
source "$VENV_PATH"
echo "Virtual environment activated successfully."
