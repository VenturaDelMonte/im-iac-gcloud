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

DIRECTORY=/opt/ventura/framework/all_logs_vanilla
if [ -d "$DIRECTORY" ]; then
    NUM_DIRS=$(find . -maxdepth 1 -type d -name "all_logs_vanilla*" | wc -l)
    mv $DIRECTORY /opt/ventura/framework/all_logs_vanilla_$NUM_DIRS
fi


rm -rf /opt/ventura/framework/flink-vanilla/log/* > /dev/null 2>&1

SLAVE_FILE=/opt/ventura/framework/flink-vanilla/conf/slaves
GOON=true
while $GOON; do
    read line || GOON=false
    HOST=$(extractHostName $line)
    if [ -n "$HOST" ] ; then
       echo "Deleting from $HOST"
       ssh -n $HOST 'rm -rf /opt/ventura/framework/flink-vanilla/log/*' > /dev/null 2>&1 &
       ssh -n $HOST 'rm -rf /opt/ventura/framework/logs/*' > /dev/null 2>&1 &
       wait
    fi
done < "$SLAVE_FILE"

for i in {1..4}
do
    HOST="im-generator-0$i"
    echo "Deleting from $HOST"
    ssh -n $HOST 'rm -rf /opt/ventura/framework/data-generator/*.log*' > /dev/null 2>&1 &
    ssh -n $HOST 'rm -rf /opt/ventura/framework/logs/*' > /dev/null 2>&1 &
    wait
done

for i in {1..4}
do
    HOST="im-broker-0$i"
    echo "Deleting from $HOST"
    ssh -n $HOST 'rm -rf /opt/ventura/framework/logs/*' > /dev/null 2>&1 
done


