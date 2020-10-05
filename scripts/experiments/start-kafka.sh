#!/bin/bash

/opt/ventura/framework/kafka/bin/zookeeper-server-start.sh /opt/ventura/framework/kafka/config/zookeeper.properties > /opt/ventura/framework/kafka/bin/zookeeper.log 2>&1 &
sleep 5
pdsh -w im-broker-[01-04] '/opt/ventura/framework/kafka/bin/kafka-server-start.sh /opt/ventura/framework/kafka/config/server.properties > /opt/ventura/framework/kafka/bin/kafka.log 2>&1 &'
