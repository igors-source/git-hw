# Домашнее задание к занятию 4. «PostgreSQL» «Шадрин Игорь»

## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL, используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД,
- подключения к БД,
- вывода списка таблиц,
- вывода описания содержимого таблиц,
- выхода из psql.

## Решение 1

docker-compose файл:

```yml
motorher@motorher:~$ cd ./postgr/
motorher@motorher:~/postgr$ cat ./docker-compose.yml
version: "3.9"
services:
  postgres:
    image: postgres:13
    environment:
      POSTGRES_DB: "test_db"
      POSTGRES_USER: "test-admin-user"
      POSTGRES_PASSWORD: "test-admin-passwd"
    ports:
      - "5432:5432"
    volumes:
      - /home/motorher/postgr/data:/var/lib/pgsql/13/data

```
- вывод списка БД
```sql
\l
```
- подключения к БД
```sql
\c #имя бд
```
- вывода списка таблиц
```sql
\d
\dt
```
- вывода описания содержимого таблиц
```sql
\dS
\dS+
\dtS
```
- выхода из psql
```sql
\q
```

## Задача 2

Используя `psql`, создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления, и полученный результат.

## Решение 2

![alt text](img/02.jpg)

```sql
ANALYZE public.orders;
SELECT attname, avg_width FROM pg_stats WHERE tablename = 'orders' ORDER BY avg_width DESC LIMIT 1;
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили
провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.

Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?

## Решение 3

```sql
CREATE TABLE orders_buffer (LIKE orders) PARTITION BY RANGE (price);
CREATE TABLE orders_2 PARTITION OF orders_new FOR VALUES FROM (0) TO (500);
CREATE TABLE orders_1 PARTITION OF orders_new FOR VALUES FROM (500) TO (65535);
INSERT INTO orders_buffer SELECT * FROM orders;
DROP TABLE orders;
ALTER TABLE orders_buffer RENAME TO orders;
```

Чтобы не пользоваться ручным разбиением, надо было изначально назначить наследованную таблицу (таблицы) командой INHERITS и настроить диапазон значений CHECK, чтобы данные с определенным id (индексы не наследуются) попадали в определенную таблицу.
```sql
CREATE TABLE orders_2 (CHECK (price >= 499)) INHERITS (orders);
```
Вариант решения с ценой.

## Задача 4

Используя утилиту `pg_dump`, создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

## Решение 5

- Открыть бекап файл текстовым редактором 
- Редактировать строку создания таблицы orders
```sql
title character varying(80) UNIQUE NOT NULL
```
добавив туда значение UNIQUE