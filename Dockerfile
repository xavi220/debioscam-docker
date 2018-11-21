FROM debian:sid-slim
LABEL maintainer "xavi220"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	build-essential \
	libssl-dev libpcsclite-dev \
	mercurial cvs subversion libncurses-dev \
	cmake &&\
 groupmod -g 24 cron && \
 groupmod -g 16 dialout && \
 usermod -a -G 16 abc && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

COPY root/ /
EXPOSE 8888
VOLUME /config


