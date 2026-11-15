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
