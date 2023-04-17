-- 테이블 생성 프로시저
-- * 프로시저 삭제
drop PROC DBO.USP_GET_TABLE_SCHEMA
 
-- * 프로시저 생성
CREATE PROC DBO.USP_GET_TABLE_SCHEMA
@TBLNAME VARCHAR(100)
AS
SET NOCOUNT ON
--SET @TBLNAME = 'DBO.companyinfo'
/*
변수 지정을 주석 처리 함으로써 프로시저를 불러올 때 테이블명을 변경하여
해당 테이블의 create 스크립트를 생성 할 수 있다.
주석을 풀면 프로시 실행시 아무리 테이블명을 바꾸어도 companyinfo테이블에
대한 create 스크립트만 나오게 된다.
*/

SELECT A.NAME AS 컬럼명,
       B.NAME AS 자료형, 
	   A.LENGTH AS 크기,
	   ' →' AS 변경, 
	   A.NAME AS NAME,
	   CASE WHEN B.NAME='NVARCHAR' THEN 'VARCHAR' ELSE B.NAME END AS DATATYPE,
	   A.LENGTH AS LENGTH,
	   A.XPREC,
	   A.XSCALE, 
	   A.COLORDER AS [ORDER]
	   INTO #TMP
FROM SYSCOLUMNS AS A INNER JOIN
     SYSTYPES AS B ON A.XTYPE=B.XTYPE
WHERE ID=OBJECT_ID(@TBLNAME) AND B.NAME <> 'SYSNAME'
ORDER BY COLORDER

SELECT 'CREATE TABLE '+@TBLNAME+'_MOVE (' AS SCRIPT, 0 AS [ORDER]
UNION ALL
SELECT CASE DATATYPE WHEN 'VARCHAR'          THEN '['+UPPER(NAME)+']'+DATATYPE+'('+CONVERT(VARCHAR,[LENGTH])+'),'
                     WHEN 'CHAR'             THEN '['+UPPER(NAME)+']'+DATATYPE+'('+CONVERT(VARCHAR,[LENGTH])+'),'
					 WHEN 'TEXT'             THEN '['+UPPER(NAME)+']'+DATATYPE+','
					 WHEN 'NVARCHAR'         THEN '['+UPPER(NAME)+']'+DATATYPE+'('+CONVERT(VARCHAR,[LENGTH])+'),'
					 WHEN 'NCHAR'            THEN '['+UPPER(NAME)+']'+DATATYPE+'('+CONVERT(VARCHAR,[LENGTH])+'),'
					 WHEN 'NTEXT'            THEN '['+UPPER(NAME)+']'+DATATYPE+','
					 WHEN 'BIT'              THEN '['+UPPER(NAME)+']'+DATATYPE+','
					 WHEN 'TINYINT'          THEN '['+UPPER(NAME)+']'+DATATYPE+','
					 WHEN 'SMALLINT'         THEN '['+UPPER(NAME)+']'+DATATYPE+','
					 WHEN 'BIGINT'           THEN '['+UPPER(NAME)+']'+DATATYPE+','
					 WHEN 'SMALLMONEY'       THEN '['+UPPER(NAME)+']'+DATATYPE+','
					 WHEN 'MONEY'            THEN '['+UPPER(NAME)+']'+DATATYPE+','
					 WHEN 'BIGINT'           THEN '['+UPPER(NAME)+']'+DATATYPE+','
					 WHEN 'INT'              THEN '['+UPPER(NAME)+']'+DATATYPE+','
					 WHEN 'FLOAT'            THEN '['+UPPER(NAME)+']'+DATATYPE+','
					 WHEN 'DATETIME'         THEN '['+UPPER(NAME)+']'+DATATYPE+','
					 WHEN 'SMALLDATETIME'    THEN '['+UPPER(NAME)+']'+DATATYPE+','
					 WHEN 'DECIMAL'          THEN '['+UPPER(NAME)+']'+DATATYPE+'('+CONVERT(VARCHAR,[XPREC])+','+CONVERT(VARCHAR,[XSCALE])+'),'
					 WHEN 'NUMERIC'          THEN '['+UPPER(NAME)+']'+DATATYPE+'('+CONVERT(VARCHAR,[XPREC])+','+CONVERT(VARCHAR,[XSCALE])+'),'
					 WHEN 'XML'              THEN '['+UPPER(NAME)+']'+DATATYPE+',' END AS SCRIPT, [ORDER]
FROM #TMP
UNION ALL
SELECT ')' AS SCRIPT, 255 AS [ORDER] ORDER BY [ORDER]

DROP TABLE #TMP

-- * 프로시저 생성
USE study
GO  
EXEC dbo.USP_GET_TABLE_SCHEMA @TBLNAME = 'companyinfo'
GO

-- * 프로시저 불러오기
sp_helptext USP_GET_TABLE_SCHEMA;


-- 변수 지정 프로시저
-- * 프로시저 삭제
drop proc Procedure_Name

-- * 프로시저 생성
CREATE PROCEDURE dbo.Procedure_Name(
	@site NVARCHAR(500),
	@name NVARCHAR(100),
	@ret INT OUTPUT 
)
AS
BEGIN
SELECT @site, @name, @ret
END
GO

-- * 프로시저 불러오기
sp_helptext Procedure_Name

-- * 프로시저 실행
USE study
GO  
EXEC dbo.Procedure_Name @site = 'abx', @name = 'hy', @ret = 5
EXEC dbo.Procedure_Name @site = 'uid', @name = 'mh', @ret = 1
GO

-- 변수 생성  개념
-- * 변수 생성 및 입력
DECLARE @site NVARCHAR(500)
DECLARE @name NVARCHAR(100)
DECLARE @ret  INT
 
SET @site = 'tistory.com'
SET @name = 'mozi'

-- * 생성된 변수로 프로시저에 입력하기
exec dbo.Procedure_Name @site, @name, @ret
exec dbo.Procedure_Name @site= 'tistory.com', @name= 'mozi', @ret=null
SELECT @ret

--
select COLUMN_NAME + ' ' + DATA_TYPE + case when isnull(CHARACTER_MAXIMUM_LENGTH,-1)!=-1 and CHARACTER_MAXIMUM_LENGTH<1000 then '(' + cast(CHARACTER_MAXIMUM_LENGTH as varchar) + ')' else '' end
from INFORMATION_SCHEMA.COLUMNS
where table_name = 'us_counties_pop_est_2010'

select*
from INFORMATION_SCHEMA.TABLES
where table_name = 'us_counties_pop_est_2010'

select*
from INFORMATION_SCHEMA.COLUMNS
where table_name = 'us_counties_pop_est_2010'

select COLUMN_NAME + ' ' + DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS
where table_name = 'us_counties_pop_est_2010'

-- 테이블 생성 스크립트 만들기
-- * 사용 DB
use study /*DB가 달라질 때마다 변경을 해주어야 한다.*/
go

-- * 스크립트 만들 테이블명 변수 지정 및 설정
declare @table_name SYSNAME
set @table_name = 'companyinfo'

-- * 쿼리문 저장할 변수 지정
declare @table_create_script nvarchar(max)
select @table_create_script = 'create table ' + table_name + '(' + stuff((
	select ', ' + COLUMN_NAME  + ' ' + DATA_TYPE + case when DATA_TYPE in ('varchar', 'char', 'varbinary', 'binary', 'nchar', 'nvarchar') then '(' + cast(CHARACTER_MAXIMUM_LENGTH as varchar) + ')'
														when DATA_TYPE in ('numeric', 'decimal') then '(' + case when cast(NUMERIC_SCALE as varchar) = 0 then cast(NUMERIC_PRECISION as varchar) + ')'
																												 else cast(NUMERIC_PRECISION as varchar) + ', '  + cast(NUMERIC_SCALE as varchar) + ')' end
														else '' end
	from INFORMATION_SCHEMA.COLUMNS
	where table_name = @table_name
	for xml path('')),1,2,'') +')'
from INFORMATION_SCHEMA.TABLES
where table_name = @table_name

-- * 테이블 생성 스크립트 쿼리문 출력
print @table_create_script
/*
create table로 되어 있는 문법이고 pk나 fk 같은 제약 조건에 대해서는 아무 것도 없다.
*/


select 'create table ' + table_name + ' (' + 
      string_agg(column_name + ' ' +  data_type + case when DATA_TYPE in ('varchar', 'char', 'varbinary', 'binary', 'nchar', 'nvarchar') then '(' + cast(CHARACTER_MAXIMUM_LENGTH as varchar) + ')'
														when DATA_TYPE in ('numeric', 'decimal') then '(' + case when cast(NUMERIC_SCALE as varchar) = 0 then cast(NUMERIC_PRECISION as varchar) + ')'
																												 else cast(NUMERIC_PRECISION as varchar) + ', '  + cast(NUMERIC_SCALE as varchar) + ')' end
														else '' end, ', ')
        + ');'
  from INFORMATION_SCHEMA.COLUMNS
 where table_name = 'companyinfo'
 group by
       table_name

create table companyinfo(  ID bigint, Name nvarchar(200), IND_ID varchar(4), Employees int, IncInCtryCode varchar(4), City varchar(61), StAdd1 varchar(61), Post varchar(21))
create table companyinfo(ID bigint, Name nvarchar(200), IND_ID varchar(4), Employees int, IncInCtryCode varchar(4), City varchar(61), StAdd1 varchar(61), Post varchar(21));

select *  from INFORMATION_SCHEMA.COLUMNS

select *  from sys.indexes

-- 기본키 설정 스크립트
use study
go
with pk_fk_tbl as (
    -- 제약조건이 같은 것을 묶어서 
	SELECT kc.CONSTRAINT_NAME, kc.TABLE_NAME, kc.COLUMN_NAME, tc.CONSTRAINT_CATALOG, tc.CONSTRAINT_SCHEMA, tc.CONSTRAINT_TYPE
	FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGe kc inner join
         information_schema.TABLE_CONSTRAINTS tc on kc.CONSTRAINT_NAME=tc.CONSTRAINT_NAME
), pk_fk_add_tbl as (
	select CONSTRAINT_NAME, stuff((select ',' + COLUMN_NAME from pk_fk_tbl where CONSTRAINT_NAME=pkt.CONSTRAINT_NAME for xml path('')),1,1,'') "mul_col"
	from pk_fk_tbl pkt
	group by CONSTRAINT_NAME
), final_pk_fk_tbl as (
	select distinct pft.CONSTRAINT_NAME, pft.TABLE_NAME, pft.CONSTRAINT_CATALOG, pft.CONSTRAINT_SCHEMA, pft.CONSTRAINT_TYPE, pkat.mul_col
	from pk_fk_add_tbl pkat inner join
	     pk_fk_tbl pft on pft.CONSTRAINT_NAME=pkat.CONSTRAINT_NAME
)




-- 최종코드 막바지
select 'alter table ' + TABLE_NAME + ' add constraint '+ CONSTRAINT_NAME + ' ' + case when CONSTRAINT_TYPE = 'PRIMARY KEY' then CONSTRAINT_TYPE + ' (' +mul_col + ')'
                                                                                      else CONSTRAINT_TYPE
from final_pk_fk_tbl





	SELECT kc.CONSTRAINT_NAME, kc.TABLE_NAME, kc.COLUMN_NAME, tc.CONSTRAINT_CATALOG, tc.CONSTRAINT_SCHEMA, tc.CONSTRAINT_TYPE
	FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGe kc inner join
         information_schema.TABLE_CONSTRAINTS tc on kc.CONSTRAINT_NAME=tc.CONSTRAINT_NAME

SELECT kcu.CONSTRAINT_NAME, fk.object_id, kcu.constraint_catalog, kcu.constraint_schema, tc.TABLE_NAME, tc.CONSTRAINT_TYPE, fk.parent_object_id, fk.referenced_object_id, fk.key_index_id, fk.delete_referential_action, fk.delete_referential_action_desc, kcu.COLUMN_NAME
	FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu inner join
	     information_schema.TABLE_CONSTRAINTS tc on kcu.CONSTRAINT_NAME=tc.CONSTRAINT_NAME inner join
		 sys.foreign_keys fk on kcu.CONSTRAINT_NAME=fk.name 
	where kcu.table_name='backupfile'

select stuff((select ',' + a.COLUMN_NAME
 from (SELECT kc.CONSTRAINT_NAME, kc.TABLE_NAME, kc.COLUMN_NAME, tc.CONSTRAINT_CATALOG, tc.CONSTRAINT_SCHEMA, tc.CONSTRAINT_TYPE
	   FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGe kc inner join
            information_schema.TABLE_CONSTRAINTS tc on kc.CONSTRAINT_NAME=tc.CONSTRAINT_NAME
       where  tc.CONSTRAINT_TYPE='FOREIGN KEY') a
for xml path('')),1,1,'')

select *
from information_schema.TABLE_CONSTRAINTS

select * -- COLUMN_NAME
from information_schema.KEY_COLUMN_USAGe
where
for xml path('')

select *
from sys.foreign_keys

select *
from sys.objects
where object_id='2117582582'

select *
from sys.foreign_keys fk inner join
     sys.objects o on fk.parent_object_id=o.object_id inner join
	 information_schema.KEY_COLUMN_USAGe kcu on fk.name=kcu.constraint_name

select *
from sys.tables

select *
from sys.foreign_keys fk inner join 
     sys.tables t on fk.parent_object_id = t.object_id or fk.referenced_object_id=t.object_id
where fk.name='FK__backupfil__backu__6C6E1476'

select * from sys.columns where object_id='1691153070' and column_id=1
select * from sys.tables where object_id='1787153412'
select * from sys.tables where name = 'backupfile'
select * from sys.foreign_keys
select * from sys.objects where object_id = '1819153526'

-- DB에 저장된 프로시저
-- * 스크립트를 만들고 싶은 DB명 변수로 지정
declare @DB_NAME VARCHAR(50) = 'msdb'

-- * 프로시저 스크립트를 담을 변수 지정
declare @procedure_script nvarchar(max)

select @procedure_script = (select replace((select ROUTINE_DEFINITION + char(13) + char(13) + char(13)
                            from INFORMATION_SCHEMA.ROUTINES 
                            where SPECIFIC_CATALOG = @DB_NAME
                            for xml path('')), '&#x0D;', char(13)))

print @procedure_script
/*
msdb에 저장되어 있는 프로시저가 너무 많아 @procedure_script에 다 저장을 하지 못해 3행의 90%정도만 삽입이 된다.
여러 프로시저를 한 번에 저장하기 보다는 한 개씩 필요한 것만 골라 내는 스크립트를 만들자
*/

-- ** 사용 DB
use msdb /*DB이름은 테이블명이 속한 DB로 변경해야한다.*/
go 

-- ** 프로시저명 변수 지정 및 설정
declare @procedure_name sysname
set @procedure_name = 'sp_syscollector_text_query_plan_lookpup'

-- ** 프로시저 스크립트를 담을 변수 지정
declare @procedure_script nvarchar(max)
select @procedure_script = (select replace((select ROUTINE_DEFINITION + char(13) + char(13) + char(13)
                                            from INFORMATION_SCHEMA.ROUTINES 
                                            where specific_name = @procedure_name
							                for xml path('')),
											'&#x0D;', char(13)))

print @procedure_script

-- 인덱스
-- * 방법1. 인덱스 확인
use msdb
go
exec sp_helpindex 'msdb.dbo.autoadmin_managed_databases'
/*
해당 DB에 접속이 되어 있어야 한다.
즉, msdb인데 study에 접속이 되어 있었다면 오류가 나온다.
inner join이 안된다. 나중에 함 찾아보자
*/

-- ** sp_helpindex와 sys.indexes join하기

-- * 방법2. 인덱스 확인
select * from sys.indexes where object_id=(select object_id from sys.tables where name='constraint_test')
/*
 - 해당 DB에 저장되어 있는 모든 인덱스를 불러옴
 - object_id로 테이블이 무엇인지 알 수 있습니다.
 - name으로 인덱스명을 알 수 있다.
 - index_id로는 해당 테이블의 인덱스가 몇 번째 인지 알 수 있다.
   => if, object_id가 같은데 index_id가 1과 2가 있다면 
      object_id에 맞는 테이블에는 인덱스가 2개 있다는 얘기가 된다.
*/

-- * 인덱스 테이블을 만들기 위한 개념 정리
select * from sys.tables -- 해당 DB의 모든 테이블 보기
select * from sys.schemas -- 해당 DB의 모든 스키마 보기
select * from sys.indexes -- 시스템의 인덱스 보기
select * from sys.index_columns -- 인덱스 열에 대한 정보가 숫자로 지정되어 있다.
/*
 - object_id: 테이블
 - index_id: 인덱스번호
 - index_column_id: 인덱스컬럼 번호
 - column_id: 테이블의 컬럼 번호
*/
select * from sys.columns -- 테이블의 컬럼 정보를 보여준다.

-- * 인덱스 테이블 만들기
select 
        s.name schema_nm, 
        i.type_desc index_type, 
        t.name table_nm, 
        i.name index_nm, 
		c.name column_nm
from sys.tables t
inner join sys.schemas s 
   on t.schema_id = s.schema_id
inner join sys.indexes i 
   on i.object_id = t.object_id
inner join sys.index_columns ic 
   on ic.object_id = t.object_id
inner join sys.columns c 
   on c.object_id = t.object_id and ic.column_id = c.column_id


-- 권한
select 

-- 시퀀스



select * from information_schema.check_constraints


