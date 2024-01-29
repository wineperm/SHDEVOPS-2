# Домашнее задание к занятию «Продвинутые методы работы с Terraform»

### Цели задания

1. Научиться использовать модули.
2. Отработать операции state.
3. Закрепить пройденный материал.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**04/src**](https://github.com/netology-code/ter-homeworks/tree/main/04/src).
4. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
Убедитесь что ваша версия **Terraform** =1.5.X (версия 1.6 может вызывать проблемы с Яндекс провайдером)
Пишем красивый код, хардкод значения не допустимы!
------

### Задание 1

1. Возьмите из [демонстрации к лекции готовый код](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1) для создания с помощью двух вызовов remote-модуля -> двух ВМ, относящихся к разным проектам(marketing и analytics) используйте labels для обозначения принадлежности.  В файле cloud-init.yml необходимо использовать переменную для ssh-ключа вместо хардкода. Передайте ssh-ключ в функцию template_file в блоке vars ={} .
Воспользуйтесь [**примером**](https://grantorchard.com/dynamic-cloudinit-content-with-terraform-file-templates/). Обратите внимание, что ssh-authorized-keys принимает в себя список, а не строку.
3. Добавьте в файл cloud-init.yml установку nginx.
4. Предоставьте скриншот подключения к консоли и вывод команды ```sudo nginx -t```, скриншот консоли ВМ yandex cloud с их метками. Откройте terraform console и предоставьте скриншот содержимого модуля. Пример: > module.marketing_vm

## Ответ
- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/c047093d-a57a-4641-96ff-31fd4111a418)

- variables.tf
```
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
```

- main.tf
```
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    username       = var.keys.cloudinit.username
    ssh_public_key = file(var.keys.cloudinit.ssh_public_key[0])
  }
}
```

- cloudinit.yml
```
#cloud-config
users:
  - name: ${username}
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ${ssh_public_key}
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOERolx3KtJ5+3FufMC88MhcYISKmL28lYydyc4MGYV udjin@udjin-VirtualBox
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtPnfjgdy85DXfFCEQBTA9syvs906biuj9kkVL2mjm1E+MEz1HGF/6FMNdeeWyFc3ks2qyXVSl1lVuV54fcUbo88UyQUvoj9p5U1+Y3vV+Ed7z3XN7IkHzHmJjfDaEySBT0upGQTQ2VkTJUxqEqsbJN2oAxDEPd+ltF0ecDDPrWfsnmQPTBeiaE+XUKqPg3wR8Lu8Iy20/9pf6+qjHwvFUWmneRLT6xJghpru8P/MYILo3cq3uvcWb7umHwh9aMBz6D/KNgLifTz0abSb/JrHkPjLhCec4z35qxDe9Ocsubtd4J/X3fRsh7qNYJwLsGoEmvixZCPJ3tDn8g0j7Z2tONQXkRTCRgEP4hI3z6+5MtRWQZ6E+MuhOASpAom7Ql3tFvYWsNAp/KyvXydSob3bHBe3UjnbXCIl+T9z9+GgHfEsyw+B3wuy5LknOjBu5lhn3dREIyJYcVJORwOMFAKm8mRd6ceiRjlykGrppLj26yq+y4IzZJFUEpbRvJ0b/HVE=
package_update: true
package_upgrade: false
packages:
  - "vim"
  - "nginx"
```

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/9060558c-d5e9-4e48-bb6e-918d2d678140)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/e6ae6bd1-eee4-4318-9c95-e34b7dd1d5ba)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/2e8eacb6-48d7-45b8-bc96-75ad6668c521)

------

### Задание 2

1. Напишите локальный модуль vpc, который будет создавать 2 ресурса: **одну** сеть и **одну** подсеть в зоне, объявленной при вызове модуля, например: ```ru-central1-a```.
2. Вы должны передать в модуль переменные с названием сети, zone и v4_cidr_blocks.
3. Модуль должен возвращать в root module с помощью output информацию о yandex_vpc_subnet. Пришлите скриншот информации из terraform console о своем модуле. Пример: > module.vpc_dev  
4. Замените ресурсы yandex_vpc_network и yandex_vpc_subnet созданным модулем. Не забудьте передать необходимые параметры сети из модуля vpc в модуль с виртуальной машиной.
5. Сгенерируйте документацию к модулю с помощью terraform-docs.
 
Пример вызова

```
module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  zone = "ru-central1-a"
  cidr = "10.0.1.0/24"
}
```

## Ответ
- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/7faa6ca8-a13b-4108-b8b6-4458f2c92d1d)
- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/55d06c20-8da7-4493-b9fc-cb10f195bf6a)
```
[Title](src/module_vpc/doc.md)
```
```
[Title](src/doc.md)
```

### Задание 3
1. Выведите список ресурсов в стейте.
2. Полностью удалите из стейта модуль vpc.
3. Полностью удалите из стейта модуль vm.
4. Импортируйте всё обратно. Проверьте terraform plan. Изменений быть не должно.
Приложите список выполненных команд и скриншоты процессы.

## Ответ

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/9c5e3e61-decd-4e85-b4c6-44f055cb32e2)

## Дополнительные задания (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 


### Задание 4*

1. Измените модуль vpc так, чтобы он мог создать подсети во всех зонах доступности, переданных в переменной типа list(object) при вызове модуля.  
  
Пример вызова
```
module "vpc_prod" {
  source       = "./vpc"
  env_name     = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.3.0/24" },
  ]
}

module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
  ]
}
```

Предоставьте код, план выполнения, результат из консоли YC.

### Задание 5*

1. Напишите модуль для создания кластера managed БД Mysql в Yandex Cloud с одним или несколькими(2 по умолчанию) хостами в зависимости от переменной HA=true или HA=false. Используйте ресурс yandex_mdb_mysql_cluster: передайте имя кластера и id сети.
2. Напишите модуль для создания базы данных и пользователя в уже существующем кластере managed БД Mysql. Используйте ресурсы yandex_mdb_mysql_database и yandex_mdb_mysql_user: передайте имя базы данных, имя пользователя и id кластера при вызове модуля.
3. Используя оба модуля, создайте кластер example из одного хоста, а затем добавьте в него БД test и пользователя app. Затем измените переменную и превратите сингл хост в кластер из 2-х серверов.
4. Предоставьте план выполнения и по возможности результат. Сразу же удаляйте созданные ресурсы, так как кластер может стоить очень дорого. Используйте минимальную конфигурацию.

### Задание 6*
1. Используя готовый yandex cloud terraform module и пример его вызова(examples/simple-bucket): https://github.com/terraform-yc-modules/terraform-yc-s3 .
Создайте и не удаляйте для себя s3 бакет размером 1 ГБ(это бесплатно), он пригодится вам в ДЗ к 5 лекции.

### Задание 7*

1. Разверните у себя локально vault, используя docker-compose.yml в проекте.
2. Для входа в web-интерфейс и авторизации terraform в vault используйте токен "education".
3. Создайте новый секрет по пути http://127.0.0.1:8200/ui/vault/secrets/secret/create
Path: example  
secret data key: test 
secret data value: congrats!  
4. Считайте этот секрет с помощью terraform и выведите его в output по примеру:
```
provider "vault" {
 address = "http://<IP_ADDRESS>:<PORT_NUMBER>"
 skip_tls_verify = true
 token = "education"
}
data "vault_generic_secret" "vault_example"{
 path = "secret/example"
}

output "vault_example" {
 value = "${nonsensitive(data.vault_generic_secret.vault_example.data)}"
} 

Можно обратиться не к словарю, а конкретному ключу:
terraform console: >nonsensitive(data.vault_generic_secret.vault_example.data.<имя ключа в секрете>)
```
5. Попробуйте самостоятельно разобраться в документации и записать новый секрет в vault с помощью terraform. 

### Задание 8*
Попробуйте самостоятельно разобраться в документаци и с помощью terraform remote state разделить root модуль на два отдельных root-модуля: создание VPC , создание ВМ . 

### Правила приёма работы

В своём git-репозитории создайте новую ветку terraform-04, закоммитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-04.

В качестве результата прикрепите ссылку на ветку terraform-04 в вашем репозитории.

**Важно.** Удалите все созданные ресурсы.

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 




