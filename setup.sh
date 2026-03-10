#!/usr/bin/env bash

set -euo pipefail

# allow this script to be invoked from any folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ $EUID -ne 0 ]; then
  echo "This script must be run with sudo"
  exit 1
fi

BAZEL_ARG=""
for arg in "$@"; do
  case "${arg}" in
    --bazel|-bazel)
      BAZEL_ARG="-bazel"
      ;;
    *)
      echo "unknown option: ${arg}" >&2
      echo "Usage: $0 [--bazel]"
      echo "  --bazel  Skip OpenROAD build dependencies (use when building OpenROAD with Bazel)"
      exit 1
      ;;
  esac
done

tmpfile=$(mktemp)
# any error messages from this command will stand out
# more clearly when run as a separate command rather than
# being piped
git submodule status --recursive > "$tmpfile"

if grep -q "^-" "$tmpfile"; then
  sudo -u $SUDO_USER git submodule update --init --recursive
elif grep -q "^+" "$tmpfile"; then
  # Make it easy for users who are not hacking ORFS to do the right thing,
  # run with current submodules, at the cost of having ORFS
  # hackers disable this test manually when hacking setup.sh
  echo "Submodules are not up to date, run 'git submodule update --recursive' and try again"
  exit 1
fi

"$DIR/etc/DependencyInstaller.sh" -base ${BAZEL_ARG}
sudo -u $SUDO_USER "$DIR/etc/DependencyInstaller.sh" -common -prefix="$DIR/dependencies" ${BAZEL_ARG}
