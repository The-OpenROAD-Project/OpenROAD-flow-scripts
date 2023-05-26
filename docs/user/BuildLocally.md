# Build from sources locally

## Clone and Install Dependencies

The `setup.sh` script installs all of the dependencies, including OpenROAD dependencies, if they are not already installed.

Supported configurations are: CentOS 7, Ubuntu 20.04, Ubuntu 22.04, RHEL 8,
Debian 10 and Debian 11.

``` shell
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts
sudo ./setup.sh
```

## Build

``` shell
./build_openroad.sh --local
```
> **Note:** There is a `build_openroad.log` file that is generated with every
> build in the main directory. In case of filing issues, it can be uploaded
> in the "Relevant log output" section of OpenROAD-flow-scripts repo
> [issue form](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/issues/new?assignees=&labels=&template=bug_report_with_orfs.yml).

## Verify Installation

The binaries should be available on your `$PATH` after setting
up the environment.

``` shell
source ./env.sh
yosys -help
openroad -help
cd flow
make
```

Above `make` command run from RTL-GDSII generation for default
design `gcd` with `nangate45` pdk. You can view final layout with
OpenROAD GUI as,

```
make gui_final
```

![gcd_final.webp](../images/gcd_final.webp)

## Using Pre-built Binaries

You can download pre-built binaries with self contained dependencies
included from the Precision Innovations github repository
[here](https://github.com/Precision-Innovations/OpenROAD/actions/workflows/github-actions-build-deb-package.yml).

Thanks to [Precision Innovations](http://www.precisioninno.com) for hosting and maintaining these binaries.

The following platforms are supported currently:
- Ubuntu 20.04/22.04
- Debian 10/11

Use following steps to download:

Step 1: Click on the [Precision Innovations Github releases link](https://github.com/Precision-Innovations/OpenROAD/releases).

Step 2: Download the artifacts for your distribution.

Step 3: Run the install command based on platform use package installer.
        For example Ubuntu 20.04 use:
```shell
sudo apt install ./openroad_2.0_amd64-ubuntu20.04.deb
```

You can install these binaries within docker as well.

> **Thanks** to Precision Innovations (www.precisioninno.com) for providing
> and supporting this daily release of pre built installers to the community.

## Compiling and debugging in Visual Studio Code

Set up environment variables to point to tools that CMake from within
Visual Studio Code will need, then start Visual Studio Code as usual
and hit F7, assuming you have CMake plugins installed.

``` shell
. ./dev_env.sh
code tools/OpenROAD/
```
