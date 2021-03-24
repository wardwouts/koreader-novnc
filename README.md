# KOReader with novnc

Run with something like:
```
docker run -p 8080:8080 -v mybooks:/books -v koreader_config:/config --name koreader koreader
```

This will make koreader available via novnc on http://localhost:8080

## Paths
- `/books` the path where koreader will search for books by default (you can always browse).
- `/config` the path where koreader configuration is stored.


