#!/bin/bash

PID=$(tail -n 1 "/tmp/timely.pid")
kill -9 $PID > /dev/null 2>&1
rm -rf /tmp/timely.pid
