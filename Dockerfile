FROM alpine:latest

RUN apk update && apk add --no-cache \
        ca-certificates \
        bash \
        curl \
        rsync \
        openssh \
    && rm -rf /var/cache/apk/*
