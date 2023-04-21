SHOW DATABASES;


SELECT * FROM performance_schema.accounts;

-- CREATE DATABASE zbdb;

SELECT * FROM zbdb.abc;

USE zbdb;

CREATE TABLE abc (
	a INT,
	b INT,
	c INT
);

INSERT INTO abc VALUES (1,3,4);
INSERT INTO abc VALUES (2,4,10);
INSERT INTO abc VALUES (3,5,16);

SELECT * FROM abc;


-------------------------------------------------------------------------------------------
-- 테이블 생성
select CONCAT('create table ', TABLE_NAME, '(', group_concat(CONCAT(COLUMN_NAME, ' ', 
                                                                    case when DATA_TYPE in ('varchar', 'char', 'varbinary', 'binary', 'nchar', 'nvarchar') 
																				 		        		then CONCAT(DATA_TYPE, '(', CHARACTER_MAXIMUM_LENGTH, ')')
				                                                             when DATA_TYPE in ('numeric', 'decimal', 'float', 'doulble') 
																						      		then CONCAT(DATA_TYPE, '(', 
																								                  case when NUMERIC_SCALE = 0 
																													  			then NUMERIC_PRECISION
														                                                     else concat(DATA_TYPE, '(', NUMERIC_PRECISION, ', ', NUMERIC_SCALE, ')') END)
				                                                             else DATA_TYPE END,
																							case when column_default is null and is_nullable='NO'
																											then ' NOT NULL'
																								  when column_default IS NOT NULL AND is_nullable='NO'
																								         then ' NOT NULL DEFAULT'
																								  when column_default = 'NULL' AND is_nullable='YES'
																								         then ' DEFAULT NULL'
																								  ELSE '' end) SEPARATOR ', '), ');')
from INFORMATION_SCHEMA.COLUMNS
GROUP BY TABLE_NAME



-------------------------------------------------------------------------------------------
-- 기본키/외래키/유니크/체크
with pk_fk_tbl as (
SELECT kc.CONSTRAINT_NAME, kc.TABLE_NAME, kc.COLUMN_NAME, tc.CONSTRAINT_CATALOG, tc.CONSTRAINT_SCHEMA, tc.CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGe kc inner join
     information_schema.TABLE_CONSTRAINTS tc on kc.CONSTRAINT_NAME=tc.CONSTRAINT_NAME and kc.TABLE_NAME=tc.TABLE_NAME -- inner join
-- 	  information_schema.TABLE_CONSTRAINTS o on o.CONSTRAINT_NAME=kc.CONSTRAINT_NAME AND o.TABLE_NAME=kc.TABLE_NAME
), pk_fk_add_tbl AS(
	SELECT pkt.CONSTRAINT_NAME, pkt.TABLE_NAME, group_concat(pkt.COLUMN_NAME SEPARATOR ', ') "mul_col"
	from pk_fk_tbl pkt
	group by CONSTRAINT_NAME, TABLE_NAME														  
), final_pk_fk_tbl as (
	select distinct pft.CONSTRAINT_NAME, pft.TABLE_NAME, pft.CONSTRAINT_CATALOG, pft.CONSTRAINT_SCHEMA, pft.CONSTRAINT_TYPE, pkat.mul_col, rc.UPDATE_RULE, rc.DELETE_RULE
	from pk_fk_add_tbl pkat inner join
	     pk_fk_tbl pft on pft.CONSTRAINT_NAME=pkat.CONSTRAINT_NAME and pft.TABLE_NAME=pkat.TABLE_NAME left join 
		  INFORMATION_SCHEMA.referential_constraints rc on rc.CONSTRAINT_NAME=pkat.CONSTRAINT_NAME
), parent_tbl as(
	select CONSTRAINT_NAME, TABLE_SCHEMA "parent_table_schema", TABLE_NAME "parent_table_name", COLUMN_NAME "parent_column_name"
	from INFORMATION_SCHEMA.KEY_COLUMN_USAGE
	WHERE CONSTRAINT_NAME = 'FOREIGN'
), refer_tbl as(
	select CONSTRAINT_NAME, REFERENCED_TABLE_SCHEMA "referenced_table_schema", REFERENCED_TABLE_NAME "referenced_table_name", REFERENCED_COLUMN_NAME "referenced_column_schema"
	from INFORMATION_SCHEMA.KEY_COLUMN_USAGE
	WHERE CONSTRAINT_NAME = 'FOREIGN'
), paren_refer_tbl as(
	select pt.CONSTRAINT_NAME, pt.parent_table_schema, pt.parent_table_name, pt.parent_column_name, 
	                           rt.referenced_table_schema, rt.referenced_table_name, rt.referenced_column_schema
	from parent_tbl pt inner join refer_tbl rt
	     on pt.CONSTRAINT_NAME=rt.CONSTRAINT_NAME
), pk_fk_dec_ifm_tbl as(
	select fpft.CONSTRAINT_NAME, fpft.table_name, fpft.constraint_schema, fpft.CONSTRAINT_TYPE, fpft.mul_col, fpft.UPDATE_RULE, fpft.DELETE_RULE,
	                             prt.parent_table_schema, prt.parent_table_name, prt.parent_column_name, 
										  prt.referenced_column_schema, prt.referenced_table_schema, prt.referenced_table_name, cc.CHECK_CLAUSE
	from final_pk_fk_tbl fpft left join paren_refer_tbl prt
		 on fpft.CONSTRAINT_NAME=prt.CONSTRAINT_NAME AND fpft.TABLE_NAME=prt.parent_table_name
		  left JOIN information_schema.CHECK_CONSTRAINTS cc ON cc.CONSTRAINT_NAME=prt.CONSTRAINT_NAME AND cc.TABLE_NAME=prt.parent_table_name 
)
select CONCAT('alter table [', CONSTRAINT_SCHEMA, '].[', TABLE_NAME, '] add constraint ', CONSTRAINT_NAME, ' ', 
        case when constraint_type='PRIMARY KEY' then concat(constraint_type , ' [', CONSTRAINT_SCHEMA, '].[', TABLE_NAME, ']([', mul_col, '])') 
		       when constraint_type='UNIQUE' then concat(constraint_type, '([', mul_col, '])')
		       when constraint_type='CHECK' then concat(constraint_type, '(', CHECK_CLAUSE, ')')
             else concat(constraint_type, '([', mul_col, ']) references [', referenced_table_schema, '].[', referenced_table_name, ']([', mul_col, '])') END , 
		  case when UPDATE_RULE IS NULL then ''
				 else CONCAT(' on update ', update_rule) END,
		  case when delete_rule IS NULL then ' '
				 else CONCAT(' on delete ', delete_rule) END, ';') "pk_fk"
from pk_fk_dec_ifm_tbl;






SELECT * FROM information_schema.CHECK_CONSTRAINTS WHERE CONSTRAINT_NAME='Priv' AND TABLE_NAME='mysql'
SELECT * FROm INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE CONSTRAINT_NAME='Priv' AND TABLE_NAME='mysql'
SELECT * FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE='check'





-------------------------------------------------------------------------------------------
-- 인덱스
SELECT CONCAT('create ', if(non_unique=0, 'unique ', ''), 'index ', index_name, ' on ', TABLE_NAME, '(', GROUP_CONCAT(COLUMN_NAME SEPARATOR ','), ');')
FROM information_schema.STATISTICS
GROUP BY index_name, TABLE_NAME;

create index commit_timestamp on transaction_registry(commit_timestamp,transaction_id);

SELECT *
FROM information_schema.STATISTICS
