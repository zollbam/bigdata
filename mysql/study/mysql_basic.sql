# 데이터 베이스 만들기
create database gydb;

# 현재 데이터베이스 보기
show databases;

# 데이터베이스 선택
use mysql;
use gydb;
/*
use를 이용하여 내가 만들거나 기존에 있는 데이터베이스를 사용할 수 있음
sakila, world, sys 등이 있음
 */

# user정보 보기
SELECT * FROM USER;
/*
mysql 데이터베이스에서만 쿼리결과가 출력
 */

# 테이블 불러오기
USE sakila;
SELECT * FROM actor;
/*
sakila데이터 베이스 안에 있는 actor테이블을 불러옴
* : 모든 열을 다 불러줌
 */

SELECT count(*) FROM actor;
/*
해당 테이블의 행 수를 확인 할 수 있음
 */

SELECT actor_id FROM actor;
/*
sakila데이터 베이스 안에 있는 actor테이블을 불러옴
열이름을 select에 지정함으로써 해당 열만 부르는 것도 가능
 */

SELECT actor_id, last_update  FROM actor;
/*
여러 개의 열을 불러 올 수 도 있음
열 구분은 ,(콤마)로 함
 */

SELECT DISTINCT first_name  FROM actor;
/*
DISTINCT는 중복된 데이터를 제거하고 1개만 보여줌
first_name에 중복되는 데이터가 많이 기존 200개 였던 행이 128개로 감소함
즉, 이말은 72개는 first_name에 중복이 있었다는 의미
CAMERON이라는 성을 가진 사람은 3명이나 있는데 2개는 삭제되고 1개만 나옴
 */

SELECT DISTINCT first_name fn FROM actor;
/*
열이름 뒤에 콤마사용없이 문자열을 적으면 해당 문자열은 열의 별칭(alias)으로 설정
 */

SELECT DISTINCT actor_id num, first_name fn FROM actor;
/*
열이름 뒤에 콤마사용없이 문자열을 적으면 해당 문자열은 열의 별칭(alias)으로 설정
actor_id열은 num으로 first_name은 fn으로 열이름이 바뀌어 출력이 됨
 */

SELECT DISTINCT actor_id num, first_name "^fn^" FROM actor;
/*
공백이나 특수문자를 넣고 싶다면 ""로 묶어주어야 함
 */

SELECT DISTINCT actor_id "@num@", first_name "^fn^" 
FROM actor
WHERE actor_id = 10;
/*
actor_id가 10인 데이터만 출력
 */

SELECT DISTINCT actor_id num, first_name fn 
FROM actor
WHERE fn = 'CAMERON';
/*
where문은 조건을 넣으므로써 테이블에서 원하는 데이터만 출력 가능
별칭을 where문에서는 사용 할 수 없음
 */

SELECT DISTINCT actor_id num, first_name fn 
FROM actor
WHERE  first_name = 'CAMERON';
/*
열이름을 적어 주어야 정상적으로 작동
 */


ALTER TABLE actor modify COLUMN first_name varchar(40);
/*
first_name가 varbinary(40)으로 되어 있어서 varchar(40) 바꿈
first_name = 'cameron'로 조회 안되었던 CAMERON이 조회가 됨
*/

SELECT DISTINCT actor_id num, first_name fn 
FROM actor
WHERE first_name = 'cameron';
/*
데이터를 찾을 때 대소문자 구분을 안함
타입이 varbinary일때는 구분을 함
 */

SELECT DISTINCT actor_id num, first_name fn 
FROM actor
WHERE BINARY first_name = 'CameRon';
/*
BINARY를 사용하여 대소문자를 구분 할 수 있음
 */

SELECT DISTINCT actor_id num, first_name fn 
FROM actor
WHERE  BINARY first_name = 'CAMERON';
/*
대문자로 된 CAMERON만 찾아 추출함
 */

SELECT DISTINCT actor_id num, first_name fn 
FROM actor
WHERE  first_name = 'CAMERON' AND actor_id IN (24,63);
/*
여러 조건을 넣는 것도 가능
 */

SELECT * 
FROM payment
WHERE payment_date = "2005-05-24 22:53:30";
/*
날짜 찾기도 가능
payment_date의 타입은 datetime임
 */

#테이블의 열 타입 변경
ALTER TABLE actor MODIFY COLUMN first_name VARBINARY(40);
ALTER TABLE actor MODIFY first_name VARCHAR(40);
/*
ALTER TABLE actor MODIFY (first_name VARCHAR(40));는 ()때문인지 오류가 나옴
VARBINARY(40)으로 변경하는 이유는 조건문으로 데이터를 찾을 때 대소문자를 구분하기 위해
*/

# 인코딩 변경
ALTER DATABASE sakila CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE actor CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
/*
 utf8이 깨지는 것 방지하기 위해 설정변수를 변경하는 것
 utf8은 인코딩이 3바이트인 반면 utf8mb4는 4바이트라 글자깨짐을 방지 할 수 있음 
 
 참조 링크: https://stackoverflow.com/questions/6115612/how-to-convert-an-entire-mysql-database-characterset-and-collation-to-utf-8
 */

SELECT *
FROM actor 
WHERE first_name <> "CAMERON";
/*
<>: 해당하는 검색어는 뽑지 말라는 의미
CAMERON으로 된 데이터는 추출하지 않기 때문에 197행의 테이블이 보여짐
 */

SELECT *
FROM actor 
WHERE first_name <> "cameron";
/*
varbinary면 대소문자를 구분하기 때문에 CAMERON은 삭제 되지 않아 200개행이 그대로 추출이 됨
varchar이면 대소문자를 구분안 하기 때문에 CAMERON은 삭제 되어 197개행이 그대로 추출이 됨
*/

SELECT count(*)
FROM payment;

SELECT count(*)
FROM payment
WHERE amount > 5;
/*
16044행에서 amout가 5초과인 행은 3957개로 나옴
 */

SELECT count(*)
FROM payment
WHERE amount BETWEEN 5 AND 10;
/*
amount가 5이상 10이하인 데이터 추출
 */

SELECT count(*)
FROM payment
WHERE amount NOT BETWEEN 5 AND 10;
/*
amount가 5미만 10초과인 데이터 추출
 */

SELECT payment_id, payment_date, amount 
FROM payment
WHERE amount IN (6.99, 4.99);
/*
amount가 6.99와 4.99인 데이터만 추출
 */

SELECT payment_id, payment_date, amount 
FROM payment
WHERE amount not IN (6.99, 4.99);
/*
amount가 6.99와 4.99인 데이터가 아닌 것만 추출
 */

SELECT first_name
FROM actor 
WHERE first_name LIKE ("%C%");
/*
"%c%"는 소문자라서 추출이 안 됨
대문자로 하면 first_name에 C가 포함된 글자는 다 추출됨
 */

SELECT count(*)
FROM film
WHERE original_language_id IS NULL;
/*
original_language_id에서 null값의 개수를 추출 
 */

SELECT count(*)
FROM film
WHERE original_language_id IS NOT NULL;
/*
original_language_id에서 null값의 아닌 개수를 추출 
 */

SELECT *
FROM actor 
WHERE first_name LIKE ("C%") OR last_name LIKE ("%S");
/*
first_name이 C로 시작하거나 last_name이 S로 끝나는 이름을 추출
OR은 2개의 조건 중 하나라도 참이면 데이터를 추출함
 */

# 데이터 추출 순서 => 오름차순/내림차순
SELECT *
FROM actor 
WHERE first_name LIKE ("CA%") OR last_name LIKE ("%MS")
ORDER BY first_name DESC;
/*
first_name이 CA로 시작하거나 last_name이 MS로 끝나는 이름을 추출
first_name을 내림차순으로 정렬한 테이블을 보여줌
ORDER BY는 기본값이 오름차순(ASC)임
 */

# 데이터 추출 순서 => 오름차순/내림차순
SELECT *
FROM actor 
WHERE first_name LIKE ("CA%") OR last_name LIKE ("%MS")
ORDER BY first_name, last_name;
/*
first_name으로 오름차순을 하고 같은 이름의 first_name가 있으면
last_name으로 오름차순을 함
 */

SELECT *
FROM actor 
WHERE first_name LIKE ("CA%") OR last_name LIKE ("%MS")
ORDER BY first_name DESC, last_name;
/*
first_name으로 내림차순을 하고 같은 이름의 first_name가 있으면
last_name으로 오름차순을 함
 */

SELECT *
FROM actor 
WHERE first_name LIKE ("CA%") OR last_name LIKE ("%MS")
ORDER BY first_name DESC, last_name DESC;
/*
first_name으로 내림차순을 하고 같은 이름의 first_name가 있으면
last_name으로 내림차순을 함
 */

SELECT *
FROM actor 
WHERE first_name LIKE ("CA%") OR last_name LIKE ("%MS")
ORDER BY first_name, last_name DESC;
/*
first_name으로 오름차순을 하고 같은 이름의 first_name가 있으면
last_name으로 내림차순을 함
 */

# 전체 DB와 각 DB의 데이블
SELECT table_schema, table_name
FROM INFORMATION_SCHEMA.tables
WHERE table_schema = "sakila";

# 유저정보 확인
USE mysql;
SELECT * FROM user;

# 테이블의 구조 확인
USE sakila;
DESCRIBE actor;
/*
열의 이름, 타입, 특징 등을 보여줌 
 */

DESCRIBE payment;
/*
열은 7개가 있음  
 */

# DB의 테이블들의 이름 출력
SHOW tables;
/*
현재 DB의 테이블들의 이름을 다 출력
 */

SHOW tables IN world;
SHOW tables IN sakila;
/*
world DB의 테이블들의 이름을 다 출력
 */

# 조건문과 정렬을 이용해 내가 원하는 형태로 출력
SELECT TABLE_SCHEMA , TABLE_NAME , TABLE_ROWS
FROM information_schema.tables
WHERE TABLE_SCHEMA IN ('sakila','gydb','sys')
ORDER BY TABLE_SCHEMA, TABLE_NAME ;
/*
특정 db의 테이블을 보고 싶고 해당 테이블의 이름과 행의 수를 확인 할수 있음
정렬을 이용해 더 깔끔하게 보이게 만듬
 */

# 데이터 삽입하기
ALTER TABLE actor MODIFY actor_id int AUTO_INCREMENT PRIMARY KEY;
/*
actor테이블의 actor_id열을 AUTO_INCREMENT과 PRIMARY KEY기능 추가
AUTO_INCREMENT를 하기 위해서는 PRIMARY KEY가 필수임
 */

INSERT INTO actor VALUES (NULL,"gun","cho", now());
/*
AUTO_INCREMENT는 NULL값을 통해 자동으로 값이 입력되고
나머지 열들은 각 타입에 맞는 형태로 값을 입력
 */

SELECT count(*) FROM actor; 
SELECT *
FROM actor
WHERE actor_id = 201; 
/*
행이 하나 늘어남
last_update에 오늘날짜로 들어간 것을 확인
 */

# 행 삭제
INSERT INTO actor VALUES (NULL,"gun","cho", date(now()));
SELECT *
FROM actor
WHERE actor_id = 202;
DELETE  FROM actor WHERE actor_id = 202; 
/*
이번에 추가된 행은 시간은 설정 하지 않고 날짜만 나오게 만듬
날짜는 오늘날짜로 나오는 반면 시간은 00:00:00
first_name과 last_name이 201번과 동일하기 때문에 삭제함
 */

INSERT INTO actor(first_name, last_name,last_update) VALUES ("saz","pig", date(now()));
SELECT *
FROM actor
WHERE actor_id = 203;
/*
열을 추가하지 않아도 actor_id에는 자동으로 값이 입력됨
 */

# auto_increment값 초기화
ALTER TABLE actor AUTO_INCREMENT = 203;
INSERT INTO actor(first_name, last_name,last_update) VALUES ("huge","pang", date(now()));
/*
하는 이유는 if 202행을 삭제하고 다시 행을 삽입하면 actor_id에는 202의 값이 아니라 203이 나오게 됨
그렇게 되면 번거롭고 헷갈리니 다시 auto_increment값을 초기화 시켜줌
 */
SELECT * FROM actor WHERE actor_id = 203;
/*
이제 다시 정상적으로 값이 나오게 됨
이렇게 하다가 다시 행을 삭제 해야 할 일이 생기면 auto_increment값을 초기화하면 됨
 */

# 데이터 수정하기
UPDATE actor SET actor_id = 202 WHERE actor_id = 203;

# 커밋 후
INSERT INTO actor (SELECT * FROM sakila.actor);
/*
sakila의 actor테이블의 모든 데티어를 dydb데이터베이스의 actor테이블에 삽입 
  */
SELECT * FROM actor ;

START TRANSACTION;
/*
이 쿼리문을 해주어야 rollback이나 commit이 정상작동 함
자동 커밋이 비활성화 됨
일회용 임 => commit이나 rollback을 하면 자동 종료
  */

COMMIT;
/*
커밋 후 변화 내용은 데이터베이스에 영구적으로 반영됨
다른 모든 사용자들도 변화된 내용을 볼 수 있음
  */

# 롤백
DELETE FROM actor;
SELECT *
FROM actor;
/*
actor의 모든 데이터가 삭제
  */

ROLLBACK;
/*
롤백 진행
  */

SELECT *
FROM actor;
/*
롤백이 안됨????
  */
