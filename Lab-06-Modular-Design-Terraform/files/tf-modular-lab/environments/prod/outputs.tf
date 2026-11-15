output "instances" {
  description = "Summary of every prod instance"
  value = {
    for k, m in module.instance : k => {
      instance_id = m.instance_id
      public_ip   = m.public_ip
      private_ip  = m.private_ip
    }
  }
}
