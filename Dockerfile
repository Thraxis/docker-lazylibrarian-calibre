FROM linuxserver/lazylibrarian
MAINTAINER Thraxis

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Thraxis' version:- ${VERSION} Build-date:- ${BUILD_DATE}"

ENV GLIBC_VERSION 2.23-r3
ENV CALIBRE_INSTALLER_SOURCE_CODE_URL https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py

# install packages
RUN \
 apk update && \
 apk add --no-cache \
 curl \
 gcc \
 mesa-gl \
 qt5-qtbase-x11 \
 xdg-utils \
 xz && \
 curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
 curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
 apk add glibc.apk && \
 curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
 apk add glibc-bin.apk && \
 /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
 echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf &&\
 wget -O- ${CALIBRE_INSTALLER_SOURCE_CODE_URL} | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main(install_dir='/opt', isolated=True)" && \
 apk del curl &&\
 rm -rf /tmp/calibre-installer-cache && \
 rm -rf glibc.apk glibc-bin.apk /var/cache/apk/*
