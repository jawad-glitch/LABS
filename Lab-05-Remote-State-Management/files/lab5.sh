#!/usr/bin/env bash
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a
. ~/lab5.env
mkdir -p "$TF_PLUGIN_CACHE_DIR"
START=$(date +%s)

echo "##### TASK 1: tools (parallel downloads) + AWS emulator #####"
sudo apt-get update -qq < /dev/null
sudo apt-get install -y -qq wget unzip curl gnupg software-properties-common jq ca-certificates git python3-venv < /dev/null

cd ~
wget -q https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip -O terraform.zip &
curl -s https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip &
( python3 -m venv ~/moto-venv && ~/moto-venv/bin/pip install -q 'moto[server]' ) &
wait

unzip -qo terraform.zip && sudo mv -f terraform /usr/local/bin/ < /dev/null
unzip -qo awscliv2.zip && sudo ./aws/install --update < /dev/null >/dev/null
terraform version; aws --version

# local AWS emulator (simulates S3 / DynamoDB / EC2 / STS)
setsid nohup ~/moto-venv/bin/moto_server -p 5000 > /tmp/moto.log 2>&1 < /dev/null &
for i in $(seq 1 30); do curl -s localhost:5000/moto-api/ >/dev/null && break; sleep 1; done
aws sts get-caller-identity

mkdir -p ~/.aws ~/terraform-remote-state-lab/{backend-setup,main-infrastructure,scripts}
cd ~/terraform-remote-state-lab
touch backend-setup/backend.tf backend-setup/variables.tf main-infrastructure/main.tf main-infrastructure/backend.tf scripts/cleanup.sh

echo "##### TASK 2: S3 backend #####"
cd ~/terraform-remote-state-lab/backend-setup
cat > variables.tf << 'EOF'
variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
  default     = "terraform-state-bucket-unique-12345"
}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "lab"
}
EOF

cat > backend.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Pointed at the local moto emulator instead of real AWS
provider "aws" {
  region                      = var.region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true
  endpoints {
    s3       = "http://localhost:5000"
    dynamodb = "http://localhost:5000"
    ec2      = "http://localhost:5000"
    sts      = "http://localhost:5000"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
  tags = {
    Name        = "Terraform State Bucket"
    Environment = var.environment
    Purpose     = "Remote State Storage"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_pab" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.terraform_state.bucket
}
output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.terraform_state.arn
}
EOF

terraform init -input=false
terraform apply -auto-approve -input=false
BUCKET_NAME=$(terraform output -raw s3_bucket_name)
echo "S3_BUCKET_NAME=$BUCKET_NAME" > ../bucket_info.env
echo "Bucket created: $BUCKET_NAME"

echo "##### TASK 3: DynamoDB locking #####"
cat >> backend.tf << 'EOF'

resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-state-lock-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform State Lock Table"
    Environment = var.environment
    Purpose     = "State Locking"
  }
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.terraform_state_lock.name
}
output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.terraform_state_lock.arn
}
EOF
terraform apply -auto-approve -input=false
DYNAMODB_TABLE=$(terraform output -raw dynamodb_table_name)
echo "DYNAMODB_TABLE_NAME=$DYNAMODB_TABLE" >> ../bucket_info.env
echo "DynamoDB table created: $DYNAMODB_TABLE"

aws s3api get-bucket-versioning --bucket $BUCKET_NAME
aws dynamodb describe-table --table-name $DYNAMODB_TABLE --query 'Table.{Name:TableName,Status:TableStatus,KeySchema:KeySchema}'
aws s3 ls s3://$BUCKET_NAME/

echo "##### TASK 4: main infrastructure on remote backend #####"
cd ~/terraform-remote-state-lab/main-infrastructure
source ../bucket_info.env

cat > backend.tf << EOF
terraform {
  backend "s3" {
    bucket                      = "$S3_BUCKET_NAME"
    key                         = "infrastructure/terraform.tfstate"
    region                      = "us-east-1"
    dynamodb_table              = "$DYNAMODB_TABLE_NAME"
    encrypt                     = true
    # emulator settings
    endpoint                    = "http://localhost:5000"
    dynamodb_endpoint           = "http://localhost:5000"
    force_path_style            = true
    access_key                  = "test"
    secret_key                  = "test"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
  }
}
EOF

cat > main.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true
  endpoints {
    s3       = "http://localhost:5000"
    dynamodb = "http://localhost:5000"
    ec2      = "http://localhost:5000"
    sts      = "http://localhost:5000"
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "Main VPC"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "Public Subnet"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "Main IGW"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}
output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}
EOF

terraform init -input=false
terraform apply -auto-approve -input=false
terraform show | head -n 30

aws s3 ls s3://$S3_BUCKET_NAME/infrastructure/
aws s3api head-object --bucket $S3_BUCKET_NAME --key infrastructure/terraform.tfstate
aws dynamodb scan --table-name $DYNAMODB_TABLE_NAME

# ---- 4.4 locking test (deterministic: plant a lock row, plan must fail, release, plan must pass) ----
cat > ~/terraform-remote-state-lab/scripts/test_locking.sh << 'EOF'
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
EOF
chmod +x ~/terraform-remote-state-lab/scripts/test_locking.sh
~/terraform-remote-state-lab/scripts/test_locking.sh

# ---- 4.5 backup ----
cat > ~/terraform-remote-state-lab/scripts/backup_state.sh << 'EOF'
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
EOF
chmod +x ~/terraform-remote-state-lab/scripts/backup_state.sh
~/terraform-remote-state-lab/scripts/backup_state.sh

# ---- 4.6 recovery ----
cat > ~/terraform-remote-state-lab/scripts/test_recovery.sh << 'EOF'
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
EOF
chmod +x ~/terraform-remote-state-lab/scripts/test_recovery.sh
~/terraform-remote-state-lab/scripts/test_recovery.sh

echo "##### TASK 5: advanced #####"
cat > ~/terraform-remote-state-lab/scripts/verify_encryption.sh << 'EOF'
#!/bin/bash
source ~/lab5.env
source ~/terraform-remote-state-lab/bucket_info.env
echo "Verifying state file encryption..."
aws s3api get-bucket-encryption --bucket $S3_BUCKET_NAME
aws s3api head-object --bucket $S3_BUCKET_NAME --key infrastructure/terraform.tfstate --query 'ServerSideEncryption'
aws s3api get-bucket-versioning --bucket $S3_BUCKET_NAME
echo "Encryption verification completed."
EOF
chmod +x ~/terraform-remote-state-lab/scripts/verify_encryption.sh
~/terraform-remote-state-lab/scripts/verify_encryption.sh

# 5.2 created, not run (running it drops a backend_local.tf that conflicts with backend.tf)
cat > ~/terraform-remote-state-lab/scripts/migrate_state.sh << 'EOF'
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
EOF
chmod +x ~/terraform-remote-state-lab/scripts/migrate_state.sh

cat > ~/terraform-remote-state-lab/scripts/monitor_state.sh << 'EOF'
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
EOF
chmod +x ~/terraform-remote-state-lab/scripts/monitor_state.sh
~/terraform-remote-state-lab/scripts/monitor_state.sh

echo "##### TASK 6: cleanup script (created, NOT run) + resource listing #####"
cat > ~/terraform-remote-state-lab/scripts/cleanup.sh << 'EOF'
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
EOF
chmod +x ~/terraform-remote-state-lab/scripts/cleanup.sh

source ~/terraform-remote-state-lab/bucket_info.env
echo "S3 Buckets:";      aws s3 ls | grep terraform-state
echo "DynamoDB Tables:"; aws dynamodb list-tables --query 'TableNames[?contains(@, `terraform-state-lock`)]'
echo "VPC Resources:";   aws ec2 describe-vpcs --filters "Name=tag:ManagedBy,Values=Terraform" --query 'Vpcs[*].{VpcId:VpcId,CidrBlock:CidrBlock,Tags:Tags}'
echo "##### LAB SCRIPT DONE in $(( $(date +%s) - START ))s #####"
