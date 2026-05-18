#!/bin/bash
set -e

# ORFS developer install script
# Builds and installs OpenROAD, Yosys, and yosys-slang to tools/install/
# where flow/Makefile expects them.
#
# Uses stamp files for fast no-op re-runs (seconds when nothing changed).

WORKSPACE="${BUILD_WORKSPACE_DIRECTORY:-.}"
INSTALL_DIR="${WORKSPACE}/tools/install"
NUM_THREADS=$(nproc)

# --- Check system dependencies for yosys/slang builds ---
check_deps() {
    local missing_cmds=()

    for cmd in bison flex gawk g++ pkg-config tclsh git cmake; do
        if ! command -v "$cmd" &>/dev/null; then
            missing_cmds+=("$cmd")
        fi
    done

    if [[ ${#missing_cmds[@]} -eq 0 ]]; then
        return
    fi

    echo "ERROR: Missing commands: ${missing_cmds[*]}"
    echo ""

    # Platform-specific install hint
    if [[ "$(uname -s)" == "Darwin" ]]; then
        echo "  brew install bison flex gawk cmake pkg-config tcl-tk"
    elif command -v apt-get &>/dev/null; then
        echo "  sudo apt-get install bison flex gawk g++ pkg-config tcl cmake git"
    elif command -v dnf &>/dev/null; then
        echo "  sudo dnf install bison flex gawk gcc-c++ pkgconf tcl cmake git"
    elif command -v yum &>/dev/null; then
        echo "  sudo yum install bison flex gawk gcc-c++ pkgconf tcl cmake git"
    elif command -v zypper &>/dev/null; then
        echo "  sudo zypper install bison flex gawk gcc-c++ pkg-config tcl cmake git"
    fi
    exit 1
}

check_deps

BUILD_OPENROAD=1

usage() {
    cat <<'EOF'
Usage: bazelisk run //:install_for_bazel [-- OPTIONS]

Options:
  --help, -h        Show this help
  --skip-openroad   Skip OpenROAD build
  --threads N       Compilation threads (default: nproc)
EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            usage
            ;;
        --skip-openroad)
            BUILD_OPENROAD=0
            ;;
        --threads)
            NUM_THREADS="$2"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
    shift
done

# --- Check submodules are initialized ---
for sub in tools/OpenROAD tools/yosys tools/yosys-slang; do
    if [[ ! -d "${WORKSPACE}/${sub}" ]] || [[ -z "$(ls -A "${WORKSPACE}/${sub}" 2>/dev/null)" ]]; then
        echo "ERROR: ${sub} not initialized."
        echo "Run: git submodule update --init --recursive"
        exit 1
    fi
done

# --- OpenROAD (delegates to its own //packaging:install) ---
if [[ $BUILD_OPENROAD -eq 1 ]]; then
    echo "=== Building OpenROAD with GUI support ==="
    (cd "${WORKSPACE}/tools/OpenROAD" && bazelisk run --//:platform=gui //packaging:install)
fi

# --- Yosys ---
# Uses stamp file for fast no-op: if the yosys submodule commit hasn't
# changed, skip the build entirely.
YOSYS_INSTALL="${INSTALL_DIR}/yosys"
YOSYS_STAMP="${YOSYS_INSTALL}/.yosys_commit"
YOSYS_COMMIT="$(git -C "${WORKSPACE}/tools/yosys" rev-parse HEAD)"

if [[ -f "${YOSYS_STAMP}" ]] && [[ "$(cat "${YOSYS_STAMP}")" == "${YOSYS_COMMIT}" ]]; then
    echo "=== Yosys already up to date (${YOSYS_COMMIT:0:12}) ==="
else
    echo "=== Building Yosys ==="
    (
        cd "${WORKSPACE}/tools/yosys"
        make -j "${NUM_THREADS}" PREFIX="${YOSYS_INSTALL}" ABC_ARCHFLAGS=-Wno-register
        make install PREFIX="${YOSYS_INSTALL}"
    )
    echo "${YOSYS_COMMIT}" > "${YOSYS_STAMP}"
    echo "Yosys installed to ${YOSYS_INSTALL}/bin/yosys"
fi

# --- yosys-slang ---
SLANG_STAMP="${YOSYS_INSTALL}/.slang_commit"
SLANG_COMMIT="$(git -C "${WORKSPACE}/tools/yosys-slang" rev-parse HEAD)"

if [[ -f "${SLANG_STAMP}" ]] && [[ "$(cat "${SLANG_STAMP}")" == "${SLANG_COMMIT}" ]]; then
    echo "=== yosys-slang already up to date (${SLANG_COMMIT:0:12}) ==="
else
    echo "=== Building yosys-slang ==="
    (
        cd "${WORKSPACE}/tools/yosys-slang"
        cmake -S . -B build \
            -DYOSYS_CONFIG="${YOSYS_INSTALL}/bin/yosys-config" \
            -DCMAKE_BUILD_TYPE=Release \
            -DYOSYS_SLANG_REVISION=unknown \
            -DSLANG_REVISION=unknown
        cmake --build build -j "${NUM_THREADS}"
        cmake --install build --prefix "${YOSYS_INSTALL}"
    )
    echo "${SLANG_COMMIT}" > "${SLANG_STAMP}"
    echo "yosys-slang installed to ${YOSYS_INSTALL}/share/yosys/plugins/"
fi

echo ""
echo "=== Done ==="
echo "cd flow && make"
