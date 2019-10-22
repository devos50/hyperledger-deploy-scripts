#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Please enter the sleep duration'
    exit 1
fi

while :
do
  peer chaincode invoke -n sacc -c '{"Args":["set", "blah1", "20"]}' -C mychannel -o orderer1.example.com:7050 --tls true --cafile /etc/hyperledger/orderers/orderer1.example.com/tls/ca.crt > /dev/null 2>&1 &
  sleep $1
done
