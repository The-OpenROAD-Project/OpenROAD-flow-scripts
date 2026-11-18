#!/usr/bin/env bash
# Wrapper to run Claude Code inside a Docker container with
# --dangerously-skip-permissions.  The repo is volume-mounted so all
# edits are reflected on the host.
#
# Usage:
#   ./claude.sh --build          # build the Docker image (one-time)
#   ./claude.sh                  # start Claude Code interactively
#   ./claude.sh --shell          # get a bash shell instead
#   ./claude.sh -- -p "prompt"   # pass extra args to claude

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Defaults (overridable via environment) ---
CLAUDE_IMAGE="${CLAUDE_IMAGE:-openroad/flow-claude:latest}"
CONTAINER_NAME="${CONTAINER_NAME:-claude-orfs}"

# --- Argument parsing ---
SHELL_MODE=0
BUILD_IMAGE=0
CLAUDE_ARGS=()

usage() {
    cat <<EOF
Usage: $0 [OPTIONS] [-- CLAUDE_ARGS...]

Options:
    --build             Build the Docker image
    --shell             Start a bash shell instead of Claude Code
    --image NAME        Override Docker image (default: ${CLAUDE_IMAGE})
    --name NAME         Override container name (default: ${CONTAINER_NAME})
    -h, --help          Show this help

Environment:
    CLAUDE_IMAGE        Docker image override (same as --image).
    CONTAINER_NAME      Container name override (same as --name).
    ANTHROPIC_API_KEY   Optional. Passed through if set.

Examples:
    $0 --build                      # build the image
    $0                              # interactive Claude Code
    $0 -- -p "fix the floorplan"    # Claude with a prompt
    $0 --shell                      # bash inside the container
EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --build)     BUILD_IMAGE=1; shift ;;
        --shell)     SHELL_MODE=1; shift ;;
        --image)     CLAUDE_IMAGE="$2"; shift 2 ;;
        --name)      CONTAINER_NAME="$2"; shift 2 ;;
        -h|--help)   usage ;;
        --)          shift; CLAUDE_ARGS=("$@"); break ;;
        *)           CLAUDE_ARGS+=("$1"); shift ;;
    esac
done

# --- Build image (explicitly or automatically if missing) ---
_build_image() {
    echo "Building Claude Code Docker image: ${CLAUDE_IMAGE}"
    docker build \
        -f "${SCRIPT_DIR}/docker/Dockerfile.claude" \
        -t "${CLAUDE_IMAGE}" \
        "${SCRIPT_DIR}/docker"
    echo "Done.  Image: ${CLAUDE_IMAGE}"
}

if [[ "${BUILD_IMAGE}" -eq 1 ]]; then
    _build_image
    # If only --build was given, exit.
    if [[ "${SHELL_MODE}" -eq 0 ]] && [[ ${#CLAUDE_ARGS[@]} -eq 0 ]]; then
        exit 0
    fi
elif ! docker image inspect "${CLAUDE_IMAGE}" > /dev/null 2>&1; then
    echo "Image ${CLAUDE_IMAGE} not found. Building automatically..."
    _build_image
fi

# --- Determine the user's home inside the container ---
# The entrypoint creates /home/claude-user for the mapped user.
CONTAINER_HOME="/home/claude-user"

# --- Git data of a worktree ---
# A worktree's .git file, and the .git files of its submodules, point to the
# main checkout's git directory by absolute or relative paths. Keep their
# relative layout so links from submodules resolve in the container.
HOST_DIR=$(cd "${SCRIPT_DIR}" && pwd -P)
CONTAINER_WORKDIR=/workspace
GIT_TOP=""
GIT_COMMON_DIR=""
if git_top=$(git -C "${HOST_DIR}" rev-parse --show-toplevel 2> /dev/null) &&
    git_common=$(git -C "${HOST_DIR}" rev-parse --git-common-dir 2> /dev/null); then
    GIT_TOP=$(cd "${git_top}" 2> /dev/null && pwd -P) || GIT_TOP=""
    GIT_COMMON_DIR=$(cd "${HOST_DIR}" && cd "${git_common}" 2> /dev/null && pwd -P) ||
        GIT_COMMON_DIR=""
fi

# True when host path $1 does not overlap a path that the container already uses.
outside_container_paths() {
    [[ "$1/" != /workspace/* && "$1/" != "${CONTAINER_HOME}/"* ]]
}

GIT_MOUNTS=()
GIT_LINK_DIR=""
mount_prefix=""
# The existing checkout mount already preserves an exact /workspace path.
if { [[ "${HOST_DIR}" != /workspace ]] && ! outside_container_paths "${HOST_DIR}"; } ||
    ! outside_container_paths "${GIT_COMMON_DIR}"; then
    mount_prefix=/tmp/claude-worktree
fi

# Only for the top of a checkout: a plain folder inside another repository
# must not get that repository's .git. A gitfile also needs relocation when
# it points inside the checkout but the /workspace mount hides the host path.
if [[ "${GIT_TOP}" == "${HOST_DIR}" && -n "${GIT_COMMON_DIR}" &&
    ( "${GIT_COMMON_DIR}/" != "${HOST_DIR}/"* ||
      ( -n "${mount_prefix}" && "${HOST_DIR}" != /workspace && -f "${HOST_DIR}/.git" ) ) ]]; then
    CONTAINER_WORKDIR="${mount_prefix}${HOST_DIR}"
    if [[ "${CONTAINER_WORKDIR}" != /workspace ]]; then
        GIT_MOUNTS+=(-v "${HOST_DIR}:${CONTAINER_WORKDIR}")
    fi
    if [[ "${GIT_COMMON_DIR}/" != "${HOST_DIR}/"* ]]; then
        GIT_MOUNTS+=(-v "${GIT_COMMON_DIR}:${mount_prefix}${GIT_COMMON_DIR}")
    fi
    if [[ -n "${mount_prefix}" && -f "${HOST_DIR}/.git" ]]; then
        # Overlay the gitfile so its absolute target uses the new prefix.
        # Git still writes to the shared metadata through the directory mount.
        git_dir=$(git -C "${HOST_DIR}" rev-parse --absolute-git-dir)
        git_dir=$(cd "${git_dir}" && pwd -P)
        # Keep the source on a path already shared with the container engine.
        GIT_LINK_DIR=$(mktemp -d "${git_dir}/claude-link.XXXXXX")
        trap 'rm -rf -- "${GIT_LINK_DIR}"' EXIT
        printf 'gitdir: %s%s\n' "${mount_prefix}" "${git_dir}" > "${GIT_LINK_DIR}/gitfile"
        GIT_MOUNTS+=(-v "${GIT_LINK_DIR}/gitfile:${CONTAINER_WORKDIR}/.git:ro")
    fi
fi

# --- Assemble docker run arguments ---
DOCKER_RUN_ARGS=(
    --rm
    --name "${CONTAINER_NAME}"
    -v "${SCRIPT_DIR}:/workspace"
    -e "HOST_UID=$(id -u)"
    -e "HOST_GID=$(id -g)"
    -w "${CONTAINER_WORKDIR}"
)
if [[ ${#GIT_MOUNTS[@]} -gt 0 ]]; then
    DOCKER_RUN_ARGS+=("${GIT_MOUNTS[@]}")
fi

# The host paths of other worktrees do not exist in the container, so git gc
# there would prune their records from the shared .git directory. Stop that.
DOCKER_RUN_ARGS+=(
    -e GIT_CONFIG_COUNT=1
    -e GIT_CONFIG_KEY_0=gc.worktreePruneExpire
    -e GIT_CONFIG_VALUE_0=never
)

# TTY/stdin handling for interactive, CI, and piped-input cases:
#   * terminal in + terminal out → -it   (normal interactive use)
#   * anything else              → -i    (pass stdin through; no TTY)
# Forcing -it unconditionally breaks non-interactive use
# ("cannot attach stdin to a TTY-enabled container"), and dropping -i
# would silently discard piped input like `cat prompt.txt | claude.sh ...`.
if [[ -t 0 && -t 1 ]]; then
    DOCKER_RUN_ARGS+=(-it)
else
    DOCKER_RUN_ARGS+=(-i)
fi

# Pass through optional environment variables
for var in ANTHROPIC_API_KEY ANTHROPIC_MODEL CLAUDE_CODE_MAX_TURNS \
           CLAUDE_CODE_USE_BEDROCK \
           AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_REGION \
           GOOGLE_APPLICATION_CREDENTIALS; do
    if [[ -v "$var" ]] && [[ -n "${!var}" ]]; then
        DOCKER_RUN_ARGS+=(-e "${var}=${!var}")
    fi
done

# SSH agent forwarding (for git push/pull over SSH)
if [[ -n "${SSH_AUTH_SOCK:-}" ]]; then
    DOCKER_RUN_ARGS+=(
        -v "${SSH_AUTH_SOCK}:/tmp/ssh-agent.sock"
        -e "SSH_AUTH_SOCK=/tmp/ssh-agent.sock"
    )
fi

# Host gitconfig (read-only, for user.name / user.email)
if [[ -f "${HOME}/.gitconfig" ]]; then
    DOCKER_RUN_ARGS+=(-v "${HOME}/.gitconfig:${CONTAINER_HOME}/.gitconfig:ro")
fi

# Persist Claude Code settings / history / memory across runs
CLAUDE_CONFIG_DIR="${HOME}/.claude"
mkdir -p "${CLAUDE_CONFIG_DIR}"
DOCKER_RUN_ARGS+=(-v "${CLAUDE_CONFIG_DIR}:${CONTAINER_HOME}/.claude")

# Claude Code config file (lives next to ~/.claude/, not inside it)
if [[ -f "${HOME}/.claude.json" ]]; then
    DOCKER_RUN_ARGS+=(-v "${HOME}/.claude.json:${CONTAINER_HOME}/.claude.json")
fi

# Persist Bazel cache (avoids re-downloading hundreds of MB each run)
BAZEL_CACHE_DIR="${BAZEL_CACHE_DIR:-${HOME}/.cache/bazel-claude}"
mkdir -p "${BAZEL_CACHE_DIR}"
DOCKER_RUN_ARGS+=(-v "${BAZEL_CACHE_DIR}:${CONTAINER_HOME}/.cache/bazel")

# --- Run ---
if [[ "${SHELL_MODE}" -eq 1 ]]; then
    command=(bash)
else
    command=(claude --dangerously-skip-permissions "${CLAUDE_ARGS[@]}")
fi

if [[ -n "${GIT_LINK_DIR}" ]]; then
    docker run "${DOCKER_RUN_ARGS[@]}" "${CLAUDE_IMAGE}" "${command[@]}"
else
    exec docker run "${DOCKER_RUN_ARGS[@]}" "${CLAUDE_IMAGE}" "${command[@]}"
fi
