module "vpc_dev" {
  source   = "./module_vpc"
  vpc_name = "vpc_dev"
}

module "test-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop"
  network_id     = module.vpc_dev.vpc_id
  subnet_zones   = ["ru-central1-a"]
  subnet_ids     = [module.vpc_dev.subnet_id]
  instance_name  = "web"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true
  labels = {
    project = "marketing"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}

module "example-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "stage"
  network_id     = module.vpc_dev.vpc_id
  subnet_zones   = ["ru-central1-a"]
  subnet_ids     = [module.vpc_dev.subnet_id]
  instance_name  = "web-stage"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true
  labels = {
    project = "analytics"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}

#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    username       = var.keys.cloudinit.username
    ssh_public_key = file(var.keys.cloudinit.ssh_public_key[0])
  }
}


