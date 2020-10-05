#!/bin/bash

BASEDIR=/opt/ventura/framework
CMD="$BASEDIR/scripts/start-dstat.sh"
SSH_CMD="nohup /bin/sh -c '$CMD' > /dev/null 2>&1 &"
pdsh -w im-worker-[01-12] -- $SSH_CMD
pdsh -w im-broker-[01-05] -- $SSH_CMD
pdsh -w im-generator-[01-05] -- $SSH_CMD

