FROM ubuntu

LABEL maintainer="Luan Pontes <luanpontes2@gmail.com>"

# Some Environment Variables
ENV HOME /root

WORKDIR /root/redis

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -yqq \
      net-tools gettext-base wget redis-tools && \
    apt-get clean -yqq

COPY redis-cluster-config.sh /redis-cluster-config.sh
COPY redis-server .
COPY redis-cluster.tmpl .

RUN chmod 755 /redis-cluster-config.sh

EXPOSE 7001 7002 7003 7004 7005 7006

ENTRYPOINT ["/redis-cluster-config.sh"]