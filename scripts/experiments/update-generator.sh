#!/bin/bash


pdsh -w im-worker-[01-04] 'scp im-master:/opt/ventura/framework/scripts/start-generator.sh /opt/ventura/framework/scripts/start-generator.sh'