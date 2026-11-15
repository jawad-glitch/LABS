#!/usr/bin/env bash
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a
. ~/lab6.env
mkdir -p "$TF_PLUGIN_CACHE_DIR"
START=$(date +%s)

echo "##### TASK 1: tools (parallel) + simulated AWS #####"
sudo apt-get update -qq < /dev/null
sudo apt-get install -y -qq wget unzip curl jq ca-certificates git python3-venv < /dev/null

wget -q https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip -O /tmp/terraform.zip &
curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip &
( python3 -m venv ~/moto-venv && ~/moto-venv/bin/pip install -q --prefer-binary 'moto[server,ec2]' ) &
wait

unzip -qo /tmp/terraform.zip -d /tmp && sudo mv -f /tmp/terraform /usr/local/bin/ < /dev/null
unzip -qo /tmp/awscliv2.zip -d /tmp/awscli-install && sudo /tmp/awscli-install/aws/install --update < /dev/null > /dev/null
rm -rf /tmp/awscliv2.zip /tmp/awscli-install

# simulated "aws configure"
mkdir -p ~/.aws
printf '[default]\naws_access_key_id = test\naws_secret_access_key = test\n' > ~/.aws/credentials
printf '[default]\nregion = us-east-1\noutput = json\n' > ~/.aws/config

# local AWS emulator
curl -s localhost:5000/moto-api/ >/dev/null || { setsid nohup ~/moto-venv/bin/moto_server -p 5000 > /tmp/moto.log 2>&1 < /dev/null & }
for i in $(seq 1 30); do curl -s localhost:5000/moto-api/ >/dev/null && break; sleep 1; done

terraform version
aws --version
aws sts get-caller-identity
AMI=$(aws ec2 describe-images --query 'Images[0].ImageId' --output text 2>/dev/null); [ -z "$AMI" -o "$AMI" = None ] && AMI=ami-12c6146b
echo "Using emulator AMI: $AMI"

echo "##### TASK 2: module #####"
M=~/tf-modular-lab/modules/ec2
mkdir -p $M ~/tf-modular-lab/environments/{dev,test,prod}

cat > $M/variables.tf << 'EOF'
variable "name" {
  description = "Short name of the instance (e.g. web, app)"
  type        = string
}

variable "environment" {
  description = "Environment label (dev, test, prod)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to launch"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp3"
}

variable "enable_monitoring" {
  description = "Enable detailed CloudWatch monitoring"
  type        = bool
  default     = false
}

variable "associate_public_ip" {
  description = "Associate a public IP address"
  type        = bool
  default     = true
}

variable "subnet_id" {
  description = "Subnet to launch into (null = default subnet)"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC for the module-created security group (null = default VPC)"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "Existing security groups. If empty, the module creates its own"
  type        = list(string)
  default     = []
}

variable "ingress_ports" {
  description = "TCP ports opened by the module-created security group"
  type        = list(number)
  default     = [22]
}

variable "user_data" {
  description = "Startup script (user data)"
  type        = string
  default     = null
}

variable "extra_tags" {
  description = "Additional tags merged over the standard set"
  type        = map(string)
  default     = {}
}
EOF

cat > $M/main.tf << 'EOF'
locals {
  create_sg = length(var.security_group_ids) == 0

  tags = merge({
    Name        = "${var.environment}-${var.name}"
    Environment = var.environment
    Role        = var.name
    ManagedBy   = "Terraform"
    Module      = "ec2"
  }, var.extra_tags)
}

resource "aws_security_group" "this" {
  count       = local.create_sg ? 1 : 0
  name_prefix = "${var.environment}-${var.name}-"
  description = "Security group for ${var.environment}-${var.name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      description = "TCP ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = local.create_sg ? [aws_security_group.this[0].id] : var.security_group_ids
  monitoring                  = var.enable_monitoring
  associate_public_ip_address = var.associate_public_ip
  user_data                   = var.user_data

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = true
    delete_on_termination = true
  }

  tags        = local.tags
  volume_tags = local.tags
}
EOF

cat > $M/outputs.tf << 'EOF'
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP address"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "Private IP address"
  value       = aws_instance.this.private_ip
}

output "security_group_ids" {
  description = "Security group IDs used by the instance"
  value       = local.create_sg ? [aws_security_group.this[0].id] : var.security_group_ids
}
EOF

cd $M && terraform init -input=false && terraform validate; echo "module validate exit code: $?"

echo "##### TASK 3: environments #####"
E=~/tf-modular-lab/environments

for e in dev test prod; do
cat > $E/$e/provider.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Simulated AWS: local moto emulator
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints {
    ec2 = "http://localhost:5000"
    sts = "http://localhost:5000"
  }
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}
EOF
echo "ami_id = \"$AMI\"" > $E/$e/terraform.tfvars
done

cat > $E/dev/main.tf << 'EOF'
module "app" {
  source           = "../../modules/ec2"
  name             = "app"
  environment      = "dev"
  ami_id           = var.ami_id
  instance_type    = "t3.nano"
  root_volume_size = 8
  extra_tags = {
    AutoShutdown     = "true"
    ShutdownSchedule = "weekdays-19:00"
    CostCenter       = "dev-sandbox"
  }
}
EOF
cat > $E/dev/outputs.tf << 'EOF'
output "instances" {
  description = "Summary of every dev instance"
  value = {
    app = {
      instance_id = module.app.instance_id
      public_ip   = module.app.public_ip
      private_ip  = module.app.private_ip
    }
  }
}
EOF

cat > $E/test/main.tf << 'EOF'
module "web" {
  source           = "../../modules/ec2"
  name             = "web"
  environment      = "test"
  ami_id           = var.ami_id
  instance_type    = "t3.micro"
  root_volume_size = 10
  ingress_ports    = [22, 80, 443]
  extra_tags       = { Tier = "web" }
}

module "app" {
  source           = "../../modules/ec2"
  name             = "app"
  environment      = "test"
  ami_id           = var.ami_id
  instance_type    = "t3.small"
  root_volume_size = 20
  ingress_ports    = [22, 8080]
  extra_tags       = { Tier = "application" }
}
EOF
cat > $E/test/outputs.tf << 'EOF'
output "instances" {
  description = "Summary of every test instance"
  value = {
    web = {
      instance_id = module.web.instance_id
      public_ip   = module.web.public_ip
      private_ip  = module.web.private_ip
    }
    app = {
      instance_id = module.app.instance_id
      public_ip   = module.app.public_ip
      private_ip  = module.app.private_ip
    }
  }
}
EOF

cat > $E/prod/main.tf << 'EOF'
locals {
  instances = {
    web = { type = "t3.large", size = 30, ports = [22, 80, 443] }
    app = { type = "t3.large", size = 40, ports = [22, 8080] }
    db  = { type = "t3.xlarge", size = 100, ports = [22, 5432] }
  }
}

module "instance" {
  source   = "../../modules/ec2"
  for_each = local.instances

  name              = each.key
  environment       = "prod"
  ami_id            = var.ami_id
  instance_type     = each.value.type
  root_volume_size  = each.value.size
  ingress_ports     = each.value.ports
  enable_monitoring = true
  extra_tags = {
    Backup              = "daily"
    BackupRetentionDays = "35"
    BackupPlan          = "prod-standard"
  }
}
EOF
cat > $E/prod/outputs.tf << 'EOF'
output "instances" {
  description = "Summary of every prod instance"
  value = {
    for k, m in module.instance : k => {
      instance_id = m.instance_id
      public_ip   = m.public_ip
      private_ip  = m.private_ip
    }
  }
}
EOF

# fmt + run all three environments in parallel (provider already cached by the module init)
terraform fmt -recursive ~/tf-modular-lab > /dev/null
run_env() {
  cd ~/tf-modular-lab/environments/$1 || exit 1
  terraform init -input=false \
  && terraform plan -input=false -out=$1.tfplan \
  && terraform show -json $1.tfplan > $1-plan.json \
  && terraform apply -input=false -auto-approve $1.tfplan \
  && terraform output
}
for e in dev test prod; do run_env $e > /tmp/env-$e.log 2>&1 & done
wait
for e in dev test prod; do echo; echo "===== ENV: $e ====="; tail -n 45 /tmp/env-$e.log; done

echo; echo "##### Plan comparison (type / root GB / monitoring) #####"
for e in dev test prod; do
  echo "--- $e ---"
  jq -r '.planned_values | [.. | objects | select(.type? == "aws_instance")] | .[] | [.address, .values.instance_type, (.values.root_block_device[0].volume_size|tostring), ("monitoring=" + (.values.monitoring|tostring))] | @tsv' ~/tf-modular-lab/environments/$e/$e-plan.json
done

echo; echo "##### Acceptance: prod plan JSON grep #####"
cd ~/tf-modular-lab/environments/prod
terraform show -json prod.tfplan | grep -oE '"(monitoring|volume_size)":[^,]*' | sort | uniq -c
echo "##### LAB SCRIPT DONE in $(( $(date +%s) - START ))s #####"
