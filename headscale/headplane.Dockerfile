FROM tale/headplane:latest

# Copy configuration directly into Headplane's expected directory
COPY config.json /app/config/config.json

EXPOSE 3000
