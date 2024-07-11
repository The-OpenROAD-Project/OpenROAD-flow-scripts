#!/bin/bash

local autotuner_pkgs=" $(cat ./requirements.txt)"
local venv_name="autotuner_env"
python3 -m venv $venv_name
source "$venv_name/bin/activate"
pip3 install -U $autotuner_pkgs
deactivate
