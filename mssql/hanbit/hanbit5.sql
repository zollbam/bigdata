/*
https://youtu.be/z59ubRHosyc
https://youtu.be/R8fYHISze0s
https://youtu.be/7syKEHGSwgo
https://youtu.be/7syKEHGSwgo

SQL Server 2016 전체 운영 실습(1,2,3,4)

DBMS > DB > table > data > 데이터 조회 및 활용

DB 객체
 - 테이블
 -


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

