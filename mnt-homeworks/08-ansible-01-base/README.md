# Домашнее задание к занятию 1 «Введение в Ansible»

## Подготовка к выполнению

1. Установите Ansible версии 2.10 или выше.
2. Создайте свой публичный репозиторий на GitHub с произвольным именем.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.
2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.
13. Предоставьте скриншоты результатов запуска команд.

## Ответ

-1. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/59a93a56-b24b-41a2-80ee-78fce1bd529b) 

``` some_fact` - "msg": 12 ```

-2. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/5fac32cb-0d35-43b6-87c1-25653b15875b)

-3. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/2b4b5da7-322a-4680-8ca1-9adf3e3a8bb4)

-4. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/03511154-07e4-4b02-b2f1-0c2f38a03744)

``` some_fact` - [centos7] => "msg": "el" ```
``` some_fact` - [ubuntu] => "msg": "deb" ```

-5-6. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/3716e9da-97a1-4a9c-b857-462848c7b28c)

-7-8. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/3eaf0754-c81f-471a-b183-ff31c979e44c)
-7-8v2. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/41028864-b9e0-4b44-a7a0-e361271045f6)

-9. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/9382d301-4d7f-49b1-b550-a8b40c1c6771)

-10-11. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/d10b02da-9cdb-4015-922b-d7979d08fd99)

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот вариант](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в ваш личный репозиторий.

## Ответ

-1. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/5e4d7442-51d7-4662-af09-2e52b5204f93)

-2. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/efacb85c-0000-478f-a375-3ffa3ca70cec)

-3. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/585e8724-bdac-4f2c-a32f-7fa1e4b640ec)

-4. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/dbaf5f7d-f2a5-4c96-b8f8-b821d66bbe06)

-5. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/ecdb3880-f0db-46ad-ab4c-afd79ff6cea4)

- bash.sh
```
#!/bin/bash
echo "=====>docker container start<====="
docker start c11d22302729 b6a2dd7470d0 31d5207907e2

echo "=====>ansible-playbook run<====="
ansible-playbook -i inventory/prod.yml site.yml --vault-password-file pass.txt

echo "=====>docker container stop<====="
docker stop c11d22302729 b6a2dd7470d0 31d5207907e2
```

- pass.txt
```
netology
```






 



---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
