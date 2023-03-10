#!/bin/bash

apt update
apt install -y apt-transport-https ca-certificates curl software-properties-common git
apt install -y apparmor
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt update
apt install -y docker-ce docker-compose-plugin
docker run hello-world
