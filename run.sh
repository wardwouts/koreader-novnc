#!/bin/sh

echo "http://localhost:8081"
podman rm koreader
podman run -p 8081:8080 -v $PWD/books:/books --env PASSWD=-nopw --env EMULATE_READER_W=1000 --env EMULATE_READER_H=600 --name koreader localhost/koreader-novnc
