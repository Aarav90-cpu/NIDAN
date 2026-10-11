# ADR 009: Switch to Alpine Linux Base

## Status
Accepted (Supersedes ADR 001)

## Context
NIDAN previously selected Debian 13 "trixie" as the base operating system for its appliance and device images (ADR 001). However, during active engineering and continuous integration testing, several significant bottlenecks emerged:

1. **Extreme Build Times and Bloat:** Generating Debian live-build images requires full debootstrap cycles, large package archives, and heavy dependencies. On CI environments, image assembly and compilation took upwards of six hours, compared to minutes for lightweight distributions.
2. **Image Size on Target Hardware:** The Debian hybrid ISO exceeded 1 GB in size. NIDAN's target hardware (T1 student devices and T2 classroom hubs) consists of constrained, low-cost hardware with limited onboard eMMC/flash storage. A 1 GB+ base image consumes excessive storage and memory.
3. **Alignment with Static Musl Toolchain:** The NIDAN Swift backend is compiled as a static executable linked against `musl-libc` and `mimalloc` for determinism and low memory overhead. Alpine Linux is natively built on `musl` and `busybox`, aligning directly with our application runtime requirements.
4. **Portability of Build Tooling:** Alpine's package management (`apk`) and ISO generation toolchain (`mkimage`, `aports`, `abuild`) are lightweight, cross-platform, and run effortlessly inside minimal containers on any Linux host (Arch, Debian, Ubuntu, etc.) without requiring multi-gigabyte chroot bootstrapping.

## Decision
We will transition the base operating system for NIDAN device images and hubs from Debian to **Alpine Linux**.

## Consequences
- **Positive:**
  - Dramatically smaller base OS footprint: A functional Alpine base image with kernel and core utilities is typically under 100 MB, compared to 1 GB+ on Debian.
  - Significantly faster CI and local build times: ISO generation via `mkimage` and package installation via `apk` completes in minutes rather than hours.
  - Native runtime harmony: The statically linked musl Swift binary runs in a native musl environment without glibc compatibility shims.
  - Reduced memory footprint on low-cost T1/T2 devices: `busybox` and OpenRC provide lower idle RAM consumption than systemd and GNU coreutils.
  - Flexible build host requirements: Alpine images can be constructed reproducibly inside minimal Docker containers or directly on developer workstations.
- **Negative:**
  - Services relying on systemd service units must use OpenRC init scripts or simple runit/s6 supervisors.
  - Proprietary or glibc-only precompiled binaries cannot run without `gcompat`, though NIDAN compiles its own dependencies from source.
