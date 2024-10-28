#!/usr/bin/env bash
set -ex
make clean_all
make do-yosys-canonicalize
make do-yosys-keep-hierarchy
make do-yosys
make do-synth
make do-floorplan
make do-place
make do-cts
make do-route
make do-final
make do-generate_abstract


