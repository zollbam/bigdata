/*
mssql
날짜 23-06-18

트랜잭션
https://youtu.be/6i0lVnVBd0U
https://youtu.be/6i0lVnVBd0U

일반적으로 DB를 논리적, 데이터 파일과 로그 파일을 물리적이라고 함

익스텐트(extent) = 8페이지 = 64kbyte

트랜잭션
 - 하나의 논리적 작업 단위로 수행되는 일련의 작업 => SQL의 묶음
 - 데이터를 변경시키는 INSERT, UPDATE, DELETE의 묶음
 - 전부 되거나 전부 안되거나의 의미 포함
 - 특성
  1) 원자성: 분리할 수 없는 하나의 단위 => 모두 수행되거나 하나도 수행 X
  2) 일관성: 모든 데이터는 일관 => 잠금과 관련
  3) 격리성: 현재 접근하고 있는 데이터는 다른 트랜잭션에서 격리
  4) 영속성: 트랜잭션이 정상적으로 종료된다면 그 결과는 시스템 오류가 발생해도 시스템에 영구적으로 적용

트랜잭션 문법
 - BEGIN TRANSACTION
       SQL문
   COMMIT TRANSACTION or ROOLBACK TRANSACTION
 - BEGIN TRANSACTION = BEGIN TRAN
 - COMMIT TRANSACTION = COMMIT TRAN = COMMIT WORK
 - ROOLBACK TRANSACTION = ROOLBACK TRAN

트랜잭션 위치 저장
 - SAVE TRAN [저장점_이름]

트랜잭션 과정
 1. update 쿼리문을 실행
 2. 데이터 파일에서 해당 값을 찾아 메모리(데이터 캐시)에 불러옴
 3. 메모리에서 값을 변경
 4. 로그파일에 update쿼리문을 저장
  => 아직 데이터 파일에는 아직 값이 변경되지 않았다.
 5. 여러 개의 쿼리문이 반복적으로 일어남
 6. commit tran가 실행
 7. 여러 쿼리문으로 최종 결과가 반영된 메모리가 데이터 파일에 적용
 8. 데이터 파일의 데이터가 변경이 완료되면 로그파일에 체크포인트가 표시!!!

트랜잭션의 종류
 1) 자동 커밋 트랜잭션
  - 기본적으로 update, insert 등을 쓰면 우리가 안 썼을 뿐 begin ~ commit tran 가 자동으로 입력되어 실행됨
 2) 명시적 트랜잭션
  - begin ~ commit tran를 직접 써서 실행
 3) 암시적 트랜잭션
  - 오라클 등의 데이터베이스와 호환을 위해 사용
  - begin tran는 붙여 주지만 commit이나 rollback은 직접 써주어야 함
  - SET IMPLICIT_TRANSACTIONS ON => begin tran는 할필요 없지만 commit(rollback) tran는 꼭 해주어야 함

*/
-- sqldb 복원
restore database sqldb from disk ='C:\Program Files\Microsoft SQL Server\MSSQL13.GYCOM\MSSQL\Backup\sqlDB.bak';

-- create database testdb_gy;
/*
실제로 만들지는 않음

C:\Program Files\Microsoft SQL Server\MSSQL13.GYCOM\MSSQL\DATA 경로에 
실제 데이터 파일인 mdf파일과 트랜잭션 로그 파일인 ldf파일이 생성
*/

use sqldb;
select * from buyTbl;
select * from userTbl;

-- 데이터 수정
update userTbl set addr = N'제주' where userID = N'KBS'
update userTbl set addr = N'미국' where userID = N'KKH'
update userTbl set addr = N'호주' where userID = N'JYP'
/*
이때 3줄을 묶어서 실해하면 트랜잭션이 한번 발생 한 것 처럼 보이지만
한줄마다 각각 트랜잭션이 발생되어 총 3번이 발생!!!
*/

-- 트랜잭션 설정
begin tran
	update userTbl set addr = N'대구' where userID = N'KBS'
	update userTbl set addr = N'호주' where userID = N'KKH'
	update userTbl set addr = N'경남' where userID = N'JYP'
commit tran;
/*
이때 3줄 가운데 한개 라도 실패하면 이 트랜잭션은 commit이 안됨!!!
또한, 트랜잭션은 1번이라고 본다!! => SQL의 묶음
*/

-- 트랜잭션 로그 파일의 역할 실습
use sqldb;
go
create table testtbl (num int);
go
insert into testtbl values (1);
insert into testtbl values (2);
insert into testtbl values (3);

select * from testtbl;

begin transaction
	update testtbl set num = 11 where num=1;
	update testtbl set num = 22 where num=2;
	update testtbl set num = 33 where num=3;
-- rollback tran
commit transaction
/*
if, 한줄씩 실행시 begin transaction하면 트랜잭션이 실행
    update testtbl set num = 11 where num=1;하고 새 쿼리를 열어
	select * from testtbl;하면 testtbl이 잠금 상태라서 테이블을 볼 수 없다!!
*/

select @@TRANCOUNT;
/*
현재 트랜잭션의 개수를 볼 수 있음
*/

use tempdb;
alter database sqldb set allow_snapshot_isolation on;
set transaction isolation level snapshot;
/*
테이블 잠금이 걸려도 mdf파일에서 읽어 오게 하는 기능
*/

use tempdb;
alter database sqldb set allow_snapshot_isolation off;

-- 트랜잭션을 사용하는 이유 실습
use sqldb;
create table bankbook (
	uName nvarchar(10),
	uMoney int,
	constraint ck_money check (uMoney >=0)
);
go
insert into bankbook values (N'구매자', 1000);
insert into bankbook values (N'판매자', 0);
select * from bankbook;

/*구매자 => 판매자 500 송금*/
update bankbook set uMoney = uMoney - 500 where uName = N'구매자';
update bankbook set uMoney = uMoney + 500 where uName = N'판매자';
select * from bankbook;
/*
하나의 update문은

begin tran
update bankbook set uMoney = uMoney - 500 where uName = N'구매자';
commit tran

과 동일 => 자동 커밋 트랜잭션
*/

/*구매자 => 판매자 600 송금*/
update bankbook set uMoney = uMoney - 600 where uName = N'구매자';
update bankbook set uMoney = uMoney + 600 where uName = N'판매자';
select * from bankbook;
/*
check조건의 충돌로 쿼리문 실행 X

그런데 문제는 구매자는 ck_money제약조건으로 값이 500 그대로 인데
판매자는 ck_money제약조건에 위배 되지 않으므로 1100 으로 변경 됨
 => 판매자와 구매자의 2개 update문을 자동 커밋이 아닌 명시적으로 변경 해줘야지
    은행 같은 곳에서 이러한 큰 문제가 발생하지 않게 할 수 있다!!
*/
update bankbook set uMoney = uMoney - 600 where uName = N'판매자';
select * from bankbook;

begin tran
	update bankbook set uMoney = uMoney - 600 where uName = N'구매자';
	update bankbook set uMoney = uMoney + 600 where uName = N'판매자';
commit tran
select * from bankbook;
/*
똑같이 판매자가 1100

why? check 제약 조건에 걸리면 rollback이 안됨!!!!
*/

begin try
	begin tran
		update bankbook set uMoney = uMoney - 600 where uName = N'구매자';
		update bankbook set uMoney = uMoney + 600 where uName = N'판매자';
	commit tran
end try
begin catch
	rollback tran
end catch
select * from bankbook;
/*
어떤 오류가 발생하던 롤백 => 구매자와 판매자의 uMoney가 그대로 유지!!!
*/
