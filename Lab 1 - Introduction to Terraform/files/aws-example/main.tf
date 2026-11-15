terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "terraform_sg" {
  name_prefix = "terraform-intro-"
  description = "Terraform introduction lab HTTP security group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.http_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "terraform-lab-sg"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

resource "aws_instance" "terraform_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.terraform_sg.id]

  user_data = <<-USERDATA
    #!/bin/bash
    dnf install -y httpd
    systemctl enable --now httpd
    echo '<h1>Hello from Terraform Lab!</h1>' > /var/www/html/index.html
    echo '<p>Provisioned with Terraform.</p>' >> /var/www/html/index.html
  USERDATA

  tags = {
    Name        = "terraform-lab-instance"
    Environment = var.environment
    CreatedBy   = "Terraform"
    Modified    = "true"
  }
}

output "instance_id" {
  value = aws_instance.terraform_instance.id
}

output "instance_public_ip" {
  value = aws_instance.terraform_instance.public_ip
}

output "instance_public_dns" {
  value = aws_instance.terraform_instance.public_dns
}

output "security_group_id" {
  value = aws_security_group.terraform_sg.id
}

output "website_url" {
  value = "http://${aws_instance.terraform_instance.public_ip}"
}
