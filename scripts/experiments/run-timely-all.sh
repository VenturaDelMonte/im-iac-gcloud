#!/bin/bash

DURATION=$1
RATE=$2
QUERY=$3
WORKERS=$4
DILATION=$5

for INDEX in $(seq 1 $WORKERS);
do
    WIDX=`expr $INDEX - 1`
    HOST="im-worker-0$INDEX"
    echo "Launching timely on $HOST as worker $WIDX"
    CMD="/opt/ventura/framework/scripts/run-timely.sh $DURATION $RATE $WIDX $QUERY $WORKERS rhino2 $DILATION"
    SSH_CMD="nohup /bin/sh -c '$CMD' > /dev/null 2>&1 &"
    ssh -n $HOST -- $SSH_CMD
done

$EXPERIMENT_DIR/scripts/start-dstat-all.sh
