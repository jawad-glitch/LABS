#!/bin/bash

echo "=== Simple Blockchain Demonstration ==="
echo

# Genesis block
GENESIS_HASH="0000000000000000000000000000000000000000000000000000000000000000"
echo "Genesis Block:"
echo "Previous Hash: $GENESIS_HASH"
echo "Data: Genesis Block - Network Initialization"
BLOCK1_HASH=$(echo "Genesis Block - Network Initialization$GENESIS_HASH" | sha256sum | cut -d' ' -f1)
echo "Current Hash: $BLOCK1_HASH"
echo

# Block 1
echo "Block 1:"
echo "Previous Hash: $BLOCK1_HASH"
echo "Data: Alice sends 10 coins to Bob"
BLOCK2_HASH=$(echo "Alice sends 10 coins to Bob$BLOCK1_HASH" | sha256sum | cut -d' ' -f1)
echo "Current Hash: $BLOCK2_HASH"
echo

# Block 2
echo "Block 2:"
echo "Previous Hash: $BLOCK2_HASH"
echo "Data: Bob sends 5 coins to Charlie"
BLOCK3_HASH=$(echo "Bob sends 5 coins to Charlie$BLOCK2_HASH" | sha256sum | cut -d' ' -f1)
echo "Current Hash: $BLOCK3_HASH"
echo

echo "=== Chain Integrity Verification ==="
echo "Each block contains the hash of the previous block"
echo "This creates an immutable chain of records"
