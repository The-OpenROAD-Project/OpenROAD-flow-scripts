#!/usr/bin/env bash
# Usage: install_licenses.sh <prefix>
#
# Copies the license notices of every module that goes into the
# kepler-formal binary and its runfiles (naja, yaml-cpp, spdlog, kissat,
# the embedded Python, the statically linked libc++, ...) into
# <prefix>/share/kepler-formal/licenses/<repository>/. kepler-formal's
# //:install ships only its own LICENSE.rst and LICENSES/.
#
# The modules are the repositories cquery finds in the binary's target
# configuration; build tools such as bison run in the exec configuration
# and are left out. Run it after `bazelisk run //:install`, from this
# folder, so that the repositories are fetched.
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <prefix>" >&2
    exit 1
fi
dest="$(cd "$1" && pwd)/share/kepler-formal/licenses"
binary=@kepler-formal//src/bin:kepler-formal

cd "$(dirname "$0")"
external="$(bazelisk info output_base)/external"
config="$(bazelisk cquery "${binary}" | awk '{print $NF}')"
repos="$(bazelisk cquery --consistent_labels "deps(${binary})" \
    | awk -v c="${config}" '$NF == c' \
    | sed -n 's|^@@\([^/]*\)//.*|\1|p' | sort -u)"

rm -rf "${dest}"
count=0
for repo in ${repos}; do
    [[ -n "${repo}" ]] || continue
    # Some modules unpack into a subdirectory (zlib-1.3.2/, slang-12.0/),
    # and the llvm-project one keeps libc++'s notice in libcxx/. The
    # embedded Python keeps its own in lib/python3.X/.
    files="$(cd "${external}/${repo}" && find . -maxdepth 3 \
        \( \( -iname 'LICENSE*' -o -iname 'LICENCE*' -o -iname 'COPYING*' \
              -o -iname 'NOTICE*' -o -iname 'COPYRIGHT*' \) \
           \( -path './*' -a ! -path './*/*/*' \
              -o -path './lib/python*/LICENSE.txt' \) \) \
        -print -prune)"
    [[ -n "${files}" ]] || continue
    mkdir -p "${dest}/${repo}"
    while IFS= read -r f; do
        (cd "${external}/${repo}" && cp -rL --parents "${f}" "${dest}/${repo}/")
    done <<< "${files}"
    count=$((count + 1))
done
if [[ ${count} -eq 0 ]]; then
    echo "[ERROR] no license notices found for ${binary} in ${external}" >&2
    exit 1
fi
echo "Installed the license notices of ${count} modules in ${dest}"
