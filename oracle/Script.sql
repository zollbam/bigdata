-- * 테이블 검색
-- ** 모든열 검색
SELECT *
FROM HR.EMPLOYEES;

-- ** 특정열 검색
SELECT EMPLOYEE_ID , FIRST_NAME 
FROM HR.EMPLOYEES ;

-- ** 중복열 빼고 검색
SELECT DISTINCT DEPARTMENT_ID
FROM HR.EMPLOYEES ;

-- *** 예제
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
중복데이터가 COL_FIR, COL_SEC 열 모두에 적용이 되어 2개열 모두 값이 같아야 하나의 열만 나오게 된다.
COL_FIR가 AB, COL_SEC가 CD인 열이 2개 있어서 1개 행은 삭제되어 나온다.
 */

SELECT COL_FIR, DISTINCT COL_SEC 
FROM HR.EX_DISTINCT_TWO;
/*
오류가 나온다.
즉, DISTINCT는 따로 뺴내서는 사용 할 수 없다는 것을 확인했다.
 */

-- ** 조건에 맞는 데이터만 검색
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
= 은 대소문자를 구분하므로 INITCAP, UPPER, LOWER 등 함수를 잘 사용하여 검색을 해야 한다.
 */

SELECT lower(FIRST_NAME)
FROM HR.EMPLOYEES ;

-- ** 날짜 타입 검색
SELECT HIRE_DATE
FROM HR.EMPLOYEES 
WHERE HIRE_DATE = '2006-04-06';
/*
NLS_DATE_FORMAT로 지정된 형태로 넣어야 된다.
 */

-- *** NLS_DATE_FORMAT에 지정된 날짜 형태
SELECT PARAMETER, value
FROM v$nls_parameters
WHERE PARAMETER = 'NLS_DATE_FORMAT';

-- *** NLS_DATE_FORMAT을 변경
ALTER SESSION SET "NLS_DATE_FORMAT"='YY-MM-DD HH:MI:SS';
ALTER SESSION SET "NLS_DATE_FORMAT"='RR/MM/DD';

SELECT SYSDATE FROM dual;
/*
NLS_DATE_FORMAT을 바꾸어도 2023-03-16 13:58:50.000로 나옴
 */

CREATE TABLE HR.ex_date(
   fir_DATE DATE
);

DROP TABLE HR.ex_date;

INSERT INTO HR.ex_date VALUES('05/12/25');
INSERT INTO HR.ex_date VALUES('2005-12-25');

SELECT * FROM hr.EX_DATE;
/*
날짜 형태도 변경되지 않고 잘 모르겠다. 나중에 찾아보자!!
 */

-- ** null 검색
SELECT LAST_NAME , DEPARTMENT_ID 
FROM hr.EMPLOYEES 
WHERE DEPARTMENT_ID IS NULL ;

SELECT LAST_NAME , DEPARTMENT_ID 
FROM hr.EMPLOYEES 
WHERE DEPARTMENT_ID IS NOT NULL ;

-- **논리연산자
-- *** AND
SELECT LAST_NAME , FIRST_NAME ,SALARY ,DEPARTMENT_ID 
FROM hr.EMPLOYEES
WHERE DEPARTMENT_ID = 50 AND SALARY >= 5000;
/*
DEPARTMENT_ID가 50이면서 SALARY 5000이상인 데이터를 검색
 */

-- *** OR
SELECT LAST_NAME , FIRST_NAME ,SALARY ,DEPARTMENT_ID 
FROM hr.EMPLOYEES
WHERE DEPARTMENT_ID = 50 OR SALARY > 5000;
/*
DEPARTMENT_ID가 50이거나 SALARY 5000이상인 데이터를 검색하므로
AND보다 많은 양의 row가 출력 된 것을 확인 할 수 있다.
 */

-- * 테이블 정렬
-- ** 하나의 열(오름차순)
SELECT DISTINCT DEPARTMENT_ID 
FROM hr.EMPLOYEES 
ORDER BY DEPARTMENT_ID ;

-- ** 하나의 열(내림차순)
SELECT DISTINCT DEPARTMENT_ID 
FROM hr.EMPLOYEES 
ORDER BY DEPARTMENT_ID DESC;

-- ** 여러 개의 열
SELECT FIRST_NAME , DEPARTMENT_ID
FROM hr.EMPLOYEES 
ORDER BY DEPARTMENT_ID DESC, FIRST_NAME ;
/*
첫번째로 DEPARTMENT_ID를 내림차순 같은 값이 있을 경우 FIRST_NAME로 오름차순
 */

SELECT FIRST_NAME , DEPARTMENT_ID
FROM hr.EMPLOYEES 
ORDER BY DEPARTMENT_ID , FIRST_NAME DESC ;
/*
첫번째로 DEPARTMENT_ID를 오름차순 같은 값이 있을 경우 FIRST_NAME로 내림차순
 */

SELECT FIRST_NAME , DEPARTMENT_ID
FROM hr.EMPLOYEES 
ORDER BY DEPARTMENT_ID DESC , FIRST_NAME DESC ;
/*
첫번째로 DEPARTMENT_ID를 내림차순 같은 값이 있을 경우 FIRST_NAME로 내림차순
 */

-- * 데이터 사전
-- ** 데이터 사전의 이름과 해당 설명
SELECT * FROM dictionary;

-- ** 해당 유저의 객체에 대한 정보
SELECT *
FROM USER_OBJECTS;

-- ** HR이 가지고 있는 권한
SELECT *
FROM dba_sys_PRIVS
WHERE grantee='HR';

-- ** SCOTT이 가지고 있는 테이블
SELECT *
FROM all_tables
WHERE OWNER = 'SCOTT';

-- * 연습문제
-- ** 1번
SELECT FIRST_NAME ,LAST_NAME 
FROM hr.EMPLOYEES;

-- ** 2번
SELECT FIRST_NAME ,LAST_NAME 
FROM hr.EMPLOYEES
WHERE DEPARTMENT_ID = 50;

-- *** cmd로 계정을 접속 후
/*
list를 치면
SELECT FIRST_NAME ,LAST_NAME 
FROM hr.EMPLOYEES
WHERE DEPARTMENT_ID = 50; 보이게 하고

save REG1을 치면 파일이 저장된다.
 */

-- ** 3번
-- *** cmd로 계정을 접속 후
/*
run REG1하면 파일을 불러온다.
@REG1을 치면 파일의 결과가 출력된다.
 */

-- ** 4번
SELECT FIRST_NAME sung ,LAST_NAME name
FROM hr.EMPLOYEES;

-- ** 5번
SELECT DISTINCT DEPARTMENT_ID 
FROM hr.EMPLOYEES;

-- ** 6번
SELECT SALARY 
FROM hr.EMPLOYEES
WHERE DEPARTMENT_ID = 50;

-- ** 7번
SELECT FIRST_NAME , SALARY  
FROM hr.EMPLOYEES
WHERE FIRST_NAME  = 'David';

-- ** 8번
SELECT FIRST_NAME , SALARY , HIRE_DATE 
FROM hr.EMPLOYEES
WHERE HIRE_DATE  > '2005-09-01'
ORDER BY HIRE_DATE ;

-- ** 9번
SELECT FIRST_NAME , SALARY , HIRE_DATE 
FROM hr.EMPLOYEES
WHERE SALARY NOT BETWEEN 5000 AND 10000
ORDER BY SALARY ;

-- ** 10번
SELECT FIRST_NAME , SALARY , DEPARTMENT_ID  
FROM hr.EMPLOYEES
WHERE FIRST_NAME LIKE '%se%';

-- ** 11번
SELECT FIRST_NAME , SALARY , DEPARTMENT_ID  
FROM hr.EMPLOYEES
WHERE FIRST_NAME LIKE '_a___';

SELECT FIRST_NAME , SALARY , DEPARTMENT_ID  
FROM hr.EMPLOYEES
WHERE FIRST_NAME LIKE 'A____';

-- * 데이터 INSERT 하기
CREATE TABLE HR.EX_INSERT AS (SELECT * 
                                                           FROM HR.EMPLOYEES
                                                           WHERE DEPARTMENT_ID = 1000);

 DROP TABLE hr.EX_INSERT ;
 /*
 EMPLOYEES의 구조만 복사 했다.
  */

ALTER TABLE HR.EX_INSERT MODIFY LAST_NAME VARCHAR2(25) NULL;
ALTER TABLE HR.EX_INSERT MODIFY EMAIL VARCHAR2(25) NULL;
ALTER TABLE HR.EX_INSERT MODIFY HIRE_DATE DATE NULL;
ALTER TABLE HR.EX_INSERT MODIFY JOB_ID VARCHAR2(10) NULL;
 /*
NOT NULL로 되어 있는 열들이 있어서 열타입을 변경 해 주었습니다.
  */

INSERT INTO hr.EX_INSERT(LAST_NAME, FIRST_NAME, HIRE_DATE, MANAGER_ID, DEPARTMENT_ID)
VALUES('Hering','Elizabeth',sysdate, 108, 30);

INSERT  INTO hr.EX_INSERT(LAST_NAME, FIRST_NAME, HIRE_DATE, MANAGER_ID, DEPARTMENT_ID) 
VALUES ('${LAST_NAME}', '${FIRST_NAME}', sysdate, ${MANAGER_ID}, ${DEPARTMENT_ID});

-- * 데이터 UPDATE 하기
UPDATE hr.EX_INSERT SET MANAGER_ID = 130 WHERE LAST_NAME = 'Hering';

-- * 데이터 DELETE 하기
DELETE FROM hr.EX_INSERT WHERE MANAGER_ID=128;

-- * 테이블 확인
SELECT LAST_NAME, FIRST_NAME, HIRE_DATE, MANAGER_ID, DEPARTMENT_ID
FROM hr.EX_INSERT;

-- * 트랜잭션
 /*
상단의 데이터베이스를 눌러 트랜잭션 모드를 manual commit으로 체크를 하자!!
  */
INSERT  INTO hr.EX_INSERT(LAST_NAME, FIRST_NAME, HIRE_DATE, MANAGER_ID, DEPARTMENT_ID) 
VALUES ('${LAST_NAME}', '${FIRST_NAME}', sysdate, ${MANAGER_ID}, ${DEPARTMENT_ID});

DELETE FROM hr.EX_INSERT WHERE MANAGER_ID=115;

UPDATE hr.EX_INSERT SET DEPARTMENT_ID = 200 WHERE FIRST_NAME ='Kim';

 /*
commit 이나 DCL, DDL문을 실행시키지 않는 이상 변화된 데이터는 나만 볼 수 있다.
  */

-- *외부변수 삽입하기
INSERT  INTO REGIONS(region_id, REGION_NAME) VALUES (${region_id}, '${region_name}');
SELECT * FROM hr.REGIONS ;
/*
cmd에서는 INSERT  INTO REGIONS(region_id, REGION_NAME) VALUES (&region_id, '&region_name');로 해야하는데
디비버에서는 안 되므로 https://digndig.kr/sql/2021/10/06/SQL_BindingVariables.html 를 찾아본 결과 $를 이용한 바인드 방법을 찾음
제일 위에 행이 추가됨 => 즉, 위에서부터 차근차근 쌓아 올리는 구조
*/

-- *연습문제
-- ** 1번
CREATE TABLE customer
(ID NUMBER(4) CONSTRAINT customer_id_pk PRIMARY KEY,
 NAME varchar(40),
 PHONE varchar(40),
 COUNTRY varchar(40),
 CREDIT_RATING varchar(40));

DELETE from CUSTOMER;
/*
DML문
테이블 안의 데이터만 삭제
 */

DROP TABLE CUSTOMER;
/*
DDL문
테이블 자체를 삭제
 */

-- *** 테이블 확인
SELECT * FROM CUSTOMER ;

-- ** 2번
INSERT INTO CUSTOMER VALUES (201,'Unisports','55-206610','Sao Paolo ,Brazil','EXCELL');

-- ** 3번 
INSERT INTO CUSTOMER(id,phone,CREDIT_RATING,NAME,COUNTRY) VALUES (202,'81-20101','POOR','OJ Atheletics','Osaka, Japan');

-- ** 4번
SELECT * FROM CUSTOMER ;

-- ** 5번
UPDATE customer SET phone = '55-123456' WHERE id=201;

-- ** 6번
INSERT INTO CUSTOMER VALUES (206,'Sportique','33-225720','Cannes, France','EXCELL');
INSERT INTO CUSTOMER VALUES (214,'Ojibway Retail','1-716-555','Buffalo, new york, USA','GOOD');
INSERT INTO CUSTOMER VALUES (${id},'${name}','${PHONE}','${COUNTRY}','${CREDIT_RATING}');

-- ** 7번
UPDATE CUSTOMER SET credit_rating = 'GOOD' WHERE credit_rating = 'EXCELL';

-- ** 8번
COMMIT;

-- ** 9번
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

SELECT * FROM s_emp;

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

-- * 데이터 제약조건 추가
ALTER TABLE s_emp ADD CONSTRAINT s_emp_manager_id_fk FOREIGN KEY (manager_id) REFERENCES s_emp(id);
/*
오류가 나오는 이유는 s_emp의 id와 manager_id가 서로 다른 타입이라서
그러면 manager_id를 number에서 char타입으로 변경
 */

ALTER TABLE s_emp MODIFY (manager_id varchar2(7));
ALTER TABLE s_emp ADD CONSTRAINT s_emp_manager_id_fk FOREIGN KEY (manager_id) REFERENCES s_emp(id);
/*
타입을 똑같이 맞춘 다음에는 오류가 나오지 않고 바로 실행이 됨
s_emp의 manager_id는 s_emp의 id열을 참조 하여 생성
 */

-- * 데이터 제약조건 삭제
ALTER TABLE s_emp DROP CONSTRAINT s_emp_manager_id_fk;
/*
alter table [테이블명] drop constraint 제약조건명;
 */

-- * 테이블의 제약사항 확인
describe user_constraints;
/*
디비버에서는 잘못된 구문이라고 결과가 출력이 안됨
 */

SELECT * FROM USER_constraints;
SELECT * FROM USER_cons_columns;

-- * 뷰 생성
CREATE VIEW empvu10
AS SELECT id, last_name, title
FROM S_EMP 
WHERE dept_id='10';
/*
열이름은 s_emp와 동일하게 나옴
 */

CREATE VIEW empvu20(id_number, emplooyee,job)
AS SELECT id, last_name, title
FROM S_EMP;
/*
열이름이 id_number, emplooyee,job로 변경되어 나옴
 */

CREATE VIEW empvu30
AS SELECT id, FIRST_NAME FIRST, last_name LAST, SALARY "MONTHLY_SALARY"
FROM S_EMP;
/*
서브쿼리로 이름을 만들어 받을 수도 있음
 */

SELECT * from empvu30;
/*
뷰는 더 이상 뷰를 통해서 볼 수 없는 데이터에 대해서는 update, delate를 수행 할 수 없게 함
 */

-- * 시퀀스 생성
-- ** 예제 1
DROP SEQUENCE s_dept_id;

CREATE SEQUENCE s_dept_id
MAXVALUE 9999999
INCREMENT BY 10
START WITH 10
NOCACHE
NOORDER
NOCYCLE;
/*
CACHE: 메모리에 시퀀스값 미리 할당, 기본값은 20
ORDER: 
CYCLE: 최대값 도달시 최소값부터 다시 할당
NOCYCLE: 최대값 도달시 시퀀스 생성 중지
 */

CREATE TABLE s_demp AS SELECT * FROM DEPARTMENTS WHERE DEPARTMENT_ID = 300;
/*
연습을 해보기위해 DEPARTMENTS테이블의 구조만 복사
 */

INSERT INTO s_demp VALUES(s_dept_id.NEXTVAL, 'abc', 1, 2700); --다음값
INSERT INTO s_demp VALUES(s_dept_id.CURRVAL, 'pc', 3, 1400); -- 현재값
/*
시퀀스를 이용하여 s_dept_id열에 만든 시퀀스 순서대로 값이 입력됨
 */

SELECT * FROM s_demp;
DROP TABLE s_demp;

-- ** 예제 2
CREATE TABLE ex_sequ_tb(
   num NUMBER(4)
 );

SELECT * FROM ex_sequ_tb;

DELETE FROM ex_sequ_tb WHERE num = 6;

SELECT * FROM all_sequences WHERE SEQUENCE_OWNER='HR';
/*
시퀀스의 개념을 알기 위해 한 열만 있는 테이블 만듬
 */

-- *** 시퀀스 생성
CREATE SEQUENCE ex_sequ
MAXVALUE 10
MINVALUE 1
INCREMENT BY 1
noorder
nocache
cycle;

-- *** 변경
ALTER SEQUENCE ex_sequ
ORDER;

-- *** 삭제
DROP SEQUENCE ex_sequ;

-- *** 테이블에 값 추가
INSERT INTO ex_sequ_tb VALUES(ex_sequ.nextval);
INSERT INTO ex_sequ_tb VALUES(ex_sequ.currval);

-- * 시퀀스 수정
/*
start with 옵션은 수정이 불가능
 */
ALTER SEQUENCE s_dept_id
MAXVALUE 900
MINVALUE 800
INCREMENT BY 1

-- * 인덱스
/*
인덱스란 데이터가 위치한 장소의 정보를 가진 일종의 주소록
데이터의 주소 ROWID를 가지고 있습니다.
 */
CREATE INDEX s_emp_last_name_i
ON s_emp(last_name);

CREATE UNIQUE INDEX s_customer_phone_uk
ON customer(phone);
/*
고객테이불에 전화번호는 중복될 수 없다.
primary키나 unique제약 조건을 주면 unique index는 자동적으로 만들어 짐
 */

-- * 인덱스 확인
/*
해당 사용자가 만든 모든 index에 대한 정보를 가진 데이터 사전 정보이다.
 */
SELECT * FROM all_constraints WHERE table_name='S_EMP';

SELECT * FROM all_all_tables WHERE OWNER = 'HR';

SELECT * FROM user_objects;

SELECT * FROM all_indexes WHERE table_name = 'S_EMP'; 
/*
꼭 대문자로 입력을 하자!!!
s_emp로 하면 아무것도 출력되지 않는다.
 */

-- * 연습문제
-- ** 1번
CREATE SEQUENCE S_MY_CUSTOMER_ID
START WITH 300
INCREMENT BY 1
nocache;

-- ** 2번
CREATE TABLE ex_custo(
    num NUMBER(4),
    name varchar2(50)
);

SELECT * FROM ex_custo;

DROP TABLE ex_custo;

INSERT INTO ex_custo VALUES(S_MY_CUSTOMER_ID.nextval,'gy');
INSERT INTO ex_custo VALUES(S_MY_CUSTOMER_ID.nextval,'zb');
INSERT INTO ex_custo VALUES(S_MY_CUSTOMER_ID.nextval,'apple');

-- ** 3번
SELECT * FROM all_indexes WHERE OWNER='HR' AND table_name = 'CUSTOMER' ORDER BY index_name;
/*
HR의 CUSTOMER테이블에 있는 모든 인덱스 정보를 확인 할 수 있다.
인덱스의 이름으로 id, name, phone이 인덱스로 지정 되는 것도 확인할 수 있다.
 */

CREATE INDEX CUSTOMER_NAME_I
ON customer(name);
/*
customer테이블의 name열을 이용해서 인덱스를 생성했다.
 */

SELECT rowid, ID FROM customer;
SELECT rowid, name FROM customer;
SELECT rowid, COUNTRY  FROM customer;
/*
인덱스의 rowid(주소)와 키값을 확인해보자!!
COUNTRY는 인덱스가 없는데도 나온다.
인덱스가 생겼다고 실행되는 쿼리가 아니라 일반적으로 다 볼 수 있다는 것을 확인 했습니다.
 */

SELECT /*+ index(customer CUSTOMER_NAME_I) */*
FROM customer;
/*
인덱스의 힌트 주석을 하는 거라는데 잘 모르겠다.....
 */

-- ** 4번
DROP INDEX CUSTOMER_NAME_I;

-- * 사용자 권한 제어
-- ** 문법
/*
grant system_priv(role) to user(role, public) with admin option

public은 모든 사용자에세 부여할 때 사용
with admin option 권한을 부여 받는 사용자도 다른 사용자에게 해당 권한을 줄 수 있도록 할 수 있습니다.
with admin option 은 권한을 회수하면 해당 유저의 권한만 회수한다.
with grant option 권한도 admin option과 같지만 권한을 회수하면 헤당 유저가 권한을 주었던 다른 유저들의 권한도 모두 회수
 */

-- ** 유저 생성
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
/*
위의 쿼리를 작동하지 않으면 user네임 앞에 c##을 붙여주어야 한다.
오라클 12c로 넘어오면서 이렇게 해야 공통 사용자를 생성가능하다.
 */

GRANT unlimited tablespace TO gy;
/*
테이블 등을 받기 위해 tablespace에 대한 무제한 사용권한을 주고자 할 때 사용
이 쿼리가 없으면 다른 DB에서 데이터를 받을 수 없다.
 */

CREATE USER gy IDENTIFIED BY 9333;

-- ** 시스템 권한 부여
GRANT CREATE SESSION, CREATE TABLE TO gy;
/*
GY사용자에게 SESSION과 TABLE을 생성할 수 있는 권한을 주었다.
 */

GRANT ALTER any TABLE TO gy;
/*
테이블을 변경(alter)할 수 있는 권한을 gy에게 넘겨주었다.
 */

-- ** 시스템 권한 정보 확인
SELECT *
FROM sys.dba_sys_privs
WHERE grantee IN ('GY');

SELECT *
FROM dba_sys_privs
WHERE grantee IN ('GY');
/*
sys.을 앞에 붙이거나 안 붙이거나 동일한 출력값이 나온다.
 */

-- ** 객체 권한 주기
GRANT  SELECT, INSERT, UPDATE ON CUSTOMER TO GY;
/*
GY유저의 CUSTOMER테이블에 select, insert, update에 대한 권한을 얻었다.
 */

GRANT  SELECT, INSERT, UPDATE ON employees TO GY WITH GRANT OPTION;
/*
GY유저의 employees테이블에 SELECT, INSERT, UPDATE할수 있고 이것을 다른 사용자에게 줄 수 도 있다.
GY유저의 권한을 회수 당하면 GY유저가 다른 유저에게 주었던 모든 권한도 모두 회수한다.
 */

-- ** 잘못된 객체 권한 주기
CREATE SEQUENCE ex_sequ1
START WITH 1
INCREMENT BY 2
MAXVALUE 10;

GRANT  delete ON ex_sequ1 TO GY;
/*
시퀀스는 select과 alter만 사용할 수 있다고 오류메세지가 나옴
ORA-02205: SELECT 와 ALTER 권한만이 시퀀스에 대하여 사용할 수 있습니다.
 */

SELECT * FROM dba_tab_privs;
SELECT * FROM dba_tab_privs WHERE OWNER = 'HR';
SELECT * FROM dba_tab_privs WHERE GRANTEE = 'GY';
/*
dba_tab_privs_made으로 all_이나 user_로는 확인 할 수 없었던 다른 사용자의 테이블이 확인 가능 하다.
OWNER은 HR이 권한을 주었기 때문에 GY로 해야한다.
GRANTEE는 권한을 받은 사람이었기 때문에 GY로 한다.
 */

SELECT * FROM user_tab_privs_made;
SELECT * FROM user_tab_privs_made WHERE OWNER = 'GY';
/*
user_tab_privs_mad는 해당 유저가 부여한 권한을 보여줌
 */

SELECT * FROM all_tab_privs_made;
SELECT * FROM all_tab_privs_made WHERE TABLE_NAME  = '';
/*
all_tab_privs_made는 모든 유저가 부여한 권한을 보여줌
 */

SELECT * FROM all_tab_privs_recd WHERE GRANTEE = 'HR';
/*
all_tab_privs_recd는 모든 유저가 부여한 보여줌
 */

SELECT * FROM all_tab_privs  WHERE TABLE_NAME  = 'employees';
SELECT * FROM all_tab_privs  WHERE TABLE_NAME  = 'employees';
/*
all_tab_privs는 모든 유저가 부여한 보여줌
 */

-- * 시노님
/*
synonym은 데이터베이스 내의 객체들에 대한 별명이다
단순히 별명이기 때문에 별다른 저장 공간이 필요한 것이 아니라 데이터 사전 정보에만 저장한다.
보안상, 편리함의 이유로 사용되어진다.
 */

-- ** 시노님 생성
CREATE synonym ex_syno_cuto
FOR gy.customer;
/*
기본적으로 private형태로 만들어진다.
 */

DROP SYNONYM ex_syno_cuto;

CREATE public synonym ex_pu_syno_cuto
FOR gy.customer;
/*
public으로 만들면 모든 스키마에서 해당 시노님을 사용할 수 있다.
 */

DROP public SYNONYM ex_syno_cuto;

-- * 권한 삭제
-- ** 시스템 권한 확인
SELECT * FROM dba_sys_privs WHERE GRANTEE = 'GY';

-- ** 시스템 권한 삭제
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
REVOKE CREATE TABLE, ALTER ANY TABLE, CREATE SESSION FROM gy;
/*
ALTER SESSION SET "_ORACLE_SCRIPT"=true;을 하지 않으면 오류가나옴
ORA-65092: 서로 다른 범위로~~이라는 오류 메세지가 나온다.
 */

-- ** 객체 권한 확인
SELECT * FROM DBA_TAB_PRIVS WHERE grantee =  'GY';
/*
HR이 GY한테 준 권한이 CUSTOMER테이블에서 SELECT, INSERT, UPDATE 이 3개가 나온다.
 */

-- ** 객체 권한 삭제
REVOKE  SELECT, INSERT, UPDATE ON CUSTOMER FROM GY;

-- * role을 통한 궈한 제어
/*
role은 시스템 권한과 객체 권한의 조합으로 이루어져 있어 이 권한의 조합을 어떤 사용자나 다른  role에 줄 수 있다.
role은 특정 사용자에 의해 소유 될 수 없다.
role은 데이터 사전에만 기록된다.
 */

-- ** 비밀번호 없는 role 생성
CREATE ROLE ex_role1;

-- ** 비밀번호 있는 role 생성
CREATE ROLE ex_role2 IDENTIFIED BY 9333;

-- ** 윈도우 인증을 통한 role 생성
CREATE ROLE ex_role3 IDENTIFIED externally;

-- ** role에게 권한을 부여하기
GRANT CREATE synonym, CREATE TABLE TO ex_role2;
/*
ex_role2 role에 CREATE synonym, CREATE TABLE 2개의 권한을 부여했다.
 */

-- ** 만든 role을 사용자에게 부여
GRANT ex_role2 TO gy;

-- ** role 확인
SELECT * FROM dba_roles WHERE ROLE = upper('ex_role2');
/*
만든 role을 볼 수 있다.
 */

SELECT * FROM dba_role_privs WHERE grantee = 'GY';
/*
사용자에게 부여된 role에는 어떤것이 있는지 알 수 있음
GY에는 EX_ROLE2가 지정되어 있는 것을 확인
 */

SELECT * FROM dba_sys_privs WHERE grantee = 'GY';
/*
GY사용자에게 부여된 권한 확인
role로 추가 된것은 이것으로 확인이 불가하다.
 */

SELECT * FROM role_sys_privs WHERE ROLE = upper('ex_role2');
/*
ex_role2에 부여된 권한을 확인할 수 있다.
 */

-- ** role 삭제
DROP ROLE ex_role1;
DROP ROLE ex_role2;
DROP ROLE ex_role3;

-- * 연습문제
-- ** 1번
-- *** orclpok
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

CREATE USER gy1 IDENTIFIED BY 9333;
DROP USER gy1 CASCADE;
/*
CASCADE는 pk를 가진 값을 삭제하면 fk로 연결된 값도 동시에 삭제하는 옵션이다.
username이나 관련된 모든 데이터베이스 스키마가 데이터 사전으로부터 삭제되고 스키마 객체조 물리적으로 삭제된다.
 */

GRANT CREATE SESSION TO gy1;
/*
CREATE SESSION의 권한이 없으면 아이디와 비번을 알아도 데이터베이스 연결이 안된다.
 */

GRANT SELECT ON hr.REGIONS TO gy1 WITH GRANT OPTION;
REVOKE SELECT ON hr.REGIONS FROM GY1;
/*
지역테이블에 대한 select 권한을 gy사용자에게 부여했다.
WITH GRANT OPTION으로 gy1은 다른 사용자에게도 자신이 가진 권한을 부여 할 수 있다.
 */

SELECT * FROM dba_tab_privs WHERE grantee = 'GY1';

-- ** 2번
-- *** orclpok
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

CREATE USER gy2 IDENTIFIED BY 9333;
DROP USER gy2 CASCADE;
/*
orclpok2에서는 권한이 없어서 유저 생성 불가
 */

-- *** orclpok2
GRANT SELECT ON hr.REGIONS TO gy2;
REVOKE SELECT ON hr.REGIONS FROM gy2;

SELECT * FROM user_tab_privs WHERE grantee = 'GY2';
/*
orclpok에서 gy1에 대한권한을 revoke 시키면 GY2의 권한도 사라진다.
 */

SELECT * FROM hr.REGIONS;
/*
디비버에 연결된 orclpok2에 들어가서 실행시키면 된다.
권한이 있으면 REGIONS가 select 되고
권한이 없으면 오류메세지가 나온다.
 */

-- ** 3번
-- *** orclpok
GRANT CREATE synonym TO gy1;
/*
gy1에 시노님 생성할 수 있는 권한 부여
 */

SELECT * FROM dba_sys_privs WHERE grantee='GY1';
SELECT * FROM dba_tab_privs WHERE grantee='GY1';

-- *** orclpok2
CREATE synonym gy1_syno_regions FOR hr.regions;
DROP synonym gy1_syno_regions;
/*
gy1 synonyms 폴더에 gy1_syno_regions가 생성됨
 */

SELECT * FROM gy1_syno_regions;

-- ** 4번
-- *** orclpok
SELECT * FROM gy1.gy1_syno_regions;
/*
SYSYEM에서도 gy1에 있는 시노님을 액세스 할 수 있다.
 */

-- ** 5번
-- *** orclpok
REVOKE SELECT ON hr.REGIONS FROM gy1;

-- ** 6번
-- *** orclpok
SELECT * FROM hr.REGIONS;
SELECT * FROM gy1.gy1_syno_regions;

-- *** orclpok2
SELECT * FROM hr.REGIONS;
SELECT * FROM gy1.gy1_syno_regions;

-- ** 7번
-- *** orclpok2
DROP synonym gy1.gy1_syno_regions;

-- * 데이터 가공하기
SELECT LAST_NAME , SALARY, COMMISSION_PCT , SALARY * COMMISSION_PCT / 100 COMMISSION
FROM hr.EMPLOYEES 
WHERE FIRST_NAME  = 'David'
ORDER BY COMMISSION DESC;
/*
해당 쿼리문에서 만들어진 COMMISSION열로 정렬을 할 수 있다.
DESC는 내림차순으로 null값이 제일 위로 나오게 하고
DESC가 없으면 기본값으로 오름차순으로 null값이 제일  밑에 나오게 된다.

LAST_NAME / SALARY / COMMISSION_PCT / COMMISSION 의 4개의 열이 나온다.
이 중 COMMISSION은 사칙연산을 통한 새로 만들어진 열로 열이름을 지정한 것이다.
FIRST_NAME 이 David 이면서 COMMISSION 으로 내림차순 정렬을 했다.
 */

SELECT LAST_NAME , SALARY, COMMISSION_PCT , SALARY * COMMISSION_PCT / 100 COMMISSION
FROM hr.EMPLOYEES 
WHERE FIRST_NAME  = 'David' AND SALARY * COMMISSION_PCT / 100 >= 5
ORDER BY COMMISSION DESC;
/*
WHERE FIRST_NAME  = 'David' AND COMMISSION >= 5 는 ORA-00904 라는 '부적합한 식별자'라는 오류 메세지가 나온다.
where절에서는 새로운 열 이름을 쓰지 않도록 주의하자!!!
 */

-- ** where절에서 새로운 열 사용 방법1
SELECT LAST_NAME , SALARY, COMMISSION_PCT , COMMISSION
FROM (SELECT FIRST_NAME, LAST_NAME , SALARY, COMMISSION_PCT , SALARY * COMMISSION_PCT / 100 COMMISSION
             FROM hr.EMPLOYEES)
WHERE FIRST_NAME  = 'David' AND COMMISSION >= 5
ORDER BY 4 DESC;
/*
새로운 테이블을 만들어 새로운 열을 where절에서 사용하면 된다.
order by 문은 새로운 열이름으로도 숫자로도 정렬이 가능합니다.
여기서 4는 첫번째 SELECT의 순서를 따른다.
 */

SELECT  * , SALARY * COMMISSION_PCT / 100 COMMISSION FROM hr.EMPLOYEES;
/*
ORA-00923: FROM 키워드가 필요한 위치에 없습니다. 오류 메세지가 나온다.
이건 나중에 찾아보자
 */

-- ** where절에서 새로운 열 사용 방법2
SELECT a.LAST_NAME, a.SALARY , a.COMMISSION_PCT  , b.commission
FROM hr.EMPLOYEES a , (SELECT EMPLOYEE_ID , SALARY * COMMISSION_PCT / 100 COMMISSION  FROM hr.EMPLOYEES) b
WHERE a.EMPLOYEE_ID = b.EMPLOYEE_ID AND b.COMMISSION >= 5 AND a.FIRST_NAME = 'David'
ORDER BY 4 DESC;

-- * 연산 관련 함수 사용하기
-- ** round 반올림
SELECT LAST_NAME , SALARY sal_y, SALARY /12 sal_m, ROUND(SALARY/12) sal_m_rou
FROM HR.EMPLOYEES;
/*
ROUND 함수를 써서 반올림을 한 결과를 출력했다.
 */

SELECT LAST_NAME , SALARY sal_y, SALARY /12 sal_m, ROUND(SALARY/12, -2) sal_m_rou
FROM HR.EMPLOYEES;
/*
십의 자리에서 반올림 한 결과를 보여준다.
round(숫자, 반올림할 위치)
반올림할 위치를 적지 않을 경우에는 기본값이 0이다.
 */

SELECT LAST_NAME , SALARY sal_y, SALARY /12 sal_m, ROUND(SALARY/12) sal_m_rou
FROM HR.EMPLOYEES
WHERE ROUND(SALARY/12) >= 1000;
/*
출력한 결과에서 월급이 1200이상인 것들만 추출했다.
 */

SELECT LAST_NAME , SALARY sal_y, SALARY /12 sal_m, ROUND(SALARY/12) sal_m_rou
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 50;
/*
DEPARTMENT_ID 가 50인 것들만 추출했다.
 */

SELECT DISTINCT DEPARTMENT_ID 
FROM HR.EMPLOYEES
ORDER BY DEPARTMENT_ID;
/*
DEPARTMENT_ID 는 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, null로 이루어져 있다.
 */

SELECT LAST_NAME , SALARY sal_y, SALARY /12 sal_m, trunc(SALARY/12) sal_m_tru
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 50;
/*
trunc 함수는 해당 자리 밑으로는 다 자르는 것으로 기본값은 0이다.
 */

SELECT LAST_NAME , SALARY sal_y, SALARY /12 sal_m, trunc(SALARY/12) sal_m_tru
FROM HR.EMPLOYEES
WHERE trunc(SALARY/12) >= 1416;
/*
trunc 함수는 해당 자리 밑으로는 다 자르는 것으로 기본값은 0이다.
 */

SELECT LAST_NAME , SALARY sal_y, SALARY /12 sal_m, trunc(SALARY/12, -2) sal_m_tru
FROM HR.EMPLOYEES
WHERE trunc(SALARY/12, -2) >= 1416;
/*
십의 자리에서 자르는 것으로 1416으로 나왔던 King도 1400으로 값이 나와 추출이 되지 않았다.
 */

CREATE TABLE num_mod(
    fir_num NUMBER(10),
    sec_num NUMBER(10)
);

DROP TABLE num_mod;
/*
mod함수를 사용하기 위한 예제 테이블을 생성하였습니다.
 */

INSERT INTO num_mod VALUES ('${fir_num}', '${sec_num}');
/*
아무 숫자나 입력하여 레코드를 추가하자
 */

SELECT FIR_NUM , SEC_NUM , trunc(FIR_NUM/SEC_NUM) quotient , MOD(FIR_NUM,SEC_NUM) remainder FROM num_mod;
/*
quotient 열에는 몫이 들어가고 remainder 열에는 나머지가 들어가게 된다.
 */

-- * null값의 계산
/*
null값은 사칙연산을 해도 null로 나옴
null + 4 = null, null * 3 = null, null - 2 = null, null / 1 = null
 */

SELECT LAST_NAME , SALARY , COMMISSION_PCT , SALARY * COMMISSION_PCT /100 COMMISSION
FROM hr.EMPLOYEES 
WHERE SALARY >=1500;
/*
COMMISSION_PCT 열에 null값이 있어서 COMMISSION에서 null로 나오는 애들이 있다.
 */

-- ** nvl함수
SELECT LAST_NAME , SALARY , COMMISSION_PCT , SALARY * nvl(COMMISSION_PCT, 0) / 100 commission
FROM hr.EMPLOYEES;
/*
nvl(A, B) => A가 null이면 B로 대치한다.
이 쿼리문에서는 null이 0으로 대치되어 계산이 되어 COMMISSION_PCT가 null이면 commission값이 0이 된다.
 */

-- * date 타입의 연산
/*
DD: 일자 => 23
DY: 요일 3글자 => SUN
DAY: 요일 => SUNDAY
DDSP: 일자영문 => TWELVE
MM: 월 숫자 => 03
MON: 월 3글자 => JAN
MONTH: 월 => JANUARY
YY: 년 2자리 숫자 => 93
YYYY: 년 4자리 숫자 => 1993
HH:MI:SS: 시간:분:초 => 12:02:34
Fm: FILE MODE
HH24: 24시간 표시 => 23
TH: 서수 일자 => 4TH
  * 영어 할때 th 붙이는 것을 서수라고 함
AM or PM: 오전 / 오후
 */

SELECT LAST_NAME , HIRE_DATE , HIRE_DATE + 90 "$review$"
FROM hr.EMPLOYEES;
/*
"$review$"처럼 열이름에 특수문자를 넣고 싶을 때는 ""안에 입력을 하자
 */

SELECT LAST_NAME , HIRE_DATE , trunc((sysdate - HIRE_DATE) / 7) WEEKS
FROM hr.EMPLOYEES
ORDER BY weeks DESC;
/*
정렬을 하면 누가 제일 빨리 고용 되었는지 알 수 있고 누가 얼마나 일 했는지도 알 수 있다.
 */

-- * date타입 관련 함수
SELECT LAST_NAME , HIRE_DATE , ADD_MONTHS(HIRE_DATE, 6) review 
FROM hr.EMPLOYEES
WHERE DEPARTMENT_ID = 50;
/*
ADD_MONTHS(날짜, 더할 개월 숫자)
 */

SELECT LAST_NAME , HIRE_DATE , LAST_DAY(HIRE_DATE) "#pay ck"
FROM hr.EMPLOYEES;
/*
LAST_DAY(날짜)는 해당 날짜의 해당월의 마지막 날을 반환한다.
즉, LAST_DAY("2016-04-18")이면 2016년 4월 30일을 반환해 준다.
 */

SELECT LAST_NAME , HIRE_DATE , LAST_DAY(HIRE_DATE) "#pay ck"
FROM hr.EMPLOYEES;
/*
LAST_DAY(날짜)는 해당 날짜의 해당월의 마지막 날을 반환한다.
 */

SELECT LAST_NAME , HIRE_DATE ,  NEXT_DAY((HIRE_DATE+14), '일') find_days
FROM hr.EMPLOYEES;
/*
NEXT_DAY(기준일자, 찾을 요일)로 기준일자가 무슨 요일 이든지 기준일자 빼고 가장 가까운 요일의 날짜를 찾아준다.
SUN, SUNDAY같은 인수를 넣으면 오류가 나온다.
 */

SELECT LAST_NAME , HIRE_DATE ,  MONTHS_BETWEEN(SYSDATE , HIRE_DATE) "MONTHS TENURE"
FROM hr.EMPLOYEES;
/*
열이름이 띄어쓰기면 ""안에 적자!!!
LAST_DAY(날짜)는 해당 날짜의 해당월의 마지막 날을 반환한다.
 */

SELECT FIRST_NAME , TO_CHAR(HIRE_DATE, 'YYYY:MM:DD') for_date FROM hr.EMPLOYEES ;
SELECT FIRST_NAME , TO_CHAR(HIRE_DATE, 'YYYY MONTH') for_date FROM hr.EMPLOYEES ;
SELECT FIRST_NAME , TO_CHAR(HIRE_DATE, 'DD"일의 날짜 영문:" DDSP') for_date FROM hr.EMPLOYEES ;
/*
날짜 타입을 ""으로 잡으면 오류가 나온다.
 */

-- * DATE 형태 맞추기
SELECT ID , LAST_NAME , START_DATE , DEPT_ID 
FROM hr.S_EMP ;
/*
MMDDYYHHMISS나 MONTH DD, YYYY로 넣어도 s_emp의 START_DATE는 YYYY-MM-DD HH:MI:SS 형태로 나온다.
 */

INSERT INTO hr.s_emp(ID, LAST_NAME , START_DATE , DEPT_ID) VALUES('100', 'smith', to_date('070393083000','MMDDYYHHMISS'), 50);
INSERT INTO hr.s_emp(id, LAST_NAME , START_DATE , DEPT_ID) VALUES('200', 'kogi', to_date('7월 07, 1993','MONTH DD, YYYY'), 10);
/*
어떤 날짜 형태로 집어 넣던 s_emp에는 YYYY-MM-DD HH:MI:SS형태로 들어 간다.
 */

DELETE FROM hr.s_emp WHERE id = 100;

SELECT ID , LAST_NAME , TO_CHAR(START_DATE, 'MMDDYYHHMISS')  , DEPT_ID 
FROM hr.S_EMP ;

SELECT ID , LAST_NAME , TO_CHAR(START_DATE, 'MONTH DD, YYYY')  , DEPT_ID 
FROM hr.S_EMP ;
/*
TO_CHAR을 써야 YYYY-MM-DD HH:MI:SS에서 다른 형태로 나오게 된다.
 */

-- * 문자열 편집하기
/*
||: 문자열을 합친다.
INITCAP: 앞글자 하나만 대문자로
UPPER: 모든 글자를 대문자로
LOWER: 모든 글자를 소문자로
SUBSTR: 해당 위치에서 몇자리의 문자열만 추출
LENGTH: 문자열의 길이
 */

-- ** ||
SELECT FIRST_NAME || LAST_NAME "full name", SALARY
FROM hr.EMPLOYEES ;
/*
FIRST_NAME 와 LAST_NAME 열을 합쳐서 full name 열을 만들었다.
FIRST_NAME 와 LAST_NAME 이 공백없이 붙어서 이름이 나오게 된다.
 */

SELECT FIRST_NAME || ' ' || LAST_NAME "full name", SALARY
FROM hr.EMPLOYEES ;
/*
|| ' ' || 으로 성과 이름에 공백이 생기게 할 수 있다.
 */

-- ** INITCAP
SELECT FIRST_NAME , EMAIL  ,INITCAP(EMAIL) email_tcap
FROM hr.EMPLOYEES ;
/*
다 대문자였던 EMAIL 은 email_tcap 에서는 앞글자만 대문자로 바뀐 것을 확인 할 수 있다.
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
첫번째 문자부터 길이가 3인 문자열을 추출한다.
 */

-- ** SUBSTR
SELECT FIRST_NAME , SUBSTR(FIRST_NAME, -3, 3) FIRST_NAME_SUBSTR
FROM hr.EMPLOYEES ;
/*
뒤에서 부터 3번째 문자에서 부터 3 길이의 문자열을 추출한다.
 */

-- ** LENGTH
SELECT FIRST_NAME , LENGTH(FIRST_NAME) FIRST_NAME_LENGTH
FROM hr.EMPLOYEES ;

SELECT FIRST_NAME || ' ' || LAST_NAME full_name , LENGTH(FIRST_NAME || ' ' || LAST_NAME) full_name_LENGTH
FROM hr.EMPLOYEES ;
/*
새로운 열에 대해서도 함수를 쓸 수 있다.
 */

SELECT FIRST_NAME , SALARY 
FROM hr.EMPLOYEES 
WHERE LENGTH(FIRST_NAME)=7;
/*
where절에서고 함수가 사용가능하다.
FIRST_NAME 이 7글자인 데이터의 연봉은 얼마 인지 알 수가 있습니다.
 */

-- * 그룹함수
SELECT AVG(salary) average, max(SALARY) maximom, min(SALARY) minimum, sum(SALARY) total
FROM hr.EMPLOYEES;
/*
함수들을 이용하여 평균 / 최대값 / 최소값 / 총합 을 구 할 수 있습니다.
 */

SELECT '$ ' || AVG(salary) average, '$ ' || max(SALARY) maximom, '$ ' || min(SALARY) minimum, '$ ' || sum(SALARY) total
FROM hr.EMPLOYEES;
/*
출력된 값 앞에는 $표시가 있다.
 */

SELECT '$ ' || round(AVG(salary),3) average, '$ ' || max(SALARY) maximom, '$ ' || min(SALARY) minimum, '$ ' || sum(SALARY) total
FROM hr.EMPLOYEES;
/*
평균의 소수점이 너무 많아 소수점이 3개 보이도록 반올림 시켰다.
 */

SELECT round(AVG(salary),3) average
FROM (SELECT AVG(salary) average
            FROM hr.EMPLOYEES;)
WHERE SALARY > 2 * AVG(salary),3;
/*
그룹함수는 where절에서 사용할 수 없다.
 */

SELECT DEPARTMENT_ID, AVG(SALARY) avg_salary
FROM hr.EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) > 8000
ORDER BY DEPARTMENT_ID;
/*
부서별로 그룹을 지어서 평균 연봉이 8000이상이면 DEPARTMENT_ID 를 오름차순으로 데이터를 추출
 */

SELECT count(*)
FROM hr.EMPLOYEES;

SELECT count(COMMISSION_PCT)
FROM hr.EMPLOYEES;
/*
107개 행이 이었는데 35개 가 된 이유는 COMMISSION_PCT에는 NULL값이 있었기 때문이다.
null값은 count 되지않는다.
 */

SELECT count(DEPARTMENT_ID)
FROM hr.EMPLOYEES;
/*
부서 ID가 없는 행은 1개만 있다;
 */

SELECT DISTINCT DEPARTMENT_ID FROM hr.EMPLOYEES;
/*
null 포함 12개의 서로다른 부서 ID가 있다.
 */

SELECT count(DISTINCT DEPARTMENT_ID)
FROM hr.EMPLOYEES;
/*
null은 count에 포함되지 않아 11개라고 나온다.
 */

-- * group by절
SELECT DEPARTMENT_ID ,count(DEPARTMENT_ID)
FROM hr.EMPLOYEES 
WHERE DEPARTMENT_ID IN (40,50,60)
GROUP BY DEPARTMENT_ID;
/*
DEPARTMENT_ID가 40 / 50 / 60인 부서에서 일하는 사람인 몇명 씩인가를 확인하기 위해 쿼리를 작성하였습니다.
 */

SELECT MANAGER_ID , DEPARTMENT_ID ,count(DEPARTMENT_ID)
FROM hr.EMPLOYEES 
GROUP BY MANAGER_ID , DEPARTMENT_ID
ORDER BY manager_id, DEPARTMENT_ID;
/*
GROUP BY 에는 여러 개의 열이 들어 갈 수 있다.
manager_id, DEPARTMENT_ID 을 오름차순으로 정렬하였습니다.
where문을 빼서 전체 데이터를 가지고 추출하였습니다.
 */

SELECT DEPARTMENT_ID , round(avg(salary)) dept_total_sal
FROM hr.EMPLOYEES 
GROUP BY DEPARTMENT_ID 
HAVING sum(salary)>50000
ORDER BY dept_total_sal DESC;
/*
부서별 총 연봉합이 50000이상인 부서의 평균 연봉은 얼마인가를 나타냄
 */

-- * 연습문제
-- ** 1번
SELECT max(salary) maxsal, min(SALARY) minsal
FROM hr.EMPLOYEES;

-- ** 2번
SELECT DEPARTMENT_ID , COUNT(DEPARTMENT_ID) "Number Of Department"
FROM hr.EMPLOYEES
GROUP BY DEPARTMENT_ID 
ORDER BY DEPARTMENT_ID ;

-- ** 3번
SELECT MANAGER_ID , COUNT(MANAGER_ID) "Number Of Maneger"
FROM hr.EMPLOYEES
GROUP BY MANAGER_ID  
ORDER BY MANAGER_ID ;

-- ** 4번
SELECT MANAGER_ID , COUNT(MANAGER_ID) "Number Of Maneger"
FROM hr.EMPLOYEES
GROUP BY MANAGER_ID
HAVING count(MANAGER_ID)>=5
ORDER BY "Number Of Maneger" DESC;

-- ** 5번
SELECT DEPARTMENT_ID , count(DEPARTMENT_ID ) "NUMBER of department" , sum(SALARY) total
FROM hr.EMPLOYEES 
GROUP BY DEPARTMENT_ID 
HAVING sum(SALARY)>=50000
ORDER BY total;

-- ** 6번
SELECT DEPARTMENT_ID , round(avg(salary),3) avg_sal
FROM hr.EMPLOYEES 
GROUP BY DEPARTMENT_ID 
ORDER BY DEPARTMENT_ID;

-- * join
SELECT emp.LAST_NAME , emp.DEPARTMENT_ID , dep.DEPARTMENT_NAME 
FROM hr.EMPLOYEES emp, hr.DEPARTMENTS dep
WHERE emp.DEPARTMENT_ID = dep.DEPARTMENT_ID;
/*
null 행은 사라져서 107개에서 106개가 되었습니다.
 */

SELECT emp.LAST_NAME , emp.DEPARTMENT_ID , dep.DEPARTMENT_NAME 
FROM hr.EMPLOYEES emp, hr.DEPARTMENTS dep
WHERE emp.DEPARTMENT_ID = dep.DEPARTMENT_ID AND emp.LAST_NAME = 'Matos';
/*
null 행은 사라져서 107개에서 106개가 되었습니다.
 */

-- ** null 데이터 확인
SELECT FIRST_NAME , LAST_NAME , DEPARTMENT_ID , SALARY 
FROM hr.EMPLOYEES 
WHERE DEPARTMENT_ID is null ;
/*
1개의 행이 DEPARTMENT_ID가 null이라고 나온다.
 */

-- ** 1:M 조인
SELECT loc.COUNTRY_ID , loc.CITY , dep.DEPARTMENT_ID , dep.DEPARTMENT_NAME 
FROM hr.DEPARTMENTS dep,  hr.LOCATIONS  loc
WHERE dep.LOCATION_ID = loc.LOCATION_ID;
/*
하나의 LOCATION에 여러개의 부서가 존재 한다.

각 도시에 어떤 부서가 있는지 확인 할 수 있다.
 */

SELECT loc.COUNTRY_ID , loc.CITY , dep.DEPARTMENT_ID , dep.DEPARTMENT_NAME 
FROM hr.DEPARTMENTS dep,  hr.LOCATIONS  loc
WHERE dep.LOCATION_ID = loc.LOCATION_ID AND loc.CITY in (initcap('TORONTO'), initcap('SEATTLE'));
/*
하나의 LOCATION에 여러개의 부서가 존재 한다.

US의 Seattle에는 10. 30, 90, 100, 110, 120, 130, 140, 150, ,160, 170, 180, 190, 200, 210, 220, 230. 240. 250. 260. 270의 21개 부서가 있고
CA의 Toronto에는 20 이라는 부서 1개 뿐이다.
 */

-- * outer join
SELECT *
FROM hr.LOCATIONS ;
/*
기존 DEPARTMENTS는 23행 6열
 */

SELECT *
FROM hr.DEPARTMENTS;
/*
기존 DEPARTMENTS는 27행 4열
 */

-- * left outer join
SELECT * 
FROM hr.LOCATIONS loc LEFT OUTER JOIN hr.DEPARTMENTS dep
           ON loc.LOCATION_ID = dep.LOCATION_ID;
/*
내가 배웠던 일반적인 방법
43행 10열이 된다.
 */

SELECT *
FROM hr.LOCATIONS loc,  hr.DEPARTMENTS  dep
WHERE loc.LOCATION_ID = dep.LOCATION_ID(+);
/*
43행 10열이 된다.
하지만 LOCATION_ID가 중첩되므로 삭제를 해주어야 보기 편할거 같아서 밑에 쿼리를 작성 했다.

(+)가 있는 쪽이 (+)없는 쪽에 붙는다고 생각 하면 쉽다.
 */

-- * right outer join
SELECT * 
FROM hr.LOCATIONS loc RIGHT OUTER JOIN hr.DEPARTMENTS dep
           ON loc.LOCATION_ID = dep.LOCATION_ID;
/*
내가 배웠던 일반적인 방법
27행 10열이 된다.
 */

SELECT *
FROM hr.LOCATIONS loc,  hr.DEPARTMENTS  dep
WHERE loc.LOCATION_ID(+) = dep.LOCATION_ID;
/*
27행 10열

(+)가 왼쪽에 있으므로 오른쪽에 있는 DEPARTMENTS에 붙는 것이다.
 */

-- * full outer join
SELECT * 
FROM hr.LOCATIONS loc FULL OUTER JOIN hr.DEPARTMENTS dep
           ON loc.LOCATION_ID = dep.LOCATION_ID;
 /*
43행 10열이 된다.
(+)는 양쪽에는 쓸수 없어서 사용을 못 함
 */

 -- * 중복열을 제거한 left outer join
SELECT loc.*, dep.DEPARTMENT_ID , dep.DEPARTMENT_NAME , dep.MANAGER_ID 
FROM hr.LOCATIONS loc,  hr.DEPARTMENTS  dep
WHERE loc.LOCATION_ID = dep.LOCATION_ID(+);

-- * 셀프조인
SELECT *
FROM hr.EMPLOYEES emp_a , hr.EMPLOYEES emp_b
WHERE emp_a.EMPLOYEE_ID = emp_b.EMPLOYEE_ID;
 /*
동일한 테이블이 2번 이상 나와 자신과 자신에 대해 조인하는 형태
 */

-- * 조인 뷰
CREATE VIEW empdepvu AS SELECT emp.LAST_NAME , emp.DEPARTMENT_ID , dep.DEPARTMENT_NAME 
												 FROM hr.EMPLOYEES emp , hr.DEPARTMENTS dep
												 WHERE emp.DEPARTMENT_ID  = dep.DEPARTMENT_ID;
 /*
inner join한 테이블을 empdepv라는 뷰로 생성하였습니다.

 */

-- ** 뷰 불러오기
SELECT * FROM empdepvu;








-- ** 
SELECT 1 FROM hr.EMPLOYEES emp , hr.DEPARTMENTS dep WHERE emp.DEPARTMENT_ID = dep.DEPARTMENT_ID;










































