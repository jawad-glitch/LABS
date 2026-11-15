output "instances" {
  description = "Summary of every test instance"
  value = {
    web = {
      instance_id = module.web.instance_id
      public_ip   = module.web.public_ip
      private_ip  = module.web.private_ip
    }
    app = {
      instance_id = module.app.instance_id
      public_ip   = module.app.public_ip
      private_ip  = module.app.private_ip
    }
  }
}
