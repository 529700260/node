FROM daocloud.io/library/ubuntu:18.04
MAINTAINER JiYun Tech Team <mboss0@163.com>

ADD ./sources.list /etc/apt/sources.list

ADD ./boost.tar.bz2 /usr/local/
ADD ./python3.tar.bz2 /usr/local/
ADD ./v8.tar.bz2 /usr/local/
ADD ./ld.so.conf /etc/ld.so.conf

RUN set -x && apt-get update && apt-get install -y --no-install-recommends  openssh-server tzdata wget  && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/*
RUN mkdir /var/run/sshd && \
    rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone && \
    echo "Port 22" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    rm /etc/ssh/ssh_host_* && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''

ADD https://nodejs.org/dist/v11.5.0/node-v11.5.0-linux-x64.tar.gz /tmp/
RUN tar -xzf /tmp/node-v11.5.0-linux-x64.tar.gz -C /usr/local --strip-components=1 --no-same-owner && \
    rm -rf /tmp/*

ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

RUN echo "sshd:ALL" >> /etc/hosts.allow

RUN mkdir -p /var/www
VOLUME /var/www
WORKDIR /var/www

RUN npm config set registry https://registry.npm.taobao.org/ && npm install pm2 -g

ENTRYPOINT ["/bin/bash", "/start.sh"]
