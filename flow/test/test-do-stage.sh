#!/usr/bin/env bash
set -ex
make clean_all
make do-sdc-clock-period
make do-yosys-canonicalize
make do-yosys
# There is deliberately no do-synth step (see the do-step comment in
# flow/Makefile); make synth materializes 1_2_yosys.sdc and 1_synth.odb.
make synth
make do-floorplan
make do-place
make do-cts
make do-route
make do-final
make do-generate_abstract


