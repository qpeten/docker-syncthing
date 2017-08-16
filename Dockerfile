FROM ubuntu:16.04
# Based on a Dockerfile from Scott Hansen
# https://github.com/firecat53/dockerfiles/blob/master/syncthing/Dockerfile

MAINTAINER Quentin Peten

ENV SYNCTHING_USER syncthing
ENV UID 1000

RUN apt-get update -q && apt-get upgrade -y
RUN apt-get install -qy \
        ca-certificates \
	curl \
	apt-transport-https

RUN curl -s https://syncthing.net/release-key.txt | apt-key add -

# Add the "stable" channel to your APT sources:
RUN echo "deb https://apt.syncthing.net/ syncthing stable" | tee /etc/apt/sources.list.d/syncthing.list

# Install syncthing:
RUN apt-get update -q && apt-get install -qy syncthing

RUN useradd --no-create-home -g users --uid $UID $SYNCTHING_USER && \
    apt-get autoremove -qy wget && \
    rm -rf /var/lib/apt/lists/*

USER $SYNCTHING_USER

CMD /usr/bin/syncthing -home=/config
