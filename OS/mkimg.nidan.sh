profile_nidan() {
    profile_standard
    profile_abbrev="nidan"
    title="NIDAN OS"
    desc="NIDAN Adaptive Offline Education Platform (Alpine Linux Base)"
    image_ext="iso"
    arch="x86_64"
    output_format="iso"
    kernel_cmdline="modules=loop,squashfs,sd-mod,usb-storage quiet loglevel=0 console=tty1 vt.global_cursor_default=0"
    syslinux_serial=""
    syslinux_timeout=1
    syslinux_prompt=0
    hostname="nidan"
    modloop_sign=no
    apkovl="genapkovl-nidan.sh"
    apks="$apks
        alpine-base
        busybox
        openrc
        eudev
        udev-init-scripts
        linux-lts
        linux-firmware-none
        chrony
        tzdata
        sudo
        iproute2
        wpa_supplicant
        alsa-utils
        sqlite
        gcompat
        cage
        seatd
        seatd-openrc
        chromium
        mesa-dri-gallium
        font-dejavu
    "
}
