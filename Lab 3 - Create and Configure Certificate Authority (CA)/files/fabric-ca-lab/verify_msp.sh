#!/bin/bash

verify_msp_structure() {
    local msp_path=$1
    local identity_name=$2
    
    echo "=== MSP Structure Verification for $identity_name ==="
    echo "MSP Path: $msp_path"
    
    if [ -d "$msp_path" ]; then
        echo "MSP directory exists: YES"
        echo "MSP structure:"
        tree "$msp_path" 2>/dev/null || find "$msp_path" -type f
        
        echo "Required components check:"
        [ -d "$msp_path/signcerts" ] && echo "✓ signcerts directory exists" || echo "✗ signcerts directory missing"
        [ -d "$msp_path/keystore" ] && echo "✓ keystore directory exists" || echo "✗ keystore directory missing"
        [ -d "$msp_path/cacerts" ] && echo "✓ cacerts directory exists" || echo "✗ cacerts directory missing"
        
        echo "File counts:"
        echo "  Signing certificates: $(find "$msp_path/signcerts" -name "*.pem" 2>/dev/null | wc -l)"
        echo "  Private keys: $(find "$msp_path/keystore" -name "*_sk" 2>/dev/null | wc -l)"
        echo "  CA certificates: $(find "$msp_path/cacerts" -name "*.pem" 2>/dev/null | wc -l)"
        echo ""
    else
        echo "MSP directory exists: NO"
        echo ""
    fi
}

verify_msp_structure "$HOME/fabric-ca-lab/certificates/peer1/msp" "peer1"
verify_msp_structure "$HOME/fabric-ca-lab/certificates/orderer1/msp" "orderer1"
verify_msp_structure "$HOME/fabric-ca-lab/certificates/user1/msp" "user1"
verify_msp_structure "$HOME/fabric-ca-lab/certificates/admin2/msp" "admin2"
