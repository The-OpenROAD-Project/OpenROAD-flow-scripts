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

args=$(run_args "${tmp}/wt")
grep -qxF "${common}:${common}" <<< "${args}" ||
    fail "worktree: ${common} is not mounted at its host path"
grep -qxF "${wt}:${wt}" <<< "${args}" ||
    fail "worktree: ${wt} is not mounted at its host path"
[[ "$(workdir "${args}")" == "${wt}" ]] ||
    fail "worktree: workdir is not ${wt}"
grep -qxF GIT_CONFIG_VALUE_0=never <<< "${args}" ||
    fail "worktree: automatic worktree prune is not disabled"
echo "A worktree gets its host path and the main .git at their host paths"

check_plain "main checkout" "$(run_args "${tmp}/main")"
echo "A main checkout gets no extra mount"

check_plain "not a repository" "$(run_args "${tmp}/plain")"
echo "A folder outside git gets no extra mount"

# Git before 2.31 prints an unknown option as output and exits 0.
mkdir "${tmp}/oldgit"
cat > "${tmp}/oldgit/git" << EOF
#!/usr/bin/env bash
if [[ "\$*" == *rev-parse* ]]; then
    echo --path-format=absolute
fi
exec "$(command -v git)" "\$@"
EOF
chmod +x "${tmp}/oldgit/git"
PATH="${tmp}/oldgit:${PATH}" check_plain "old git, main checkout" \
    "$(PATH="${tmp}/oldgit:${PATH}" run_args "${tmp}/main")"
echo "Unexpected git output adds no mount"
