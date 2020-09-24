FROM daocloud.io/library/ubuntu:16.04
MAINTAINER JiYun Tech Team <mboss0@163.com>

RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

ADD https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.gz /tmp/
RUN tar -xzf /tmp/node-v8.9.4-linux-x64.tar.gz -C /usr/local --strip-components=1 --no-same-owner

RUN rm -rf /tmp/*

RUN set -x && apt-get update && apt-get install --no-install-recommends --no-install-suggests -y openssh-server tzdata  && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/*
RUN mkdir /var/run/sshd && \
    rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone

ADD ./sshd_config /etc/ssh/sshd_config

ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

RUN echo "sshd:ALL" >> /etc/hosts.allow

RUN mkdir -p /var/www
VOLUME /var/www
WORKDIR /var/www

RUN npm install pm2 -g
ENV EGG_SERVER_ENV prod

ENTRYPOINT ["/bin/bash", "/start.sh"]