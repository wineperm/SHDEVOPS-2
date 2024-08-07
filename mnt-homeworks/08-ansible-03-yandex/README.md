# Домашнее задание к занятию 3 «Использование Ansible»

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.
2. Репозиторий находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Ответ

-1. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/94078586-b42c-477f-b0fa-148174aebe42)

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
4. Подготовьте свой inventory-файл `prod.yml`.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

## Ответ 

-5. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/7f6838fa-c44c-4b83-b0ec-f6d189138dfe)

-6. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/dfa0b1ac-7f18-48e0-9985-7c4799d8bfdc)

-7. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/7ea57061-d12d-47f8-a1f7-1a310858f4b1)

-8. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/652f11ac-bcf9-4457-9733-3ed0a6cb5d10)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/67b26850-8230-463d-b809-104a09ef4572) 

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/73a09811-db9f-4ea1-b3c1-f5f42f79a2af)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/623013cc-168d-4684-896b-c17f43f255e7)

[README.md](https://github.com/wineperm/SHDEVOPS-2/blob/29cdfa8919132d5b5b74bb3647baf72b0592c365/mnt-homeworks/08-ansible-03-yandex/playbook/README.md)

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
