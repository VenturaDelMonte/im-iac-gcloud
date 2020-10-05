#!/bin/bash

DURATION=$1
RATE=100000
QUERY=q8
WORKERS=$2

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
WORKER_PARALLELISM=`expr 8 \* 7`
#WORKER_PARALLELISM=105
WINDOW_SLIDE=60
#WINDOW_SIZE=86400
#WINDOW_SIZE=800
WINDOW_TYPE=0
REPLICA_SLOTS=2
#CHECKPOINT_INTERVAL=180000
MAX_PARALLELISM=32768
CHECKPOINT_INTERVAL=180000
VIRTUAL_NODES=4
PARALLEL_CHECKPOINT=1
KAFKA_SERVERS=`cat /tmp/brokers.txt`

$EXPERIMENT_DIR/scripts/create-nexmark-topics.sh $NUM_PARTITION_PERSON $NUM_PARTITION_AUCTIONS

for INDEX in $(seq 1 $WORKERS);
do
    WIDX=`expr $INDEX - 1`
    HOST="im-worker-0$INDEX"
    echo "Launching timely on $HOST as worker $WIDX"
    CMD="/opt/ventura/framework/scripts/run-timely-kafka.sh $DURATION $RATE $WIDX $QUERY $WORKERS rhino $NUM_PARTITION_PERSON"
    SSH_CMD="nohup /bin/sh -c '$CMD' > /dev/null 2>&1 &"
    ssh -n $HOST -- $SSH_CMD
done

sleep 30

PARAMS="$NUM_PARTITION_PERSON $NUM_PARTITION_AUCTIONS $NUM_WORKERS_PERSONS $NUM_WORKERS_AUCTIONS $SIZE_PERSONS $SIZE_AUCTIONS $DESIRED_PERSONS $DESIRED_AUCTIONS $KAFKA_SERVERS"
CMD="/opt/ventura/framework/scripts/start-generator-q8-rust.sh $PARAMS"
pdsh -w im-generator-0[1-$NUM_GENERATORS] "nohup /bin/sh -c '$CMD' > /dev/null 2>&1 &"