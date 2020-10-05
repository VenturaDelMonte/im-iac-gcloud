#!/bin/bash

TARGET_DIR=/opt/ventura/framework
REMOTE_BUCKET=code-incremental-migration

$GSUTIL cp gs://$REMOTE_BUCKET/flink-build.7z $TARGET_DIR/ > /dev/null 2>&1 &
$GSUTIL cp gs://$REMOTE_BUCKET/flink-vanilla.7z $TARGET_DIR/ > /dev/null 2>&1 &
pdsh -w im-worker-0[1-8] 'TARGET_DIR=/opt/ventura/framework; REMOTE_BUCKET=code-incremental-migration; $GSUTIL cp gs://$REMOTE_BUCKET/flink-vanilla.7z $TARGET_DIR/ > /dev/null 2>&;  $GSUTIL cp gs://$REMOTE_BUCKET/flink-build.7z $TARGET_DIR/ > /dev/null 2>&1; LC_ALL=C; 7z x ./flink-build.7z > /dev/null 2>&1; rm -rf ./flink-build.7z > /dev/null 2>&1; 7z x ./flink-vanilla.7z > /dev/null 2>&1; rm -rf ./flink-vanilla.7z > /dev/null 2>&1'
wait
LC_ALL=C
7z x ./flink-build.7z > /dev/null 2>&1
rm -rf ./flink-build.7z > /dev/null 2>&1
#mv $TARGET_DIR/flink-build/opt/* $TARGET_DIR/flink-build/lib/ > /dev/null 2>&1
#pdsh -w im-worker-[1-12] 'TARGET_DIR=/opt/ventura/framework; mv $TARGET_DIR/flink-build/opt/* $TARGET_DIR/flink-build/lib/ > /dev/null 2>&1'

