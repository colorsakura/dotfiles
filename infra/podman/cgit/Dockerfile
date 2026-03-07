FROM alpine:latest AS builder
ARG CGIT_VERSION=v1.3

# To avoid conflict: undeclared REG_STARTEND compiling git with musl
# https://github.com/git/git/blob/23b219f8e3f2adfb0441e135f0a880e6124f766c/git-compat-util.h#L1279-L1281
ENV NO_REGEX=NeedsStartEnd

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
RUN git clone https://github.com/zx2c4/cgit.git . \
    && git checkout ${CGIT_VERSION} \
    && git submodule update --init --recursive
    
RUN make && \
    make install

# =============================================================================

FROM nginx:stable-alpine

RUN apk add --no-cache \
    fcgiwrap \
    git \
    git-daemon \
    luajit \
    && rm -rf /var/cache/apk/*

COPY ./rootfs/ /

# 复制 CGit 文件
COPY --from=builder /var/www/htdocs/cgit /var/www/cgit
COPY --from=builder /usr/local/lib/cgit/ /usr/lib/cgit

VOLUME ["/repo"]
EXPOSE 80