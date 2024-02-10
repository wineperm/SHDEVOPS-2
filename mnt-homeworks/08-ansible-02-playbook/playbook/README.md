# Ansible-playbook - установка Clickhouse и Vector

## Устанавливаемое программное обеспечание:

### ClickHouse 
``` Это колоночная аналитическая СУБД , позволяющая выполнять аналитические запросы в режиме реального времени на структурированных больших данных, использует собственный диалект SQL близкий к стандартному. ```

### Vector 
``` Это высокопроизводительный конвейер данных, позволяющий преобразовавать данные из различных источников (файлов, баз данных и т.д.) в требуемый удобночитаемый формат. ```

##  Изменяемые переменные /playbook/group_vars/clickhouse/vars.yml
```
clickhouse_version: "22.3.3.44"
clickhouse_packages:
  - clickhouse-client
  - clickhouse-server
  - clickhouse-common-static

vector_version: "0.35.0"
directory_save: "/home/qwerty/vector"
sample_templates: "mnt-homeworks/08-ansible-02-playbook-SHDEVOPS-2-KLS(wineperm)"
```
## Существующие tags 
``` ansible-playbook -i inventory/prod.yml site.yml --list-tags ```

```
playbook: site.yml

  play #1 (clickhouse): Install Clickhouse      TAGS: []
      TASK TAGS: []

  play #2 (clickhouse): Install Vector  TAGS: [vector]
      TASK TAGS: [vector, vector_install, vector_template]
```
