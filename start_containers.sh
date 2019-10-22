#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Please enter the peer number'
    exit 1
fi

cd "$(dirname "$0")"

# Couchdb
docker-compose -f docker-compose-couch.yaml up -d couchdb${1}

# Orderer
docker-compose -f docker-compose-orderers.yaml up -d orderer${1}.example.com

# Peer
docker-compose -f docker-compose-peers.yaml -f docker-compose-couch.yaml up -d peer0.org${1}.example.com

# Start CLI if we are peer 1
if [[ $1 -eq 1 ]] ; then
    echo 'Starting CLI'
    docker-compose -f docker-compose-cli.yaml up -d cli
fi
#docker-compose -f docker-compose-cli.yaml up -d cli
