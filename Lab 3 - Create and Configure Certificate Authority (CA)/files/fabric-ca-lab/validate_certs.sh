#!/bin/bash

validate_certificate_chain() {
    local cert_path=$1
    local ca_cert_path=$2
    local identity_name=$3
    
    echo "=== Certificate Chain Validation for $identity_name ==="
    
    if [ -f "$cert_path" ] && [ -f "$ca_cert_path" ]; then
        echo "Validating certificate chain..."
        if openssl verify -CAfile "$ca_cert_path" "$cert_path" > /dev/null 2>&1; then
            echo "✓ Certificate chain is valid"
        else
            echo "✗ Certificate chain validation failed"
        fi
        
        echo "Certificate validity period:"
        openssl x509 -in "$cert_path" -noout -dates
        
        echo "Certificate subject:"
        openssl x509 -in "$cert_path" -noout -subject
        
        echo "Certificate issuer:"
        openssl x509 -in "$cert_path" -noout -issuer
        echo ""
    else
        echo "Required certificate files not found"
        echo ""
    fi
}

CA_CERT="$HOME/fabric-ca-lab/ca-server/ca-cert.pem"

validate_certificate_chain "$HOME/fabric-ca-lab/certificates/peer1/msp/signcerts/cert.pem" "$CA_CERT" "peer1"
validate_certificate_chain "$HOME/fabric-ca-lab/certificates/orderer1/msp/signcerts/cert.pem" "$CA_CERT" "orderer1"
validate_certificate_chain "$HOME/fabric-ca-lab/certificates/user1/msp/signcerts/cert.pem" "$CA_CERT" "user1"
validate_certificate_chain "$HOME/fabric-ca-lab/certificates/admin2/msp/signcerts/cert.pem" "$CA_CERT" "admin2"
