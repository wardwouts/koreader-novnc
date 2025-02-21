#!/bin/sh

echo "http://localhost:8081"
echo "=== x86_64 version ==="
podman rm koreader
podman run -p 8081:8080 -v "$PWD/books:/books" --env PASSWD=-nopw --env EMULATE_READER_W=1000 --env EMULATE_READER_H=600 --name koreader localhost/koreader-novnc

echo "=== ARM64 version ==="
podman rm koreader
podman run -p 8081:8080 --arch=arm64 -v "$PWD/books:/books" --env PASSWD=-nopw --env EMULATE_READER_W=1000 --env EMULATE_READER_H=600 --name koreader localhost/koreader-novnc
