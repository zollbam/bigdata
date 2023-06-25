/*
mssql
날짜 23-06-18

저장 프로시저와 사용자 정의 함수
https://youtu.be/b1YF7CKQ3Fw
https://youtu.be/2K6w3jTy6uQ
https://youtu.be/R9-BLGQ5DYk

저장 프로시저
 - SQL SERVER에서 제공되는 프로그래밍 기능
 - 쿼리문의 집합으로 어떤 동작을 일괄 처리할 때 사용

매개변수의 사용
 - 입력 매개변수 지정: @입력_매개_변수_이름 데이터 형식 [= 디폴트값]
 - 입력 매개변수가 있는 저장 프로시저를 실행: execute 프로시저_이름 [전달값]
 - 출력 매개변수 지정: @출력_매개_변수_이름 데이터 형식 output
 - 출력 매개변수가 있는 저장 프로시저를 실행: execute 프로시저_이름 @변수명 output

프로시저 특징
 1) SQL Server의 성능을 향상
  - 프로시저를 처음 실행 하면 최적화, 컴파일 등의 과정을 거쳐서 그 결과가 캐시에 저장
  - 같은 프로시저를 실행하면 캐시(메모리)에 있는 것을 가져다 사용하므로 실행 속도가 빨라짐
 2) 유지관리가 간단
  - c##이나 자바 등의 클라이언트 응용 프로그램에서 직접 sql문을 작성하지 않고 저장 프로시저 이름만 호출하도록 설정하여
    데이터베이스에 관련된 저장 프로시저의 내용을 일관되게 수정/유지보수 등의 작업을 할 수 있다.
 3) 모듈식 프로그래밍 가능
 4) 보안을 강화
  - 테이블에 접근권한을 주지 않고 저장 프로시저에만 접근 권한을 줌으로써 
 5) 네트워크 전송량의 감소

사용자 정의 함수
 - 복잡한 프로그래밍이 가능하도록 지원
 - return문에 의해서 특정값을 돌려주는 기능
 - 프로시저는 excute 또는 exec에 의해서 실행되지만 
   함수는 주로 select 문에 포함되서 실행
*/
use sqldb;
go
create procedure usp_users
as 
	select * from usertbl;
go

exec usp_users;

-- DB복원
use tempdb;
go
restore database sqldb from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL13.GYCOM\MSSQL\Backup\sqldb.bak' with replace;

-- 프로시저 실습
use sqldb;
go
create procedure usp_users1
	@userName nvarchar(10)
as 
	select * from usertbl where name = @userName;
go
exec usp_users1 '조관우';
go
exec usp_users1 '이승기';

-- 여러 개의 매개변수
create procedure usp_users2
	@userBirth int,
	@userHeight int
as
	select * 
	  from userTbl
	 where birthYear > @userBirth 
	       and 
		   height > @userHeight;
go
exec usp_users2 1970, 178;
exec usp_users2 @userHeight=178, @userBirth = 1970;
/*매개변수명을 직접입력하면 순서는 상관 없다!!*/

-- 매개변수에 기본값
create procedure usp_users3
	@userBirth int = 1970,
	@userHeight int = 178
as
	select * 
	  from userTbl
	 where birthYear > @userBirth 
	       and 
		   height > @userHeight;
go
exec usp_users3;
exec usp_users3 1980, 180;

-- 입력 & 출력 매개변수
create procedure usp_users4
	@txtvalue nchar(10),
	@outvalue int out
as
	insert into testtbl values (@txtvalue);
	/*프로시저를 만들때 미리 테이블이나 뷰가 없어도 됨*/
	select @outvalue = ident_current('testtbl'); 
	/*ident_current: 현재 identity값 반환해주는 함수*/
go
create table testtbl(
  id int identity
, txt nchar(10)
);
go
declare @myvalue int;
exec usp_users4 '0', @myvalue out;
exec usp_users4 '테스트2', @myvalue out;
print '현재 입력된 ID 값 ==> ' + cast(@myvalue as char(5));

-- if~else문으로 프로시저
create proc usp_ifelse
	@username nvarchar(10)
as 
	declare @byear int -- 출생년도를 저장할 변수 선언
	/*@byear는 프로시저 안에서만 사용되는 변수*/

	select @byear = birthyear 
	  from usertbl
	 where name = @username;

	if (@byear >= 1980)
		begin
			print '아직 젊군요..';
		end
	else
		begin
			print '나이가 지긋하네요..';
		end
go
exec usp_ifelse '이승기';
exec usp_ifelse '은지원';
exec usp_ifelse '바비킴';

-- case문으로 프로시저
create proc usp_case
	@username nvarchar(10)
as
	declare @byear int
	declare @tti nchar(3) -- 띠

	select @byear = birthyear 
	  from usertbl
	 where name = @username;

	set @tti = case
			       when (@byear % 12 = 0) then '원숭이'
				   when (@byear % 12 = 1) then '닭'
				   when (@byear % 12 = 2) then '개'
				   when (@byear % 12 = 3) then '돼지'
				   when (@byear % 12 = 4) then '쥐'
				   when (@byear % 12 = 5) then '소'
				   when (@byear % 12 = 6) then '호랑이'
				   when (@byear % 12 = 7) then '토끼'
				   when (@byear % 12 = 8) then '용'
				   when (@byear % 12 = 9) then '뱀'
				   when (@byear % 12 = 10) then '말'
				   when (@byear % 12 = 11) then '양'
			   end;
    
	print @username + '의 띠 ==> ' + @tti;
go
exec usp_case '성시경';
exec usp_case '이승기';
exec usp_case '조관우';

-- while문의 프로시저
/*새로운 열 추가*/
alter table usertbl add grade nvarchar(5);
go
create proc usp_while
as
	declare usercur cursor for -- 커서 선언
		select u.userid, sum(price * amount)
		  from buytbl B
		       right outer join
			   usertbl U
			       on B.userid = U.userid
		 group by U.userID, U.name

	open usercur -- 커서 열기

	declare @id nvarchar(10) -- 사용자 아이디를 저장할 변수
	declare @sum bigint -- 총 구매액을 저장할 변수
	declare @usergrade nchar(5) -- 고객 등급 변수

	fetch next from usercur into @id, @sum -- 첫행 값을 대입

	while (@@fetch_status = 0) -- 행이 없을 때 까지 반복 (즉, 모든 행 처리)
	begin 
		set @usergrade = 
			case 
				when (@sum >= 1500) then '최우수고객'
				when (@sum >= 1000) then '우수고객'
				when (@sum >= 1) then '일반고객'
				else '유령고객'
			end
		update usertbl set grade = @usergrade where userid = @id
		fetch next from usercur into @id, @sum -- 다음 행 값을 대입
	end

	close usercur -- 커서 닫기
	deallocate usercur -- 커서 해제
go
exec usp_while;
select * from userTbl;

-- return으로 프로시저
create proc usp_return
	@username nvarchar(10)
as
	declare @userid char(8);

	select @userid = userid 
	  from usertbl
	 where name = @username;

	if (@userid <> '')
		return 0; -- 성공일 경우, 그냥 return만 써도 0을 돌려줌
	else
		return -1; -- 실패일 경우 (즉, 해당 이름의 ID가 없을 경우)
go
declare @retval int;
exec @retval = usp_return '이승기';
select @retval;
declare @retval int;
exec @retval = usp_return '카리나';
select @retval;

-- 오류함수로 프로시저
create proc usp_error
      @userid char(8)
	, @name nvarchar(10)
	, @birthyear int = 1900
	, @addr nchar(2) = '서울'
	, @mobile1 char(3) = null
	, @mobile2 char(8) = null
	, @height smallint = 170
	, @mdate date = '2019-11-11'
as 
	declare @err int;

	insert into usertbl(userid, name, birthyear, addr, mobile1, mobile2, height, mdate)
	       values (@userid, @name, @birthyear, @addr, @mobile1, @mobile2, @height, @mdate);

	select @err = @@error;
	/*@@error가 0이면 정상적인 작동*/
	if @err != 0
		begin
			print '###' + @name + '을(를) insert에 실패했습니다. ###'
		end;

	return @err; -- 오류번호를 돌려줌
go
declare @ret_err int;
exec @ret_err = usp_error '가나다라마바사아자차카', '한글';
select @ret_err;
select * from usertbl;

declare @ret_err int;
exec @ret_err = usp_error 'JGY', '조건영';
select @ret_err;
select * from usertbl;

declare @ret_err int;
exec @ret_err = usp_error 127, 'ABC';
select @ret_err;
select * from usertbl;

-- try catch로 프로시저
create proc usp_try_cat
      @userid char(8)
	, @name nvarchar(10)
	, @birthyear int = 1900
	, @addr nchar(2) = '서울'
	, @mobile1 char(3) = null
	, @mobile2 char(8) = null
	, @height smallint = 170
	, @mdate date = '2019-11-11'
as 
	begin try 
		insert into usertbl(userid, name, birthyear, addr, mobile1, mobile2, height, mdate)
		       values (@userid, @name, @birthyear, @addr, @mobile1, @mobile2, @height, @mdate);
	end try

	/*정상적으로 insert가 되면 catch문은 실행 X*/
	begin catch
		select error_number()
		select error_message()
	end catch
go
exec usp_try_cat 'SYJ', '손연재';

-- 이제껏 내가 만든 프로시저 조회
select 
  o.name
, m.definition
  from sys.sql_modules m
       inner join
	   sys.objects o
	       on m.object_id=o.object_id
		      and 
			  o.type = 'P';

select * from sys.sql_modules;
select * from sys.objects;

-- 하나의 프로시저에 대해 스크립트를 보고 싶을 때
exec sp_helptext 'usp_error';

-- 프로시저를 암호화 하고 싶을 때
create proc usp_encrypt with encryption
as
	select 
	  substring(name, 1, 1) + '00' as [이름]
	, birthyear as '출생년도'
	, height as '키'
	  from usertbl;
go
exec usp_encrypt;

-- 암호화로 되어 있는지 확인
/*방법1*/
select 
  object_name(object_id)
, definition
  from sys.sql_modules
 where object_name(object_id) = 'usp_encrypt';

 /*방법2*/
 exec sp_helptext 'usp_encrypt';

-- 임시로 만든 프로시저
create proc #usp_temp
as 
	select * from usertbl;
go
exec #usp_temp;
/*쿼리문을 다시 실행하면 이 프로시저는 사용 불가!!*/

exec sp_executesql N'select * from usertbl';
/*
잠시 사용할거면 굳이 임시 프로시저로 만들지말고 
sp_executesql로 쿼리문만 써서 사용
*/

-- 출력값을 테이블로!!
create type usertbltype as table (
  userid char(8)
, name nvarchar(10)
, birthyear int
, addr nchar(2)
);
/*사용자 타입으로 테이블을 생성 => 테이블 모양의 데이터*/
go
create proc usp_tableTypeParameter
	@tblPara usertbltype readonly -- 테이블 형식의 매개변수는 readonly를 붙여야 함
as 
	-- begin
		select * from @tblpara where birthyear < 1970;
	-- end;
go
/*테이블 형태로 불러 올 때 변수선언하기*/
declare @tblvar usertbltype; -- 테이블 형식의 변수 선언
insert into @tblvar
	select userid, name, birthyear, addr from usertbl; -- 테이블 변수에 데이터 입력
exec usp_tableTypeParameter @tblvar; -- 프로시저 호출

-- 일반 t-sql의 처리시간 비교
set statistics time on;
use adventureworks;
go
select
  P.productNumber
, P.name as product
, V.name as vendor
, PV.LastReceiptCost
  from Production.product as P
       inner join
	   Purchasing.ProductVendor as PV
		on P.ProductID = pv.ProductID
	   inner join
	   Purchasing.Vendor as V
	    on V.BusinessEntityID = PV.BusinessEntityID
 order by P.name;
 /*
 첫번째는 시간이 걸리지만 두번재부터는 같은 쿼리문을 실행하여 시간이 단축 됨
 if, 대소문자 하나만 바뀌어도 다른 쿼리문으로 인식하여 실행시간이 늘어남
 */

 -- 저장프로시저 내부 작동 확인
 set statistics time on;

 create proc usp_prod
 as 
	select
      P.productNumber
	, P.name as product
	, V.name as vendor
	, PV.LastReceiptCost
	  from Production.product as P
           inner join
	       Purchasing.ProductVendor as PV
			on P.ProductID = pv.ProductID
		   inner join
	       Purchasing.Vendor as V
	        on V.BusinessEntityID = PV.BusinessEntityID
     order by P.name;
go
exec usp_prod;

set statistics time off;

-- 저장 프로시저를 사용하는 이유
use sqldb;

select * from usertbl where userid = 'LSG';
select * from usertbl where userid = 'KBS';
select * from usertbl where userid = 'KKH';
/*3개 쿼리문은 다 다른 쿼리로 보고 실행 할 때마다 실행시간이 걸림*/

create proc usp_userid
	@id nvarchar(10)
as 
	select * from usertbl where userid = @id;
go
exec usp_userid 'LSG'
exec usp_userid 'KBS'
exec usp_userid 'KKH'
/*
첫번째 LSG때만 최적화 및 컴파일을 수행하고
나머지는 캐시(메모리)의 것만 사용
*/

-- 저장 프로시저 문제점
use sqldb;
select * into sptbl from AdventureWorks.Sales.Customer order by rowguid;
create index idx_sptbl_id on sptbl(customerid);
go
select * from sptbl where CustomerID <10;
/*index seek로 index사용 O*/
select * from sptbl where CustomerID <5000;
/*table scan으로 index사용 X*/
/*조건은 숫자만 바뀌었을 뿐이지만 index를 사용할지 안할지는 컴퓨터가 알아서 정함*/
go
drop proc usp_id;
create proc usp_id
	@id int
as
	select * from sptbl where CustomerID < @id;
go
exec usp_id 10;
exec usp_id 5000;
/*
50에서 index seek를 사용해서 5000에서도 index seek를 사용
5000일 때는 테이블 스캔을 하는 것이 성능적으로 좋다

하지만 2016년 정식 버전이 나오면서 최적화 알고리즘이 바뀌면서
테이블 스캔으로 변하는 경우가 있다.
이전 버전 까지만 해도 index seek이면 무조건 index seek이었다.
이 문제를 해결하기 위해 recompile를 진행
*/
go
exec sp_recompile sptbl;
exec usp_id 10;
exec sp_recompile sptbl;
exec usp_id 5000;
/*
recompile해서 10은 seek
              5000은 scan
*/

-- 캐시 비우기
dbcc freeproccache;
exec usp_id 5000;

-- 프로시저 생성시 recompile옵션 추가
create proc usp_id_recom
	@id int
	with recompile
as 
	select * from sptbl where customerid < @id;
go
exec usp_id_recom 10;
exec usp_id_recom 5000;

-- 사용자 정의 함수 실습
use tempdb;
restore database sqldb from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL13.GYCOM\MSSQL\Backup\sqldb.bak' with replace;

use sqldb;
go
-- 나이가 나오는 함수
create function ufn_getage(@byear int) -- 매개변수를 정수로 받음
	returns int -- 리턴값은 정수형
as 
	begin
		declare @age int
		set @age = year(getdate()) - @byear + 1 
		return(@age)
	end;
go
select dbo.ufn_getage(1993);
go
declare @retval int;
exec @retval = dbo.ufn_getage 1966;
select @retval;
go
select 
  userid
, name
, dbo.ufn_getage(birthYear) "한국 나이"
  from userTbl;

-- 함수 수정 => 만 나이로 고치기
alter function ufn_getage(@byear int) -- 매개변수를 정수로 받음
	returns int -- 리턴값은 정수형
as 
	begin
		declare @age int
		set @age = year(getdate()) - @byear 
		return(@age)
	end;
go
select 
  userid
, name
, dbo.ufn_getage(birthYear) "만 나이"
  from userTbl;

-- 함수 삭제
drop function dbo.ufn_getage;

-- 인라인 테이블 반환 함수
create function ufn_getuser(@ht int)
	returns table
as 
	return (
		select 
		  userid as [아이디]
		, name as [이름]
		, height as [키]
		  from usertbl
		 where height > @ht
	);
go
select * from dbo.ufn_getuser(177);

-- 다중문 테이블 반환 함수
create function ufn_usergrade(@byear int)
-- 리턴할 테이블의 정의(@rettable은 begin..end에서 사용될 테이블 변수임)
	returns @rettable table (
	                           userid char(8)
							 , name nchar(10)
							 , grade nchar(5) )
as
	begin
		declare @rowcnt int;
		-- 행의 개수를 카운트
		select @rowcnt = count(*) from usertbl where birthyear >= @byear;

		-- 행이 하나도 없으면 '없음'이라고 입력하고 테이블을 리턴함.
		if @rowcnt <= 0
			begin
				insert into @rettable values ('없음','없음','없음');
			end
		else
			begin
				insert into @rettable 
							select 
							  U.userid
							, U.name
							, case when (sum(price*amount) >= 1500) then '최우수고객'
							       when (sum(price*amount) >= 1000) then '우수고객'
								   when (sum(price*amount) >= 1) then '일반고객'
								   else '유령고객'
							  end
							  from buytbl B
							       inner join
							       usertbl U
									on B.userid = u.userID
							 where birthyear >= @byear
							 group by U.userID, U.name;
			end
		return;
	end;
go
select * from dbo.ufn_usergrade(1970);
select * from dbo.ufn_usergrade(1990);

-- 스키마 바운드 함수
use tempdb;
restore database sqldb from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL13.GYCOM\MSSQL\Backup\sqldb.bak' with replace;

use sqldb;
go
create function ufn_discount(@id nvarchar(10))
	returns bigint
as
	begin
		declare @totprice bigint;

		-- 입력된 사용자id의 총구매액
		select @totprice = sum(price * amount)
		  from buytbl
		 where userid = @id
		 group by userid;

	   -- 총구매액에 따라서 차등된 할인율을 적용
	   set @totprice = case when (@totprice >= 1500) then @totprice * 0.7
	                        when (@totprice >= 1000) then @totprice * 0.8
							when (@totprice >= 500) then @totprice * 0.9
							else @totprice
					   end;

	   -- 구매기록이 없으면 0원
	   if @totprice is null
	       set @totprice=0;

	   return @totprice;
	end;
go
select 
  userid
, name
, dbo.ufn_discount(userid)
  from usertbl;
go
exec sp_rename 'buytbl.price', 'cost', 'column';
/*열이름이 바뀌면 함수가 실행히 안된다.*/
exec sp_rename 'buytbl.cost', 'price', 'column';
go
/*열이름 변경을 방지하기 위해 스키마바운딩 사용*/ 
alter function ufn_discount(@id nvarchar(10))
	returns bigint
	with schemabinding
as
	begin
		declare @totprice bigint;

		-- 입력된 사용자id의 총구매액
		select @totprice = sum(price * amount)
		  from dbo.buytbl
		  /*dbo라는 스키마를 확실히 적어 주어야지 스키마바운딩 가능!!!*/
		 where userid = @id
		 group by userid;

	   -- 총구매액에 따라서 차등된 할인율을 적용
	   set @totprice = case when (@totprice >= 1500) then @totprice * 0.7
	                        when (@totprice >= 1000) then @totprice * 0.8
							when (@totprice >= 500) then @totprice * 0.9
							else @totprice
					   end;

	   -- 구매기록이 없으면 0원
	   if @totprice is null
	       set @totprice=0;

	   return @totprice;
	end;
go
exec sp_rename 'buytbl.price', 'cost', 'column';
/*이름 변경을 할려니 오류가 나오면서 변경이 불가능*/

-- 테이블 변수
declare @tblVar table (id char(8), name nvarchar(10), addr nchar(2));
insert into @tblvar
	select userid, name, addr
	  from usertbl
	 where birthyear >= 1970;
select * from @tblvar;