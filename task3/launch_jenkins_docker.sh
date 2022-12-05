#!/bin/bash

# Jenkins controller

docker run --name jenkins -d \
    -v jenkins_data:/var/jenkins_home \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -p 8080:8080 -p 50000:50000 \
    --privileged \
    --network jenkins_network \
    --restart=on-failure \
        jenkins/jenkins:lts-jdk11


