# Target with dependencies and the binaries to run the complete flow
FROM openroad/flow-dev

WORKDIR /OpenROAD-flow-scripts

# synthesis tools binaries and plugins
COPY --from=openroad/yosys /install ./tools/install/yosys
COPY --from=openroad/lsoracle /LSOracle/build/core/lsoracle ./tools/build/LSOracle/bin/lsoracle
COPY --from=openroad/lsoracle /LSOracle/core/test.ini ./tools/build/LSOracle/share/lsoracle/test.ini
COPY --from=openroad/lsoracle /LSOracle/build/yosys-plugin/oracle.so /OpenROAD-flow/tools/build/yosys/share/yosys/plugins/

# openroad binary
COPY --from=openroad/centos7-builder-gcc /OpenROAD/build/src/openroad ./tools/install/OpenROAD/bin/openroad

# flow files
COPY ./env.sh .
COPY ./flow ./flow

# avoid issues with permissions
RUN chmod o+rw -R /OpenROAD-flow-scripts
