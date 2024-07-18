#!/bin/bash
# Copyright (c) 2024 Antmicro <www.antmicro.com>
# SPDX-License-Identifier: Apache-2.0

# Change remote scaling
sed -i 's/UI.initSetting('\''resize'\''\, '\''off'\'')/UI.initSetting('\''resize'\''\, '\''remote'\'')/' /usr/local/novnc/noVNC*/app/ui.js

# Change autoconnect to skip login panel
sed -i 's/WebUtil.getConfigVar('\''autoconnect'\'', false)/WebUtil\.getConfigVar('\''autoconnect'\'', true)/' /usr/local/novnc/noVNC*/app/ui.js
