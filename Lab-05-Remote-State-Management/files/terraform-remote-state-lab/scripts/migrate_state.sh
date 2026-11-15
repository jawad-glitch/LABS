#!/bin/bash
echo "State Migration Script"
cat > backend_local.tf << 'LOCALEOF'
terraform {
  backend "local" {
    path = "./terraform.tfstate.local"
  }
}
LOCALEOF
echo "To migrate from remote to local: replace backend.tf with backend_local.tf, run terraform init -migrate-state"
echo "To migrate back: restore the original backend.tf, run terraform init -migrate-state"
