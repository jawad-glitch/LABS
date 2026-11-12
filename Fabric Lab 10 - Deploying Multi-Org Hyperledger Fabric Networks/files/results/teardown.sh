#!/bin/bash
# Removes every container, named volume, crypto artefact and channel artefact of this lab so deploy.sh can run from scratch.
L=$HOME/fabric-lab
sudo docker compose -f $L/docker-compose.yaml down -v --remove-orphans 2>&1 | tail -2
[ -f $L/tradecc-ccaas.pid ] && kill "$(cat $L/tradecc-ccaas.pid)" 2>/dev/null; pkill -f tradecc-ccaas 2>/dev/null; rm -f $L/tradecc-ccaas.pid
sudo rm -rf $L/organizations $L/channel-artifacts $L/tradecc.tar.gz
echo "containers left: $(sudo docker ps -a --format '{{.Names}}' | grep -cE '^(cli|orderer0\.orderer|peer[01]\.org[12])\.?')"
echo "volumes left: $(sudo docker volume ls -q --filter label=com.docker.compose.project=tradenet | wc -l)"
echo "artefacts left: $(ls -d $L/organizations $L/channel-artifacts 2>/dev/null | wc -l)"
