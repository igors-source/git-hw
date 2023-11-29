### Задание 1. СУБД

### Кейс
Крупная строительная компания, которая также занимается проектированием и девелопментом, решила создать 
правильную архитектуру для работы с данными. Ниже представлены задачи, которые необходимо решить для
каждой предметной области. 

Какие типы СУБД, на ваш взгляд, лучше всего подойдут для решения этих задач и почему? 
 
1.1. Бюджетирование проектов с дальнейшим формированием финансовых аналитических отчётов и прогнозирования рисков.
СУБД должна гарантировать целостность и чёткую структуру данных.


1.2. Под каждый девелоперский проект создаётся отдельный лендинг, и все данные по лидам стекаются в CRM к 
маркетологам и менеджерам по продажам. Какой тип СУБД лучше использовать для лендингов и для CRM? 
СУБД должны быть гибкими и быстрыми.


1.3. Отдел контроля качества решил создать базу по корпоративным нормам и правилам, обучающему материалу 
и так далее, сформированную согласно структуре компании. СУБД должна иметь простую и понятную структуру.


1.4. Департамент логистики нуждается в решении задач по быстрому формированию маршрутов доставки материалов 
по объектам и распределению курьеров по маршрутам с доставкой документов. СУБД должна уметь быстро работать
со связями.

### Решение 1
---
1.1. SQL база данных, реляционная модель может гарантировать целостность данных и четкую структуру.
1.2. Одна из NoSQL баз данных будет предоставлять достаточную гибкость для лендинга, однако для CRM лучше использовать SQL базу данных.
1.3. Модель "Ключ - значение", обладает простой и понятной структурой.
1.4. Графовая база данных лучше подходит для работы со связями. 
### Задание 2. Транзакции

2.1. Пользователь пополняет баланс счёта телефона, распишите пошагово, какие действия должны произойти для того, чтобы 
транзакция завершилась успешно. Ориентируйтесь на шесть действий.

### Решение 2

1. Открыть транзакцию.
2. Проверить, есть ли сумма на счету для оплаты
3. Заблокировать сумму на счета на оплату
4. Записать сумму на счет телефона
5. Списать сумму со счета на оплату
6. Закрыть транзацкию.


---

### Задание 3. SQL vs NoSQL

3.1. Напишите пять преимуществ SQL-систем по отношению к NoSQL. 

### Решение 3

1. Наличие SQL - универсального языка запросов, который используется всеми реляционными системами.
2. Соответствие ACID - сохранность данных и предсказуемость работы базы данных
3. Большой опыт разработчиков и техническая поддержка, так как стандарт устоявшийся и стандартизирован
4. SQL более универсален (NoSQL зачастую узконаправлены и хороши в конкретной задаче)
5. SQL базы больше подходят для сложных запросов (выборок).

---

### Задание 4. Кластеры

Необходимо производить большое количество вычислений при работе с огромным количеством данных, под эту задачу выделено 1000 машин. 

На основе какого критерия будете выбирать тип СУБД и какая модель *распределённых вычислений* 
здесь справится лучше всего и почему?

### Решение 4

Критерий выбора - поддержка работы в кластере, либо горизонтальная масштабируемость. 
Предполагаю, что лучшим решением будет модель CP, так как она гарантирует целостность данных в  таком крупном кластере и способность фунционировать в условиях распада, в ущерб доступности пользователя.
