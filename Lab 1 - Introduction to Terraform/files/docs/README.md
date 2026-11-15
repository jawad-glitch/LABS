# Lab 1: Introduction to Terraform

## Local exercise
The `local-demo` directory uses Terraform's built-in `terraform_data` resource.
It demonstrates initialization, validation, planning, applying, outputs,
state inspection, configuration changes, and destruction without AWS access.

This is a local Terraform workflow simulation, not an EC2 instance.

## AWS example
The `aws-example` directory contains an AWS provider configuration, Amazon
Linux 2023 AMI lookup, default VPC lookup, HTTP security group, EC2 instance,
and outputs.

The AWS configuration is not applied in this lab run. Applying it requires
an authorized AWS account, credentials, and review of the resulting costs.
The example intentionally does not create an SSH ingress rule or require
an EC2 key pair.

## State safety
Terraform state can contain sensitive infrastructure information. Do not
commit state files, credentials, or `.terraform` directories to GitHub.
