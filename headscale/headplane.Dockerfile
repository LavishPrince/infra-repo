FROM ghcr.io/tale/headplane:latest

# Copy configuration directly into Headplane's expected directory
COPY head-plane-config.yaml /etc/headplane/config.yaml

# Headplane reads Headscale's config from headscale.config_path; bake a copy in
# so no bind mount is required.
COPY config.yaml /etc/headscale/config.yaml

EXPOSE 3000
