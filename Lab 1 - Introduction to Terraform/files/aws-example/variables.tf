variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "http_cidr" {
  description = "CIDR allowed to access HTTP; restrict this before deployment"
  type        = string
  default     = "0.0.0.0/0"
}
