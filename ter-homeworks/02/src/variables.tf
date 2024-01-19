variable "cloud_id" {
  default     = "!!!!!!!!!!!!!!!!!!!!"
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  default     = "!!!!!!!!!!!!!!!!!!!!"
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "vm_web_default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vm_web_default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_web_vpc_name" {
  type        = string
  default     = "develop-web"
  description = "VPC network & subnet name"
}

variable "vm_web_ubuntu-2004-lts" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "image web ubuntu-2004-lts"
}

variable "vm_web_netology-develop-platform-web" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "name-platform-vm"
}

variable "vm_web_standard-v2" {
  type        = string
  default     = "standard-v2"
  description = "platform-id"
}

#variable "vm_web_cores" {
#  type        = number
#  default     = 2
#  description = "cores"
#}

#variable "vm_web_memory" { 
#  type        = number
#  default     = 2
#  description = "memory"
#}

#variable "vm_web_core_fraction" { 
#  type        = number
#  default     = 5
#  description = "fraction"
#} 

variable "name" { 
  type        = string
  default     = "netology-develop"
  description = "locals name1"
} 

variable "my_object" {
  type = object({
    web = string
    db = string
  })
  default = {
    web = "platform-web"
    db = "platform-db"
  }
  description = "locals name2"
}

###ssh vars

#variable "vms_ssh_root_key" {
#  type        = string
#  default     = "ssh-ed25519 !!!!!!!!!!!!!!!!!!!!"
#  description = "ssh-keygen -t ed25519"
#}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


