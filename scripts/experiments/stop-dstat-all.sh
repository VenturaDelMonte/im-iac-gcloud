#!/bin/bash

BASEDIR=/opt/ventura/framework
CMD="$BASEDIR/dstat/stop-dstat.sh"
SSH_CMD="nohup /bin/sh -c '$CMD' > /dev/null 2>&1 &"
pdsh -w im-worker-[01-12] -- $SSH_CMD
wait
