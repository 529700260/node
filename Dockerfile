FROM oraclelinux:7-slim

# nodejs
RUN groupadd --gid 1000 node && \
    useradd --uid 1000 --gid node --shell /bin/bash --create-home node

ADD ./start.sh /start.sh
ADD https://npm.taobao.org/mirrors/node/v10.22.1/node-v10.22.1-linux-x64.tar.gz /tmp/
RUN yum install -y tar gzip && \
    tar -xzf /tmp/node-v10.22.1-linux-x64.tar.gz -C /usr/local --strip-components=1 --no-same-owner

# oracle
ADD *.rpm /tmp/
RUN yum -y install /tmp/*.rpm && \
    rm -rf /var/cache/yum && \
    yum clean all && \
    rm -rf /tmp/* && \
    echo /usr/lib/oracle/11.2/client64/lib > /etc/ld.so.conf.d/oracle-instantclient11.2.conf && \
    ldconfig
    
RUN export ORACLE_HOME=/usr/lib/oracle/11.2/client64 && \
    export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib && \
    export TNS_ADMIN=/usr/lib/oracle/11.2/client64/network/admin && \
    export PATH=$PATH:$ORACLE_HOME/bin && \
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone && \
    chmod 755 /start.sh && \
    mkdir -p /var/www

VOLUME /var/www
WORKDIR /var/www

RUN npm install pm2 -g --registry=https://registry.npm.taobao.org

ENV PATH=$PATH:/usr/lib/oracle/11.2/client64/bin
ENV EGG_SERVER_ENV prod

ENTRYPOINT ["/bin/bash", "/start.sh"]
