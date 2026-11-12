# Lab 3 - Create and Configure Certificate Authority (CA) - completion proof
Completed (UTC): 2026-11-12 09:27:42 | EC2: i-0896d9379182da727 | host: ip-172-31-10-72 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 3 - Create and Configure Certificate Authority (CA), 2026-11-12 09:27:36 UTC) ==========
PASS: Task 1: Fabric CA binaries v1.5.5 installed & CA server initialized
FAIL: Task 2: CA server started on port 7054 & bootstrap admin enrolled with valid X.509 cert
PASS: Task 3: peer1, orderer1, user1, admin2 & TLS certs registered and enrolled
PASS: Task 4.1-4.3: Identity list & MSP structure verification passed for all 4 identities
PASS: Task 4.4: OpenSSL certificate chain validation passed (4/4 valid against ca-cert.pem)
PASS: Task 4.5 & 4.6: user1 revoked + CRL generated; user2 enrolled with ABAC attributes & summary saved
PASS: Time: Lab completed in 5s (<= 300s)
CORE: 6/7 PASS
```

## Docker snapshot
```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

## Files
```
./fabric-ca-lab/bin/fabric-ca-client
./fabric-ca-lab/bin/fabric-ca-server
./fabric-ca-lab/ca-client/msp/cacerts/localhost-7054.pem
./fabric-ca-lab/ca-client/msp/crls/crl.pem
./fabric-ca-lab/ca-client/msp/keystore/admin_sk
./fabric-ca-lab/ca-client/msp/signcerts/cert.pem
./fabric-ca-lab/ca-client/msp/tlscacerts/tls-localhost-7054.pem
./fabric-ca-lab/ca-server/ca-cert.pem
./fabric-ca-lab/ca-server/ca-cert.srl
./fabric-ca-lab/ca-server/ca-server.log
./fabric-ca-lab/ca-server/fabric-ca-server-config.yaml
./fabric-ca-lab/ca-server/fabric-ca-server-config.yaml.backup
./fabric-ca-lab/ca-server/fabric-ca-server.db
./fabric-ca-lab/ca-server/identities.json
./fabric-ca-lab/ca-server/msp/cacerts/ca-cert.pem
./fabric-ca-lab/ca-server/msp/keystore/ca_sk
./fabric-ca-lab/ca-server/msp/signcerts/cert.pem
./fabric-ca-lab/certificates/admin2/msp/cacerts/localhost-7054.pem
./fabric-ca-lab/certificates/admin2/msp/keystore/admin2_sk
./fabric-ca-lab/certificates/admin2/msp/signcerts/cert.pem
./fabric-ca-lab/certificates/admin2/msp/tlscacerts/tls-localhost-7054.pem
./fabric-ca-lab/certificates/orderer1/msp/cacerts/localhost-7054.pem
./fabric-ca-lab/certificates/orderer1/msp/keystore/orderer1_sk
./fabric-ca-lab/certificates/orderer1/msp/signcerts/cert.pem
./fabric-ca-lab/certificates/orderer1/msp/tlscacerts/tls-localhost-7054.pem
./fabric-ca-lab/certificates/peer1/msp/cacerts/localhost-7054.pem
./fabric-ca-lab/certificates/peer1/msp/keystore/peer1_sk
./fabric-ca-lab/certificates/peer1/msp/signcerts/cert.pem
./fabric-ca-lab/certificates/peer1/msp/tlscacerts/tls-localhost-7054.pem
./fabric-ca-lab/certificates/tls/orderer1/msp/cacerts/localhost-7054.pem
./fabric-ca-lab/certificates/tls/orderer1/msp/keystore/orderer1_sk
./fabric-ca-lab/certificates/tls/orderer1/msp/signcerts/cert.pem
./fabric-ca-lab/certificates/tls/orderer1/msp/tlscacerts/tls-localhost-7054.pem
./fabric-ca-lab/certificates/tls/peer1/msp/cacerts/localhost-7054.pem
./fabric-ca-lab/certificates/tls/peer1/msp/keystore/peer1_sk
./fabric-ca-lab/certificates/tls/peer1/msp/signcerts/cert.pem
./fabric-ca-lab/certificates/tls/peer1/msp/tlscacerts/tls-localhost-7054.pem
./fabric-ca-lab/certificates/user1/msp/cacerts/localhost-7054.pem
./fabric-ca-lab/certificates/user1/msp/keystore/user1_sk
./fabric-ca-lab/certificates/user1/msp/signcerts/cert.pem
./fabric-ca-lab/certificates/user1/msp/tlscacerts/tls-localhost-7054.pem
./fabric-ca-lab/certificates/user2/msp/cacerts/localhost-7054.pem
./fabric-ca-lab/certificates/user2/msp/keystore/user2_sk
./fabric-ca-lab/certificates/user2/msp/signcerts/cert.pem
./fabric-ca-lab/certificates/user2/msp/tlscacerts/tls-localhost-7054.pem
./fabric-ca-lab/lab_summary.txt
./fabric-ca-lab/results/task1.1-ca-versions.txt
./fabric-ca-lab/results/task1.1-env-check.txt
./fabric-ca-lab/results/task1.2-ca-init.txt
./fabric-ca-lab/results/task2.1-ca-port.txt
./fabric-ca-lab/results/task2.1-ca-process.txt
./fabric-ca-lab/results/task2.3-admin-cert.txt
./fabric-ca-lab/results/task2.3-admin-enroll.txt
./fabric-ca-lab/results/task3.1-register-users.txt
./fabric-ca-lab/results/task3.2-enroll-users.txt
./fabric-ca-lab/results/task3.3-enroll-tls.txt
./fabric-ca-lab/results/task4.1-identity-list.txt
./fabric-ca-lab/results/task4.2-cert-analysis.txt
./fabric-ca-lab/results/task4.3-verify-msp.txt
./fabric-ca-lab/results/task4.4-validate-certs.txt
./fabric-ca-lab/results/task4.5-crl-text.txt
./fabric-ca-lab/results/task4.5-revoke.txt
./fabric-ca-lab/results/task4.6-user2-abac.txt
./fabric-ca-lab/results/task4.6-user2-enroll.txt
./fabric-ca-lab/results/task4.6-user2-register.txt
./fabric-ca-lab/validate_certs.sh
./fabric-ca-lab/verify_msp.sh
```
