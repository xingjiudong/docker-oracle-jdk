FROM debian:stretch
MAINTAINER xjd <xing.jiudong@trans-cosmos.com.cn>

USER root

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=linux \
    INITRD=No \
    LANG=C.UTF-8  

RUN set -x && \
  apt-get update -qq && \
  apt-get install -y apt-utils curl && \
  apt-get install -y --no-install-recommends ca-certificates wget unzip && \
  rm -rf /var/lib/apt/lists/*

# Install Oracle JDK 8u181
RUN mkdir /opt/java && cd /tmp && \
    curl -L -O -H "Cookie: oraclelicense=accept-securebackup-cookie" -k "http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.tar.gz" && \
    tar xf jdk-8u181-linux-x64.tar.gz -C /opt/java && \
    rm -f jdk-8u181-linux-x64.tar.gz && \
    ln -s /opt/java/jdk* /opt/java/jdk && \
    ln -s /opt/java/jdk /opt/java/jvm && \
    ln -s /opt/java/jdk1.8.0_181/ /opt/java/default && \
    chown -R root:root /opt/java/jdk1.8.0_181/

# Define commonly used JAVA_HOME variable
# Add /opt/java and jdk on PATH variable
ENV JAVA_HOME=/opt/java/jdk \
    PATH=${PATH}:/opt/java/jdk/bin:/opt/java

# Define default workdir
WORKDIR /root

# Define default command.
CMD [ "/bin/bash", "-l"]
