#!/bin/bash

apt-get update
apt-get install -y openjdk-11-jre maven

curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"

chmod +x /usr/local/bin/gitlab-runner
useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash

gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner

apt-get install docker.io
usermod -aG docker gitlab-runner

# gitlab-runner register <- starts interactive prompt for registering the runner at the GitLab server
# gitlab-runner start    <- run under sudo privileges after registering