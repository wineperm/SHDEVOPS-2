variable "cloud_id" {
  type        = string
  description = "default.cloud_id"
}

variable "folder_id" {
  type        = string
  description = "default.folder_id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
