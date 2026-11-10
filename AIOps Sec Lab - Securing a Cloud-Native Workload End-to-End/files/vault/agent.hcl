pid_file = "/tmp/pidfile"
exit_after_auth = false
vault { address = "http://l8-vault:8200" }
auto_auth {
  method "kubernetes" {
    mount_path = "auth/kubernetes"
    config = { role = "shop-api", token_path = "/var/run/secrets/kubernetes.io/serviceaccount/token" }
  }
  sink "file" { config = { path = "/tmp/vault-token" } }
}
template {
  destination = "/vault/secrets/db.env"
  contents = <<EOT
{{- with secret "secret/data/shop/db" -}}
DB_USER={{ .Data.data.username }}
DB_PASS={{ .Data.data.password }}
{{- end }}
EOT
}
