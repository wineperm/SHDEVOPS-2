# Объявляем переменную yc_cloud_id
variable "yc_cloud_id" {
  type        = string
  description = "ID облака"
}

# Объявляем переменную yc_folder_id
variable "yc_folder_id" {
  type        = string
  description = "ID каталога"
}

# Объявляем переменную yc_zone
variable "yc_zone" {
  description = "Зона Yandex Cloud"
  default     = "ru-central1-a"
}