#!/bin/bash

TM_ID=$1

/opt/ventura/framework/flink-build/bin/flink remove -tm $TM_ID
