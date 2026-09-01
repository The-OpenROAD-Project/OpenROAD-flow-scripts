#!/usr/bin/env bash
#
# Run one E12 stage over a list of candidates, N at a time.
#
# Why this exists rather than bazel-orfs's //fork: fork is unreachable
# from any bazel-orfs commit ORFS can currently pin (it lands after the
# verilog/ subtree removal that @bazel-orfs-verilog is built from). But
# fork was never what stood in the way of parallelism -- bazel's
# output-base lock was, which serializes concurrent `bazelisk run`
# invocations. orfs_run_executable emits a plain shell wrapper that execs
# make with no bazel server involved, so invoking that wrapper directly
# sidesteps the lock and needs no fork.
#
# Each candidate is a separate process by design: the scorers must be, in
# any case, because gpl's Replace::reset() does not clear its cluster
# list. Per-candidate work directories come from e12_redirect, and
# RUN_LOG_NAME_STEM is overridden per tag so the workers do not race on a
# shared run.log.
#
# Usage:
#   run_parallel.sh <stage-target> <out-dir> <jobs> <tag>...
#   run_parallel.sh swerv_evaluate /path/to/evidence 3 cand_s0 cand_s1
#
# Extra KEY=VALUE overrides may be passed via E12_EXTRA_ARGS.

set -euo pipefail

if [ "$#" -lt 4 ]; then
  echo "usage: $0 <stage-target> <out-dir> <jobs> <tag>..." >&2
  exit 2
fi

target=$1
out_dir=$2
jobs=$3
shift 3
tags=("$@")

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)
wrapper="$repo_root/bazel-bin/flow/test/macro_e12/run_${target}_base_executable"
runfiles="$wrapper.runfiles/_main"

if [ ! -x "$wrapper" ]; then
  echo "$0: no wrapper at $wrapper" >&2
  echo "  build it first: bazelisk build //flow/test/macro_e12:$target" >&2
  exit 1
fi
if [ ! -d "$runfiles" ]; then
  echo "$0: no runfiles at $runfiles" >&2
  exit 1
fi

mkdir -p "$out_dir/logs"

# The wrapper creates an `external` symlink in its runfiles on first use.
# Do it once here rather than letting N workers race on it.
(cd "$runfiles" && [ -e external ] || ln -sfn "$(realpath "$runfiles/..")" "$runfiles/external")

echo "$0: $target over ${#tags[@]} candidates, $jobs at a time"

failed=0
started=0

# Reap whichever worker finishes first, rather than blocking on a
# particular one: a slow candidate must not idle the other slots.
for tag in "${tags[@]}"; do
  while [ "$(jobs -rp | wc -l)" -ge "$jobs" ]; do
    if ! wait -n; then
      failed=$((failed + 1))
    fi
  done

  (
    cd "$runfiles"
    exec "$wrapper" \
      E12_OUT_DIR="$out_dir" \
      E12_TAG="$tag" \
      RUN_LOG_NAME_STEM="run_$tag" \
      ${E12_EXTRA_ARGS:-}
  ) > "$out_dir/logs/$tag.log" 2>&1 &
  started=$((started + 1))
  echo "  [$started/${#tags[@]}] started $tag (pid $!)"
done

while [ "$(jobs -rp | wc -l)" -gt 0 ]; do
  if ! wait -n; then
    failed=$((failed + 1))
  fi
done

echo "$0: done, $failed failure(s) of ${#tags[@]}"
echo "  per-candidate logs: $out_dir/logs/<tag>.log"
exit $((failed > 0))
