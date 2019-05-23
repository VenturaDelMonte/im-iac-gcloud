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
    ntp \
    vim \
    htop \
    lvm2; do
    sleep 2
  done

echo 3 | sudo tee /proc/sys/vm/drop_caches

service ntp stop
cp /etc/ntp.conf /etc/ntp.conf.backup
sed -i '/^pool/s/^/#/g' /etc/ntp.conf
echo "server metadata.google.internal iburst" | tee -a /etc/ntp.conf
service ntp restart

mkdir -p /opt/ventura
mkdir -p /opt/ventura/framework
chown -R ventura:ventura /opt/ventura/framework

mkdir -p /data/1/
mkfs.ext4 -F /dev/nvme0n1
mount /dev/nvme0n1 /data/1/
chmod a+w /data/1/
chown -R ventura:ventura /data/1/

mkdir -p /data/2/
mkfs.ext4 -F /dev/nvme0n2
mount /dev/nvme0n2 /data/2/
chmod a+w /data/2/
chown -R ventura:ventura /data/2/

echo "* - nofile 65536" | tee -a /etc/security/limits.conf
echo "* - nproc 65536" | tee -a /etc/security/limits.conf
echo "* - memlock unlimited" | tee -a /etc/security/limits.conf

touch /opt/ventura/.bootstrap_complete