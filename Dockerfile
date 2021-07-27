# Target with dependencies to build all flow tools from their sources.
# i.e., "./build_openroad.sh --local" from inside a docker container
FROM openroad/centos7-dev AS flow-dev
RUN yum update -y \
    && yum install -y https://www.klayout.org/downloads/CentOS_7/klayout-0.27.1-0.x86_64.rpm \
    && yum install -y libffi-devel time \
    && pip3 install pandas

# Target with dependencies to run all flow tools from their pre-compiled
# binaries.
FROM openroad/centos7-runtime AS flow-runtime
RUN yum update -y \
    && yum install -y https://www.klayout.org/downloads/CentOS_7/klayout-0.27.1-0.x86_64.rpm \
    && yum install -y time \
    && pip3 install pandas

# Target with dependencies and the binaries to run the complete flow
FROM openroad/flow-runtime AS flow-scripts

WORKDIR /OpenROAD-flow-scripts

# synthesis tools binaries and plugins
COPY --from=openroad/yosys /install ./tools/install/yosys
COPY --from=openroad/lsoracle /LSOracle/build/core/lsoracle ./tools/build/LSOracle/bin/lsoracle
COPY --from=openroad/lsoracle /LSOracle/core/test.ini ./tools/build/LSOracle/share/lsoracle/test.ini
COPY --from=openroad/lsoracle /LSOracle/build/yosys-plugin/oracle.so /OpenROAD-flow/tools/build/yosys/share/yosys/plugins/

# openroad binary
COPY --from=openroad/centos7-builder-gcc /OpenROAD/build/src/openroad ./tools/install/OpenROAD/bin/openroad

# flow files
COPY ./setup_env.sh .
COPY ./flow ./flow

# avoid issues with permissions
RUN chmod o+rw -R /OpenROAD-flow-scripts
