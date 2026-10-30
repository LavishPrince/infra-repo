FROM headscale/headscale:latest

# Headscale reads /etc/headscale/config.yaml by default. Keep the config out of
# /var/lib/headscale so the named data volume cannot shadow it.
COPY config.yaml /etc/headscale/config.yaml

CMD ["serve"]
