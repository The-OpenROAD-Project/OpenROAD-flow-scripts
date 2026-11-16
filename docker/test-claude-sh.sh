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
common=$(git -C "${tmp}/wt" rev-parse --path-format=absolute --git-common-dir)

run_args() { # Print the docker run arguments of claude.sh in checkout $1.
    env -u SSH_AUTH_SOCK HOME="${tmp}/home" PATH="${tmp}/bin:${PATH}" \
        bash "$1/claude.sh" --shell < /dev/null
}

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

wt_args=$(run_args "${tmp}/wt")
grep -qxF "${common}:${common}" <<< "${wt_args}" ||
    fail "worktree: ${common} is not mounted at the same path"
grep -qxF "GIT_CONFIG_VALUE_0=never" <<< "${wt_args}" ||
    fail "worktree: automatic worktree prune is not disabled"
echo "A worktree gets the main .git at the same path"

main_args=$(run_args "${tmp}/main")
if grep -qF "${common}:" <<< "${main_args}"; then
    fail "main checkout: .git is mounted a second time"
fi
grep -qxF "GIT_CONFIG_VALUE_0=never" <<< "${main_args}" ||
    fail "main checkout: automatic worktree prune is not disabled"
echo "A main checkout needs no extra .git mount"
