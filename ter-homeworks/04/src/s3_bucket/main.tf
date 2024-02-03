resource "yandex_iam_service_account" "sa" {
  folder_id = var.folder_id
  name      = "tf-test-sa"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "wineperm"
  max_size   = 1073741824

  # versioning {
  #   enabled = true
  # }

}












# # To always have a unique bucket name in this example
# resource "random_string" "unique_id" {
#   length  = 8
#   upper   = false
#   lower   = true
#   numeric = true
#   special = false
# }

# module "s3" {
#   source = "../../"

#   bucket_name = "simple-bucket-${random_string.unique_id.result}"
# }
