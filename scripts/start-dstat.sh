#!/bin/bash

BASEDIR=/opt/ventura/framework
TARGET_LOG_FILE=$BASEDIR/logs/dstat-`hostname`.csv

rm -rf $TARGET_LOG_FILE
python $BASEDIR/dstat/dstat -cdgmnrpryl --mem-adv --ipc --epoch --noheaders --vm-adv --aio  --bw --nocolor --output $TARGET_LOG_FILE 5 > /dev/null 2>&1 &
pid=$!

echo $pid > $BASEDIR/dstat/dstat.pid
