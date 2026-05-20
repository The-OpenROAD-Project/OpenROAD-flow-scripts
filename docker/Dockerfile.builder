# syntax=docker/dockerfile:1.7-labs

# Target with dependencies to build all flow tools from their sources.
# i.e., "./build_openroad.sh --local" from inside a docker container
# NOTE: don't use this file directly unless you know what you are doing,
# instead use etc/DockerHelper.sh

ARG fromImage=openroad/flow-ubuntu22.04-dev:latest

FROM $fromImage AS orfs-base

WORKDIR /OpenROAD-flow-scripts
COPY --link dev_env.sh dev_env.sh
COPY --link build_openroad.sh build_openroad.sh

FROM orfs-base AS orfs-builder-base

# Add compiler wrapper scripts for reproducible builds
COPY --link etc/setup_compiler_wrappers.sh /tmp/
RUN sh /tmp/setup_compiler_wrappers.sh && rm /tmp/setup_compiler_wrappers.sh

# Prepend wrapper directory to PATH so they override system compilers
ENV PATH="/usr/local/bin/wrapped-cc:$PATH"

COPY --link tools tools
ARG numThreads=$(nproc)
ARG openroadVersion=NotSet
ARG verificPath=""

RUN <<EOF
set -e
echo "" > tools/yosys/abc/.gitcommit
if [ -n "${verificPath}" ]; then
    verificArgs="--with-verific ${verificPath}"
else
    verificArgs=""
fi
./build_openroad.sh --no_init \
                    --local \
                    --threads ${numThreads} \
                    --openroad-args -DOPENROAD_VERSION=${openroadVersion} \
                    ${verificArgs}
if [ -n "${verificPath}" ]; then
    rm -rf "${verificPath}"
fi
EOF

# Collect LICENSE files from tool source trees into the install directory so
# they are available in the final image. tools/OpenROAD/src/sta is excluded
# because it is covered by a separate commercial license agreement.
RUN find /OpenROAD-flow-scripts/tools \( -name "*LICENSE*" -o -name "*LICENSES*" \) \
    | grep -v '/OpenROAD/src/sta/' \
    | grep -v '/AutoTuner/' \
    | while read -r f; do \
        rel="${f#/OpenROAD-flow-scripts/tools/}"; \
        mkdir -p "/OpenROAD-flow-scripts/tools/install/licenses/$(dirname "$rel")"; \
        cp -r "$f" "/OpenROAD-flow-scripts/tools/install/licenses/$rel"; \
    done

FROM orfs-base

# The order for copying the directories is based on the frequency of changes (ascending order),
# and the layer size (descending order)
COPY --link docker docker
COPY --link flow/tutorials flow/tutorials
COPY --link docs docs
COPY --link flow/test flow/test
COPY --link flow/platforms flow/platforms
COPY --link flow/util flow/util
COPY --link flow/scripts flow/scripts
COPY --link flow/designs flow/designs
COPY --link tools/AutoTuner tools/AutoTuner

COPY --link --from=orfs-builder-base /OpenROAD-flow-scripts/tools/install tools/install
COPY --link \
     --exclude=.git* --exclude=tools/ --exclude=docs/ --exclude=docker/ \
     --exclude=flow/designs --exclude=flow/platforms --exclude=flow/scripts \
     --exclude=flow/test --exclude=flow/tutorials --exclude=flow/util \
  . ./
