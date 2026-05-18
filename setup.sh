#!/usr/bin/env bash

set -euo pipefail

# allow this script to be invoked from any folder
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ "$OSTYPE" == "darwin"* ]] && [[ $EUID -eq 0 ]]; then
  echo "Do NOT run this script with sudo on macOS"
  exit 1
fi

if [[ "$OSTYPE" != "darwin"* ]] && [[ $EUID -ne 0 ]]; then
  echo "This script must be run with sudo on Linux"
  exit 1
fi

tmpfile=$(mktemp)
# any error messages from this command will stand out
# more clearly when run as a separate command rather than
# being piped
git submodule status --recursive > "$tmpfile"

if grep -q "^-" "$tmpfile"; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    git submodule update --init --recursive
  else
    sudo -u $SUDO_USER git submodule update --init --recursive
  fi
elif grep -q "^+" "$tmpfile"; then
  # Make it easy for users who are not hacking ORFS to do the right thing,
  # run with current submodules, at the cost of having ORFS
  # hackers disable this test manually when hacking setup.sh
  echo "Submodules are not up to date, run 'git submodule update --recursive' and try again"
  exit 1
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  if [[ ! -d "$DIR/.venv" ]]; then
    echo "Creating Python virtual environment at $DIR/.venv"
    python3 -m venv "$DIR/.venv"
  fi

  echo "Activating virtual environment"
  source "$DIR/.venv/bin/activate"

  python -m pip install --upgrade pip
fi

"$DIR/etc/DependencyInstaller.sh" -base
if [[ "$OSTYPE" == "darwin"* ]]; then
  "$DIR/etc/DependencyInstaller.sh" -common -prefix="$DIR/dependencies"
else
  sudo -u $SUDO_USER "$DIR/etc/DependencyInstaller.sh" -common -prefix="$DIR/dependencies"
fi
