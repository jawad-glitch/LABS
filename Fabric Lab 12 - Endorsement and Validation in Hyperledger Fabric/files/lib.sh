# Shared helpers (sourced by the lab scripts).
DK="docker"; docker ps >/dev/null 2>&1 || DK="sudo docker"
ORD() { echo "-o $ORDERER_ADDRESS --tls --cafile $ORDERER_CA"; }
BOTH() { echo "--peerAddresses $PEER0_ORG1_ADDRESS --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses $PEER0_ORG2_ADDRESS --tlsRootCertFiles $PEER0_ORG2_CA"; }
ONE() { echo "--peerAddresses $PEER0_ORG1_ADDRESS --tlsRootCertFiles $PEER0_ORG1_CA"; }
txid_of() { grep -oE 'txid \[[0-9a-f]{64}\]' "$1" | head -1 | tr -d 'txid []'; }
status_of() { grep -oE 'committed with status \([A-Z_]+\)' "$1" | head -1 | sed 's/.*(\(.*\))/\1/'; }
