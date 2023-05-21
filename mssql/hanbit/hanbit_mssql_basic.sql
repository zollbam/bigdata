/*
mssql
날짜 23-05-20

https://youtu.be/-4E_lEQte04
https://youtu.be/nkrlLSN6-ZE
https://youtu.be/vZ2h3ezd8n0
https://youtu.be/wYtIM5GzrkY
https://youtu.be/2PDieWqQtFY

Transact-SQL 기본

with절
 - CTE(common table experssion)을 표현하기 위한 구문
  * CTE는 기존의 뷰, 파생 테이블, 임시 테이블 등으로
    사용되던 것을 대신할 수 있고 더 간결한 식으로 보여지는 장점
  * CTE는 비재귀적과 재귀적 2가지 존재

DML
 - select, insert, update, delete
 - 트랜잭션이 발생

DDL
 - 테이블, 뷰, 인덱스, DB 등의 개체를 생성/삭제/변경하는 역할
 - create, drop, alter
 - 트랙잭션 발생 X

DCL
 - 사용자에게 권한을 부여하거나 빼앗을 때 사용
*/

-- 모든열 조회
use AdventureWorks;
go
select * from HumanResources.Employee;
/*
from절에는 "인스턴스이름.DB명.스키마명.테이블명" 순서대로 입력
 => localhost.AdventureWorks.HumanResources.Employee
*/

SELECT * FROM [GYCOM\GYCOM].ADVENTUREWORKS.HUMANRESOURCES.EMPLOYEE;
/*
AdventureWorks말고 다른 DB에 연결 되었을 때 이렇게 사용
[GYCOM\GYCOM].는 없어도 됨
*/

-- 필요열만 조회
SELECT NAME, GROUPNAME FROM ADVENTUREWORKS.HUMANRESOURCES.DEPARTMENT;

-- 현재 인스턴스의 내용 조회
exec sp_helpdb;

-- 현재 DB의 테이블 내용 조회
use AdventureWorks;
go
exec sp_tables @table_type = "'table'";

-- 별칭(alias) 사용
select DepartmentID as 부서번호, name 부서이름, "그룹이름" = GroupName
from HumanResources.Department;

-- 구매내역DB 예제
use tempdb;
go
create database sqlDB;
go
use sqlDB;
go
create table userTbl ( -- 회원 테이블
	userID char(8) not null primary key,
	name nvarchar(10) not null,
	birthYear int not null,
	addr nchar(2) not null,
	mobile1 char(3),
	mobile2 char(8),
	height smallint,
	mDate date
);
go
create table buyTbl ( -- 물건 구매 테이블
	num int identity not null primary key, -- 자동 숫자 입력
	userID char(8) not null
		foreign key references userTbl(userID),
	prodName nchar(6) not null,
	groupName nchar(4),
	price int not null,
	amount smallint not null
);
go
insert into userTbl values 
	('LSG', '이승기',  1987, '서울', '011', '11111111', 182, '2008-8-8'),
	('KBS', '김범수',  1979, '경남', '011', '22222222', 173, '2012-4-4'),
	('KKH', '김경호',  1971, '전남', '019', '33333333', 177, '2007-7-7'),
	('JYP', '조용필',  1950, '경기', '011', '44444444', 166, '2009-4-4'),
	('SSK', '성시경',  1979, '서울', null, null, 186, '2013-12-12'),
	('LJB', '임재범',  1963, '서울', '016', '66666666', 182, '2009-9-9'),
	('YLS', '윤종신',  1969, '경남', null, null, 170, '2005-5-5'),
	('EJW', '은지원',  1978, '경북', '011', '88888888', 174, '2014-3-3'),
	('JKW', '조관우',  1965, '경기', '018', '99999999', 172, '2010-10-10'),
	('BBK', '바비킴',  1973, '서울', '010', '00000000', 176, '2013-5-5');
go
insert into buyTbl values 
	('KBS', '운동화', null, 30, 2),
	('KBS', '노트북', '전자', 1000, 1),
	('JYP', '모니터', '전자', 200, 1),
	('BBK', '모니터', '전자', 200, 5),
	('KBS', '청바지', '의류', 50, 3),
	('BBK', '메모리', '전자', 80, 10),
	('SSK', '책', '서적', 15, 5),
	('EJW', '책', '서적', 15, 2),
	('EJW', '청바지', '의류', 50, 1),
	('BBK', '운동화', null, 30, 2),
	('EJW', '책', '서적', 15, 1),
	('BBK', '운동화', null, 30, 2);
go
select * from userTbl; /*pk로 잡으면 그 열로 정렬*/
go
select * from buyTbl;

-- 백업
backup database [sqlDB] 
	to disk = 'C:\Program Files\Microsoft SQL Server\MSSQL13.GYCOM\MSSQL\Backup\sqlDB.bak' with init;

-- 특정조건 데이터 조회
select *
from userTbl
where name = '김경호';
go
select userID, name
from userTbl
where birthYear >= 1970 and height >= 182;
go
select userID, name
from userTbl
where birthYear >= 1970 or height >= 182;
go
select name, height
from userTbl
where height between 180 and 183;
go
select name, addr
from userTbl
where addr in ('경남','전남','경북');
go
select name
from userTbl
where name like '김%';
go
select name
from userTbl
where name like '_종신';
go
/*김경호보다 키를 큰 사람 조회*/
select name, height 
from userTbl
where height > (select height
		        from userTbl
				where name='김경호');
go
/*경남에 사는 사람의 키보다 큰 고객 조회
  하지만 경남의 사람이 2명이 나와 오류메세지
  이럴때 어떻게 해야 할까??*/
select name, height /*170이상*/
from userTbl
where height >= any(select height /*any: 서브쿼리로 나온 결과중 한개라도 만족하면*/
		            from userTbl
				    where addr='경남');
go
select name, height /*173이상*/
from userTbl
where height >= all(select height /*all: 서브쿼리로 나온 결과 모두 만족하면*/
		            from userTbl
				    where addr='경남');
go
/*정렬*/
select name, mDate
from userTbl
order by mDate; -- 등록이 빠른 순으로
go
select name, mDate
from userTbl
order by mDate desc; -- 등록이 느린 순으로
go
select name, mDate
from userTbl
order by mDate, name;
/*order by는 성능을 떨어뜨릴 경향이 높음*/
go
/*distinct*/
select distinct addr
from userTbl;
go
/*offset: 행 건너띄기*/
select userID, name, birthYear
from userTbl
order by birthYear 
	offset 4 rows; /*상위 4개는 보지 X*/
go
select userID, name, birthYear
from userTbl
order by birthYear 
	offset 4 rows /*상위 4개는 보지 X*/
	fetch next 3 rows only; /*offset 상태에서 상위 3개만*/

-- AdventureWorks DB 데이터 조회
use AdventureWorks;
go
select top 10 CreditCardID /*상위 10개*/
from Sales.CreditCard
where CardType = 'vista' /*vista일때*/
order by ExpYear, ExpMonth; /*오래된 순으로*/
go
select top(select count(*)/100 from Sales.CreditCard) CreditCardID /*상위 1%*/
from Sales.CreditCard
where CardType = 'vista' /*vista일때*/
order by ExpYear, ExpMonth; /*오래된 순으로*/
go
select top(0.1)percent CreditCardID, ExpYear, ExpMonth /*0.1%*/
from Sales.CreditCard
where CardType = 'vista' /*vista일때*/
order by ExpYear, ExpMonth; /*오래된 순으로*/
go
/*동일 점수를 가진 사람도 조회 해야 할 때는??*/
select top(0.1)percent with ties CreditCardID, ExpYear, ExpMonth /*0.1%*/
from Sales.CreditCard
where CardType = 'vista' /*vista일때*/
order by ExpYear, ExpMonth; /*오래된 순으로*/
/*
with ties을 쓰지 않았을 때는 5행만 나왔지만
with ties을 쓰면 122행이 나오게 됨
*/
go
/*랜덤 데이터 조회*/
select *
from Sales.CreditCard
tablesample(5 percent); /*대략 5%*/
go
select *
from Sales.CreditCard
tablesample(5); /*대략 5%*/

-- select into => 테이블 복사
/*
데이터만 복사되지 PK, FK등은 복사 X
*/
use sqlDB;
go
select userID, prodName into buyTbl_col
from buyTbl;
go
select * from buyTbl_col;

-- group by
use sqlDB;
go
select userid, "총 구매개수" = sum(amount)
from buyTbl
group by userID
order by userID;
/*userID 별 총 amount 조회*/
go
select userid, "총 구매액" = sum(price*amount)
from buyTbl
group by userID
order by userID;
/*userID 별 총 amount 조회*/

-- 집계함수
select userid, "평균 구매 개수" = avg(cast(amount as float))
from buyTbl
group by userID
order by userID;
go
select userid, "평균 구매 개수" = avg(amount*1.0)
from buyTbl
group by userID
order by userID;
go
select addr 지역, "최소 키" = min(height), "최대 키" = max(height)
from userTbl
group by addr;
go
select name, height
from userTbl
where height = (select MAX(height) from userTbl) or
      height = (select min(height) from userTbl);
go
select count(*)
from userTbl;
go
select count(mobile1) /*null 값 포함열*/
from userTbl;
/*null은 count로 새지 못 함*/
go
/*select과 count 성능 비교*/
use AdventureWorks;
go
select * from Sales.Customer;
go
select count(*) from Sales.Customer;
/*
도구 창의 profiler로 비교해본 결과 
count로 한개 훨씬 성능이 좋은 것을 확인
*/
use sqlDB
go
select num, price, amount into #tempTbl
from buyTbl;
go
insert into #tempTbl
	select a.price, a.amount from #tempTbl a, #tempTbl b;
go
select * from #tempTbl;
go
select sum(price*amount) from #tempTbl;
/*
집계함수를 사용하면 성능이 훨씬 좋아지므로 되도록 집계함수를 사용하자
커서나 사용자 함수는 너무 성능이 안 좋게 나옴
*/

-- having절
use sqlDB
go
select userID "사용자", sum(price*amount) as 총구매액
from buyTbl
group by userID
having sum(price*amount) > 1000
order by 2;

-- rollup => 그룹별 소합계와 총합계
select num, groupName, sum(price*amount) as "비용"
from buyTbl
group by rollup(groupName, num);
go
select groupName, sum(price*amount) as "비용"
from buyTbl
group by rollup(groupName);

-- grouping_id => 추가된 행 여부
select groupName, 
       sum(price*amount) as "비용",
	   GROUPING_ID(groupName) "추가행 여부"
from buyTbl
group by rollup(groupName);
/*
NULL	3500	1행은 원래 buyTbl테이블에서는 존재 하지 않았던 행!!!
*/

-- cube => 다차원 정보의 데이터 요약
/*예제*/
use sqlDB;
go
create table cubeTbl(prodName nchar(3), color nchar(2), amount int);
go
insert into cubeTbl values
	('컴퓨터','검정',11),
	('컴퓨터','파랑',22),
	('모니터','검정',33),
	('모니터','파랑',44);
go
select color, prodName, "수량합계" = sum(amount)
from cubeTbl
group by cube(prodName, color);
go
select color, prodName, "수량합계" = sum(amount)
from cubeTbl
group by cube(color, prodName);
go
/*cube와 rollup 비교*/
select color, prodName, "수량합계" = sum(amount)
from cubeTbl
group by rollup(color, prodName);
go
/*총합과 평균 같이 조회*/
select color, prodName, "수량합계" = sum(amount), "수량평균" = avg(cast(amount as float))
from cubeTbl
group by rollup(color, prodName);
go
select color, prodName, 
       "수량합계" = sum(amount), 
	   "수량평균" = avg(convert(float, amount))
from cubeTbl
group by rollup(color, prodName);

-- with 절
/*
문법
 - with [CTE_테이블이름(열이름)]
   AS 
   (
		[쿼리문]
   )
   select 열이름 from [[CTE_테이블이름];
*/
use sqlDB;
go
with abc(userID, total) as 
    (
	select userID, sum(price*amount)
	from buyTbl
	group by userID
	)
select * from abc order by total desc;
go
with cte_userTbl(addr, MaxHeight) as 
    (
	select addr, max(height)
	from userTbl
	group by addr
	)
select avg(cast(MaxHeight as float)) from cte_userTbl;

-- 자동증가 값 입력
use sqlDB;
go
create table testTbl2 (
	id int identity,
	userName nchar(3),
	age int,
	nation nchar(4) default '대한민국'
);
go
insert into testTbl2(userName, age) values ('지민', 25);
go
insert into testTbl2 values ('호화', 34, default);
go
insert into testTbl2 values ('제임스', 65, '미국');
go
/*강제로 id값을 입력하고 싶다면*/
set identity_insert testTbl2 on;
go
insert into testTbl2(id, userName, age, nation) values (10,'미미', 19, '일본');
/*
(id, userName, age, nation) 구문을 꼭 입력해야지 안 하면 오류 발생!!!
 => 꼭 id를 명시 해주어야 한다.
*/
go
set identity_insert testTbl2 off;
/*
다시 자동으로 변환하고 싶으면 off를 시켜야 함
*/
go
insert into testTbl2 values ('시오팡', 41, '중국');
/*
자동증가값이 on전부터 값이 입력되는 것이 아닌
on을 하고 지정한 값부터 이어서 진행
 => id값이 4부터가 아닌 11부터 삽입이 됨
*/
go
/*현재 identity값 확인*/
select ident_current('testTbl2');
go
select @@IDENTITY;

-- 시퀀스
create sequence idSEQ
	start with 15
	increment by 2;
go
set identity_insert testTbl2 on;
go
insert into testTbl2(id, userName, age, nation) 
	values (next value for idSEQ, '건영', 30, default);
go
/*시작값 다시 설정*/
alter sequence idSEQ
	restart with 100;
go
insert into testTbl2(id, userName, age, nation) 
	values (next value for idSEQ, '후미코', 35, '일본');
go
select * from testTbl2;
go
/*cycle*/
create table test4(
	id int
);
go
create sequence testseq
	start with 100
	increment by 100
	maxvalue 300
	minvalue 100
	cycle;
go 
insert into test4 values (next value for testseq);
insert into test4 values (next value for testseq);
insert into test4 values (next value for testseq);
insert into test4 values (next value for testseq);
insert into test4 values (next value for testseq);
go
select * from test4;
/*
cycle때문에 100/200/300이 계속 반복적으로 삽입
cycle이 없다면 처음 300 이후에 삽입하려면 오류 발생
*/
go
/*이런 방법으로도  자동증가 가능*/
create sequence testseq1
	start with 1
	increment by 1;
go
create table test5(
	id int default (next value for testseq1),
	name nvarchar(3)
);
go
insert into test5(name) values ('조기석');
insert into test5(name) values ('권경순');
insert into test5(name) values ('조건영');
insert into test5(name) values ('조만영');
go

-- 대량 데이터 삽입
use tempdb;
go
create table test6(
	id int,
	Fname nvarchar(50),
	Lname nvarchar(50)
);
go
insert into test6
	select BusinessEntityID, FirstName, LastName from AdventureWorks.Person.Person;
go
select * from test6;
/*
insert into ~ select은 먼저 테이블을 만들어야 하는 단점
*/

-- delete
/*해당 조건에 맞는 상위 5개만 삭제*/
delete top(5) test6 where Fname = 'Kim';
go
select * from test6 where Fname = 'Kim';
/*원래 10행만 보였지만 5행이 삭제되어 5행만 조회됨*/

-- 대용량 데이터 삭제
/*예제 만들기*/
select * into bigtbl1 from AdventureWorks. Sales.SalesOrderDetail;
select * into bigtbl2 from AdventureWorks. Sales.SalesOrderDetail;
select * into bigtbl3 from AdventureWorks. Sales.SalesOrderDetail;
go
/*삭제 성능 비교 => delete / drop / truncate */
delete from bigtbl1;
go
drop table bigtbl2;
go
truncate table bigtbl3;
/*
성능: drop > truncate> delete
*/
go
select * from bigtbl1; /*레코드 전체 삭제 => 조회가능*/
select * from bigtbl2; /*테이블 자체 삭제 => 조회불가*/
select * from bigtbl3; /*레코드 전체 삭제 => 조회가능*/
/*
행 전체를 삭제 하려면 delete보다 truncate를 사용하자!!
*/

-- merge
/*예제*/
use sqlDB;
go
select userid,name,addr into membertbl from userTbl;
go
select * from membertbl;
go
/*변경사항 기록 테이블 생성*/
create table changetbl(
	changetype nchar(4), /*변경사유*/
	userid char(8),
	name nvarchar(10),
	addr nchar(2)
);
go
insert into changetbl values
	('신규가입', 'CHO', '초아', '미국'),
	('주소변경', 'LSG', null, '제주'),
	('주소변경', 'LJB', null, '영국'),
	('회원탈퇴', 'BBK', null, null),
	('회원탈퇴', 'SSK', null, null);
go 
select * from changetbl;
go
/*신규가입 => insert, 주소변경=> update, 회원탈퇴 => delete*/
merge membertbl as M /*변경될 테이블(target table)*/
using changetbl as c /*변경할 기준이 되는 테이블(source table)*/
	on m.userid = c.userid /*userid을 기준으로 두 테이블 비교*/
when not matched and changetype = '신규가입' then
	/*not matched은 source table에 있는 데이터가 target table에 없으면 참
	  즉, target table의 userid에 없는 새로운 데이터가 입력될 때*/
	insert (userid,name,addr) values (c.userid,c.name,c.addr)
when matched and changetype = '주소변경' then
	update set m.addr = c.addr
when matched and changetype = '회원탈퇴' then
	delete;
go
select * from membertbl;
