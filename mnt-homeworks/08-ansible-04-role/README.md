# Домашнее задание к занятию 4 «Работа с roles»

## Подготовка к выполнению

1. * Необязательно. Познакомьтесь с [LightHouse](https://youtu.be/ymlrNlaHzIY?t=929).
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю на GitHub.

## Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. 

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. 

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.13"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачайте себе эту роль.
3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры. Пример качественной документации ansible role [по ссылке](https://github.com/cloudalchemy/ansible-prometheus).
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

## Ответ

- 1-2. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/f56429dc-825a-4d2d-9c6b-c86ac0537591)

- 3 . ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/753f7d84-accc-4f77-beb7-5c8c31e31de7)

- 8 . 
```
git tag -a 0.0.1 -m "lighthouse-role" 
      
git push --follow-tags
      
git tag -a 0.0.1 -m "vector-role" 
      
git push --follow-tags 
```

- [LightHouse-role](git@github.com:wineperm/lighthouse-role.git)

- [Vector-role](git@github.com:wineperm/vector-role.git)

- [playbook.yml](https://github.com/wineperm/SHDEVOPS-2/blob/main/mnt-homeworks/08-ansible-04-role/playbook/playbook.yml)
```
---
- name: Install clickhouse
  hosts: clickhouse-01
  roles: 
    - clickhouse

- name: Install lighthouse
  hosts: lighthouse-01
  roles: 
    - lighthouse-role

- name: Install vector
  hosts: vector-01
  roles:
    - vector-role
```

- [requirements.yml](https://github.com/wineperm/SHDEVOPS-2/blob/main/mnt-homeworks/08-ansible-04-role/playbook/requirements.yml)
```
---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.13"
       name: clickhouse

     - src: git@github.com:wineperm/lighthouse-role.git
       scm: git
       version: "0.0.1"
       name: lighthouse-role

     - src: git@github.com:wineperm/vector-role.git
       scm: git
       version: "0.0.1"
       name: vector-role
```

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
