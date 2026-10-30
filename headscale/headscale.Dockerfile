FROM headscale/headscale:latest

# Create directory for config if not present

COPY config.yaml /etc/headscale/config.yaml


ENTRYPOINT ["headscale"]
CMD ["serve"]
