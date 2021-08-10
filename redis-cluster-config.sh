#!/bin/bash

rm -rf 700* && rm -rf *.aof && rm -rf *.conf && rm -rf *.rdb ;

sleep 5;

IP=$(hostname -I)

for port in `seq 7001 7006`; do \
  echo "> ${port}"

  mkdir -p ./${port}/conf \
  && PORT=${port} IP=$IP envsubst < ./redis-cluster.tmpl > ./${port}/conf/redis.conf \
  && cp 'redis-server' ./${port}/redis-server;

  cd ./${port} 
  
  echo "> start server ${port}"
  nohup ./redis-server ./conf/redis.conf > ./logs 2>&1 &

  cd ..

  sleep 3;
done

echo "yes" | redis-cli -p 7001 --cluster create 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 127.0.0.1:7006 --cluster-replicas 1;

tail -f ./7001/logs