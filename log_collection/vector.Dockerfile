FROM alpine:3.20 AS builder

RUN apk add --no-cache gettext

COPY vector.yaml /tmp/vector.template.yaml

RUN envsubst < /tmp/vector.template.yaml > /tmp/vector.yaml

FROM timberio/vector:latest-alpine

COPY --from=builder /tmp/vector.yaml /etc/vector/vector.yaml