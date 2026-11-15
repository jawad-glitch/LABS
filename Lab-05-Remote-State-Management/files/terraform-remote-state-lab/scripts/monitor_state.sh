#!/bin/bash
source ~/lab5.env
source ~/terraform-remote-state-lab/bucket_info.env
cd ~/terraform-remote-state-lab/main-infrastructure
get_state_info() {
  aws s3api head-object --bucket $S3_BUCKET_NAME --key infrastructure/terraform.tfstate --query '{LastModified:LastModified,ETag:ETag,Size:ContentLength}' 2>/dev/null || echo "State file not found"
}
echo "Initial state file info:"; INITIAL_STATE=$(get_state_info); echo $INITIAL_STATE
terraform apply -auto-approve -input=false
echo "State file info after:"; UPDATED_STATE=$(get_state_info); echo $UPDATED_STATE
[ "$INITIAL_STATE" != "$UPDATED_STATE" ] && echo "State file updated" || echo "No changes detected in state file (no infra changes were needed)."
aws s3api list-object-versions --bucket $S3_BUCKET_NAME --prefix infrastructure/terraform.tfstate --query 'Versions[*].{Key:Key,VersionId:VersionId,LastModified:LastModified,Size:Size}' --output table
echo "Monitoring completed."
