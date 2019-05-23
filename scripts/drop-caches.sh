#!/bin/bash

pdsh -w im-worker-[1-12] 'echo 3 | sudo tee /proc/sys/vm/drop_caches'
