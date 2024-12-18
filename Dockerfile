FROM debian:bookworm-slim
LABEL maintainer Ward Wouts

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=C.UTF-8 DISPLAY=:0.0 CURSOR="-nocursor"
ENV EMULATE_READER_W="600" EMULATE_READER_H="800"
ENV PASSWD="-rfbauth /passwd"
ARG VERSION=0
ARG ARCH=wrong
ARG KOREADERURL=https://github.com/koreader/koreader/releases/download/v$VERSION/koreader-linux-$ARCH-v$VERSION.tar.xz

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
        iputils-ping \
        libsdl2-2.0-0 \
    && echo $KOREADERURL \
    && wget -q $KOREADERURL -O /tmp/koreader.tar.xz \
    && cd /usr \
    && tar -xaf /tmp/koreader.tar.xz \
    && rm -rf /var/lib/apt/lists/* \
    && rm /tmp/koreader.tar.xz

# Install koreader icons over novnc icons
COPY resources/icons/* /usr/share/novnc/app/images/icons/
# Install koreader logo
COPY resources/koreader-logo.svg /usr/share/novnc/app/images/


ENV HOME /home/user

RUN adduser user \
    && chown -R user:user $HOME

# Force vnc.html to be used for novnc, to avoid having the directory listing page.
# Set resizing to "local scaling".
# Turn off the noVNC control bar.
# Set logo on connect to koreader.
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html \
    && mkdir -p /books /config \
    && mkdir -p /home/user/.config \
    && mkdir -p /opt \
    && ln -s /config /home/user/.config/koreader \
    && x11vnc -storepasswd koreader /passwd \
    && sed -i "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'scale');/" /usr/share/novnc/app/ui.js \
    && sed -i "s/#noVNC_control_bar_anchor {/#noVNC_control_bar_anchor {\n  display: none;/" /usr/share/novnc/app/styles/base.css \
    && sed -i 's/<div class="noVNC_logo" translate="no"><span>no<\/span>VNC<\/div>/<div class="noVNC_logo" translate="no"><img src="app\/images\/koreader-logo.svg" width=80%><\/div>/' /usr/share/novnc/vnc.html \
    && sed -i 's/<title>noVNC<\/title>/<title>KOReader<\/title>/' /usr/share/novnc/vnc.html \
    && sed -i 's/background-color:#494949;/background-color:#DDDDDD;/' /usr/share/novnc/app/styles/base.css \
    && sed -i 's/background-color: #313131;/background-color:#CCCCCC;/' /usr/share/novnc/app/styles/base.css \
    && chown -R user:user $HOME /config /passwd

# Configure supervisord.
COPY resources/supervisord.conf /etc/supervisor/supervisord.conf
ENTRYPOINT [ "supervisord", "-c", "/etc/supervisor/supervisord.conf" ]

# Add default settings file to set HOME dir to /books
COPY resources/start_koreader resources/settings.reader.lua /opt/

EXPOSE 8080

WORKDIR $HOME
USER user
