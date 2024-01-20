# Домашнее задание к занятию «Резервное копирование баз данных» «Шадрин Игорь»

### Задание 1. Резервное копирование

### Кейс
Финансовая компания решила увеличить надёжность работы баз данных и их резервного копирования. 

Необходимо описать, какие варианты резервного копирования подходят в случаях: 

1.1. Необходимо восстанавливать данные в полном объёме за предыдущий день.

1.2. Необходимо восстанавливать данные за час до предполагаемой поломки.

1.3.* Возможен ли кейс, когда при поломке базы происходило моментальное переключение на работающую или починенную базу данных.

*Приведите ответ в свободной форме.*

---

### Решение 1
1.1. В случае необходимости восстанавливать данные за предыдущий день, я предположил бы дифференциальный бекап раз в сутки с фулл бекапом раз в неделю.

1.2. В случае необходимости восстанавливать данные каждый час, к стратегии из предыдущего ответа, я бы добавил инкрементный бекап каждый час, или бекап на уровне Журнала транзакций (файлов WAL) каждый час.

1.3. Моментальное переключение возможно при использовании репликации - если вышел из строя слейв, который работал на чтение. Если вышел из строя мастер, слейву понадобится некоторое время, чтобы стать мастером (как минимум, некий таймаут, за который станет понятно, что мастер вышел из строя).

### Задание 2. PostgreSQL

2.1. С помощью официальной документации приведите пример команды резервирования данных и восстановления БД (pgdump/pgrestore).

2.1.* Возможно ли автоматизировать этот процесс? Если да, то как?

*Приведите ответ в свободной форме.*

---

### Решение 2

2.1
```bash
#создание резервной копии 
pg_dump -U dbUser -d Somedb | gzip > /tmp/backup.gz
#восстановление из резервной копии
pg_restore -U dbUser -d Somedb -Ft /tmp/backup.gz

```
2.1*
Автоматизация возможна при помощи crontab
```bash
crontab -e
3 0 * * * pg_dump -U dbUser -d Somedb | gzip > /tmp/backup.gz # postgres pg dump
```
Или в таймере systemd (если он используется)

### Задание 3. MySQL

3.1. С помощью официальной документации приведите пример команды инкрементного резервного копирования базы данных MySQL. 

3.1.* В каких случаях использование реплики будет давать преимущество по сравнению с обычным резервным копированием?

*Приведите ответ в свободной форме.*

### Решение 3
3.1
```bash
#создание инкрементной резервной копии. 
#1. Создание полной копии
mysqdump --all-databases -u [username] -p [password] --backup-basedir=/tmp/backup/ > full$(date +"%Y-%m-%d-%H-%M-%S").sql

#2. Создание инкрементной копии на базе полной копии
mysqldump --all-databases -u [username] -p [password] --incremental --incremental-basedir=/tmp/backup/  > incremental-$(date +"%Y-%m-%d-%H-%M-%S").sql
```
3.1*
1) Увеличение производительности - реплика позволяет взять на себя часть запросов на чтение.
2) Более быстрое переключение в случае отказа
3) Можно остановить реплику и спокойно снять с нее резервную копию
