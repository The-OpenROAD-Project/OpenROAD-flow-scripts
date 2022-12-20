#!/bin/bash

set -euo pipefail

# Make sure we are on the correct folder before beginning
cd "$(dirname $(readlink -f $0))/../"

_installORDependencies() {
    ./tools/OpenROAD/etc/DependencyInstaller.sh -dev
}

_installCommon() {
    lastDir="$(pwd)"

    # install pandas
    pip3 install --user pandas

    # temp dir to download and compile
    baseDir=/tmp/installers
    mkdir -p "${baseDir}"
    
    # install KLayout
    klayoutVersion=0.27.10
    klayoutChecksum=ff4fb9c597d0e3d7f6dfb49d40d2d167
    if [[ -z $(command -v klayout) ]]; then
        cd "${baseDir}"
        wget https://www.klayout.org/downloads/source/klayout-${klayoutVersion}.tar.gz
        md5sum -c <(echo "${klayoutChecksum}  klayout-${klayoutVersion}.tar.gz") || exit 1
        tar hzxvf klayout-${klayoutVersion}.tar.gz
        cd klayout-${klayoutVersion}
        echo $(pwd)
        ./build.sh -without-qtbinding
    fi

    cd "$lastDir"
    rm -rf "${baseDir}"
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

    pip3 install --user pandas
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

    # install pandas
    pip3 install --user pandas

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
    brew install python
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py
    pip3 install --user pandas
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
        echo "We only officially support Linux at the moment." >&2
        _help
        ;;
esac

case "${os}" in
    "CentOS Linux" )
        _installORDependencies
        _installCentosPackages
        _installCentosCleanUp
        ;;
    "Ubuntu" )
        version=$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release | sed 's/"//g')
        _installORDependencies
        _installUbuntuPackages "${version}"
        _installUbuntuCleanUp
        ;;
    "Darwin" )
        _installORDependencies
        _installDarwinPackages
        ;;
    *)
        echo "unsupported system: ${os}" >&2
        echo "supported systems are CentOS 7, Ubuntu 20.04, Ubuntu 22.04, RHEL 8, Debian 10 and Debian 11" >&2
        _help
        ;;
esac