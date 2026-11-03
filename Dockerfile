# Target with dependencies and the binaries to run the complete flow
FROM openroad/flow-dev

WORKDIR /OpenROAD-flow-scripts

# synthesis tools binaries and plugins
COPY --from=openroad/yosys /install ./tools/install/yosys

# openroad binary, and yaml2json, which the flow reads variables.yaml with
COPY --from=openroad/ubuntu22.04-builder-gcc \
    /OpenROAD/install/bin/openroad \
    /OpenROAD/install/bin/yaml2json \
    ./tools/install/OpenROAD/bin/

# flow files
COPY ./env.sh .
COPY ./flow ./flow

# avoid issues with permissions
RUN chmod o+rw -R /OpenROAD-flow-scripts
