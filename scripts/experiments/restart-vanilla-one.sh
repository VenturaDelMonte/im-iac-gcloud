#!/bin/bash

echo "im-worker-$2" >> /opt/ventura/framework/flink-vanilla/conf/slaves
ssh im-worker-$2 /opt/ventura/framework/flink-vanilla/bin/taskmanager.sh start
ssh im-worker-$1 /opt/ventura/framework/flink-vanilla/bin/taskmanager.sh stop
