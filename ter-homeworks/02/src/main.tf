resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop-web" {
  name           = var.vm_web_vpc_name
  zone           = var.vm_web_default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_web_default_cidr
}

resource "yandex_vpc_subnet" "develop-db" {
  name           = var.vm_db_vpc_name
  zone           = var.vm_db_default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_db_default_cidr
}


data "yandex_compute_image" "ubuntu-web" {
  family = var.vm_web_ubuntu-2004-lts
}

resource "yandex_compute_instance" "platform-web" {
  name        = local.vm_web
  platform_id = var.vm_web_standard-v2
  
  zone        = var.vm_web_default_zone

  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-web.image_id
    }
  }
  
  scheduling_policy {
    preemptible = true
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop-web.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.metadatas.serial-port-enable
    ssh-keys           = "ubuntu:${var.metadatas.ssh-keys}"
  }

}

data "yandex_compute_image" "ubuntu-db" {
  family = var.vm_db_ubuntu-2004-lts
}

resource "yandex_compute_instance" "platform-db" {
  name        = local.vm_db
  platform_id = var.vm_db_standard-v2
  
  zone        = var.vm_db_default_zone
  
  resources {
    cores         = var.vms_resources.db.cores
    memory        = var.vms_resources.db.memory
    core_fraction = var.vms_resources.db.core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-db.image_id
    }
  }
  
  scheduling_policy {
    preemptible = true
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop-db.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.metadatas.serial-port-enable
    ssh-keys           = "ubuntu:${var.metadatas.ssh-keys}"
  }
}
