/*
mssql
날짜 23-06-25

커서
https://youtu.be/KL0eLC3BjWw
https://youtu.be/-PdmFmOorf0

커서란
 - 행 집합을 편하게 다루기 위한 기능을 제공
 - 테이블에서 여러개의 행을 쿼리한 후에 쿼리의 결과인 행 집합을 한 행씩 처리하기 위한 방식

커서 처리 순서
 1) 커서의 선언(declare)
 2) 커서 열기 (open)
 3) 커서에서 데이터 가져오기(fetch)
  - while문으로 모든 행이 처리 될때 까지 반복
 4) 데이터 처리
  - while문으로 모든 행이 처리 될때 까지 반복
 5) 커서 닫기(close)
 6) 커서의 해제(dealocate)

커서 문법
 declare [커서명] cursor [local | global]
	[forward_only | scroll]
	[static | keyset | dynamic | fast_forward]
	[read_only | scrool_locks | optimistic]
	[type_waring]
	for [쿼리문]
		[for update [of column_name [n, ...]]]

 1) local은 지역커서, global은 전역커서 => 디폴트는 global
 2) forward_only => fetch next뿐
    scroll => fetch next/first/last/prior 등 사용 => 잘 사용 안됨
 3) static => 데이터를 모두 tempdb에 복사한 후 데이터를 사용
           => 원본 테이블의 데이터가 변경 되어도 tempdb에 복사된 변경 전 데이터 사용
	dynamic => 현재의 키 값만 tempdb에 저장
	        => update 및 insert 된 모든 내용이 보임
			=> 디폴트 값
    keyset => 모든 키 값을 tempdb에 저장
	       => update된 내용만 보이며 insert된 내용은 보이지 않는다.
	fast_forward => forward_only와 read_only옵션이 합쳐진 것
	             => 커서에서 행 데이터를 수정하지 않을 것이라면 성능에는 가장 바람직한 옵션
    성능 순서: fast_forward > static > keyset > dynamic

 4) read_only => 읽기 전용
    scroll_locks => 위치 지정 업데이트나 삭제가 가능하도록 설정
	optimistic => 커서로 행을 읽어 들인후 원본 테이블의 행이 업데이트 되었다면 
	              커서에서는 해당 행을 위치 지정 업데이트나 삭제되지 않도록 지정
 5) type_waring => 요청한 커서 형식이 다른 형식으로 변환된 경우 클라이언트에 경고 메세지
                => 고유 인덱스가 없을 경우 ,keyset으로 커서를 만들려고 하면 암시적 변환으로 static커서로 자동 변경
				  
				 
*/
-- 커서의 간단한 예제
use tempdb;
restore database sqldb from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL13.GYCOM\MSSQL\Backup\sqldb.bak' with replace;

use sqldb;
/*커서 준비*/
declare usertbl_cursor 
	cursor global 
		for select height from userTbl;
go
/*커서오픈*/
open usertbl_cursor;
go
/*while문으로 모든 행이 처리될 때 까지 반복*/
-- 1. 변수선언
declare @height int; -- 고객의 키
declare @cnt int = 0; -- 고객의 인원수(=읽은 행 수)
declare @totalheight int = 0; -- 키의 합계

-- 2. 첫행을 읽어서 키를 @height변수에 넣는다.
fetch next from usertbl_cursor into @height;

-- 3. while문
--  - 성공적으로 읽어졌다면 @@fetch_status은 0을 반환
--  - 즉, 더이상 읽은 행이 없다면 while문을 종료
while @@fetch_status = 0
	begin
		set @cnt += 1;
		set @totalheight += @height;
		fetch next from usertbl_cursor into @height;
	end;

-- 4. 평균 키 구하기
print '고객 키의 평균 ==> ' + cast((@totalheight/@cnt) as char(10));
go
/*커서 닫기*/
close usertbl_cursor;
go
/*커서할당 해제*/
deallocate usertbl_cursor;

-- 커서 성능
create database cursordb;
use cursordb;
go
select * into cursortbl from AdventureWorks.Sales.SalesOrderDetail;
/*linetotal 평균 구하기(커서로)*/
declare cursortbl_cursor cursor global fast_forward
	for select linetotal from cursortbl;
go
open cursortbl_cursor;
go
declare @linetotal money;
declare @cnt int = 0;
declare @sumlinetotal money = 0;

fetch next from cursortbl_cursor into @linetotal;

while @@fetch_status = 0
	begin
		set @cnt += 1;
		set @sumlinetotal += @linetotal;
		fetch next from cursortbl_cursor into @linetotal;
    end

print '총 합계 ==> ' + cast(@sumlinetotal as char(20));
print '건당 평균 ==> ' + cast(@sumlinetotal/@cnt as char(20));
go
close cursortbl_cursor;
deallocate cursortbl_cursor;

/*linetotal 평균 구하기(쿼리문으로)*/
select sum(linetotal) as [총합계] , avg(linetotal) as [건당평균] from cursortbl;

-- global/local
use cursordb;

declare cursortbl_cursor cursor
	for select linetotal from cursortbl;

declare @result cursor;
exec sp_describe_cursor @cursor_return = @result output,
                        @cursor_source = N'global',
						@cursor_identity = N'cursortbl_cursor';

fetch next from @result
while (@@fetch_status <> -1)
	fetch next from @result;
go
/*cursordb의 속성에 옵션에 커서를 gloval에서 local로 변경후 실행하자!!!*/
declare cursortbl_cursor cursor
	for select linetotal from cursortbl;

declare @result cursor;
exec sp_describe_cursor @cursor_return = @result output,
                        @cursor_source = N'local',
						@cursor_identity = N'cursortbl_cursor';

fetch next from @result
while (@@fetch_status <> -1)
	fetch next from @result;
/*cursor_scope가 1일 때는 local, 2일 때는 gloval*/

-- static, dynamic, keyset
/*
sqldb의 usertbl를 사용한다고 가정
id열에는 PK가 설정되어 고유 인덱스가 설정되어 있는 상태

1. static(정적)
 - 커서를 열면 tempdb에 모두 복사됨
2. keyset(키집합)
 - 커서를 열면 키 값만 tempdb에 복사됨
3. dynamic(동적)
 - 커서를 열면 현재 커서 포인터의 키 값만 tempdb에 복사됨
*/
declare cursortbl_cursor cursor
	for select LineTotal from cursortbl;

declare @result cursor;
exec sp_describe_cursor @cursor_return = @result output,
                        @cursor_source = N'global',
						@cursor_identity = N'cursortbl_cursor';

fetch next from @result
while (@@fetch_status <> -1)
	fetch next from @result;
/*model이 1일 때는 static, 2일 때는 keyset, 3일 때는 dynamic, 4일 때는 fast_forward*/
close cursortbl_cursor;
deallocate cursortbl_cursor;
go
/*인덱스 설정*/
alter table cursortbl add constraint uk_id unique (salesorderdetailID);
/*이제 static과 keyset 사용 가능*/
go
declare cursortbl_cursor cursor global static
	for select * from cursortbl;
go
open cursortbl_cursor;
go
fetch next from cursortbl_cursor;
go
/*다른 쿼리문을 열어서 실행*/
update cursortbl set SalesOrderID = 0;
go
fetch next from cursortbl_cursor;
/*SalesOrderID은 0으로 출력되지 않는다.*/
go
close cursortbl_cursor;
deallocate cursortbl_cursor;
go
select * from cursortbl;
/*SalesOrderID가 0으로 변경된 것을 확인*/

-- 커서 이동
use sqldb;

declare usertbl_cursor cursor global scroll
	for select name, height from usertbl;
go
open usertbl_cursor;
go
/*다음 커서로*/
declare @name nvarchar(10);
declare @height int;
fetch next from usertbl_cursor into @name, @height;
select @name, @height;
go
/*마지막 커서로*/
declare @name nvarchar(10);
declare @height int;
fetch last from usertbl_cursor into @name, @height;
select @name, @height;
go
/*이전 커서로*/
declare @name nvarchar(10);
declare @height int;
fetch prior from usertbl_cursor into @name, @height;
select @name, @height;
go
/*첫줄 커서로*/
declare @name nvarchar(10);
declare @height int;
fetch first from usertbl_cursor into @name, @height;
select @name, @height;
go
close usertbl_cursor;
deallocate usertbl_cursor;

-- 암시적 커서 변환
create table keysettbl(id int, txt char(5));
insert into keysettbl values (1,'AAA');
insert into keysettbl values (2,'BBB');
insert into keysettbl values (3,'CCC');

declare keysettbl_cursor cursor forward_only keyset
	for select * from keysettbl;
go
/*커서 정보 확인*/
declare @result cursor;
exec sp_describe_cursor @cursor_return = @result output,
                        @cursor_source = N'global',
						@cursor_identity = N'keysettbl_cursor';
fetch next from @result;
while @@FETCH_STATUS<>-1
	fetch next from @result;
/*model이 keyset이 아닌 static으로 잡혀 있음*/
go
open keysettbl_cursor;
go
fetch next from keysettbl_cursor;
go
update keysettbl set txt = 'ZZZ' where id = 3;
go
fetch next from keysettbl_cursor;
/*static이므로 변경 안됨*/
go
close keysettbl_cursor;
deallocate keysettbl_cursor;
go
/*잘못 되어 있는지 오류 메세지를 발생*/
declare keysettbl_cursor cursor forward_only keyset type_warning
	for select * from keysettbl;

create table keysettbl1(id int primary key, txt char(5));
insert into keysettbl1 values (1,'AAA');
insert into keysettbl1 values (2,'BBB');
insert into keysettbl1 values (3,'CCC');
go
declare keysettbl_cursor cursor forward_only keyset type_warning
	for select * from keysettbl1;
/*오류 메세지가 없으니 keyset으로 잘 만들어짐*/
go
open keysettbl_cursor;
go
fetch next from keysettbl_cursor;
go
update keysettbl set txt = 'ZZZ' where id = 3;
go
fetch next from keysettbl_cursor;
go
declare @result cursor;
exec sp_describe_cursor @cursor_return = @result output,
                        @cursor_source = N'global',
						@cursor_identity = N'keysettbl_cursor';
fetch next from @result;
while @@FETCH_STATUS<>-1
	fetch next from @result;
/*이번에는 model이 2로 keyset으로 잘 만들어짐*/
go
close keysettbl_cursor;
deallocate keysettbl_cursor;


