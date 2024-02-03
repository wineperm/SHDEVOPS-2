resource "random_password" "azuresecrets" {
  length  = 32
  special = true
  count   = length(var.secret_keys)
}

resource "vault_generic_secret" "azuresecrets" {
  path      = "secret/netology_shdevops-2"
  count     = length(var.secret_keys)
  data_json = <<EOT
    {
    "${var.secret_keys[0]}": "${random_password.azuresecrets.0.result}"
  }
    EOT
}
