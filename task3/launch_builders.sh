#!/bin/bash

# Builders

for buildtool in mvn dotnet golang react
do
    name=${buildtool}_builder
    docker run --name $name -d \
        --network jenkins_network $name
done
