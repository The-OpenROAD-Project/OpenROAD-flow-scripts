Wafer thin Bazel layer on top of Bazel
======================================

This example shows how to create a wafer thin Bazel layer on top of ORFS
for a private project that is not in a fork of ORFS(OpenROAD-flow-scripts)

Bazel offers some important features, such
as parallel builds and artifact sharing(share built macros).

A wafer thin Bazel layer on top of ORFS can be useful if it is important
to be able to easily report bugs using the `make issue` features and
having the ability to upgrade easily to the latest ORFS.

See https://github.com/hdl/bazel_rules_hdl for a much more comprehensive Bazel
implemenation that uses OpenROAD, amongst other tools.

Set up this example
-------------------

This example uses the `designs/src/aes` source code.

- Clone and build OpenROAD-flow-scripts into ~/OpenROAD-flow-scripts. The example `./orfs`
  script in this example assumes this location.
- Install Bazel and Bazelisk https://github.com/bazelbuild/bazelisk
- Create a symbolic link to the source code `ln -s ../../designs/src/aes/ aes`.
  A symbolic link is used because the Bazel must have the source files underneath
  the Bazel files and to avoid duplicating the `aes` code.

Set up environment variables from ORFS. Assuming you have ORFS in `~/OpenROAD-flow-scripts`:

    source ~/OpenROAD-flow-scripts/env.sh

Then build this test project with Bazel:

    bazelisk build ...

Viewing final results from Bazel
--------------------------------

    ./orfs make WORK_HOME=bazel-out/k8-fastbuild/bin/build/ DESIGN_CONFIG=config.mk gui_final

Staring at logs
---------------

If you want to "stare at logs" while Bazel is running, open the logs folder in vscode by:

    code $(readlink -f /proc/$(pgrep openroad)/cwd)/bazel-out/k8-fastbuild/bin/build/logs/

Using Bazel artifacts, but running ORFS locally
-----------------------------------------------

Use artifacts from the Bazel output folder and run local build:

    ./orfs make DESIGN_CONFIG=config.mk WORK_HOME_READ=bazel-out/k8-fastbuild/bin/build/
