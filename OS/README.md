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

## Customization

- **Package Selection:** Edit `OS/mkimg.nidan.sh` to add or remove packages from the `apks` list.
- **System Initialization:** Edit `OS/genapkovl-nidan.sh` to configure boot-time files, network interfaces, and OpenRC service runlevels.
- **Service Supervision:** Edit `OS/init.d/nidan` to adjust daemon startup parameters and logging.
