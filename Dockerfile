FROM debian:latest AS builder

LABEL maintainer "LJason <ljason@ljason77.com>"

RUN apt -qq update && \
    apt install -yqq --no-install-recommends git cmake python3 ca-certificates build-essential wget && \
    apt clean && \
    rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

RUN wget https://factorio.com/get-download/stable/headless/linux64 -O factorio_headless_x64.tar.xz && \
    tar Jxf factorio_headless_x64.tar.xz && \
    rm -rf factorio_headless_x64.tar.xz

RUN git clone --depth=1 https://github.com/ptitSeb/box64 && mkdir box64/build

WORKDIR box64/build

RUN cmake .. -D ARM_DYNAREC=ON -D RPI4ARM64=1 -D CMAKE_BUILD_TYPE=RelWithDebInfo && \
    make -j4 && \
    make install DESTDIR=/tmp/install

FROM debian:latest

LABEL maintainer "LJason <ljason@ljason77.com>"

COPY --from=builder /tmp/install /
COPY --from=builder --chown=1000:1000 /factorio /factorio

RUN groupadd --gid 1000 pi && \
    useradd --uid 1000 --gid 1000 -m pi

USER pi

WORKDIR /factorio

ENV BOX64_DYNAREC 1
ENV BOX64_NOBANNER 1
ENV BOX64_TRACE_FILE BOX64.log

ENTRYPOINT ["box64", "bin/x64/factorio"]