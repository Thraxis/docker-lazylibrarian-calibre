FROM lsiobase/alpine.python:3.6
MAINTAINER Thraxis

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Thraxis' version:- ${VERSION} Build-date:- ${BUILD_DATE}"

#ENV GLIBC_VERSION 2.26-r0
#ENV CALIBRE_INSTALLER_SOURCE_CODE_URL https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py
#ENV CALIBRE_CONFIG_DIRECTORY="/config/calibre/"
#ENV CALIBRE_TEMP_DIR="/config/calibre/tmp/"
#ENV CALIBRE_CACHE_DIRECTORY="/config/cache/calibre/"


# install packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	make && \

 apk add --no-cache \
 	ghostscript \
 	mesa-gl \
 	qt5-qtbase-x11 \
 	xdg-utils && \

 # build unrarlib
 rar_ver=$(apk info unrar | grep unrar- | cut -d "-" -f2 | head -1) && \
 mkdir -p \
	/tmp/unrar && \
 curl -o \
 /tmp/unrar-src.tar.gz -L \
	"http://www.rarlab.com/rar/unrarsrc-${rar_ver}.tar.gz" && \
 tar xf \
 /tmp/unrar-src.tar.gz -C \
	/tmp/unrar --strip-components=1 && \
 cd /tmp/unrar && \
 make lib && \
 make install-lib && \

 # build calibre
 #curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
 #curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
 #apk add glibc.apk && \
 #curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
 #apk add glibc-bin.apk && \
 #/usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
 #echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf &&\
 #wget -O- ${CALIBRE_INSTALLER_SOURCE_CODE_URL} | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main(install_dir='/opt', isolated=True)" && \

# install app
 git clone --depth 1 https://github.com/dobytang/lazylibrarian.git /app/lazylibrarian && \

 # cleanup
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/* 
#	&& \
 #rm -rf \
 #   /tmp/calibre-installer-cache && \
 #rm -rf \
 #   glibc.apk glibc-bin.apk /var/cache/apk/*

 # add local files
 COPY root/ /

 # ports and volumes
 EXPOSE 5299
 VOLUME /config /books /audiobooks /magazines /downloads
