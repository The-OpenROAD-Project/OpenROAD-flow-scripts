FROM openroad/yosys-dev AS builder
COPY . /yosys
WORKDIR /yosys
RUN make PREFIX=/install CONFIG=gcc ABCREV=62180f3 ABCURL=https://github.com/berkeley-abc/abc install -j$(nproc)
