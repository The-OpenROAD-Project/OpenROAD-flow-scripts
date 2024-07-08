# Target with dependencies to build all flow tools from their sources.
# i.e., "./build_openroad.sh --local" from inside a docker container
# NOTE: don't use this file directly unless you know what you are doing,
# instead use etc/DockerHelper.sh
ARG fromImage=openroad/flow-ubuntu22.04-dev:latest

FROM $fromImage AS openroad-builder-base

ARG numThreads=$(nproc)

COPY . /OpenROAD-flow-scripts
WORKDIR /OpenROAD-flow-scripts

RUN ./build_openroad.sh --no_init --local --threads ${numThreads}

FROM $fromImage AS openroad-flow-scripts-base

COPY . /OpenROAD-flow-scripts

RUN rm -rf /OpenROAD-flow-scripts/tools /OpenROAD-flow-scripts/.git

COPY --from=openroad-builder-base /OpenROAD-flow-scripts/tools/install /OpenROAD-flow-scripts/tools/install

FROM $fromImage

COPY --from=openroad-flow-scripts-base /OpenROAD-flow-scripts /OpenROAD-flow-scripts
WORKDIR /OpenROAD-flow-scripts
