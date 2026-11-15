#!/bin/bash
source ~/lab5.env
source ~/terraform-remote-state-lab/bucket_info.env
cd ~/terraform-remote-state-lab/main-infrastructure
echo "Testing state recovery..."
terraform apply -auto-approve -input=false
aws s3 cp s3://$S3_BUCKET_NAME/infrastructure/terraform.tfstate ./state_backup_before_test.json
echo '{"invalid": "state"}' > ./corrupted_state.json
aws s3 cp ./corrupted_state.json s3://$S3_BUCKET_NAME/infrastructure/terraform.tfstate
echo "Testing with corrupted state (should fail)..."
terraform plan -input=false || echo "Expected failure due to corrupted state"
echo "Restoring from backup..."
aws s3 cp ./state_backup_before_test.json s3://$S3_BUCKET_NAME/infrastructure/terraform.tfstate
echo "Testing after recovery (should succeed)..."
terraform plan -input=false
echo "Recovery test completed successfully."
rm -f ./corrupted_state.json ./state_backup_before_test.json
