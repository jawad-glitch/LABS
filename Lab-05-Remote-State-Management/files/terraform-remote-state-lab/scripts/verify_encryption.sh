#!/bin/bash
source ~/lab5.env
source ~/terraform-remote-state-lab/bucket_info.env
echo "Verifying state file encryption..."
aws s3api get-bucket-encryption --bucket $S3_BUCKET_NAME
aws s3api head-object --bucket $S3_BUCKET_NAME --key infrastructure/terraform.tfstate --query 'ServerSideEncryption'
aws s3api get-bucket-versioning --bucket $S3_BUCKET_NAME
echo "Encryption verification completed."
