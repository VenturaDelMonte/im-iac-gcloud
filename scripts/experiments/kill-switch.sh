#!/bin/bash

/opt/ventura/framework/flink-build/bin/stop-cluster.sh
pdsh -w im-broker-[01-04] '/opt/ventura/framework/kafka/bin/kafka-server-stop.sh'
pdsh -w im-broker-[01-04] "ps aux | grep -ie kafka | awk '{print \$2}' | xargs kill -9"
pdsh -w im-generator-[01-04] "ps aux | grep java | awk '{print \$2}' | xargs kill -9"
pdsh -w im-broker-[01-05] "ps aux | grep dstat | awk '{print \$2}' | xargs kill -9"
pdsh -w im-generator-[01-04] "ps aux | grep dstat | awk '{print \$2}' | xargs kill -9"
pdsh -w im-worker-[01-08] "ps aux | grep dstat | awk '{print \$2}' | xargs kill -9"
/opt/ventura/framework/kafka/bin/zookeeper-server-stop.sh
pdsh -w im-broker-[01-04] 'rm -rf /data/1/kafka/*; rm -rf /data/2/kafka/*; rm -rf /data/1/kafka/.lock; rm -rf /data/2/kafka/.lock' 
pdsh -w im-worker-[01-04] 'rm -rf /data/1/flink/*; rm -rf /data/2/flink/*' 
rm -rf /data/2/zookeeper/tmp/*

pdsh -w im-worker-0[1-12],im-generator-0[1-4],im-broker-0[1-4] 'echo 3 | sudo tee /proc/sys/vm/drop_caches'
