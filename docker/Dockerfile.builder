# Target with dependencies to build all flow tools from their sources.
# i.e., "./build_openroad.sh --local" from inside a docker container
# NOTE: don't use this file directly unless you know what you are doing,
# instead use etc/DockerHelper.sh
ARG fromImage=openroad/flow-centos7-dev:latest

FROM $fromImage

ARG numThreads=$(nproc)

COPY . /OpenROAD-flow-scripts
WORKDIR /OpenROAD-flow-scripts

RUN ./build_openroad.sh --no_init --local --threads ${numThreads}
