#!/bin/bash

NUM_PARTITION_PERSON=$1
NUM_PARTITION_AUCTIONS=$2
NUM_WORKERS_PERSONS=$3
NUM_WORKERS_AUCTIONS=$4
SIZE_PERSONS=$5
SIZE_AUCTIONS=$6
DESIRED_PERSONS=$7
DESIRED_AUCTIONS=$8
KAFKA_SERVERS=$9

SPECIAL_OPTS="-Dgenerator.bid.ratio=0 -Dgenerator.auction.ratio=4 -Dgenerator.person.ratio=1 -Dgenerator.auction.hot=85"
JAVA_OPTS="-Xms24G -XX:+TieredCompilation -XX:+UseCompressedOops -server -XX:+UseG1GC -Xmx24G $SPECIAL_OPTS"
java $JAVA_OPTS -jar /opt/ventura/framework/data-generator/im-generator-4.0.0-SNAPSHOT.jar -csv /opt/ventura/framework/data-generator/ -kafkaServers $KAFKA_SERVERS -hostname $(hostname) -personsPartition $NUM_PARTITION_PERSON -auctionsPartition $NUM_PARTITION_AUCTIONS -personsWorkers $NUM_WORKERS_PERSONS -auctionsWorkers $NUM_WORKERS_AUCTIONS -inputSizeItemsAuctions $SIZE_AUCTIONS -inputSizeItemsPersons $SIZE_PERSONS -desiredPersonsThroughputKBSec $DESIRED_PERSONS -desiredAuctionsThroughputKBSec $DESIRED_AUCTIONS   > /opt/ventura/framework/data-generator/generator-$(hostname).log 2>&1 &
pid=$!
echo $pid > /opt/ventura/framework/data-generator/gen.pid