FROM debian:stretch
MAINTAINER xjd <xing.jiudong@trans-cosmos.com.cn>

USER root

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=linux \
    INITRD=No \
    LANG=C.UTF-8  

# add user and group
ENV USER_NAME=java \
    USER_UID=4205 \
    GROUP_NAME=java \
    GROUP_GID=4205

RUN groupadd $GROUP_NAME -g $GROUP_GID && \
    useradd -u $USER_UID --home-dir /srv/$USER_NAME --create-home --system --no-user-group $USER_NAME && \
    usermod -g $GROUP_NAME $USER_NAME && \
    ln -s /srv/$USER_NAME /var/lib/$USER_NAME && \
    chown -R $USER_NAME:$GROUP_NAME /var/lib/$USER_NAME

RUN set -x && \
  apt-get update -qq && \
  apt-get install -y apt-utils curl && \
  apt-get install -y --no-install-recommends ca-certificates wget && \
  rm -rf /var/lib/apt/lists/*

# Install Oracle JDK 8u181
RUN cd /tmp && \
    curl -L -O -H "Cookie: oraclelicense=accept-securebackup-cookie" -k "http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.tar.gz" && \
    tar xf jdk-8u181-linux-x64.tar.gz -C /srv/java && \
    rm -f jdk-8u181-linux-x64.tar.gz && \
    ln -s /srv/java/jdk* /srv/java/jdk && \
    ln -s /srv/java/jdk /srv/java/jvm && \
    chown -R java:java /srv/java

# Define commonly used JAVA_HOME variable
# Add /srv/java and jdk on PATH variable
ENV JAVA_HOME=/srv/java/jdk \
    PATH=${PATH}:/srv/java/jdk/bin:/srv/java

# Define default workdir
WORKDIR /root

# Define default command.
CMD [ "/bin/bash", "-l"]
