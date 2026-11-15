output "instances" {
  description = "Summary of every dev instance"
  value = {
    app = {
      instance_id = module.app.instance_id
      public_ip   = module.app.public_ip
      private_ip  = module.app.private_ip
    }
  }
}
