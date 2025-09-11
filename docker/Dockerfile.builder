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

# Inject compiler wrapper scripts that append the macros
RUN mkdir -p /usr/local/bin/wrapped-cc && \
    echo '#!/bin/sh' > /usr/local/bin/wrapped-cc/gcc && \
    echo 'exec /usr/bin/gcc -D__TIME__="\"0\"" -D__DATE__="\"0\"" -D__TIMESTAMP__="\"0\"" -Wno-builtin-macro-redefined "$@"' >> /usr/local/bin/wrapped-cc/gcc && \
    chmod +x /usr/local/bin/wrapped-cc/gcc && \
    ln -sf /usr/local/bin/wrapped-cc/gcc /usr/local/bin/wrapped-cc/cc && \
    echo '#!/bin/sh' > /usr/local/bin/wrapped-cc/g++ && \
    echo 'exec /usr/bin/g++ -D__TIME__="\"0\"" -D__DATE__="\"0\"" -D__TIMESTAMP__="\"0\"" -Wno-builtin-macro-redefined "$@"' >> /usr/local/bin/wrapped-cc/g++ && \
    chmod +x /usr/local/bin/wrapped-cc/g++

# Prepend wrapper directory to PATH so they override system compilers
ENV PATH="/usr/local/bin/wrapped-cc:$PATH"

COPY --link tools tools
ARG numThreads=$(nproc)
ARG openroadVersion=NotSet

RUN echo "" > tools/yosys/abc/.gitcommit && \
  ./build_openroad.sh --no_init --local --threads ${numThreads} --openroad-args -DOPENROAD_VERSION=${openroadVersion}

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
