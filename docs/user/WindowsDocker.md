# Build OpenROAD on Windows Using Docker

## Prerequisites

* Windows 10 (version 2004+) or Windows 11
* Docker Desktop (WSL2 backend enabled)
* At least 16GB RAM (8GB minimum usable)
* At least 50GB free disk space



## Step 1 — Install and Configure Docker Desktop

1. Install Docker Desktop with WSL 2 backend enabled
2. Configure resources:

   * Memory: ≥ 8GB
   * CPUs: ≥ 4
3. Enable WSL Integration for Ubuntu-22.04

Verify installation:

```
docker run hello-world
```


## Step 2 — Avoid Timezone Prompt

Run before any apt-get:

```
export DEBIAN_FRONTEND=noninteractive
export TZ=UTC

apt-get update
apt-get install -y tzdata
```


## Step 3 — Install Correct Yosys Version

```
wget https://github.com/YosysHQ/oss-cad-suite-build/releases/latest/download/oss-cad-suite-linux-x64.tgz

tar -xzf oss-cad-suite-linux-x64.tgz

echo 'export PATH="$(pwd)/oss-cad-suite/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

yosys --version
```



## Step 4 — Fix Line Endings (CRLF Issue)

Run before cloning:

```
git config --global core.autocrlf false
git config --global core.eol lf

git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
```



## Step 5 — Copy Files into Docker

Option A:

```
docker ps
docker cp C:\path\to\file <container_id>:/tmp/
```

Option B (recommended):

```
docker run -it -v //c/Users/YourName/OpenROAD-flow-scripts:/OpenROAD-flow-scripts ubuntu:22.04
```

## Step 6 — Persist Environment

Save PATH:

```
echo 'export PATH="$(pwd)/oss-cad-suite/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Save container:

```
docker commit <container_id> openroad-windows:latest
docker run -it openroad-windows:latest
```

---

## Step 7 — Run Example Design

```
cd /OpenROAD-flow-scripts/flow
make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk
```



## Common Issues

Yosys too old:
Use OSS CAD Suite (Step 3)

apt-get stuck:

```
export DEBIAN_FRONTEND=noninteractive
```

GUI not working:

```
docker run -it -e DISPLAY=<YOUR_IP>:0.0 openroad/orfs
```

Slow performance:
Use WSL path:
\\wsl$\Ubuntu\

Disk space fix:

```
wsl --export Ubuntu-22.04 D:\ubuntu_backup.tar
wsl --import Ubuntu-22.04 D:\WSL\Ubuntu D:\ubuntu_backup.tar
```

CRLF issue:

```
git config --global core.autocrlf false
```



## Optional: WSL2 Native Build

See: BuildWithWSL.md in repository
