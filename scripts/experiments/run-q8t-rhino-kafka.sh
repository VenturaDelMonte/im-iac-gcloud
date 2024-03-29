#!/bin/bash

NUM_GENERATORS=4
NUM_PARTITION_PERSON=32
NUM_PARTITION_AUCTIONS=32
NUM_WORKERS_PERSONS=4
NUM_WORKERS_AUCTIONS=4
SIZE_PERSONS=380000000
SIZE_AUCTIONS=7000000000
DESIRED_PERSONS=`expr 8 \* 1024`
DESIRED_AUCTIONS=`expr 8 \* 1024`
SOURCE_PARALLELISM=32
WINDOW_SIZE=43200
WORKER_PARALLELISM=56
#WORKER_PARALLELISM=105
WINDOW_SLIDE=60
#WINDOW_SIZE=86400
#WINDOW_SIZE=800
WINDOW_TYPE=0
REPLICA_SLOTS=2
CHECKPOINT_INTERVAL=180000
MAX_PARALLELISM=32768
#CHECKPOINT_INTERVAL=30000
VIRTUAL_NODES=4
PARALLEL_CHECKPOINT=1
KAFKA_SERVERS=`cat /tmp/brokers.txt`

$EXPERIMENT_DIR/scripts/create-nexmark-topics.sh $NUM_PARTITION_PERSON $NUM_PARTITION_AUCTIONS
sleep 2
$EXPERIMENT_DIR/scripts/start-dstat-all.sh

$EXPERIMENT_DIR/flink-build/bin/flink run $EXPERIMENT_JOBS_DIR/im-job-benchmarks_2.11-0.1-SNAPSHOT.jar -q8 -latencyTrackingInterval 0 -numOfVirtualNodes $VIRTUAL_NODES -sourceParallelism $SOURCE_PARALLELISM -windowType $WINDOW_TYPE -windowSlide $WINDOW_SLIDE -maxParallelism $MAX_PARALLELISM -kafkaServers $KAFKA_SERVERS  -numOfReplicaSlotsHint $REPLICA_SLOTS -windowParallelism $WORKER_PARALLELISM -concurrentCheckpoints $PARALLEL_CHECKPOINT -sinkParallelism $WORKER_PARALLELISM -checkpointingInterval $CHECKPOINT_INTERVAL -personStreamSizeGb $SIZE_PERSONS -auctionStreamSizeGb $SIZE_AUCTIONS -checkpointingTimeout 50000000 -windowDuration $WINDOW_SIZE -personToGenerate $SIZE_PERSONS -auctionsToGenerate $SIZE_AUCTIONS -personRate $DESIRED_PERSONS -auctionRate $DESIRED_AUCTIONS  > run-80.log 2>&1 & 

PARAMS="$NUM_PARTITION_PERSON $NUM_PARTITION_AUCTIONS $NUM_WORKERS_PERSONS $NUM_WORKERS_AUCTIONS $SIZE_PERSONS $SIZE_AUCTIONS $DESIRED_PERSONS $DESIRED_AUCTIONS $KAFKA_SERVERS"
CMD="/opt/ventura/framework/scripts/start-generator-q8t.sh $PARAMS"
pdsh -w im-generator-0[1-$NUM_GENERATORS] "nohup /bin/sh -c '$CMD' > /dev/null 2>&1 &"

