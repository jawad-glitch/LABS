#!/bin/bash
source ~/lab5.env
source ~/terraform-remote-state-lab/bucket_info.env
echo "Starting cleanup process..."
cd ~/terraform-remote-state-lab/main-infrastructure && terraform destroy -auto-approve -input=false
cd ~/terraform-remote-state-lab/backend-setup
aws s3 rm s3://$S3_BUCKET_NAME --recursive
for q in Versions DeleteMarkers; do
  aws s3api list-object-versions --bucket $S3_BUCKET_NAME --query "$q[].{Key:Key,VersionId:VersionId}" --output text | while read key version; do
    if [ "$key" != "None" ] && [ "$version" != "None" ]; then
      aws s3api delete-object --bucket $S3_BUCKET_NAME --key "$key" --version-id "$version"
    fi
  done
done
terraform destroy -auto-approve -input=false
cd ~/terraform-remote-state-lab && rm -rf ~/terraform-state-backups/ && rm -f bucket_info.env
echo "Cleanup completed successfully!"
