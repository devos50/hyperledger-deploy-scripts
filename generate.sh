#!/bin/bash

cd "$(dirname "$0")"

rm -rf crypto-config
rm -rf channel-artifacts/*
cryptogen generate --config=./crypto-config.yaml

export FABRIC_CFG_PATH=$PWD

configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
export CHANNEL_NAME=mychannel
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

for i in $(seq 1 $1);
do
  configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org${i}MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org${i}MSP
done


# Bad...
chmod -R 777 crypto-config

