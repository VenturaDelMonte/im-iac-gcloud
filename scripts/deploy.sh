#!/bin/bash

HOSTNAME=`hostname`
# TARGET_DIR=/opt/ventura/framework
# REMOTE_BUCKET=code-incremental-migration

cd $TARGET_DIR/ 

$GSUTIL cp gs://$REMOTE_BUCKET/flink-build.7z $TARGET_DIR/ > /dev/null 2>&1 &
$GSUTIL cp gs://$REMOTE_BUCKET/flink-vanilla.7z $TARGET_DIR/ > /dev/null 2>&1 &
$GSUTIL cp gs://$REMOTE_BUCKET/hdfs.7z $TARGET_DIR/ > /dev/null 2>&1 &
$GSUTIL cp gs://$REMOTE_BUCKET/scripts.7z $TARGET_DIR/ > /dev/null 2>&1 &

if [[ $HOSTNAME == *"master"* ]]; then
    mkdir -p $TARGET_DIR/flink-build-jobs > /dev/null 2>&1
    $GSUTIL cp gs://$REMOTE_BUCKET/im-job-benchmarks_2.11-0.1-SNAPSHOT.jar $TARGET_DIR/flink-build-jobs/ > /dev/null 2>&1 &
    $GSUTIL cp gs://$REMOTE_BUCKET/im-job-vanilla-benchmarks_2.11-0.1-SNAPSHOT.jar $TARGET_DIR/flink-build-jobs/ > /dev/null 2>&1 &
    $GSUTIL cp gs://$REMOTE_BUCKET/kafka.7z $TARGET_DIR/ > /dev/null 2>&1 &
fi

git clone https://github.com/VenturaDelMonte/dstat.git > /dev/null 2>&1 &

wait

LC_ALL=C
7z x ./flink-build.7z > /dev/null 2>&1 &
7z x ./flink-vanilla.7z > /dev/null 2>&1 &
7z x ./hdfs.7z > /dev/null 2>&1 &
7z x ./scripts.7z > /dev/null 2>&1 &
wait
rm -rf ./flink-build.7z > /dev/null 2>&1
rm -rf ./flink-vanilla.7z > /dev/null 2>&1
rm -rf ./hdfs.7z > /dev/null 2>&1
rm -rf $TARGET_DIR/scripts.7z > /dev/null 2>&1

mv $TARGET_DIR/flink-build/opt/* $TARGET_DIR/flink-build/lib/ > /dev/null 2>&1

$GSUTIL cp gs://$REMOTE_BUCKET/flink-conf.yaml $TARGET_DIR/flink-build/conf/ > /dev/null 2>&1

if [[ $HOSTNAME == *"master"* ]]; then
    ./hdfs/bin/hadoop namenode -format > /dev/null 2>&1 &
    LC_ALL=C
    7z x ./kafka.7z > /dev/null 2>&1 &
    wait
    rm -rf $TARGET_DIR/kafka.7z > /dev/null 2>&1
fi


mkdir logs > /dev/null 2>&1