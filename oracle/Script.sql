-- *외부변수 삽입하기
INSERT  INTO REGIONS(region_id, REGION_NAME) VALUES (${region_id}, '${region_name}');
SELECT * FROM REGIONS ;
/*
cmd에서는 INSERT  INTO REGIONS(region_id, REGION_NAME) VALUES (&region_id, '&region_name');로 해야하는데
디비버에서는 안 되므로 https://digndig.kr/sql/2021/10/06/SQL_BindingVariables.html 를 찾아본 결과 $를 이용한 바인드 방법을 찾음
*/

-- *연습문제
-- **테이블 생성
CREATE TABLE customer
(ID NUMBER(4) CONSTRAINT customer_id_pk PRIMARY KEY,
 NAME varchar(40),
 PHONE varchar(40),
 COUNTRY varchar(40),
 CREDIT_RATING varchar(40));

-- **테이블 삭제 => 데이터만
DELETE TABLE CUSTOMER;

-- **테이블 삭제 => 테이블 자체 삭제
DROP TABLE CUSTOMER;

-- **테이블 확인
SELECT * FROM CUSTOMER ;

-- **데이터 삽입
INSERT INTO CUSTOMER VALUES (201,'Unisports','55-206610','Sao Paolo ,Brazil','EXCELL');
INSERT INTO CUSTOMER(id,phone,CREDIT_RATING,NAME,COUNTRY) VALUES (202,'81-20101','POOR','OJ Atheletics','Osaka, Japan');
INSERT INTO CUSTOMER VALUES (206,'Sportique','33-225720','Cannes, France','EXCELL');
INSERT INTO CUSTOMER VALUES (214,'Ojibway Retail','1-716-555','Buffalo, new york, USA','GOOD');
INSERT INTO CUSTOMER VALUES (${id},'${name}','${PHONE}','${COUNTRY}','${CREDIT_RATING}');

-- **데이터 변경
UPDATE CUSTOMER SET phone = '55-123456' WHERE id=201;
UPDATE CUSTOMER SET credit_rating = 'GOOD' WHERE credit_rating = 'EXCELL';

-- **커밋
COMMIT;

-- **모든 데이터 삭제
DELETE from CUSTOMER;
TRUNCATE TABLE CUSTOMER;
/*
TRUNCATE는 롤백을 해도 소용이 없이 싹지워 버림
롤백을 하기 위해서는 DELETE from으로 삭제 하자
*/

-- **롤백
ROLLBACK;

-- *테이블 생성
CREATE TABLE s_emp(
id varchar2(7),
last_name varchar2(25) CONSTRAINT s_emp_last_name_nn NOT NULL,
FIRST_name varchar2(25),
userid varchar(8),
START_date DATE,
comments varchar2(255),
manager_id number(7),
title varchar(25),
dept_id NUMBER(7),
salary NUMBER(11,2),
commision_pct NUMBER(4,2),
 CONSTRAINT s_emp_id_pk PRIMARY KEY (id),
 CONSTRAINT s_emp_userid_u unique (userid),
 CONSTRAINT s_emp_commision_pct_ck CHECK (commision_pct IN (10,12.5,15,17.5,20)));
/*
CONSTRAINT 변수 설정할 때 같이 쓸수도 있고 마지막에 적는 것도 가능
열이름 열타입 제약조건 순서대로 적어야 함
cmd랑 같이 열려 있어서 인지 끄자마자 바로 테이블이 생성
cmd가 켜져 있었을 때는 시간만 계속 흐르고 생성이 되지 않았음
*/

-- * 테이블 구조 변경
ALTER TABLE s_emp ADD (comments_two varchar2(255));
/*
varchar2타입인 comments2열을 추가
*/

ALTER TABLE s_emp MODIFY (comments_two varchar2(100));
/*
comments2열의 타입을 수정
255자리에서 100자리로 수정
*/
























