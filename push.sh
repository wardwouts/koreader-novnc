#!/bin/sh

VERSION=$(cat VERSION)

docker push wardwouts/koreader-novnc:latest
docker push wardwouts/koreader-novnc:v$VERSION
