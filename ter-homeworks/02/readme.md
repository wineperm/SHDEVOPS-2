# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

### Цели задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src).


### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav). 
Этот функционал понадобится к следующей лекции.

## Ответ

- Ознакомился

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
------

### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.  Убедитесь что ваша версия **Terraform** =1.5.Х (версия 1.6.Х может вызывать проблемы с Яндекс провайдером) 

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net).
4. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**.
5. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
6. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.
Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
8. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
- ответы на вопросы.

## Ответ

- Суть ошибки, что код пытается запросить у яндекса конфигурацию платформы (ВМ), которую он не предоставляет.

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/c098af7a-88bb-4abf-8c66-2d4c9946fe40)
- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/90d2f743-0e5d-41a8-9049-53560469c722)

- preemptible = true. 
Прерываемые виртуальные машины — это виртуальные машины, которые могут быть принудительно остановлены в любой момент. Это может произойти в двух случаях:
Если с момента запуска виртуальной машины прошло 24 часа.
Если возникнет нехватка ресурсов для запуска обычной виртуальной машины в той же зоне доступности.
- core_fraction=5 
Выбранный уровень производительности. Этот уровень определяет долю вычислительного времени физических ядер, которую гарантирует vCPU.
- Эти функции позволят снизить затраты при использование облака в обучении.

### Задание 2

1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan. Изменений быть не должно. 

## Ответ

- main.ft
```
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_ubuntu-2004-lts
}

resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_netology-develop-platform-web
  platform_id = var.vm_web_standard-v2
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  
  scheduling_policy {
    preemptible = true
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
```
- variables.ft
```
variable "vm_web_ubuntu-2004-lts" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "image ubuntu-2004-lts"
}

variable "vm_web_netology-develop-platform-web" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "name-platform-vm"
}

variable "vm_web_standard-v2" {
  type        = string
  default     = "standard-v2"
  description = "platform-id"
}

variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "cores"
}

variable "vm_web_memory" { 
  type        = number
  default     = 2
  description = "memory"
}

variable "vm_web_core_fraction" { 
  type        = number
  default     = 5
  description = "fraction"
}
```
- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/a55da25f-54c5-4320-ac93-a345f190eff0)

### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"
3. Примените изменения.

## Ответ

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/49f6d97e-2a97-4687-a55d-d7b25e20b434)

- vms_platform.tf
``` 
variable "vm_db_ubuntu-2004-lts" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "image db ubuntu-2004-lts"
}

variable "vm_db_netology-develop-platform-db" {
  type        = string
  default     = "netology-develop-platform-db"
}

variable "vm_db_standard-v2" {
  type        = string
  default     = "standard-v2"
}

variable "vm_db_cores" {
  type        = number
  default     = 2
  description = "cores"
}

variable "vm_db_memory" { 
  type        = number
  default     = 2
  description = "memory"
}

variable "vm_db_core_fraction" { 
  type        = number
  default     = 20
  description = "fraction"
} 

variable "vm_db_default_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "vm_db_default_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_db_vpc_name" {
  type        = string
  default     = "develop-db"
  description = "VPC network & subnet name"
}

```

### Задание 4

1. Объявите в файле outputs.tf **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.

## Ответ

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/f08ff11f-2bce-460b-b330-c0a81d4b9f30)

### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.

## Ответ

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/309cfdcc-2cd2-4f50-a766-f16218634be0)
- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/c0f675d1-dc54-4f9d-a4f3-594e97af239b)

### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map.  
   ```
   пример из terraform.tfvars:
   vms_resources = {
     web={
       cores=
       memory=
       core_fraction=
       ...
     },
     db= {
       cores=
       memory=
       core_fraction=
       ...
     }
   }
   ```
2. Создайте и используйте отдельную map переменную для блока metadata, она должна быть общая для всех ваших ВМ.
   ```
   пример из terraform.tfvars:
   metadata = {
     serial-port-enable = 1
     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
   }
   ```  
  
3. Найдите и закоментируйте все, более не используемые переменные проекта.
4. Проверьте terraform plan. Изменений быть не должно.

## Ответ
```
variable "metadatas" {
  type = map
  default = {
    serial-port-enable = "1"
    ssh-keys           = "ssh-ed25519 AAAAC3NzaC1lZDI1NT!!!!!!!!!!!1k/j3Q1IKOp75JjS6oPPMg/xsNxImn2M vagrant@server1"
    }
}

variable "vms_resources" {
  type = map(object({
    cores = number
    memory = number
    core_fraction = number
  }))
  default = {
    web = {
      cores = 2
      memory = 2
      core_fraction = 5
    },
    db = {
      cores = 2
      memory = 2
      core_fraction = 20
    }
  }
}
```

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/ba55599c-61ec-43a0-a6ba-06c663c11df1)
------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   
Они помогут глубже разобраться в материале. Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 


------
### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list.
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.
4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

**Примечание**: если не догадаетесь как вычленить слово "admin", погуглите: "terraform get keys of map"

В качестве решения предоставьте необходимые команды и их вывод.

------

## Ответ

- ```> local.test_list[1]```
```"staging"```
выведет второй элемент из списка ``` test_list = ["develop", "staging", "production"]```

- ```> length(["develop", "staging", "production"])```
```3```
длина списка ```test_list = ["develop", "staging", "production"]```

- ```> local.test_map.admin```
```"John"```
- или
- ```> local.test_map["admin"]```
```"John"```
такой командой можно отобразить значение ключа admin из map test_map
```
test_map = {
    admin = "John"
    user  = "Alex"
  }
```
- ```>  "${local.test_map["admin"]} is ${keys(local.test_map)[0]} for ${local.test_list[2]} server based on OS ${local.servers.production.image} with ${local.servers.production["cpu"]} v${keys(local.servers.develop)[0]}, ${local.servers.production["ram"]} ${keys(local.servers.develop)[3]} and ${length(local.servers.production["disks"])} virtual ${keys(local.servers.develop)[1]}"```

"John is admin for production server based on OS ubuntu-20-04 with 10 vcpu, 40 ram and 4 virtual disks"

```
##Этот файл для 7 задания!!
locals {

  test_list = ["develop", "staging", "production"]

  test_map = {
    admin = "John" ###local.test_map["admin"]- John, ###keys(local.test_map)[0] - admin
    user  = "Alex"
  }

  servers = {
    develop = {
      cpu   = 2  ###keys(local.servers.develop)[0] - cpu
      ram   = 4  ###keys(local.servers.develop)[3] - ram
      image = "ubuntu-21-10"
      disks = ["vda", "vdb"] ###keys(local.servers.develop)[1] - disks
    },
    stage = {
      cpu   = 4
      ram   = 8
      image = "ubuntu-20-04"
      disks = ["vda", "vdb"]
    },
    production = {  ###local.test_list[2] - production
      cpu   = 10  ###local.servers.production["cpu"] - 10
      ram   = 40  ###local.servers.production["ram"] - 40
      image = "ubuntu-20-04"  ###local.servers.production.image - ubuntu-20-04
      disks = ["vda", "vdb", "vdc", "vdd"]  ## length(local.servers.production["disks"]) - 4 (длина списка)
    }
  }
}
```

### Задание 8*
1. Напишите и проверьте переменную test и полное описание ее type в соответствии со значением из terraform.tfvars:
```
test = [
  {
    "dev1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
      "10.0.1.7",
    ]
  },
  {
    "dev2" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
      "10.0.2.29",
    ]
  },
  {
    "prod1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
      "10.0.1.30",
    ]
  },
]
```
2. Напишите выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117"

## Ответ

- var.test[0]["dev1"][0]

------

------

### Задание 9*

Используя инструкцию https://cloud.yandex.ru/ru/docs/vpc/operations/create-nat-gateway#tf_1, настройте для ваших ВМ nat_gateway. Для проверки уберите внешний IP адрес (nat=false) у ваших ВМ и проверьте доступ в интернет с ВМ, подключившись к ней через serial console. Для подключения предварительно через ssh измените пароль пользователя: ```sudo passwd ubuntu```

### Правила приёма работыДля подключения предварительно через ssh измените пароль пользователя: sudo passwd ubuntu
В качестве результата прикрепите ссылку на MD файл с описанием выполненой работы в вашем репозитории. Так же в репозитории должен присутсвовать ваш финальный код проекта.

**Важно. Удалите все созданные ресурсы**.


### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 
