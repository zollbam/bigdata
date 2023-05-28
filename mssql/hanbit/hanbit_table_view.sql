/*
mssql
날짜 23-05-28

테이블과 뷰

https://youtu.be/UM8nbkmwNfA
https://youtu.be/7X0c0N04PsQ
https://youtu.be/Ns2q721C0PI
https://youtu.be/zecM5hUeKDE
https://youtu.be/tiFAehetNDk

제약조건
 - 1. PK = > 클러스터형 인덱스 자동 생성
 - 2. FK
 - 3. UNIQUE
 - 4. CHECK
 - 5. DEFAULT
 - 6. NULL

with check / with nocheck
 - with check(default): 이전 데이터도 포함하여 조건에 위배되면 안됨
 - with nocheck: 이전 데이터는 상관없이 이후입력되는 데이터만 조건에 맞으면 됨

스파스 열
 - null 값에 대해 최적화된 저장소가 있는 일반 열
 - null 값이 많이 들어갈 것으로 예상 되는 열들의 공간 절약 효과를 볼 수 있음
 - geometry, geography, image, text, ntext, timestamp, udt에는 설정불가
 - identity 속성에는 사용할 수 없음
 - default값을 지정할 수 없음
 - filestream 특성을 포함 할 수 없음
 - 스파스열이 포함된 테이블은 압축 불가!!

임시 테이블
 - #을 앞에 한개 붙이면 '로컬 임시 테이블'로 생성한 사람만 사용
 - #을 앞에 두개 붙이면 '전역 임시 테이블'로 모든 사용자가 사용

테이블 삭제
 - 부모와 자식 테이블이 이어진 경우 자식을 먼저 삭제해야 부모 테이블을 지울수 있음

메모리 테이블
 - 디스크가 아닌 메모리(RAM)에 테이블이 존재
 - 테이블에 읽기/쓰기 속도가 획기적으로 향상
 - 컴퓨터 한대가 기존 서버 5~10대 분량이 처리
 - 문제는 메모리는 전원이 꺼지면 내용이 모두 사라지므로
   이를 방지하기 위해 보조 복사본이 디스크에서도 유지 관리 됨
 - 전제 조건
  * 64비트 필요
  * 일반적으로 32GB이상의 RAM필요
  * 메모리 테이블 크기의 2배에 해당하는 디스크 여유 공간이 필요
  * 기본 키 및 비클러스터형 인덱스 필요

스키마
 - 데이터베이스 내의 객체를 관리하기 위한 묶음
 - DB명.스키마명.개체명
 - 기본적으로는 dbo로 생성

뷰
 - 일반적으로는 읽기 전용으로 사용
 - 보안의 도움 => 알바한테 중요한 정보를 보여 주기 어려울 때
*/
-- 복원
restore database sqldb 
	from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL13.GYCOM\MSSQL\Backup\sqlDB.bak' with replace;

-- DB삭제
drop database tableDB;

-- DB생성
create database tableDB;

-- 예제 테이블 생성
use tableDB;
go
create table userTBL(
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
create table buyTBL(
	num int not null primary key identity,
	userid char(8) not null,
	proName nchar(6) not null,
	groupName nchar(4),
	price int not null,
	height smallint not null,
	constraint FK_buyTBL_userTBL foreign key (userid) references userTBL(userID) 
);
go
insert into userTBL values
	('LSG',N'이승기',1987,N'서울','011','11111111',182,'2008-08-08'),
	('KBS',N'김범수',1979,N'경남','011','22222222',173,'2012-04-04'),
	('KKH',N'김경호',1971,N'전남','019','33333333',177,'2007-07-07');
go
insert into buyTBL(userid, proName, groupName, price, height) values
	('KBS',N'운동화',null,30,2),
	('KBS',N'노트북',N'전자',1000,1);
go
select * from userTBL;
select * from buyTBL;

-- 테이블 정보 확인
exec sp_help 'buyTBL';

-- 2개열로 기본키 설정
create table probTBL(
	prodCode nchar(3) not null,
	prodID nchar(4) not null,
	prodDate smalldatetime not null,
	prodCur nchar(10)
);
alter table probTBL add constraint PK_probTBL_Code_ID primary key (prodCode, prodID);

-- unique: 중복된값 X + null 허용
create table a1(
	email char(30) null constraint uk_email unique
);

-- check
alter table usertbl
	add constraint ck_birthyear 
	check (birthyear >= 1900 and birthyear <= year(getdate()));

alter table usertbl
	add constraint ck_mobile1
	check (mobile1 in ('010','011','016','017','018','019'));

alter table usertbl
	add constraint ck_height
	check (height>=0);

alter table usertbl
	add constraint ck_name
	check (name not in ('이승기'));
/*
usertbl에 이미 이승기라는 데이터가 있어 조건에 위배되어 오류메세지가 발생
왜냐하면 기본값으로 with check가 설정 되어 있기 때문
*/

alter table usertbl
	with nocheck
	add constraint ck_name
	check (name not in ('이승기'));
/*
이후 부터 데이터 삽입에 이승기는 입력 불가
*/

-- 제약조건 삭제
alter table usertbl drop constraint ck_name;

-- defualt
create table userTBL_cd(
	userID char(8) not null primary key,
	name nvarchar(10) not null,
	birthYear int not null default year(getdate()),
	addr nchar(2) not null default N'서울',
	mobile1 char(3),
	mobile2 char(8),
	height smallint default 170,
	mDate date
);

alter table usertbl
	add constraint cd_addr
	default N'서울' for addr;

-- sparse 열
create table chartbl (id int identity, data char(100) null);
create table sparsechartbl (id int identity, data char(100) sparse null);

declare @i int=0
while @i < 10000
begin
	insert into chartbl values (null);
	insert into chartbl values (null);
	insert into chartbl values (null);
	insert into chartbl values (replicate('A',100));
	insert into sparsechartbl values (null);
	insert into sparsechartbl values (null);
	insert into sparsechartbl values (null);
	insert into sparsechartbl values (replicate('A',100));
	set @i += 1
end

select * from chartbl;
select * from sparsechartbl;
/*
테이블의 오른쪽 마우스 속성에 저장소를 클릭하게 된다면
같은 데이터를 삽입하였지만
chartbl에는 4.531 MB
sparsechartbl에는 1.664 MB
*/

create table chartbl1 (id int identity, data char(100) null);
create table sparsechartbl1 (id int identity, data char(100) sparse null);

declare @i int=0
while @i < 40000
begin
	insert into chartbl1 values (replicate('A',100));
	insert into sparsechartbl1 values (replicate('A',100));
	set @i += 1
end
/*
null 값없이 실제 있는 값만 삽입한다면
chartbl에는 4.531 MB
sparsechartbl에는 5.047 MB

sparsechartbl에 용량을 더 많이 차지하는 것으로 확인 됨
즉, null값이 없으면 sparse열이 용량을 더 차지하게 됨
*/

-- 임시테이블 => tempDB에 저장!!!
create table #temptbl (id int, txt nvarchar(10));
create table ##temptbl (id int, txt nvarchar(10));
insert into #temptbl values (1, N'지역임시테이블');
insert into ##temptbl values (2, N'지역임시테이블');
select * from #temptbl;
select * from ##temptbl;

-- 테이블 삭제
use tableDB
drop table buyTBL;
drop table userTBL;
drop table a1, chartbl, chartbl1, probtbl, sparsechartbl, sparsechartbl1, usertbl_cd;

-- 열 추가
alter table usertbl add homepage nvarchar(30) default 'http://www.hanb.co.kr';
select * from usertbl;

-- 열 삭제
alter table usertbl drop constraint DF__userTBL__homepag__3D5E1FD2;
alter table usertbl drop column homepage;
/*열에 제약조건이 있으면 해당 제약조건을 삭제 해야 열을 삭제 가능*/

-- 열 형식 변경
alter table usertbl alter column name nvarchar(20);

-- 열 이름 변경
exec sp_rename 'usertbl.name', 'username', 'column';
select * from usertbl;
exec sp_rename 'usertbl.username', 'name', 'column';
select * from usertbl;

-- 예제
use tableDB;
go
create table userTBL(
	userID char(8),
	name nvarchar(10),
	birthYear int,
	addr nchar(2),
	mobile1 char(3),
	mobile2 char(8),
	height smallint,
	mDate date
);
go
create table buyTBL(
	num int identity,
	userid char(8),
	proName nchar(6),
	groupName nchar(4),
	price int,
	height smallint
);
go
insert into userTBL values
	('LSG',N'이승기',1987,N'서울','011','11111111',182,'2008-8-8'),
	('KBS',N'김범수',null,N'경남','011','22222222',173,'2012-4-4'),
	('KKH',N'김경호',1871,N'전남','019','33333333',177,'2007-7-7'),
	('JYP',N'조용필',1950,N'경기','011','44444444',166,'2009-4-4');
go
insert into buyTBL(userid, proName, groupName, price, height) values
	('KBS',N'운동화',null,30,2),
	('KBS',N'노트북',N'전자',1000,1),
	('JYP',N'모니터',N'전자',200,1),
	('BBK',N'모니터',N'전자',200,5);
go
alter table usertbl add constraint pk_usertbl_userid primary key (userID);
/*null 허용이라 기본키 생성 불가*/
go
alter table usertbl alter column userID char(8) not null;
alter table usertbl add constraint pk_usertbl_userid primary key (userID);
/*not null로 설정하고 기본키를 생성*/
alter table buyTBL add constraint pk_buytbl_num primary key (num);
/*identity를 설정하면 알아서 not null로 설정*/
go
alter table buytbl with nocheck
	add constraint fk_usertbl_buytbl foreign key (userID) references usertbl(userID);
/*
with check로 하면 BBK가 부모테이블에 없는데 있어서 오류가 발생
*/
insert into buytbl values ('BBK',N'청바지',N'전자',80,10);
/*제약조건 위반으로 데이터 삽입 불가*/
go
/*외래키에 자식테이블에 없는 데이터를 넣기 위해*/
alter table buytbl nocheck constraint fk_usertbl_buytbl;
insert into buytbl values ('BBK',N'메모리',N'전자',80,10);
insert into buytbl values ('SSK',N'책',N'서적',15,5);
insert into buytbl values ('EJW',N'책',N'서적',15,2);
insert into buytbl values ('EJW',N'청바지',N'의류',50,1);
insert into buytbl values ('BBK',N'운동화',Null,30,2);
insert into buytbl values ('EJW',N'책',N'서적',15,1);
insert into buytbl values ('BBK',N'운동화',Null,30,2);
/*다시 외래키 제약 조건 on*/
alter table buytbl check constraint fk_usertbl_buytbl;
go
alter table usertbl
	with nocheck
	add constraint ck_birthyear 
	check (birthyear >= 1900 and birthyear <= year(getdate()));
go
insert into userTBL values
	('SSK',N'성시경',1979,N'서울',null,null,186,'2013-12-12'),
	('LJB',N'임재범',1963,N'서울','016','66666666',182,'2009-9-9'),
	('YJS',N'윤종신',1969,N'경남',null,null,170,'2005-5-5'),
	('EJW',N'은지원',1972,N'경북','011','88888888',174,'2014-3-3'),
	('JKW',N'조관우',1965,N'경기','018','99999999',172,'2010-10-10'),
	('BBK',N'바비킴',1973,N'서울','010','00000000',176,'2013-5-5');
go
update userTBL set userid = 'VVK' where userid='BBK'; 
/*
자식테이블에 BBK가 있는데 부모 테이블에 BBK가 
사라지므로 제약조건에 위배되어 데이터 변경 불가
*/
go
alter table buyTBL nocheck constraint fk_usertbl_buytbl;
update userTBL set userid = 'VVK' where userid='BBK'; 
alter table buyTBL check constraint fk_usertbl_buytbl;
select * from userTBL;
go
alter table buyTBL nocheck constraint fk_usertbl_buytbl;
update userTBL set userid = 'BBK' where userid='VVK'; 
alter table buyTBL check constraint fk_usertbl_buytbl;
select * from userTBL;
go
/*on update cascade*/
alter table buytbl drop constraint fk_usertbl_buytbl;
alter table buytbl add constraint fk_usertbl_buytbl foreign key (userid) references usertbl(userid) on update cascade;
update userTBL set userid = 'VVK' where userid='BBK';
select * from userTBL;
select * from buytbl;
/*부모테이블에서 변경된 값이 자식테이블에도 영향을 미침*/
go
/*on delete cascade*/
alter table buytbl drop constraint fk_usertbl_buytbl;
alter table buytbl 
	add constraint fk_usertbl_buytbl 
		foreign key (userid) references usertbl(userid) on update cascade on delete cascade;
delete from usertbl where userid ='VVK';
select * from userTBL;
select * from buytbl;
/*부모테이블에서 삭제된 값이 자식테이블에도 영향을 미쳐 해당 조건의 데이터가 사라짐*/

-- 메모리 테이블
/*RAM이 좋지 않아 실습 진행 X*/
/*
create table [메모리테이블명] (컬럼...) with (memory_optimized=on);
*/

-- 스키마
create database schemaDB;
use schemaDB;
go
create schema userSchema;
go
create schema buySchema;
go
create table userSchema.usertbl(id int);
create table buySchema.usertbl(num int);
create table buySchema.probtbl(pid int);
go
select * from userSchema.usertbl;

-- view
use tableDB;
go
create view v_usertbl
as
	select userid, name, addr from userTBL;
go
select * from v_usertbl;
go
/*예제*/
create view v_userbuytbl
as
	select u.userid "user id", u.name "user name", b.proname "product name",
	       u.addr, u.mobile1+u.mobile2 "mobile phone"
	from usertbl U
		 inner join
		 buytbl B
			on u.userid = b.userid;
go
select * from v_userbuytbl;
select "user name", "product name", "mobile phone" from v_userbuytbl;

-- view의 소스 확인
select * from sys.sql_modules;
select object_name(object_id), definition from sys.sql_modules;

-- view의 소스를 못보게 하는 방법
create view v_usertbl_encryption
	with encryption
as
	select userid, name, addr from usertbl;
go
select * from sys.sql_modules;
select object_name(object_id) "뷰이름", definition from sys.sql_modules;

-- view의 update
update v_usertbl set addr = '부산' where userid = 'JKW';

-- view의 데이터 삽입
insert into v_usertbl values ('KBM','김병만','충북');
select * from v_usertbl;

-- 집계함수 활용 뷰 생성
create view v_sum
as 
	select userid, sum(price*height) as total
	from buytbl
	group by userid;
go
select * from v_sum;

