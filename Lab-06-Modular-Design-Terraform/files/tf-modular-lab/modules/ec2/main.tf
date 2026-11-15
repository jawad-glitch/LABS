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
