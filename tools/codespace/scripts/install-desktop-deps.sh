#!/bin/bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Copyright (c) 2024 Antmicro <www.antmicro.com>
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Docs: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/desktop-lite.md
# Maintainer: The VS Code and Codespaces Teams

. common.sh

package_list="
    tigervnc-standalone-server \
    tigervnc-common \
    dbus-x11 \
    x11-utils \
    x11-xserver-utils \
    xdg-utils \
    fbautostart \
    at-spi2-core \
    xterm \
    eterm \
    nautilus\
    mousepad \
    seahorse \
    gnome-keyring \
    libx11-dev \
    libxkbfile-dev \
    libsecret-1-dev \
    libgbm-dev \
    libnotify4 \
    libnss3 \
    libxss1 \
    libasound2 \
    htop \
    ncdu \
    curl \
    ca-certificates\
    unzip \
    locales \
    xfwm4 \
    lxqt \
    "

# Packages to attempt to install if essential tools are missing (ie: vncpasswd).
# This is useful, at least, for Ubuntu 22.04 (jammy)
package_list_additional="
    tigervnc-tools"

set -e

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

apt_get_update
check_packages ${package_list}

# On newer versions of Ubuntu (22.04),
# we need an additional package that isn't provided in earlier versions
if ! type vncpasswd > /dev/null 2>&1; then
    check_packages ${package_list_additional}
fi
