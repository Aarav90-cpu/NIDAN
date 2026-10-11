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

# 3. APK Repositories (main and community for kiosk packages)
mkdir -p "$tmp"/etc/apk
makefile root:root 0644 "$tmp"/etc/apk/repositories <<EOF
https://dl-cdn.alpinelinux.org/alpine/v3.20/main
https://dl-cdn.alpinelinux.org/alpine/v3.20/community
EOF

# 4. Quiet Boot OpenRC Configuration
makefile root:root 0644 "$tmp"/etc/rc.conf <<EOF
rc_quiet="YES"
rc_verbose="NO"
EOF

# 5. Boot Screen & Login Banner in Pure White
BANNER="\033c\033[1;37m
                        _   _ ___ ____    _    _   _ 
                       | \ | |_ _|  _ \  / \  | \ | |
                       |  \| || || | | |/ _ \ |  \| |
                       | |\  || || |_| / ___ \| |\  |
                       |_| \_|___|____/_/   \_\_| \_|

                                 N I D A N
\033[0m"

makefile root:root 0644 "$tmp"/etc/issue <<EOF
$BANNER
EOF

makefile root:root 0644 "$tmp"/etc/motd <<EOF
$BANNER
EOF

# 6. Early Boot Banner Script
mkdir -p "$tmp"/usr/local/bin
makefile root:root 0755 "$tmp"/usr/local/bin/nidan-boot-banner <<EOF
#!/bin/sh
if [ -c /dev/tty1 ]; then
    printf "\033c\033[1;37m\n\n\n\n\n" > /dev/tty1 2>/dev/null || true
    printf "                        _   _ ___ ____    _    _   _ \n" > /dev/tty1 2>/dev/null || true
    printf "                       | \ | |_ _|  _ \  / \  | \ | |\n" > /dev/tty1 2>/dev/null || true
    printf "                       |  \| || || | | |/ _ \ |  \| |\n" > /dev/tty1 2>/dev/null || true
    printf "                       | |\  || || |_| / ___ \| |\  |\n" > /dev/tty1 2>/dev/null || true
    printf "                       |_| \_|___|____/_/   \_\_| \_|\n\n" > /dev/tty1 2>/dev/null || true
    printf "                                 N I D A N\n\n\033[0m" > /dev/tty1 2>/dev/null || true
fi
EOF

# 7. Inittab for OpenRC and Immediate Kiosk Launch
makefile root:root 0644 "$tmp"/etc/inittab <<EOF
::sysinit:/usr/local/bin/nidan-boot-banner
::sysinit:/sbin/openrc sysinit
::sysinit:/sbin/openrc boot
::wait:/sbin/openrc default

tty1::respawn:/sbin/getty -n -l /usr/local/bin/nidan-kiosk-session 38400 tty1
tty2::respawn:/sbin/getty 38400 tty2
tty3::respawn:/sbin/getty 38400 tty3

::ctrlaltdel:/sbin/reboot
::shutdown:/sbin/openrc shutdown
EOF

# 8. Core OpenRC Service Runlevels
rc_add devfs sysinit
rc_add dmesg sysinit
rc_add udev sysinit
rc_add udev-trigger sysinit
rc_add udev-settle sysinit
rc_add hclock boot
rc_add hwclock boot
rc_add modules boot
rc_add sysctl boot
rc_add hostname boot
rc_add bootmisc boot
rc_add syslog boot

rc_add networking default
rc_add chronyd default
rc_add seatd default
rc_add local default

# 9. Install and Enable NidanApp Service
SCRIPT_DIR="$(dirname "$0")"
if [ -f "$SCRIPT_DIR/init.d/nidan" ]; then
    mkdir -p "$tmp"/etc/init.d
    cp "$SCRIPT_DIR/init.d/nidan" "$tmp"/etc/init.d/nidan
    chmod 0755 "$tmp"/etc/init.d/nidan
    rc_add nidan default
fi

# 10. Install Compiled Application Binary
if [ -f "$SCRIPT_DIR/bin/nidan" ]; then
    mkdir -p "$tmp"/usr/local/bin
    cp "$SCRIPT_DIR/bin/nidan" "$tmp"/usr/local/bin/nidan
    chmod 0755 "$tmp"/usr/local/bin/nidan
elif [ -f "$SCRIPT_DIR/nidan" ]; then
    mkdir -p "$tmp"/usr/local/bin
    cp "$SCRIPT_DIR/nidan" "$tmp"/usr/local/bin/nidan
    chmod 0755 "$tmp"/usr/local/bin/nidan
fi

# 11. Bundle Static Web UI Assets
if [ -d "$SCRIPT_DIR/www" ]; then
    mkdir -p "$tmp"/var/lib/nidan/www
    cp -r "$SCRIPT_DIR/www/"* "$tmp"/var/lib/nidan/www/
fi

# 12. Student User Provisioning
mkdir -p "$tmp"/etc/local.d
makefile root:root 0755 "$tmp"/etc/local.d/00-nidan-user.start <<EOF
#!/bin/sh
if ! id student >/dev/null 2>&1; then
    adduser -D -h /home/student -s /bin/sh student
    echo "student:student" | chpasswd
    addgroup student audio 2>/dev/null || true
    addgroup student video 2>/dev/null || true
    addgroup student input 2>/dev/null || true
    addgroup student seat 2>/dev/null || true
fi
EOF

# 13. Kiosk Launcher Session
makefile root:root 0755 "$tmp"/usr/local/bin/nidan-kiosk-session <<EOF
#!/bin/sh
STUDENT_UID=\$(id -u student 2>/dev/null || echo 1000)
export XDG_RUNTIME_DIR="/run/user/\${STUDENT_UID}"
mkdir -p "\${XDG_RUNTIME_DIR}"
chown student:student "\${XDG_RUNTIME_DIR}"
chmod 0700 "\${XDG_RUNTIME_DIR}"

# Wait for NidanApp backend to become available on port 8080 (up to 15 seconds)
COUNTER=0
while [ \$COUNTER -lt 15 ]; do
    if nc -z 127.0.0.1 8080 >/dev/null 2>&1; then
        break
    fi
    sleep 1
    COUNTER=\$((COUNTER + 1))
done

# Launch Wayland cage kiosk running Chromium
if command -v cage >/dev/null 2>&1 && command -v chromium >/dev/null 2>&1; then
    exec su -l student -c "
        export XDG_RUNTIME_DIR=\"/run/user/\${STUDENT_UID}\"
        export WAYLAND_DISPLAY=\"wayland-0\"
        export GDK_BACKEND=wayland
        export QT_QPA_PLATFORM=wayland
        export MOZ_ENABLE_WAYLAND=1

        exec cage -s -- chromium \
            --ozone-platform-hint=auto \
            --kiosk \
            --no-first-run \
            --no-sandbox \
            --disable-infobars \
            --disable-session-crashed-bubble \
            --disable-translate \
            --disable-features=TranslateUI \
            --disable-pinch \
            --overscroll-history-navigation=0 \
            http://127.0.0.1:8080
    "
else
    echo "NIDAN Educational Platform is running at http://127.0.0.1:8080"
    sleep 2
    exec su -l student -c "exec /bin/sh"
fi
EOF

# 14. Create final apkovl archive
tar -c -C "$tmp" -z -f "$HOSTNAME.apkovl.tar.gz" .
