#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/output"
CACHE_DIR="${SCRIPT_DIR}/.cache"

mkdir -p "${OUTPUT_DIR}" "${CACHE_DIR}"

run_mkimage() {
    echo "Preparing Alpine build scripts..."
    git config --global --add safe.directory '*' 2>/dev/null || true

    ALPINE_BRANCH="3.20-stable"
    PRIMARY_APORTS_URL="https://github.com/alpinelinux/aports.git"
    FALLBACK_APORTS_URL="https://gitlab.alpinelinux.org/alpine/aports.git"

    clone_aports() {
        rm -rf "${CACHE_DIR}/aports"
        echo "Cloning Alpine aports repository (${ALPINE_BRANCH}) from ${PRIMARY_APORTS_URL}..."
        if ! git clone --depth 1 --branch "${ALPINE_BRANCH}" "${PRIMARY_APORTS_URL}" "${CACHE_DIR}/aports"; then
            echo "Primary mirror failed; attempting fallback to ${FALLBACK_APORTS_URL}..."
            git clone --depth 1 --branch "${ALPINE_BRANCH}" "${FALLBACK_APORTS_URL}" "${CACHE_DIR}/aports"
        fi
    }

    if [ ! -d "${CACHE_DIR}/aports/.git" ]; then
        clone_aports
    elif [ "$(git -C "${CACHE_DIR}/aports" rev-parse --abbrev-ref HEAD 2>/dev/null)" != "${ALPINE_BRANCH}" ]; then
        echo "Switching aports repository to ${ALPINE_BRANCH}..."
        clone_aports
    else
        echo "Using cached aports repository (${ALPINE_BRANCH})..."
    fi

    # Install profile and overlay hooks
    cp "${SCRIPT_DIR}/mkimg.nidan.sh" "${CACHE_DIR}/aports/scripts/"
    cp "${SCRIPT_DIR}/genapkovl-nidan.sh" "${CACHE_DIR}/aports/scripts/"
    mkdir -p "${CACHE_DIR}/aports/scripts/init.d"
    cp -f "${SCRIPT_DIR}/init.d/"* "${CACHE_DIR}/aports/scripts/init.d/"
    if [ -d "${SCRIPT_DIR}/bin" ]; then
        mkdir -p "${CACHE_DIR}/aports/scripts/bin"
        cp -f "${SCRIPT_DIR}/bin/"* "${CACHE_DIR}/aports/scripts/bin/" 2>/dev/null || true
    fi
    if [ -f "${SCRIPT_DIR}/nidan" ]; then
        cp -f "${SCRIPT_DIR}/nidan" "${CACHE_DIR}/aports/scripts/nidan"
    fi
    if [ -d "${SCRIPT_DIR}/www" ]; then
        mkdir -p "${CACHE_DIR}/aports/scripts/www"
        cp -rf "${SCRIPT_DIR}/www/"* "${CACHE_DIR}/aports/scripts/www/" 2>/dev/null || true
    elif [ -d "${SCRIPT_DIR}/../Frontend/dist" ]; then
        mkdir -p "${CACHE_DIR}/aports/scripts/www"
        cp -rf "${SCRIPT_DIR}/../Frontend/dist/"* "${CACHE_DIR}/aports/scripts/www/" 2>/dev/null || true
    fi
    chmod +x "${CACHE_DIR}/aports/scripts/genapkovl-nidan.sh"

    if ! ls "${HOME}/.abuild/"*.rsa >/dev/null 2>&1; then
        mkdir -p "${HOME}/.abuild"
        abuild-keygen -a -i -n
    fi
    export PACKAGER_PRIVKEY="$(ls "${HOME}/.abuild/"*.rsa 2>/dev/null | head -n 1)"

    echo "Building NIDAN Alpine Linux ISO..."
    cd "${CACHE_DIR}/aports/scripts"
    sh ./mkimage.sh \
        --profile nidan \
        --arch x86_64 \
        --hostkeys \
        --repository "https://dl-cdn.alpinelinux.org/alpine/v3.20/main" \
        --repository "https://dl-cdn.alpinelinux.org/alpine/v3.20/community" \
        --outdir "${OUTPUT_DIR}"

    echo "ISO build completed. Output files located in ${OUTPUT_DIR}"
}

if [ -f "/etc/alpine-release" ]; then
    run_mkimage
else
    echo "Host is not Alpine Linux. Delegating build to containerized Alpine builder..."
    docker build -t nidan-alpine-builder "${SCRIPT_DIR}"
    docker run --privileged --rm \
        -v "${SCRIPT_DIR}:/workspace" \
        -w /workspace \
        nidan-alpine-builder \
        bash -c "./build.sh"
fi
