# Build from sources locally

## Prerequisites & Dependencies

### OpenROAD

Instructions for installing OpenROAD are available [here](https://openroad.readthedocs.io/en/latest/main/README.html#install-dependencies)

### KLayout

OpenROAD Flow requires [KLayout](https://www.klayout.de) `v0.27.1`.

### Packages

-   `libffi-devel`
-   `tcl`
-   `time`
-   `pandas` Python library
      -   Available from pip (e.g., `python3-pip`) to install pandas:
          `pip3 install --user pandas`

## Clone and Build

``` shell
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts
./build_openroad.sh --local
```

```{note}
There is a `build_openroad.log` file that is generated with every build in the main directory. In case of filing issues, it can be uploaded in the "Relevant log output" section of OpenROAD-flow-scripts repo [issue form](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/issues/new?assignees=&labels=&template=bug_report_with_orfs.yml).
```

## Verify Installation

The binaries should be available on your `$PATH` after setting up the
environment.

``` shell
source ./setup_env.sh
yosys -help
openroad -help
exit
```
