# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule и его драйвера: `pip3 install "molecule molecule_docker molecule_podman`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s ubuntu_xenial` (или с любым другим сценарием, не имеет значения) внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками или не отработать вовсе, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу И из чего может состоять сценарий тестирования.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (oraclelinux:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 
5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

## Ответ

-1. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/ffeef471-731e-4d5b-ac56-6bed62d048d5)

-2. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/2de10846-0f6f-4da6-bfe3-e5cfc23fc17e)

-3. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/dce43a18-af16-4de1-a809-8b47ca912b90)
-3-1. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/99a7b939-3b82-4ed0-a82e-af6fd97957cd)

-4. verify.yml
```
- name: Verify
  hosts: all
  gather_facts: false
  vars:
    vector_config_path: "{{ vector_conf_dir }}/vector.toml"
  tasks:
    - name: Validation Vector configuration
      ansible.builtin.command: "vector validate --no-environment --config-toml {{ vector_config_path }}"
      changed_when: false
      register: vector_validate
    - name: Get Vector version
      ansible.builtin.command: "vector -V"
      register: vector_version
    - name: Assert Vector instalation
      ansible.builtin.assert:
        that: "'{{ vector_version.rc }}' == '0'"
    - name: Get Vector validation
      ansible.builtin.command: "vector validate"
      register: vector_check
    - name: Assert Vector validation
      ansible.builtin.assert:
        that: "'{{ vector_check.rc }}' == '0'"
```
- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/c2c8161b-9a2a-4f21-b968-ac35f0ff6060)

-5. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/20f11df5-072b-439b-96b0-f6700b5e23ae)

[vector-role/tag/0.1.3](https://github.com/wineperm/vector-role/releases/tag/v0.1.3)




### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Ответ

-1-2. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/fd2b03d2-0a78-46c3-a9bf-46925c232a89)

-3. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/d2fd2e7e-a068-4d6e-9be5-c7d261156925)

-4-5. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/5b281332-076d-4b56-b8b6-83367ceca2e1)

-6. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/c6d308cc-31f7-4782-8c49-e37c47e60342)

[vector-role/tag/0.1.4](https://github.com/wineperm/vector-role/releases/tag/v0.1.4)

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.
