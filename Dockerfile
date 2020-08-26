FROM alpine:latest

RUN apk update && apk add --no-cache \
        ca-certificates \
        bash \
        curl \
        rsync \
        openssh \
        git \
    && rm -rf /var/cache/apk/*

# Run unprivileged
USER nobody

# Expose port 8730 rather than default 873
EXPOSE 8730

# Run rsync in daemon mode
CMD ["rsync", "--daemon", "--no-detach", "--verbose", "--log-file=/dev/stdout", "--port=8730"]
