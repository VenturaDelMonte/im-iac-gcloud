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
    ntp \
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

service ntp stop
cp /etc/ntp.conf /etc/ntp.conf.backup
sed -i '/^pool/s/^/#/g' /etc/ntp.conf
echo "server metadata.google.internal iburst" | tee -a /etc/ntp.conf
service ntp restart

curl -sSO https://dl.google.com/cloudagents/install-monitoring-agent.sh
bash install-monitoring-agent.sh

echo 3 | sudo tee /proc/sys/vm/drop_caches

mkdir -p /opt/ventura
mkdir -p /opt/ventura/framework
chown -R ventura:ventura /opt/ventura/framework

mkdir -p /data/1/data
mkdir -p /data/1/check
mkdir -p /data/1/tmp
mkdir -p /data/1/namenode
chown -R ventura:ventura /data/1

mkdir -p /data/2
mkdir -p /data/2/zookeeper/tmp/
chown -R ventura:ventura /data/2

echo "* - nofile 65536" | tee -a /etc/security/limits.conf
echo "* - nproc 65536" | tee -a /etc/security/limits.conf
echo "* - memlock unlimited" | tee -a /etc/security/limits.conf

touch /opt/ventura/.bootstrap_complete