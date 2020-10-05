#!/bin/bash

JOB_ID=$1
QUERY=$2
SCALING_FACTOR=$3

if [[ $QUERY == *"q8"* ]]; then
/opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
elif [[ $QUERY == *"q5"* ]]; then
/opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "Nexmark4Aggregator -> Sink: Nexmark4Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "Nexmark4Aggregator -> Sink: Nexmark4Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "Nexmark4Aggregator -> Sink: Nexmark4Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "Nexmark4Aggregator -> Sink: Nexmark4Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "Nexmark4Aggregator -> Sink: Nexmark4Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "Nexmark4Aggregator -> Sink: Nexmark4Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "Nexmark4Aggregator -> Sink: Nexmark4Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "Nexmark4Aggregator -> Sink: Nexmark4Sink"
elif [[ $QUERY == *"qx"* ]]; then
/opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "winningBids -> Sink: NexmarkXSink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
# /opt/ventura/framework/flink-build/bin/flink rescale $JOB_ID -ti "-1" -s $SCALING_FACTOR -tv 0 -to "WindowOperator(43200) -> Sink: Nexmark8Sink"
fi 
