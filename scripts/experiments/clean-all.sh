#!/bin/bash

pdsh -w im-broker-0[1-4] 'rm -rf /data/1/*'
pdsh -w im-broker-0[1-4] 'rm -rf /data/2/*'

pdsh -w im-worker-0[1-8] 'rm -rf /data/1/*'
pdsh -w im-worker-0[1-8] 'rm -rf /data/2/*'




