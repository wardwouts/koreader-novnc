# KOReader with novnc

Run using something like this:
```
docker run -p 8080:8080 -v mybooks:/books:ro -v koreader_config:/config -v passwd:/passwd:ro --name koreader wardwouts/koreader-novnc
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
- `/books` the path where koreader will search for books by default (you can always browse). Can be read-only.
- `/passwd` location of the vnc password file. You should create your own using `vncpasswd`. Can be read-only.
- `/config` the path where koreader configuration is stored. Needs to be writeable.

## Environment
### Cursor
By default no X-cursor will be shown. Which is nice for reading on a mobile phone, but not ideal for a desktop browser (even though keyboard navigation is possible). This behaviour can be overruled by specifying an environment variable `CURSOR`, with an empty value:

```
docker run -p 8080:8080 --env CURSOR="" -v mybooks:/books -v koreader_config:/config -v passwd:/passwd --name koreader wardwouts/koreader-novnc
```
### Geometry
The default geometry used is "600x800". You can specify a different one via the `EMULATE_READER_W` and `EMULATE_READER_H` environment variables:


```
docker run -p 8080:8080 --env EMULATE_READER_W="1400" --env EMULATE_READER_H="600" -v mybooks:/books -v koreader_config:/config -v passwd:/passwd --name koreader wardwouts/koreader-novnc
```

### PASSWD
By default the varialbe `PASSWD` has the value `-rfbauth /passwd`. There could be cases where you want to overrule this, for instance when an alternative authentication layer is used (`-nopw`).
