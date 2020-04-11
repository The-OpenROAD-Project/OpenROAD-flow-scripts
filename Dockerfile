FROM centos:centos7 AS base-dependencies
LABEL maintainer="Abdelrahman Hosny <abdelrahman_hosny@brown.edu>"

RUN yum group install -y "Development Tools" && \
    yum update -y && yum install -y libffi-devel python3 tcl-devel which time && \
    yum localinstall https://www.klayout.org/downloads/CentOS_7/klayout-0.26.4-0.x86_64.rpm -y

WORKDIR /OpenROAD-flow
RUN mkdir -p /OpenROAD-flow

COPY --from=openroad /OpenROAD/build ./tools/build/OpenROAD
COPY --from=openroad/yosys /build ./tools/build/yosys
COPY --from=openroad/tritonroute /build ./tools/build/TritonRoute
COPY ./setup_env.sh .
COPY ./flow ./flow
RUN chmod o+rw -R /OpenROAD-flow/flow
