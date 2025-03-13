# Scripts

Various scripts to support flow as well as utilities.

## make run-yosys

Sets up all the ORFS environment variables and launches Yosys.

Useful to run a Yosys script or interactive mode on the synthesis result to  extract information or debug synthesis results using Yosys commands.

Used with the `YOSYS_RUN_ARGS` variable to pass arguments to Yosys. The default arguments is a "Hello world" script that lists all modules with the keep_hierarchy attribute set and writes a report of those modules.

    $ make DESIGN_CONFIG=designs/asap7/aes-block/config.mk synth run-yosys
    $ cat reports/asap7/aes-block/base/keep.txt

    2 modules:
      aes_cipher_top    aes_key_expand_128

## yosys_load.tcl

Loads in 1_synth.v synthesis result from Yosys. This is useful in automation, such as generating reports from synthesis, but can also be used in interactive inspection.

Example usage to examine results interactively:

    make DESIGN_CONFIG=designs/asap7/aes-block/config.mk synth run-yosys RUN_YOSYS_ARGS=-C

Load synthesis result and list modules that were kept in hierarchical synthesis:

    [banner deleted]
    % source $::env(SCRIPTS_DIR)/yosys_load.tcl
    [yosys verbose output deleted]
    % ls A:keep_hierarchy=1

    2 modules:
    aes_cipher_top
    aes_key_expand_128
    %
