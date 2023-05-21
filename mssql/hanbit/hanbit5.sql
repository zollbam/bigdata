/*
https://youtu.be/z59ubRHosyc
https://youtu.be/R8fYHISze0s
https://youtu.be/7syKEHGSwgo
https://youtu.be/7syKEHGSwgo

SQL Server 2016 전체 운영 실습(1,2,3,4)

DBMS > DB > table > data > 데이터 조회 및 활용

DB 객체
 - 테이블
 - 뷰
 - 인덱스
 - 저장 프로시저
 - 함수
 - 트리거
  * 삭제할 데이터를 자동으로 다른 곳에 저장
  * insert, update, delete작업이 발생되면 실행되는 코드
 - 커서
*/

-- DB 생성
create database ShopDB;

-- DB 선택
use ShopDB;

-- 테이블 생성
create table memberTBL (
	memberID char(8) not null,
	memberName nchar(5) not null,
	memberAddress nchar(20)
);

create table productTBL (
	productName nchar(4) not null,
	cost int not null,
	makeDate date,
	company nchar(5),
	amout int not null, 
);

create table "my test TBL" ( -- 띄어쓰기 테이블 생성
	a int,
	b nchar(10)
);

-- 데이터 삽입
insert into [dbo].[memberTBL] values
	('Dan', '당탕이', '경기 부천'),
	('Han', '한주연', '인천 남구'),
	('Jee', '지은이', '서울 은평'),
	('Sang', '상길이', '경기 성남'),
	('Naota', '나오타', '주소 모름');

insert into [dbo].[productTBL] values
	('컴퓨터', 10, '2017-01-01', '삼성', 17),
	('세탁기', 20, '2018-09-01', 'LG', 3),
	('냉장고', 5, '2019-02-01', '대우', 22);

-- 데이터 삭제
delete from [dbo].[memberTBL] where memberID = 'Naota';

-- 테이블 조회
select * from memberTBL;
select top 3 * from memberTBL; -- 위에서 부터 3개 행만 
select memberName, memberAddress from memberTBL; -- 특정 열만
select * from memberTBL where memberName = '지은이'; -- 조건에 맞는 데이터

select * from [dbo].[productTBL] where productName = '세탁기';

-- 테이블 복사
select Name, ProductNumber, ListPrice, Size 
	into indexTBL
from AdventureWorks.Production.Product;

SELECT * FROM INDEXTBL WHERE NAME = 'MINIPUMP';
/*
실제 실행 계획 포함을 눌러 실행 결과 속도를 살펴 보자

커서 전체 대문자 변환 단축키
ctrl + shift + U

커서 전체 소문자 변환 단축키
ctrl + shift + L
*/

-- 인덱스 생성
CREATE INDEX IDX_INDEXTBL_NAME ON INDEXTBL(NAME);
/*
create index [인덱스명] on [테이블명][(컬럼명)];

100%로 데이터를 찾던것을 50% 감소 확인
*/

-- 뷰 생성
create view uv_memberTBL as 
	select memberName, memberAddress 
	from memberTBL;

select * from uv_memberTBL;

-- 프로시저 생성
create procedure myProc
as 
select * from [dbo].[memberTBL] where memberName = '당탕이'
select * from [dbo].[productTBL] where productName = '세탁기';

exec myProc;
execute myProc;
/*execute는 exec로 줄여서도 사용가능*/

-- 프로시저 변경
alter procedure myProc
as 
select * from [dbo].[memberTBL] where memberName = '지은이'
select * from [dbo].[productTBL] where productName = '세탁기';

exec myProc;
execute myProc;
/*다른 결과가 나옴*/

-- 트리거 생성
insert into memberTBL values ('Figure', '연아', '경기도 군포시 당정동');
select * from memberTBL;
update memberTBL set memberAddress = '서울 강남구 역삼동' where memberName = '연아'; 
delete from memberTBL where memberName = '연아';
/*레코드 삭제만 되고 아무 일 일어나지 X*/

create table deletedMemberTBL(
	memberID char(8),
	memberName nchar(5),
	memberAddress nchar(20),
	deleteDate date /*삭제한 날짜*/
); /*삭제된 레코드 저장 테이블*/

create trigger trg_deletedMemvberTBL /*트리거 이름*/
	on memberTBL /*트리거를 부착할 테이블*/
	after delete /*삭제후에 작동하게 지정*/
as
	/*delted 테이블의 내용을 백업 테이블에 삽입*/
	insert into deletedMemberTBL
		select memberID, memberName, memberAddress, getdate() from deleted;

delete from [dbo].[memberTBL] where memberName = '당탕이';

select * from [dbo].[memberTBL];
select * from [dbo].deletedMemberTBL;

-- DB 백업
/* 
데이터베이스 => 데이터베이스 복원을 누름
*/
 /*확인*/
select * from productTBL; 
/*조회*/
delete from productTBL;
