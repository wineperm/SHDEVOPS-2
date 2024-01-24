output "vm_for_each_and_count" {
  value = [
    [
      for i in yandex_compute_instance.web : {
        name = i.name
        id   = i.id
        fqdn = i.fqdn
      }
    ],
    [
      for i in yandex_compute_instance.db : {
        name = i.name
        id   = i.id
        fqdn = i.fqdn
      }
    ]
  ]
}
