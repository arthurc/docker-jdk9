FROM gliderlabs/alpine
MAINTAINER Arthur Carlsson <arthur@kiron.net>

ENV JAVA_HOME=/usr/lib/jvm/jdk1.9.0 \
    JAVA_BUILD=106 \
    PATH=${PATH}:${JAVA_HOME}/bin

# wget
RUN apk add --update wget ca-certificates

# glibc
RUN wget "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" \
  "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" \
  -P /tmp
RUN apk add --allow-untrusted /tmp/glibc-2.21-r2.apk /tmp/glibc-bin-2.21-r2.apk
RUN /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib
RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

# JDK
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://www.java.net/download/java/jdk9/archive/${JAVA_BUILD}/binaries/jdk-9-ea+${JAVA_BUILD}_linux-x64_bin.tar.gz -O /tmp/jdk-9.tar.gz
RUN mkdir -p `dirname $JAVA_HOME`
RUN tar -zxf /tmp/jdk-9.tar.gz -C /tmp
RUN mv /tmp/jdk-9 $JAVA_HOME
RUN ln -s $JAVA_HOME/bin/java /usr/bin/java
RUN ln -s $JAVA_HOME/bin/javac /usr/bin/javac
RUN rm -rf \
  $JAVA_HOME/*src.zip \
  $JAVA_HOME/lib/visualvm \
  $JAVA_HOME/man \
  $JAVA_HOME/bin/jvisualvm \
  $JAVA_HOME/bin/appletviewer

# Cleanup
RUN apk del wget ca-certificates
RUN rm /tmp/* /var/cache/apk/*
