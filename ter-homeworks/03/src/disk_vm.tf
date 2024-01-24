resource "yandex_compute_disk" "storage_disk" {
  count = 3
  name  = "disk-${count.index}"
  type  = var.vm_web_network-disk.web.type
  zone  = var.default_zone
  size  = 1
}

resource "yandex_compute_instance" "storage-vm" {
  name        = "storage"
  platform_id = var.vm_web_standard-v2
  zone        = var.default_zone
  hostname    = "storage"

  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.db_ubuntu-2004-lts.image_id
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk

    content {
      disk_id     = secondary_disk.value.id
      device_name = "secondary-disk-${secondary_disk.key + 1}"
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


