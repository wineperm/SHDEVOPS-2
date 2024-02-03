terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.5"
}

provider "yandex" {
  # token                    = "do not use!!!"
  cloud_id                 = "!!!!!!!!!!!!!!!!!!!!"
  folder_id                = "!!!!!!!!!!!!!!!!!!!!"
  service_account_key_file = file("~/.ssh/authorized_key.json")
  zone                     = "ru-central1-a" #(Optional) The default availability zone to operate under, if not specified by a given resource.
}

provider "vault" {
  address         = "http://127.0.0.1:8200"
  skip_tls_verify = true
  token           = "education"
  # checkov:skip=CKV_SECRET_6: education
}
