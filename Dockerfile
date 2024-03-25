FROM debian:latest AS builder

LABEL maintainer "LJason <ljason@ljason77.com>"

RUN apt -qq update && \
    apt install -yqq --no-install-recommends wget ca-certificates xz-utils && \
    apt clean && \
    rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

RUN wget -q https://factorio.com/get-download/stable/headless/linux64 -O factorio_headless_x64.tar.xz && \
    tar Jxf factorio_headless_x64.tar.xz && \
    rm -rf factorio_headless_x64.tar.xz

FROM debian:latest

LABEL maintainer "LJason <ljason@ljason77.com>"

COPY --from=builder --chown=1000:1000 /factorio /factorio

RUN groupadd --gid 1000 pi && \
    useradd --uid 1000 --gid 1000 -m pi

USER pi

WORKDIR /factorio

ENTRYPOINT ["bin/x64/factorio"]