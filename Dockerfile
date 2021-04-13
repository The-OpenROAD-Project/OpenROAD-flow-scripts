FROM centos:centos7 AS base-dependencies
LABEL maintainer="Abdelrahman Hosny <abdelrahman_hosny@brown.edu>"

RUN yum group install -y "Development Tools" && \
    yum update -y && yum install -y libffi-devel python3 tcl-devel which time && \
    yum install https://www.klayout.org/downloads/CentOS_7/klayout-0.26.4-0.x86_64.rpm -y && \
    yum install -y qt5-qtbase-devel

RUN yum install -y libXft libXScrnSaver

WORKDIR /OpenROAD-flow
RUN mkdir -p /OpenROAD-flow

COPY --from=openroad/centos7-builder-gcc /OpenROAD/build ./tools/build/OpenROAD
COPY --from=openroad/yosys /build ./tools/build/yosys
COPY --from=openroad/lsoracle /LSOracle ./tools/build/LSOracle
COPY --from=openroad/lsoracle /LSOracle/core/test.ini /usr/local/share/lsoracle/
COPY --from=openroad/lsoracle /LSOracle-plugin/oracle.so /OpenROAD-flow/tools/build/yosys/share/yosys/plugins/
COPY ./setup_env.sh .
COPY ./flow ./flow
RUN chmod o+rw -R /OpenROAD-flow/flow
