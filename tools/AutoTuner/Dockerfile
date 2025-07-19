ARG BASE_IMAGE
FROM ${BASE_IMAGE:-openroad/orfs:latest}

# Set workdir
WORKDIR /OpenROAD-flow-scripts/tools/AutoTuner

# Replace pre-existing AT files with local copy
RUN rm -rf /OpenROAD-flow-scripts/tools/AutoTuner

# Create venv
RUN python3 -m venv .venv
ENV PATH="/OpenROAD-flow-scripts/tools/AutoTuner/.venv:${PATH}"

# Copy only requirements first for better caching of pip install
COPY requirements.txt .

# Upgrade pip and install Python dependencies
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

# Copy full source after installing dependencies
COPY . .

# Install package in editable mode
RUN pip3 install --no-cache-dir -e .
