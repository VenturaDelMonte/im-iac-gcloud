#!/bin/bash

BASEDIR=/opt/ventura/framework
CMD="$BASEDIR/dstat/stop-dstat.sh"
SSH_CMD="nohup /bin/sh -c '$CMD' > /dev/null 2>&1 &"
pdsh -w im-worker-0[1-8],im-broker-0[1-4],im-generator-0[1-4] -- $SSH_CMD
wait