#!/bin/bash

CMD="/opt/ventura/framework/scripts/stop-timely.sh"
SSH_CMD="nohup /bin/sh -c '$CMD' > /dev/null 2>&1 &"
pdsh -w im-worker-[01-12] -- $SSH_CMD
wait
