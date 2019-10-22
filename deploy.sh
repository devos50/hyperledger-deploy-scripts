#!/bin/bash

docker exec cli peer channel create -o orderer1.example.com:7050 -c mychannel -f /opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

echo "Channel created"

for i in $(seq 1 $1);
do
  PORT=$((7051+($i-1)*1000))
  docker exec -e CORE_PEER_ADDRESS=peer0.org${i}.example.com:$PORT -e CORE_PEER_LOCALMSPID=Org${i}MSP -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${i}.example.com/peers/peer0.org${i}.example.com/tls/server.crt -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${i}.example.com/peers/peer0.org${i}.example.com/tls/server.key -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${i}.example.com/peers/peer0.org${i}.example.com/tls/ca.crt -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${i}.example.com/users/Admin@org${i}.example.com/msp cli peer channel join -b mychannel.block
  echo "Peer ${i} joined channel"

  docker exec -e CORE_PEER_ADDRESS=peer0.org${i}.example.com:$PORT -e CORE_PEER_LOCALMSPID=Org${i}MSP -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${i}.example.com/peers/peer0.org${i}.example.com/tls/server.crt -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${i}.example.com/peers/peer0.org${i}.example.com/tls/server.key -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${i}.example.com/peers/peer0.org${i}.example.com/tls/ca.crt -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${i}.example.com/users/Admin@org${i}.example.com/msp cli peer chaincode install -n sacc -v v0 -p github.com/chaincode/sacc
  echo "Installed chaincode on peer ${i}"
done

docker exec cli peer chaincode instantiate -o orderer1.example.com:7050 -c '{"Args":["john","0"]}' -C mychannel -n sacc -v v0 -P "OR ('Org1MSP.member','Org2MSP.member')" --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/server.crt
echo "Instantiated chaincode"
