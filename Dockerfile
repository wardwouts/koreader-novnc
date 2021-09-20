FROM debian:buster-slim
LABEL maintainer Ward Wouts <ward@wouts.nl>

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=C.UTF-8 DISPLAY=:0.0 CURSOR="-nocursor"
ARG VERSION=2021.08
ARG KOREADERURL=https://github.com/koreader/koreader/releases/download/v$VERSION/koreader-$VERSION-amd64.deb

# Install koreader and dependencies.
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get autoremove -y \
    && apt-get install -y \
        novnc \
        wget \
        x11vnc \
        xvfb \
        supervisor \
        net-tools \
    && wget -q $KOREADERURL -O /tmp/koreader.deb \
    && apt-get install -y /tmp/koreader.deb \
    && rm -rf /var/lib/apt/lists/* \
    && rm /tmp/koreader.deb

ENV HOME /home/user

RUN adduser user \
    && chown -R user:user $HOME

# Force vnc.html to be used for novnc, to avoid having the directory listing page.
# Set resizing to "local scaling".
# Additionally, turn off the control bar.
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html \
    && mkdir -p /books /config \
    && mkdir -p /home/user/.config \
    && mkdir -p /opt \
    && ln -s /config /home/user/.config/koreader \
    && x11vnc -storepasswd koreader /passwd \
    && sed -i "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'scale');/" /usr/share/novnc/app/ui.js \
    && sed -i "s/#noVNC_control_bar_anchor {/#noVNC_control_bar_anchor {\n  display: none;/" /usr/share/novnc/app/styles/base.css \
    && chown -R user:user $HOME /config /passwd

# Configure supervisord.
COPY supervisord.conf /etc/supervisor/supervisord.conf
ENTRYPOINT [ "supervisord", "-c", "/etc/supervisor/supervisord.conf" ]

# Add default settings file to set HOME dir to /books
COPY start_koreader settings.reader.lua /opt/

EXPOSE 8080

WORKDIR $HOME
USER user
