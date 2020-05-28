#!/bin/bash

exec &> >(tee -a /tmp/bootstrap.log)

until apt update; do
    sleep 2
done

# until apt upgrade -y; do
#     sleep 2
# done

until apt install -y unzip p7zip-full python g++ openjdk-8-jdk tmux vim cmake iperf3 htop pdsh git; do
    sleep 2
done

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

until apt-get install -y \
    maven; do
    sleep 2
done

# service ntp stop
# cp /etc/ntp.conf /etc/ntp.conf.backup
# cp /home/ventura/ntp.conf /etc/ntp.conf
# chown root:root /etc/ntp.conf
# ntpdate -dv metadata.google.internal
# service ntp restart

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
mkdir -p /data/1/flink
chown -R ventura:ventura /data/1

mkdir -p /data/2
mkdir -p /data/2/zookeeper/tmp/
mkdir -p /data/2/flink
chown -R ventura:ventura /data/2

echo "* - nofile 65536" | tee -a /etc/security/limits.conf
echo "* - nproc 65536" | tee -a /etc/security/limits.conf
echo "* - memlock unlimited" | tee -a /etc/security/limits.conf

touch /opt/ventura/.bootstrap_complete