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
    g++ \
    openjdk-8-jdk \
    tmux \
    vim \
    cmake \
    iperf3 \
    git \
    htop \
    pdsh \
    lvm2; do
    sleep 2
  done

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

until apt-get install -y \
    maven; do
    sleep 2
done

echo 3 | sudo tee /proc/sys/vm/drop_caches

mkdir -p /opt/ventura
mkdir -p /opt/ventura/framework
chown -R ventura:ventura /opt/ventura/framework

touch /opt/ventura/.bootstrap_complete