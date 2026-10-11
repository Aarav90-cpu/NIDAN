# NIDAN Command Reference

This document provides a comprehensive reference for all commands, command-line arguments, environment variables, and build tools across the NIDAN repository.

For quick start instructions, see [README.md](../README.md).

---

## Table of Contents

1. [Swift Application Server (`NidanApp`)](#1-swift-application-server-nidanapp)
   - [Default Server Mode](#default-server-mode)
   - [Enrollment Code Issuance Subcommand](#enrollment-code-issuance-subcommand)
   - [Environment Variables](#environment-variables-nidanapp)
2. [Content Server (`NidanContentServer`)](#2-content-server-nidancontentserver)
   - [Execution](#execution-nidancontentserver)
   - [Environment Variables](#environment-variables-nidancontentserver)
3. [Swift Package Manager Commands](#3-swift-package-manager-commands)
   - [Building](#building-with-swiftpm)
   - [Testing](#testing-with-swiftpm)
4. [Frontend Commands (`Frontend/`)](#4-frontend-commands-frontend)
   - [Dependency Installation](#dependency-installation)
   - [Production Build](#production-build)
   - [Development Server](#development-server)
   - [Build Preview](#build-preview)
5. [Operating System Image Build (`OS/`)](#5-operating-system-image-build-os)
   - [Docker Builder Construction](#docker-builder-construction)
   - [Live-Build Execution](#live-build-execution)
6. [End-to-End Operational Workflows](#6-end-to-end-operational-workflows)
   - [Fresh Development Setup](#fresh-development-setup)
   - [Demo Environment Setup](#demo-environment-setup)

---

## 1. Swift Application Server (`NidanApp`)

`NidanApp` is the authoritative school server. It provides the REST API, manages local SQLite storage (`nidan.sqlite`), handles session authentication, and serves the compiled frontend assets from `Frontend/dist/`.

### Default Server Mode

To launch the primary application server:

```bash
swift run NidanApp
```

Behavior upon execution:
- Initializes the SQLite database file at `<project_root>/nidan.sqlite`.
- Runs required schema migrations (`v1_baseline`, `v2_realistic_schema`).
- Seeds the diagnostic question bank if not already populated.
- Checks if `NIDAN_DEMO_SEED=1` is specified (see environment variables below).
- Serves static assets from `Frontend/dist/`.
- Binds to the designated host and port (default: `127.0.0.1:8080`).

### Enrollment Code Issuance Subcommand

The `NidanApp` executable includes a built-in CLI utility for generating secure, role-scoped enrollment invitation codes.

#### Syntax

```bash
swift run NidanApp issue-enrollment-code <role> [--classes <list>] [--subjects <list>]
```

#### Supported Roles

- `student`: Requires `--classes` with exactly one class identifier. Does not accept `--subjects`.
- `teacher`: Requires both `--classes` and `--subjects` (comma-separated lists).
- `vicePrincipal`: Must not specify `--classes` or `--subjects` (role is school-wide).
- `principal`: Must not specify `--classes` or `--subjects` (role is school-wide).

#### Examples

Issue a code for a student entering Class 9A:
```bash
swift run NidanApp issue-enrollment-code student --classes 9A
```

Issue a code for a teacher instructing Mathematics and Science across classes 9A and 9B:
```bash
swift run NidanApp issue-enrollment-code teacher --classes 9A,9B --subjects Mathematics,Science
```

Issue a code for a vice-principal:
```bash
swift run NidanApp issue-enrollment-code vicePrincipal
```

Issue a code for a principal:
```bash
swift run NidanApp issue-enrollment-code principal
```

#### Characteristics
- Codes are cryptographically generated, single-use, and valid for 24 hours.
- Only the SHA-256 hash of the code is stored in the database.
- The plaintext code is printed once to the operator terminal and cannot be retrieved later.

### Environment Variables (`NidanApp`)

| Variable | Default Value | Description |
| --- | --- | --- |
| `NIDAN_BIND_HOST` | `127.0.0.1` | Network interface IP to bind the HTTP server. Use `0.0.0.0` or a local LAN IP only behind trusted networks. |
| `NIDAN_API_PORT` | `8080` | Port number on which the HTTP server listens. |
| `NIDAN_DEMO_SEED` | *(unset)* | When set to `1` on a clean database, seeds synthetic demo school data (roster, teachers, sample marks, assignments, notices). Only executes if no users exist. |

Example using custom host, port, and demo seed:
```bash
NIDAN_BIND_HOST=127.0.0.1 NIDAN_API_PORT=9090 NIDAN_DEMO_SEED=1 swift run NidanApp
```

---

## 2. Content Server (`NidanContentServer`)

`NidanContentServer` is an isolated static file server designed to serve educational textbooks, media, and documents located in `Content/public`. It has no access to the school database and performs no authentication.

### Execution (`NidanContentServer`)

```bash
swift run NidanContentServer
```

Behavior upon execution:
- Binds to the designated content host and port (default: `127.0.0.1:8081`).
- Serves static assets from `Content/public` via FileMiddleware.
- Exposes a health status check endpoint at `GET /health`.

### Environment Variables (`NidanContentServer`)

| Variable | Default Value | Description |
| --- | --- | --- |
| `NIDAN_CONTENT_BIND_HOST` | `127.0.0.1` | Network interface IP to bind the content server. |
| `NIDAN_CONTENT_PORT` | `8081` | Port number for the content server. |
| `NIDAN_CONTENT_DIRECTORY` | `<project_root>/Content/public` | Filesystem directory path containing public educational materials. |

Example:
```bash
NIDAN_CONTENT_PORT=8085 NIDAN_CONTENT_DIRECTORY=/opt/nidan/media swift run NidanContentServer
```

---

## 3. Swift Package Manager Commands

The repository uses Swift Package Manager (SwiftPM) defined in `Package.swift`.

### Building with SwiftPM

Compile all package libraries and executable targets:
```bash
swift build
```

Compile for release mode with optimizations:
```bash
swift build -c release
```

Build a specific executable target:
```bash
swift build --target NidanApp
swift build --target NidanContentServer
```

Build a specific library target:
```bash
swift build --target NidanCore
swift build --target NidanStorage
```

### Testing with SwiftPM

Execute all unit and integration test suites:
```bash
swift test
```

Execute a specific test target:
```bash
swift test --filter NidanStorageTests
```

Execute an individual test class:
```bash
swift test --filter DiagnosticStorageTests
swift test --filter EnrollmentCodeTests
swift test --filter SchoolWorkflowTests
```

---

## 4. Frontend Commands (`Frontend/`)

The web client is located in `Frontend/` and is built using TypeScript, Vite, and Material Design 3 Web components.

All commands in this section must be executed from within the `Frontend/` subdirectory:

```bash
cd Frontend
```

### Dependency Installation

Install all required npm dependencies:
```bash
npm install
```

### Production Build

Typecheck TypeScript source files and bundle production static assets into `Frontend/dist/`:
```bash
npm run build
```

This runs `tsc && vite build`. Output files are generated in `Frontend/dist/`, which is directly served by `NidanApp`.

### Development Server

Start the local Vite development server with hot-module reloading:
```bash
npm run dev
```

Note: When using the Vite dev server, API requests must route to the running `NidanApp` instance.

### Build Preview

Locally preview the built output from `Frontend/dist/`:
```bash
npm run preview
```

---

## 5. Operating System Image Build (`OS/`)

Per [ADR 009](adr/009-switch-to-alpine-linux.md), NIDAN's base operating system image is transitioning to Alpine Linux for reduced footprint, native musl alignment, and significantly faster build cycles.

### Containerized Alpine ISO Construction (Universal Method)

The recommended approach across any Linux workstation (Arch, Debian, Ubuntu) is using a clean Alpine container:

1. Launch a privileged Alpine container:
   ```bash
   docker run -it --privileged -v $(pwd):/workspace -w /workspace alpine:latest /bin/sh
   ```

2. Inside the container, install ISO build dependencies:
   ```bash
   apk update
   apk add alpine-sdk xorriso syslinux squashfs-tools
   ```

3. Clone Alpine deployment profiles:
   ```bash
   git clone --depth 1 https://gitlab.alpinelinux.org/alpine/aports.git
   cd aports/scripts
   ```

4. Compile the bootable Alpine ISO:
   ```bash
   ./mkimage.sh --profile standard --arch x86_64 --outdir /workspace/output
   ```

### Host Package Building (`abuild`)

For building custom Alpine packages (`.apk`) on an Arch Linux or Debian workstation:

On Arch Linux:
```bash
sudo pacman -S abuild atools
abuild-keygen -a -i
```

On Debian/Ubuntu:
```bash
sudo apt-get install -y abuild alpine-sdk
abuild-keygen -a -i
```

Compile a package defined in `APKBUILD`:
```bash
abuild -r
```

### Legacy Debian Live-Build Reference (Superseded)

For reference, the superseded Debian live-build configuration used:
```bash
docker run --privileged -v $(pwd)/OS:/workspace nidan-os-builder lb clean
docker run --privileged -v $(pwd)/OS:/workspace nidan-os-builder lb config
docker run --privileged -v $(pwd)/OS:/workspace nidan-os-builder lb build
```

---

## 6. End-to-End Operational Workflows

### Fresh Development Setup

1. Install frontend dependencies and compile web assets:
   ```bash
   cd Frontend
   npm install
   npm run build
   cd ..
   ```

2. Compile the Swift backend targets:
   ```bash
   swift build
   ```

3. Run the automated test suites:
   ```bash
   swift test
   ```

4. Launch the application server:
   ```bash
   swift run NidanApp
   ```

5. Open a web browser to `http://localhost:8080`.

### Demo Environment Setup

To start a new demonstration instance pre-populated with synthetic student records, classes, notices, and worksheets:

1. Ensure existing test database is removed (if starting clean):
   ```bash
   rm -f nidan.sqlite nidan.sqlite-wal nidan.sqlite-shm
   ```

2. Build the frontend (if not already built):
   ```bash
   cd Frontend && npm run build && cd ..
   ```

3. Start `NidanApp` with the demo seed environment flag:
   ```bash
   NIDAN_DEMO_SEED=1 swift run NidanApp
   ```

4. In a separate terminal, issue an enrollment code to register an account:
   ```bash
   swift run NidanApp issue-enrollment-code student --classes 9A
   ```

5. Access `http://localhost:8080/onboarding.html`, enter the enrollment code, and set up your student credentials.

---

## Operating System & Virtual Machine Commands

### Building the Alpine Linux Image

Build the custom Alpine Linux ISO image:
```bash
cd OS && ./build.sh
```

The script automatically executes inside the containerized Alpine build environment on non-Alpine hosts and generates the final bootable ISO in `OS/output/alpine-nidan-<date>-x86_64.iso`.

### Testing the ISO with QEMU

Test the generated ISO in a virtual machine with hardware acceleration and port forwarding:
```bash
qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -m 2G \
  -smp 2 \
  -vga virtio \
  -cdrom OS/output/alpine-nidan-261011-x86_64.iso \
  -boot d \
  -net nic -net user,hostfwd=tcp::8080-:8080
```

#### Command Options
- `-enable-kvm -cpu host`: Enables native hardware acceleration (omit if KVM is not supported on your host).
- `-m 2G`: Allocates 2 GB of RAM (required for live memory filesystem and Chromium).
- `-smp 2`: Allocates 2 CPU cores.
- `-vga virtio`: Provides a VirtIO DRM/KMS graphics device for the Wayland kiosk compositor (`cage`).
- `-cdrom OS/output/alpine-nidan-261011-x86_64.iso`: Specifies the ISO image to boot.
- `-net user,hostfwd=tcp::8080-:8080`: Forwards port 8080 to the host machine for network testing at `http://localhost:8080`.

#### Key Navigation in QEMU
- **TTY1 (Graphical Kiosk):** Displays the white `N I D A N` boot banner and launches the full-screen kiosk interface.
- **TTY2 / TTY3 (Emergency Console):** Press `Ctrl+Alt+F2` or `Ctrl+Alt+F3` (or use QEMU window menu `View -> View TTY2`) to access an emergency text terminal for maintenance.
- **Host Browser:** Open `http://localhost:8080` on your host machine while the VM runs to test teacher and administrative dashboard access across the virtual network.

