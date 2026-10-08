# ~/NIDAN/OS/Dockerfile
FROM debian:stable

# Install live-build system dependencies once and for all
RUN apt-get update && apt-get install -y \
    live-build \
    xorriso \
    squashfs-tools \
    nano \
    sudo \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Keep the entrypoint interactive or open for execution overrides
CMD ["/bin/bash"]
