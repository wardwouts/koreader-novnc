# KOReader with novnc

Run using something like this:
```
docker run -p 8080:8080 -v mybooks:/books -v koreader_config:/config -v passwd:/passwd --name koreader wardwouts/koreader-novnc
```

This will make [koreader](<https://github.com/koreader/koreader>) available via novnc on <http://localhost:8080>.

## Change the password
The default password is `koreader`. You should change this.

Create a password file on your local machine, using `vncpasswd`, and use a volume mount to `/passwd` in the container.

OR replace this by opening a shell in the current container:
```
docker exec -it CONTAINERNAME /bin/bash
```
And then run the command:
```
x11vnc -storepasswd PASSWORD /passwd
```

## Paths
- `/books` the path where koreader will search for books by default (you can always browse).
- `/passwd` location of the vnc password file. You should create your own using `vncpasswd`.
- `/config` the path where koreader configuration is stored.


