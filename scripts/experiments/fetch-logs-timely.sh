#!/usr/bin/env bash

TARGET=/opt/ventura/framework
REMOTE_BUCKET=code-incremental-migration

extractHostName() {
    # handle comments: extract first part of string (before first # character
    SLAVE=`echo $1 | cut -d'#' -f 1`
    # Extract the hostname from the network hierarchy
    if [[ "$SLAVE" =~ ^.*/([0-9a-zA-Z.-]+)$ ]]; then
        SLAVE=${BASH_REMATCH[1]}
    fi
    echo $SLAVE
}

DIRECTORY=/opt/ventura/framework/all_logs_timely
if [ -d "$DIRECTORY" ]; then
    NUM_DIRS=$(find . -maxdepth 1 -type d -name "all_logs_timely*" | wc -l)
    mv $DIRECTORY /opt/ventura/framework/all_logs_timely_$NUM_DIRS
fi

mkdir -p /opt/ventura/framework/all_logs_timely > /dev/null 2>&1

for i in {1..8}
do
    HOST="im-worker-0$i"
    echo "Fetching from $HOST"
    scp $HOST:/opt/ventura/framework/logs/* "$DIRECTORY/" > /dev/null 2>&1
    ssh -n $HOST 'rm -rf /opt/ventura/framework/logs/*' > /dev/null 2>&1
done

# for i in {1..8}
# do
#     touch $DIRECTORY/latency-0$i.csv
#     echo "measurement,index,mean,ts" >> $DIRECTORY/latency-0$i.csv
#     cat $DIRECTORY/log_timely_im-worker-0$i.log | grep latency >> $DIRECTORY/latency-0$i.csv
# done

rm -rf /opt/ventura/framework/all_logs_timely.7z > /dev/null 2>&1

LC_ALL=C
7z a -t7z  -m0=LZMA2:d64k:fb32 -ms=8m -mx=7 -mmt=8 /opt/ventura/framework/all_logs_timely.7z $DIRECTORY/*

$GSUTIL cp /opt/ventura/framework/all_logs_timely.7z  gs://$REMOTE_BUCKET/

