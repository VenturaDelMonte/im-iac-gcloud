#!/bin/bash

HOSTNAME=`hostname`
#TARGET_DIR=/opt/ventura/framework
#REMOTE_BUCKET=code-incremental-migration

cd $TARGET_DIR/ 
mkdir data-generator > /dev/null 2>&1
mkdir logs > /dev/null 2>&1
$GSUTIL cp gs://$REMOTE_BUCKET/im-generator-4.0.0-SNAPSHOT.jar $TARGET_DIR/data-generator/ > /dev/null 2>&1 &
$GSUTIL cp gs://$REMOTE_BUCKET/scripts.7z $TARGET_DIR/ > /dev/null 2>&1 &
git clone https://github.com/VenturaDelMonte/dstat.git > /dev/null 2>&1 &
wait
7z x ./scripts.7z > /dev/null 2>&1 
rm -rf ./scripts.7z




