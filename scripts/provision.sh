#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
/usr/bin/apt-get update 
/usr/bin/apt-get install -y git software-properties-common
/usr/bin/wget -qO- https://get.docker.com/ | sh
/usr/bin/wget -O /usr/local/bin/docker-compose \
  https://github.com/docker/compose/releases/download/1.17.1/run.sh
/usr/bin/chmod +x /usr/local/bin/docker-compose
/usr/bin/wget -O /usr/local/bin/docker-compose -L \ 
  "https://github.com/docker/compose/releases/download/1.17.1/docker-compose-$(uname -s)-$(uname -m)"
usermod -aG docker $USER
