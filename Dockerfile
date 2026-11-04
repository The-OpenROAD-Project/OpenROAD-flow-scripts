# Target with dependencies and the binaries to run the complete flow
FROM openroad/flow-ubuntu26.04-dev:latest

WORKDIR /OpenROAD-flow-scripts

# Flow tools built for the same Ubuntu release as the runtime image.
COPY --from=openroad/flow-ubuntu26.04-tools:latest \
    /OpenROAD-flow-scripts/tools/install ./tools/install

# OpenROAD binary and its installed libraries.
COPY --from=openroad/ubuntu26.04:latest \
    /OpenROAD/install ./tools/install/OpenROAD

# flow files
COPY ./env.sh .
COPY ./flow ./flow

# Allow users of the image to write flow results.
RUN chmod -R a+rwX /OpenROAD-flow-scripts/flow
