#!/bin/bash

apt-get update
apt-get install -y openjdk-8-jre
tar -xf /vagrant/nexus-3.44.0-01-unix.tar.gz
./nexus-3.44.0-01/bin/nexus run &> /dev/null &
