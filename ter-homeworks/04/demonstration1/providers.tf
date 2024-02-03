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
  service_account_key_file = file("~/authorized_key.json")
  zone                     = "ru-central1-a" #(Optional) The default availability zone to operate under, if not specified by a given resource.
}
