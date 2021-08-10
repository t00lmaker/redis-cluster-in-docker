#!/bin/bash

rm -rf 700* && rm -rf *.aof && rm -rf *.conf && rm -rf *.rdb ;

sleep 5;
 
if [ -z "$IP" ]; then
    IP=$(hostname -I)
fi

echo "IP: '$IP'"

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

echo "yes" | redis-cli -p 7001 --cluster create $IP:7001 $IP:7002 $IP:7003 $IP:7004 $IP:7005 $IP:7006 --cluster-replicas 1;

tail -f ./7001/logs
