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
