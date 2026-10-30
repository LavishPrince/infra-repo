FROM headscale/headscale:latest

# Create directory for config if not present
USER root
RUN mkdir -p /etc/headscale

# Copy the embedded configuration file into the container
COPY config.yaml /etc/headscale/config.yaml

# Revert to the default non-root user for security
USER headscale

ENTRYPOINT ["headscale"]
CMD ["serve"]
