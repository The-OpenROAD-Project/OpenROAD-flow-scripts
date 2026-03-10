#!/usr/bin/env bash

set -euo pipefail

# Make sure we are on the correct folder before beginning
if [[ "$OSTYPE" == "darwin"* ]]; then
    cd "$(dirname $(perl -e 'use Cwd "abs_path";print abs_path(shift)' $0))/../"
else
    cd "$(dirname $(readlink -f $0))/../"
fi

# package versions
klayoutVersion=0.30.3
numThreads=$(nproc)

_versionCompare() {
    local a b IFS=. ; set -f
    printf -v a %08d $1; printf -v b %08d $3
    test $a "$2" $b
}

_installORDependencies() {
    if [[ ${YOSYS_VER} == "" ]]; then
        YOSYS_VER=v$(grep 'yosys_ver =' tools/yosys/docs/source/conf.py | awk -F'"' '{print $2}')
    fi
    ./tools/OpenROAD/etc/DependencyInstaller.sh ${OR_INSTALLER_ARGS} -yosys-ver="${YOSYS_VER}"
}

# Install system packages for building Yosys/slang (via OR's -base),
# then build Yosys/eqy/sby directly, skipping OpenROAD-specific build
# dependencies (boost, swig, spdlog, eigen, or-tools, etc.) which Bazel
# manages.
_installBazelFlowDependencies() {
    if [[ ${YOSYS_VER} == "" ]]; then
        YOSYS_VER=v$(grep 'yosys_ver =' tools/yosys/docs/source/conf.py | awk -F'"' '{print $2}')
    fi
    # OR's -base installs system packages (build-essential, bison, flex,
    # tcl-dev, libreadline-dev, libffi-dev, pkg-config, python3-dev, cmake,
    # etc.) needed for building Yosys and yosys-slang.
    if [[ "${option}" == "base" || "${option}" == "all" ]]; then
        ./tools/OpenROAD/etc/DependencyInstaller.sh -base
    fi
    # Build Yosys/eqy/sby without the full -common pass that would also
    # compile boost, swig, spdlog, eigen, gtest, or-tools, abseil, etc.
    if [[ "${option}" == "common" || "${option}" == "all" ]]; then
        local yosys_prefix=${PREFIX:-"/usr/local"}
        local buildDir
        buildDir=$(mktemp -d /tmp/orfs-yosys-build-XXXXXX)

        echo "Building Yosys ${YOSYS_VER} ..."
        (
            cd "${buildDir}"
            git clone --depth=1 -b "${YOSYS_VER}" --recursive https://github.com/YosysHQ/yosys
            cd yosys
            make -j "${numThreads}" PREFIX="${yosys_prefix}" ABC_ARCHFLAGS=-Wno-register
            make install PREFIX="${yosys_prefix}"
        )

        echo "Building eqy ${YOSYS_VER} ..."
        (
            cd "${buildDir}"
            git clone --depth=1 -b "${YOSYS_VER}" https://github.com/YosysHQ/eqy
            cd eqy
            export PATH="${yosys_prefix}/bin:${PATH}"
            make -j "${numThreads}" PREFIX="${yosys_prefix}"
            make install PREFIX="${yosys_prefix}"
        )

        echo "Building sby ${YOSYS_VER} ..."
        (
            cd "${buildDir}"
            git clone --depth=1 -b "${YOSYS_VER}" --recursive https://github.com/YosysHQ/sby
            cd sby
            export PATH="${yosys_prefix}/bin:${PATH}"
            make -j "${numThreads}" PREFIX="${yosys_prefix}" install
        )

        rm -rf "${buildDir}"
    fi
}

_installPipCommon() {
    if [[ -f /opt/rh/rh-python38/enable ]]; then
        set +u
        source /opt/rh/rh-python38/enable
        set -u
    fi
    local pkgs="pandas numpy firebase_admin click pyyaml yamlfix"
    if [[ $(id -u) == 0 ]]; then
        pip3 install --no-cache-dir -U $pkgs
    else
        pip3 install --no-cache-dir --user -U $pkgs
    fi
}

# Enterprise Linux 7 cleanup
_install_EL7_CleanUp() {
    yum clean -y all
    rm -rf /var/lib/apt/lists/*
}

# Enterprise Linux 7 package installation (EL7 = RHEL 7 or CentOS 7)
_install_EL7_Packages() {
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


# Enterprise Linux 8/9 cleanup
_install_EL8_EL9_CleanUp() {
    dnf clean -y all
    rm -rf /var/lib/apt/lists/*
}

# Enterprise Linux 8/9 package installation (EL8/EL9 = RHEL, Rocky Linux, AlmaLinux, or CentOS 8 as no CentOS 9 exists)
_install_EL8_EL9_Packages() {
    # Re-detect EL version for appropriate KLayout package
    if [[ -f /etc/os-release ]]; then
        elVersion=$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release | sed 's/"//g' | cut -d. -f1)
    else
        echo "ERROR: Could not detect Enterprise Linux version"
        exit 1
    fi

    # EL8 and EL9 use `dnf`, instead of `yum`
    dnf -y update
    dnf -y install \
        time \
        ruby \
        ruby-devel

    # Install KLayout based on EL version, note the different URLs
    case "${elVersion}" in
        "8")
            if ! [ -x "$(command -v klayout)" ]; then
                dnf -y install https://www.klayout.org/downloads/CentOS_8/klayout-${klayoutVersion}-0.x86_64.rpm
            else
                currentVersion=$(klayout -v | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
                if _versionCompare "$currentVersion" -ge $klayoutVersion; then
                    echo "KLayout version greater than or equal to ${klayoutVersion}"
                else
                    echo "KLayout version less than ${klayoutVersion}"
                    sudo dnf remove -y klayout
                    dnf -y install https://www.klayout.org/downloads/CentOS_8/klayout-${klayoutVersion}-0.x86_64.rpm
                fi
            fi
            ;;
        "9")
            if ! [ -x "$(command -v klayout)" ]; then
                dnf -y install https://www.klayout.org/downloads/RockyLinux_9/klayout-${klayoutVersion}-0.x86_64.rpm
            else
                currentVersion=$(klayout -v | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
                if _versionCompare "$currentVersion" -ge $klayoutVersion; then
                    echo "KLayout version greater than or equal to ${klayoutVersion}"
                else
                    echo "KLayout version less than ${klayoutVersion}"
                    sudo dnf remove -y klayout
                    dnf -y install https://www.klayout.org/downloads/RockyLinux_9/klayout-${klayoutVersion}-0.x86_64.rpm
                fi
            fi
            ;;
        *)
            echo "ERROR: Unsupported Enterprise Linux version: ${elVersion}"
            exit 1
            ;;
    esac
}

_installUbuntuCleanUp() {
    apt-get autoclean -y
    apt-get autoremove -y
}

_installKlayoutDependenciesUbuntuAarch64() {
    echo "Installing Klayout dependencies"
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

    # Flow-level packages needed regardless of how OpenROAD is built
    apt-get -y install --no-install-recommends \
        curl \
        perl \
        python3-pip \
        python3-venv \
        ruby \
        ruby-dev \
        time

    if [[ "${BAZEL}" == "no" ]]; then
        # Additional packages only needed when building OpenROAD from source
        # (not with Bazel). OR's -base already installs core build tools
        # (build-essential, bison, flex, etc.). This list covers ORFS-specific
        # extras like KLayout Qt deps and profiling.
        apt-get -y install --no-install-recommends \
            bison \
            flex \
            help2man \
            libfl-dev \
            libfl2 \
            libgit2-dev \
            libgoogle-perftools-dev \
            libqt5multimediawidgets5 \
            libqt5opengl5 \
            libqt5svg5-dev \
            libqt5xmlpatterns5-dev \
            libz-dev \
            qtmultimedia5-dev \
            qttools5-dev \
            zlib1g \
            zlib1g-dev

        packages=()
        # Choose libstdc++ version
        if _versionCompare $1 -ge 25.04; then
            packages+=("libstdc++-15-dev")
        elif _versionCompare $1 -ge 24.04; then
            packages+=("libstdc++-14-dev")
        elif _versionCompare $1 -ge 22.10; then
            packages+=("libstdc++-12-dev")
        fi
        apt-get install -y --no-install-recommends ${packages[@]}
    fi

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
                git clone --depth=1 -b "v${klayoutVersion}" https://github.com/KLayout/klayout.git
                cd klayout
                ./build.sh -bin "${klayoutPrefix}" -option -j "${numThreads}"
            else
                echo "Klayout is already installed"
        fi
        else
            if [[ $1 == 20.04 ]]; then
                klayoutChecksum=e83be08033f2f69d83ab7bd494a7a858
            elif [[ $1 == 22.04 ]]; then
                klayoutChecksum=6e431b0a1a34c16eab9958a2c28f88bd
            elif [[ $1 == 24.04 ]]; then
                klayoutChecksum=2d186f0225dbac7ae2d790aa8fa57814
            else
                echo "Unrecognized version of Ubuntu $1. Please install KLayout manually"
                exit 1
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
            docker-buildx-plugin \
            docker-compose-plugin
    fi
}

_installDarwinPackages() {
    brew install libffi tcl-tk ruby
    brew install python libomp doxygen capnp tbb bison flex boost spdlog zlib
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
        software-properties-common \
        clang pkg-config \
        libboost-dev libfl-dev libtbb-dev capnproto libcapnp-dev \
        libgtest-dev libspdlog-dev libfmt-dev libboost-iostreams-dev zlib1g-dev
}

_help() {
    cat <<EOF

All arguments and flags are only applicable for OpenROAD dependencies
Usage: $0 [-all|-base|-common] [-<ARGS>]
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
       $0 -yosys-ver=VERSION
                                # Installs specified version of Yosys.
                                #    By default, the Yosys version is
                                #    obtained from tools/yosys/docs/source/conf.py
       $0 -constant-build-dir
                                #  Use constant build directory, instead of
                                #    random one.
       $0 -bazel
                                # Skip OpenROAD build dependencies. Only
                                #    install flow-level dependencies
                                #    (klayout, ruby, docker, pip packages).
                                #    Use this when building OpenROAD with
                                #    Bazel, which manages its own build
                                #    dependencies.
EOF
    exit "${1:-1}"
}

# default args
OR_INSTALLER_ARGS="-eqy"
YOSYS_VER=""
# default prefix
PREFIX=""
# default option
option="none"
# default isLocal
isLocal="false"
constantBuildDir="false"
CI="no"
BAZEL="no"

# default values, can be overwritten by cmdline args
while [ "$#" -gt 0 ]; do
    case "${1}" in
        -h|-help)
            _help 0
            ;;
        -all)
            if [[ "${option}" != "none" ]]; then
                echo "WARNING: previous argument -${option} will be overwritten with -all." >&2
            fi
            option="all"
            ;;
        -base)
            if [[ "${option}" != "none" ]]; then
                echo "WARNING: previous argument -${option} will be overwritten with -base." >&2
            fi
            option="base"
            ;;
        -common)
            if [[ "${option}" != "none" ]]; then
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
        -yosys-ver=*)
            YOSYS_VER=${1#*=}
            ;;
        -prefix=*)
            OR_INSTALLER_ARGS="${OR_INSTALLER_ARGS} $1"
            PREFIX=${1#*=}
            ;;
        -constant-build-dir)
            OR_INSTALLER_ARGS="${OR_INSTALLER_ARGS} $1"
            constantBuildDir="true"
            ;;
        -bazel)
            BAZEL="yes"
            ;;
        -threads=*)
            OR_INSTALLER_ARGS="${OR_INSTALLER_ARGS} $1"
            numThreads=${1#*=}
            ;;
        *)
            echo "unknown option: ${1}" >&2
            _help
            ;;
    esac
    shift 1
done

if [[ "${option}" == "none"  ]]; then
        echo "You must use one of: -all|-base|-common" >&2
        _help
fi

OR_INSTALLER_ARGS="${OR_INSTALLER_ARGS} -${option}"

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
    "CentOS Linux" | "Red Hat Enterprise Linux"* | "AlmaLinux" | "Rocky Linux")
        # Enterprise Linux support - dispatch based on specific version
        if [[ ${CI} == "yes" ]]; then
            echo "WARNING: Installing CI dependencies is only supported on Ubuntu 22.04" >&2
        fi
        
        # Detect EL version to choose appropriate functions
        if [[ -f /etc/os-release ]]; then
            elVersion=$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release | sed 's/"//g' | cut -d. -f1)
        else
            echo "ERROR: Could not detect Enterprise Linux version" >&2
            exit 1
        fi
        
        # First install OpenROAD base
        if [[ "${BAZEL}" == "yes" ]]; then
            _installBazelFlowDependencies
        else
            _installORDependencies
        fi

        # Determine between EL7 vs EL8/9, since yum vs dnf should be used, and different Klayout builds exist
        case "${elVersion}" in
            "7")
                # EL7 = RHEL 7 or CentOS 7
                if [[ "${option}" == "base" || "${option}" == "all" ]]; then
                    _install_EL7_Packages
                    _install_EL7_CleanUp
                fi
                ;;
            "8"|"9")
                # EL8/EL9 = RHEL, Rocky Linux, AlmaLinux, or CentOS 8+
                if [[ "${option}" == "base" || "${option}" == "all" ]]; then
                    _install_EL8_EL9_Packages
                    _install_EL8_EL9_CleanUp
                fi
                ;;
            *)
                echo "ERROR: Unsupported Enterprise Linux version: ${elVersion}" >&2
                exit 1
                ;;
        esac
        
        if [[ "${option}" == "common" || "${option}" == "all" ]]; then
            _installPipCommon
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
        if [[ "${BAZEL}" == "yes" ]]; then
            _installBazelFlowDependencies
        else
            _installORDependencies
        fi
        if [[ "${option}" == "base" || "${option}" == "all" ]]; then
            _installUbuntuPackages "${version}"
            _installUbuntuCleanUp
        fi
        if [[ "${option}" == "common" || "${option}" == "all" ]]; then
            if [[ $version != "rodete" ]]; then
                if _versionCompare ${version} -lt 23.04 ; then
                    _installPipCommon
                fi
            else
                echo "Skip common for rodete"
            fi
        fi
        ;;
    "Darwin" )
        if [[ ${CI} == "yes" ]]; then
            echo "WARNING: Installing CI dependencies is only supported on Ubuntu 22.04" >&2
        fi
        if [[ "${BAZEL}" == "yes" ]]; then
            _installBazelFlowDependencies
        else
            _installORDependencies
        fi
        if [[ "${option}" == "base" || "${option}" == "all" ]]; then
            _installDarwinPackages
        fi
        if [[ "${option}" == "common" || "${option}" == "all" ]]; then
            _installPipCommon
        fi
        ;;
    *)
        echo "unsupported system: ${os}" >&2
        _help
        ;;
esac
