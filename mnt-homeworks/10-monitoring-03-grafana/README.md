# Домашнее задание к занятию 14 «Средство визуализации Grafana»

## Задание повышенной сложности

**При решении задания 1** не используйте директорию [help](./help) для сборки проекта. Самостоятельно разверните grafana, где в роли источника данных будет выступать prometheus, а сборщиком данных будет node-exporter:

- grafana;
- prometheus-server;
- prometheus node-exporter.

За дополнительными материалами можете обратиться в официальную документацию grafana и prometheus.

В решении к домашнему заданию также приведите все конфигурации, скрипты, манифесты, которые вы
использовали в процессе решения задания.

**При решении задания 3** вы должны самостоятельно завести удобный для вас канал нотификации, например, Telegram или email, и отправить туда тестовые события.

В решении приведите скриншоты тестовых событий из каналов нотификаций.

## Обязательные задания

### Задание 1

1. Используя директорию [help](./help) внутри этого домашнего задания, запустите связку prometheus-grafana.
1. Зайдите в веб-интерфейс grafana, используя авторизационные данные, указанные в манифесте docker-compose.
1. Подключите поднятый вами prometheus, как источник данных.
1. Решение домашнего задания — скриншот веб-интерфейса grafana со списком подключенных Datasource.

## Ответ

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/d44aebae-fb4d-408d-be58-8f73f2e06cc4)

## Задание 2

Изучите самостоятельно ресурсы:

1. [PromQL tutorial for beginners and humans](https://valyala.medium.com/promql-tutorial-for-beginners-9ab455142085).
1. [Understanding Machine CPU usage](https://www.robustperception.io/understanding-machine-cpu-usage).
1. [Introduction to PromQL, the Prometheus query language](https://grafana.com/blog/2020/02/04/introduction-to-promql-the-prometheus-query-language/).

Создайте Dashboard и в ней создайте Panels:

- утилизация CPU для nodeexporter (в процентах, 100-idle);
- CPULA 1/5/15;
- количество свободной оперативной памяти;
- количество места на файловой системе.

Для решения этого задания приведите promql-запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

## Ответ

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/9078e246-e63f-4a28-9225-8cac617ba2e0)

```
100 - (avg by (instance)(irate(node_cpu_seconds_total{job="nodeexporter",mode="idle"}[5m])) * 100)
```

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/7936a64e-233c-4e52-8c9f-f62911c061d9)

```
node_load1{instance="nodeexporter:9100", job="nodeexporter"}
node_load5{instance="nodeexporter:9100", job="nodeexporter"}
node_load15{instance="nodeexporter:9100", job="nodeexporter"}
```

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/869b3867-5cad-432f-ac48-bc2f3b4f226a)

```
node_memory_MemAvailable_bytes{instance="nodeexporter:9100"}
```

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/d831dbdd-eebf-4b66-b65b-0995aefab3e4)

```
node_filesystem_avail_bytes{device="/dev/sda2", fstype="ext4", instance="nodeexporter:9100", job="nodeexporter", mountpoint="/"}
```

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/e63b9576-301d-4b1d-9254-348dfb3fe3ac)

## Задание 3

1. Создайте для каждой Dashboard подходящее правило alert — можно обратиться к первой лекции в блоке «Мониторинг».
1. В качестве решения задания приведите скриншот вашей итоговой Dashboard.

## Ответ

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/f849c0f4-9fbf-4b26-9ebf-eae2168919ee)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/f2a8e627-5aad-478d-8812-dc94cb1d3f5c)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/111e404b-232b-4466-83c2-55907a1cf498)

- ![Alt text](https://github.com/wineperm/SHDEVOPS-2/assets/15356046/9773839d-522f-4593-9e36-f4ad079d5d6c)

## Задание 4

1. Сохраните ваш Dashboard.Для этого перейдите в настройки Dashboard, выберите в боковом меню «JSON MODEL». Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
1. В качестве решения задания приведите листинг этого файла.

[model.json](https://github.com/wineperm/SHDEVOPS-2/blob/main/mnt-homeworks/10-monitoring-03-grafana/model.json)

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
