profile_nidan() {
    profile_standard
    profile_abbrev="nidan"
    title="NIDAN OS"
    desc="NIDAN Adaptive Offline Education Platform (Alpine Linux Base)"
    image_ext="iso"
    arch="x86_64"
    output_format="iso"
    kernel_cmdline="modules=loop,squashfs,sd-mod,usb-storage quiet console=tty1"
    syslinux_serial=""
    hostname="nidan"
    modloop_sign=no
    apkovl="genapkovl-nidan.sh"
    apks="$apks
        alpine-base
        busybox
        openrc
        eudev
        linux-lts
        linux-firmware-none
        chrony
        tzdata
        sudo
        iproute2
        wpa_supplicant
        alsa-utils
        sqlite
    "
}
