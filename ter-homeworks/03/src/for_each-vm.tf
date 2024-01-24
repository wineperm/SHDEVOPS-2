data "yandex_compute_image" "web_ubuntu-2004-lts" {
  family = var.vm_ubuntu-2004-lts
}

resource "yandex_compute_instance" "db" {
  for_each    = { for vm in var.db : vm.vm_name => vm }
  name        = each.value.vm_name
  platform_id = each.value.platform
  hostname    = each.value.vm_name

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.web_ubuntu-2004-lts.image_id
      type     = each.value.type
      size     = each.value.disk
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
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  allow_stopping_for_update = true
}
