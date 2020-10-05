#!/bin/bash

BASEDIR=/opt/ventura/framework
PID=$(tail -n 1 "$BASEDIR/dstat/dstat.pid")
kill -9 $PID > /dev/null 2>&1
rm -rf $BASEDIR/dstat/dstat.pid