#!/bin/bash
# Copyright (c) 2024 Antmicro <www.antmicro.com>
# SPDX-License-Identifier: Apache-2.0

export DEBIAN_FRONTEND=noninteractive

# Klayout
export KLAYOUT_VER=${KLAYOUT_VER:-0.28.17-1}
apt-get -qqy update
apt-get install -qqy --no-install-recommends git wget ca-certificates make time

update-ca-certificates
wget https://www.klayout.org/downloads/Ubuntu-22/klayout_${KLAYOUT_VER}_amd64.deb
apt-get install -qqy --no-install-recommends ./klayout_${KLAYOUT_VER}_amd64.deb
rm -rf ./klayout_${KLAYOUT_VER}_amd64.deb

# Yosys
apt-get install -y --no-install-recommends gperf build-essential bison flex libreadline-dev gawk tcl-dev libffi-dev git graphviz xdot pkg-config python2 python3 python-is-python3 libboost-system-dev libboost-python-dev libboost-filesystem-dev zlib1g-dev

git clone https://github.com/YosysHQ/yosys.git
cd yosys
mkdir build
make -f Makefile config-$CC
make -f Makefile -j12
make -f install
rm -rf build
cd ..

# OpenROAD binary
wget https://github.com/Precision-Innovations/OpenROAD/releases/download/2024-03-25/openroad_2.0_amd64-ubuntu22.04-2024-03-25.deb
apt-get install -qqy --no-install-recommends ./openroad_2.0_amd64-ubuntu22.04-2024-03-25.deb
rm -rf ./openroad_2.0_amd64-ubuntu22.04-2024-03-25.deb

# OpenROAD flow scripts
cd ~
git clone https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git

apt-get clean
apt-get autoclean
