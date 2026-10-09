# NIDAN Minimal Session Launch
# Automatically launch the Wayland compositor when logging in on tty1
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    echo "Starting NIDAN session..."
    exec cage -- /usr/local/bin/nidan-app
fi
