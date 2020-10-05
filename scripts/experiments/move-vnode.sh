#!/bin/bash

JOB_ID=$1
TARGET_INDEX=$2
QUERY=$3
if [[ $QUERY == *"q8"* ]]; then
/opt/ventura/framework/flink-build/bin/flink move $JOB_ID -ti $TARGET_INDEX,-1  -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
elif [[ $QUERY == *"q5"* ]]; then
/opt/ventura/framework/flink-build/bin/flink move $JOB_ID -ti $TARGET_INDEX,-1  -tv 0 -to "Nexmark4Aggregator -> Sink: Nexmark4Sink"
elif [[ $QUERY == *"qx"* ]]; then
/opt/ventura/framework/flink-build/bin/flink move $JOB_ID -ti $TARGET_INDEX,-1  -tv 0 -to "winningBids -> Sink: NexmarkXSink"
fi