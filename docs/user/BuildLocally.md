# Build from sources locally

## Clone and Install Dependencies

The `setup.sh` script installs all of the dependencies, including OpenROAD dependencies, if they are not already installed.

``` shell
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts
sudo ./setup.sh
```

## Build

``` shell
./build_openroad.sh --local
```
> **Note:** There is a `build_openroad.log` file that is generated with every build in the main directory. In case of filing issues, it can be uploaded in the "Relevant log output" section of OpenROAD-flow-scripts repo [issue form](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/issues/new?assignees=&labels=&template=bug_report_with_orfs.yml).

## Verify Installation

The binaries should be available on your `$PATH` after setting up the
environment.

``` shell
source ./setup_env.sh
yosys -help
openroad -help
exit
```

## Compiling and debugging in Visual Studio Code

Set up environment variables to point to tools that CMake from within
Visual Studio Code will need, then start Visual Studio Code as usual
and hit F7, assuming you have CMake plugins installed.

``` shell
. ./dev_env.sh
code tools/OpenROAD/
```
