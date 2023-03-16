-- * ���̺� �˻�
-- ** ��翭 �˻�
SELECT *
FROM HR.EMPLOYEES;

-- ** Ư���� �˻�
SELECT EMPLOYEE_ID , FIRST_NAME 
FROM HR.EMPLOYEES ;

-- ** �ߺ��� ���� �˻�
SELECT DISTINCT DEPARTMENT_ID
FROM HR.EMPLOYEES ;

-- *** ����
CREATE TABLE HR.EX_DISTINCT_TWO(
    COL_FIR VARCHAR2(10),
    COL_SEC VARCHAR2(10)
);

DROP TABLE HR.EX_DISTINCT_TWO;

INSERT INTO HR.EX_DISTINCT_TWO VALUES('${COL_FIR}', '${COL_SEC}');

SELECT  *
FROM HR.EX_DISTINCT_TWO;

SELECT DISTINCT COL_FIR, COL_SEC 
FROM HR.EX_DISTINCT_TWO;
/*
�ߺ������Ͱ� COL_FIR, COL_SEC �� ��ο� ������ �Ǿ� 2���� ��� ���� ���ƾ� �ϳ��� ���� ������ �ȴ�.
COL_FIR�� AB, COL_SEC�� CD�� ���� 2�� �־ 1�� ���� �����Ǿ� ���´�.
 */

SELECT COL_FIR, DISTINCT COL_SEC 
FROM HR.EX_DISTINCT_TWO;
/*
������ ���´�.
��, DISTINCT�� ���� �������� ��� �� �� ���ٴ� ���� Ȯ���ߴ�.
 */

-- ** ���ǿ� �´� �����͸� �˻�
SELECT *
FROM HR.EMPLOYEES 
WHERE DEPARTMENT_ID = 50;

SELECT EMPLOYEE_ID , LAST_NAME , PHONE_NUMBER , DEPARTMENT_ID 
FROM HR.EMPLOYEES 
WHERE DEPARTMENT_ID IN (50,90);

SELECT EMPLOYEE_ID , FIRST_NAME , LAST_NAME , PHONE_NUMBER , DEPARTMENT_ID 
FROM HR.EMPLOYEES 
WHERE INITCAP(FIRST_NAME) = 'David';

SELECT FIRST_NAME
FROM HR.EMPLOYEES 
WHERE UPPER(FIRST_NAME) = 'DAVID';

SELECT FIRST_NAME
FROM HR.EMPLOYEES 
WHERE INITCAP(FIRST_NAME) = 'DAvid';
/*
= �� ��ҹ��ڸ� �����ϹǷ� INITCAP, UPPER, LOWER �� �Լ��� �� ����Ͽ� �˻��� �ؾ� �Ѵ�.
 */

SELECT lower(FIRST_NAME)
FROM HR.EMPLOYEES ;

-- ** ��¥ Ÿ�� �˻�
SELECT HIRE_DATE
FROM HR.EMPLOYEES 
WHERE HIRE_DATE = '2006-04-06';
/*
NLS_DATE_FORMAT�� ������ ���·� �־�� �ȴ�.
 */

-- *** NLS_DATE_FORMAT�� ������ ��¥ ����
SELECT PARAMETER, value
FROM v$nls_parameters
WHERE PARAMETER = 'NLS_DATE_FORMAT';

-- *** NLS_DATE_FORMAT�� ����
ALTER SESSION SET "NLS_DATE_FORMAT"='YY-MM-DD HH:MI:SS';
ALTER SESSION SET "NLS_DATE_FORMAT"='RR/MM/DD';

SELECT SYSDATE FROM dual;
/*
NLS_DATE_FORMAT�� �ٲپ 2023-03-16 13:58:50.000�� ����
 */

CREATE TABLE HR.ex_date(
   fir_DATE DATE
);

DROP TABLE HR.ex_date;

INSERT INTO HR.ex_date VALUES('05/12/25');
INSERT INTO HR.ex_date VALUES('2005-12-25');

SELECT * FROM hr.EX_DATE;
/*
��¥ ���µ� ������� �ʰ� �� �𸣰ڴ�. ���߿� ã�ƺ���!!
 */

-- ** null �˻�
SELECT LAST_NAME , DEPARTMENT_ID 
FROM hr.EMPLOYEES 
WHERE DEPARTMENT_ID IS NULL ;

SELECT LAST_NAME , DEPARTMENT_ID 
FROM hr.EMPLOYEES 
WHERE DEPARTMENT_ID IS NOT NULL ;

-- **��������
-- *** AND
SELECT LAST_NAME , FIRST_NAME ,SALARY ,DEPARTMENT_ID 
FROM hr.EMPLOYEES
WHERE DEPARTMENT_ID = 50 AND SALARY >= 5000;
/*
DEPARTMENT_ID�� 50�̸鼭 SALARY 5000�̻��� �����͸� �˻�
 */

-- *** OR
SELECT LAST_NAME , FIRST_NAME ,SALARY ,DEPARTMENT_ID 
FROM hr.EMPLOYEES
WHERE DEPARTMENT_ID = 50 OR SALARY > 5000;
/*
DEPARTMENT_ID�� 50�̰ų� SALARY 5000�̻��� �����͸� �˻��ϹǷ�
AND���� ���� ���� row�� ��� �� ���� Ȯ�� �� �� �ִ�.
 */

-- * ���̺� ����
-- ** �ϳ��� ��(��������)
SELECT DISTINCT DEPARTMENT_ID 
FROM hr.EMPLOYEES 
ORDER BY DEPARTMENT_ID ;

-- ** �ϳ��� ��(��������)
SELECT DISTINCT DEPARTMENT_ID 
FROM hr.EMPLOYEES 
ORDER BY DEPARTMENT_ID DESC;

-- ** ���� ���� ��
SELECT FIRST_NAME , DEPARTMENT_ID
FROM hr.EMPLOYEES 
ORDER BY DEPARTMENT_ID DESC, FIRST_NAME ;
/*
ù��°�� DEPARTMENT_ID�� �������� ���� ���� ���� ��� FIRST_NAME�� ��������
 */

SELECT FIRST_NAME , DEPARTMENT_ID
FROM hr.EMPLOYEES 
ORDER BY DEPARTMENT_ID , FIRST_NAME DESC ;
/*
ù��°�� DEPARTMENT_ID�� �������� ���� ���� ���� ��� FIRST_NAME�� ��������
 */

SELECT FIRST_NAME , DEPARTMENT_ID
FROM hr.EMPLOYEES 
ORDER BY DEPARTMENT_ID DESC , FIRST_NAME DESC ;
/*
ù��°�� DEPARTMENT_ID�� �������� ���� ���� ���� ��� FIRST_NAME�� ��������
 */

-- * ������ ����
-- ** ������ ������ �̸��� �ش� ����
SELECT * FROM dictionary;

-- ** �ش� ������ ��ü�� ���� ����
SELECT *
FROM USER_OBJECTS;

-- ** HR�� ������ �ִ� ����
SELECT *
FROM dba_sys_PRIVS
WHERE grantee='HR';

-- ** SCOTT�� ������ �ִ� ���̺�
SELECT *
FROM all_tables
WHERE OWNER = 'SCOTT';

-- * ��������
-- ** 1��
SELECT FIRST_NAME ,LAST_NAME 
FROM hr.EMPLOYEES;

-- ** 2��
SELECT FIRST_NAME ,LAST_NAME 
FROM hr.EMPLOYEES
WHERE DEPARTMENT_ID = 50;

-- *** cmd�� ������ ���� ��
/*
list�� ġ��
SELECT FIRST_NAME ,LAST_NAME 
FROM hr.EMPLOYEES
WHERE DEPARTMENT_ID = 50; ���̰� �ϰ�

save REG1�� ġ�� ������ ����ȴ�.
 */

-- ** 3��
-- *** cmd�� ������ ���� ��
/*
run REG1�ϸ� ������ �ҷ��´�.
@REG1�� ġ�� ������ ����� ��µȴ�.
 */

-- ** 4��
SELECT FIRST_NAME sung ,LAST_NAME name
FROM hr.EMPLOYEES;

-- ** 5��
SELECT DISTINCT DEPARTMENT_ID 
FROM hr.EMPLOYEES;

-- ** 6��
SELECT SALARY 
FROM hr.EMPLOYEES
WHERE DEPARTMENT_ID = 50;

-- ** 7��
SELECT FIRST_NAME , SALARY  
FROM hr.EMPLOYEES
WHERE FIRST_NAME  = 'David';

-- ** 8��
SELECT FIRST_NAME , SALARY , HIRE_DATE 
FROM hr.EMPLOYEES
WHERE HIRE_DATE  > '2005-09-01'
ORDER BY HIRE_DATE ;

-- ** 9��
SELECT FIRST_NAME , SALARY , HIRE_DATE 
FROM hr.EMPLOYEES
WHERE SALARY NOT BETWEEN 5000 AND 10000
ORDER BY SALARY ;

-- ** 10��
SELECT FIRST_NAME , SALARY , DEPARTMENT_ID  
FROM hr.EMPLOYEES
WHERE FIRST_NAME LIKE '%se%';

-- ** 11��
SELECT FIRST_NAME , SALARY , DEPARTMENT_ID  
FROM hr.EMPLOYEES
WHERE FIRST_NAME LIKE '_a___';

SELECT FIRST_NAME , SALARY , DEPARTMENT_ID  
FROM hr.EMPLOYEES
WHERE FIRST_NAME LIKE 'A____';

-- * ������ INSERT �ϱ�
CREATE TABLE HR.EX_INSERT AS (SELECT * 
                                                           FROM HR.EMPLOYEES
                                                           WHERE DEPARTMENT_ID = 1000);

 DROP TABLE hr.EX_INSERT ;
 /*
 EMPLOYEES�� ������ ���� �ߴ�.
  */

ALTER TABLE HR.EX_INSERT MODIFY LAST_NAME VARCHAR2(25) NULL;
ALTER TABLE HR.EX_INSERT MODIFY EMAIL VARCHAR2(25) NULL;
ALTER TABLE HR.EX_INSERT MODIFY HIRE_DATE DATE NULL;
ALTER TABLE HR.EX_INSERT MODIFY JOB_ID VARCHAR2(10) NULL;
 /*
NOT NULL�� �Ǿ� �ִ� ������ �־ ��Ÿ���� ���� �� �־����ϴ�.
  */

INSERT INTO hr.EX_INSERT(LAST_NAME, FIRST_NAME, HIRE_DATE, MANAGER_ID, DEPARTMENT_ID)
VALUES('Hering','Elizabeth',sysdate, 108, 30);

INSERT  INTO hr.EX_INSERT(LAST_NAME, FIRST_NAME, HIRE_DATE, MANAGER_ID, DEPARTMENT_ID) 
VALUES ('${LAST_NAME}', '${FIRST_NAME}', sysdate, ${MANAGER_ID}, ${DEPARTMENT_ID});

-- * ������ UPDATE �ϱ�
UPDATE hr.EX_INSERT SET MANAGER_ID = 130 WHERE LAST_NAME = 'Hering';

-- * ������ DELETE �ϱ�
DELETE FROM hr.EX_INSERT WHERE MANAGER_ID=128;

-- * ���̺� Ȯ��
SELECT LAST_NAME, FIRST_NAME, HIRE_DATE, MANAGER_ID, DEPARTMENT_ID
FROM hr.EX_INSERT;

-- * Ʈ�����
 /*
����� �����ͺ��̽��� ���� Ʈ����� ��带 manual commit���� üũ�� ����!!
  */
INSERT  INTO hr.EX_INSERT(LAST_NAME, FIRST_NAME, HIRE_DATE, MANAGER_ID, DEPARTMENT_ID) 
VALUES ('${LAST_NAME}', '${FIRST_NAME}', sysdate, ${MANAGER_ID}, ${DEPARTMENT_ID});

DELETE FROM hr.EX_INSERT WHERE MANAGER_ID=115;

UPDATE hr.EX_INSERT SET DEPARTMENT_ID = 200 WHERE FIRST_NAME ='Kim';

 /*
commit �̳� DCL, DDL���� �����Ű�� �ʴ� �̻� ��ȭ�� �����ʹ� ���� �� �� �ִ�.
  */

-- *�ܺκ��� �����ϱ�
INSERT  INTO REGIONS(region_id, REGION_NAME) VALUES (${region_id}, '${region_name}');
SELECT * FROM hr.REGIONS ;
/*
cmd������ INSERT  INTO REGIONS(region_id, REGION_NAME) VALUES (&region_id, '&region_name');�� �ؾ��ϴµ�
���������� �� �ǹǷ� https://digndig.kr/sql/2021/10/06/SQL_BindingVariables.html �� ã�ƺ� ��� $�� �̿��� ���ε� ����� ã��
���� ���� ���� �߰��� => ��, ���������� �������� �׾� �ø��� ����
*/

-- *��������
-- ** 1��
CREATE TABLE customer
(ID NUMBER(4) CONSTRAINT customer_id_pk PRIMARY KEY,
 NAME varchar(40),
 PHONE varchar(40),
 COUNTRY varchar(40),
 CREDIT_RATING varchar(40));

DELETE from CUSTOMER;
/*
DML��
���̺� ���� �����͸� ����
 */

DROP TABLE CUSTOMER;
/*
DDL��
���̺� ��ü�� ����
 */

-- *** ���̺� Ȯ��
SELECT * FROM CUSTOMER ;

-- ** 2��
INSERT INTO CUSTOMER VALUES (201,'Unisports','55-206610','Sao Paolo ,Brazil','EXCELL');

-- ** 3�� 
INSERT INTO CUSTOMER(id,phone,CREDIT_RATING,NAME,COUNTRY) VALUES (202,'81-20101','POOR','OJ Atheletics','Osaka, Japan');

-- ** 4��
SELECT * FROM CUSTOMER ;

-- ** 5��
UPDATE customer SET phone = '55-123456' WHERE id=201;

-- ** 6��
INSERT INTO CUSTOMER VALUES (206,'Sportique','33-225720','Cannes, France','EXCELL');
INSERT INTO CUSTOMER VALUES (214,'Ojibway Retail','1-716-555','Buffalo, new york, USA','GOOD');
INSERT INTO CUSTOMER VALUES (${id},'${name}','${PHONE}','${COUNTRY}','${CREDIT_RATING}');

-- ** 7��
UPDATE CUSTOMER SET credit_rating = 'GOOD' WHERE credit_rating = 'EXCELL';

-- ** 8��
COMMIT;

-- ** 9��
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

SELECT * FROM s_emp;

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

-- * ������ �������� �߰�
ALTER TABLE s_emp ADD CONSTRAINT s_emp_manager_id_fk FOREIGN KEY (manager_id) REFERENCES s_emp(id);
/*
������ ������ ������ s_emp�� id�� manager_id�� ���� �ٸ� Ÿ���̶�
�׷��� manager_id�� number���� charŸ������ ����
 */

ALTER TABLE s_emp MODIFY (manager_id varchar2(7));
ALTER TABLE s_emp ADD CONSTRAINT s_emp_manager_id_fk FOREIGN KEY (manager_id) REFERENCES s_emp(id);
/*
Ÿ���� �Ȱ��� ���� �������� ������ ������ �ʰ� �ٷ� ������ ��
s_emp�� manager_id�� s_emp�� id���� ���� �Ͽ� ����
 */

-- * ������ �������� ����
ALTER TABLE s_emp DROP CONSTRAINT s_emp_manager_id_fk;
/*
alter table [���̺��] drop constraint �������Ǹ�;
 */

-- * ���̺��� ������� Ȯ��
describe user_constraints;
/*
���������� �߸��� �����̶�� ����� ����� �ȵ�
 */

SELECT * FROM USER_constraints;
SELECT * FROM USER_cons_columns;

-- * �� ����
CREATE VIEW empvu10
AS SELECT id, last_name, title
FROM S_EMP 
WHERE dept_id='10';
/*
���̸��� s_emp�� �����ϰ� ����
 */

CREATE VIEW empvu20(id_number, emplooyee,job)
AS SELECT id, last_name, title
FROM S_EMP;
/*
���̸��� id_number, emplooyee,job�� ����Ǿ� ����
 */

CREATE VIEW empvu30
AS SELECT id, FIRST_NAME FIRST, last_name LAST, SALARY "MONTHLY_SALARY"
FROM S_EMP;
/*
���������� �̸��� ����� ���� ���� ����
 */

SELECT * from empvu30;
/*
��� �� �̻� �並 ���ؼ� �� �� ���� �����Ϳ� ���ؼ��� update, delate�� ���� �� �� ���� ��
 */

-- * ������ ����
-- ** ���� 1
DROP SEQUENCE s_dept_id;

CREATE SEQUENCE s_dept_id
MAXVALUE 9999999
INCREMENT BY 10
START WITH 10
NOCACHE
NOORDER
NOCYCLE;
/*
CACHE: �޸𸮿� �������� �̸� �Ҵ�, �⺻���� 20
ORDER: 
CYCLE: �ִ밪 ���޽� �ּҰ����� �ٽ� �Ҵ�
NOCYCLE: �ִ밪 ���޽� ������ ���� ����
 */

CREATE TABLE s_demp AS SELECT * FROM DEPARTMENTS WHERE DEPARTMENT_ID = 300;
/*
������ �غ������� DEPARTMENTS���̺��� ������ ����
 */

INSERT INTO s_demp VALUES(s_dept_id.NEXTVAL, 'abc', 1, 2700); --������
INSERT INTO s_demp VALUES(s_dept_id.CURRVAL, 'pc', 3, 1400); -- ���簪
/*
�������� �̿��Ͽ� s_dept_id���� ���� ������ ������� ���� �Էµ�
 */

SELECT * FROM s_demp;
DROP TABLE s_demp;

-- ** ���� 2
CREATE TABLE ex_sequ_tb(
   num NUMBER(4)
 );

SELECT * FROM ex_sequ_tb;

DELETE FROM ex_sequ_tb WHERE num = 6;

SELECT * FROM all_sequences WHERE SEQUENCE_OWNER='HR';
/*
�������� ������ �˱� ���� �� ���� �ִ� ���̺� ����
 */

-- *** ������ ����
CREATE SEQUENCE ex_sequ
MAXVALUE 10
MINVALUE 1
INCREMENT BY 1
noorder
nocache
cycle;

-- *** ����
ALTER SEQUENCE ex_sequ
ORDER;

-- *** ����
DROP SEQUENCE ex_sequ;

-- *** ���̺� �� �߰�
INSERT INTO ex_sequ_tb VALUES(ex_sequ.nextval);
INSERT INTO ex_sequ_tb VALUES(ex_sequ.currval);

-- * ������ ����
/*
start with �ɼ��� ������ �Ұ���
 */
ALTER SEQUENCE s_dept_id
MAXVALUE 900
MINVALUE 800
INCREMENT BY 1

-- * �ε���
/*
�ε����� �����Ͱ� ��ġ�� ����� ������ ���� ������ �ּҷ�
�������� �ּ� ROWID�� ������ �ֽ��ϴ�.
 */
CREATE INDEX s_emp_last_name_i
ON s_emp(last_name);

CREATE UNIQUE INDEX s_customer_phone_uk
ON customer(phone);
/*
�����̺ҿ� ��ȭ��ȣ�� �ߺ��� �� ����.
primaryŰ�� unique���� ������ �ָ� unique index�� �ڵ������� ����� ��
 */

-- * �ε��� Ȯ��
/*
�ش� ����ڰ� ���� ��� index�� ���� ������ ���� ������ ���� �����̴�.
 */
SELECT * FROM all_constraints WHERE table_name='S_EMP';

SELECT * FROM all_all_tables WHERE OWNER = 'HR';

SELECT * FROM user_objects;

SELECT * FROM all_indexes WHERE table_name = 'S_EMP'; 
/*
�� �빮�ڷ� �Է��� ����!!!
s_emp�� �ϸ� �ƹ��͵� ��µ��� �ʴ´�.
 */

-- * ��������
-- ** 1��
CREATE SEQUENCE S_MY_CUSTOMER_ID
START WITH 300
INCREMENT BY 1
nocache;

-- ** 2��
CREATE TABLE ex_custo(
    num NUMBER(4),
    name varchar2(50)
);

SELECT * FROM ex_custo;

DROP TABLE ex_custo;

INSERT INTO ex_custo VALUES(S_MY_CUSTOMER_ID.nextval,'gy');
INSERT INTO ex_custo VALUES(S_MY_CUSTOMER_ID.nextval,'zb');
INSERT INTO ex_custo VALUES(S_MY_CUSTOMER_ID.nextval,'apple');

-- ** 3��
SELECT * FROM all_indexes WHERE OWNER='HR' AND table_name = 'CUSTOMER' ORDER BY index_name;
/*
HR�� CUSTOMER���̺� �ִ� ��� �ε��� ������ Ȯ�� �� �� �ִ�.
�ε����� �̸����� id, name, phone�� �ε����� ���� �Ǵ� �͵� Ȯ���� �� �ִ�.
 */

CREATE INDEX CUSTOMER_NAME_I
ON customer(name);
/*
customer���̺��� name���� �̿��ؼ� �ε����� �����ߴ�.
 */

SELECT rowid, ID FROM customer;
SELECT rowid, name FROM customer;
SELECT rowid, COUNTRY  FROM customer;
/*
�ε����� rowid(�ּ�)�� Ű���� Ȯ���غ���!!
COUNTRY�� �ε����� ���µ��� ���´�.
�ε����� ����ٰ� ����Ǵ� ������ �ƴ϶� �Ϲ������� �� �� �� �ִٴ� ���� Ȯ�� �߽��ϴ�.
 */

SELECT /*+ index(customer CUSTOMER_NAME_I) */*
FROM customer;
/*
�ε����� ��Ʈ �ּ��� �ϴ� �Ŷ�µ� �� �𸣰ڴ�.....
 */

-- ** 4��
DROP INDEX CUSTOMER_NAME_I;

-- * ����� ���� ����
-- ** ����
/*
grant system_priv(role) to user(role, public) with admin option

public�� ��� ����ڿ��� �ο��� �� ���
with admin option ������ �ο� �޴� ����ڵ� �ٸ� ����ڿ��� �ش� ������ �� �� �ֵ��� �� �� �ֽ��ϴ�.
with admin option �� ������ ȸ���ϸ� �ش� ������ ���Ѹ� ȸ���Ѵ�.
with grant option ���ѵ� admin option�� ������ ������ ȸ���ϸ� ��� ������ ������ �־��� �ٸ� �������� ���ѵ� ��� ȸ��
 */

-- ** ���� ����
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
/*
���� ������ �۵����� ������ user���� �տ� c##�� �ٿ��־�� �Ѵ�.
����Ŭ 12c�� �Ѿ���鼭 �̷��� �ؾ� ���� ����ڸ� ���������ϴ�.
 */

GRANT unlimited tablespace TO gy;
/*
���̺� ���� �ޱ� ���� tablespace�� ���� ������ �������� �ְ��� �� �� ���
�� ������ ������ �ٸ� DB���� �����͸� ���� �� ����.
 */

CREATE USER gy IDENTIFIED BY 9333;

-- ** �ý��� ���� �ο�
GRANT CREATE SESSION, CREATE TABLE TO gy;
/*
GY����ڿ��� SESSION�� TABLE�� ������ �� �ִ� ������ �־���.
 */

GRANT ALTER any TABLE TO gy;
/*
���̺��� ����(alter)�� �� �ִ� ������ gy���� �Ѱ��־���.
 */

-- ** �ý��� ���� ���� Ȯ��
SELECT *
FROM sys.dba_sys_privs
WHERE grantee IN ('GY');

SELECT *
FROM dba_sys_privs
WHERE grantee IN ('GY');
/*
sys.�� �տ� ���̰ų� �� ���̰ų� ������ ��°��� ���´�.
 */

-- ** ��ü ���� �ֱ�
GRANT  SELECT, INSERT, UPDATE ON CUSTOMER TO GY;
/*
GY������ CUSTOMER���̺� select, insert, update�� ���� ������ �����.
 */

GRANT  SELECT, INSERT, UPDATE ON employees TO GY WITH GRANT OPTION;
/*
GY������ employees���̺� SELECT, INSERT, UPDATE�Ҽ� �ְ� �̰��� �ٸ� ����ڿ��� �� �� �� �ִ�.
GY������ ������ ȸ�� ���ϸ� GY������ �ٸ� �������� �־��� ��� ���ѵ� ��� ȸ���Ѵ�.
 */

-- ** �߸��� ��ü ���� �ֱ�
CREATE SEQUENCE ex_sequ1
START WITH 1
INCREMENT BY 2
MAXVALUE 10;

GRANT  delete ON ex_sequ1 TO GY;
/*
�������� select�� alter�� ����� �� �ִٰ� �����޼����� ����
ORA-02205: SELECT �� ALTER ���Ѹ��� �������� ���Ͽ� ����� �� �ֽ��ϴ�.
 */

SELECT * FROM dba_tab_privs;
SELECT * FROM dba_tab_privs WHERE OWNER = 'HR';
SELECT * FROM dba_tab_privs WHERE GRANTEE = 'GY';
/*
dba_tab_privs_made���� all_�̳� user_�δ� Ȯ�� �� �� ������ �ٸ� ������� ���̺��� Ȯ�� ���� �ϴ�.
OWNER�� HR�� ������ �־��� ������ GY�� �ؾ��Ѵ�.
GRANTEE�� ������ ���� ����̾��� ������ GY�� �Ѵ�.
 */

SELECT * FROM user_tab_privs_made;
SELECT * FROM user_tab_privs_made WHERE OWNER = 'GY';
/*
user_tab_privs_mad�� �ش� ������ �ο��� ������ ������
 */

SELECT * FROM all_tab_privs_made;
SELECT * FROM all_tab_privs_made WHERE TABLE_NAME  = '';
/*
all_tab_privs_made�� ��� ������ �ο��� ������ ������
 */

SELECT * FROM all_tab_privs_recd WHERE GRANTEE = 'HR';
/*
all_tab_privs_recd�� ��� ������ �ο��� ������
 */

SELECT * FROM all_tab_privs  WHERE TABLE_NAME  = 'employees';
SELECT * FROM all_tab_privs  WHERE TABLE_NAME  = 'employees';
/*
all_tab_privs�� ��� ������ �ο��� ������
 */

-- * �ó��
/*
synonym�� �����ͺ��̽� ���� ��ü�鿡 ���� �����̴�
�ܼ��� �����̱� ������ ���ٸ� ���� ������ �ʿ��� ���� �ƴ϶� ������ ���� �������� �����Ѵ�.
���Ȼ�, ������ ������ ���Ǿ�����.
 */

-- ** �ó�� ����
CREATE synonym ex_syno_cuto
FOR gy.customer;
/*
�⺻������ private���·� ���������.
 */

DROP SYNONYM ex_syno_cuto;

CREATE public synonym ex_pu_syno_cuto
FOR gy.customer;
/*
public���� ����� ��� ��Ű������ �ش� �ó���� ����� �� �ִ�.
 */

DROP public SYNONYM ex_syno_cuto;

-- * ���� ����
-- ** �ý��� ���� Ȯ��
SELECT * FROM dba_sys_privs WHERE GRANTEE = 'GY';

-- ** �ý��� ���� ����
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
REVOKE CREATE TABLE, ALTER ANY TABLE, CREATE SESSION FROM gy;
/*
ALTER SESSION SET "_ORACLE_SCRIPT"=true;�� ���� ������ ����������
ORA-65092: ���� �ٸ� ������~~�̶�� ���� �޼����� ���´�.
 */

-- ** ��ü ���� Ȯ��
SELECT * FROM DBA_TAB_PRIVS WHERE grantee =  'GY';
/*
HR�� GY���� �� ������ CUSTOMER���̺��� SELECT, INSERT, UPDATE �� 3���� ���´�.
 */

-- ** ��ü ���� ����
REVOKE  SELECT, INSERT, UPDATE ON CUSTOMER FROM GY;

-- * role�� ���� ���� ����
/*
role�� �ý��� ���Ѱ� ��ü ������ �������� �̷���� �־� �� ������ ������ � ����ڳ� �ٸ�  role�� �� �� �ִ�.
role�� Ư�� ����ڿ� ���� ���� �� �� ����.
role�� ������ �������� ��ϵȴ�.
 */

-- ** ��й�ȣ ���� role ����
CREATE ROLE ex_role1;

-- ** ��й�ȣ �ִ� role ����
CREATE ROLE ex_role2 IDENTIFIED BY 9333;

-- ** ������ ������ ���� role ����
CREATE ROLE ex_role3 IDENTIFIED externally;

-- ** role���� ������ �ο��ϱ�
GRANT CREATE synonym, CREATE TABLE TO ex_role2;
/*
ex_role2 role�� CREATE synonym, CREATE TABLE 2���� ������ �ο��ߴ�.
 */

-- ** ���� role�� ����ڿ��� �ο�
GRANT ex_role2 TO gy;

-- ** role Ȯ��
SELECT * FROM dba_roles WHERE ROLE = upper('ex_role2');
/*
���� role�� �� �� �ִ�.
 */

SELECT * FROM dba_role_privs WHERE grantee = 'GY';
/*
����ڿ��� �ο��� role���� ����� �ִ��� �� �� ����
GY���� EX_ROLE2�� �����Ǿ� �ִ� ���� Ȯ��
 */

SELECT * FROM dba_sys_privs WHERE grantee = 'GY';
/*
GY����ڿ��� �ο��� ���� Ȯ��
role�� �߰� �Ȱ��� �̰����� Ȯ���� �Ұ��ϴ�.
 */

SELECT * FROM role_sys_privs WHERE ROLE = upper('ex_role2');
/*
ex_role2�� �ο��� ������ Ȯ���� �� �ִ�.
 */

-- ** role ����
DROP ROLE ex_role1;
DROP ROLE ex_role2;
DROP ROLE ex_role3;

-- * ��������
-- ** 1��
-- *** orclpok
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

CREATE USER gy1 IDENTIFIED BY 9333;
DROP USER gy1 CASCADE;
/*
CASCADE�� pk�� ���� ���� �����ϸ� fk�� ����� ���� ���ÿ� �����ϴ� �ɼ��̴�.
username�̳� ���õ� ��� �����ͺ��̽� ��Ű���� ������ �������κ��� �����ǰ� ��Ű�� ��ü�� ���������� �����ȴ�.
 */

GRANT CREATE SESSION TO gy1;
/*
CREATE SESSION�� ������ ������ ���̵�� ����� �˾Ƶ� �����ͺ��̽� ������ �ȵȴ�.
 */

GRANT SELECT ON hr.REGIONS TO gy1 WITH GRANT OPTION;
REVOKE SELECT ON hr.REGIONS FROM GY1;
/*
�������̺� ���� select ������ gy����ڿ��� �ο��ߴ�.
WITH GRANT OPTION���� gy1�� �ٸ� ����ڿ��Ե� �ڽ��� ���� ������ �ο� �� �� �ִ�.
 */

SELECT * FROM dba_tab_privs WHERE grantee = 'GY1';

-- ** 2��
-- *** orclpok
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

CREATE USER gy2 IDENTIFIED BY 9333;
DROP USER gy2 CASCADE;
/*
orclpok2������ ������ ��� ���� ���� �Ұ�
 */

-- *** orclpok2
GRANT SELECT ON hr.REGIONS TO gy2;
REVOKE SELECT ON hr.REGIONS FROM gy2;

SELECT * FROM user_tab_privs WHERE grantee = 'GY2';
/*
orclpok���� gy1�� ���ѱ����� revoke ��Ű�� GY2�� ���ѵ� �������.
 */

SELECT * FROM hr.REGIONS;
/*
������ ����� orclpok2�� ���� �����Ű�� �ȴ�.
������ ������ REGIONS�� select �ǰ�
������ ������ �����޼����� ���´�.
 */

-- ** 3��
-- *** orclpok
GRANT CREATE synonym TO gy1;
/*
gy1�� �ó�� ������ �� �ִ� ���� �ο�
 */

SELECT * FROM dba_sys_privs WHERE grantee='GY1';
SELECT * FROM dba_tab_privs WHERE grantee='GY1';

-- *** orclpok2
CREATE synonym gy1_syno_regions FOR hr.regions;
DROP synonym gy1_syno_regions;
/*
gy1 synonyms ������ gy1_syno_regions�� ������
 */

SELECT * FROM gy1_syno_regions;

-- ** 4��
-- *** orclpok
SELECT * FROM gy1.gy1_syno_regions;
/*
SYSYEM������ gy1�� �ִ� �ó���� �׼��� �� �� �ִ�.
 */

-- ** 5��
-- *** orclpok
REVOKE SELECT ON hr.REGIONS FROM gy1;

-- ** 6��
-- *** orclpok
SELECT * FROM hr.REGIONS;
SELECT * FROM gy1.gy1_syno_regions;

-- *** orclpok2
SELECT * FROM hr.REGIONS;
SELECT * FROM gy1.gy1_syno_regions;

-- ** 7��
-- *** orclpok2
DROP synonym gy1.gy1_syno_regions;

-- * ������ �����ϱ�
SELECT LAST_NAME , SALARY, COMMISSION_PCT , SALARY * COMMISSION_PCT / 100 COMMISSION
FROM hr.EMPLOYEES 
WHERE FIRST_NAME  = 'David'
ORDER BY COMMISSION DESC;
/*
�ش� ���������� ������� COMMISSION���� ������ �� �� �ִ�.
DESC�� ������������ null���� ���� ���� ������ �ϰ�
DESC�� ������ �⺻������ ������������ null���� ����  �ؿ� ������ �ȴ�.

LAST_NAME / SALARY / COMMISSION_PCT / COMMISSION �� 4���� ���� ���´�.
�� �� COMMISSION�� ��Ģ������ ���� ���� ������� ���� ���̸��� ������ ���̴�.
FIRST_NAME �� David �̸鼭 COMMISSION ���� �������� ������ �ߴ�.
 */

SELECT LAST_NAME , SALARY, COMMISSION_PCT , SALARY * COMMISSION_PCT / 100 COMMISSION
FROM hr.EMPLOYEES 
WHERE FIRST_NAME  = 'David' AND SALARY * COMMISSION_PCT / 100 >= 5
ORDER BY COMMISSION DESC;
/*
WHERE FIRST_NAME  = 'David' AND COMMISSION >= 5 �� ORA-00904 ��� '�������� �ĺ���'��� ���� �޼����� ���´�.
where�������� ���ο� �� �̸��� ���� �ʵ��� ��������!!!
 */

-- ** where������ ���ο� �� ��� ���1
SELECT LAST_NAME , SALARY, COMMISSION_PCT , COMMISSION
FROM (SELECT FIRST_NAME, LAST_NAME , SALARY, COMMISSION_PCT , SALARY * COMMISSION_PCT / 100 COMMISSION
             FROM hr.EMPLOYEES)
WHERE FIRST_NAME  = 'David' AND COMMISSION >= 5
ORDER BY 4 DESC;
/*
���ο� ���̺��� ����� ���ο� ���� where������ ����ϸ� �ȴ�.
order by ���� ���ο� ���̸����ε� ���ڷε� ������ �����մϴ�.
���⼭ 4�� ù��° SELECT�� ������ ������.
 */

SELECT  * , SALARY * COMMISSION_PCT / 100 COMMISSION FROM hr.EMPLOYEES;
/*
ORA-00923: FROM Ű���尡 �ʿ��� ��ġ�� �����ϴ�. ���� �޼����� ���´�.
�̰� ���߿� ã�ƺ���
 */

-- ** where������ ���ο� �� ��� ���2
SELECT a.LAST_NAME, a.SALARY , a.COMMISSION_PCT  , b.commission
FROM hr.EMPLOYEES a , (SELECT EMPLOYEE_ID , SALARY * COMMISSION_PCT / 100 COMMISSION  FROM hr.EMPLOYEES) b
WHERE a.EMPLOYEE_ID = b.EMPLOYEE_ID AND b.COMMISSION >= 5 AND a.FIRST_NAME = 'David'
ORDER BY 4 DESC;

-- * ���� ���� �Լ� ����ϱ�
-- ** round �ݿø�
SELECT LAST_NAME , SALARY sal_y, SALARY /12 sal_m, ROUND(SALARY/12) sal_m_rou
FROM HR.EMPLOYEES;
/*
ROUND �Լ��� �Ἥ �ݿø��� �� ����� ����ߴ�.
 */

SELECT LAST_NAME , SALARY sal_y, SALARY /12 sal_m, ROUND(SALARY/12, -2) sal_m_rou
FROM HR.EMPLOYEES;
/*
���� �ڸ����� �ݿø� �� ����� �����ش�.
round(����, �ݿø��� ��ġ)
�ݿø��� ��ġ�� ���� ���� ��쿡�� �⺻���� 0�̴�.
 */

SELECT LAST_NAME , SALARY sal_y, SALARY /12 sal_m, ROUND(SALARY/12) sal_m_rou
FROM HR.EMPLOYEES
WHERE ROUND(SALARY/12) >= 1000;
/*
����� ������� ������ 1200�̻��� �͵鸸 �����ߴ�.
 */

SELECT LAST_NAME , SALARY sal_y, SALARY /12 sal_m, ROUND(SALARY/12) sal_m_rou
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 50;
/*
DEPARTMENT_ID �� 50�� �͵鸸 �����ߴ�.
 */

SELECT DISTINCT DEPARTMENT_ID 
FROM HR.EMPLOYEES
ORDER BY DEPARTMENT_ID;
/*
DEPARTMENT_ID �� 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, null�� �̷���� �ִ�.
 */

SELECT LAST_NAME , SALARY sal_y, SALARY /12 sal_m, trunc(SALARY/12) sal_m_tru
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 50;
/*
trunc �Լ��� �ش� �ڸ� �����δ� �� �ڸ��� ������ �⺻���� 0�̴�.
 */

SELECT LAST_NAME , SALARY sal_y, SALARY /12 sal_m, trunc(SALARY/12) sal_m_tru
FROM HR.EMPLOYEES
WHERE trunc(SALARY/12) >= 1416;
/*
trunc �Լ��� �ش� �ڸ� �����δ� �� �ڸ��� ������ �⺻���� 0�̴�.
 */

SELECT LAST_NAME , SALARY sal_y, SALARY /12 sal_m, trunc(SALARY/12, -2) sal_m_tru
FROM HR.EMPLOYEES
WHERE trunc(SALARY/12, -2) >= 1416;
/*
���� �ڸ����� �ڸ��� ������ 1416���� ���Դ� King�� 1400���� ���� ���� ������ ���� �ʾҴ�.
 */

CREATE TABLE num_mod(
    fir_num NUMBER(10),
    sec_num NUMBER(10)
);

DROP TABLE num_mod;
/*
mod�Լ��� ����ϱ� ���� ���� ���̺��� �����Ͽ����ϴ�.
 */

INSERT INTO num_mod VALUES ('${fir_num}', '${sec_num}');
/*
�ƹ� ���ڳ� �Է��Ͽ� ���ڵ带 �߰�����
 */

SELECT FIR_NUM , SEC_NUM , trunc(FIR_NUM/SEC_NUM) quotient , MOD(FIR_NUM,SEC_NUM) remainder FROM num_mod;
/*
quotient ������ ���� ���� remainder ������ �������� ���� �ȴ�.
 */

-- * null���� ���
/*
null���� ��Ģ������ �ص� null�� ����
null + 4 = null, null * 3 = null, null - 2 = null, null / 1 = null
 */

SELECT LAST_NAME , SALARY , COMMISSION_PCT , SALARY * COMMISSION_PCT /100 COMMISSION
FROM hr.EMPLOYEES 
WHERE SALARY >=1500;
/*
COMMISSION_PCT ���� null���� �־ COMMISSION���� null�� ������ �ֵ��� �ִ�.
 */

-- ** nvl�Լ�
SELECT LAST_NAME , SALARY , COMMISSION_PCT , SALARY * nvl(COMMISSION_PCT, 0) / 100 commission
FROM hr.EMPLOYEES;
/*
nvl(A, B) => A�� null�̸� B�� ��ġ�Ѵ�.
�� ������������ null�� 0���� ��ġ�Ǿ� ����� �Ǿ� COMMISSION_PCT�� null�̸� commission���� 0�� �ȴ�.
 */

-- * date Ÿ���� ����
/*
DD: ���� => 23
DY: ���� 3���� => SUN
DAY: ���� => SUNDAY
DDSP: ���ڿ��� => TWELVE
MM: �� ���� => 03
MON: �� 3���� => JAN
MONTH: �� => JANUARY
YY: �� 2�ڸ� ���� => 93
YYYY: �� 4�ڸ� ���� => 1993
HH:MI:SS: �ð�:��:�� => 12:02:34
Fm: FILE MODE
HH24: 24�ð� ǥ�� => 23
TH: ���� ���� => 4TH
  * ���� �Ҷ� th ���̴� ���� ������� ��
AM or PM: ���� / ����
 */

SELECT LAST_NAME , HIRE_DATE , HIRE_DATE + 90 "$review$"
FROM hr.EMPLOYEES;
/*
"$review$"ó�� ���̸��� Ư�����ڸ� �ְ� ���� ���� ""�ȿ� �Է��� ����
 */

SELECT LAST_NAME , HIRE_DATE , trunc((sysdate - HIRE_DATE) / 7) WEEKS
FROM hr.EMPLOYEES
ORDER BY weeks DESC;
/*
������ �ϸ� ���� ���� ���� ��� �Ǿ����� �� �� �ְ� ���� �󸶳� �� �ߴ����� �� �� �ִ�.
 */

-- * dateŸ�� ���� �Լ�
SELECT LAST_NAME , HIRE_DATE , ADD_MONTHS(HIRE_DATE, 6) review 
FROM hr.EMPLOYEES
WHERE DEPARTMENT_ID = 50;
/*
ADD_MONTHS(��¥, ���� ���� ����)
 */

SELECT LAST_NAME , HIRE_DATE , LAST_DAY(HIRE_DATE) "#pay ck"
FROM hr.EMPLOYEES;
/*
LAST_DAY(��¥)�� �ش� ��¥�� �ش���� ������ ���� ��ȯ�Ѵ�.
��, LAST_DAY("2016-04-18")�̸� 2016�� 4�� 30���� ��ȯ�� �ش�.
 */

SELECT LAST_NAME , HIRE_DATE , LAST_DAY(HIRE_DATE) "#pay ck"
FROM hr.EMPLOYEES;
/*
LAST_DAY(��¥)�� �ش� ��¥�� �ش���� ������ ���� ��ȯ�Ѵ�.
 */

SELECT LAST_NAME , HIRE_DATE ,  NEXT_DAY((HIRE_DATE+14), '��') find_days
FROM hr.EMPLOYEES;
/*
NEXT_DAY(��������, ã�� ����)�� �������ڰ� ���� ���� �̵��� �������� ���� ���� ����� ������ ��¥�� ã���ش�.
SUN, SUNDAY���� �μ��� ������ ������ ���´�.
 */

SELECT LAST_NAME , HIRE_DATE ,  MONTHS_BETWEEN(SYSDATE , HIRE_DATE) "MONTHS TENURE"
FROM hr.EMPLOYEES;
/*
���̸��� ����� ""�ȿ� ����!!!
LAST_DAY(��¥)�� �ش� ��¥�� �ش���� ������ ���� ��ȯ�Ѵ�.
 */

SELECT FIRST_NAME , TO_CHAR(HIRE_DATE, 'YYYY:MM:DD') for_date FROM hr.EMPLOYEES ;
SELECT FIRST_NAME , TO_CHAR(HIRE_DATE, 'YYYY MONTH') for_date FROM hr.EMPLOYEES ;
SELECT FIRST_NAME , TO_CHAR(HIRE_DATE, 'DD"���� ��¥ ����:" DDSP') for_date FROM hr.EMPLOYEES ;
/*
��¥ Ÿ���� ""���� ������ ������ ���´�.
 */

-- * DATE ���� ���߱�
SELECT ID , LAST_NAME , START_DATE , DEPT_ID 
FROM hr.S_EMP ;
/*
MMDDYYHHMISS�� MONTH DD, YYYY�� �־ s_emp�� START_DATE�� YYYY-MM-DD HH:MI:SS ���·� ���´�.
 */

INSERT INTO hr.s_emp(ID, LAST_NAME , START_DATE , DEPT_ID) VALUES('100', 'smith', to_date('070393083000','MMDDYYHHMISS'), 50);
INSERT INTO hr.s_emp(id, LAST_NAME , START_DATE , DEPT_ID) VALUES('200', 'kogi', to_date('7�� 07, 1993','MONTH DD, YYYY'), 10);
/*
� ��¥ ���·� ���� �ִ� s_emp���� YYYY-MM-DD HH:MI:SS���·� ��� ����.
 */

DELETE FROM hr.s_emp WHERE id = 100;

SELECT ID , LAST_NAME , TO_CHAR(START_DATE, 'MMDDYYHHMISS')  , DEPT_ID 
FROM hr.S_EMP ;

SELECT ID , LAST_NAME , TO_CHAR(START_DATE, 'MONTH DD, YYYY')  , DEPT_ID 
FROM hr.S_EMP ;
/*
TO_CHAR�� ��� YYYY-MM-DD HH:MI:SS���� �ٸ� ���·� ������ �ȴ�.
 */

-- * ���ڿ� �����ϱ�
/*
||: ���ڿ��� ��ģ��.
INITCAP: �ձ��� �ϳ��� �빮�ڷ�
UPPER: ��� ���ڸ� �빮�ڷ�
LOWER: ��� ���ڸ� �ҹ��ڷ�
SUBSTR: �ش� ��ġ���� ���ڸ��� ���ڿ��� ����
LENGTH: ���ڿ��� ����
 */

-- ** ||
SELECT FIRST_NAME || LAST_NAME "full name", SALARY
FROM hr.EMPLOYEES ;
/*
FIRST_NAME �� LAST_NAME ���� ���ļ� full name ���� �������.
FIRST_NAME �� LAST_NAME �� ������� �پ �̸��� ������ �ȴ�.
 */

SELECT FIRST_NAME || ' ' || LAST_NAME "full name", SALARY
FROM hr.EMPLOYEES ;
/*
|| ' ' || ���� ���� �̸��� ������ ����� �� �� �ִ�.
 */

-- ** INITCAP
SELECT FIRST_NAME , EMAIL  ,INITCAP(EMAIL) email_tcap
FROM hr.EMPLOYEES ;
/*
�� �빮�ڿ��� EMAIL �� email_tcap ������ �ձ��ڸ� �빮�ڷ� �ٲ� ���� Ȯ�� �� �� �ִ�.
 */

-- ** UPPER
SELECT FIRST_NAME , UPPER(FIRST_NAME) FIRST_NAME_upper
FROM hr.EMPLOYEES ;

-- ** LOWER
SELECT FIRST_NAME , LOWER(FIRST_NAME) FIRST_NAME_lower
FROM hr.EMPLOYEES ;

-- ** SUBSTR
SELECT FIRST_NAME , SUBSTR(FIRST_NAME, 1, 3) FIRST_NAME_SUBSTR
FROM hr.EMPLOYEES ;
/*
ù��° ���ں��� ���̰� 3�� ���ڿ��� �����Ѵ�.
 */

-- ** SUBSTR
SELECT FIRST_NAME , SUBSTR(FIRST_NAME, -3, 3) FIRST_NAME_SUBSTR
FROM hr.EMPLOYEES ;
/*
�ڿ��� ���� 3��° ���ڿ��� ���� 3 ������ ���ڿ��� �����Ѵ�.
 */

-- ** LENGTH
SELECT FIRST_NAME , LENGTH(FIRST_NAME) FIRST_NAME_LENGTH
FROM hr.EMPLOYEES ;

SELECT FIRST_NAME || ' ' || LAST_NAME full_name , LENGTH(FIRST_NAME || ' ' || LAST_NAME) full_name_LENGTH
FROM hr.EMPLOYEES ;
/*
���ο� ���� ���ؼ��� �Լ��� �� �� �ִ�.
 */

SELECT FIRST_NAME , SALARY 
FROM hr.EMPLOYEES 
WHERE LENGTH(FIRST_NAME)=7;
/*
where�������� �Լ��� ��밡���ϴ�.
FIRST_NAME �� 7������ �������� ������ �� ���� �� ���� �ֽ��ϴ�.
 */

-- * �׷��Լ�
SELECT AVG(salary) average, max(SALARY) maximom, min(SALARY) minimum, sum(SALARY) total
FROM hr.EMPLOYEES;
/*
�Լ����� �̿��Ͽ� ��� / �ִ밪 / �ּҰ� / ���� �� �� �� �� �ֽ��ϴ�.
 */

SELECT '$ ' || AVG(salary) average, '$ ' || max(SALARY) maximom, '$ ' || min(SALARY) minimum, '$ ' || sum(SALARY) total
FROM hr.EMPLOYEES;
/*
��µ� �� �տ��� $ǥ�ð� �ִ�.
 */

SELECT '$ ' || round(AVG(salary),3) average, '$ ' || max(SALARY) maximom, '$ ' || min(SALARY) minimum, '$ ' || sum(SALARY) total
FROM hr.EMPLOYEES;
/*
����� �Ҽ����� �ʹ� ���� �Ҽ����� 3�� ���̵��� �ݿø� ���״�.
 */

SELECT round(AVG(salary),3) average
FROM (SELECT AVG(salary) average
            FROM hr.EMPLOYEES;)
WHERE SALARY > 2 * AVG(salary),3;
/*
�׷��Լ��� where������ ����� �� ����.
 */

SELECT DEPARTMENT_ID, AVG(SALARY) avg_salary
FROM hr.EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) > 8000
ORDER BY DEPARTMENT_ID;
/*
�μ����� �׷��� ��� ��� ������ 8000�̻��̸� DEPARTMENT_ID �� ������������ �����͸� ����
 */

SELECT count(*)
FROM hr.EMPLOYEES;

SELECT count(COMMISSION_PCT)
FROM hr.EMPLOYEES;
/*
107�� ���� �̾��µ� 35�� �� �� ������ COMMISSION_PCT���� NULL���� �־��� �����̴�.
null���� count �����ʴ´�.
 */

SELECT count(DEPARTMENT_ID)
FROM hr.EMPLOYEES;
/*
�μ� ID�� ���� ���� 1���� �ִ�;
 */

SELECT DISTINCT DEPARTMENT_ID FROM hr.EMPLOYEES;
/*
null ���� 12���� ���δٸ� �μ� ID�� �ִ�.
 */

SELECT count(DISTINCT DEPARTMENT_ID)
FROM hr.EMPLOYEES;
/*
null�� count�� ���Ե��� �ʾ� 11����� ���´�.
 */

-- * group by��
SELECT DEPARTMENT_ID ,count(DEPARTMENT_ID)
FROM hr.EMPLOYEES 
WHERE DEPARTMENT_ID IN (40,50,60)
GROUP BY DEPARTMENT_ID;
/*
DEPARTMENT_ID�� 40 / 50 / 60�� �μ����� ���ϴ� ����� ��� ���ΰ��� Ȯ���ϱ� ���� ������ �ۼ��Ͽ����ϴ�.
 */

SELECT MANAGER_ID , DEPARTMENT_ID ,count(DEPARTMENT_ID)
FROM hr.EMPLOYEES 
GROUP BY MANAGER_ID , DEPARTMENT_ID
ORDER BY manager_id, DEPARTMENT_ID;
/*
GROUP BY ���� ���� ���� ���� ��� �� �� �ִ�.
manager_id, DEPARTMENT_ID �� ������������ �����Ͽ����ϴ�.
where���� ���� ��ü �����͸� ������ �����Ͽ����ϴ�.
 */

SELECT DEPARTMENT_ID , round(avg(salary)) dept_total_sal
FROM hr.EMPLOYEES 
GROUP BY DEPARTMENT_ID 
HAVING sum(salary)>50000
ORDER BY dept_total_sal DESC;
/*
�μ��� �� �������� 50000�̻��� �μ��� ��� ������ ���ΰ��� ��Ÿ��
 */

-- * ��������
-- ** 1��
SELECT max(salary) maxsal, min(SALARY) minsal
FROM hr.EMPLOYEES;

-- ** 2��
SELECT DEPARTMENT_ID , COUNT(DEPARTMENT_ID) "Number Of Department"
FROM hr.EMPLOYEES
GROUP BY DEPARTMENT_ID 
ORDER BY DEPARTMENT_ID ;

-- ** 3��
SELECT MANAGER_ID , COUNT(MANAGER_ID) "Number Of Maneger"
FROM hr.EMPLOYEES
GROUP BY MANAGER_ID  
ORDER BY MANAGER_ID ;

-- ** 4��
SELECT MANAGER_ID , COUNT(MANAGER_ID) "Number Of Maneger"
FROM hr.EMPLOYEES
GROUP BY MANAGER_ID
HAVING count(MANAGER_ID)>=5
ORDER BY "Number Of Maneger" DESC;

-- ** 5��
SELECT DEPARTMENT_ID , count(DEPARTMENT_ID ) "NUMBER of department" , sum(SALARY) total
FROM hr.EMPLOYEES 
GROUP BY DEPARTMENT_ID 
HAVING sum(SALARY)>=50000
ORDER BY total;

-- ** 6��
SELECT DEPARTMENT_ID , round(avg(salary),3) avg_sal
FROM hr.EMPLOYEES 
GROUP BY DEPARTMENT_ID 
ORDER BY DEPARTMENT_ID;

-- * join
SELECT emp.LAST_NAME , emp.DEPARTMENT_ID , dep.DEPARTMENT_NAME 
FROM hr.EMPLOYEES emp, hr.DEPARTMENTS dep
WHERE emp.DEPARTMENT_ID = dep.DEPARTMENT_ID;
/*
null ���� ������� 107������ 106���� �Ǿ����ϴ�.
 */

SELECT emp.LAST_NAME , emp.DEPARTMENT_ID , dep.DEPARTMENT_NAME 
FROM hr.EMPLOYEES emp, hr.DEPARTMENTS dep
WHERE emp.DEPARTMENT_ID = dep.DEPARTMENT_ID AND emp.LAST_NAME = 'Matos';
/*
null ���� ������� 107������ 106���� �Ǿ����ϴ�.
 */

-- ** null ������ Ȯ��
SELECT FIRST_NAME , LAST_NAME , DEPARTMENT_ID , SALARY 
FROM hr.EMPLOYEES 
WHERE DEPARTMENT_ID is null ;
/*
1���� ���� DEPARTMENT_ID�� null�̶�� ���´�.
 */

-- ** 1:M ����
SELECT loc.COUNTRY_ID , loc.CITY , dep.DEPARTMENT_ID , dep.DEPARTMENT_NAME 
FROM hr.DEPARTMENTS dep,  hr.LOCATIONS  loc
WHERE dep.LOCATION_ID = loc.LOCATION_ID;
/*
�ϳ��� LOCATION�� �������� �μ��� ���� �Ѵ�.

�� ���ÿ� � �μ��� �ִ��� Ȯ�� �� �� �ִ�.
 */

SELECT loc.COUNTRY_ID , loc.CITY , dep.DEPARTMENT_ID , dep.DEPARTMENT_NAME 
FROM hr.DEPARTMENTS dep,  hr.LOCATIONS  loc
WHERE dep.LOCATION_ID = loc.LOCATION_ID AND loc.CITY in (initcap('TORONTO'), initcap('SEATTLE'));
/*
�ϳ��� LOCATION�� �������� �μ��� ���� �Ѵ�.

US�� Seattle���� 10. 30, 90, 100, 110, 120, 130, 140, 150, ,160, 170, 180, 190, 200, 210, 220, 230. 240. 250. 260. 270�� 21�� �μ��� �ְ�
CA�� Toronto���� 20 �̶�� �μ� 1�� ���̴�.
 */

-- * outer join
SELECT *
FROM hr.LOCATIONS ;
/*
���� DEPARTMENTS�� 23�� 6��
 */

SELECT *
FROM hr.DEPARTMENTS;
/*
���� DEPARTMENTS�� 27�� 4��
 */

-- * left outer join
SELECT * 
FROM hr.LOCATIONS loc LEFT OUTER JOIN hr.DEPARTMENTS dep
           ON loc.LOCATION_ID = dep.LOCATION_ID;
/*
���� ����� �Ϲ����� ���
43�� 10���� �ȴ�.
 */

SELECT *
FROM hr.LOCATIONS loc,  hr.DEPARTMENTS  dep
WHERE loc.LOCATION_ID = dep.LOCATION_ID(+);
/*
43�� 10���� �ȴ�.
������ LOCATION_ID�� ��ø�ǹǷ� ������ ���־�� ���� ���Ұ� ���Ƽ� �ؿ� ������ �ۼ� �ߴ�.

(+)�� �ִ� ���� (+)���� �ʿ� �ٴ´ٰ� ���� �ϸ� ����.
 */

-- * right outer join
SELECT * 
FROM hr.LOCATIONS loc RIGHT OUTER JOIN hr.DEPARTMENTS dep
           ON loc.LOCATION_ID = dep.LOCATION_ID;
/*
���� ����� �Ϲ����� ���
27�� 10���� �ȴ�.
 */

SELECT *
FROM hr.LOCATIONS loc,  hr.DEPARTMENTS  dep
WHERE loc.LOCATION_ID(+) = dep.LOCATION_ID;
/*
27�� 10��

(+)�� ���ʿ� �����Ƿ� �����ʿ� �ִ� DEPARTMENTS�� �ٴ� ���̴�.
 */

-- * full outer join
SELECT * 
FROM hr.LOCATIONS loc FULL OUTER JOIN hr.DEPARTMENTS dep
           ON loc.LOCATION_ID = dep.LOCATION_ID;
 /*
43�� 10���� �ȴ�.
(+)�� ���ʿ��� ���� ��� ����� �� ��
 */

 -- * �ߺ����� ������ left outer join
SELECT loc.*, dep.DEPARTMENT_ID , dep.DEPARTMENT_NAME , dep.MANAGER_ID 
FROM hr.LOCATIONS loc,  hr.DEPARTMENTS  dep
WHERE loc.LOCATION_ID = dep.LOCATION_ID(+);

-- * ��������
SELECT *
FROM hr.EMPLOYEES emp_a , hr.EMPLOYEES emp_b
WHERE emp_a.EMPLOYEE_ID = emp_b.EMPLOYEE_ID;
 /*
������ ���̺��� 2�� �̻� ���� �ڽŰ� �ڽſ� ���� �����ϴ� ����
 */

-- * ���� ��
CREATE VIEW empdepvu AS SELECT emp.LAST_NAME , emp.DEPARTMENT_ID , dep.DEPARTMENT_NAME 
												 FROM hr.EMPLOYEES emp , hr.DEPARTMENTS dep
												 WHERE emp.DEPARTMENT_ID  = dep.DEPARTMENT_ID;
 /*
inner join�� ���̺��� empdepv��� ��� �����Ͽ����ϴ�.

 */

-- ** �� �ҷ�����
SELECT * FROM empdepvu;








-- ** 
SELECT 1 FROM hr.EMPLOYEES emp , hr.DEPARTMENTS dep WHERE emp.DEPARTMENT_ID = dep.DEPARTMENT_ID;










































