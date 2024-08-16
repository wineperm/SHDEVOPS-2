# Создаем виртуальную сеть "common"
resource "yandex_vpc_network" "common" {
  name = "common"
}

# Создаем подсеть "subnet-a-private" в зоне "ru-central1-a"
resource "yandex_vpc_subnet" "subnet_a_private" {
  name           = "subnet-a-private"
  network_id     = yandex_vpc_network.common.id
  v4_cidr_blocks = ["10.0.1.0/24"]
  zone           = "ru-central1-a"
}

# Создаем подсеть "subnet-b-private" в зоне "ru-central1-b"
resource "yandex_vpc_subnet" "subnet_b_private" {
  name           = "subnet-b-private"
  network_id     = yandex_vpc_network.common.id
  v4_cidr_blocks = ["10.0.2.0/24"]
  zone           = "ru-central1-b"
}

# Создаем подсеть "subnet-d-private" в зоне "ru-central1-d"
resource "yandex_vpc_subnet" "subnet_d_private" {
  name           = "subnet-d-private"
  network_id     = yandex_vpc_network.common.id
  v4_cidr_blocks = ["10.0.3.0/24"]
  zone           = "ru-central1-d"
}

# Создаем подсеть "subnet-a-public" в зоне "ru-central1-a"
resource "yandex_vpc_subnet" "subnet_a_public" {
  name           = "subnet-a-public"
  v4_cidr_blocks = ["10.0.4.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.common.id
}

# Создаем подсеть "subnet-b-public" в зоне "ru-central1-b"
resource "yandex_vpc_subnet" "subnet_b_public" {
  name           = "subnet-b-public"
  v4_cidr_blocks = ["10.0.5.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.common.id
}

# Создаем подсеть "subnet-d-public" в зоне "ru-central1-d"
resource "yandex_vpc_subnet" "subnet_d_public" {
  name           = "subnet-d-public"
  v4_cidr_blocks = ["10.0.6.0/24"]
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.common.id
}