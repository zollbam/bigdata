# ������ ���̽� �����
create database gydb;

# ���� �����ͺ��̽� ����
show databases;

# �����ͺ��̽� ����
use mysql;
use gydb;
/*
use�� �̿��Ͽ� ���� ����ų� ������ �ִ� �����ͺ��̽��� ����� �� ����
sakila, world, sys ���� ����
 */

# user���� ����
SELECT * FROM USER;
/*
mysql �����ͺ��̽������� ��������� ���
 */

# ���̺� �ҷ�����
USE sakila;
SELECT * FROM actor;
/*
sakila������ ���̽� �ȿ� �ִ� actor���̺��� �ҷ���
* : ��� ���� �� �ҷ���
 */

SELECT count(*) FROM actor;
/*
�ش� ���̺��� �� ���� Ȯ�� �� �� ����
 */

SELECT actor_id FROM actor;
/*
sakila������ ���̽� �ȿ� �ִ� actor���̺��� �ҷ���
���̸��� select�� ���������ν� �ش� ���� �θ��� �͵� ����
 */

SELECT actor_id, last_update  FROM actor;
/*
���� ���� ���� �ҷ� �� �� �� ����
�� ������ ,(�޸�)�� ��
 */

SELECT DISTINCT first_name  FROM actor;
/*
DISTINCT�� �ߺ��� �����͸� �����ϰ� 1���� ������
first_name�� �ߺ��Ǵ� �����Ͱ� ���� ���� 200�� ���� ���� 128���� ������
��, �̸��� 72���� first_name�� �ߺ��� �־��ٴ� �ǹ�
CAMERON�̶�� ���� ���� ����� 3���̳� �ִµ� 2���� �����ǰ� 1���� ����
 */

SELECT DISTINCT first_name fn FROM actor;
/*
���̸� �ڿ� �޸������� ���ڿ��� ������ �ش� ���ڿ��� ���� ��Ī(alias)���� ����
 */

SELECT DISTINCT actor_id num, first_name fn FROM actor;
/*
���̸� �ڿ� �޸������� ���ڿ��� ������ �ش� ���ڿ��� ���� ��Ī(alias)���� ����
actor_id���� num���� first_name�� fn���� ���̸��� �ٲ�� ����� ��
 */

SELECT DISTINCT actor_id num, first_name "^fn^" FROM actor;
/*
�����̳� Ư�����ڸ� �ְ� �ʹٸ� ""�� �����־�� ��
 */

SELECT DISTINCT actor_id "@num@", first_name "^fn^" 
FROM actor
WHERE actor_id = 10;
/*
actor_id�� 10�� �����͸� ���
 */

SELECT DISTINCT actor_id num, first_name fn 
FROM actor
WHERE fn = 'CAMERON';
/*
where���� ������ �����Ƿν� ���̺��� ���ϴ� �����͸� ��� ����
��Ī�� where�������� ��� �� �� ����
 */

SELECT DISTINCT actor_id num, first_name fn 
FROM actor
WHERE  first_name = 'CAMERON';
/*
���̸��� ���� �־�� ���������� �۵�
 */


ALTER TABLE actor modify COLUMN first_name varchar(40);
/*
first_name�� varbinary(40)���� �Ǿ� �־ varchar(40) �ٲ�
first_name = 'cameron'�� ��ȸ �ȵǾ��� CAMERON�� ��ȸ�� ��
*/

SELECT DISTINCT actor_id num, first_name fn 
FROM actor
WHERE first_name = 'cameron';
/*
�����͸� ã�� �� ��ҹ��� ������ ����
Ÿ���� varbinary�϶��� ������ ��
 */

SELECT DISTINCT actor_id num, first_name fn 
FROM actor
WHERE BINARY first_name = 'CameRon';
/*
BINARY�� ����Ͽ� ��ҹ��ڸ� ���� �� �� ����
 */

SELECT DISTINCT actor_id num, first_name fn 
FROM actor
WHERE  BINARY first_name = 'CAMERON';
/*
�빮�ڷ� �� CAMERON�� ã�� ������
 */

SELECT DISTINCT actor_id num, first_name fn 
FROM actor
WHERE  first_name = 'CAMERON' AND actor_id IN (24,63);
/*
���� ������ �ִ� �͵� ����
 */

SELECT * 
FROM payment
WHERE payment_date = "2005-05-24 22:53:30";
/*
��¥ ã�⵵ ����
payment_date�� Ÿ���� datetime��
 */

#���̺��� �� Ÿ�� ����
ALTER TABLE actor MODIFY COLUMN first_name VARBINARY(40);
ALTER TABLE actor MODIFY first_name VARCHAR(40);
/*
ALTER TABLE actor MODIFY (first_name VARCHAR(40));�� ()�������� ������ ����
VARBINARY(40)���� �����ϴ� ������ ���ǹ����� �����͸� ã�� �� ��ҹ��ڸ� �����ϱ� ����
*/

# ���ڵ� ����
ALTER DATABASE sakila CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE actor CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
/*
 utf8�� ������ �� �����ϱ� ���� ���������� �����ϴ� ��
 utf8�� ���ڵ��� 3����Ʈ�� �ݸ� utf8mb4�� 4����Ʈ�� ���ڱ����� ���� �� �� ���� 
 
 ���� ��ũ: https://stackoverflow.com/questions/6115612/how-to-convert-an-entire-mysql-database-characterset-and-collation-to-utf-8
 */

SELECT *
FROM actor 
WHERE first_name <> "CAMERON";
/*
<>: �ش��ϴ� �˻���� ���� ����� �ǹ�
CAMERON���� �� �����ʹ� �������� �ʱ� ������ 197���� ���̺��� ������
 */

SELECT *
FROM actor 
WHERE first_name <> "cameron";
/*
varbinary�� ��ҹ��ڸ� �����ϱ� ������ CAMERON�� ���� ���� �ʾ� 200������ �״�� ������ ��
varchar�̸� ��ҹ��ڸ� ���о� �ϱ� ������ CAMERON�� ���� �Ǿ� 197������ �״�� ������ ��
*/

SELECT count(*)
FROM payment;

SELECT count(*)
FROM payment
WHERE amount > 5;
/*
16044�࿡�� amout�� 5�ʰ��� ���� 3957���� ����
 */

SELECT count(*)
FROM payment
WHERE amount BETWEEN 5 AND 10;
/*
amount�� 5�̻� 10������ ������ ����
 */

SELECT count(*)
FROM payment
WHERE amount NOT BETWEEN 5 AND 10;
/*
amount�� 5�̸� 10�ʰ��� ������ ����
 */

SELECT payment_id, payment_date, amount 
FROM payment
WHERE amount IN (6.99, 4.99);
/*
amount�� 6.99�� 4.99�� �����͸� ����
 */

SELECT payment_id, payment_date, amount 
FROM payment
WHERE amount not IN (6.99, 4.99);
/*
amount�� 6.99�� 4.99�� �����Ͱ� �ƴ� �͸� ����
 */

SELECT first_name
FROM actor 
WHERE first_name LIKE ("%C%");
/*
"%c%"�� �ҹ��ڶ� ������ �� ��
�빮�ڷ� �ϸ� first_name�� C�� ���Ե� ���ڴ� �� �����
 */

SELECT count(*)
FROM film
WHERE original_language_id IS NULL;
/*
original_language_id���� null���� ������ ���� 
 */

SELECT count(*)
FROM film
WHERE original_language_id IS NOT NULL;
/*
original_language_id���� null���� �ƴ� ������ ���� 
 */

SELECT *
FROM actor 
WHERE first_name LIKE ("C%") OR last_name LIKE ("%S");
/*
first_name�� C�� �����ϰų� last_name�� S�� ������ �̸��� ����
OR�� 2���� ���� �� �ϳ��� ���̸� �����͸� ������
 */

# ������ ���� ���� => ��������/��������
SELECT *
FROM actor 
WHERE first_name LIKE ("CA%") OR last_name LIKE ("%MS")
ORDER BY first_name DESC;
/*
first_name�� CA�� �����ϰų� last_name�� MS�� ������ �̸��� ����
first_name�� ������������ ������ ���̺��� ������
ORDER BY�� �⺻���� ��������(ASC)��
 */

# ������ ���� ���� => ��������/��������
SELECT *
FROM actor 
WHERE first_name LIKE ("CA%") OR last_name LIKE ("%MS")
ORDER BY first_name, last_name;
/*
first_name���� ���������� �ϰ� ���� �̸��� first_name�� ������
last_name���� ���������� ��
 */

SELECT *
FROM actor 
WHERE first_name LIKE ("CA%") OR last_name LIKE ("%MS")
ORDER BY first_name DESC, last_name;
/*
first_name���� ���������� �ϰ� ���� �̸��� first_name�� ������
last_name���� ���������� ��
 */

SELECT *
FROM actor 
WHERE first_name LIKE ("CA%") OR last_name LIKE ("%MS")
ORDER BY first_name DESC, last_name DESC;
/*
first_name���� ���������� �ϰ� ���� �̸��� first_name�� ������
last_name���� ���������� ��
 */

SELECT *
FROM actor 
WHERE first_name LIKE ("CA%") OR last_name LIKE ("%MS")
ORDER BY first_name, last_name DESC;
/*
first_name���� ���������� �ϰ� ���� �̸��� first_name�� ������
last_name���� ���������� ��
 */

# ��ü DB�� �� DB�� ���̺�
SELECT table_schema, table_name
FROM INFORMATION_SCHEMA.tables
WHERE table_schema = "sakila";

# �������� Ȯ��
USE mysql;
SELECT * FROM user;

# ���̺��� ���� Ȯ��
USE sakila;
DESCRIBE actor;
/*
���� �̸�, Ÿ��, Ư¡ ���� ������ 
 */

DESCRIBE payment;
/*
���� 7���� ����  
 */

# DB�� ���̺���� �̸� ���
SHOW tables;
/*
���� DB�� ���̺���� �̸��� �� ���
 */

SHOW tables IN world;
SHOW tables IN sakila;
/*
world DB�� ���̺���� �̸��� �� ���
 */

# ���ǹ��� ������ �̿��� ���� ���ϴ� ���·� ���
SELECT TABLE_SCHEMA , TABLE_NAME , TABLE_ROWS
FROM information_schema.tables
WHERE TABLE_SCHEMA IN ('sakila','gydb','sys')
ORDER BY TABLE_SCHEMA, TABLE_NAME ;
/*
Ư�� db�� ���̺��� ���� �Ͱ� �ش� ���̺��� �̸��� ���� ���� Ȯ�� �Ҽ� ����
������ �̿��� �� ����ϰ� ���̰� ����
 */

# ������ �����ϱ�
ALTER TABLE actor MODIFY actor_id int AUTO_INCREMENT PRIMARY KEY;
/*
actor���̺��� actor_id���� AUTO_INCREMENT�� PRIMARY KEY��� �߰�
AUTO_INCREMENT�� �ϱ� ���ؼ��� PRIMARY KEY�� �ʼ���
 */

INSERT INTO actor VALUES (NULL,"gun","cho", now());
/*
AUTO_INCREMENT�� NULL���� ���� �ڵ����� ���� �Էµǰ�
������ ������ �� Ÿ�Կ� �´� ���·� ���� �Է�
 */

SELECT count(*) FROM actor; 
SELECT *
FROM actor
WHERE actor_id = 201; 
/*
���� �ϳ� �þ
last_update�� ���ó�¥�� �� ���� Ȯ��
 */

# �� ����
INSERT INTO actor VALUES (NULL,"gun","cho", date(now()));
SELECT *
FROM actor
WHERE actor_id = 202;
DELETE  FROM actor WHERE actor_id = 202; 
/*
�̹��� �߰��� ���� �ð��� ���� ���� �ʰ� ��¥�� ������ ����
��¥�� ���ó�¥�� ������ �ݸ� �ð��� 00:00:00
first_name�� last_name�� 201���� �����ϱ� ������ ������
 */

INSERT INTO actor(first_name, last_name,last_update) VALUES ("saz","pig", date(now()));
SELECT *
FROM actor
WHERE actor_id = 203;
/*
���� �߰����� �ʾƵ� actor_id���� �ڵ����� ���� �Էµ�
 */

# auto_increment�� �ʱ�ȭ
ALTER TABLE actor AUTO_INCREMENT = 203;
INSERT INTO actor(first_name, last_name,last_update) VALUES ("huge","pang", date(now()));
/*
�ϴ� ������ if 202���� �����ϰ� �ٽ� ���� �����ϸ� actor_id���� 202�� ���� �ƴ϶� 203�� ������ ��
�׷��� �Ǹ� ���ŷӰ� �򰥸��� �ٽ� auto_increment���� �ʱ�ȭ ������
 */
SELECT * FROM actor WHERE actor_id = 203;
/*
���� �ٽ� ���������� ���� ������ ��
�̷��� �ϴٰ� �ٽ� ���� ���� �ؾ� �� ���� ����� auto_increment���� �ʱ�ȭ�ϸ� ��
 */

# ������ �����ϱ�
UPDATE actor SET actor_id = 202 WHERE actor_id = 203;

# Ŀ�� ��
INSERT INTO actor (SELECT * FROM sakila.actor);
/*
sakila�� actor���̺��� ��� ��Ƽ� dydb�����ͺ��̽��� actor���̺� ���� 
  */
SELECT * FROM actor ;

START TRANSACTION;
/*
�� �������� ���־�� rollback�̳� commit�� �����۵� ��
�ڵ� Ŀ���� ��Ȱ��ȭ ��
��ȸ�� �� => commit�̳� rollback�� �ϸ� �ڵ� ����
  */

COMMIT;
/*
Ŀ�� �� ��ȭ ������ �����ͺ��̽��� ���������� �ݿ���
�ٸ� ��� ����ڵ鵵 ��ȭ�� ������ �� �� ����
  */

# �ѹ�
DELETE FROM actor;
SELECT *
FROM actor;
/*
actor�� ��� �����Ͱ� ����
  */

ROLLBACK;
/*
�ѹ� ����
  */

SELECT *
FROM actor;
/*
�ѹ��� �ȵ�????
  */
