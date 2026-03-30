# Build OpenROAD on Windows Using Docker

## Prerequisites

* Windows 10 (version 2004+) or Windows 11
* Docker Desktop (WSL2 backend enabled)
* At least 16GB RAM (8GB minimum usable)
* At least 50GB free disk space
* VS Code (optional, recommended)

## Step 1 — Install and Configure Docker Desktop

> Run in PowerShell (Administrator)

1. Install Docker Desktop with WSL2:
   [https://docs.docker.com/desktop/windows/wsl/](https://docs.docker.com/desktop/windows/wsl/)

2. Configure resources:
   * Memory: ≥ 8GB
   * CPUs: ≥ 4

3. Enable WSL Integration:
   Docker Desktop → Settings → Resources → WSL Integration → Enable Ubuntu-22.04

Verify installation:

```bash
docker run --rm hello-world
```

## Step 2 — Avoid Timezone Prompt

> Run inside Docker container

```bash
export DEBIAN_FRONTEND=noninteractive
export TZ=UTC
apt-get update
apt-get install -y tzdata
```

## Step 3 — Install Correct Yosys Version

> Run inside Docker container

```bash
wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2025-03-01/oss-cad-suite-linux-x64.tgz
tar -xzf oss-cad-suite-linux-x64.tgz
echo 'export PATH="$(pwd)/oss-cad-suite/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
yosys --version
```

## Step 4 — Fix Line Endings (CRLF Issue)

> Run in PowerShell

```bash
git config --global core.autocrlf false
git config --global core.eol lf
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
```

## Step 5 — Copy Files into Docker

### Option A: Copy files

> Run in PowerShell

```bash
docker ps
docker cp C:\path\to\file <container_id>:/tmp/
```

### Option B (Recommended): Mount volume

> Run in PowerShell

```bash
docker run -it -v //c/Users/YourName/OpenROAD-flow-scripts:/OpenROAD-flow-scripts ubuntu:22.04
```

## Step 6 — Persist Environment

> Run inside Docker container

```bash
echo 'export PATH="$(pwd)/oss-cad-suite/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
docker commit <container_id> openroad-windows:latest
docker run -it openroad-windows:latest
```

## Step 7 — Run Example Design

> Run inside Docker container

```bash
cd /OpenROAD-flow-scripts/flow
make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk
```

## Step 8 — VS Code Integration

### Beginner: Attach to Running Container

1. Install VS Code: [https://code.visualstudio.com/](https://code.visualstudio.com/)
2. Install Dev Containers extension
3. Run container:

```bash
docker run -it -v //c/Users/YourName/OpenROAD-flow-scripts:/OpenROAD-flow-scripts openroad-windows:latest
```

4. In VS Code press `Ctrl+Shift+P` → Select "Attach to Running Container" → Choose your container

### Intermediate: Open Folder in Container

Press `Ctrl+Shift+P` → "Dev Containers: Open Folder in Container" → Choose your project folder

### Advanced: DevContainer Setup

Create `.devcontainer/devcontainer.json`:

```json
{
  "name": "OpenROAD Development",
  "image": "openroad/orfs:latest",
  "workspaceMount": "source=${localWorkspaceFolder},target=/OpenROAD-flow-scripts,type=bind",
  "workspaceFolder": "/OpenROAD-flow-scripts",
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-vscode.cpptools-extension-pack",
        "twxs.cmake"
      ]
    }
  },
  "remoteUser": "root"
}
```

Press `Ctrl+Shift+P` → "Dev Containers: Reopen in Container"

## Common Issues

### Yosys too old

Use OSS CAD Suite (Step 3)

### apt-get stuck

```bash
export DEBIAN_FRONTEND=noninteractive
```

### GUI not working

```bash
docker run -it -e DISPLAY=<YOUR_IP>:0.0 openroad/orfs
```

### Slow performance

Use WSL path: `\\wsl$\Ubuntu\`

### Disk space fix

```bash
wsl --export Ubuntu-22.04 D:\ubuntu_backup.tar
wsl --import Ubuntu-22.04 D:\WSL\Ubuntu D:\ubuntu_backup.tar
```

### VS Code not connecting

* Ensure Docker Desktop is running
* Restart VS Code
* Check Dev Containers extension is installed

## Optional: WSL2 Native Build

See: [BuildWithWSL.md](BuildWithWSL.md).