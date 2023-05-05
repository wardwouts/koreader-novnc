#!/bin/sh

VERSION=$(cat VERSION)

unset TMPDIR # othewise buildah will try to use that and it doesn't work with an NFS home
podman build --build-arg=VERSION=$VERSION -t wardwouts/koreader-novnc -t wardwouts/koreader-novnc:v$VERSION .
