# Создаем региональный кластер Kubernetes
resource "yandex_kubernetes_cluster" "k8s-regional" {
  name = "k8s-regional"
  network_id = yandex_vpc_network.common.id
  release_channel = "STABLE"
  master {
    master_location {
      zone      = yandex_vpc_subnet.subnet_a_public.zone
      subnet_id = yandex_vpc_subnet.subnet_a_public.id
    }
    master_location {
      zone      = yandex_vpc_subnet.subnet_b_public.zone
      subnet_id = yandex_vpc_subnet.subnet_b_public.id
    }
    master_location {
      zone      = yandex_vpc_subnet.subnet_d_public.zone
      subnet_id = yandex_vpc_subnet.subnet_d_public.id
    }
    public_ip = true
    master_logging {
      enabled                    = true
      folder_id                  = var.yc_folder_id
      kube_apiserver_enabled     = true
      cluster_autoscaler_enabled = true
      events_enabled             = true
      audit_enabled              = true
    }
  }
  service_account_id      = yandex_iam_service_account.my-regional-account.id
  node_service_account_id = yandex_iam_service_account.my-regional-account.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.encrypterDecrypter,
    yandex_resourcemanager_folder_iam_member.logging-writer,
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }
}

# Создаем сервисный аккаунт для кластера
resource "yandex_iam_service_account" "my-regional-account" {
  name        = "regional-k8s-account"
  description = "K8S regional service account"
}

# Назначаем роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  folder_id = var.yc_folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.my-regional-account.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  folder_id = var.yc_folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.my-regional-account.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "load-balancer-admin" {
  folder_id = var.yc_folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.my-regional-account.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  folder_id = var.yc_folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.my-regional-account.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "encrypterDecrypter" {
  folder_id = var.yc_folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.my-regional-account.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "logging-writer" {
  folder_id = var.yc_folder_id
  role      = "logging.writer"
  member    = "serviceAccount:${yandex_iam_service_account.my-regional-account.id}"
}

# Создаем симметричный ключ для шифрования
resource "yandex_kms_symmetric_key" "kms-key" {
  name              = "kms-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}

# Создаем группу нод
resource "yandex_kubernetes_node_group" "node_group_1" {
  name               = "node-group-1"
  cluster_id         = yandex_kubernetes_cluster.k8s-regional.id
  version            = "1.27"
  instance_template {
    platform_id = "standard-v2"
    resources {
      cores  = 2
      memory = 4
      core_fraction = 5
    }
    boot_disk {
      type = "network-ssd"
      size = 30
    }
    scheduling_policy {
      preemptible = true
    }
    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.subnet_a_public.id]
    }
    metadata = {
      "ssh-keys" = file("/home/vagrant/.ssh/k8s.pub")
    }
  }
  scale_policy {
    auto_scale {
      initial = 3
      min     = 3
      max     = 6
    }
  }
  allocation_policy {
    location {
      zone      = yandex_vpc_subnet.subnet_a_public.zone
    }
  }
  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
  }
}