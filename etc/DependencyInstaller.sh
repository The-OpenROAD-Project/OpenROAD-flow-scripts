#!/bin/bash

set -euo pipefail

_installORDependencies() {
    # how to count for relative path
    ../tools/OpenROAD/etc/DependencyInstaller.sh -dev
}

_installCommon() {
    lastDir="$(pwd)"

    # install pandas
    pip3 install --user pandas

    # temp dir to download and compile
    baseDir=/tmp/installers
    mkdir -p "${baseDir}"
    
    # install KLayout
    klayoutVersion=0.28
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
        python3-pip
}

_installDebianCleanUp() {
    apt-get autoclean -y
    apt-get autoremove -y
}

_installDebianPackages() {
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
        python3-pip
}

_installRHELCleanUp() {
    yum clean -y all
    rm -rf /var/lib/apt/lists/*
}

_installRHELPackages() {
    yum update -y
    yum install -y \
        libffi-devel \
        tcl \
        time \
        ruby \
        ruby-devel
}

_installDarwinPackages() {
    brew install libffi tcl-tk ruby
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
        _installCommon
        _installCentosCleanUp
        ;;
    "Ubuntu" )
        _installORDependencies
        _installUbuntuPackages
        _installCommon
        _installUbuntuCleanUp
        ;;
    "Red Hat Enterprise Linux")
        _installORDependencies
        _installRHELPackages
        _installCommon
        _installRHELCleanUp
        ;;
    "Debian GNU/Linux" )
        _installORDependencies
        _installDebianPackages
        _installCommon
        _installDebianCleanUp
        ;;
    "Darwin" )
        _installDarwinPackages
        _installCommon
        ;;
    *)
        echo "unsupported system: ${os}" >&2
        echo "supported systems are CentOS 7, Ubuntu 20.04, Ubuntu 22.04, RHEL 8, Debian 10 and Debian 11" >&2
        _help
        ;;
esac