#!/bin/bash

TOPIC_NAME=$1
PARTITION_NUM=$2
BINARIES_DIR=/opt/ventura/framework
ZOOKEEPER_NODE=im-master:2181

DESCRIPTION=`$BINARIES_DIR/kafka/bin/kafka-topics.sh --describe --zookeeper $ZOOKEEPER_NODE --topic $TOPIC_NAME`

if [ -z "$DESCRIPTION" ]; then
    echo "Topic $TOPIC_NAME/$PARTITION_NUM does not exist, we just need to create it"
    $BINARIES_DIR/kafka/bin/kafka-topics.sh --create --zookeeper $ZOOKEEPER_NODE --replication-factor 1 --partitions $PARTITION_NUM --topic $TOPIC_NAME
else
    echo "Topic $TOPIC_NAME/$PARTITION_NUM does exist, we need to delete it first"
    $BINARIES_DIR/kafka/bin/kafka-topics.sh --delete --zookeeper $ZOOKEEPER_NODE --topic $TOPIC_NAME
    $BINARIES_DIR/kafka/bin/zookeeper-shell.sh $ZOOKEEPER_NODE rmr /brokers/topics/$TOPIC_NAME
    $BINARIES_DIR/kafka/bin/kafka-topics.sh --create --zookeeper $ZOOKEEPER_NODE --replication-factor 1 --partitions $PARTITION_NUM --topic $TOPIC_NAME
fi