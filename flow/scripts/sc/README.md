# SiliconCompiler OpenROAD-flow-scripts build scripts

This is a collection of build scripts for use with SiliconCompiler. They are intented to be called by a Python-based build script.

To use them, install the `siliconcompiler` Python module and add this directory to your `$SCPATH` environment variable:

    pip3 install siliconcompiler
    export SCPATH=[OpenROAD-flow-scripts]/flow/scripts/sc

To run the OpenROAD reference flow using SiliconCompiler, navigate to your `OpenROAD-flow-scripts/flow` directory and run:

    python3 Makefile.py -DESIGN_CONFIG=./designs/[platform]/[design]/config.mk

Once the build completes, you can find the results and build artifacts in `build/[design]/job0/`. Most files are sorted into directories named after the task associated with them.

For example, you can find the post-synthesis netlist under `build/[design]/job0/or_yosys/0/outputs/1_synth.v`. Likewise, the final GDS result can be found under `build/[design]/job0/or_export/0/outputs/[design].gds`

You can view a completed design in KLayout with the appropriate platform's layer map using the `sc-show` helper script:

    sc-show -design [design]

# Example: GCD on nangate45

(First time only) install:

    pip3 install siliconcompiler
    export SCPATH=[OpenROAD-flow-scripts]/flow/scripts/sc

Build:

    cd [OpenROAD-flow-scripts]/flow
    python3 Makefile.py -DESIGN_CONFIG=./designs/nangate45/gcd/config.mki

View:

    sc-show -design gcd
