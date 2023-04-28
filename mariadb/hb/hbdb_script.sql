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
GROUP BY table_name
/*
'varchar', 'char', 'varbinary', 'binary', 'nchar', 'nvarchar' => DATA_TYPE(CHARACTER_MAXIMUM_LENGTH)
'numeric', 'decimal', 'float', 'doulble' => NUMERIC_SCALE = 0이면 DATA_TYPE(NUMERIC_PRECISION)
                                            NUMERIC_SCALE != 0이면 DATA_TYPE(NUMERIC_PRECISION, NUMERIC_SCALE)
나머지 타입 => DATA_TYPE

group_concat은 GROUP BY된 열을 기준으로 세로로 되어진 값을 가로 형태로 합쳐준다. 
 => 여러 개의 행으로 이루어진 값을 1개 행으로 압축할 수 있다.
 => SEPARATOR로 구분자를 정한다.
*/

SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGe
SELECT * FROM information_schema.INNODB_SYS_FOREIGN 
SELECT * FROM information_schema.INNODB_SYS_FOREIGN_COLS

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
	from pk_fk_add_tbl pkat inner JOIN
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
/*
마리아db에는 check도 있어서 
*/


SELECT table_comment FROM information_schema.`TABLES`


-- 인덱스
SELECT CONCAT('create ', if(non_unique=0, 'unique ', ''), 'index ', index_name, ' on ', TABLE_NAME, '(', GROUP_CONCAT(COLUMN_NAME SEPARATOR ','), ');')
FROM information_schema.STATISTICS
GROUP BY index_name, TABLE_NAME;
/*
information_schema.STATISTICS에 인덱스 생성에 필요한 모든 정보가 있어서 쿼리가 짧다.
*/









-- 프로시저
SELECT CONCAT('create ', routine_type, ' ', ROUTINE_name, '()', CHAR(13), routine_definition)
FROM information_schema.ROUTINES
LIMIT 2
/*
- 프로시저와 함수의 쿼리문이 너무 길어 복사 붙여 넣기 할 때 많은 렉이 걸린다.
- 쿼리문을 복사 붙여넣기 한 후 실행시켜보면 2번째 줄에 ''구문 오류가 나온다.
*/

















-- 권한
SELECT CONCAT('grant ', privilege_type, ' on ', table_schema, '.', TABLE_NAME, ' to ', grantee, if(is_grantable='NO', '', 'WITH GRANT OPTION'), ';')
FROM information_schema.TABLE_PRIVILEGES;





