# Домашнее задание к занятию 10 «Jenkins»

## Подготовка к выполнению

1. Создать два VM: для jenkins-master и jenkins-agent.
2. Установить Jenkins при помощи playbook.
3. Запустить и проверить работоспособность.
4. Сделать первоначальную настройку.

## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.
4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.
5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).
6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.
8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.
9. Сопроводите процесс настройки скриншотами для каждого пункта задания!!

## Ответ

-1. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/8ef78784-90e8-4c29-bd3c-2ef13f3a9fb0)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/75272786-af61-4267-9cf6-b17881a51923)

-2. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/a9263c0f-df9d-41a9-96c7-cebbf3e9301c)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/63987598-6144-4e0d-b7b9-e1d489b1b493)

```
pipeline {
    agent {
  label 'ansible'
    }
    stages {
        stage('Git Clone') {
            steps {
                dir('/opt/jenkins_agent/workspace/Declarative Pipeline Job/vector-role') {
                git 'https://github.com/wineperm/vector-role.git'
                }
            }
        }
        stage('Install Another') {
            steps {
                sh "pip3 install molecule==3.5.2 molecule-docker"
                sh "pip3 install --upgrade requests==2.26.0"
                sh "ansible-galaxy collection install community.docker"
            }
        }
        stage('Run Molecule Test') {
            steps {
                dir('/opt/jenkins_agent/workspace/Declarative Pipeline Job/vector-role') {
                sh 'pwd'
                sh 'ls -lah'
                sh 'molecule test'
                }
            }
        }
    }
}
```

-3. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/f2e55bad-fc8c-4322-b050-dfbf998ebc3d)

-4. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/ad305f4c-a0fc-42dc-acde-f4609c8dacac)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/f5ae3b67-7247-4811-ab8a-a09c68742050)

-6. ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/fa1d6f18-749c-439e-a12f-247b54ba6e25)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/7510ad70-c428-4239-a842-9de845622236)
- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/cf370b52-3123-45b5-8aa0-30cbc013ef3c)

-7. [ScriptedJenkinsfile]mnt-homeworks/09-ci-04-jenkins/ScriptedJenkinsfile

-8. [Vector-role](https://github.com/wineperm/vector-role)
[Declarative Pipeline]mnt-homeworks/09-ci-04-jenkins/DeclarativePipeline
[Scripted Pipeline]mnt-homeworks/09-ci-04-jenkins/ScriptedJenkinsfile

## Необязательная часть

1. Создать скрипт на groovy, который будет собирать все Job, завершившиеся хотя бы раз неуспешно. Добавить скрипт в репозиторий с решением и названием `AllJobFailure.groovy`.
2. Создать Scripted Pipeline так, чтобы он мог сначала запустить через Yandex Cloud CLI необходимое количество инстансов, прописать их в инвентори плейбука и после этого запускать плейбук. Мы должны при нажатии кнопки получить готовую к использованию систему.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
