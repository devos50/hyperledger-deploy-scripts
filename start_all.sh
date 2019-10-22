#!/bin/bash

cd "$(dirname "$0")"

./generate.sh

docker-compose -f docker-compose-peers.yaml -f docker-compose-cli.yaml -f docker-compose-couch.yaml -f docker-compose-orderers.yaml up -d
