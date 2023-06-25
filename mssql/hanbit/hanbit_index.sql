/*
mssql
날짜 23-05-28

인덱스
https://youtu.be/3y6HAcqBz2c
https://youtu.be/jRmt2wCx0X4
https://youtu.be/sSOsWoaTrNk
https://youtu.be/wzHuooBh17M

인덱스
 - select 할 때 빠르게 접근하도록 도와줌
 - 데이터베이스 성능에 아주 중요한 역할
 - 인덱스가 데이터베이스 공간을 차지해서 데이터베이스 크기의 10% 정도의 추가 공간이 필요
 - 생성에 시간이 소요될 수 있음
 - 데이터를 변경(insert, update, delete)할때 성능이 나빠짐
 - 데이터 변경작업인 insert, update, delete 가 자주 일어나는 경우 성능이 나빠 질 수 있음
 - 클러스트형은 테이블 당 한개, 비클러스트형은 테이블 당 여러개 생성 가능
 - 인덱스가 만들어 지는 제약조건은 PK와 UK뿐
 - 비클러스터형 인덱스의 리프 페이지에는 데이터가 없고 데이터가 위치하는 RID가 존재
 - where절에서 사용해야 인덱스를 만드는 의미가 있음!!!!!
*/
use tempdb;
create table tbl1(
	a int primary key,
	b int,
	c int
);
go
create table tbl2 (
	a int primary key,
	b int unique,
	c1 int unique,
	d int
);
go
create table tbl3 (
	ab int primary key nonclustered,
	b int unique,
	c1 int unique,
	d int
);
go
create table tbl4 (
	ab int primary key nonclustered,
	b int unique,
	ca int unique clustered,
	d int
);
go
-- 인덱스 확인
exec sp_helpindex "tbl1";
exec sp_helpindex "tbl2";
exec sp_helpindex "tbl3";
exec sp_helpindex usertbl;
/*pk는 기본적으로 클러스터형, uk는 비클러스터형으로 지정*/

-- 예제
drop table usertbl;
create table usertbl(
	userID char(8) not null,
	name nvarchar(10) not null,
	birthYear int not null,
	addr nchar(2) not null
);
go
insert into usertbl values ('SSK', '성시경', 1988, '서울');
insert into usertbl values ('LSG', '이승기', 1988, '서울');
insert into usertbl values ('KBS', '김범수', 1988, '경남');
insert into usertbl values ('KKH', '김경호', 1988, '전남');
insert into usertbl values ('JYP', '조용필', 1988, '경기');
go
select * from usertbl;
/*userid에 인덱스가 없어서 자동 정렬이 되지 않는다.*/
go
alter table usertbl add constraint pk_usertbl_userid primary key (userid);
go
select * from usertbl;
/*인덱스를 설정하니 userid기준으로 행이 정렬*/

-- 클러스터 인덱스 예제
use tempdb;
go
create table clustertbl (
	userid char(8) not null,
	name nvarchar(10) not null
);
go
insert into clustertbl values ('LSG', '이승기');
insert into clustertbl values ('KBS', '김범수');
insert into clustertbl values ('KKH', '김경호');
insert into clustertbl values ('JYP', '조용필');
insert into clustertbl values ('SSK', '성시경');
insert into clustertbl values ('LJB', '임재범');
insert into clustertbl values ('YJS', '윤종신');
insert into clustertbl values ('EJW', '은지원');
insert into clustertbl values ('JKW', '조관우');
insert into clustertbl values ('BBK', '바비킴');
/*Btree는 하나의 페이지에 8Kbyte*/
go
/*이제 클러스트 생성*/
alter table clustertbl add constraint pk_clustertbl_userid primary key (userid);
go
select * from clustertbl;
/*여러개의 페이지가 있을시 userid를 기준으로 정렬이 일어남*/
go
insert into clustertbl values ('FNT', '푸니타');
insert into clustertbl values ('KAI', '카아이');
/*EJW과 JKW 사이에 FNT가 입력되므로 페이지 분할이 발생*/

-- 비클러스터형 인덱스 예제
create table nonclustertbl (
	userid char(8) not null,
	name nvarchar(10) not null
);
go
insert into nonclustertbl values ('LSG', '이승기');
insert into nonclustertbl values ('KBS', '김범수');
insert into nonclustertbl values ('KKH', '김경호');
insert into nonclustertbl values ('JYP', '조용필');
insert into nonclustertbl values ('SSK', '성시경');
insert into nonclustertbl values ('LJB', '임재범');
insert into nonclustertbl values ('YJS', '윤종신');
insert into nonclustertbl values ('EJW', '은지원');
insert into nonclustertbl values ('JKW', '조관우');
insert into nonclustertbl values ('BBK', '바비킴');
/*Btree는 하나의 페이지에 8Kbyte*/
go
/*이제 클러스트 생성*/
alter table nonclustertbl add constraint uk_clustertbl_userid unique (userid);
go
select * from nonclustertbl;
/*
비클러스터형은 userid열을 기준으로 인덱스는 생성되지만
페이지에 있는 데이터는 정렬이 일어나지 않는다.
*/
go
exec sp_helpindex 'nonclustertbl';
go
insert into nonclustertbl values ('FNT', '푸니타');
insert into nonclustertbl values ('KAI', '카아이');
/*페이지 분할이 일어나지 않음*/

-- 클러스터형 + 비클러스터형
use tempdb;
go
create table mixedtbl (
	userid char(8) not null,
	name nvarchar(10) not null,
	addr nchar(2)
);
go
insert into mixedtbl values ('LSG', '이승기', '서울');
insert into mixedtbl values ('KBS', '김범수', '경남');
insert into mixedtbl values ('KKH', '김경호', '전남');
insert into mixedtbl values ('JYP', '조용필', '경기');
insert into mixedtbl values ('SSK', '성시경', '서울');
insert into mixedtbl values ('LJB', '임재범', '서울');
insert into mixedtbl values ('YJS', '윤종신', '경남');
insert into mixedtbl values ('EJW', '은지원', '경북');
insert into mixedtbl values ('JKW', '조관우', '경기');
insert into mixedtbl values ('BBK', '바비킴', '서울');
go
select * from mixedtbl;
go
alter table mixedtbl add constraint pk_mixedtbl_userid primary key (userid);
alter table mixedtbl add constraint uk_mixedtbl_name unique (name);
go
exec sp_helpindex 'mixedtbl';
go
select addr from mixedtbl where name ='임재범';
/*비클러스터형 => 클러스터형*/
go
select addr from mixedtbl where userid ='LJB'; 
/*클러스터형만으로 찾는다.*/
go
select * from mixedtbl; 
/*
실행계획에 나오는 scan은 인덱스 페이지를 모두 찾아봤다는 의미
seek는 일부 페이지만 검색했다는 의미
*/

-- 제약조건 없이 직접 인덱스 생성
/*
기본값으로는 비클러스터형으로 생성
filefactor로 데이터를 채울 수 있는 크기를 지정할 수 있다.
 => 50으로 설정하면 50%만 채우고 나머지 50%는 비워놓겠다는 의미
*/
restore database sqldb 
	from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL13.GYCOM\MSSQL\Backup\sqlDB.bak' with replace;
use sqldb;
go
exec sp_helpindex usertbl;
go
create index idx_usertbl_addr
	on usertbl(addr);
go
exec sp_helpindex usertbl;
go
create index idx_usertbl_name
	on usertbl(name);
go
exec sp_helpindex usertbl;
go
/*2개 이상의 열로도 인덱스 생성*/
create index idx_usertbl_name_birthyear
	on usertbl(name, birthyear);
go
exec sp_helpindex usertbl;
go
select * from usertbl where name ='윤종신' and birthyear = '1969';
go
create index idx_usertbl_mobile1
	on usertbl(mobile1);

select * from usertbl where mobile1 = '011';

-- 인덱스 변경

-- 인덱스 삭제
exec sp_helpindex usertbl;
go
drop index usertbl.idx_usertbl_addr;
drop index usertbl.idx_usertbl_mobile1;
drop index usertbl.idx_usertbl_name;
drop index usertbl.idx_usertbl_name_birthyear;
go
drop index usertbl.PK__userTbl__CB9A1CDF91DE6EBA;
/*
제약조건으로 생성된 인덱스는 삭제 불가
PK__userTbl__CB9A1CDF91DE6EBA은 usertbl의 userid로 만든 인덱스
*/

-- 인덱스 없을 때 VS 클러스터형 VS 비클러스터형
/*테이블의 구조를 확인 하는 프로시저*/
create procedure usp_indexinfo
	@tablename sysname
as 
	select @tablename as '테이블이름',
	       I.name as '인덱스이름',
		   I.type_desc as '인덱스타입',
		   A.data_pages as '페이지개수', -- 사용된 데이터 페이지수
		   A.data_pages * 8 as '크기(KB)', -- 페이지를 KB(1page = 8KB)로 계산
		   P.rows as '행개수'
	from sys.indexes I
	     inner join
		 sys.partitions P
			on I.object_id = P.object_id
			   and
			   object_id(@tablename) = I.object_id
			   and I.index_id = P.index_id
		 inner join
		 sys.allocation_units A
			on A.container_id = P.hobt_id;
go
select top 19820 * into cust from AdventureWorks.sales.customer order by newid();
select top 19820 * into cust_c from AdventureWorks.sales.customer order by newid();
select top 19820 * into cust_nc from AdventureWorks.sales.customer order by newid();
select top 4 * from cust;
select top 4 * from cust_c;
select top 4 * from cust_nc;
/*
 - select into from을 사용할 때는 먼저 테이블 생성할 필요없음
 - top 19820 ~ order by newid()을 사용하면 customer테이블의 데이터가 섞여서 복사됨
*/
go
exec usp_indexinfo cust;
exec usp_indexinfo cust_c;
exec usp_indexinfo cust_nc;
go
/*테이블에 인덱스 생성*/
create clustered index idx_cust_c on cust_c(customerid);
create index idx_cust_nc on cust_nc(customerid);
go
select top 4 * from cust; -- 정렬 O
select top 4 * from cust_c; -- 정렬 X
select top 4 * from cust_nc; -- 정렬 X
go
exec usp_indexinfo cust;
/*HEAP은 데이터 페이지*/
exec usp_indexinfo cust_c;
/*페이지 개수가 총 160개인데 기존 155개에서 루트페이지가 4개 추가 되었다고 볼 수 있음*/
exec usp_indexinfo cust_nc;
go
select * from cust where customerid = 100;
/*
도구 => 옵션 => 쿼리실행 => SQL Server => set statistics io를 체크 표시 해두면
메시지에 논리적 읽기수 가 나오는데 이것은 읽은 페이지 수를 의미!!
*/
select * from cust_c where customerid = 100;
/*메시지 창을 보면 2페이지만 읽은 것을 확인*/
select * from cust_nc where customerid = 100;
/*
- 메시지 창을 보면 3페이지를 읽은 것을 확인
- 비클러스터형은 데이터 페이지도 읽기 때문에 클러스터형보다는 많은 테이블을 읽는다.
*/
go
/*범위로 검색*/
select * from cust where customerid < 100;
select * from cust_c where customerid < 100;
/*
- 1~100까지의 데이터는 정렬된 하나의 페이지에 저장되어 있으므로
  하나의 페이지에서 모든 데이터를 찾아 볼 수 있다.
*/
select * from cust_c where customerid between 100 and 150;
/*
- 하나의 페이지에는 130개의 행이 들어 있으므로
  100~130은 1페이지에서 131~150은 2페이지에서 검색
*/
select * from cust_nc where customerid < 100;
select * from cust_nc with (index(idx_cust_nc))  where customerid < 100;
/*with (index(idx_cust_nc))옵션을 사용하면 idx_cust_nc를 강제적으로 사용하여 실행*/

-- territoryid에는 1~10으로만 이루어진 데이터만 존재
select top 19820 * into cust2_c from AdventureWorks.sales.customer order by newid();
select top 19820 * into cust2_nc from AdventureWorks.sales.customer order by newid();
go
create clustered index idx_cust2_c on cust2_c(territoryid);
create index idx_cust2_nc on cust2_nc(territoryid);
go
select * from cust2_c where TerritoryID = 2; -- seek
select * from cust2_nc where TerritoryID = 2; -- scan

-- 주의 할점
select * from cust_c where customerid * 1 = 100;
/*
이렇게 * 1로 가공할 시 seek가 아닌 scan으로 성능이 떨어지므로 주의하자!!!
*/
