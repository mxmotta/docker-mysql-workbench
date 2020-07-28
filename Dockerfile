from ubuntu:20.04

#INSTALL PACKAGES AND DEPS
RUN buildDeps=" \
    wget \
    gdebi \
    iodbc \
    libiodbc2-dev \
    libpq-dev \
    libssl-dev \
    " && \
    apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y $buildDeps sudo locales iproute2 dbus-x11 libsecret-1-0 gnome-keyring && \
    apt-get clean

#COMPILE AND INSTALL LIBRARIES
RUN wget https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-12.02.0000.tar.gz && \
    tar zxvf psqlodbc-12.02.0000.tar.gz && \
    cd psqlodbc-12.02.0000 && \
    ./configure --with-iodbc --enable-pthreads && \
    make && make install && \
    rm -rf /psqlodbc-12.02.0000*

#INSTALL MYSQL WORKBENCH
RUN wget https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_8.0.21-1ubuntu20.04_amd64.deb && \
    gdebi --n --q mysql-workbench-community_8.0.21-1ubuntu20.04_amd64.deb && rm -f mysql-workbench-community_8.0.21-1ubuntu20.04_amd64.deb
RUN locale-gen pt_BR pt_BR.UTF-8 en_US en_US.UTF-8 && dpkg-reconfigure locales
# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

COPY ./start.sh /start.sh
RUN chmod +x /start.sh && export NO_AT_BRIDGE=1
USER developer
ENV HOME /home/developer
ENTRYPOINT [ "sh", "start.sh" ]