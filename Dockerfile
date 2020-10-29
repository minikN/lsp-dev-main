FROM node:10.23-alpine

# bash, sh, zsh
RUN apk add shellcheck zsh && \
    npm i -g bash-language-server
COPY ./scripts/zshwrapper /bin/zshwrapper

# Dockerfile
RUN npm i -g dockerfile-language-server-nodejs

# PHP
RUN apk add curl php7 \
    php7-json \
    php7-openssl \
    php7-phar \
    php7-mbstring \
    php7-dom \
    php7-xml \
    php7-xmlwriter \
    php7-tokenizer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN npm i -g intelephense
RUN mkdir /root/intelephense
COPY ./licence.txt /root/intelephense/licence.txt
