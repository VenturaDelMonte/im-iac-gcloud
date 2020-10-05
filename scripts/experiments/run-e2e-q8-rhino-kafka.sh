#!/bin/bash

$EXPERIMENT_DIR/flink-build/bin/start-cluster.sh
$EXPERIMENT_DIR/scripts/start-kafka.sh
sleep 10
$EXPERIMENT_DIR/scripts/run-q8-rhino-kafka.sh
