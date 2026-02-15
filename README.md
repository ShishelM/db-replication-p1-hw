# Домашнее задание к занятию "`Репликация и масштабирование. Часть 1`" - `Рыбянцев Павел`

---

### Задание 1

На лекции рассматривались режимы репликации master-slave, master-master, опишите их различия.

*Ответить в свободной форме.*
```
1. Master-Slave
    - Master: Принимает все запросы на запись (INSERT, UPDATE, DELETE). 
        После изменения данных записывает их в лог репликации.
    - Slave: Получает данные из лога Мастера и применяет их у себя. 
        Используется только для чтения (SELECT).

2. Master-Master
    В этой схеме все узлы равноправны. 
    Каждый сервер может одновременно и записывать, и считывать данные.
```

---

### Задание 2

Выполните конфигурацию master-slave репликации, примером можно пользоваться из лекции.

*Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*
`Конфигурация мастера и слейва:` 

[master.cnf](master.cnf)

[slave.cnf](slave.cnf)

![0](/img/image.png)

`Скрипты для автоматизации настройки:` 

[Добавление юзера репликации на мастер](master_init/setup.sh) 

[Настройка репликации на слейве](slave_init/setup.sh)

![1](/img/image-1.png)

`Поднимаем тестовые бд с помощью docker compose:`

[docker-compose.yml](docker-compose.yml)

![2](/img/image-2.png)

`Проверяем статус на slave:`

```sql
SHOW SLAVE STATUS;
```
Name                         |Value                                                   |
-----------------------------|--------------------------------------------------------|
Slave_IO_State               |Waiting for source to send event                        |
Master_Host                  |mysql-master                                            |
Master_User                  |repl_user                                               |
Master_Port                  |3306                                                    |
Connect_Retry                |60                                                      |
Master_Log_File              |mysql-bin.000003                                        |
Read_Master_Log_Pos          |1695                                                    |
Relay_Log_File               |211911d6574b-relay-bin.000005                           |
Relay_Log_Pos                |1911                                                    |
Relay_Master_Log_File        |mysql-bin.000003                                        |
Slave_IO_Running             |Yes                                                     |
Slave_SQL_Running            |Yes                                                     |
Replicate_Do_DB              |                                                        |
Replicate_Ignore_DB          |                                                        |
Replicate_Do_Table           |                                                        |
Replicate_Ignore_Table       |                                                        |
Replicate_Wild_Do_Table      |                                                        |
Replicate_Wild_Ignore_Table  |                                                        |
Last_Errno                   |0                                                       |
Last_Error                   |                                                        |
Skip_Counter                 |0                                                       |
Exec_Master_Log_Pos          |1695                                                    |
Relay_Log_Space              |2997654                                                 |
Until_Condition              |None                                                    |
Until_Log_File               |                                                        |
Until_Log_Pos                |0                                                       |
Master_SSL_Allowed           |Yes                                                     |
Master_SSL_CA_File           |                                                        |
Master_SSL_CA_Path           |                                                        |
Master_SSL_Cert              |                                                        |
Master_SSL_Cipher            |                                                        |
Master_SSL_Key               |                                                        |
Seconds_Behind_Master        |0                                                       |
Master_SSL_Verify_Server_Cert|No                                                      |
Last_IO_Errno                |0                                                       |
Last_IO_Error                |                                                        |
Last_SQL_Errno               |0                                                       |
Last_SQL_Error               |                                                        |
Replicate_Ignore_Server_Ids  |                                                        |
Master_Server_Id             |1                                                       |
Master_UUID                  |4e9e8b83-0a88-11f1-b8f2-6614b793fa16                    |
Master_Info_File             |mysql.slave_master_info                                 |
SQL_Delay                    |0                                                       |
SQL_Remaining_Delay          |                                                        |
Slave_SQL_Running_State      |Replica has read all relay log; waiting for more updates|
Master_Retry_Count           |86400                                                   |
Master_Bind                  |                                                        |
Last_IO_Error_Timestamp      |                                                        |
Last_SQL_Error_Timestamp     |                                                        |
Master_SSL_Crl               |                                                        |
Master_SSL_Crlpath           |                                                        |
Retrieved_Gtid_Set           |                                                        |
Executed_Gtid_Set            |                                                        |
Auto_Position                |0                                                       |
Replicate_Rewrite_DB         |                                                        |
Channel_Name                 |                                                        |
Master_TLS_Version           |                                                        |
Master_public_key_path       |                                                        |
Get_master_public_key        |0                                                       |
Network_Namespace            |                                                        |

`Добавляем тестовую табличку на master`
```sql
CREATE TABLE test_table (id INT PRIMARY KEY, name VARCHAR(50));
```
`Видим что таблица успешно реплицировалась на слейв:`

![3](/img/image-3.png)

`Добавляем тестовые данные в таблицу:`
```sql
INSERT INTO test_table (id, name) VALUES (1, 'Master Record');
```

`Проверяем, строка появилась так же на слейв`

![4](/img/image-4.png)

---

## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

---

### Задание 3* 

Выполните конфигурацию master-master репликации. Произведите проверку.

*Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*