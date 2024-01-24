###cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "public_key" {
  type = map(any)
  default = {
    serial-port-enable = "1"
    ssh-keys           = "!!!!!!!!!!!!!!!!!!!!!!!"
  }
}
variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}
variable "vm_ubuntu-2004-lts" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "image ubuntu-2004-lts"
}
variable "vm_web_standard-v2" {
  type        = string
  default     = "standard-v2"
  description = "web_platform-id"
}
variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
  default = {
    web = {
      cores         = 2
      memory        = 2
      core_fraction = 5
    }
  }
}
variable "vm_web_network-disk" {
  type = map(object({
    type = string
    size = number
  }))
  default = {
    web = {
      type        = "network-hdd"
      size        = "5"
      description = "web_choice network-disk"
    }
  }
}

variable "db" {
  type = list(object({
    vm_name       = string
    cores         = number
    memory        = number
    core_fraction = number
    disk          = number
    type          = string
    platform      = string
  }))
  default = [
    {
      vm_name       = "main"
      cores         = 2
      memory        = 2
      core_fraction = 5
      disk          = 5
      type          = "network-hdd"
      platform      = "standard-v2"
    },
    {
      vm_name       = "replica"
      cores         = 2
      memory        = 2
      core_fraction = 5
      disk          = 5
      type          = "network-hdd"
      platform      = "standard-v2"
    }
  ]
}
