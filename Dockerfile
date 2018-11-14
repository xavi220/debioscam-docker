FROM debian:sid-slim
LABEL maintainer "xavi220"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	build-essential \
	libssl-dev libpcsclite-dev \
	mercurial cvs subversion libncurses-dev \
	cmake &&\
RUN \
 cd /tmp	
 svn co http://streamboard.tv/svn/oscam/trunk oscam
 cd oscam
 make 
 cd /tmp/oscam-svn && \
 ./config.sh \
	--enable all \
	--disable \
	IPV6SUPPORT \
	LCDSUPPORT \
	LEDSUPPORT \
	READ_SDT_CHARSETS && \
 make \
	CONF_DIR=/config \
	DEFAULT_PCSC_FLAGS="-I/usr/include/PCSC" \
	NO_PLUS_TARGET=1 \
	OSCAM_BIN=/usr/bin/oscam && \
 echo "**** fix group for card readers and add abc to dialout group ****" && \
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

