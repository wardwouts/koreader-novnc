#!/bin/sh

VERSION=$(cat VERSION)

podman push wardwouts/koreader-novnc:latest
podman push wardwouts/koreader-novnc:v$VERSION
