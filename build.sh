#!/bin/sh

VERSION=$(cat VERSION)

docker build --build-arg=VERSION=$VERSION -t wardwouts/koreader-novnc -t wardwouts/koreader-novnc:v$VERSION .
