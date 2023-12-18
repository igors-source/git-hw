# Домашнее задание к занятию «SQL. Часть 2» «Шадрин Игорь»


### Задание 1

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию: 
- фамилия и имя сотрудника из этого магазина;
- город нахождения магазина;
- количество пользователей, закреплённых в этом магазине.


### Решение 1
```sql
SELECT s.store_id, CONCAT (e.first_name,' ', e.last_name) as F_L_NAME , d.city, COUNT(c.store_id) as customers
FROM store s
JOIN customer c ON c.store_id = s.store_id
JOIN address a ON a.address_id = s.address_id 
JOIN staff e ON e.staff_id = s.store_id 
JOIN city d ON d.city_id = a.city_id 
GROUP BY s.store_id
HAVING COUNT(c.store_id) > 300;
```

![Alt text](img/01.jpg)


### Задание 2

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.

### Решение 2
```sql
SELECT  COUNT(`length`)  
FROM film
WHERE length  > ( SELECT AVG(length) FROM film)

```
![Alt text](img/02.jpg)

### Задание 3

Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.

### Решение 3
```sql
SELECT SUM(p.amount), DATE_FORMAT(r.rental_date, "%Y %m") as YM , COUNT(1)
FROM payment p
JOIN rental r ON r.rental_id = p.rental_id 
GROUP BY YM 
ORDER BY  SUM(p.amount) DESC 
LIMIT 1

```
![Alt text](img/03.jpg)


### Задание 4*

Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия». Если количество продаж превышает 8000, то значение в колонке будет «Да», иначе должно быть значение «Нет».

### Решение 4
```sql
SELECT CONCAT(s.first_name, ' ' , s.last_name) as FIO, COUNT(r.rental_id) as Продажи,
case
	WHEN COUNT(r.rental_id) > 8000 THEN 'Да'
	ELSE 'Нет' END AS 'Премия'
FROM rental r
JOIN staff s ON s.staff_id = r.staff_id
GROUP BY FIO 

```
![Alt text](img/04.jpg)

### Задание 5*

Найдите фильмы, которые ни разу не брали в аренду.

### Решение 5
```sql
SELECT f.title , r.rental_id, i.inventory_id 
FROM inventory i
LEFT JOIN rental r ON r.inventory_id  = i.inventory_id
JOIN film f ON f.film_id = i.film_id 
WHERE r.inventory_id is NULL

```
![Alt text](img/05.jpg)