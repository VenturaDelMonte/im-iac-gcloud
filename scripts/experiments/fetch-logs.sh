#!/usr/bin/env bash

TARGET=/opt/ventura/framework

extractHostName() {
    # handle comments: extract first part of string (before first # character
    SLAVE=`echo $1 | cut -d'#' -f 1`
    # Extract the hostname from the network hierarchy
    if [[ "$SLAVE" =~ ^.*/([0-9a-zA-Z.-]+)$ ]]; then
        SLAVE=${BASH_REMATCH[1]}
    fi
    echo $SLAVE
}

DIRECTORY=/opt/ventura/framework/all_logs
if [ -d "$DIRECTORY" ]; then
    NUM_DIRS=$(find . -maxdepth 1 -type d -name "all_logs*" | wc -l)
    mv $DIRECTORY /opt/ventura/framework/all_logs_$NUM_DIRS
fi

mkdir -p /opt/ventura/framework/all_logs > /dev/null 2>&1

mv /opt/ventura/framework/flink-build/log/* /opt/ventura/framework/all_logs/ > /dev/null 2>&1

SLAVE_FILE=/opt/ventura/framework/flink-build/conf/slaves
GOON=true
while $GOON; do
    read line || GOON=false
    HOST=$(extractHostName $line)
    if [ -n "$HOST" ] ; then
       echo "Fetching from $HOST"
       mkdir -p "$DIRECTORY/latencies/$HOST"
       scp $HOST:/opt/ventura/framework/flink-build/log/*.out* "$DIRECTORY/" > /dev/null 2>&1 &
       scp $HOST:/opt/ventura/framework/flink-build/log/*.log* "$DIRECTORY/" > /dev/null 2>&1 &
       scp $HOST:/opt/ventura/framework/flink-build/log/*.metrics* "$DIRECTORY/" > /dev/null 2>&1 &
       scp -rp $HOST:/opt/ventura/framework/flink-build/log/latencies/* "$DIRECTORY/latencies/$HOST/" > /dev/null 2>&1 &
       scp $HOST:/opt/ventura/framework/logs/dstat-$HOST.csv "$DIRECTORY/" > /dev/null 2>&1 &
       wait
       ssh -n $HOST 'rm -rf /opt/ventura/framework/flink-build/log/*.log*' > /dev/null 2>&1 &
       ssh -n $HOST 'rm -rf /opt/ventura/framework/flink-build/log/*.out*' > /dev/null 2>&1 &
       ssh -n $HOST 'rm -rf /opt/ventura/framework/flink-build/log/latencies' > /dev/null 2>&1 &
       ssh -n $HOST 'rm -rf /opt/ventura/framework/flink-build/log/*.metrics*' > /dev/null 2>&1 &
       ssh -n $HOST 'rm -rf /opt/ventura/framework/logs/*' > /dev/null 2>&1 &
       wait
    fi
done < "$SLAVE_FILE"

for i in {1..4}
do
    HOST="im-generator-0$i"
    echo "Fetching from $HOST"
    scp $HOST:/opt/ventura/framework/data-generator/*.csv* "$DIRECTORY/" > /dev/null 2>&1 &
    scp $HOST:/opt/ventura/framework/data-generator/*.log* "$DIRECTORY/" > /dev/null 2>&1 &
    scp $HOST:/opt/ventura/framework/logs/dstat-$HOST.csv "$DIRECTORY/" > /dev/null 2>&1 &
    wait
    ssh -n $HOST 'rm -rf /opt/ventura/framework/data-generator/*.csv*' > /dev/null 2>&1 &
    ssh -n $HOST 'rm -rf /opt/ventura/framework/data-generator/*.log*' > /dev/null 2>&1 &
    ssh -n $HOST 'rm -rf /opt/ventura/framework/logs/*' > /dev/null 2>&1  &
    wait
done

for i in {1..4}
do
    HOST="im-broker-0$i"
    echo "Fetching from $HOST"
    scp $HOST:/opt/ventura/framework/logs/dstat-$HOST.csv "$DIRECTORY/" > /dev/null 2>&1 
    ssh -n $HOST 'rm -rf /opt/ventura/framework/logs/*' > /dev/null 2>&1 
done

rm -rf /opt/ventura/framework/all_logs.7z > /dev/null 2>&1

LC_ALL=C
7z a -t7z  -m0=LZMA2:d64k:fb32 -ms=8m -mx=7 -mmt=8 all_logs.7z ./all_logs

REMOTE_BUCKET=code-incremental-migration
$GSUTIL cp ./all_logs.7z  gs://$REMOTE_BUCKET/

