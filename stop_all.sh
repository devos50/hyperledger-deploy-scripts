#!/bin/bash

cd "$(dirname "$0")"

docker-compose -f docker-compose-peers.yaml -f docker-compose-cli.yaml -f docker-compose-couch.yaml -f docker-compose-orderers.yaml down --volumes --remove-orphans
