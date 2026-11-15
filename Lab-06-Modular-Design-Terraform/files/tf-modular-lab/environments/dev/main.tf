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
