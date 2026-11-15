terraform {
  required_version = ">= 1.4.0"
}

resource "terraform_data" "lab_instance" {
  input = {
    project       = "terraform-introduction-lab"
    environment   = "dev"
    revision      = "2"
    instance      = "simulated-ec2-instance"
    instance_type = "t2.micro"
  }
}

output "project_name" {
  value = terraform_data.lab_instance.output.project
}

output "environment" {
  value = terraform_data.lab_instance.output.environment
}

output "simulated_instance" {
  value = terraform_data.lab_instance.output.instance
}

output "simulated_instance_type" {
  value = terraform_data.lab_instance.output.instance_type
}

output "configuration_revision" {
  value = terraform_data.lab_instance.output.revision
}
