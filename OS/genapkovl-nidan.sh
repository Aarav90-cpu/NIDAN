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
rc_add modloop sysinit
rc_add udev sysinit
rc_add udev-trigger sysinit
rc_add udev-settle sysinit
rc_add hwdrivers sysinit

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

rc_add mount-ro shutdown
rc_add killprocs shutdown
rc_add savecache shutdown

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
mkdir -p "$tmp"/var/lib/nidan/www
if [ -d "$SCRIPT_DIR/www" ] && [ -n "$(ls -A "$SCRIPT_DIR/www" 2>/dev/null)" ]; then
    cp -r "$SCRIPT_DIR/www/"* "$tmp"/var/lib/nidan/www/
fi

# Ensure standalone fallback UI exists if assets were not packaged
if [ ! -f "$tmp"/var/lib/nidan/www/index.html ]; then
    makefile root:root 0644 "$tmp"/var/lib/nidan/www/index.html <<'EOF_HTML'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>NIDAN - Offline Educational Platform</title>
  <style>
    :root {
      --bg: #0f172a;
      --card-bg: #1e293b;
      --text-main: #f8fafc;
      --text-sub: #94a3b8;
      --primary: #38bdf8;
      --accent: #10b981;
      --border: #334155;
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      background: var(--bg);
      color: var(--text-main);
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 2rem;
    }
    .container {
      max-width: 720px;
      width: 100%;
      background: var(--card-bg);
      border: 1px solid var(--border);
      border-radius: 16px;
      padding: 2.5rem;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
      text-align: center;
    }
    .logo {
      font-size: 2.5rem;
      font-weight: 800;
      letter-spacing: 0.25em;
      color: var(--text-main);
      margin-bottom: 0.5rem;
    }
    .subtitle {
      font-size: 1.1rem;
      color: var(--primary);
      margin-bottom: 2rem;
      font-weight: 500;
    }
    .status-badge {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.5rem 1rem;
      border-radius: 9999px;
      background: rgba(16, 185, 129, 0.15);
      color: var(--accent);
      font-size: 0.875rem;
      font-weight: 600;
      margin-bottom: 2rem;
      border: 1px solid rgba(16, 185, 129, 0.3);
    }
    .status-dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: var(--accent);
      box-shadow: 0 0 8px var(--accent);
    }
    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
      gap: 1rem;
      margin-top: 1.5rem;
      text-align: left;
    }
    .card {
      background: rgba(15, 23, 42, 0.6);
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 1.25rem;
    }
    .card h3 {
      font-size: 1rem;
      color: var(--text-main);
      margin-bottom: 0.35rem;
    }
    .card p {
      font-size: 0.85rem;
      color: var(--text-sub);
      line-height: 1.4;
    }
    .footer {
      margin-top: 2rem;
      font-size: 0.8rem;
      color: var(--text-sub);
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="logo">N I D A N</div>
    <div class="subtitle">Adaptive Offline Education Platform</div>
    <div class="status-badge" id="status-badge">
      <span class="status-dot"></span>
      <span id="status-text">System Active: Alpine Appliance Kiosk</span>
    </div>
    <div class="grid">
      <div class="card">
        <h3>Diagnostic</h3>
        <p>Adaptive diagnostic assessments tailored for student foundational mastery.</p>
      </div>
      <div class="card">
        <h3>Learning</h3>
        <p>Interactive practice modules designed for offline classroom continuity.</p>
      </div>
      <div class="card">
        <h3>Progress</h3>
        <p>Private, local mastery tracking without requiring active network connectivity.</p>
      </div>
    </div>
    <div class="footer">
      NIDAN OS &bull; Offline-First Appliance
    </div>
  </div>

  <script>
    function checkBackend() {
      fetch('http://127.0.0.1:8080/api/status', { mode: 'cors' })
        .then(response => {
          if (response.ok) {
            document.getElementById('status-text').textContent = 'Connecting to NIDAN Service...';
            window.location.href = 'http://127.0.0.1:8080/';
          }
        })
        .catch(() => {
          setTimeout(checkBackend, 2000);
        });
    }
    checkBackend();
  </script>
</body>
</html>
EOF_HTML
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
makefile root:root 0755 "$tmp"/usr/local/bin/nidan-kiosk-session <<'EOF'
#!/bin/sh
STUDENT_UID=$(id -u student 2>/dev/null || echo 1000)
export XDG_RUNTIME_DIR="/run/user/${STUDENT_UID}"
mkdir -p "${XDG_RUNTIME_DIR}"
chown student:student "${XDG_RUNTIME_DIR}"
chmod 0700 "${XDG_RUNTIME_DIR}"

# Check if NidanApp backend is responding on port 8080; default to local offline bundle
START_URL="file:///var/lib/nidan/www/index.html"
if nc -z 127.0.0.1 8080 >/dev/null 2>&1; then
    START_URL="http://127.0.0.1:8080"
fi

# Launch Wayland cage kiosk running Chromium
if command -v cage >/dev/null 2>&1 && command -v chromium >/dev/null 2>&1; then
    exec su -l student -c "
        export XDG_RUNTIME_DIR=\"/run/user/${STUDENT_UID}\"
        export WAYLAND_DISPLAY=\"wayland-0\"
        export LIBSEAT_BACKEND=\"seatd\"
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
            \"${START_URL}\"
    "
else
    echo "NIDAN Educational Platform is running at http://127.0.0.1:8080"
    sleep 2
    exec su -l student -c "exec /bin/sh"
fi
EOF

# 14. Create final apkovl archive
tar -c -C "$tmp" -z -f "$HOSTNAME.apkovl.tar.gz" .
