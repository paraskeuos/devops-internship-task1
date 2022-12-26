#!/bin/bash

apt-get update
apt-get install -y openjdk-11-jre maven

useradd -m -s /bin/bash jenkins
echo -ne "jenkins\njenkins" | passwd jenkins

sed -i 's/^PasswordAuthentication no/#&/' /etc/ssh/sshd_config
systemctl restart sshd.service