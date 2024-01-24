# Домашнее задание к занятию «Управляющие конструкции в коде Terraform»

### Цели задания

1. Отработать основные принципы и методы работы с управляющими конструкциями Terraform.
2. Освоить работу с шаблонизатором Terraform (Interpolation Syntax).

------

### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Доступен исходный код для выполнения задания в директории [**03/src**](https://github.com/netology-code/ter-homeworks/tree/main/03/src).
4. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Консоль управления Yandex Cloud](https://console.cloud.yandex.ru/folders/<cloud_id>/vpc/security-groups).
2. [Группы безопасности](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav).
3. [Datasource compute disk](https://terraform-eap.website.yandexcloud.net/docs/providers/yandex/d/datasource_compute_disk.html).

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
Убедитесь что ваша версия **Terraform** =1.5.Х (версия 1.6 может вызывать проблемы с Яндекс провайдером)
Теперь пишем красивый код, хардкод значения не допустимы!
------

### Задание 1

1. Изучите проект.
2. Заполните файл personal.auto.tfvars.
3. Инициализируйте проект, выполните код. Он выполнится, даже если доступа к preview нет.

Примечание. Если у вас не активирован preview-доступ к функционалу «Группы безопасности» в Yandex Cloud, запросите доступ у поддержки облачного провайдера. Обычно его выдают в течение 24-х часов.

Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud или скриншот отказа в предоставлении доступа к preview-версии.

## Ответ

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/f6fcb041-6cbd-4534-9788-5be43ec6e789)

------

### Задание 2

1. Создайте файл count-vm.tf. Опишите в нём создание двух **одинаковых** ВМ  web-1 и web-2 (не web-0 и web-1) с минимальными параметрами, используя мета-аргумент **count loop**. Назначьте ВМ созданную в первом задании группу безопасности.(как это сделать узнайте в документации провайдера yandex/compute_instance )
2. Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ для баз данных с именами "main" и "replica" **разных** по cpu/ram/disk , используя мета-аргумент **for_each loop**. Используйте для обеих ВМ одну общую переменную типа:
```
variable "each_vm" {
  type = list(object({  vm_name=string, cpu=number, ram=number, disk=number }))
}
```  
При желании внесите в переменную все возможные параметры.
4. ВМ из пункта 2.1 должны создаваться после создания ВМ из пункта 2.2.
5. Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2.
6. Инициализируйте проект, выполните код.

------

## Ответ

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/b64b0d4c-ce9d-448a-9616-3224c1777c41)
- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/10b018e2-a3a7-4834-a969-0ff5886e9cf1)

- count-vm.tf
```
resource "yandex_compute_instance" "web" {
  name        = "web-${count.index + 1}"
  platform_id = var.vm_web_standard-v2

  count = 2

  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.db_ubuntu-2004-lts.image_id
      type     = var.vm_web_network-disk.web.type
      size     = var.vm_web_network-disk.web.size
    }
  }
```
```
network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = true

  }
```

- for_each-vm.tf
```
resource "yandex_compute_instance" "db" {
  for_each    = { for vm in var.db : vm.vm_name => vm }
  name        = each.value.vm_name
  platform_id = each.value.platform

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.web_ubuntu-2004-lts.image_id
      type     = each.value.type
      size     = each.value.disk
    }
  }
```
```
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
      memory        = 4
      core_fraction = 20
      disk          = 8
      type          = "network-ssd"
      platform      = "standard-v1"
    },
    {
      vm_name       = "replica"
      cores         = 4
      memory        = 2
      core_fraction = 50
      disk          = 5
      type          = "network-hdd"
      platform      = "standard-v2"
    }
  ]
}
```
- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/2d3a6130-e896-41cc-b23c-84862564101f)
- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/7c26544f-0dbc-42ad-a25d-468487252982)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/8a611131-5bd0-4c3d-ba3b-bf0f514ece12)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/392e6e78-cf08-4345-ac0d-3f7fabd5cbfe)

### Задание 3

1. Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле **disk_vm.tf** .
2. Создайте в том же файле **одиночную**(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage"  . Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.

------

## Ответ
- disk_vm.tf
```
resource "yandex_compute_disk" "storage_disk" {
  count = 3
  name  = "disk-${count.index}"
  type  = var.vm_web_network-disk.web.type
  zone  = var.default_zone
  size  = 1
}
```
```
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = var.vm_web_standard-v2
  zone        = var.default_zone

  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.db_ubuntu-2004-lts.image_id
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk

    content {
      disk_id     = secondary_disk.value.id
      device_name = "secondary-disk-${secondary_disk.key + 1}"
    }
  }

  metadata = {
    serial-port-enable = var.public_key.serial-port-enable
    ssh-keys           = "ubuntu:${local.ssh_public_key}"
    sensitive          = true
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  allow_stopping_for_update = true
}
```
- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/5c19659b-8854-4c1d-b3ef-744fd861beb5)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/7236760c-8f54-48d5-a6ea-3f6934a81d27)

### Задание 4

1. В файле ansible.tf создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demo).
Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.
2. Инвентарь должен содержать 3 группы и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ.
3. Добавьте в инвентарь переменную  [**fqdn**](https://cloud.yandex.ru/docs/compute/concepts/network#hostname).
``` 
[webservers]
web-1 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
web-2 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[databases]
main ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
replica ansible_host<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[storage]
storage ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
```
Пример fqdn: ```web1.ru-central1.internal```(в случае указания имени ВМ); ```fhm8k1oojmm5lie8i22a.auto.internal```(в случае автоматической генерации имени ВМ зона изменяется). ужную вам переменную найдите в документации провайдера или terraform console.
4. Выполните код. Приложите скриншот получившегося файла. 

## Ответ
- ansible.tf
```
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",

    {
      webservers = yandex_compute_instance.web,
      databases  = yandex_compute_instance.db,
      storage    = [yandex_compute_instance.storage-vm]
  })

  filename = "${abspath(path.module)}/hosts.cfg"
}


resource "null_resource" "web_hosts_provision" {
  #Ждем создания инстанса
  depends_on = [yandex_compute_instance.web]

  #Добавление ПРИВАТНОГО ssh ключа в ssh-agent
  provisioner "local-exec" {
    command = "eval $(ssh-agent -s) | ssh-add ~/.ssh/id_ed25519"
  }

  #Костыль!!! Даем ВМ 60 сек на первый запуск. Лучше выполнить это через wait_for port 22 на стороне ansible
  # В случае использования cloud-init может потребоваться еще больше времени
  provisioner "local-exec" {
    command = "sleep 60"
  }

  #Запуск ansible-playbook
  provisioner "local-exec" {
    command     = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${abspath(path.module)}/hosts.cfg ${abspath(path.module)}/test.yml"
    on_failure  = continue #Продолжить выполнение terraform pipeline в случае ошибок
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
    #срабатывание триггера при изменении переменных
  }
  triggers = {
    always_run        = "${timestamp()}"                         #всегда т.к. дата и время постоянно изменяются
    playbook_src_hash = file("${abspath(path.module)}/test.yml") # при изменении содержимого playbook файла
    ssh_public_key    = local.ssh_public_key                     # при изменении переменной
  }

}
```
-hosts.tftpl
```
[webservers]

 %{~ for i in webservers ~}
 ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i["fqdn"]}
 %{~ endfor ~}

[databases]

%{~ for i in databases ~}
 ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i["fqdn"]}
 %{~ endfor ~}

[storage]

 %{~ for i in storage ~}
 ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i["fqdn"]}
 %{~ endfor ~}
```
- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/0e0be816-8e98-4f2d-b8c6-eb419832219c)

Для общего зачёта создайте в вашем GitHub-репозитории новую ветку terraform-03. Закоммитьте в эту ветку свой финальный код проекта, пришлите ссылку на коммит.   
**Удалите все созданные ресурсы**.

------

## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 

### Задание 5* (необязательное)
1. Напишите output, который отобразит ВМ из ваших ресурсов count и for_each в виде списка словарей :
``` 
[
 {
  "name" = 'имя ВМ1'
  "id"   = 'идентификатор ВМ1'
  "fqdn" = 'Внутренний FQDN ВМ1'
 },
 {
  "name" = 'имя ВМ2'
  "id"   = 'идентификатор ВМ2'
  "fqdn" = 'Внутренний FQDN ВМ2'
 },
 ....
...итд любое количество ВМ в ресурсе(те требуется итерация по ресурсам, а не хардкод) !!!!!!!!!!!!!!!!!!!!!
]
```
Приложите скриншот вывода команды ```terrafrom output```.

------

## Ответ

```
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
```

### Задание 6* (необязательное)

1. Используя null_resource и local-exec, примените ansible-playbook к ВМ из ansible inventory-файла.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demo).
3. Модифицируйте файл-шаблон hosts.tftpl. Необходимо отредактировать переменную ```ansible_host="<внешний IP-address или внутренний IP-address если у ВМ отсутвует внешний адрес>```.

Для проверки работы уберите у ВМ внешние адреса(nat=false). Этот вариант используется при работе через bastion-сервер.
Для зачёта предоставьте код вместе с основной частью задания.

### Правила приёма работы

В своём git-репозитории создайте новую ветку terraform-03, закоммитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-03.

В качестве результата прикрепите ссылку на ветку terraform-03 в вашем репозитории.

Важно. Удалите все созданные ресурсы.

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 

