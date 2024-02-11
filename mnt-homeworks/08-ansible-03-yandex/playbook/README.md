# Ansible-playbook - установка Clickhouse - Vector - LightHouse

## Устанавливаемое программное обеспечение:

### [ClickHouse](https://clickhouse.com/) 
```Это колоночная аналитическая СУБД , позволяющая выполнять аналитические запросы в режиме реального времени на структурированных больших данных, использует собственный диалект SQL близкий к стандартному.```

### [Vector](https://vector.dev/)
```Это высокопроизводительный конвейер данных, позволяющий преобразовывать данные из различных источников (файлов, баз данных и т.д.) в требуемый удобочитаемый формат.```

### [LightHouse](https://github.com/VKCOM/lighthouse)
```LightHouse - это упрощенный графический интерфейс для ClickHouse.```

##  Изменяемые переменные /playbook/group_vars/clickhouse/vars.yml
```
vector_version: vector-0.21.1-x86_64-unknown-linux-musl
clickhouse_version: "22.3.3.44"
clickhouse_packages:
  - clickhouse-client
  - clickhouse-server
  - clickhouse-common-static
```
##  Изменяемые переменные /playbook/group_vars/lighthouse/lighthouse.yml
```
lighthouse_vcs: https://github.com/VKCOM/lighthouse.git
lighthouse_location_dir: /home/qwerty/lighthouse
lighthouse_access_log_name: lighthouse_access
nginx_user_name: root
```
##  Изменяемые переменные /playbook/group_vars/vector/vector.yml
```
vector_url: https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-1.x86_64.rpm
vector_version: 0.21.1
nginx_user_name: root
vector_config:
  sources:
      our_log:
        ignore_older_secs: 600
        include:
          - /var/log/nginx/access.log
        read_from: beginning
        type: file
  sinks:
    to_clickhouse:
      type: clickhouse
      inputs:
        - our_log
      database: logs
      endpoint: http://{{ hostvars['clickhouse-01'].ansible_default_ipv4.address }}:8123
      table: access_logs
      compression: gzip
      healthcheck: false
      skip_unknown_fields: true
```


## Существующие tags 
``` ansible-playbook -i inventory/prod.yml site.yml --list-tags ```

```
playbook: site.yml

  play #1 (lighthouse:vector): install nginx    TAGS: []
      TASK TAGS: [config_nginx.j2, nginx install, nginx install repository]

  play #2 (lighthouse): lighthouse install      TAGS: []
      TASK TAGS: [config_lighthouse.j2, lighthouse clone git, lighthouse install git]

  play #3 (clickhouse): Install Clickhouse      TAGS: []
      TASK TAGS: []

  play #4 (vector): install nginx-vector        TAGS: []
      TASK TAGS: []

  play #5 (vector): install vector      TAGS: []
      TASK TAGS: [config_vector.j2, vector.yml.j2, vector_install, vector_systemd]
```

