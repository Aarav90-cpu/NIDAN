#!/bin/sh -e

HOSTNAME="$1"
if [ -z "$HOSTNAME" ]; then
    HOSTNAME="nidan"
fi

cleanup() {
    rm -rf "$tmp"
}

makefile() {
    OWNER="$1"
    PERMS="$2"
    FILENAME="$3"
    cat > "$FILENAME"
    chown "$OWNER" "$FILENAME"
    chmod "$PERMS" "$FILENAME"
}

rc_add() {
    mkdir -p "$tmp"/etc/runlevels/"$2"
    ln -sf /etc/init.d/"$1" "$tmp"/etc/runlevels/"$2"/"$1"
}

tmp="$(mktemp -d)"
trap cleanup EXIT

# 1. System Hostname
mkdir -p "$tmp"/etc
makefile root:root 0644 "$tmp"/etc/hostname <<EOF
$HOSTNAME
EOF

# 2. Network Loopback & DHCP
mkdir -p "$tmp"/etc/network
makefile root:root 0644 "$tmp"/etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF

# 3. Welcome Message
makefile root:root 0644 "$tmp"/etc/motd <<EOF
Welcome to NIDAN Educational Platform (Alpine Linux Base)
Adaptive Offline-First Learning Infrastructure
EOF

# 4. Inittab for OpenRC
makefile root:root 0644 "$tmp"/etc/inittab <<EOF
::sysinit:/sbin/openrc sysinit
::sysinit:/sbin/openrc boot
::wait:/sbin/openrc default

tty1::respawn:/sbin/getty -n -l /usr/local/bin/nidan-kiosk-session 38400 tty1
tty2::respawn:/sbin/getty 38400 tty2
tty3::respawn:/sbin/getty 38400 tty3

::ctrlaltdel:/sbin/reboot
::shutdown:/sbin/openrc shutdown
EOF

# 5. Core OpenRC Service Runlevels
rc_add devfs sysinit
rc_add dmesg sysinit
rc_add mdev sysinit
rc_add hclock boot
rc_add hwclock boot
rc_add modules boot
rc_add sysctl boot
rc_add hostname boot
rc_add bootmisc boot
rc_add syslog boot

rc_add networking default
rc_add chronyd default
rc_add local default

# 6. Install and enable NidanApp service if present
SCRIPT_DIR="$(dirname "$0")"
if [ -f "$SCRIPT_DIR/init.d/nidan" ]; then
    mkdir -p "$tmp"/etc/init.d
    cp "$SCRIPT_DIR/init.d/nidan" "$tmp"/etc/init.d/nidan
    chmod 0755 "$tmp"/etc/init.d/nidan
    rc_add nidan default
fi

if [ -f "$SCRIPT_DIR/bin/nidan" ]; then
    mkdir -p "$tmp"/usr/local/bin
    cp "$SCRIPT_DIR/bin/nidan" "$tmp"/usr/local/bin/nidan
    chmod 0755 "$tmp"/usr/local/bin/nidan
elif [ -f "$SCRIPT_DIR/nidan" ]; then
    mkdir -p "$tmp"/usr/local/bin
    cp "$SCRIPT_DIR/nidan" "$tmp"/usr/local/bin/nidan
    chmod 0755 "$tmp"/usr/local/bin/nidan
fi

# 7. Student User Provisioning
mkdir -p "$tmp"/etc/local.d
makefile root:root 0755 "$tmp"/etc/local.d/00-nidan-user.start <<EOF
#!/bin/sh
if ! id student >/dev/null 2>&1; then
    adduser -D -h /home/student -s /bin/sh student
    echo "student:student" | chpasswd
    addgroup student audio 2>/dev/null || true
    addgroup student video 2>/dev/null || true
    addgroup student input 2>/dev/null || true
fi
EOF

# 8. Kiosk Launcher Session
mkdir -p "$tmp"/usr/local/bin
makefile root:root 0755 "$tmp"/usr/local/bin/nidan-kiosk-session <<EOF
#!/bin/sh
exec su -l student -c "exec /bin/sh"
EOF

# 9. Create final apkovl archive
tar -c -C "$tmp" -z -f "$HOSTNAME.apkovl.tar.gz" .
