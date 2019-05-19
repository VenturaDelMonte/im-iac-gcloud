#!/bin/bash

exec &> >(tee -a /tmp/bootstrap.log)

until apt-get update; do
    sleep 2
done

until apt-get install -y \
    unzip \
    p7zip-full \
    python \
    thin-provisioning-tools \
    pv \
    nfs-client \
    openjdk-8-jdk \
    iperf3 \
    vim \
    htop \
    lvm2; do
    sleep 2
  done

echo 3 | sudo tee /proc/sys/vm/drop_caches

mkdir -p /opt/ventura
mkdir -p /opt/ventura/framework
chown -R ventura:ventura /opt/ventura/framework

touch /opt/ventura/.bootstrap_complete