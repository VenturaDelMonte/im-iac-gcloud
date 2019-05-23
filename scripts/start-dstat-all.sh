#!/bin/bash

BASEDIR=/opt/ventura/framework
CMD="$BASEDIR/dstat/start-dstat.sh"
SSH_CMD="nohup /bin/sh -c '$CMD' > /dev/null 2>&1 &"
pdsh -w im-worker-[1-12] -- $SSH_CMD
wait