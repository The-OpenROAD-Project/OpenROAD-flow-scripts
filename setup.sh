#!/usr/bin/env bash

set -euo pipefail

# allow this script to be invoked from any folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ $EUID -ne 0 ]; then
  echo "This script must be run with sudo"
  exit 1
fi


# Run a command as the original user if invoked via sudo, otherwise run directly
run_as_user() {
  if [[ -n "${SUDO_USER:-}" ]]; then
    sudo -u "$SUDO_USER" "$@"
  else
    "$@"
  fi
}
tmpfile=$(mktemp)
# any error messages from this command will stand out
# more clearly when run as a separate command rather than
# being piped
git submodule status --recursive > "$tmpfile"

if grep -q "^-" "$tmpfile"; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    git submodule update --init --recursive
  else
    run_as_user git submodule update --init --recursive
  fi
elif grep -q "^+" "$tmpfile"; then
  # Make it easy for users who are not hacking ORFS to do the right thing,
  # run with current submodules, at the cost of having ORFS
  # hackers disable this test manually when hacking setup.sh
  echo "Submodules are not up to date, run 'git submodule update --recursive' and try again"
  exit 1
fi

"$DIR/etc/DependencyInstaller.sh" -base
if [[ "$OSTYPE" == "darwin"* ]]; then
  "$DIR/etc/DependencyInstaller.sh" -common -prefix="$DIR/dependencies"
else
  run_as_user "$DIR/etc/DependencyInstaller.sh" -common -prefix="$DIR/dependencies"
fi
