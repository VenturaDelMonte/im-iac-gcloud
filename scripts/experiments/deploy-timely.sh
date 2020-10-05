#!/bin/bash

mkdir -p $EXPERIMENT_DIR/megaphone-repos
cd megaphone-repos
if [ "$(ls -A $EXPERIMENT_DIR/megaphone-repos/)" ]; then
cd megaphone-rhino
git fetch
git reset --hard HEAD^^^^^
git rebase origin/master
else
git clone https://venturadelmonte@github.com/VenturaDelMonte/megaphone-rhino.git
cd megaphone-rhino
fi
cd nexmark
cargo build --release

pdsh -w im-worker-[01-08] 'rm -rf $EXPERIMENT_DIR/megaphone/*; scp im-master:$EXPERIMENT_DIR/megaphone-repos/megaphone-rhino/nexmark/target/release/timely* $EXPERIMENT_DIR/megaphone/'

rm -rf $EXPERIMENT_DIR/megaphone-repos/megaphone-rhino/megaphone.7z
7z a -t7z  -mx=1 -m0=LZMA2 -mmt8 $EXPERIMENT_DIR/megaphone-repos/megaphone-rhino/megaphone.7z $EXPERIMENT_DIR/megaphone-repos/megaphone-rhino/nexmark/target/release/timely*
gsutil cp $EXPERIMENT_DIR/megaphone-repos/megaphone-rhino/megaphone.7z gs://code-incremental-migration/