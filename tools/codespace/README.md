# GitHub Codespace with OpenROAD GUI

The goal is to provide a web browser experience of the OpenROAD GUI. Solution works with Firefox and Chrome.

## Creating a Codespace

First time Codespace users are encouraged to read the tutorial [creating a codespace for a repository](https://docs.github.com/en/codespaces/developing-in-a-codespace/creating-a-codespace-for-a-repository)

1. Create a codespace from this repository

![create](../../docs/images/create_codespace.gif)

2. Select `Default Project Configuration` in the `Dev container configuration` field

![configure](../../docs/images/configure_codespace.gif)

3. Click "Create codespace" and after a few minutes, the codespace should be ready for use

## Using the Codespace

### OpenROAD GUI

At the bottom, there should be tab `PORTS`, where you will find the `Forwarded Address`. A link labelled `Desktop (6080)` is provided, which you can follow to open the OpenROAD GUI.

![open](../../docs/images/open_vnc.gif)

Test that the ORFS flow works by running the following commands:

```
cd /OpenROAD-flow-scripts/flow
source ../env.sh
make
make gui_final
```

### VSCode

1. You can also use VSCode to connect to Codespaces
2. [Install VSCode](https://code.visualstudio.com/docs/setup/setup-overview)
3. Open VSCode and install the [GitHub Codespaces](https://marketplace.visualstudio.com/items?itemName=GitHub.codespaces) extension
4. Press `Ctrl+Shift+P` and select `Codespaces:Connect to Codespace`
5. Open a web browser and connect to url: `localhost:6080`

### Useful scripts

User can use:
* `/usr/local/bin/set-resolution` - change the resolution
* `/usr/local/share/desktop-init.sh` - desktop (GUI, VNC, etc.) initialization
* `./tools/codespace/kill.sh` - script to terminate all processes related to vnc. If you want to restart the vnc environment, first kill processes, then re-launch by executing `/usr/local/share/desktop-init.sh`

In docker build, scripts are used:
* `patch-lxqt-config.sh` - set the GUI configuration
* `patch-novnc-ui.sh` - set remote resizing and skip login panel
* `install-*` - a group of scripts to install dependencies (Yosys, ORFS, etc.)

## Developer

ORFS docker images is now built with available binaries. In CI configuration, you will find steps to reproduce the required docker images.

Useful resources:
* [Development loop](https://code.visualstudio.com/docs/devcontainers/create-dev-container#_full-configuration-edit-loop)
* [devcontainer JSON reference](https://containers.dev/implementors/json_reference/)
* [Desktop lite feature](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/desktop-lite.md)

### Desktop-lite feature

The desktop-lite feature was originally provided by the [devcontainers organization](https://github.com/devcontainers/features/tree/main/src/desktop-lite). In this flow, the scripts were heavily modified, c.f. `install-desktop.sh`.
