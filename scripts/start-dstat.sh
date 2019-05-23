#!/bin/bash

BASEDIR=/opt/ventura/framework
TARGET_LOG_FILE=$BASEDIR/logs/dstat-`hostname`.csv

rm -rf $TARGET_LOG_FILE
python $BASEDIR/dstat/dstat -cdgmnrpryl --mem-adv -C 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,total --epoch --noheaders --vm-adv --aio  --bw --nocolor --output $TARGET_LOG_FILE 5 > /dev/null 2>&1 &
pid=$!

echo $pid > $BASEDIR/dstat/dstat.pid
