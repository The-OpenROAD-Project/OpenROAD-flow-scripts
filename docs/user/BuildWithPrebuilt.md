# Using Pre-built Binaries

## Install Klayout and Yosys
Please ensure the Klayout version (denoted with `klayoutVersion` variable) is consistent with the one used in [DependencyInstaller script](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/blob/master/etc/DependencyInstaller.sh). 

Instructions for installing:
- [Klayout>=0.28.8](https://www.klayout.de/build.html)
- [Yosys>=0.39](https://github.com/YosysHQ/oss-cad-suite-build/blob/master/README.md#installation)

```{tip} Unfortunately KLayout maintainers do not provide Debian 10/11 compatible packages. You can follow the build-from-sources instruction (Version >=0.25) and Ubuntu 22 instructions [here](https://www.klayout.de/build.html#:~:text=Building%20KLayout%20on%20Linux%20(Version%20%3E%3D%200.25)). 
```

## Install OpenROAD
Download pre-built binaries with self-contained dependencies
included from the Precision Innovations' GitHub releases
[here](https://github.com/Precision-Innovations/OpenROAD/releases).

Thanks to [Precision Innovations](https://precisioninno.com/) for hosting and maintaining these binaries.

The following platforms are supported currently:
- Ubuntu 20.04/22.04
- Debian 10/11

Use the following steps to download:

Step 1: Click on the [Precision Innovations Github releases link](https://github.com/Precision-Innovations/OpenROAD/releases).

Step 2: Download the artifacts for your distribution.

Step 3: Run the install command based on platform use package installer.
        For example Ubuntu 20.04 use:
        
```shell
sudo apt install ./openroad_2.0_amd64-ubuntu20.04.deb
```

## Install Klayout and Yosys
Please ensure the Klayout version (denoted with `klayoutVersion` variable) is consistent with the one used in [DependencyInstaller script](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/blob/master/etc/DependencyInstaller.sh). 

Instructions for installing:
- [Klayout>=0.28.8](https://www.klayout.de/build.html)
- [Yosys>=0.39](https://github.com/YosysHQ/oss-cad-suite-build/blob/master/README.md#installation)

```{tip} Unfortunately KLayout maintainers do not provide Debian 10/11 compatible packages. You can follow the build-from-sources instruction (Version >=0.25) and Ubuntu 22 instructions [here](https://www.klayout.de/build.html#:~:text=Building%20KLayout%20on%20Linux%20(Version%20%3E%3D%200.25)). 
```


## Verify Installation
You may clone the OpenROAD-flow-scripts repository non-recursively. 

```
git clone https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git
```

Export path variables accordingly.

```
# these variables are used in flow/Makefile. Do make sure the yosys path is sourced.
export OPENROAD_EXE=$(command -v openroad)
export YOSYS_EXE=$(command -v yosys)

# only if KLayout is built from source
export LD_LIBRARY_PATH="<klayout_location>/bin:$PATH" 

yosys -help
openroad -help
cd flow
make
make gui_final
```
