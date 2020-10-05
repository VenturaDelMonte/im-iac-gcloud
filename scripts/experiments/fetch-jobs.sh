#!/bin/bash

TARGET_DIR=/opt/ventura/framework
REMOTE_BUCKET=code-incremental-migration

$GSUTIL cp gs://$REMOTE_BUCKET/im-job-benchmarks_2.11-0.1-SNAPSHOT.jar $TARGET_DIR/flink-build-jobs/ > /dev/null 2>&1 &
$GSUTIL cp gs://$REMOTE_BUCKET/im-job-vanilla-benchmarks_2.11-0.1-SNAPSHOT.jar $TARGET_DIR/flink-build-jobs/ > /dev/null 2>&1 &
wait
