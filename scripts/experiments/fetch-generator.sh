#!/bin/bash

TARGET_DIR=/opt/ventura/framework/data-generator
REMOTE_BUCKET=code-incremental-migration

pdsh -w im-generator-[01-04] '$GSUTIL cp gs://$REMOTE_BUCKET/im-generator-4.0.0-SNAPSHOT.jar $TARGET_DIR/ > /dev/null 2>&1' 
