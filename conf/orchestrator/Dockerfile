# Use stable release of orchestrator
FROM openarkcode/orchestrator:latest

# Needed because upstream Dockerfile doesn't create this directory, so our config
# breaks the container.
RUN mkdir -p /var/lib/orchestrator
