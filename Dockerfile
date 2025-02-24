# Target with dependencies and the binaries to run the complete flow
FROM openroad/flow-dev

WORKDIR /OpenROAD-flow-scripts

# synthesis tools binaries and plugins
COPY --from=openroad/yosys /install ./tools/install/yosys

# openroad binary
COPY --from=openroad/ubuntu22.04-builder-gcc /OpenROAD/build/src/openroad ./tools/install/OpenROAD/bin/openroad

# flow files
COPY ./env.sh .
COPY ./flow ./flow

# avoid issues with permissions
RUN chmod o+rw -R /OpenROAD-flow-scripts
