## Hyperledger Fabric deployment scripts 

The scripts in this repository can be used to quickly deploy one or more peers and Raft orderers on a single machine. The repository includes a script to generate the required configuration and docker files with a given number of organizations. Each organization contains one peer, and for each peer, a single orderer is started. These files are generated from template files, which contain "template" in the name.

To generate the configuration files with two organization/peers, run the following command:

```
python generate_config.py 2
```

This will generate the `docker-compose-cli.yaml`, `docker-compose-peers.yaml`, `docker-compose-couch.yaml`, `docker-compose-orderers.yaml`, `configtx.yaml` and `crypto-config.yaml` files.

To start the docker containers, run the following command:

```
./start_all.sh
```

This will boot all docker containers, including a CLI container (which by default performs commands as the admin user of organization 1).

To create a channel and deploy chaincode to all peers, run the following command (the first argument is the number of organizations/peers in the network):

```
./deploy.sh 2
```

This deploys the `sacc` chaincode to the peers (see `sacc.go` in the `chaincode` directory), which is a basic key/value store. You can easily adapt `deploy.sh` to deploy your own chaincode. You can now invoke the chaincode on peer 1 as follows:

```
docker exec peer0.org1.example.com peer chaincode invoke -n sacc -c '{"Args":["set", "blah1", "20"]}' -C mychannel -o orderer1.example.com:7050 --tls true --cafile /etc/hyperledger/orderers/orderer1.example.com/tls/ca.crt
``` 

*NOTE:* These scripts are tested with Hyperledger Fabric 1.4.3 and may not be compatible with further versions of Hyperledger Fabric.

