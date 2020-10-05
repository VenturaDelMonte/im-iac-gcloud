#!/bin/bash

JOB_ID=$1
NEW_PARALLELISM=$2
QUERY=$3

#ssh im-worker-08 '$EXPERIMENT_DIR/flink-vanilla/bin/taskmanager.sh start > /dev/null 2>&1'
RESULT=$($EXPERIMENT_DIR/flink-vanilla/bin/flink cancel -s $JOB_ID 2>&1)
echo $RESULT
SAVEPOINT_PATH=$(python $EXPERIMENT_DIR/scripts/extract_savepoint_path.py "$RESULT")
echo $SAVEPOINT_PATH
RUNNING_JOBS=$($EXPERIMENT_DIR/flink-vanilla/bin/flink list -r 2>&1)
while [[ ! $RUNNING_JOBS == *"No running jobs"* ]]
do
    echo "Still running..."
    sleep 1
    RUNNING_JOBS=$($EXPERIMENT_DIR/flink-vanilla/bin/flink list -r 2>&1)
done

$EXPERIMENT_DIR/scripts/run-$QUERY-vanilla-kafka.sh $SAVEPOINT_PATH $NEW_PARALLELISM
#echo "im-worker-08" | tee -a $EXPERIMENT_DIR/flink-vanilla/conf/slaves