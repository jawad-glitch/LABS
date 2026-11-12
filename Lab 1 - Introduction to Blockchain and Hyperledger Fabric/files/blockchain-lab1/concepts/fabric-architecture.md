# Hyperledger Fabric Architecture

## Core Components:

### 1. Peer Nodes:
- **Endorsing Peers**: Execute and endorse transactions
- **Committing Peers**: Validate and commit transactions to ledger
- Maintain copy of the ledger and smart contracts (chaincode)

### 2. Orderer Nodes:
- Order transactions into blocks
- Distribute blocks to peer nodes
- Implement consensus mechanism (Raft, Kafka, Solo)

### 3. Certificate Authority (CA):
- Issues digital certificates for network participants
- Manages identity and access control
- Provides cryptographic credentials

### 4. Membership Service Provider (MSP):
- Defines rules for valid identities
- Maps certificates to organizational roles
- Enables permissioned network access

### 5. Channels:
- Private communication subnets
- Isolate transactions between specific organizations
- Each channel has its own ledger

### 6. Chaincode (Smart Contracts):
- Business logic executed on peers
- Written in Go, JavaScript, or Java
- Defines asset states and transaction logic

## Key Features:

### Permissioned Network:
- Known identities for all participants
- Role-based access control
- Enterprise-grade security

### Modular Architecture:
- Pluggable consensus algorithms
- Configurable membership services
- Flexible deployment options

### Privacy and Confidentiality:
- Private channels for sensitive data
- Private data collections
- Zero-knowledge proofs support

### High Performance:
- Parallel transaction execution
- Optimized for enterprise workloads
- Scalable network topology
