#!/bin/bash

SERVER_URL="https://server:6443"
NODE_TOKEN="token_here"
NODE_NAME="ubuntu1"

curl -sfL https://get.k3s.io | K3S_URL=$SERVER_URL K3S_TOKEN=$NODE_TOKEN K3S_NODE_NAME=$NODE_NAME sh -