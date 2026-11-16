#!/usr/bin/env bash
# Check the git mounts that claude.sh adds, with a stub docker command.
# Needs bash and git only; no container engine runs.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp=$(mktemp -d)
trap 'rm -rf "${tmp}"' EXIT

mkdir -p "${tmp}/bin" "${tmp}/home"
cat > "${tmp}/bin/docker" << 'EOF'
#!/usr/bin/env bash
# The image exists. For "run", print each argument on its own line.
if [[ "$1" == run ]]; then
    shift
    printf '%s\n' "$@"
fi
EOF
chmod +x "${tmp}/bin/docker"

git -c init.defaultBranch=main init -q "${tmp}/main"
cp "${SCRIPT_DIR}/../claude.sh" "${tmp}/main/claude.sh"
git -C "${tmp}/main" add claude.sh
git -C "${tmp}/main" -c user.name=test -c user.email=test@example.invalid \
    -c core.hooksPath=/dev/null commit -q -m init
git -C "${tmp}/main" worktree add -q "${tmp}/wt"
common=$(cd "${tmp}/main/.git" && pwd -P)
wt=$(cd "${tmp}/wt" && pwd -P)
mkdir "${tmp}/plain"
cp "${SCRIPT_DIR}/../claude.sh" "${tmp}/plain/claude.sh"
# A plain folder inside another repository, for example a home in git.
git -c init.defaultBranch=main init -q "${tmp}/parent"
mkdir -p "${tmp}/parent/src/orfs"
cp "${SCRIPT_DIR}/../claude.sh" "${tmp}/parent/src/orfs/claude.sh"
parent_git=$(cd "${tmp}/parent/.git" && pwd -P)

# Git before 2.31 does not know --path-format. rev-parse then prints the
# option as output and exits 0. This wrapper does the same.
mkdir "${tmp}/oldgit"
cat > "${tmp}/oldgit/git" << EOF
#!/usr/bin/env bash
args=()
for arg in "\$@"; do
    case "\${arg}" in
        --path-format=*) echo "\${arg}" ;;
        *) args+=("\${arg}") ;;
    esac
done
exec "$(command -v git)" "\${args[@]}"
EOF
chmod +x "${tmp}/oldgit/git"

run_args() { # Print the docker run arguments of claude.sh in checkout $1.
    env -u SSH_AUTH_SOCK HOME="${tmp}/home" PATH="${tmp}/bin:${PATH}" \
        bash "$1/claude.sh" --shell < /dev/null
}

workdir() { # Print the value of -w in the arguments $1.
    grep -A1 -xF -- -w <<< "$1" | tail -n 1
}

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

check_plain() { # check_plain NAME ARGS: only /workspace, prune guard set.
    if grep -qF "${common}:" <<< "$2" || grep -qF "${wt}:" <<< "$2"; then
        fail "$1: unexpected git mount"
    fi
    [[ "$(workdir "$2")" == /workspace ]] || fail "$1: workdir is not /workspace"
    grep -qxF GIT_CONFIG_VALUE_0=never <<< "$2" ||
        fail "$1: automatic worktree prune is not disabled"
}

check_worktree() { # check_worktree NAME ARGS: host-path mounts and workdir.
    grep -qxF "${common}:${common}" <<< "$2" ||
        fail "$1: ${common} is not mounted at its host path"
    grep -qxF "${wt}:${wt}" <<< "$2" ||
        fail "$1: ${wt} is not mounted at its host path"
    [[ "$(workdir "$2")" == "${wt}" ]] || fail "$1: workdir is not ${wt}"
    grep -qxF GIT_CONFIG_VALUE_0=never <<< "$2" ||
        fail "$1: automatic worktree prune is not disabled"
}

check_worktree worktree "$(run_args "${tmp}/wt")"
echo "A worktree gets its host path and the main .git at their host paths"

check_plain "main checkout" "$(run_args "${tmp}/main")"
echo "A main checkout gets no extra mount"

check_plain "not a repository" "$(run_args "${tmp}/plain")"
echo "A folder outside git gets no extra mount"

args=$(run_args "${tmp}/parent/src/orfs")
check_plain "folder in a parent repository" "${args}"
if grep -qF "${parent_git}" <<< "${args}"; then
    fail "folder in a parent repository: the parent .git is mounted"
fi
echo "A folder inside another repository does not get its .git"

check_worktree "old git, worktree" "$(PATH="${tmp}/oldgit:${PATH}" run_args "${tmp}/wt")"
check_plain "old git, main checkout" "$(PATH="${tmp}/oldgit:${PATH}" run_args "${tmp}/main")"
echo "Git without --path-format gives the same mounts"
