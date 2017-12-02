#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export COMPOSE_PROJECT_NAME=analyte
/usr/bin/apt-get update > /dev/null 2>&1
/usr/bin/apt-get install -y git software-properties-common \
  python-software-properties python python-dev > /dev/null 2>&1
wget -qO- https://get.docker.com/ | sh > /dev/null 2>&1
wget \
  -O /usr/local/bin/docker-compose \
  https://github.com/docker/compose/releases/download/1.17.1/run.sh \
&& chmod +x /usr/local/bin/docker-compose > /dev/null 2>&1
usermod -aG docker $USER > /dev/null 2>&1
docker network create --driver bridge analyte
docker volume create --name db-data
docker-compose
# git clone $BRANCH_SLUG
gcloud auth activate-service-account --key-file /vagrant/creds/registry-access.json
