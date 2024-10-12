# Домашнее задание к занятию «Микросервисы: принципы» "Шадрин Игорь"

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

## Задача 1: API Gateway 

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- маршрутизация запросов к нужному сервису на основе конфигурации,
- возможность проверки аутентификационной информации в запросах,
- обеспечение терминации HTTPS.

Обоснуйте свой выбор.

## Решение 1
| Gateway API                                                   | Kong                   | Tyk          | KrakenD                  | Apigee                              | AWS Gateway        | Azure Gateway      | Express Gateway |
|---------------------------------------------------------------|------------------------|--------------|--------------------------|-------------------------------------|--------------------|--------------------|-----------------|
| Сложность развертывания                                       | Single node            | Single node  | Low, single binary       | Many nodes with different roles     | Cloud vendor PaaS  | Cloud vendor PaaS  | Flexible        |
| Хранилище данных                                              | Cassandra or Postgres  | Redis        | None                     | Cassandra, Zookeeper, and Postgres  | Cloud vendor PaaS  | Cloud vendor PaaS  | Redis           |
| Open Source                                                   | Yes, Apache 2.0        | Yes, MPL     | Yes, Apache 2.0          | No                                  | No                 | No                 | Yes, Apache 2.0 |
| Базируется на                                                 | NGINX/Lua              | GoLang       | GoLang                   | Java                                | Not open           | Not open           | Node.js Express |
| Возможность проверки аутентификационной информации в запросах | Yes                    | Yes          | Yes                      | Yes                                 | Yes                | Yes                | Yes             |
| Ограничение скорости                                          | Yes                    | Yes          | Yes                      | Yes                                 | Yes                | Yes                | Yes             |
| Терминация данных                                             | HTTP                   | HTTP         | Extensive, customizable  | Yes                                 | No                 | No                 | No              |


API Gateway — это служба для управления запросами к API веб-сервисов и приложений. Шлюз служит посредником между пользователем и онлайн-сервисами.

Выбор конкретного шлюза зависит от предпочтений команды разработки и выбора экосистемы облачных услуг, в текущей ситуации, я бы отдал предпочтение Open source разработчику API, например, Kong для избежания проблем с поддержкой, так же он базируется на понятной связке nginx + postgres.

## Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- поддержка кластеризации для обеспечения надёжности,
- хранение сообщений на диске в процессе доставки,
- высокая скорость работы,
- поддержка различных форматов сообщений,
- разделение прав доступа к различным потокам сообщений,
- простота эксплуатации.

Обоснуйте свой выбор.

## Решение 2

|                                                                   |   RabbitMQ              |   ActiveMQ                                               |   Qpid C++                                               |   SwiftMQ                                 |   Artemis                                                | Kafka                                                |
|-------------------------------------------------------------------|-------------------------|----------------------------------------------------------|----------------------------------------------------------|-------------------------------------------|----------------------------------------------------------|------------------------------------------------------|
|   Подписка на сообщения                                           |   +                     |   +                                                      |   +                                                      |   +                                       |   +                                                      |   +                                                  |
|   Однонаправленная, широковещательная, групповая передача данных  |   Реализованы все типы  |   Реализованы однонаправленный и широковещательный типы  |   Реализованы однонаправленный и широковещательный типы  |   Реализован только однонаправленный тип  |   Реализованы однонаправленный и широковещательный типы  | Высокомасштабируемые распределенные системы рассылки |
|   Упорядоченная доставка сообщений                                |   +                     |   +                                                      |   +                                                      |   -                                       |   +                                                      |   +                                                  |
|   Гарантированная доставка сообщений                              |   +                     |   +                                                      |   +                                                      |   +                                       |   +                                                      |   +                                                  |
|   Кластеризация                                                   |   +                     |   +                                                      |   +                                                      |   +                                       |   +                                                      |   +                                                  |
|   Восстановление каналов после потери связи                       |   +                     |   +                                                      |   +                                                      |   +                                       |   +                                                      |   +                                                  |
|   Масштабируемость                                                |   +                     |   +                                                      |   +                                                      |   +                                       |   +                                                      |   +                                                  |
|   Контроль доступа                                                |   +                     |   +                                                      |   +                                                      |   +                                       |   +                                                      |   +                                                  |
|   SSL/TLS                                                         |   +                     |   +                                                      |   +                                                      |   +                                       |   +                                                      |   +                                                  |
|   Открытый код                                                    |   +                     |   +                                                      |   +                                                      |   -                                       |   +                                                      |   +                                                  |

Под заданные параметры подходит RabbitMQ. Помимо соответствия заданным параметрам, он обладает гибкой маршрутизацией и высокой отказоустойчивостью. 
Так же возможно использовать Kafka, из преимуществ - хранение данных после доставки, большое комьюнити.