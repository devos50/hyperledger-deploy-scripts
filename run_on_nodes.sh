#!/bin/bash

counter=1
for node in node321 node322 node323 node324 node325 node326 node327 node328
do
  CMD="source ~/.bash_profile && source ~/venv3/bin/activate && bash hyperledger-network-template/start_containers.sh $counter && bash hyperledger-network-template/stop_all.sh"
  echo $CMD
  ssh $node -t $CMD
  counter=$(($counter+1))
done

