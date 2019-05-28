#!/bin/bash

HOSTNAME=`hostname`
TARGET_DIR=/opt/ventura/framework
REMOTE_BUCKET=code-incremental-migration

cd $TARGET_DIR/ 

/snap/bin/gsutil cp gs://$REMOTE_BUCKET/generator.7z $TARGET_DIR/ > /dev/null 2>&1 
LC_ALL=C
7z x $TARGET_DIR/generator.7z > /dev/null 2>&1
rm -rf $TARGET_DIR/generator.7z > /dev/null 2>&1

git clone https://github.com/VenturaDelMonte/dstat.git > /dev/null 2>&1

