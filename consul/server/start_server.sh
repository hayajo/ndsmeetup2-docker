#!/bin/sh

DOCKER_IMAGE_NAME='ndsmeetup2/consul_server'
DOCKER_CONSUL_SERVER_NAME='consul_sv'

docker build -t $DOCKER_IMAGE_NAME `dirname $0`

# start first server
docker run -d --name "${DOCKER_CONSUL_SERVER_NAME}01" ndsmeetup2/consul --bootstrap-expect=2 -node=sv01

first_server=`docker inspect -f '{{.NetworkSettings.IPAddress}}' consul_sv01`

for i in `seq --format '%02g' 2 3`; do
  docker run -d --name "${DOCKER_CONSUL_SERVER_NAME}$i" ndsmeetup2/consul -node=sv$i -join $first_server
done
