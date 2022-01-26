FROM openroad/yosys-dev AS builder
COPY . /yosys
WORKDIR /yosys
RUN make PREFIX=/install CONFIG=gcc ABCREV=bafd2a7 ABCURL=https://github.com/berkeley-abc/abc install -j$(nproc)
