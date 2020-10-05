#!/bin/bash

rm -rf /vagrant/binaries/megaphone/*
cp -R /home/vagrant/repos/megaphone-rhino/nexmark/target/release/timely* /vagrant/binaries/megaphone/
rm -rf megaphone.7z
7z a -t7z  -mx=9 -m0=LZMA2 -mmt4 /vagrant/binaries/megaphone.7z /vagrant/binaries/megaphone/* 
gsutil cp /vagrant/binaries/megaphone.7z gs://code-incremental-migration
