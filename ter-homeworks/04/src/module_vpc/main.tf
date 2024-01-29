terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}


resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "vpc" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = var.default_cidr
}
