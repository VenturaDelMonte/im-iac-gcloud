#!/bin/bash

DURATION=$1
RATE=$2
INDEX=$3
QUERY=$4
WORKERS=$5
MIGRATION=$6
NUM_SOURCE=$7

export RUST_BACKTRACE=1
$EXPERIMENT_DIR/megaphone/timely_kafka --brokers `cat /tmp/brokers.txt` --source $NUM_SOURCE --statm --migration $MIGRATION --duration $DURATION --queries $QUERY --rate $RATE -- -w 8 -h $EXPERIMENT_DIR/scripts/workers.txt -p $INDEX -n $WORKERS > $EXPERIMENT_DIR/logs/log_timely_`hostname`.log 2>&1 &
pid=$!
echo $pid >> /tmp/timely.pid 2>&1



