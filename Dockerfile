FROM debian:stretch-slim AS builder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    build-essential=12.3 \
    libffi-dev=3.2.* \
    libgmp-dev=2:6.1.* \
    zlib1g-dev=1:1.2.* \
    curl=7.52.* \
    ca-certificates=* \
    git=1:2.11.* \
    netbase=5.4 \
 && curl -sSL https://get.haskellstack.org/ | sh \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/hadolint/
COPY hadolint/stack.yaml hadolint/package.yaml /opt/hadolint/
RUN stack --no-terminal --install-ghc test --only-dependencies

COPY ./hadolint/ /opt/hadolint
RUN scripts/fetch_version.sh \
  && stack install --ghc-options="-fPIC" --flag hadolint:static

# COMPRESS WITH UPX
RUN curl -sSL https://github.com/upx/upx/releases/download/v3.94/upx-3.94-amd64_linux.tar.xz \
  | tar -x --xz --strip-components 1 upx-3.94-amd64_linux/upx \
  && ./upx --best --ultra-brute /root/.local/bin/hadolint

# OUTPUT
FROM alpine:latest AS alpine-distro
RUN apk add nodejs npm

# DOCKERFILE
COPY --from=builder /root/.local/bin/hadolint /bin/
RUN npm i -g dockerfile-language-server-nodejs

# SH, BASH, ZSH
RUN apk add shellcheck zsh && \
    npm i -g bash-language-server
COPY ./scripts/zshwrapper /bin/zshwrapper

# PHP
RUN apk add curl php7 \
    php7-json \
    php7-openssl \
    php7-phar \
    php7-mbstring \
    php7-dom \
    php7-xml \
    php7-xmlwriter \
    php7-tokenizer \
    php7-fileinfo
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN npm i -g intelephense
RUN mkdir /root/intelephense
COPY ./licence.txt /root/intelephense/licence.txt
