-- *�ܺκ��� �����ϱ�
INSERT  INTO REGIONS(region_id, REGION_NAME) VALUES (${region_id}, '${region_name}');
SELECT * FROM REGIONS ;
/*
cmd������ INSERT  INTO REGIONS(region_id, REGION_NAME) VALUES (&region_id, '&region_name');�� �ؾ��ϴµ�
���������� �� �ǹǷ� https://digndig.kr/sql/2021/10/06/SQL_BindingVariables.html �� ã�ƺ� ��� $�� �̿��� ���ε� ����� ã��
*/

-- *��������
-- **���̺� ����
CREATE TABLE customer
(ID NUMBER(4) CONSTRAINT customer_id_pk PRIMARY KEY,
 NAME varchar(40),
 PHONE varchar(40),
 COUNTRY varchar(40),
 CREDIT_RATING varchar(40));

-- **���̺� ���� => �����͸�
DELETE TABLE CUSTOMER;

-- **���̺� ���� => ���̺� ��ü ����
DROP TABLE CUSTOMER;

-- **���̺� Ȯ��
SELECT * FROM CUSTOMER ;

-- **������ ����
INSERT INTO CUSTOMER VALUES (201,'Unisports','55-206610','Sao Paolo ,Brazil','EXCELL');
INSERT INTO CUSTOMER(id,phone,CREDIT_RATING,NAME,COUNTRY) VALUES (202,'81-20101','POOR','OJ Atheletics','Osaka, Japan');
INSERT INTO CUSTOMER VALUES (206,'Sportique','33-225720','Cannes, France','EXCELL');
INSERT INTO CUSTOMER VALUES (214,'Ojibway Retail','1-716-555','Buffalo, new york, USA','GOOD');
INSERT INTO CUSTOMER VALUES (${id},'${name}','${PHONE}','${COUNTRY}','${CREDIT_RATING}');

-- **������ ����
UPDATE CUSTOMER SET phone = '55-123456' WHERE id=201;
UPDATE CUSTOMER SET credit_rating = 'GOOD' WHERE credit_rating = 'EXCELL';

-- **Ŀ��
COMMIT;

-- **��� ������ ����
DELETE from CUSTOMER;
TRUNCATE TABLE CUSTOMER;
/*
TRUNCATE�� �ѹ��� �ص� �ҿ��� ���� ������ ����
�ѹ��� �ϱ� ���ؼ��� DELETE from���� ���� ����
*/

-- **�ѹ�
ROLLBACK;

-- *���̺� ����
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
CONSTRAINT ���� ������ �� ���� ������ �ְ� �������� ���� �͵� ����
���̸� ��Ÿ�� �������� ������� ����� ��
cmd�� ���� ���� �־ ���� ���ڸ��� �ٷ� ���̺��� ����
cmd�� ���� �־��� ���� �ð��� ��� �帣�� ������ ���� �ʾ���
*/

-- * ���̺� ���� ����
ALTER TABLE s_emp ADD (comments_two varchar2(255));
/*
varchar2Ÿ���� comments2���� �߰�
*/

ALTER TABLE s_emp MODIFY (comments_two varchar2(100));
/*
comments2���� Ÿ���� ����
255�ڸ����� 100�ڸ��� ����
*/
























