FROM shadowsocks/shadowsocks-libev:v3.3.4

ENV V2RAY_PLUGIN_VERSION v1.2.0
ENV OBFS_PLUGIN v2ray-plugin
ENV OBFS_OPTS   'server'


USER root

RUN set -ex \
      && apk add --no-cache --virtual .build-deps tar \
      && wget -cq -O /root/v2ray-plugin.tar.gz https://github.com/shadowsocks/v2ray-plugin/releases/download/${V2RAY_PLUGIN_VERSION}/v2ray-plugin-linux-amd64-${V2RAY_PLUGIN_VERSION}.tar.gz \
      && tar xvzf /root/v2ray-plugin.tar.gz -C /root \
      && mv /root/v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin \
      && rm -f /root/v2ray-plugin.tar.gz \
      && apk del .build-deps


ADD config.json /config.json
ADD config.json /etc/shadowsocks-libev/config.json
USER nobody

CMD exec ss-server \
      -c /config.json \
      --fast-open \
      --plugin $OBFS_PLUGIN \
      --plugin-opts $OBFS_OPTS
