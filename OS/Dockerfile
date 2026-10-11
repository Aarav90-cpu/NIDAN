FROM alpine:3.20

# Install dependencies required for Alpine ISO generation and package compilation
RUN apk update && apk add --no-cache \
    alpine-sdk \
    alpine-conf \
    fakeroot \
    mkinitfs \
    grub \
    grub-efi \
    xorriso \
    syslinux \
    mtools \
    squashfs-tools \
    dosfstools \
    bash \
    git \
    openrc \
    coreutils \
    tzdata \
    sudo

# Configure build environment and permissions
RUN addgroup -S abuild 2>/dev/null || true && \
    adduser -D -G abuild builder && \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    git config --global --add safe.directory '*'

WORKDIR /workspace

CMD ["/bin/bash"]
