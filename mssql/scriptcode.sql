-- ���̺� ���� ���ν���
-- * ���ν��� ����
drop PROC DBO.USP_GET_TABLE_SCHEMA
 
-- * ���ν��� ����
CREATE PROC DBO.USP_GET_TABLE_SCHEMA
@TBLNAME VARCHAR(100)
AS
SET NOCOUNT ON
--SET @TBLNAME = 'DBO.companyinfo'
/*
���� ������ �ּ� ó�� �����ν� ���ν����� �ҷ��� �� ���̺���� �����Ͽ�
�ش� ���̺��� create ��ũ��Ʈ�� ���� �� �� �ִ�.
�ּ��� Ǯ�� ���ν� ����� �ƹ��� ���̺���� �ٲپ companyinfo���̺�
���� create ��ũ��Ʈ�� ������ �ȴ�.
*/

SELECT A.NAME AS �÷���,
       B.NAME AS �ڷ���, 
	   A.LENGTH AS ũ��,
	   ' ��' AS ����, 
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

-- * ���ν��� ����
USE study
GO  
EXEC dbo.USP_GET_TABLE_SCHEMA @TBLNAME = 'companyinfo'
GO

-- * ���ν��� �ҷ�����
sp_helptext USP_GET_TABLE_SCHEMA;


-- ���� ���� ���ν���
-- * ���ν��� ����
drop proc Procedure_Name

-- * ���ν��� ����
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

-- * ���ν��� �ҷ�����
sp_helptext Procedure_Name

-- * ���ν��� ����
USE study
GO  
EXEC dbo.Procedure_Name @site = 'abx', @name = 'hy', @ret = 5
EXEC dbo.Procedure_Name @site = 'uid', @name = 'mh', @ret = 1
GO

-- ���� ����  ����
-- * ���� ���� �� �Է�
DECLARE @site NVARCHAR(500)
DECLARE @name NVARCHAR(100)
DECLARE @ret  INT
 
SET @site = 'tistory.com'
SET @name = 'mozi'

-- * ������ ������ ���ν����� �Է��ϱ�
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

-- ���̺� ���� ��ũ��Ʈ �����
-- * ��� DB
use study /*DB�� �޶��� ������ ������ ���־�� �Ѵ�.*/
go

-- * ��ũ��Ʈ ���� ���̺�� ���� ���� �� ����
declare @table_name SYSNAME
set @table_name = 'companyinfo'

-- * ������ ������ ���� ����
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

-- * ���̺� ���� ��ũ��Ʈ ������ ���
print @table_create_script
/*
create table�� �Ǿ� �ִ� �����̰� pk�� fk ���� ���� ���ǿ� ���ؼ��� �ƹ� �͵� ����.
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

-- �⺻Ű ���� ��ũ��Ʈ
use study
go
with pk_fk_tbl as (
    -- ���������� ���� ���� ��� 
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




-- �����ڵ� ������
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

-- DB�� ����� ���ν���
-- * ��ũ��Ʈ�� ����� ���� DB�� ������ ����
declare @DB_NAME VARCHAR(50) = 'msdb'

-- * ���ν��� ��ũ��Ʈ�� ���� ���� ����
declare @procedure_script nvarchar(max)

select @procedure_script = (select replace((select ROUTINE_DEFINITION + char(13) + char(13) + char(13)
                            from INFORMATION_SCHEMA.ROUTINES 
                            where SPECIFIC_CATALOG = @DB_NAME
                            for xml path('')), '&#x0D;', char(13)))

print @procedure_script
/*
msdb�� ����Ǿ� �ִ� ���ν����� �ʹ� ���� @procedure_script�� �� ������ ���� ���� 3���� 90%������ ������ �ȴ�.
���� ���ν����� �� ���� �����ϱ� ���ٴ� �� ���� �ʿ��� �͸� ��� ���� ��ũ��Ʈ�� ������
*/

-- ** ��� DB
use msdb /*DB�̸��� ���̺���� ���� DB�� �����ؾ��Ѵ�.*/
go 

-- ** ���ν����� ���� ���� �� ����
declare @procedure_name sysname
set @procedure_name = 'sp_syscollector_text_query_plan_lookpup'

-- ** ���ν��� ��ũ��Ʈ�� ���� ���� ����
declare @procedure_script nvarchar(max)
select @procedure_script = (select replace((select ROUTINE_DEFINITION + char(13) + char(13) + char(13)
                                            from INFORMATION_SCHEMA.ROUTINES 
                                            where specific_name = @procedure_name
							                for xml path('')),
											'&#x0D;', char(13)))

print @procedure_script

-- �ε���
-- * ���1. �ε��� Ȯ��
use msdb
go
exec sp_helpindex 'msdb.dbo.autoadmin_managed_databases'
/*
�ش� DB�� ������ �Ǿ� �־�� �Ѵ�.
��, msdb�ε� study�� ������ �Ǿ� �־��ٸ� ������ ���´�.
inner join�� �ȵȴ�. ���߿� �� ã�ƺ���
*/

-- ** sp_helpindex�� sys.indexes join�ϱ�

-- * ���2. �ε��� Ȯ��
select * from sys.indexes where object_id=(select object_id from sys.tables where name='constraint_test')
/*
 - �ش� DB�� ����Ǿ� �ִ� ��� �ε����� �ҷ���
 - object_id�� ���̺��� �������� �� �� �ֽ��ϴ�.
 - name���� �ε������� �� �� �ִ�.
 - index_id�δ� �ش� ���̺��� �ε����� �� ��° ���� �� �� �ִ�.
   => if, object_id�� ������ index_id�� 1�� 2�� �ִٸ� 
      object_id�� �´� ���̺��� �ε����� 2�� �ִٴ� ��Ⱑ �ȴ�.
*/

-- * �ε��� ���̺��� ����� ���� ���� ����
select * from sys.tables -- �ش� DB�� ��� ���̺� ����
select * from sys.schemas -- �ش� DB�� ��� ��Ű�� ����
select * from sys.indexes -- �ý����� �ε��� ����
select * from sys.index_columns -- �ε��� ���� ���� ������ ���ڷ� �����Ǿ� �ִ�.
/*
 - object_id: ���̺�
 - index_id: �ε�����ȣ
 - index_column_id: �ε����÷� ��ȣ
 - column_id: ���̺��� �÷� ��ȣ
*/
select * from sys.columns -- ���̺��� �÷� ������ �����ش�.

-- * �ε��� ���̺� �����
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


-- ����
select 

-- ������



select * from information_schema.check_constraints


