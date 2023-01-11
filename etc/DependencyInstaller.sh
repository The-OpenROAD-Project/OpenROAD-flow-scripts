#!/bin/bash

set -euo pipefail

# Make sure we are on the correct folder before beginning
cd "$(dirname $(readlink -f $0))/../"

_installORDependencies() {
    ./tools/OpenROAD/etc/DependencyInstaller.sh
}

_installCommon() {
    # install pandas
    pip3 install -U --user pandas
}

_installCentosCleanUp() {
    yum clean -y all
    rm -rf /var/lib/apt/lists/*
}

_installCentosPackages() {
    yum update -y
    yum install -y \
        libffi-devel \
        tcl \
        time \
        ruby \
        ruby-devel \
        tcl-devel 

    yum install -y https://www.klayout.org/downloads/CentOS_7/klayout-0.27.10-0.x86_64.rpm
}

_installUbuntuCleanUp() {
    apt-get autoclean -y
    apt-get autoremove -y
}

_installUbuntuPackages() {
    export DEBIAN_FRONTEND="noninteractive"
    apt-get -y update
    apt-get -y install \
        libffi-dev \
        tcl \
        tcl-dev \
        time \
        ruby \
        ruby-dev \
        libz-dev \
        python3-pip \
        qttools5-dev \
        libqt5xmlpatterns5-dev \
        qtmultimedia5-dev \
        libqt5multimediawidgets5 \
        libqt5svg5-dev

    lastDir="$(pwd)"

    # temp dir to download and compile
    baseDir=/tmp/installers
    mkdir -p "${baseDir}"
    cd ${baseDir}

    # install KLayout
    klayoutVersion=0.27.10
    if [[ $1 == 20.04 ]]; then
        klayoutChecksum=8076dadfb1b790b75d284fdc9c90f70b
    else
        klayoutChecksum=2fb355f0e19d69be8535722185f983cc
    fi
    wget https://www.klayout.org/downloads/Ubuntu-${1%.*}/klayout_${klayoutVersion}-1_amd64.deb
    md5sum -c <(echo "${klayoutChecksum} klayout_${klayoutVersion}-1_amd64.deb") || exit 1
    dpkg -i klayout_${klayoutVersion}-1_amd64.deb

    cd ${lastDir}
    rm -rf "${baseDir}"
}

_installDarwinPackages() {
    brew install libffi tcl-tk ruby
    brew install python libomp
    brew link --force libomp
    brew install --cask klayout
}

platform="$(uname -s)"
case "${platform}" in
    "Linux" )
        if [[ -f /etc/os-release ]]; then
            os=$(awk -F= '/^NAME/{print $2}' /etc/os-release | sed 's/"//g')
        else
            os="Unidentified OS, could not find /etc/os-release."
        fi
        ;;
    "Darwin" )
        os="Darwin"
        ;;
    *)
        echo "${platform} is not supported" >&2
        _help
        ;;
esac

case "${os}" in
    "CentOS Linux" )
        _installORDependencies
        _installCentosPackages
        _installCommon
        _installCentosCleanUp
        ;;
    "Ubuntu" )
        version=$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release | sed 's/"//g')
        _installORDependencies
        _installUbuntuPackages "${version}"
        _installCommon
        _installUbuntuCleanUp
        ;;
    "Darwin" )
        _installORDependencies
        _installDarwinPackages
        _installCommon
        ;;
    *)
        echo "unsupported system: ${os}" >&2
        _help
        ;;
esac