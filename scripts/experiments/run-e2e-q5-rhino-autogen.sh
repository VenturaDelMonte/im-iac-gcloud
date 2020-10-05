#!/bin/bash

$EXPERIMENT_DIR/flink-build/bin/start-cluster.sh
sleep 10
$EXPERIMENT_DIR/scripts/run-q4-rhino-autogen.sh
