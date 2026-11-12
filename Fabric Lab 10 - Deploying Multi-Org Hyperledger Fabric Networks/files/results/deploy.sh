#!/bin/bash
# Deploys the TradeConsortium network from scratch: crypto -> blocks -> compose up -> osnadmin join -> peer joins
# -> anchor peer config updates -> chaincode lifecycle -> cross-org smoke test.   Usage: deploy.sh <label>
set -o pipefail
L=$HOME/fabric-lab; export PATH=$PATH:/usr/local/go/bin:$L/bin; LBL=${1:-run}; R=$L/results; mkdir -p $R
ORG=$L/organizations; CA=$L/channel-artifacts; NC=$L/network-config; D="sudo docker"; OUT=$R/deploy-$LBL.txt; : > $OUT
log() { echo "[$LBL] $*" | tee -a $OUT; }
fail() { log "DEPLOY_FAILED: $*"; exit 1; }
OCA=$ORG/ordererOrganizations/orderer.example.com/tlsca/tlsca.orderer.example.com-cert.pem
OTLS=$ORG/ordererOrganizations/orderer.example.com/orderers/orderer0.orderer.example.com/tls
TLSCA() { echo $ORG/peerOrganizations/org$1.example.com/tlsca/tlsca.org$1.example.com-cert.pem; }
peerenv() { export CORE_PEER_TLS_ENABLED=true CORE_PEER_LOCALMSPID=Org$1MSP CORE_PEER_ADDRESS=localhost:$2 FABRIC_CFG_PATH=$L/config \
  CORE_PEER_TLS_ROOTCERT_FILE=$(TLSCA $1) CORE_PEER_MSPCONFIGPATH=$ORG/peerOrganizations/org$1.example.com/users/Admin@org$1.example.com/msp; }
ORDARGS="-o localhost:7050 --tls --cafile $OCA"
BOTH="--peerAddresses localhost:7051 --tlsRootCertFiles $(TLSCA 1) --peerAddresses localhost:9051 --tlsRootCertFiles $(TLSCA 2)"
POL="AND('Org1MSP.peer','Org2MSP.peer')"

cryptogen generate --config=$NC/crypto-config.yaml --output=$ORG > /dev/null 2>&1 || fail cryptogen
mkdir -p $CA
FABRIC_CFG_PATH=$NC configtxgen -profile TradeOrdererGenesis -channelID system-channel -outputBlock $CA/system-genesis.block > $R/configtxgen-system-$LBL.txt 2>&1; log "system-channel genesis block (TradeOrdererGenesis): exit=$? size=$(stat -c %s $CA/system-genesis.block 2>/dev/null)"
FABRIC_CFG_PATH=$NC configtxgen -profile TradeChannel -channelID tradechannel -outputBlock $CA/tradechannel.block > /dev/null 2>&1 || fail "configtxgen tradechannel"
log "crypto + tradechannel.block ok"
(cd $L && $D compose -f docker-compose.yaml up -d > $R/compose-up-$LBL.txt 2>&1) || fail "compose up"
for i in $(seq 1 60); do curl -sk -m 1 -o /dev/null https://localhost:7053/ && [ "$($D ps --filter network=fabric_trade --format '{{.Status}}' | grep -c '^Up')" = 6 ] && break; sleep 1; done
log "containers Up: $($D ps --filter network=fabric_trade --format '{{.Names}}' | sort | paste -sd' ')"
osnadmin channel join --channelID tradechannel --config-block $CA/tradechannel.block -o localhost:7053 --ca-file $OCA --client-cert $OTLS/server.crt --client-key $OTLS/server.key > $R/osnadmin-$LBL.txt 2>&1 || fail "osnadmin join"
for i in $(seq 1 30); do [ "$(osnadmin channel list --channelID tradechannel -o localhost:7053 --ca-file $OCA --client-cert $OTLS/server.crt --client-key $OTLS/server.key 2>/dev/null | sed -n '/^{/,$p' | jq -r .status)" = active ] && break; sleep 0.5; done
log "orderer: $(osnadmin channel list --channelID tradechannel -o localhost:7053 --ca-file $OCA --client-cert $OTLS/server.crt --client-key $OTLS/server.key 2>/dev/null | sed -n '/^{/,$p' | jq -c '{name,status,consensusRelation}')"
for p in 1:7051 1:8051 2:9051 2:10051; do peerenv ${p%%:*} ${p##*:}
  for a in 1 2 3; do peer channel join -b $CA/tradechannel.block > /dev/null 2>&1 && break; sleep 2; done
  log "peer localhost:${p##*:} channels: $(peer channel list 2>/dev/null | grep -v '^Channels' | paste -sd,)"; done
anchor() { local o=$1 port=$2 t; t=$(mktemp -d); peerenv $o $port
  peer channel fetch config $t/cfg.pb $ORDARGS -c tradechannel > /dev/null 2>&1 || return 1
  configtxlator proto_decode --input $t/cfg.pb --type common.Block --output $t/blk.json && jq .data.data[0].payload.data.config $t/blk.json > $t/config.json
  jq ".channel_group.groups.Application.groups.Org${o}MSP.values += {\"AnchorPeers\":{\"mod_policy\":\"Admins\",\"value\":{\"anchor_peers\":[{\"host\":\"peer0.org${o}.example.com\",\"port\":$port}]},\"version\":\"0\"}}" $t/config.json > $t/modified.json
  configtxlator proto_encode --input $t/config.json --type common.Config --output $t/original.pb
  configtxlator proto_encode --input $t/modified.json --type common.Config --output $t/modified.pb
  configtxlator compute_update --channel_id tradechannel --original $t/original.pb --updated $t/modified.pb --output $t/update.pb || return 1
  configtxlator proto_decode --input $t/update.pb --type common.ConfigUpdate --output $t/update.json
  echo "{\"payload\":{\"header\":{\"channel_header\":{\"channel_id\":\"tradechannel\",\"type\":2}},\"data\":{\"config_update\":$(cat $t/update.json)}}}" | jq . > $t/env.json
  configtxlator proto_encode --input $t/env.json --type common.Envelope --output $t/env.pb
  peer channel update -f $t/env.pb -c tradechannel $ORDARGS > $t/upd.txt 2>&1; local rc=$?; rm -rf $t; return $rc; }
anchor 1 7051 && log "anchor peer update Org1: ok" || fail "anchor update Org1"
anchor 2 9051 && log "anchor peer update Org2: ok" || fail "anchor update Org2"
sleep 3; peerenv 2 9051; t=$(mktemp -d); peer channel fetch config $t/c.pb $ORDARGS -c tradechannel >/dev/null 2>&1
configtxlator proto_decode --input $t/c.pb --type common.Block | jq -c '[.data.data[0].payload.data.config.channel_group.groups.Application.groups | to_entries[] | {org: .key, anchors: .value.values.AnchorPeers.value.anchor_peers}]' > $R/anchors-$LBL.json; rm -rf $t
log "anchor peers in channel config: $(cat $R/anchors-$LBL.json)"
# chaincode-as-a-service package, install on all four peers
t=$(mktemp -d); printf '{"address":"host.docker.internal:9999","dial_timeout":"10s","tls_required":false}\n' > $t/connection.json; printf '{"type":"ccaas","label":"tradecc_1.0"}\n' > $t/metadata.json
tar -czf $t/code.tar.gz -C $t connection.json; tar -czf $L/tradecc.tar.gz -C $t metadata.json code.tar.gz; rm -rf $t
for p in 1:7051 1:8051 2:9051 2:10051; do peerenv ${p%%:*} ${p##*:}; peer lifecycle chaincode install $L/tradecc.tar.gz > /dev/null 2>&1; log "install on localhost:${p##*:}: exit=$?"; done
peerenv 1 7051; PKG=$(peer lifecycle chaincode queryinstalled --output json | jq -r '.installed_chaincodes[] | select(.label=="tradecc_1.0") | .package_id')
[ -n "$PKG" ] || fail "package id"
pkill -f tradecc-ccaas >/dev/null 2>&1; CHAINCODE_SERVER_ADDRESS=0.0.0.0:9999 CHAINCODE_ID=$PKG nohup $L/tradecc-ccaas > $R/chaincode-service-$LBL.log 2>&1 & echo $! > $L/tradecc-ccaas.pid
for o in 1:7051 2:9051; do peerenv ${o%%:*} ${o##*:}; peer lifecycle chaincode approveformyorg $ORDARGS --channelID tradechannel --name tradecc --version 1.0 --package-id $PKG --sequence 1 --signature-policy "$POL" > /dev/null 2>&1 || fail "approve Org${o%%:*}"; log "approved by Org${o%%:*} admin"; done
peerenv 1 7051; peer lifecycle chaincode commit $ORDARGS --channelID tradechannel --name tradecc --version 1.0 --sequence 1 --signature-policy "$POL" $BOTH > /dev/null 2>&1 || fail commit
log "committed tradecc 1.0 seq 1 with $POL"
peerenv 1 7051; peer chaincode invoke $ORDARGS -C tradechannel -n tradecc $BOTH -c '{"function":"CreateAsset","Args":["smoke-'$LBL'","written-by-org1"]}' --waitForEvent > /dev/null 2>&1 || fail "smoke invoke"
peerenv 2 9051; log "smoke: Org2 reads smoke-$LBL = $(peer chaincode query -C tradechannel -n tradecc -c '{"Args":["ReadAsset","smoke-'$LBL'"]}' 2>&1)"
log "DEPLOY_OK"
