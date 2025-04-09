#!/bin/sh

VERSION=$(cat VERSION)

buildah manifest push --all --format v2s2 koreader-novnc "docker://docker.io/wardwouts/koreader-novnc:latest"
buildah manifest push --all --format v2s2 koreader-novnc "docker://docker.io/wardwouts/koreader-novnc:v$VERSION"
