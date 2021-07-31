FROM openroad/yosys-dev AS builder
COPY . /yosys
WORKDIR /yosys
RUN make PREFIX=/install CONFIG=gcc install -j$(nproc)
