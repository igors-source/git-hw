# Домашнее задание к занятию «Индексы»  «Шадрин Игорь» 


### Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.

### Решение 1 

```sql
SELECT SUM(index_length)/(SUM(data_length)/100)
FROM INFORMATION_SCHEMA.TABLES
```

![Alt text](img/01.jpg)

### Задание 2

Выполните explain analyze следующего запроса:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
- перечислите узкие места;
- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.

### Решение 2
Результат выполнения запроса:
```sql
-> Limit: 200 row(s)  (cost=0..0 rows=0) (actual time=463031..463051 rows=200 loops=1)
    -> Table scan on <temporary>  (cost=2.5..2.5 rows=0) (actual time=463031..463043 rows=200 loops=1)
        -> Temporary table with deduplication  (cost=0..0 rows=0) (actual time=463031..463031 rows=391 loops=1)
            -> Window aggregate with buffering: sum(payment.amount) OVER (PARTITION BY c.customer_id,f.title )   (actual time=393451..447239 rows=642000 loops=1)
                -> Sort: c.customer_id, f.title  (actual time=393451..408370 rows=642000 loops=1)
                    -> Stream results  (cost=22.6e+6 rows=16.5e+6) (actual time=49.6..377993 rows=642000 loops=1)
                        -> Nested loop inner join  (cost=22.6e+6 rows=16.5e+6) (actual time=49.5..348961 rows=642000 loops=1)
                            -> Nested loop inner join  (cost=20.9e+6 rows=16.5e+6) (actual time=49.1..239465 rows=642000 loops=1)
                                -> Nested loop inner join  (cost=19.3e+6 rows=16.5e+6) (actual time=48.9..129789 rows=642000 loops=1)
                                    -> Inner hash join (no condition)  (cost=1.65e+6 rows=16.5e+6) (actual time=48.7..14606 rows=634000 loops=1)
                                        -> Filter: (cast(p.payment_date as date) = '2005-07-30')  (cost=1.72 rows=16500) (actual time=1.87..716 rows=634 loops=1)
                                            -> Table scan on p  (cost=1.72 rows=16500) (actual time=0.0858..350 rows=16044 loops=1)
                                        -> Hash
                                            -> Covering index scan on f using idx_title  (cost=112 rows=1000) (actual time=0.0983..23.8 rows=1000 loops=1)
                                    -> Covering index lookup on r using rental_date (rental_date=p.payment_date)  (cost=0.969 rows=1) (actual time=0.0484..0.0734 rows=1.01 loops=634000)
                                -> Single-row index lookup on c using PRIMARY (customer_id=r.customer_id)  (cost=250e-6 rows=1) (actual time=0.0435..0.0645 rows=1 loops=642000)
                            -> Single-row covering index lookup on i using PRIMARY (inventory_id=r.inventory_id)  (cost=250e-6 rows=1) (actual time=0.0433..0.0644 rows=1 loops=642000)

```
1) Опетаторы **distinct** (удаление дубликатов) с операторами **over(partition by** (некий аналогк GROUP BY, на сколько я понял, используется для разделения строк по группам и разделам), показались очень ресурсоемкими, так же многочисленные and в операторе where не имеют смысла и добавление такого количества таблиц в оператор from не нужно, лучше использовать join. В итоге аналогичный результат был получен при выполнении следующего кода:

2) Поскольку тема была про индексы, добавил индексирование по дате, так же отработал по замечаниям: 
```sql
CREATE INDEX date_pay ON payment(payment_date);
```


```sql
EXPLAIN ANALYZE      
select concat(c.last_name, ' ', c.first_name) as CST,sum(p.amount)
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id 
JOIN rental r ON r.rental_id = p.rental_id 
JOIN inventory i ON i.inventory_id = r.inventory_id 
WHERE p.payment_date >= '2005-07-30' and p.payment_date < DATE_ADD('2005-07-30', INTERVAL 1 DAY)
GROUP BY c.customer_id


-> Limit: 200 row(s)  (actual time=445..469 rows=200 loops=1)
    -> Table scan on <temporary>  (actual time=445..459 rows=200 loops=1)
        -> Aggregate using temporary table  (actual time=445..445 rows=391 loops=1)
            -> Nested loop inner join  (cost=1396 rows=634) (actual time=0.625..427 rows=634 loops=1)
                -> Nested loop inner join  (cost=1175 rows=634) (actual time=0.468..297 rows=634 loops=1)
                    -> Nested loop inner join  (cost=507 rows=634) (actual time=0.31..174 rows=634 loops=1)
                        -> Filter: (p.rental_id is not null)  (cost=286 rows=634) (actual time=0.145..50.3 rows=634 loops=1)
                            -> Index range scan on p using date_pay over ('2005-07-30 00:00:00' <= payment_date < '2005-07-31 00:00:00'), with index condition: ((p.payment_date >= TIMESTAMP'2005-07-30 00:00:00') and (p.payment_date < <cache>(('2005-07-30' + interval 1 day))))  (cost=286 rows=634) (actual time=0.0687..19 rows=634 loops=1)
                        -> Single-row index lookup on c using PRIMARY (customer_id=p.customer_id)  (cost=0.25 rows=1) (actual time=0.0555..0.0796 rows=1 loops=634)
                    -> Single-row index lookup on r using PRIMARY (rental_id=p.rental_id)  (cost=0.952 rows=1) (actual time=0.0535..0.0765 rows=1 loops=634)
                -> Single-row covering index lookup on i using PRIMARY (inventory_id=r.inventory_id)  (cost=0.25 rows=1) (actual time=0.0557..0.0796 rows=1 loops=634)

```
Видно использование добавленного индекса

![Alt text](img/02.jpg)