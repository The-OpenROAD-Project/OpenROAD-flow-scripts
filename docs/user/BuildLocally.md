# Build from sources locally

## Clone and Install Dependencies

The `DependencyInstaller.sh` script installs all of the dependencies, including OpenROAD dependencies, if they are not already installed.

``` shell
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts
./etc/DependencyInstaller.sh
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
