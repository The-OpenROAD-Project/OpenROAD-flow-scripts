#!/usr/bin/env bash

set -euo pipefail

# Make sure we are on the correct folder before beginning
if [[ "$OSTYPE" == "darwin"* ]]; then
    cd "$(dirname $(perl -e 'use Cwd "abs_path";print abs_path(shift)' $0))/../"
else
    cd "$(dirname $(readlink -f $0))/../"
fi

# package versions
klayoutVersion=0.28.8

_versionCompare() {
    local a b IFS=. ; set -f
    printf -v a %08d $1; printf -v b %08d $3
    test $a "$2" $b
}

_installORDependencies() {
    ./tools/OpenROAD/etc/DependencyInstaller.sh ${OR_INSTALLER_ARGS}
}

_installCommon() {
    if [[ -f /opt/rh/rh-python38/enable ]]; then
        set +u
        source /opt/rh/rh-python38/enable
        set -u
    fi
    local pkgs="pandas numpy firebase_admin click pyyaml"
    if [[ $(id -u) == 0 ]]; then
        pip3 install -U $pkgs
    else
        pip3 install --user -U $pkgs
    fi
}

_installCentosCleanUp() {
    yum clean -y all
    rm -rf /var/lib/apt/lists/*
}

_installCentosPackages() {
    yum update -y
    yum install -y \
        time \
        ruby \
        ruby-devel

    if ! [ -x "$(command -v klayout)" ]; then
      yum install -y https://www.klayout.org/downloads/CentOS_7/klayout-${klayoutVersion}-0.x86_64.rpm
    else
      currentVersion=$(klayout -v | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
      if _versionCompare $currentVersion -ge $klayoutVersion; then
        echo "KLayout version greater than or equal to ${klayoutVersion}"
      else
        echo "KLayout version less than ${klayoutVersion}"
        sudo yum remove -y klayout
        yum install -y https://www.klayout.org/downloads/CentOS_7/klayout-${klayoutVersion}-0.x86_64.rpm
      fi
    fi
}

_installUbuntuCleanUp() {
    apt-get autoclean -y
    apt-get autoremove -y
}

_installUbuntuPackages() {
    export DEBIAN_FRONTEND="noninteractive"
    apt-get -y update
    apt-get -y install \
        libqt5multimediawidgets5 \
        libqt5svg5-dev \
        libqt5xmlpatterns5-dev \
        libz-dev \
        python3-pip \
        qtmultimedia5-dev \
        qttools5-dev \
        ruby \
        ruby-dev \
        time

    # install KLayout
    if _versionCompare $1 -ge 23.04; then
        apt-get install klayout python3-pandas
    else
        if [[ $1 == 20.04 ]]; then
            klayoutChecksum=15a26f74cf396d8a10b7985ed70ab135
        else
            klayoutChecksum=db751264399706a23d20455bb7624264
        fi
        lastDir="$(pwd)"
        # temp dir to download and compile
        baseDir=/tmp/installers
        mkdir -p "${baseDir}"
        cd ${baseDir}
        wget https://www.klayout.org/downloads/Ubuntu-${1%.*}/klayout_${klayoutVersion}-1_amd64.deb
        md5sum -c <(echo "${klayoutChecksum} klayout_${klayoutVersion}-1_amd64.deb") || exit 1
        dpkg -i klayout_${klayoutVersion}-1_amd64.deb
        cd ${lastDir}
        rm -rf "${baseDir}"
    fi
}

_installDarwinPackages() {
    brew install libffi tcl-tk ruby
    brew install python libomp
    brew link --force libomp
    brew install --cask klayout
}

_help() {
    cat <<EOF

All arguments and flags are only applicable for OpenROAD dependencies
Usage: $0
                                # Installs all of OpenROAD's dependencies no
                                #     need to run -base or -common. Requires
                                #     privileged access.
                                #
       $0 -base
                                # Installs OpenROAD's dependencies using
                                #     package managers (-common must be
                                #     executed in another command).
       $0 -common
                                # Installs OpenROAD's common dependencies
                                #     (-base must be executed in another
                                #     command).
       $0 -prefix=DIR
                                # Installs common dependencies in an existing
                                #     user-specified directory. Only used
                                #     with -common. This flag cannot be used
                                #     with sudo or with root access.
       $0 -local
                                # Installs common dependencies in
                                #    "$HOME/.local". Only used with
                                #    -common. This flag cannot be used with
                                #    sudo or with root access.
EOF
    exit "${1:-1}"
}

# default args
OR_INSTALLER_ARGS="-eqy"
# default prefix
PREFIX=""
# default option
option="all"
# default isLocal
isLocal="false"

# default values, can be overwritten by cmdline args
while [ "$#" -gt 0 ]; do
    case "${1}" in
        -h|-help)
            _help 0
            ;;
        -base)
            OR_INSTALLER_ARGS="${OR_INSTALLER_ARGS} -base"
            if [[ "${option}" != "all" ]]; then
                echo "WARNING: previous argument -${option} will be overwritten with -base." >&2
            fi
            option="base"
            ;;
        -common)
            OR_INSTALLER_ARGS="${OR_INSTALLER_ARGS} -common"
            if [[ "${option}" != "all" ]]; then
                echo "WARNING: previous argument -${option} will be overwritten with -common." >&2
            fi
            option="common"
            ;;
        -local)
            OR_INSTALLER_ARGS="${OR_INSTALLER_ARGS} -local"
            ;;
        -prefix=*)
            OR_INSTALLER_ARGS="${OR_INSTALLER_ARGS} $1"
            ;;
        *)
            echo "unknown option: ${1}" >&2
            _help
            ;;
    esac
    shift 1
done

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
        if [[ $(id -u) == 0 ]]; then>&2
            echo "ERROR: cannot install on macOS if you are root or using sudo  (not recommended for brew)." >&2
            exit 1
        fi
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
        if [[ "${option}" == "base" || "${option}" == "all" ]]; then
            _installCentosPackages
            _installCentosCleanUp
        fi
        if [[ "${option}" == "common" || "${option}" == "all" ]]; then
            _installCommon
        fi
        ;;
    "Ubuntu" )
        version=$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release | sed 's/"//g')
        _installORDependencies
        if [[ "${option}" == "base" || "${option}" == "all" ]]; then
            _installUbuntuPackages "${version}"
            _installUbuntuCleanUp
        fi
        if [[ "${option}" == "common" || "${option}" == "all" ]]; then
            if _versionCompare ${version} -lt 23.04 ; then
                _installCommon
            fi
        fi
        ;;
    "Darwin" )
        _installORDependencies
        if [[ "${option}" == "base" || "${option}" == "all" ]]; then
            _installDarwinPackages
        fi
        if [[ "${option}" == "common" || "${option}" == "all" ]]; then
            _installCommon
        fi
        ;;
    *)
        echo "unsupported system: ${os}" >&2
        _help
        ;;
esac
