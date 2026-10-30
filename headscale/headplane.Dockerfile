FROM ghcr.io/tale/headplane:latest

# Copy configuration directly into Headplane's expected directory
COPY head-plane-config.yaml /app/config/config.yaml

EXPOSE 3000
