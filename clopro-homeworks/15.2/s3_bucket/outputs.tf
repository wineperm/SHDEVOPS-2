output "bucket_name" {
  description = "The name of the bucket."
  value       = yandex_storage_bucket.test.bucket
}

output "public_url" {
  value = "https://storage.yandexcloud.net/${yandex_storage_bucket.test.bucket}/${yandex_storage_object.netology_image.key}"
}
