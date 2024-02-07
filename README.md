# Домашнее задание к занятию «Защита сети» «Шадрин Игорь»


### Задание 1

Проведите разведку системы и определите, какие сетевые службы запущены на защищаемой системе:

**sudo nmap -sA < ip-адрес >**

**sudo nmap -sT < ip-адрес >**

**sudo nmap -sS < ip-адрес >**

**sudo nmap -sV < ip-адрес >**

По желанию можете поэкспериментировать с опциями: https://nmap.org/man/ru/man-briefoptions.html.


*В качестве ответа пришлите события, которые попали в логи Suricata и Fail2Ban, прокомментируйте результат.*


### Решение 1

![alt text](img/01.jpg)

Логи Suricata отобразили подозрительные входящие сообщения, потенциально нежелательный трафик в разнообразных портах на отслеживаемом интерфейсе.

Логи Fail2ban не отобразили ничего, так как программа не занимается сбором статистики сетевой активности. 
------

### Задание 2

Проведите атаку на подбор пароля для службы SSH:

**hydra -L users.txt -P pass.txt < ip-адрес > ssh**

1. Настройка **hydra**: 
 
 - создайте два файла: **users.txt** и **pass.txt**;
 - в каждой строчке первого файла должны быть имена пользователей, второго — пароли. В нашем случае это могут быть случайные строки, но ради эксперимента можете добавить имя и пароль существующего пользователя.

Дополнительная информация по **hydra**: https://kali.tools/?p=1847.

2. Включение защиты SSH для Fail2Ban:

-  открыть файл /etc/fail2ban/jail.conf,
-  найти секцию **ssh**,
-  установить **enabled**  в **true**.

Дополнительная информация по **Fail2Ban**:https://putty.org.ru/articles/fail2ban-ssh.html.



*В качестве ответа пришлите события, которые попали в логи Suricata и Fail2Ban, прокомментируйте результат.*

### Решение 2

![alt text](<img/02 ftb.jpg>)

В логи fail2ban попали попытки ввода ssh пароля и бан за превышение допустимого количества попыток.

![alt text](<img/2 sct.jpg>)

Логи suricata показывают потенциальное ssh сканирование (на сколько я понял, hydra открывает сразу много ssh сессий для ускорения перебора)
