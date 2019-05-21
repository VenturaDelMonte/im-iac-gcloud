#!/bin/bash

HOSTNAME=`hostname`
TARGET_DIR=/opt/ventura/framework
REMOTE_BUCKET=code-incremental-migration

cd $TARGET_DIR/ 

/snap/bin/gsutil cp gs://$REMOTE_BUCKET/flink-build.7z $TARGET_DIR/ &
if [[ $HOSTNAME == *"master"* ]]; then
    mkdir -p $TARGET_DIR/flink-build-jobs
    /snap/bin/gsutil cp gs://$REMOTE_BUCKET/im-job-benchmarks_2.11-0.1-SNAPSHOT.jar $TARGET_DIR/flink-build-jobs &
    /snap/bin/gsutil cp gs://$REMOTE_BUCKET/scripts.7z $TARGET_DIR/ &
fi

wait

LC_ALL=C
7z x ./flink-build.7z
rm -rf ./flink-build.7z

mv $TARGET_DIR/flink-build/opt/* $TARGET_DIR/flink-build/lib/

if [[ $HOSTNAME == *"master"* ]]; then
    7z x ./scripts.7z
    rm -rf $TARGET_DIR/scripts.7z
fi