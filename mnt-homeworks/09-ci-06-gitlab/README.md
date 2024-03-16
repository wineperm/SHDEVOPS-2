# Домашнее задание к занятию 12 «GitLab»

## Подготовка к выполнению

1. Или подготовьте к работе Managed GitLab от yandex cloud [по инструкции](https://cloud.yandex.ru/docs/managed-gitlab/operations/instance/instance-create) .
   Или создайте виртуальную машину из публичного образа [по инструкции](https://cloud.yandex.ru/marketplace/products/yc/gitlab) .
2. Создайте виртуальную машину и установите на нее gitlab runner, подключите к вашему серверу gitlab [по инструкции](https://docs.gitlab.com/runner/install/linux-repository.html) .

3. (\* Необязательное задание повышенной сложности. ) Если вы уже знакомы с k8s попробуйте выполнить задание, запустив gitlab server и gitlab runner в k8s [по инструкции](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/gitlab-containers).

4. Создайте свой новый проект.
5. Создайте новый репозиторий в GitLab, наполните его [файлами](./repository).
6. Проект должен быть публичным, остальные настройки по желанию.

## Ответ

-1-2. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/818de8b9-5b9f-4a18-9408-4563fe8afe72)

-2. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/66674504-3791-4528-b64c-8efef0852e05)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/4accc16c-b4fe-4d3e-ad89-f4691e241050)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/43516824-1e85-4bca-b9a8-a37bb9e245f0)

## Основная часть

### DevOps

В репозитории содержится код проекта на Python. Проект — RESTful API сервис. Ваша задача — автоматизировать сборку образа с выполнением python-скрипта:

1. Образ собирается на основе [centos:7](https://hub.docker.com/_/centos?tab=tags&page=1&ordering=last_updated).
2. Python версии не ниже 3.7.
3. Установлены зависимости: `flask` `flask-jsonpify` `flask-restful`.
4. Создана директория `/python_api`.
5. Скрипт из репозитория размещён в /python_api.
6. Точка вызова: запуск скрипта.
7. При комите в любую ветку должен собираться docker image с форматом имени hello:gitlab-$CI_COMMIT_SHORT_SHA . Образ должен быть выложен в Gitlab registry или yandex registry.

## Ответ

Dockerfile

```
FROM centos:7

RUN yum update -y && yum install -y python3 python3-pip
RUN pip3 install flask flask-jsonpify flask-restful

ADD python-api.py /python-api/
ENTRYPOINT [ "python3", "/python-api/python-api.py" ]

```

.gitlab-ci.yml

```
image: docker:cli
services:
  - docker:dind
stages:
  - build
  - deploy
build:
  stage: build
  script:
    - docker build -t $CI_REGISTRY/$CI_PROJECT_PATH/hello:gitlab-$CI_COMMIT_SHORT_SHA .
  except:
    - main
build&deploy:
  stage: deploy
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY/$CI_PROJECT_PATH/hello:gitlab-$CI_COMMIT_SHORT_SHA .
    - docker push $CI_REGISTRY/$CI_PROJECT_PATH/hello:gitlab-$CI_COMMIT_SHORT_SHA
  only:
    - main
```

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/edb3d39a-8052-4578-859e-f3b718c6d889)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/d296279b-ade1-4977-a2b1-a1d308ef64bb)

### Product Owner

Вашему проекту нужна бизнесовая доработка: нужно поменять JSON ответа на вызов метода GET `/rest/api/get_info`, необходимо создать Issue в котором указать:

1. Какой метод необходимо исправить.
2. Текст с `{ "message": "Already started" }` на `{ "message": "Running"}`.
3. Issue поставить label: feature.

## Ответ

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/87a3da54-13a7-4a3e-9856-72ae3c48d45c)

### Developer

Пришёл новый Issue на доработку, вам нужно:

1. Создать отдельную ветку, связанную с этим Issue.
2. Внести изменения по тексту из задания.
3. Подготовить Merge Request, влить необходимые изменения в `master`, проверить, что сборка прошла успешно.

## Ответ

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/6dbf77bc-42be-44d3-a562-83f4694fd595)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/88c49b19-2acf-4e34-940c-5bc330d836ba)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/b03a575f-ca99-4a9f-834e-1946b54940fc)

### Tester

Разработчики выполнили новый Issue, необходимо проверить валидность изменений:

1. Поднять докер-контейнер с образом `python-api:latest` и проверить возврат метода на корректность.
2. Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый.

## Ответ

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/25cdbacf-fff7-4069-950a-ba1dfe6c8da7)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/c3aa3975-e7d9-4724-b949-9ccc18688c56)

[gitlab.com]https://gitlab.com/permwine/09-ci-06-gitlab

[.gitlab-ci.yml]

[Dockerfile]

[log pipelines]

## Итог

В качестве ответа пришлите подробные скриншоты по каждому пункту задания:

- файл gitlab-ci.yml;
- Dockerfile;
- лог успешного выполнения пайплайна;
- решённый Issue.

### Важно

После выполнения задания выключите и удалите все задействованные ресурсы в Yandex Cloud.
