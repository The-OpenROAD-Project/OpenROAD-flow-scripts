#!/bin/bash
# Copyright (c) 2024 Antmicro <www.antmicro.com>
# SPDX-License-Identifier: Apache-2.0

# Update theme and wallpaper
git clone https://github.com/lxqt/lxqt-themes.git
cp -rf lxqt-themes/themes/* /usr/share/lxqt/themes/
mkdir -p /usr/share/lxqt/wallpapers
cp -f lxqt-themes/wallpapers/kde-plasma.png /usr/share/lxqt/wallpapers/kde-plasma.png
rm -rf lxqt-themes

# Patch config
cp -rf /usr/local/bin/lxqt-config/.config ~/
