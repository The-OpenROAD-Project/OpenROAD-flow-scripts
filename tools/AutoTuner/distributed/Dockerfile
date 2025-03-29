ARG BASE_IMAGE
FROM ${BASE_IMAGE:-openroad/orfs:latest}

# Customize this based on the user's needs
ENV GOOGLE_APPLICATION_CREDENTIALS=/OpenROAD-flow-scripts/service_account.json

# Install AT required packages
WORKDIR /OpenROAD-flow-scripts/tools/AutoTuner
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir -r requirements-dev.txt

# Install rsync (https://github.com/ray-project/ray/issues/40566)
# ssh: to communicate with other nodes within image.
# sudo: for grpc calls in ray.
RUN apt-get update && \
    apt-get install -y rsync openssh-client sudo && \
    rm -rf /var/lib/apt/lists/*

# Replace pre-existing AT files with local copy
RUN rm -rf /OpenROAD-flow-scripts/tools/AutoTuner
COPY . /OpenROAD-flow-scripts/tools/AutoTuner

# Install AT package in editable mode
RUN pip3 install --no-cache-dir -e .
