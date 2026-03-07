FROM alpine:latest AS builder

RUN apk add --no-cache \
    git \
    make \
    gcc \
    musl-dev \
    musl-libintl \
    openssl-dev \
    zlib-dev \
    luajit-dev
    
WORKDIR /builder
RUN git clone https://github.com/cgit/cgit.git && \
    cd cgit && \
    git submodule update --init --recursive

COPY ["cgit.conf", "/builder/cgit/cgit.conf"]
RUN |
    make && \
    make install
    
FROM nginx:stable-alpine

RUN apk add --no-cache \
    fcgiwrap \
    git \
    git-daemon \
    luajit \
    && rm -rf /var/cache/apk/*

COPY --from=builder /opt/cgit /opt/cgit