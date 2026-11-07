# Lab 10 - Configure Privacy Groups - completion proof
Completed (UTC): 2026-11-07 15:45:49 | EC2: i-08a2d461a4e4fc58a | host: ip-172-31-10-223 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 10 - Configure Privacy Groups, 2026-11-07 15:45:10 UTC) ==========
PASS: Task 1.2: besu 22.10.3 present
PASS: Task 1.2: tessera present (jar or docker)
PASS: Task 2.1: tessera key pair exists
PASS: Task 2.1: tessera pubkey non-trivial
PASS: Task 2.2: tessera config valid JSON
FAIL: Task 2.3: tessera upcheck=200
PASS: Task 3.1: genesis valid, qbft, chainId 1337
FAIL: Task 3.1: besu address matches validator
FAIL: Task 3.3: besu started
FAIL: Task 3.3: QBFT block produced
FAIL: Task 4.3: priv_getPrivacyPrecompileAddress returned 0x...
FAIL: Task 4.3: priv_createPrivacyGroup returned group id
FAIL: Task 4.3: priv_findPrivacyGroup returned result
CORE: 6/13 PASS
```

## Files
```
./besu-node1/data/DATABASE_METADATA.json
./besu-node1/data/database/000004.log
./besu-node1/data/database/CURRENT
./besu-node1/data/database/IDENTITY
./besu-node1/data/database/LOCK
./besu-node1/data/database/LOG
./besu-node1/data/database/MANIFEST-000005
./besu-node1/data/database/OPTIONS-000029
./besu-node1/data/database/OPTIONS-000031
./besu-node1/data/key
./genesis.json
./results/besu-own-address.txt
./results/besu-version.txt
./results/besu.log
./results/extraData.txt
./results/java-version.txt
./results/task4-privacy-tests.txt
./results/tessera-keygen.log
./results/tessera-keys.txt
./results/tessera-pub.txt
./results/tessera.log
./start-besu.sh
./tessera-node1/keys/node1.key
./tessera-node1/keys/node1.pub
./tessera-node1/tessera-config.json
```
