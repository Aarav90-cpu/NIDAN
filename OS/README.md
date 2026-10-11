# NIDAN OS Build System (Alpine Linux Base)

This directory contains the build configuration for constructing the custom NIDAN operating system image, built on Alpine Linux (x86_64).

Per [ADR 009](../docs/adr/009-switch-to-alpine-linux.md), Alpine Linux provides a minimal, musl-native foundation designed for rapid compilation and low resource consumption on T1 student devices and T2 classroom hubs.

---

## Directory Contents

- `Dockerfile`: Container definition providing a clean Alpine Linux build environment with `alpine-sdk`, `xorriso`, `syslinux`, `mtools`, and `squashfs-tools`.
- `build.sh`: Orchestration script that builds the Docker builder container (if on a non-Alpine host) and triggers the Alpine `mkimage.sh` pipeline.
- `mkimg.nidan.sh`: Alpine image profile defining the base package manifest, kernel version, and output specifications.
- `genapkovl-nidan.sh`: Alpine Package Overlay (apkovl) generator script that sets up host identity, networking, OpenRC runlevels, and user accounts.
- `init.d/nidan`: OpenRC service script to supervise the NidanApp backend process.

---

## Building the Image

### Automatic Build (Docker-Delegated)

From the repository root or the `OS/` directory, run:

```bash
cd OS
./build.sh
```

If executed on a non-Alpine host (e.g. Arch or Debian), the script automatically builds the containerized builder and executes the compilation inside a clean Alpine container.

The compiled ISO will be saved in `OS/output/`.

### Manual Containerized Build

To build manually in an interactive Alpine container:

1. Build the builder container:
   ```bash
   docker build -t nidan-alpine-builder ./OS
   ```

2. Launch the container:
   ```bash
   docker run --privileged -it -v $(pwd)/OS:/workspace -w /workspace nidan-alpine-builder /bin/bash
   ```

3. Inside the container, run the build script:
   ```bash
   ./build.sh
   ```

---

---

## Application Bundling

To bundle the `NidanApp` binary into the ISO:

1. Compile the static musl binary using the Swift Static Linux SDK.
2. Place the resulting binary at `OS/bin/nidan`.
3. Run `./build.sh`.

The build script will automatically package the binary into `/usr/local/bin/nidan` within the Alpine Package Overlay (`apkovl`) and activate the `nidan` OpenRC daemon.

---

## Testing in QEMU

To test the generated ISO in a virtual machine using QEMU:

```bash
qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -m 4G \
  -smp 2 \
  -vga virtio \
  -cdrom OS/output/alpine-nidan-261011-x86_64.iso \
  -boot d \
  -net nic -net user,hostfwd=tcp::8080-:8080
```

### VM Interaction Notes
- **RAM Allocation:** `-m 4G` is required for live ISO diskless testing because the entire operating system, XFCE desktop, LibreOffice, and Chromium are uncompressed into an in-memory `tmpfs` root filesystem during boot. Allocating less than 4 GB in diskless mode causes `No space left on device` during package extraction.
- **Hardware Acceleration:** `-enable-kvm -cpu host` provides native CPU performance. Omit these flags if KVM is not supported on your host.
- **Display Driver:** `-vga virtio` provides the VirtIO graphics device for the XFCE desktop and Xorg server.
- **Port Forwarding:** `hostfwd=tcp::8080-:8080` allows accessing the running `NidanApp` web interface from your host browser at `http://localhost:8080`.
- **Desktop Environment:** The student desktop session runs on `tty1` featuring XFCE with pre-configured Adwaita-dark styling, autostarted NIDAN app, LibreOffice, and Chromium. Emergency text consoles are accessible via `Ctrl+Alt+F2` or `Ctrl+Alt+F3`.
- **Student Lockdown:** Non-root student account with `/sbin/apk` execution restricted to prevent unauthorized package management.

---

## Persistent Expanding Disk Installation (Sys Mode)

To run NIDAN as a permanent, persistent OS on a virtual drive or physical USB stick without consuming RAM for root storage:

1. Create a 16 GB expanding virtual disk:
   ```bash
   qemu-img create -f qcow2 OS/output/nidan-disk.qcow2 16G
   ```

2. Boot the installer with the disk attached:
   ```bash
   qemu-system-x86_64 \
     -enable-kvm -cpu host -m 2G -smp 2 -vga virtio \
     -drive file=OS/output/nidan-disk.qcow2,format=qcow2 \
     -cdrom OS/output/alpine-nidan-261011-x86_64.iso -boot d
   ```

3. Switch to console (`Ctrl+Alt+F2`), log in as `root`, and install to disk:
   ```bash
   setup-disk -m sys /dev/sda
   ```

4. Subsequent boots run directly from the persistent, expanding disk with low RAM consumption:
   ```bash
   qemu-system-x86_64 \
     -enable-kvm -cpu host -m 2G -smp 2 -vga virtio \
     -hda OS/output/nidan-disk.qcow2 \
     -net nic -net user,hostfwd=tcp::8080-:8080
   ```

---

## Customization

- **Package Selection:** Edit `OS/mkimg.nidan.sh` to add or remove packages from the `apks` list.
- **System Initialization:** Edit `OS/genapkovl-nidan.sh` to configure boot-time files, network interfaces, and OpenRC service runlevels.
- **Service Supervision:** Edit `OS/init.d/nidan` to adjust daemon startup parameters and logging.
