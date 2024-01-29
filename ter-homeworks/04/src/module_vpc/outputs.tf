
output "vpc_id" {
  value = yandex_vpc_network.vpc.id
}

output "subnet_id" {
  value = yandex_vpc_subnet.vpc.id
}

output "vpc_name" {
  value = var.vpc_name
}

output "default_zone" {
  value = var.default_zone
}

output "default_cidr" {
  value = var.default_cidr
}

output "network_id" {
  value = yandex_vpc_network.vpc.id
}
