#!/bin/bash
source ~/lab5.env
source ~/terraform-remote-state-lab/bucket_info.env
BACKUP_DIR="$HOME/terraform-state-backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR
echo "Creating state backup..."
aws s3 cp s3://$S3_BUCKET_NAME/infrastructure/terraform.tfstate $BACKUP_DIR/terraform.tfstate.$TIMESTAMP
echo "Available state file versions:"
aws s3api list-object-versions --bucket $S3_BUCKET_NAME --prefix infrastructure/terraform.tfstate
echo "Creating full bucket backup..."
aws s3 sync s3://$S3_BUCKET_NAME $BACKUP_DIR/full_backup_$TIMESTAMP/
echo "Backup completed. Files saved to: $BACKUP_DIR"
ls -la $BACKUP_DIR/
