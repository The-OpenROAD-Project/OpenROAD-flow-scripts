# Using Pre-built Binaries

## Install KLayout and Yosys
The GDS file is written with KLayout's Python module, installed with the
other Python packages from `etc/requirements-common_lock.txt`, or alone
with `pip install klayout`. `make drc` and `make lvs`, the gallery and
the viewers need the KLayout application:
[KLayout](https://www.klayout.de/build.html).

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

yosys -help
yosys -m slang -p "slang_version"
openroad -help
cd flow
make
make gui_final
```
