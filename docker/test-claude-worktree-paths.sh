#!/usr/bin/env bash
# Run only on a disposable Linux host with empty, writable /workspace and
# /home/claude-user directories. The test needs Git, Bash and a container engine.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
for dir in /workspace /home/claude-user; do
    if [[ ! -d "${dir}" || ! -w "${dir}" || -n "$(ls -A "${dir}")" ]]; then
        echo "Test requires an empty, writable ${dir}" >&2
        exit 1
    fi
done

tmp=$(mktemp -d)
workspace_fixture=$(mktemp -d /workspace/claude-test.XXXXXX)
home_fixture=$(mktemp -d /home/claude-user/claude-test.XXXXXX)
trap 'rm -rf "${tmp}" "${workspace_fixture}" "${home_fixture}"' EXIT

export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.invalid
export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.invalid
# Resolve the real engine before adding the test shim to PATH.
TEST_ENGINE=$(command -v "${CONTAINER_ENGINE:-docker}")
export TEST_ENGINE
export TEST_ENGINE_HOME="${HOME}"
export TEST_ENTRYPOINT="${SCRIPT_DIR}/claude-entrypoint.sh"
export TEST_SETUP="${tmp}/entrypoint"
image="${TEST_IMAGE:-openroad/flow-ubuntu26.04-dev:latest}"

mkdir -p "${tmp}/bin" "${tmp}/settings/.claude" "${tmp}/settings/.cache/bazel-claude"
cat > "${TEST_SETUP}" <<'SH'
#!/usr/bin/env bash
set -e
mkdir -p /etc/sudoers.d
exec /test-entrypoint.sh "$@"
SH
cat > "${tmp}/bin/docker" <<'SH'
#!/usr/bin/env bash
engine_args=()
if [[ "${TEST_ENGINE##*/}" == podman ]]; then
    export HOME="${TEST_ENGINE_HOME}"
    engine_args+=(--userns keep-id --security-opt label=disable)
fi
case "$1" in
    image) exec "${TEST_ENGINE}" "$@" ;;
    run)
        shift
        exec "${TEST_ENGINE}" run "${engine_args[@]}" --user 0:0 --network none \
            --cap-drop ALL --cap-add CHOWN --cap-add SETUID --cap-add SETGID \
            --cap-add DAC_OVERRIDE --security-opt no-new-privileges \
            -v "${TEST_ENTRYPOINT}:/test-entrypoint.sh:ro" \
            -v "${TEST_SETUP}:/test-setup.sh:ro" \
            --entrypoint /test-setup.sh "$@"
        ;;
    *) exit 1 ;;
esac
SH
chmod +x "${TEST_SETUP}" "${tmp}/bin/docker"

cat > "${tmp}/settings/.gitconfig" <<'CONFIG'
[user]
    name = test
    email = test@example.invalid
CONFIG
echo saved > "${tmp}/settings/.claude.json"

git init -q "${tmp}/module"
echo module > "${tmp}/module/content"
git -C "${tmp}/module" add content
git -C "${tmp}/module" commit -qm module

make_main() {
    git init -q "$1"
    cp "${SCRIPT_DIR}/../claude.sh" "$1/claude.sh"
    echo initial > "$1/content"
    git -C "$1" -c protocol.file.allow=always submodule add -q "${tmp}/module" module
    git -C "$1" add claude.sh content
    git -C "$1" commit -qm initial
}

make_worktree() {
    git -C "$1" worktree add --detach -q "$2"
    git -C "$2" -c protocol.file.allow=always submodule update --init -q
}

run_case() {
    local checkout=$1 name=$2 original original_module ref git_dir
    original=$(cat "${checkout}/.git") || return 1
    original_module=$(cat "${checkout}/module/.git") || return 1
    git_dir=$(git -C "${checkout}" rev-parse --absolute-git-dir) || return 1
    echo fixture > "${tmp}/settings/.claude/settings.json"
    rm -f "${tmp}/settings/.cache/bazel-claude/marker"
    if ! env -u SSH_AUTH_SOCK -u ANTHROPIC_API_KEY -u AWS_ACCESS_KEY_ID \
        -u AWS_SECRET_ACCESS_KEY -u GOOGLE_APPLICATION_CREDENTIALS -u BAZEL_CACHE_DIR \
        HOME="${tmp}/settings" PATH="${tmp}/bin:${PATH}" \
        bash "${checkout}/claude.sh" --shell --image "${image}" --name "claude-git-test-$$" <<'SH'
set -eu
test "$(git rev-parse --show-toplevel)" = "$(pwd -P)"
test "$(git -C module rev-parse --show-toplevel)" = "$(pwd -P)/module"
status=$(git status --porcelain)
test -z "${status}"
test "$(git -C module show HEAD:content)" = module
git switch -qc "test-$(basename "$(git rev-parse --absolute-git-dir)")"
echo modified > content
git add content
git -c commit.gpgsign=false commit -qm modified
test "$(cat /workspace/content)" = modified
test "$(git config --get gc.worktreePruneExpire)" = never
test "$(cat "${HOME}/.claude/settings.json")" = fixture
test "$(cat "${HOME}/.claude.json")" = saved
if (echo changed >> "${HOME}/.gitconfig") 2>/dev/null; then
    exit 1
fi
echo updated > "${HOME}/.claude/settings.json"
touch "${HOME}/.cache/bazel/marker"
SH
    then
        echo "FAIL: ${name}" >&2
        return 1
    fi
    ref=$(git -C "${checkout}" symbolic-ref HEAD) || return 1
    if compgen -G "${git_dir}/claude-link.*" > /dev/null; then
        echo "FAIL: ${name}: temporary Git pointer was left behind" >&2
        return 1
    fi
    if [[ "$(cat "${checkout}/.git")" != "${original}" ||
        "$(cat "${checkout}/module/.git")" != "${original_module}" ||
        "$(git -C "${checkout}" show "${ref}:content")" != modified ||
        "$(cat "${tmp}/settings/.claude/settings.json")" != updated ||
        ! -f "${tmp}/settings/.cache/bazel-claude/marker" ]]; then
        echo "FAIL: ${name}: unexpected host state" >&2
        return 1
    fi
    echo "PASS: ${name}"
}

make_main "${tmp}/main"
make_main "${workspace_fixture}/main"
make_main "${home_fixture}/main"
make_worktree "${tmp}/main" "${workspace_fixture}/worktree"
make_worktree "${tmp}/main" "${home_fixture}/worktree"
git -C "${workspace_fixture}/main" -c worktree.useRelativePaths=true \
    worktree add --detach -q "${tmp}/workspace-data"
git -C "${tmp}/workspace-data" -c protocol.file.allow=always submodule update --init -q
make_worktree "${home_fixture}/main" "${tmp}/home-data"

# A linked checkout can contain its main repository after the main
# repository moves and Git repairs the links.
nested_checkout="${workspace_fixture}/nested"
make_main "${tmp}/nested-main"
git -C "${tmp}/nested-main" worktree add --detach -q "${nested_checkout}"
mv "${tmp}/nested-main" "${nested_checkout}/main"
git -C "${nested_checkout}/main" worktree repair "${nested_checkout}"
echo /main/ >> "${nested_checkout}/main/.git/info/exclude"
git -C "${nested_checkout}" -c protocol.file.allow=always submodule update --init -q

failed=0
run_case "${workspace_fixture}/worktree" "worktree under /workspace" || failed=1
run_case "${home_fixture}/worktree" "worktree under /home/claude-user" || failed=1
run_case "${tmp}/workspace-data" "Git data under /workspace" || failed=1
run_case "${tmp}/home-data" "Git data under /home/claude-user" || failed=1
run_case "${nested_checkout}" "Git data inside the worktree" || failed=1

# Use /workspace itself only after removing this test's nested fixtures.
rm -rf "${workspace_fixture}"
make_worktree "${tmp}/main" /workspace
run_case /workspace "worktree at /workspace" || failed=1
git -C "${tmp}/main" worktree remove --force /workspace
exit "${failed}"
