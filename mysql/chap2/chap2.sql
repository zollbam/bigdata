-- db확인
show DATABASES;

-- db사용
use sakila;

/*
cmd에서 
mysql -u root -p sakila 치고
비번 치면 sakila에 연결된다.
*/

-- 해당 DB가 가진 테이블 확인
show tables;

-- 현재 날짜 및 시간
select now() now from dual;
select now() fromx_now;

-- 멀티바이트 캐릭터셋
show CHARACTER set;

-- 기본 캐릭터셋 설정
create DATABASE gydb1 CHARACTER set utf8;
drop DATABASE gydb1;

--  테이블 생성
CREATE table person(
    person_id SMALLINT UNSIGNED,
    fname VARCHAR(20),
    lname VARCHAR(20), 
    eye_color CHAR(2) check (eye_color in ('BR','BL','GR')), 
    birth_date DATE,
    street VARCHAR(30), 
    city VARCHAR(20),
    state VARCHAR(20), 
    country VARCHAR(20),
    postal_code VARCHAR(20),
    CONSTRAINT pk_person PRIMARY KEY(person_id)
);
/*
eye_color CHAR(2) check (eye_color in ('BR','BL','GR')을 eye_color ENUM('BR','BL','GR')로 적어도 됨
*/

CREATE TABLE favorite_food(
    person_id SMALLINT UNSIGNED,
    food varchar(20),
    constraint pk_favorite_food PRIMARY key (person_id, food),
    constraint fk_fav_food_person_id FOREIGN key (person_id) references person(person_id)
);
/*
favorite_food은 person_id, food가 기본키로 이루어진 복합키이다.
person_id는 외래키로 person테이블의 기본키인 person_id을 참조하고 있다.
*/

-- 테이블 삭제
drop table person cascade;

drop table favorite_food cascade;

-- 테이블 구조
DESC person;

DESC favorite_food;

-- 테이블 행 삽입
-- * person
insert into person (person_id, fname, lname, eye_color, birth_date) VALUES(null, 'William','Turner','BR','1972-05-27');
insert into person (person_id, fname, lname, eye_color, birth_date, street, city, state, country, postal_code) 
             VALUES(null, 'Susan','Smith','BL','1975-11-02','23 Maple St.','Arlington','VA','USA','20220');
/*
person_id을 null로 두었지만 auto_increment에 의해 1부터 차례대로 숫자가 입력이 된다.
*/

-- * favorite_food
insert into favorite_food VALUES(1, 'pizza');
insert into favorite_food VALUES(1, 'cookies');
insert into favorite_food VALUES(1, 'nachos');

-- 테이블 행 삭제
-- * person
delete from person where person_id=2;

-- * favorite_food
delete from person where food='nachos';

-- 테이블 열 수정
alter table person MODIFY person_id SMALLINT UNSIGNED auto_increment;
/*
favorite_food테이블이 참조 하고 있다고 오류가 나온다.
favorite_food테이블 삭제후 열 정보 수정 후 다시 테이블을 만들자!!

DESC person; 을 하면 Extra열에 auto_increment가 생긴다.
*/

-- 테이블 열 변경
-- * person_id가 1일 때 여러 열들의 값을 변경
update person set street='1225 Tremont St.',
                  city='Boston',
                  state='MA',
                  country='USA',
                  postal_code='02138'
               where person_id=1;

-- 테이블 데이터 확인
-- * person
select* from person;

select person_id, fname, lname, birth_date
from person;

-- ** lname이 Turner인 사람에 대한 정보

select person_id, fname, lname, birth_date
from person
where lname='Turner';

-- * favorite_food
-- ** person_id가 1인 사람이 좋아하는 food는??
select * from favorite_food;

select food
from favorite_food
where person_id=1;

-- str_to_date
select str_to_date('DEC-21-1980', '%b-%d-%Y') str_date;
/*
입력된 날짜의 형태를 적어 현재 시스템의 저장된 시간 format형태로 만들어 준다.
'DEC-21-1980' => '1980-12-21'
*/

-- date_format
select date_format(now(), '%d-%m-%y %h시 %i분 %s초') date_format;

select date_format(now(), '%d-%m-%y %W (%a)') date_format;
