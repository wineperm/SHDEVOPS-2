variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

###common vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDuxuqOb1cJ1k/j3Q1IKOp75JjS6oPPMg/xsNxImn2M vagrant@server1"
  description = "ssh-keygen -t ed25519"
}

###example vm_web var
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "example vm_web_ prefix"
}

###example vm_db var
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "example vm_db_ prefix"
}
variable "keys" {
  type = map(object({
    username       = string
    ssh_public_key = list(string)
  }))
  default = {
    cloudinit = {
      username       = "ubuntu"
      ssh_public_key = ["~/.ssh/id_ed25519.pub"]
    }
  }
}
