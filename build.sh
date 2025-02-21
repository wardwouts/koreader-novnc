#!/bin/bash

set -u # Throw errors when unset variables are used
set -e # Exit on error
set -o pipefail # Bash specific
set -x

VERSION=$(cat VERSION)

unset TMPDIR # othewise buildah will try to use that and it doesn't work with an NFS home

# Debian architectures
# amd64, arm32v5, arm32v7, arm64v8, i386, mips64le, ppc64le, riscv64, s390x

# Koreader builds
# koreader-2023.04-amd64.deb - amd64
# koreader-2023.04-arm64.deb - arm64v8
# koreader-2023.04-armel.deb - arm32v5
# koreader-2023.04-armhf.deb - arm32v7

# Setup mapping from debian platform names to koreader platform names
declare -A architectures=( [linux/amd64]="x86_64" [linux/arm64]="aarch64" )

# Set your manifest name
MANIFEST="koreader-novnc"

# Set the required variables
BUILD_PATH="."
IMAGE_NAME="${MANIFEST}"

BUILDAH_VERSION=$(buildah --version | awk '{ sub(/^[^0-9]*/, ""); sub(/ .*/, ""); gsub(/\./, ""); print $1; }')

if [ "$BUILDAH_VERSION" -lt 1190 ]; then
  echo "Buildah version too old for multi-arch manifests"
  exit
fi

set +e
buildah manifest rm "${MANIFEST}"
buildah manifest create "${MANIFEST}"
set -e

for arch in "${!architectures[@]}"; do
  echo "Creating image for architecture ${arch}"
  subarch=${arch#*/}
  echo buildah bud \
    --tag "${IMAGE_NAME}:${VERSION}-${subarch}" \
    --build-arg=VERSION="${VERSION}" \
    --build-arg=ARCH="${architectures[$arch]}" \
    --platform="${arch}" \
    --manifest="${MANIFEST}" \
    "${BUILD_PATH}"
  buildah bud \
    --tag "${IMAGE_NAME}:${VERSION}-${subarch}" \
    --build-arg=VERSION="${VERSION}" \
    --build-arg=ARCH="${architectures[$arch]}" \
    --platform="${arch}" \
    --manifest="${MANIFEST}" \
    "${BUILD_PATH}"
done
