data "yandex_compute_image" "db_ubuntu-2004-lts" {
  family = var.vm_ubuntu-2004-lts
}

resource "yandex_compute_instance" "web" {
  name        = "web-${count.index + 1}"
  platform_id = var.vm_web_standard-v2
  hostname    = "web-${count.index + 1}"

  count = 2

  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.db_ubuntu-2004-lts.image_id
      type     = var.vm_web_network-disk.web.type
      size     = var.vm_web_network-disk.web.size
    }
  }

  metadata = {
    serial-port-enable = var.public_key.serial-port-enable
    ssh-keys           = "ubuntu:${local.ssh_public_key}"
    sensitive          = true
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = true

  }
  allow_stopping_for_update = true

  depends_on = [yandex_compute_instance.db]
}
