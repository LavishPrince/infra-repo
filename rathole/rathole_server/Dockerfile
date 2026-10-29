FROM alpine:latest AS builder
RUN apk add --no-cache gettext

ARG TOKEN_SERVICE_1
# ARG TOKEN_SERVICE_2
ARG VPS_PRIVATE_KEY

COPY server.toml.template /tmp/server.toml.template
RUN envsubst < /tmp/server.toml.template > /tmp/server.toml

FROM rapiz1/rathole:latest
COPY --from=builder /tmp/server.toml /etc/rathole/server.toml
ENTRYPOINT ["/app/rathole", "--server", "/etc/rathole/server.toml"]
