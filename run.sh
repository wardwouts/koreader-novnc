#!/bin/sh

echo "http://localhost:8081"
docker rm koreader ; docker run -p 8081:8080 -v $PWD/books:/books --name koreader wardwouts/koreader-novnc
