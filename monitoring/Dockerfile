FROM prom/prometheus:latest

# Copy your local configuration into the container's expected path
COPY prometheus.yml /etc/prometheus/prometheus.yml

# Hardcode the configuration paths and retention limits
CMD [ "--config.file=/etc/prometheus/prometheus.yml", \
      "--storage.tsdb.path=/prometheus", \
      "--storage.tsdb.retention.time=15d", \
      "--storage.tsdb.retention.size=20GB" ]
