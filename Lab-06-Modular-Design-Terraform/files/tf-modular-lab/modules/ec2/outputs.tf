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
