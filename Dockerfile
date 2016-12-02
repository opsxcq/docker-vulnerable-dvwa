FROM debian:jessie

MAINTAINER opsxcq <opsxcq@thestorm.com.br>

RUN apt-get update && \
    apt-get upgrapde -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    package1 \
    package2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd --system --uid 666 -M --shell /usr/sbin/nologin vulnerable

USER vulnerable

EXPOSE 80

VOLUME /data
WORKDIR /data
