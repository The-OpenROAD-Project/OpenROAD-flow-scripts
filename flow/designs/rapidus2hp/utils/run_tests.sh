#!/bin/bash

err_ct=0

for design_name in cva6 ethmac gcd hercules_idecode hercules_is_int ibex jpeg; do
    ./designs/rapidus2hp/$design_name/test/test_params.py
    if [ $? -ne 0 ]; then
	((err_ct++))
    fi
done

if [ $err_ct -ne 0 ]; then
    echo "ERROR: $err_ct errors found"
    exit 1
fi

exit 0
