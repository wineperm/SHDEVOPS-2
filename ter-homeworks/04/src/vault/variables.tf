# Vault URL
variable "vault_url" {
  description = "Vault URL"
  type        = string
  default     = "http://192.168.56.11:8200"
}

# Vault Token
variable "vault_token" {
  default     = "education"
  description = "Vault Token"
  type        = string
}

#--Resource Groups
variable "secret_keys" {
  description = "Keys (Names) For Secrets"
  type        = list(string)
  default     = ["ter-homeworks/04-z7"]
}

