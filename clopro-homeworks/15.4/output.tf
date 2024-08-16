# Выводим ID кластера Kubernetes
output "k8s_cluster_id" {
  value = yandex_kubernetes_cluster.k8s-regional.id
}

# Выводим имя кластера Kubernetes
output "k8s_cluster_name" {
  value = yandex_kubernetes_cluster.k8s-regional.name
}

# Выводим хосты MySQL кластера
output "mysql_hosts" {
  value = yandex_mdb_mysql_cluster.cluster.host
}

# Выводим хост MySQL кластера
output "mysql_host" {
  value = yandex_mdb_mysql_cluster.cluster.host[0].fqdn
}