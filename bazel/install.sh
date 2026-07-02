#!/bin/bash
set -e

# ORFS developer install script
# Builds and installs OpenROAD, Yosys (with the yosys-slang plugin) to
# tools/install/ where flow/Makefile expects them.
#
# Yosys comes from the bazel-built //:yosys_tar tarball (hermetic, cached
# by bazel), so re-runs are fast and no host toolchain beyond bazelisk is
# needed.

WORKSPACE="${BUILD_WORKSPACE_DIRECTORY:-.}"
INSTALL_DIR="${WORKSPACE}/tools/install"

BUILD_OPENROAD=1

usage() {
    cat <<'EOF'
Usage: bazelisk run //:install_for_bazel [-- OPTIONS]

Options:
  --help, -h        Show this help
  --skip-openroad   Skip OpenROAD build
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
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
    shift
done

# --- Check submodules are initialized ---
for sub in tools/OpenROAD; do
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

# --- Yosys (bazel-packaged tarball, includes yosys-abc and slang.so) ---
# //:yosys_tar is the bazel-built relocatable PREFIX tarball; bazel
# caches the build so re-runs are fast no-ops.
YOSYS_INSTALL="${INSTALL_DIR}/yosys"

echo "=== Installing Yosys (bazel //:yosys_tar) ==="
(
    cd "${WORKSPACE}"
    bazelisk build //:yosys_tar
    TARBALL="$(bazelisk info execution_root)/$(bazelisk cquery --output=files //:yosys_tar 2>/dev/null)"
    rm -rf "${YOSYS_INSTALL}"
    mkdir -p "${YOSYS_INSTALL}"
    tar -xzf "${TARBALL}" -C "${YOSYS_INSTALL}"
)
echo "Yosys installed to ${YOSYS_INSTALL}/bin/yosys"

echo ""
echo "=== Done ==="
echo "cd flow && make"
