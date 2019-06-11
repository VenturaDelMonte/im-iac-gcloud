#!/bin/bash

pdsh -w im-worker-0[1-8],im-broker-0[1-4],im-generator-0[1-4] 'echo 3 | sudo tee /proc/sys/vm/drop_caches'
