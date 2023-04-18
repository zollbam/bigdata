-- 테이블 생성 프로시저
-- * 프로시저 삭제
<<<<<<< HEAD
drop PROC DBO.USP_GET_TABLE_SCHEMA;
 
-- * 프로시저 생성
CREATE PROC DBO.USP_GET_TABLE_SCHEMA 
=======
drop PROC DBO.USP_GET_TABLE_SCHEMA
 
-- * 프로시저 생성
CREATE PROC DBO.USP_GET_TABLE_SCHEMA
>>>>>>> 6879f7fa83121d045d521da6eaab7dc67ce075b6
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

<<<<<<< HEAD
DROP TABLE #TMP;
=======
DROP TABLE #TMP
>>>>>>> 6879f7fa83121d045d521da6eaab7dc67ce075b6

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
<<<<<<< HEAD
USE master
=======
USE study
>>>>>>> 6879f7fa83121d045d521da6eaab7dc67ce075b6
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

<<<<<<< HEAD
-- 테이블 생성 스크립트 만들기
-- * 사용 DB
use master /*DB가 달라질 때마다 변경을 해주어야 한다.*/
go;

-- * 스크립트 만들 테이블명 변수 지정 및 설정
declare @table_name SYSNAME
set @table_name = 'spt_values' -- masterDB에는 MSreplication_options, spt_fallback_db, spt_fallback_dev, spt_fallback_usg, spt_monitor, spt_values가 있다.
=======
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
>>>>>>> 6879f7fa83121d045d521da6eaab7dc67ce075b6

-- * 쿼리문 저장할 변수 지정
declare @table_create_script nvarchar(max)
select @table_create_script = 'create table ' + table_name + '(' + stuff((
	select ', ' + COLUMN_NAME  + ' ' + DATA_TYPE + case when DATA_TYPE in ('varchar', 'char', 'varbinary', 'binary', 'nchar', 'nvarchar') then '(' + cast(CHARACTER_MAXIMUM_LENGTH as varchar) + ')'
														when DATA_TYPE in ('numeric', 'decimal') then '(' + case when cast(NUMERIC_SCALE as varchar) = 0 then cast(NUMERIC_PRECISION as varchar) + ')'
																												 else cast(NUMERIC_PRECISION as varchar) + ', '  + cast(NUMERIC_SCALE as varchar) + ')' end
														else '' end
	from INFORMATION_SCHEMA.COLUMNS
	where table_name = @table_name
<<<<<<< HEAD
	for xml path('')),1,2,'') +');'
=======
	for xml path('')),1,2,'') +')'
>>>>>>> 6879f7fa83121d045d521da6eaab7dc67ce075b6
from INFORMATION_SCHEMA.TABLES
where table_name = @table_name

-- * 테이블 생성 스크립트 쿼리문 출력
print @table_create_script
/*
<<<<<<< HEAD
 - create table로 되어 있는 문법이고 pk나 fk 같은 제약 조건에 대해서는 아무 것도 없다.
 - 테이블명을 입력 해주어야 한다.
  => 하나의 테이블명에 대해서만 생성쿼리문을 만들어 낸다.
  => 한방처럼 테이블명을 확실히 모른다거나 수가 엄청 많으면 무리가 있다.
*/

-- * DB내 모든 테이블 생성 쿼리 한번에 만들기
select 'create table ' + TABLE_NAME + '(' +
       stuff((select ', ' + COLUMN_NAME  + ' ' + DATA_TYPE + case when DATA_TYPE in ('varchar', 'char', 'varbinary', 'binary', 'nchar', 'nvarchar') then '(' + cast(CHARACTER_MAXIMUM_LENGTH as varchar) + ')'
														          when DATA_TYPE in ('numeric', 'decimal') then '(' + case when cast(NUMERIC_SCALE as varchar) = 0 then cast(NUMERIC_PRECISION as varchar) + ')'
														                                                                   else cast(NUMERIC_PRECISION as varchar) + ', '  + cast(NUMERIC_SCALE as varchar) + ')' end
														          else '' end
              from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME=c.TABLE_NAME for xml path('')), 1,2,'') + ');'
from INFORMATION_SCHEMA.COLUMNS c
group by TABLE_NAME;

-- * DB내 모든 테이블 생성 쿼리를 변수에 저장시키기
declare @db_table_create_script nvarchar(max)
select @db_table_create_script = replace(
                                         stuff(
										       (select ' ' + char(13) + 'create table ' + TABLE_NAME + '(' +
                                                       stuff((select ', ' + COLUMN_NAME  + ' ' + DATA_TYPE + case when DATA_TYPE in ('varchar', 'char', 'varbinary', 'binary', 'nchar', 'nvarchar') then '(' + cast(CHARACTER_MAXIMUM_LENGTH as varchar) + ')'
														                                                          when DATA_TYPE in ('numeric', 'decimal') then '(' + case when cast(NUMERIC_SCALE as varchar) = 0 then cast(NUMERIC_PRECISION as varchar) + ')'
														                                                                                                                   else cast(NUMERIC_PRECISION as varchar) + ', '  + cast(NUMERIC_SCALE as varchar) + ')' end
														                                                          else '' end
                                                              from INFORMATION_SCHEMA.COLUMNS
												              where TABLE_NAME=c.TABLE_NAME 
												              for xml path('')), 
															  1,2,'') + ');'
                                                from INFORMATION_SCHEMA.COLUMNS c
											    group by TABLE_NAME
											    for xml path('')),
										       1,1,''),
							             '&#x0D;', char(13))

print @db_table_create_script

-- 김선일 부장님이 만드신 쿼리
select 'create table ' + table_name + ' (' + 
       string_agg(column_name + ' ' +  data_type + case when DATA_TYPE in ('varchar', 'char', 'varbinary', 'binary', 'nchar', 'nvarchar') then '(' + cast(CHARACTER_MAXIMUM_LENGTH as varchar) + ')'
														when DATA_TYPE in ('numeric', 'decimal') then '(' + case when cast(NUMERIC_SCALE as varchar) = 0 then cast(NUMERIC_PRECISION as varchar) + ')'
																												 else cast(NUMERIC_PRECISION as varchar) + ', '  + cast(NUMERIC_SCALE as varchar) + ')' end
														else '' end, ', ')+ ');'
from INFORMATION_SCHEMA.COLUMNS
group by table_name;

-- 기본키/외래키/유니크키 설정 스크립트
use msdb -- 복사하고 싶은 DB명 입력
go
with pk_fk_tbl as (
    -- 제약조건이 같은 것을 묶어서 
	SELECT kc.CONSTRAINT_NAME, o.object_id, kc.TABLE_NAME, kc.COLUMN_NAME, tc.CONSTRAINT_CATALOG, tc.CONSTRAINT_SCHEMA, tc.CONSTRAINT_TYPE
	FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGe kc inner join
         information_schema.TABLE_CONSTRAINTS tc on kc.CONSTRAINT_NAME=tc.CONSTRAINT_NAME inner join
		 sys.objects o on o.name=kc.CONSTRAINT_NAME
), pk_fk_add_tbl as (
	select CONSTRAINT_NAME, object_id,stuff((select ', ' + COLUMN_NAME from pk_fk_tbl where CONSTRAINT_NAME=pkt.CONSTRAINT_NAME for xml path('')),1,2,'') "mul_col"
	from pk_fk_tbl pkt
	group by CONSTRAINT_NAME, object_id
), final_pk_fk_tbl as (
	select distinct pft.CONSTRAINT_NAME, pft.object_id, pft.TABLE_NAME, pft.CONSTRAINT_CATALOG, pft.CONSTRAINT_SCHEMA, pft.CONSTRAINT_TYPE, pkat.mul_col, rc.UPDATE_RULE, rc.DELETE_RULE
	from pk_fk_add_tbl pkat inner join
	     pk_fk_tbl pft on pft.CONSTRAINT_NAME=pkat.CONSTRAINT_NAME left join 
		 INFORMATION_SCHEMA.referential_constraints rc on rc.CONSTRAINT_NAME=pkat.CONSTRAINT_NAME
), parent_tbl as(
	select fkc.constraint_object_id, fkc.parent_object_id, t.TABLE_SCHEMA "parent_table_schema", o.name "parent_table_name", fkc.parent_column_id
	from sys.foreign_key_columns fkc inner join
		 sys.objects o on fkc.parent_object_id=o.object_id inner join
		 INFORMATION_SCHEMA.TABLES t on t.TABLE_NAME=o.name
), refer_tbl as(
	select fkc.constraint_object_id, fkc.referenced_object_id, t.TABLE_SCHEMA "referenced_table_schema", o.name "referenced_table_name", fkc.referenced_column_id
	from sys.foreign_key_columns fkc inner join
		 sys.objects o on fkc.referenced_object_id=o.object_id inner join
		 INFORMATION_SCHEMA.TABLES t on t.TABLE_NAME=o.name
), paren_refer_tbl as(
	select pt.constraint_object_id, pt.parent_object_id, pt.parent_table_schema, pt.parent_table_name, pt.parent_column_id, 
	       rt.referenced_column_id, rt.referenced_object_id, rt.referenced_table_schema, rt.referenced_table_name
	from parent_tbl pt inner join refer_tbl rt
	     on pt.constraint_object_id=rt.constraint_object_id
), pk_fk_dec_ifm_tbl as(
	select *
	from final_pk_fk_tbl fpft left join paren_refer_tbl prt
		 on fpft.object_id=prt.constraint_object_id
)
-- 하나의 행마다 하나의 키 생성 쿼리문
select 'alter table [' + CONSTRAINT_SCHEMA + '].['+ table_name + '] add constraint ' + CONSTRAINT_NAME + ' ' + 
        case when constraint_type='PRIMARY KEY' then constraint_type + ' [' + CONSTRAINT_SCHEMA + '].[' + TABLE_NAME + ']([' + mul_col + '])' 
		     when constraint_type='UNIQUE' then constraint_type + '([' + mul_col + '])' 
             else constraint_type+ '([' + mul_col + ']) references [' + referenced_table_schema + '].[' + referenced_table_name + ']([' + mul_col + '])' + 
				case when UPDATE_RULE='NO ACTION' then ''
					 else ' on update ' + update_rule
				end +
				case when delete_rule='NO ACTION' then ''
					 else ' on delete ' + delete_rule
				end
		end + ';' "pk_fk"
from pk_fk_dec_ifm_tbl;

-- * xml형태로 저장 => 한 행에 다 저장
select replace((select char(13) + 'alter table [' + CONSTRAINT_SCHEMA + '].['+ table_name + '] add constraint ' + CONSTRAINT_NAME + ' ' + 
                       case when constraint_type='PRIMARY KEY' then constraint_type + ' [' + CONSTRAINT_SCHEMA + '].[' + TABLE_NAME + ']([' + mul_col + '])' 
		                    when constraint_type='UNIQUE' then constraint_type + '([' + mul_col + '])' 
                            else constraint_type+ '([' + mul_col + ']) references [' + referenced_table_schema + '].[' + referenced_table_name + ']([' + mul_col + '])' + 
								case when UPDATE_RULE='NO ACTION' then ''
					                 else ' on update ' + update_rule
				                end +
				                case when delete_rule='NO ACTION' then ''
					                 else ' on delete ' + delete_rule
				                end
		               end + ';'
from pk_fk_dec_ifm_tbl
for xml path('')), '&#x0D;', char(13)) "pk_fk";
=======
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
>>>>>>> 6879f7fa83121d045d521da6eaab7dc67ce075b6

-- DB에 저장된 프로시저
-- * 스크립트를 만들고 싶은 DB명 변수로 지정
declare @DB_NAME VARCHAR(50) = 'msdb'

-- * 프로시저 스크립트를 담을 변수 지정
declare @procedure_script nvarchar(max)

select @procedure_script = (select replace((select ROUTINE_DEFINITION + char(13) + char(13) + char(13)
                            from INFORMATION_SCHEMA.ROUTINES 
<<<<<<< HEAD
                            --where SPECIFIC_CATALOG = @DB_NAME
=======
                            where SPECIFIC_CATALOG = @DB_NAME
>>>>>>> 6879f7fa83121d045d521da6eaab7dc67ce075b6
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

<<<<<<< HEAD
-- *** 한행에 하나의 프로시저/함수 생성 쿼리문
select replace(ROUTINE_DEFINITION, '        ', char(10))
from INFORMATION_SCHEMA.ROUTINES
/*
하나의 프로시저 당 하나의 행을 반환
주석이나 엔터/띄어쓰기 문제로 본인이 직접 복사해서 코드를 맞추어 주어야 한다.
*/

select replace((select replace(ROUTINE_DEFINITION, '        ', char(10))
                from INFORMATION_SCHEMA.ROUTINES
                for xml path('')),'&#x0D;' , '') "result"
/*
1행 1열에 모든 프로시저를 다 넣으려고 하니 글자수 부족으로 다 들어 가지 않는다.
*/

=======
>>>>>>> 6879f7fa83121d045d521da6eaab7dc67ce075b6
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
<<<<<<< HEAD
select * from sys.tables; -- 해당 DB의 모든 테이블 보기
select * from sys.schemas; -- 해당 DB의 모든 스키마 보기
select * from sys.indexes where name='PK_sysutility_mi_dac_execution_statistics_internal'; -- 시스템의 인덱스 보기
select * from sys.index_columns; -- 인덱스 열에 대한 정보가 숫자로 지정되어 있다.
select * from sys.objects;
select * from sys.columns;
select * from INFORMATION_SCHEMA.tables;
select * from INFORMATION_SCHEMA.columns where TABLE_NAME='sysnotifications';
=======
select * from sys.tables -- 해당 DB의 모든 테이블 보기
select * from sys.schemas -- 해당 DB의 모든 스키마 보기
select * from sys.indexes -- 시스템의 인덱스 보기
select * from sys.index_columns -- 인덱스 열에 대한 정보가 숫자로 지정되어 있다.
>>>>>>> 6879f7fa83121d045d521da6eaab7dc67ce075b6
/*
 - object_id: 테이블
 - index_id: 인덱스번호
 - index_column_id: 인덱스컬럼 번호
 - column_id: 테이블의 컬럼 번호
*/
<<<<<<< HEAD

-- * 인덱스 테이블 만들기
with index_tbl as(
	select i.name "INDEX_NAME", i.type_desc "INDEX_TYPE", t.*, c.name "COLUMN_NAME",
		   i.is_unique, i.data_space_id, i.ignore_dup_key, i.is_primary_key, i.is_unique_constraint, i.fill_factor, 
		   i.is_padded, i.is_disabled, i.is_hypothetical, i.is_ignored_in_optimization, i.allow_page_locks, i.allow_row_locks,
		   i.has_filter, i.suppress_dup_key_messages, i.auto_created, i.optimize_for_sequential_key
	from sys.indexes i inner join 
	     sys.objects o on i.object_id=o.object_id inner join
		 sys.index_columns ic on ic.object_id=i.object_id and i.index_id=ic.index_id inner join
		 sys.columns c on ic.object_id=c.object_id and ic.column_id=c.column_id inner join
		 INFORMATION_SCHEMA.tables t on o.name=t.TABLE_NAME
	where i.type_desc not in ('HEAP')
)
select *
from index_tbl;

select i.name "INDEX_NAME", i.type_desc "INDEX_TYPE", o.type_desc "OBJECT_TYPE"
from sys.indexes i inner join 
	 sys.objects o on i.object_id=o.object_id and i.index_id=i.index_id
where i.name='PK_sysutility_mi_dac_execution_statistics_internal'

select i.name "INDEX_NAME", i.type_desc "INDEX_TYPE", o.type_desc "OBJECT_TYPE", ic.*
from sys.indexes i inner join 
	 sys.objects o on i.object_id=o.object_id inner join
	 sys.index_columns ic on ic.object_id=i.object_id and i.index_id=ic.index_id
where i.name='PK_sysutility_mi_dac_execution_statistics_internal'

select *
from sys.indexes
where object_id='18815129'

select *
from sys.index_columns
where object_id='18815129'

-- 권한
select * from INFORMATION_SCHEMA.COLUMN_PRIVILEGES
=======
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
>>>>>>> 6879f7fa83121d045d521da6eaab7dc67ce075b6

-- 시퀀스



<<<<<<< HEAD




=======
select * from information_schema.check_constraints
>>>>>>> 6879f7fa83121d045d521da6eaab7dc67ce075b6


