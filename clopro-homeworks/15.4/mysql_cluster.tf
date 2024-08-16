# Создаем кластер MySQL
resource "yandex_mdb_mysql_cluster" "cluster" {
  name               = "cluster"
  environment        = "PRESTABLE"
  network_id         = yandex_vpc_network.common.id
  version            = "8.0"
  host {
    subnet_id = yandex_vpc_subnet.subnet_a_private.id
    zone      = "ru-central1-a"
    assign_public_ip = false
  }
  host {
    subnet_id = yandex_vpc_subnet.subnet_b_private.id
    zone      = "ru-central1-b"
    assign_public_ip = false
  }
  host {
    subnet_id = yandex_vpc_subnet.subnet_d_private.id
    zone      = "ru-central1-d"
    assign_public_ip = false
  }
  resources {
    resource_preset_id = "b2.medium"
    disk_size          = 20
    disk_type_id       = "network-hdd"
  }
  backup_window_start {
    hours   = "23"
    minutes = "59"
  }
  maintenance_window {
    type = "WEEKLY"
    day  = "FRI"
    hour = "22"
  }
  deletion_protection = false
}

# Создаем базу данных MySQL
resource "yandex_mdb_mysql_database" "db" {
  name        = "netology_db"
  cluster_id  = yandex_mdb_mysql_cluster.cluster.id
}

# Создаем пользователя MySQL
resource "yandex_mdb_mysql_user" "user" {
  name             = "netology"
  password         = "qwerty123"
  cluster_id       = yandex_mdb_mysql_cluster.cluster.id
  permission {
    database_name = yandex_mdb_mysql_database.db.name
    roles         = ["ALL"]
  }
}

# Создаем внешний IP-адрес для NAT
resource "yandex_vpc_address" "k8s-nat-ip" {
  name = "k8s-nat-ip"
  external_ipv4_address {
    zone_id = yandex_vpc_subnet.subnet_a_public.zone
  }
}