/*
mssql
날짜 23-07-03

트리거
https://youtu.be/jQlYcO6wFzU
https://youtu.be/sQGmggqJCfQ

트리거란
 - 사전적 의미는 방아쇠 => 방아쇠를 당기면 자동으로 총알이 나감
 - 테이블에 무슨 일이 생기면 자동으로 실행
 - 테이블에 삽입, 수정, 삭제 등의 작업(이벤트)이 발생 시에 자동으로 작동되는 개체 => DML문의 이벤트 발생시 작동
 - 테이블에 행이 삭제되는 순간에 B테이블에 A테이블에서 삭제된 행의 내용, 시간, 삭제한 사용자를 기록하는 기능
 - 테이블 또는 뷰에 부착되는 프로그램 코드

트리거의 종류
 1) AFTER 트리거
  - 테이블에 삽입, 수정, 삭제 등의 작업 후 작동하는 트리거
  - 테이블에만 부착되며 뷰에는 부착 안됨
 2) INSTEAD OF 트리거
  - 이벤트가 발생하기 전에 작동하는 트리거
  - 테이블뿐아니라 뷰에도 작동되며 주로 뷰에 업데이트가 가능하도록 할 때 사용

트리거 문법
 - create trigger [트리거 이름]
       as {테이블/뷰 이름}
	   with encryption
	   [for or after / instead of]
	   [insert, update, delete]
	   as
	       [실행할 SQL 문들];

트리거가 생성하는 임시 테이블
 0) 개념
  - 사용자가 임의로 변경 작업을 할 수 없고 단지 select만 가능
 1) inserted
  - insert와 update 작업 시에 변경 후의 행 데이터와 동일한 데이터가 저장
  - 데이터가 삽입 또는 변경되고 그 다음에 변경된 데이터가 저장
 2) deleted
  - delete와 update 작업 시에 변경 전의 행 데이터와 동일한 데이터가 저장
  - 데이터가 삭제 또는 변경되고 그 다음에 변경되기 전 데이터가 저장

instead of 트리거
 - 테이블에 변경이 가해지기 전에 작동되는 트리거
 - before 트리거라고도 함
 - 주로 뷰에 행이 삽입 되거나 변경, 삭제때 사용
 - 시도된 insert, update, delete문은 무시되고 대신에 instead of트리거가 작동

다중트리거
 - 하나의 테이블에 동일한 트리거가 여러개 부착
 - 예를 들면 after insert 트리거가 한 개 테이블에 2개이상 부착 될 수 도 있음

중첩 트리거
 - 트리거가 또 다른 트리거를 작동 시키는 것
 - 32단계 까지 가능

재귀 트리거
 - 트리거가 작동해서 다시 자신의 트리거를 작동 시키는 것
 - 간접과 직접 2가지 존재
 - 32단계까지 반복
 - 빠져 나올 수 있는 루틴을 마련해 놓아야지 안 그럼면 무한루프를 돌게 된다.

트리거 순서
 - 테이블에 여러 트리거가 존재 한다면 처음과 끝은 지정 할 수 있어도 중간 부분은 지정 불가
*/
-- DB 복원
restore database sqldb from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL13.GYCOM\MSSQL\Backup\sqldb.bak' with replace;

-- 간단한 트리거 실습
use tempdb;
create table testtbl(id int, txt nvarchar(5));
go
insert into testtbl values (1, N'원더걸스');
insert into testtbl values (2, N'에프터스쿨');
insert into testtbl values (3, N'에이오에이');
select * from testtbl;
go
create trigger testtrg -- 트리거 이름
	on testtbl -- 트리거를 부착할 테이블
	after delete, update -- 삭제, 수정 후에 작동하도록 지정
	as
		print(N'트리거가 작동했습니다'); -- 트리거 실행시 작동되는 코드들
go
insert into testtbl values (4, N'나인뮤지스');
/*insert는 설정을 안 했으니 아무일이 일어나지 않음*/
go
update testtbl set txt = N'에이핑크' where id = 3;
/*update는 설정 했으므로 print문이 출력*/
go
delete from testtbl where id = 4;
go
select * from testtbl;

-- after 트리거
restore database sqldb from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL13.GYCOM\MSSQL\Backup\sqlDB.bak' with replace;
use sqldb;
drop table buytbl;
go
create table backup_usertbl(
  userid char(8) not null primary key
, name nvarchar(10) not null
, birthyear int not null
, addr nchar(2) not null
, mobile1 char(3)
, mobile2 char(8)
, height smallint
, mdate date
, modtype nchar(2) -- 변경된 타입. '수정' 또는 '삭제'
, moddate date -- 변경된 날짜
, moduser nvarchar(256) -- 변경한 사용자
);
go
create trigger trg_backupusertbl -- 트리거 이름
	on usertbl -- 트리거를 부착할 테이블
	after update, delete -- 삭제, 수정, 후에 작동하도록 지정
	as
		declare @modtype nchar(2) -- 변경타입

		if (columns_updated() > 0) -- 업데이트가 되었다면
		/*columns_updated()가 0초과이면 업데이트가 일어 난거임*/
			begin
				set @modtype = N'수정'
			end
		else -- 삭제가 되었다면
			begin
				set @modtype = N'삭제'
			end

		-- delete 테이블의 내용(변경 전의 내용)을 백업 테이블에 삽입
		insert into backup_usertbl
		    select userid, name, birthyear, addr, mobile1, mobile2, height, mdate, @modtype, getdate(), user_name()
			  from deleted;
		/*deleted는 시스템 테이블로 데이터가 삭제되면 잠깐 들어감*/
go
update usertbl set addr=N'몽고' where userid='JKW';
select * from backup_usertbl;
go
delete from usertbl where height >= 177;
select * from backup_usertbl;
go
truncate table usertbl;
/*truncate로 삭제된 데이터는 트리거가 작동 안함*/
select * from backup_usertbl;
select * from usertbl;

-- insert 트리거 만들기 
create trigger trg_insertusertbl
	on usertbl
	after insert
	as 
		raiserror(N'데이터의 입력을 시도했습니다.',10, 1)
		raiserror(N'귀하의 정보가 서버에 기록되었습니다.',10, 1)
		raiserror(N'그리고, 입력한 데이터는 적용되지 않습니다.',10, 1)

		rollback tran;
go
insert into userTbl values (N'ABC', N'에비씨', 1977, N'서울', N'011', N'11111111', 181, '2019-12-31');

-- instead of트리거
use sqldb;
go
create view uv_deliver
as
select 
  b.userid
, u.name
, b.prodname
, b.price
, b.amount
, u.addr
  from buytbl b
       inner join
	   usertbl u
	       on b.userid = u.userid;
go
select * from uv_deliver;
go
insert into uv_deliver values (N'JBI',N'존밴이',N'구두',50,1,N'인천');
/*
복합 뷰로 데이터 삽입이 불가!!
이런 부분을 해결하기 위한 instead of 트리거를 사용한다
*/
go
create trigger trg_insert
on uv_deliver
instead of insert
as 
begin 
    insert into usertbl(userid, name, birthYear, addr, mdate)
		select userid, name, 1900, addr, getdate() from inserted

	insert into buytbl(userid, prodname, price, amount)
		select userid, prodname, price, amount from inserted
end;
go
insert into uv_deliver values (N'JBI',N'존밴이',N'구두',50,1,N'인천');
/*이제는 오류 없이 실행*/
go
select * from buytbl where userid = 'jbi';
select * from usertbl where userid = 'jbi';

-- 트리거 확인
exec sp_helptrigger uv_deliver;
/*해당 테이블의 트리거의 정보를 확인*/
exec sp_helptext trg_insert;
/*트리거 생성 쿼리를 볼수 있다.*/
exec sp_rename 'dbo.trg_insert', 'dbo.trg_uvInsert';
/*
트리거의 이름 변경
눈에 보이 이름만 바뀌었지 시스템 상으로는 변경 안됨
*/
drop trigger dbo.trg_uvInsert;
/*삭제 안됨*/
go
exec sp_helptrigger uv_deliver;
/*trg_insert라고 이름이 보임*/
go
exec sp_helptext trg_uvInsert;
exec sp_helptext trg_insert;
/*변경 이름이나 이전 이름 둘다로 해도 오류*/
go
drop trigger trg_insert;
/*
 - 예전이름으로 삭제해도 오류메세지
 - 이름 변경을 하지 않는다면 자연스럽게 삭제 가능
*/
go
drop view uv_deliver;
/*뷰와 트리거 모두 삭제*/

-- 중첩 트리거
create database triggerdb;
go
use triggerdb;
create table ordertbl -- 구매 테이블
	(orderno int identity, -- 구매 일련번호
	 userid nvarchar(5), -- 구매한 회원아이디
	 prodname nvarchar(5), -- 구매한 물건
	 orderamount int); -- 구매한 개수
go
create table prodtbl -- 물품 테이블
	(prodname nvarchar(5), -- 물건 이름
	 account int); -- 남은 수량
go
create table delivertbl -- 배송 테이블
	(deliverno int identity, -- 배송 일련 번호
	 prodname nvarchar(5), -- 배송할 물건
	 amount int); -- 배송할 물건 개수
go
insert into prodtbl values (N'사과', 100);
insert into prodtbl values (N'배', 100);
insert into prodtbl values (N'귤', 100);
go 
/*물품테이블에서 개수 감소시키는 트리거*/
create trigger trg_order
on ordertbl
after insert
as
	print N'1. trg_order를 실행합니다.'
	declare @orderamount int
	declare @prodname nvarchar(5)

	select @orderamount = orderamount from inserted
	select @prodname = prodname from inserted

	update prodtbl set account -= @orderamount
		where prodname = @prodname;
go
/**/
create trigger trg_prod
on prodtbl
after update
as
	print N'2. trg_prod를 실행합니다.'
	declare @prodname nvarchar(5)
	declare @amount int

	select @prodname = prodname from inserted
	select @amount = D.account - I.account
	  from inserted I, deleted D -- 주문 개수 = 변경 전의 개수 - 변경 후의 개수

	insert into delivertbl(prodname, amount) values(@prodname, @amount);
go
insert into ordertbl values ('JOHN',N'배', 5);
GO
select * from ordertbl;
select * from prodtbl;
select * from delivertbl;

















