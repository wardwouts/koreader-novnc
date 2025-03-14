#!/bin/sh

echo "http://localhost:8081"
echo "=== x86_64 version ==="
podman rm koreader
podman run -p 8081:8080 --arch=amd64 -v "$PWD/books:/books" -v "$PWD/fonts:/usr/lib/koreader/fonts/myfonts" -v "/tmp/config:/config:rw,z" --env PASSWD=-nopw --env CURSOR="" --env EMULATE_READER_W=1000 --env EMULATE_READER_H=600 --name koreader localhost/koreader-novnc

echo "=== ARM64 version ==="
podman rm koreader
podman run -p 8081:8080 --arch=arm64 -v "$PWD/books:/books" -v "$PWD/config:/config:w" --env PASSWD=-nopw --env EMULATE_READER_W=1000 --env EMULATE_READER_H=600 --name koreader localhost/koreader-novnc
