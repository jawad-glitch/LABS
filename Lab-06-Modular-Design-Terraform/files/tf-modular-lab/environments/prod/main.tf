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
