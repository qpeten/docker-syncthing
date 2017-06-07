FROM ubuntu:16.04
# Dockerfile to run Syncthing. Requires an external container manager such as
# systemd to auto-restart the container when Syncthing restarts.
MAINTAINER Scott Hansen <firecat4153@gmail.com>

ENV SYNCTHING_USER syncthing
ENV UID 1000

RUN apt-get update -q && \
    apt-get install -qy \
        ca-certificates \
        wget && \
    wget https://github.com/syncthing/syncthing/releases/download/v0.14.29/syncthing-linux-amd64-v0.14.29.tar.gz -O /syncthing.tar.gz && \
    tar -xzvf syncthing.tar.gz && \
    mv sync*/syncthing /syncthing && \
    rm -rf syncthing.tar.gz syncthing-linux*

RUN useradd --no-create-home -g users --uid $UID $SYNCTHING_USER && \
    apt-get autoremove -qy wget && \
    rm -rf /var/lib/apt/lists/* && \
    chown $SYNCTHING_USER /syncthing

USER $SYNCTHING_USER

CMD /syncthing -home=/config
