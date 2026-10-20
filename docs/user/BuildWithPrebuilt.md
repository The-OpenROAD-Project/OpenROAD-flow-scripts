# Using Pre-built Binaries

## Install Klayout and Yosys
Please ensure the Klayout version (denoted with `klayoutVersion` variable) is consistent with the one used in [DependencyInstaller script](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/blob/master/etc/DependencyInstaller.sh).

Instructions for installing:
- [Klayout>=0.28.8](https://www.klayout.de/build.html)
- [Yosys>=0.58](https://github.com/YosysHQ/oss-cad-suite-build/blob/master/README.md#installation)

## Install OpenROAD
Download pre-built binaries with self-contained dependencies
from [OpenROAD VaultLink](https://vaultlink.precisioninno.com/).

Thanks to [Precision Innovations](https://precisioninno.com/) for hosting and maintaining these binaries.

Pre-built binaries are available for these platforms:
- Ubuntu 22.04
- Ubuntu 24.04

Use the following steps to download:

Step 1: Open [OpenROAD VaultLink](https://vaultlink.precisioninno.com/).

Step 2: Download the `.deb` package for your Ubuntu version.

Step 3: Install the package with `apt`.
        For example, on Ubuntu 22.04:

```shell
sudo apt install ./openroad_<version>_amd64-ubuntu-22.04.deb
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
yosys -m slang -p "slang_version"
openroad -help
cd flow
make
make gui_final
```
