#!/bin/bash

HOSTNAME=`hostname`


cd $TARGET_DIR/ 
mkdir logs > /dev/null 2>&1

git clone https://github.com/VenturaDelMonte/dstat.git > /dev/null 2>&1 
$GSUTIL cp gs://$REMOTE_BUCKET/scripts.7z $TARGET_DIR/ > /dev/null 2>&1 & 
$GSUTIL cp gs://$REMOTE_BUCKET/kafka.7z $TARGET_DIR/ > /dev/null 2>&1 &
wait
LC_ALL=C
7z x $TARGET_DIR/kafka.7z > /dev/null 2>&1 &
7z x $TARGET_DIR/scripts.7z > /dev/null 2>&1 &
wait
rm -rf $TARGET_DIR/scripts.7z > /dev/null 2>&1
rm -rf $TARGET_DIR/kafka.7z > /dev/null 2>&1




