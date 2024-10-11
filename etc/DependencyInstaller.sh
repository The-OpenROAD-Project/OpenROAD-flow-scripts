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
verilatorVersion=5.026

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
        pip3 install --no-cache-dir -U $pkgs
    else
        pip3 install --no-cache-dir --user -U $pkgs
    fi

    if [[ "$constantBuildDir" == "true" ]]; then
        baseDir="/tmp/DependencyInstaller-ORFS"
        if [[ -d "$baseDir" ]]; then
            echo "[INFO] Removing old building directory $baseDir"
        fi
        mkdir -p "$baseDir"
    else
        baseDir=$(mktemp -d /tmp/DependencyInstaller-orfs-XXXXXX)
    fi

    # Install Verilator
    verilatorPrefix=`realpath ${PREFIX:-"/usr/local"}`
    if [[ ! -x ${verilatorPrefix}/bin/verilator ]]; then
        pushd $baseDir
            git clone --depth=1 -b "v$verilatorVersion" https://github.com/verilator/verilator.git
            pushd verilator
                autoconf
                ./configure --prefix "${verilatorPrefix}"
                make -j`nproc`
                make install
            popd
            rm -r verilator
        popd
    fi
}

_installCentosCleanUp() {
    yum clean -y all
    rm -rf /var/lib/apt/lists/*
}

_installCentosPackages() {
    yum -y update
    yum -y install \
        time \
        ruby \
        ruby-devel

    if ! [ -x "$(command -v klayout)" ]; then
      yum -y install https://www.klayout.org/downloads/CentOS_7/klayout-${klayoutVersion}-0.x86_64.rpm
    else
      currentVersion=$(klayout -v | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
      if _versionCompare $currentVersion -ge $klayoutVersion; then
        echo "KLayout version greater than or equal to ${klayoutVersion}"
      else
        echo "KLayout version less than ${klayoutVersion}"
        sudo yum remove -y klayout
        yum -y install https://www.klayout.org/downloads/CentOS_7/klayout-${klayoutVersion}-0.x86_64.rpm
      fi
    fi
}

_installUbuntuCleanUp() {
    apt-get autoclean -y
    apt-get autoremove -y
}

_installKlayoutDependenciesUbuntuAarch64() {
    echo "Installing Klayout dependancies"
    export DEBIAN_FRONTEND=noninteractive
    apt-get -y update
    apt-get -y install  build-essential \
                        qtbase5-dev qttools5-dev libqt5xmlpatterns5-dev qtmultimedia5-dev libqt5multimediawidgets5 libqt5svg5-dev \
                        ruby ruby-dev \
                        python3 python3-dev \
                        libz-dev\
                        libgit2-dev
    echo "All dependencies installed successfully"
}

_installUbuntuPackages() {
    export DEBIAN_FRONTEND="noninteractive"
    apt-get -y update
    apt-get -y install --no-install-recommends \
        bison \
        curl \
        flex \
        help2man \
        libfl-dev \
        libfl2 \
        libgoogle-perftools-dev \
        libqt5multimediawidgets5 \
        libqt5opengl5 \
        libqt5svg5-dev \
        libqt5xmlpatterns5-dev \
        libz-dev \
        perl \
        python3-pip \
        python3-venv \
        qtmultimedia5-dev \
        qttools5-dev \
        ruby \
        ruby-dev \
        time \
        zlib1g \
        zlib1g-dev

    # install KLayout
    if  [[ $1 == "rodete" ]]; then
        apt-get -y install --no-install-recommends klayout python3-pandas
    elif _versionCompare "$1" -ge 23.04; then
        apt-get -y install --no-install-recommends klayout python3-pandas
    else
        arch=$(uname -m)
        lastDir="$(pwd)"
        # temp dir to download and compile
        baseDir=/tmp/installers
        klayoutPrefix=${PREFIX:-"/usr/local"}
        mkdir -p "${baseDir}"
        cd "${baseDir}"
        if [[ $arch == "aarch64" ]]; then
            if [ ! -f ${klayoutPrefix}/klayout ]; then
                _installKlayoutDependenciesUbuntuAarch64
                echo "Installing KLayout for aarch64 architecture"
                git clone https://github.com/KLayout/klayout.git
                cd klayout
                ./build.sh -bin "${klayoutPrefix}"
            else
                echo "Klayout is already installed"
        fi
        else
            if [[ $1 == 20.04 ]]; then
                klayoutChecksum=15a26f74cf396d8a10b7985ed70ab135
            else
                klayoutChecksum=db751264399706a23d20455bb7624264
            fi
            wget https://www.klayout.org/downloads/Ubuntu-${1%.*}/klayout_${klayoutVersion}-1_amd64.deb
            md5sum -c <(echo "${klayoutChecksum} klayout_${klayoutVersion}-1_amd64.deb") || exit 1
            dpkg -i klayout_${klayoutVersion}-1_amd64.deb
        fi
        cd "${lastDir}"
        rm -rf "${baseDir}"
    fi

    if command -v docker &> /dev/null; then
        # The user can uninstall docker if they want to reinstall it,
        # and also this allows the user to choose drop in replacements
        # for docker, such as podman-docker
        echo "Docker is already installed, skip docker reinstall."
        return 0
    fi

    # Add Docker's official GPG key:
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get -y update
    if [[ $1 != "rodete" ]]; then
        apt-get -y install --no-install-recommends \
            docker-ce \
            docker-ce-cli \
            containerd.io \
            docker-buildx-plugin
    fi
}

_installDarwinPackages() {
    brew install libffi tcl-tk ruby
    brew install python libomp
    brew link --force libomp
    brew install --cask klayout
    brew install docker docker-buildx
}

_installCI() {
    apt-get -y update
    apt-get -y install --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        coreutils \
        curl \
        python3 \
        software-properties-common
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
       $0 -ci
                                # Installs CI tools
       $0 -constant-build-dir
                                #  Use constant build directory, instead of
                                #    random one.
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
constantBuildDir="false"
CI="no"

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
        -ci)
            CI="yes"
            OR_INSTALLER_ARGS="${OR_INSTALLER_ARGS} -save-deps-prefixes=/etc/openroad_deps_prefixes.txt"
            ;;
        -prefix=*)
            OR_INSTALLER_ARGS="${OR_INSTALLER_ARGS} $1"
            PREFIX=${1#*=}
            ;;
        -constant-build-dir)
            OR_INSTALLER_ARGS="${OR_INSTALLER_ARGS} $1"
            constantBuildDir="true"
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
        if [[ ${CI} == "yes" ]]; then
            echo "WARNING: Installing CI dependencies is only supported on Ubuntu 22.04" >&2
        fi
        _installORDependencies
        if [[ "${option}" == "base" || "${option}" == "all" ]]; then
            _installCentosPackages
            _installCentosCleanUp
        fi
        if [[ "${option}" == "common" || "${option}" == "all" ]]; then
            _installCommon
        fi
        ;;
    "Ubuntu" | "Debian GNU/Linux rodete" )
        version=$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release | sed 's/"//g')
        if [[ -z ${version} ]]; then
            version=$(awk -F= '/^VERSION_CODENAME/{print $2}' /etc/os-release | sed 's/"//g')
        fi
        if [[ ${CI} == "yes" ]]; then
            echo "Installing CI Tools"
            _installCI
        fi
        _installORDependencies
        if [[ "${option}" == "base" || "${option}" == "all" ]]; then
            _installUbuntuPackages "${version}"
            _installUbuntuCleanUp
        fi
        if [[ "${option}" == "common" || "${option}" == "all" ]]; then
            if [[ $version == "rodete" ]]; then
                echo "Skip common for rodete"
            elif _versionCompare ${version} -lt 23.04 ; then
                _installCommon
            fi
        fi
        ;;
    "Darwin" )
        if [[ ${CI} == "yes" ]]; then
            echo "WARNING: Installing CI dependencies is only supported on Ubuntu 22.04" >&2
        fi
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
