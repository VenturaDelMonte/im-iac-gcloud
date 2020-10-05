#!/bin/bash

$EXPERIMENT_DIR/flink-vanilla/bin/start-cluster.sh
$EXPERIMENT_DIR/hdfs/sbin/start-dfs.sh
sleep 10
touch /tmp/brokers.txt
$EXPERIMENT_DIR/hdfs/bin/hdfs dfs -mkdir -p /storage/flink > /dev/null 2>&1
$EXPERIMENT_DIR/hdfs/bin/hdfs dfs -mkdir -p /storage/savepoints > /dev/null 2>&1

pdsh -w im-worker-0[1-8] 'dd if=/dev/zero of=/tmp/testfile_`hostname`.bin bs=1G count=1; /opt/ventura/framework/hdfs/bin/hdfs dfs -copyFromLocal /tmp/testfile_`hostname`.bin /storage/; rm -rf /tmp/testfile_`hostname`.bin'

$EXPERIMENT_DIR/scripts/run-q8-vanilla-autogen.sh
