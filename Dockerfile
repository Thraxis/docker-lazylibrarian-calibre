FROM lsiobase/alpine.python:3.8
MAINTAINER Thraxis

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Thraxis' version:- ${VERSION} Build-date:- ${BUILD_DATE}"

ENV GLIBC_VERSION 2.26-r0
ENV CALIBRE_INSTALLER_SOURCE_CODE_URL https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py
ENV CALIBRE_CONFIG_DIRECTORY="/config/calibre/"
ENV CALIBRE_TEMP_DIR="/config/calibre/tmp/"
ENV CALIBRE_CACHE_DIRECTORY="/config/cache/calibre/"

# install build packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	make && \

# install runtime packages
 apk add --no-cache \
	ghostscript \
 	mesa-gl \
 	qt5-qtbase-x11 \
 	xdg-utils && \
	
apk add py-html5lib --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ && \

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
 apk --no-cache --allow-untrusted -X https://apkproxy.herokuapp.com/sgerrand/alpine-pkg-glibc add glibc glibc-bin && \
 /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
 echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf &&\
 wget -O- ${CALIBRE_INSTALLER_SOURCE_CODE_URL} | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main(install_dir='/opt', isolated=True)" && \

# install app
 git clone --depth 1 https://gitlab.com/LazyLibrarian/LazyLibrarian.git /app/lazylibrarian && \

# cleanup
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/* && \
 rm -rf \
    /tmp/calibre-installer-cache && \
 rm -rf \
   glibc.apk glibc-bin.apk /var/cache/apk/*

# add apprise
RUN pip install --upgrade pip
RUN pip install apprise
   
# add local files
COPY root/ /

# ports and volumes
EXPOSE 5299
VOLUME /config /books /audiobooks /magazines /comics /downloads
