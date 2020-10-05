#!/bin/bash

TARGET_DIR=/opt/ventura/framework
REMOTE_BUCKET=code-incremental-migration

$GSUTIL cp gs://$REMOTE_BUCKET/flink-build/flink-conf.yaml $TARGET_DIR/flink-build/conf/ > /dev/null 2>&1
pdsh -w im-worker-[01-12] 'export TARGET_DIR=/opt/ventura/framework; export REMOTE_BUCKET=code-incremental-migration; gsutil cp gs://$REMOTE_BUCKET//flink-build/flink-conf.yaml $TARGET_DIR/flink-build/conf/ > /dev/null 2>&1'

$GSUTIL cp gs://$REMOTE_BUCKET/flink-vanilla/flink-conf.yaml $TARGET_DIR/flink-vanilla/conf/ > /dev/null 2>&1
pdsh -w im-worker-[01-12] 'export TARGET_DIR=/opt/ventura/framework; export REMOTE_BUCKET=code-incremental-migration; gsutil cp gs://$REMOTE_BUCKET/flink-vanilla/flink-conf.yaml $TARGET_DIR/flink-vanilla/conf/ > /dev/null 2>&1'

