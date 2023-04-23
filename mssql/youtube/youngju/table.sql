-- 테이블 생성
create table Persons(
	PersonID int,
	LastName varchar(255),
	Firstname varchar(255),
	Address varchar(255),
	City varchar(255)
);

-- 테이블 확인
go
select * from persons;

-- 테이블 제거
drop table persons;

-- 테이블 변경
-- 1) 새로운 열 추가
alter table persons add newcol int
go
select * from dbo.persons;

-- 2) 기존열 삭제
alter table persons drop column newcol
go 
select * from persons;

-- 3) 타입 변경
alter table persons alter column personid varchar(255)
go 
select * from persons;

alter table persons alter column personid int
go 
select * from persons;

-- 데이터 삽입
insert into persons(lastname, firstname) values
	('ALFRED', 'HITCHCOK')
go
select * from persons;

insert into persons values
	(20, 'YA', 'NOLJA', 'T ROAD 112', 'SEOUL')
go
select * from persons;

-- 데이터 삭제
delete from persons where personid is null
go 
select * from persons;

-- 데이터 수정
update persons set address = 'jagalchi-ro 112', city='BUSAN' where personid=20
go 
select * from persons;

-- 제약조건
create table Customers (
	ID int not null,
	LastName varchar(255) not null,
	FirstName varchar(255) not null,
	Age int
);

drop table customers;

-- 제약조건 추가
alter table customers add constraint id_uq unique(id); -- primary key 조건으로 변경

insert into customers values
	(10, 'A', 'B',30),
	(20, 'C', 'D',25)
go 
select * from customers;

insert into customers values
	(10, 'E', 'F', 45)
go 
select * from customers;
/*
10이 이미 들어가 있는데 10을 또 삽입하여 unique에 제약이 걸려 삽입이 불가
*/

-- 제약 조건 추가(기본키)
alter table customers add constraint pk_customers primary key (id);

-- 제약 조건 삭제
alter table customers drop constraint pk_customers;

-- 제약 조건 추가(외래키)
create table Customers(
	PersonID int primary key,
	LastName varchar(255) not null,
	FirstName varchar(255) not null,
	Age int
)
go
insert into customers values
	(1, 'Hansen', 'Ola', 30),
	(2, 'Svendson', 'Tove', 23),
	(3, 'Hansen', 'Kari', 20)
go
select * from customers;

create table Orders (
	OrderID int primary key,
	OrderNumber int not null,
	PersonID int,
	constraint fk_orders foreign key(personid) references customers(personid)
)
go 
insert into orders values
	(1, 77895, 3),
	(2, 44678, 3),
	(3, 22456, 2),
	(4, 24562, 1)
go
select * from orders;

insert into orders values
	(5, 45584, 4);
/*
customers의 personid에는 4라는 값이 없으므로 orders에 personid에는 4라는 값 삽입 불가
*/

drop table orders;
