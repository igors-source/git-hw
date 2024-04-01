# Домашнее задание к занятию 6. «Troubleshooting»

## Задача 1

Перед выполнением задания ознакомьтесь с документацией по [администрированию MongoDB](https://docs.mongodb.com/manual/administration/).

Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD-операция в MongoDB и её 
нужно прервать. 

Вы как инженер поддержки решили произвести эту операцию:

- напишите список операций, которые вы будете производить для остановки запроса пользователя;
- предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB.

## Решение 1

1) Включить средства профилирования - db.setProfilingLevel(1) - логирование только медленных запросов
2) db.currentOp({"active" : true,"secs_running" : { "$gt" : 180 },}) - вывести список запросов, выполняющихся более 3х минут
3) db.killOp(id интересующего запроса)

Для решения проблемы, необходимо построить explain(‘executionStats’) запроса, чтобы выяснить, что конкретно занимает много времени и при необходимости подключить индексацию.

## Задача 2

Перед выполнением задания познакомьтесь с документацией по [Redis latency troobleshooting](https://redis.io/topics/latency).

Вы запустили инстанс Redis для использования совместно с сервисом, который использует механизм TTL. 
Причём отношение количества записанных key-value-значений к количеству истёкших значений есть величина постоянная и
увеличивается пропорционально количеству реплик сервиса. 

При масштабировании сервиса до N реплик вы увидели, что:

- сначала происходит рост отношения записанных значений к истекшим,
- Redis блокирует операции записи.

Как вы думаете, в чём может быть проблема?

## Решение 2
 
Предполагаю, что у Redis закончилась выделенная память, рост отношения записанных значений к истекшим происходил из - за того, что redis не может удалить старые ключи, у них не закончилось время жизни, а количество запросов в N раз увеличилось.

Почему Redis блокирует операции записи: eсли в базе данных есть много ключей, срок действия которых истекает в одну и ту же секунду, и они составляют не менее 25% текущей популяции ключей с установленным TTL, Redis может заблокировать запись, чтобы получить процент ключей с уже истекшим сроком действия ниже 25%.

## Задача 3

Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей в таблицах базы
пользователи начали жаловаться на ошибки вида:
```python
InterfaceError: (InterfaceError) 2013: Lost connection to MySQL server during query u'SELECT..... '
```

Как вы думаете, почему это начало происходить и как локализовать проблему?

Какие пути решения этой проблемы вы можете предложить?

## Решение 3

Локализация проблемы - запуск MySQL c ключом --log-warnings=2, чтобы получить в логе информацию о потерянных соединениях.

Исклоючим проблему с сетевым соединением, так как проблема начала проявляться с ростом количества записей. 
1) Первое предположение - слишком большой запрос от клиента, база закрывает соедииение, так как предполагает проблемы на стороне клиента, можно попробовать увеличить переменную max_allowed_packet, так же можно в клиентском приложении разбить запросы на более маленькие.
2) Попробовать установить переменную 'connect_timeout': 120, увеличить время ожидания до закрытия соединения. 

## Задача 4


Вы решили перевести гис-систему из задачи 3 на PostgreSQL, так как прочитали в документации, что эта СУБД работает с 
большим объёмом данных лучше, чем MySQL.

После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:

`postmaster invoked oom-killer`

Как вы думаете, что происходит?

Как бы вы решили эту проблему?

## Решение 4

Out-Of-Memory Killer — это процесс, который завершает приложение, для предотвращения обрушения всей системы Linux если закончилась память. Очевидно, процесс postmaster вызвал OOM потому, что потребил всю доступную оперативную память. Необходимо физически увеличить количество оперативной памяти, рассмотреть варианты завершения лишних приложений и сервисов, работающих на сервере, вертикально масштабировать базу данных. 
Переменные в конфиге Postgresql, который можно поправить:
1) уменьшить значение work_mem - максимальный объем памяти для каждого запроса, по умолчанию 4 мб, чем меньше значение, тем меньше памяти будет задействовано
2) уменьшить значени max_connections каждое соединение потребляет 2-3мб памяти, уменьшив это значение, освободим память
3) уменьшить значение shared_buffers при операции чтения любые данные, запрошенные с диска, сначала загружаются в ОЗУ, а затем передаются клиенту
Занижение этих переменных уменьшит быстродействие, но освободит память.