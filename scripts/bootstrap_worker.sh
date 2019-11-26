#!/bin/bash

exec &> >(tee -a /tmp/bootstrap.log)

until apt update; do
    sleep 2
done

# until apt upgrade -y; do
#     sleep 2
# done

until apt install -y unzip less p7zip-full python vnstat openjdk-8-jdk python-six iperf3 vim htop git; do
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

mkdir -p /opt/ventura
mkdir -p /opt/ventura/framework
chown -R ventura:ventura /opt/ventura/framework

# mkdir -p /data/1/
# mkfs.ext4 -F /dev/nvme0n1
# mount -o discard,defaults,nobarrier,noatime /dev/nvme0n1 /data/1/
# chmod a+w /data/1/
# mkdir -p /data/1/data
# mkdir -p /data/1/tmp
# mkdir -p /data/1/check
# mkdir -p /data/1/kafka
# mkdir -p /data/1/flink
# chown -R ventura:ventura /data/1/

# mkdir -p /data/2/
# mkfs.ext4 -F /dev/nvme0n2
# mount -o discard,defaults,nobarrier,noatime /dev/nvme0n2 /data/2/
# chmod a+w /data/2/
# mkdir -p /data/2/kafka
# mkdir -p /data/2/flink
# chown -R ventura:ventura /data/2/

sysctl vm.swappiness=1
echo 3 | sudo tee /proc/sys/vm/drop_caches

echo "* - nofile 65536" | tee -a /etc/security/limits.conf
echo "* - nproc 65536" | tee -a /etc/security/limits.conf
echo "* - memlock unlimited" | tee -a /etc/security/limits.conf

touch /opt/ventura/.bootstrap_complete
echo `date` | tee -a /opt/ventura/.bootstrap_complete
