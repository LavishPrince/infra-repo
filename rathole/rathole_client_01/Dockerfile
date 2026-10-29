FROM alpine:latest AS builder
RUN apk add --no-cache gettext

ARG VPS_IP
ARG VPS_PUBLIC_KEY
ARG TOKEN_SERVICE_1

COPY client.toml.template /tmp/client.toml.template
RUN envsubst < /tmp/client.toml.template > /tmp/client.toml

FROM rapiz1/rathole:latest
COPY --from=builder /tmp/client.toml /etc/rathole/client.toml
ENTRYPOINT ["/app/rathole", "--client", "/etc/rathole/client.toml"]
