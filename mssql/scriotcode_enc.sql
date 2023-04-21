-- 테이블 생성 스크립트 만들기
-- 링크: https://scalability.tistory.com/38
-- * 스크립트 만들 테이블명 변수 설정
DECLARE @TABLE_NAME SYSNAME -- 
SELECT @TABLE_NAME = '[dbo].[autoadmin_managed_databases]' 

-- *  
DECLARE 
      @OBJECT_NAME SYSNAME
    , @OBJECT_ID INT
SELECT 
      @OBJECT_NAME = '[' + S.NAME + '].[' + O.NAME + ']'
    , @OBJECT_ID = O.[OBJECT_ID]
FROM SYS.OBJECTS O WITH (NOWAIT)
JOIN SYS.SCHEMAS S WITH (NOWAIT) ON O.[SCHEMA_ID] = S.[SCHEMA_ID]
WHERE S.NAME + '.' + O.NAME = @TABLE_NAME
    AND O.[TYPE] = 'U'
    AND O.IS_MS_SHIPPED = 0


DECLARE @SQL NVARCHAR(MAX) = '';
 
WITH INDEX_COLUMN AS 
(
    SELECT 
          IC.[OBJECT_ID]
        , IC.INDEX_ID
        , IC.IS_DESCENDING_KEY
        , IC.IS_INCLUDED_COLUMN
        , C.NAME
    FROM SYS.INDEX_COLUMNS IC WITH (NOWAIT)
    JOIN SYS.COLUMNS C WITH (NOWAIT) ON IC.[OBJECT_ID] = C.[OBJECT_ID] AND IC.COLUMN_ID = C.COLUMN_ID
    WHERE IC.[OBJECT_ID] = @OBJECT_ID
),
FK_COLUMNS AS 
(
     SELECT 
          K.CONSTRAINT_OBJECT_ID
        , CNAME = C.NAME
        , RCNAME = RC.NAME
    FROM SYS.FOREIGN_KEY_COLUMNS K WITH (NOWAIT)
    JOIN SYS.COLUMNS RC WITH (NOWAIT) ON RC.[OBJECT_ID] = K.REFERENCED_OBJECT_ID AND RC.COLUMN_ID = K.REFERENCED_COLUMN_ID 
    JOIN SYS.COLUMNS C WITH (NOWAIT) ON C.[OBJECT_ID] = K.PARENT_OBJECT_ID AND C.COLUMN_ID = K.PARENT_COLUMN_ID
    WHERE K.PARENT_OBJECT_ID = @OBJECT_ID
)
SELECT @SQL = 'CREATE TABLE ' + @OBJECT_NAME + CHAR(13) + '(' + CHAR(13) + STUFF((
    SELECT CHAR(9) + ', [' + C.NAME + '] ' + 
        CASE WHEN C.IS_COMPUTED = 1
            THEN 'AS ' + CC.[DEFINITION] 
            ELSE UPPER(TP.NAME) + 
                CASE WHEN TP.NAME IN ('VARCHAR', 'CHAR', 'VARBINARY', 'BINARY', 'TEXT')
                       THEN '(' + CASE WHEN C.MAX_LENGTH = -1 THEN 'MAX' ELSE CAST(C.MAX_LENGTH AS VARCHAR(5)) END + ')'
                     WHEN TP.NAME IN ('NVARCHAR', 'NCHAR', 'NTEXT')
                       THEN '(' + CASE WHEN C.MAX_LENGTH = -1 THEN 'MAX' ELSE CAST(C.MAX_LENGTH / 2 AS VARCHAR(5)) END + ')'
                     WHEN TP.NAME IN ('DATETIME2', 'TIME2', 'DATETIMEOFFSET') 
                       THEN '(' + CAST(C.SCALE AS VARCHAR(5)) + ')'
                     WHEN TP.NAME = 'DECIMAL' 
                       THEN '(' + CAST(C.[PRECISION] AS VARCHAR(5)) + ',' + CAST(C.SCALE AS VARCHAR(5)) + ')'
                    ELSE ''
                END +
                CASE WHEN C.COLLATION_NAME IS NOT NULL THEN ' COLLATE ' + C.COLLATION_NAME ELSE '' END +
                CASE WHEN C.IS_NULLABLE = 1 THEN ' NULL' ELSE ' NOT NULL' END +
                CASE WHEN DC.[DEFINITION] IS NOT NULL THEN ' DEFAULT' + DC.[DEFINITION] ELSE '' END + 
                CASE WHEN IC.IS_IDENTITY = 1 THEN ' IDENTITY(' + CAST(ISNULL(IC.SEED_value, '0') AS CHAR(1)) + ',' + CAST(ISNULL(IC.INCREMENT_value, '1') AS CHAR(1)) + ')' ELSE '' END 
        END + CHAR(13)
    FROM SYS.COLUMNS C WITH (NOWAIT)
    JOIN SYS.TYPES TP WITH (NOWAIT) ON C.USER_TYPE_ID = TP.USER_TYPE_ID
    LEFT JOIN SYS.COMPUTED_COLUMNS CC WITH (NOWAIT) ON C.[OBJECT_ID] = CC.[OBJECT_ID] AND C.COLUMN_ID = CC.COLUMN_ID
    LEFT JOIN SYS.DEFAULT_CONSTRAINTS DC WITH (NOWAIT) ON C.DEFAULT_OBJECT_ID != 0 AND C.[OBJECT_ID] = DC.PARENT_OBJECT_ID AND C.COLUMN_ID = DC.PARENT_COLUMN_ID
    LEFT JOIN SYS.IDENTITY_COLUMNS IC WITH (NOWAIT) ON C.IS_IDENTITY = 1 AND C.[OBJECT_ID] = IC.[OBJECT_ID] AND C.COLUMN_ID = IC.COLUMN_ID
    WHERE C.[OBJECT_ID] = @OBJECT_ID
    ORDER BY C.COLUMN_ID
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, CHAR(9) + ' ')
    + ISNULL((SELECT CHAR(9) + ', CONSTRAINT [' + K.NAME + '] PRIMARY KEY (' + 
                    (SELECT STUFF((
                         SELECT ', [' + C.NAME + '] ' + CASE WHEN IC.IS_DESCENDING_KEY = 1 THEN 'DESC' ELSE 'ASC' END
                         FROM SYS.INDEX_COLUMNS IC WITH (NOWAIT)
                         JOIN SYS.COLUMNS C WITH (NOWAIT) ON C.[OBJECT_ID] = IC.[OBJECT_ID] AND C.COLUMN_ID = IC.COLUMN_ID
                         WHERE IC.IS_INCLUDED_COLUMN = 0
                             AND IC.[OBJECT_ID] = K.PARENT_OBJECT_ID 
                             AND IC.INDEX_ID = K.UNIQUE_INDEX_ID     
                         FOR XML PATH(N''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, ''))
            + ')' + CHAR(13)
            FROM SYS.KEY_CONSTRAINTS K WITH (NOWAIT)
            WHERE K.PARENT_OBJECT_ID = @OBJECT_ID 
                AND K.[TYPE] = 'PK'), '') + ')'  + CHAR(13)
    + ISNULL((SELECT (
        SELECT CHAR(13) +
             'ALTER TABLE ' + @OBJECT_NAME + ' WITH' 
            + CASE WHEN FK.IS_NOT_TRUSTED = 1 
                THEN ' NOCHECK' 
                ELSE ' CHECK' 
              END + 
              ' ADD CONSTRAINT [' + FK.NAME  + '] FOREIGN KEY(' 
              + STUFF((
                SELECT ', [' + K.CNAME + ']'
                FROM FK_COLUMNS K
                WHERE K.CONSTRAINT_OBJECT_ID = FK.[OBJECT_ID]
                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
               + ')' +
              ' REFERENCES [' + SCHEMA_NAME(RO.[SCHEMA_ID]) + '].[' + RO.NAME + '] ('
              + STUFF((
                SELECT ', [' + K.RCNAME + ']'
                FROM FK_COLUMNS K
                WHERE K.CONSTRAINT_OBJECT_ID = FK.[OBJECT_ID]
                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
               + ')'
            + CASE 
                WHEN FK.DELETE_REFERENTIAL_ACTION = 1 THEN ' ON DELETE CASCADE' 
                WHEN FK.DELETE_REFERENTIAL_ACTION = 2 THEN ' ON DELETE SET NULL'
                WHEN FK.DELETE_REFERENTIAL_ACTION = 3 THEN ' ON DELETE SET DEFAULT' 
                ELSE '' 
              END
            + CASE 
                WHEN FK.UPDATE_REFERENTIAL_ACTION = 1 THEN ' ON UPDATE CASCADE'
                WHEN FK.UPDATE_REFERENTIAL_ACTION = 2 THEN ' ON UPDATE SET NULL'
                WHEN FK.UPDATE_REFERENTIAL_ACTION = 3 THEN ' ON UPDATE SET DEFAULT'  
                ELSE '' 
              END 
            + CHAR(13) + 'ALTER TABLE ' + @OBJECT_NAME + ' CHECK CONSTRAINT [' + FK.NAME  + ']' + CHAR(13)
        FROM SYS.FOREIGN_KEYS FK WITH (NOWAIT)
        JOIN SYS.OBJECTS RO WITH (NOWAIT) ON RO.[OBJECT_ID] = FK.REFERENCED_OBJECT_ID
        WHERE FK.PARENT_OBJECT_ID = @OBJECT_ID
        FOR XML PATH(N''), TYPE).value('.', 'NVARCHAR(MAX)')), '')
    + ISNULL(((SELECT
         CHAR(13) + 'CREATE' + CASE WHEN I.IS_UNIQUE = 1 THEN ' UNIQUE' ELSE '' END 
                + ' NONCLUSTERED INDEX [' + I.NAME + '] ON ' + @OBJECT_NAME + ' (' +
                STUFF((
                SELECT ', [' + C.NAME + ']' + CASE WHEN C.IS_DESCENDING_KEY = 1 THEN ' DESC' ELSE ' ASC' END
                FROM INDEX_COLUMN C
                WHERE C.IS_INCLUDED_COLUMN = 0
                    AND C.INDEX_ID = I.INDEX_ID
                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') + ')'  
                + ISNULL(CHAR(13) + 'INCLUDE (' + 
                    STUFF((
                    SELECT ', [' + C.NAME + ']'
                    FROM INDEX_COLUMN C
                    WHERE C.IS_INCLUDED_COLUMN = 1
                        AND C.INDEX_ID = I.INDEX_ID
                    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') + ')', '')  + CHAR(13)
        FROM SYS.INDEXES I WITH (NOWAIT)
        WHERE I.[OBJECT_ID] = @OBJECT_ID
            AND I.IS_PRIMARY_KEY = 0
            AND I.[TYPE] = 2
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)')
    ), '')
 
PRINT @SQL

-- 테이블 생성 프로시저
-- * 프로시저 삭제
drop PROC DBO.USP_GET_TABLE_SCHEMA;
 
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

DROP TABLE #TMP;

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
USE master
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

-- 테이블 생성 스크립트 만들기
-- * 사용 DB
use master /*DB가 달라질 때마다 변경을 해주어야 한다.*/
go;

-- * 스크립트 만들 테이블명 변수 지정 및 설정
declare @table_name SYSNAME
set @table_name = 'spt_values' -- masterDB에는 MSreplication_options, spt_fallback_db, spt_fallback_dev, spt_fallback_usg, spt_monitor, spt_values가 있다.

-- * 쿼리문 저장할 변수 지정
declare @table_create_script nvarchar(max)
select @table_create_script = 'create table ' + table_name + '(' + stuff((
	select ', ' + COLUMN_NAME  + ' ' + DATA_TYPE + case when DATA_TYPE in ('varchar', 'char', 'varbinary', 'binary', 'nchar', 'nvarchar') then '(' + cast(CHARACTER_MAXIMUM_LENGTH as varchar) + ')'
														when DATA_TYPE in ('numeric', 'decimal') then '(' + case when cast(NUMERIC_SCALE as varchar) = 0 then cast(NUMERIC_PRECISION as varchar) + ')'
																												 else cast(NUMERIC_PRECISION as varchar) + ', '  + cast(NUMERIC_SCALE as varchar) + ')' end
														else '' end
	from INFORMATION_SCHEMA.COLUMNS
	where table_name = @table_name
	for xml path('')),1,2,'') +');'
from INFORMATION_SCHEMA.TABLES
where table_name = @table_name

-- * 테이블 생성 스크립트 쿼리문 출력
print @table_create_script
/*
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

-- * 테이블 생성(수정본)
/*
타입 추가
PRECISION에 맞게 코드 변경 => CHARACTER_MAXIMUM_LENGTH이 -1 
cast로 잘못 변경한 것을 삭제
*/
select 'create table ' + TABLE_NAME + '(' +
       stuff((select ', ' + COLUMN_NAME  + ' ' + DATA_TYPE + 
	          case when DATA_TYPE in ('varchar', 'char', 'varbinary', 'binary', 'nchar', 'nvarchar') then 
						case when CHARACTER_MAXIMUM_LENGTH = -1 then ''
						     else '(' + cast(CHARACTER_MAXIMUM_LENGTH as varchar) + ')' end
				   when DATA_TYPE in ('numeric', 'decimal', 'float' , 'real') then '(' + 
							case when NUMERIC_SCALE = 0 then cast(NUMERIC_PRECISION as varchar) + ')'
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
-- * 하나의 행마다 하나의 키 생성 쿼리문
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

-- * xml형태로 저장 => 한 행에 다 저장 => 실행 시키기 위해서는 -- * 하나의 행마다 하나의 키 생성 쿼리문 부분을 주석 처리 후 실행
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

-- DB에 저장된 프로시저
-- * 스크립트를 만들고 싶은 DB명 변수로 지정
declare @DB_NAME VARCHAR(50) = 'msdb'

-- * 프로시저 스크립트를 담을 변수 지정
declare @procedure_script nvarchar(max)

select @procedure_script = (select replace((select ROUTINE_DEFINITION + char(13) + char(13) + char(13)
                            from INFORMATION_SCHEMA.ROUTINES 
                            --where SPECIFIC_CATALOG = @DB_NAME
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
select * from sys.tables; -- 해당 DB의 모든 테이블 보기
select * from sys.schemas; -- 해당 DB의 모든 스키마 보기
select * from sys.indexes where name='PK_sysutility_mi_dac_execution_statistics_internal'; -- 시스템의 인덱스 보기
select * from sys.index_columns; -- 인덱스 열에 대한 정보가 숫자로 지정되어 있다.
select * from sys.objects;
select * from sys.columns;
select * from INFORMATION_SCHEMA.tables;
select * from INFORMATION_SCHEMA.columns where TABLE_NAME='sysnotifications';
/*
 - object_id: 테이블
 - index_id: 인덱스번호
 - index_column_id: 인덱스컬럼 번호
 - column_id: 테이블의 컬럼 번호
*/

-- * 인덱스 테이블 만들기
declare @index_script varchar(max)
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
), ind_add_col_tbl as(
	select index_name, TABLE_NAME, stuff((select ',[' + column_name + ']' 
	                                      from index_tbl
										  where index_name=it.index_name and TABLE_NAME=it.TABLE_NAME
										  for xml path(''))
										  , 1, 1, '') "mul_col"
	from index_tbl it
	group by index_name ,TABLE_NAME
), final_index_tbl as (
	select distinct it.INDEX_NAME, it.INDEX_TYPE, it.TABLE_CATALOG, it.TABLE_SCHEMA, it.TABLE_NAME, it.TABLE_TYPE, iact.mul_col,
		   it.is_unique, it.data_space_id, it.ignore_dup_key, it.is_primary_key, it.is_unique_constraint, it.fill_factor, 
		   it.is_padded, it.is_disabled, it.is_hypothetical, it.is_ignored_in_optimization, it.allow_page_locks, it.allow_row_locks,
		   it.has_filter, it.suppress_dup_key_messages, it.auto_created, it.optimize_for_sequential_key
	from index_tbl it inner join
		 ind_add_col_tbl iact on it.INDEX_NAME=iact.INDEX_NAME and it.TABLE_NAME=iact.TABLE_NAME
)
-- ** 각행의 하나의 인덱스
select 'create ' + INDEX_TYPE + ' index ' + INDEX_NAME COLLATE Korean_Wansung_CI_AS + ' on [' + TABLE_SCHEMA + '].[' + TABLE_NAME + '](' + mul_col +');' 
from final_index_tbl

-- ** 전체 인덱스 출력
select @index_script = replace(stuff((select ' ' + char(13) + 'create ' + INDEX_TYPE + ' index ' + INDEX_NAME COLLATE Korean_Wansung_CI_AS + ' on [' + TABLE_SCHEMA + '].[' + TABLE_NAME + '](' + mul_col +');' 
from final_index_tbl
for xml path('')),1,1,''),'&#x0D;',char(13))
/*
DB의 전체 인덱스를 하나의 스크립트에 담는 쿼리문으로 전체 196행 중 80행쯤에서 문자수 초과로 모든 쿼리문이 삽입이 되지 않는다.
*/

print @index_script

-- 권한
-- * DB개념
-- ** 객체(major_id)가 가지고 있는 권한에 대해 알려준다.
select * from sys.database_permissions

select grantee_principal_id, grantor_principal_id, type, permission_name, state, state_desc from sys.database_permissions
select user_name(grantee_principal_id) "grantee_user", -- 권한을 받는 사람
       user_name(grantor_principal_id) "grantor_user", -- 권한을 주는 사람
	   type, permission_name, -- 권한 종류(줄임, 풀)
	   state, state_desc -- 사용권한 상태 (줄임, 풀)
from sys.database_permissions
/*
- class는 0:데이터베이스, 1: 개체, 열, 3: 스키마, 등으로 각 번호에 맞는 객체가 있다.
- class_desc는 번호로된 class의 문자열 정보
- major_id: 사용권한이 존재하는 항목 ID
- minor_id: 사용권한이 존재하는 항목 보조 ID
*/

-- * 예제 권한 만들기
create login gy_test with password='9333';
create user gy_test for login gy_test;

-- * 권한 부여
grant select on [dbo].[spt_fallback_db] to gy_test;
grant select on [dbo].[spt_fallback_dev] to gy_test;
grant create table to gy_test;

-- * 권한 삭제
revoke select on [dbo].[spt_fallback_db] to gy_test;
revoke create table to gy_test;

-- * 부여된 권한 확인
select * from sys.database_permissions where major_id='117575457' -- 테이블로 확인
select * from sys.database_permissions where USER_NAME(grantee_principal_id)='public' -- 유저명으로 
/*
- major_id='117575457' => spt_fallback_db의 번호
- major_id='133575514' => spt_fallback_dev의 번호
- grantee_principal_id나 grantor_principal_id는 sys.database_principalsDB에 저장되어 있으니 확인해보자!!
  => grantee_principal_id는 권한을 부여받은 사람, grantor_principal_id는 권한을 준 사람이라고 생각
- grant select on [dbo].[spt_fallback_db] to gy_test를 실행하면 grantee_principal_id가 7(gy_test)인 줄이 추가
- grantor_principal_id가 0이면 public
*/

-- * 스크립트 생성 쿼리문
select 'grant ' + PRIVILEGE_TYPE + ' on [' + TABLE_SCHEMA + '].[' + TABLE_NAME + '] to [' + GRANTEE + '];' 
from INFORMATION_SCHEMA.TABLE_PRIVILEGES;

-- 유저와 역할
-- * DB개념
select * from sys.database_principals;

select 'create ' + 
        case when type='R' then 'role [' + name + '];'
		     when type='S' then 'user [' + name + '];' end
from sys.database_principals
/*
- mssql 개체 탐색기 해당 DB의 보안 폴더에 있는 사용저와 역할(데이터베이스 역할)에 저장된 정보들을 보여준다.
- type열에는 A(애플리케이션 역할), C(인증서로 매칭된 사용자), E(Azure active Directory의 외부 사용자), G(window그룹), K(비대칭 키로 매핑된 사용자) 등 다른 타입들도 있다.
*/

-- 시퀀스


















