# Build OpenROAD on Windows Using Docker

This guide walks you through installing and running OpenROAD on Windows using Docker Desktop with an Ubuntu 22.04 container.

## Prerequisites

- Windows 10 (version 2004+) or Windows 11
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (WSL2 backend enabled)
- At least 16GB RAM (8GB minimum usable)
- At least 50GB free disk space

## Step 1 — Install and Configure Docker Desktop

1. Download and install [Docker Desktop for Windows] (https://www.docker.com/products/docker-desktop/)
2. During setup, enable **WSL 2 backend**
3. After installation, open Docker Desktop -> Settings -> Resources:
   * Memory: ≥ 8GB
   * CPUs: ≥ 4
4. Go to the Settings -> Resources -> WSL Integration -> Enable for Ubuntu-22.04
   
Verify installation (run in PowerShell):
```
docker run -rm hello-world
```

## Step 2 — Start an Ubuntu 22.04 Container

Run in **PowerShell**:
```bash
docker run -it ubuntu:22.04
```

This opens an interactive Ubuntu terminal inside Docker.

> **Note:** All following commands run **inside this Docker container**
> unless stated otherwise.

## Step 3 — Avoid Timezone Prompt

Before running any `apt-get` command, set this to avoid interactive prompts:
```bash
export DEBIAN_FRONTEND=noninteractive
export TZ=UTC

apt-get update
apt-get install -y tzdata
```

## Step 4 — Download and Install OpenROAD Binary

Download the prebuilt `.deb` file for Ubuntu 22.04 from [Precision Innovations releases](https://vaultlink.precisioninno.com/).

Copy it from Windows into the running container (run in **PowerShell**):
```powershell
# First get your container ID
docker ps

# Copy the file into the container
docker cp "C:\Users\<YourUsername>\Downloads\openroad_<version>_amd64-ubuntu-22.04.deb" <container_id>:/root/
```

Install it inside the container:
```bash
cd /root
apt-get install -y ./openroad_<version>_amd64-ubuntu-22.04.deb.deb
```

Verify:
```bash
openroad -version
```

## Step 5 — Install Correct Yosys Version

The default apt version of Yosys is too old (0.9). ORFS requires Yosys >= 0.58.
Install OSS CAD Suite which includes a compatible version:
```bash
apt-get install -y wget
cd /root

wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2025-03-01/oss-cad-suite-linux-x64-20250301.tgz
tar -xzf oss-cad-suite-linux-x64-20250301.tgz

source /root/oss-cad-suite/environment
yosys --version
```

To make yosys available permanently across sessions:
```bash
echo 'source /root/oss-cad-suite/environment' >> ~/.bashrc
source ~/.bashrc
```

> **Important:** Always use a pinned version of OSS CAD Suite.
> ORFS does not guarantee compatibility with `latest`.

## Step 6 — Fix Line Endings (CRLF Issue)

Run in **PowerShell** before cloning:
```powershell
git config --global core.autocrlf false
git config --global core.eol lf
```

## Step 7 - Clone OpenROAD Flow Scripts 

Run inside the container:
```bash
apt-get install -y git
git clone https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git
cd OpenROAD-flow-scripts
```

Checkout the version matching your OpenROAD binary:
```bash
git checkout 26Q1
```

> **Important:** Always match the ORFS version tag with your OpenROAD binary.
> Mismatched versions cause errors like:
> `invalid command name "sta::endpoint_count"`

## Step 8 - Set Environment Variables

Run inside the container for every new session:
```bash
source /root/oss-cad-suite/environment
export OPENROAD_EXE=$(command -v openroad)
export YOSYS_EXE=$(command -v yosys)
```

> **Note:** These variables reset every time you start a new container session.
> Use `docker commit` (Step 10) or add them to `~/.bashrc` to make permanent.

## Step 9 — Install Remaining Dependencies
```bash
apt-get install -y make time python3-pip
pip3 install pyyaml
```

## Step 10 — Run Example Design
```bash
cd /OpenROAD-flow-scripts/flow
make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk
```

This runs the full RTL-to-GDSII flow on the `nangate45/gcd` example.
It will take 10-20 minutes. Output files will be in:

- `flow/logs/nangate45/gcd/base/` — log files for each stage
- `flow/reports/nangate45/gcd/base/` — timing and design reports
- `flow/results/nangate45/gcd/base/` — result files including `6_final.*`

## Step 11 — Persist Your Container (Optional)

To save your setup so you don't repeat installation next time
(run in **powershell**):
```powershell
docker commit  openroad-windows:latest
```

Next time, start directly with:
```powershell
docker run -it openroad-windows:latest
```

## Common Issues

- Yosys version too old: Use OSS CAD Suite (Step 5)
- `apt-get` timezone prompt: Set `DEBIAN_FRONTEND=noninteractive` (Step 3)
- Environment variables lost: Re-run Step 8 every new session or add to `~/.bashrc`
- Version mismatch errors: Run `git checkout 26Q1` after cloning (Step 7)
- Slow Docker performance: Use WSL path `\\wsl$\Ubuntu\` instead of `C:\`
- Disk space full on C: drive: Move WSL to another drive using `wsl --export / wsl --import` 
- GUI not working: Use `docker run -it -e DISPLAY=<YOUR_IP>:0.0 openroad/orfs` 
- CRLF line ending errors:  Run `git config --global core.autocrlf false` (Step 6) 

## Optional: WSL2 Native Build

For better performance, you can install OpenROAD natively on WSL2
without Docker. See: [BuildWithWSL.md](BuildWithWSL.md)
