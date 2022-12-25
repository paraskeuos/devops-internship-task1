#!/bin/bash

apt-get update
apt-get install -y curl ca-certificates tzdata perl

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | bash

EXTERNAL_URL="http://192.168.0.22" apt-get install gitlab-ee



