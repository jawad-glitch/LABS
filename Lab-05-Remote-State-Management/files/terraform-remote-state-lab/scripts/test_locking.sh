#!/bin/bash
source ~/lab5.env
source ~/terraform-remote-state-lab/bucket_info.env
cd ~/terraform-remote-state-lab/main-infrastructure
LOCKKEY="$S3_BUCKET_NAME/infrastructure/terraform.tfstate"
echo "Testing Terraform state locking..."
jq -n --arg k "$LOCKKEY" '{LockID:{S:$k},Info:{S:"{\"ID\":\"fake-lock-1\",\"Operation\":\"OperationTypePlan\",\"Who\":\"other-user\"}"}}' > /tmp/lockitem.json
aws dynamodb put-item --table-name $DYNAMODB_TABLE_NAME --item file:///tmp/lockitem.json
echo "Lock held by another 'user'. Second operation (should FAIL):"
terraform plan -input=false -lock-timeout=3s && echo "UNEXPECTED: plan succeeded" || echo "EXPECTED: plan blocked by state lock"
echo "Releasing lock..."
aws dynamodb delete-item --table-name $DYNAMODB_TABLE_NAME --key "{\"LockID\":{\"S\":\"$LOCKKEY\"}}"
echo "Second operation again (should SUCCEED):"
terraform plan -input=false
echo "State locking test completed."
