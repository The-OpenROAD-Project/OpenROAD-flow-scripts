#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == --assert ]]; then
    if [[ "${HOME}" != /home/claude-user ]]; then
        echo "HOME=${HOME}, expected /home/claude-user" >&2
        exit 1
    fi
    test "$(id -u)" = "$2"
    test "$(cat "${HOME}/.claude/settings.json")" = fixture
    echo updated > "${HOME}/.claude/settings.json"
    echo "UID $2 reads and writes settings through HOME"
    exit 0
fi

if [[ "${1:-}" == --inside ]]; then
    uid=$2
    gid=$3
    if [[ "$4" == existing ]]; then
        getent passwd "${uid}" > /dev/null
        mkdir -p "$(getent passwd "${uid}" | cut -d: -f6)"
    else
        if getent passwd "${uid}" > /dev/null; then
            echo "Fixture UID ${uid} must be unused" >&2
            exit 1
        fi
    fi
    mkdir -p /home/claude-user/.claude /etc/sudoers.d
    echo fixture > /home/claude-user/.claude/settings.json
    chown -R "${uid}:${gid}" /home/claude-user/.claude
    export HOST_UID=${uid} HOST_GID=${gid}
    exec bash /test/claude-entrypoint.sh bash /test/test-claude-entrypoint.sh --assert "${uid}"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTAINER_ENGINE="${CONTAINER_ENGINE:-docker}"
TEST_IMAGE="${TEST_IMAGE:-openroad/flow-ubuntu26.04-dev:latest}"

for fixture in '1000 1000 existing' '2000 2000 new'; do
    read -r uid gid state <<< "${fixture}"
    "${CONTAINER_ENGINE}" run --rm --platform linux/amd64 \
        --network none --user 0:0 \
        --cap-drop ALL --cap-add CHOWN --cap-add SETUID --cap-add SETGID --cap-add DAC_OVERRIDE \
        --security-opt no-new-privileges \
        --cpus 2 --memory 4g --pids-limit 256 \
        --volume "${SCRIPT_DIR}:/test:ro" \
        --entrypoint bash "${TEST_IMAGE}" \
        /test/test-claude-entrypoint.sh --inside "${uid}" "${gid}" "${state}"
done
