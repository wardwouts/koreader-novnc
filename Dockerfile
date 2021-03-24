FROM debian:buster
LABEL maintainer Ward Wouts <ward@wouts.nl>

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=C.UTF-8 DISPLAY=:0.0
ARG KOREADERURL=https://github.com/koreader/koreader/releases/download/v2021.02/koreader-appimage-x86_64-linux-gnu-v2021.02.AppImage

# Install dependencies.
RUN apt-get update && apt-get install -y \
    novnc \
    wget \
    x11vnc \
    xvfb \
    supervisor \
    fuse \
    && wget -q https://github.com/koreader/koreader/releases/download/v2021.02/koreader-2021.02-amd64.deb -O /tmp/koreader.deb \
    && apt install -y /tmp/koreader.deb \
    && rm -rf /var/lib/apt/lists/*

ENV HOME /home/user

RUN adduser user \
    && chown -R user:user $HOME

# Force vnc_lite.html to be used for novnc, to avoid having the directory listing page.
# Additionally, turn off the control bar.
RUN ln -s /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html \
    && sed -i 's/display:flex/display:none/' /usr/share/novnc/app/styles/lite.css \
    && mkdir -p /books /config \
    && mkdir -p /home/user/.config \
    && ln -s /config /home/user/.config/koreader \
    && chown -R user:user $HOME /config

# Configure supervisord.
COPY supervisord.conf /etc/supervisor/supervisord.conf
ENTRYPOINT [ "supervisord", "-c", "/etc/supervisor/supervisord.conf" ]

WORKDIR $HOME
USER user
