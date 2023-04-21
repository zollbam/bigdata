-- 테이블 생성
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




SELECT * FROM information_schema.CONSTRAINT_TABLE_USAGE
SELECT * FROM information_schema.CONSTRAINT_COLUMN_USAGE
SELECT * FROM information_schema.TABLE_CONSTRAINTS
SELECT * FROM information_schema.referential_constraints
select * from INFORMATION_SCHEMA.COLUMNS
select * from INFORMATION_SCHEMA.TABLE_PRIVILEGES
select * from INFORMATION_SCHEMA.COLUMN_PRIVILEGES
select * from INFORMATION_SCHEMA.KEY_COLUMN_USAGE


-- 기본/외래/유니크 키
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
/*
테이블 생성시 키를 지정하는 것이 아닌 테이블을 만들어 두고 alter옵션으로 수정하는 방법으로 만듬
*/










-- 인덱스
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
select * from index_tbl
select 'create ' + INDEX_TYPE + ' index ' + INDEX_NAME COLLATE Korean_Wansung_CI_AS + ' on [' + TABLE_SCHEMA + '].[' + TABLE_NAME + '](' + mul_col +');' 
from final_index_tbl

/*
sys.indexes, sys.objects, sys.index_columns, sys.columns, INFORMATION_SCHEMA.tables에서 필요한 열을 추출
allow_page_locks, allow_row_locks 등은 인덱스 만들 때 필요한 옵션들인데 없어도 생성이 되니 일단 추출만 해봄
*/










-- 프로시저
select replace(ROUTINE_DEFINITION, '        ', char(10))
from INFORMATION_SCHEMA.ROUTINES;
/*
주석이나 엔터/띄어쓰기 문제로 본인이 직접 복사해서 코드를 맞추어 주어야 하는 번거로움
*/









-- 권한
select 'grant ' + PRIVILEGE_TYPE + ' on [' + TABLE_SCHEMA + '].[' + TABLE_NAME + '] to [' + GRANTEE +
       case when is_grantable = 'NO' then ''
	        else ' with grant option' 
	   end + '];' 
from INFORMATION_SCHEMA.TABLE_PRIVILEGES;
/*
INFORMATION_SCHEMA.TABLE_PRIVILEGES옵션에는 모든 정보들이 다 들어 있어 편하게 쿼리문을 작성
*/









-- 시퀀스
-- * 각 행마다 하나의 시퀀스(INFORMATION_SCHEMA.SEQUENCES)
select 'create sequence [' + sequence_schema + '].[' + sequence_name + '] as ' + data_type + char(13) + 
       'start with ' + cast(start_value as varchar) + char(13) +
       'minvalue ' + cast(MINIMUM_VALUE as varchar) + char(13) +
	   'maxvalue ' + cast(MAXIMUM_VALUE as varchar)  + char(13) +
	   'increment by ' + cast(increment as varchar)  + char(13) +
	   case when cycle_option=0 then 'cycle' else 'no cycle' end + ';'
from INFORMATION_SCHEMA.SEQUENCES;

-- * 스크립트에 저장(INFORMATION_SCHEMA.SEQUENCES)
declare @script varchar(max)
select @script=replace(stuff((select ',' + 'create sequence [' + sequence_schema + '].[' + sequence_name + '] as ' + data_type + char(13) + 
                                     'start with ' + cast(start_value as varchar) + char(13) +
                                     'minvalue ' + cast(MINIMUM_VALUE as varchar) + char(13) +
                               	     'maxvalue ' + cast(MAXIMUM_VALUE as varchar)  + char(13) +
	                                 'increment by ' + cast(increment as varchar)  + char(13) +
                	                 case when cycle_option=0 then 'cycle' else 'no cycle' end + ';'
from INFORMATION_SCHEMA.SEQUENCES
for xml path('')),1,1,''),'&#x0D;', char(13))

print @script;

-- * 각 행마다 하나의 시퀀스(sys.SEQUENCES)
/*
sys.SEQUENCES와 INFORMATION_SCHEMA.SEQUENCES의 다른점
 - sys.SEQUENCES는 cache옵션을 지정 해줄 수 있는 열이 있음
 - sys.SEQUENCES는 cache크기를 저장 시켜둔 정보도 있음
 - sys.SEQUENCES는 현재 값도 볼 수 있음
*/
select 'create sequence ' + name + ' as ' + (select name "sq_type" from sys.types where system_type_id= s.system_type_id) + char(13) +
       'start with ' + cast(start_value as varchar) + char(13) +
	   'increment by ' + cast(increment as varchar) + char(13) +
	   'minvalue ' + cast(minimum_value as varchar) + char(13) +
	   'maxvalue ' + cast(maximum_value as varchar) + char(13) +
	   case when is_cycling = 0 then 'no cycle' else 'cycle' end + char(13) +
	   case when is_cached = 0 then 'no cache' else 'cache ' end + 
			case when is_cached = 1 and cache_size is not null then cast(system_type_id as varchar) else '' end + ';'
from sys.SEQUENCES s;

-- * 스크립트에 저장(sys.SEQUENCES)
declare @script_ss varchar(max)
select @script_ss=replace(stuff((select ' ' + 'create sequence ' + name + ' as ' + (select name "sq_type" from sys.types where system_type_id= s.system_type_id) + char(13) +
       'start with ' + cast(start_value as varchar) + char(13) +
	   'increment by ' + cast(increment as varchar) + char(13) +
	   'minvalue ' + cast(minimum_value as varchar) + char(13) +
	   'maxvalue ' + cast(maximum_value as varchar) + char(13) +
	   case when is_cycling = 0 then 'no cycle' else 'cycle' end + char(13) +
	   case when is_cached = 0 then 'no cache' else 'cache ' end + 
			case when is_cached = 1 and cache_size is not null then cast(system_type_id as varchar) else '' end + ';'
from sys.SEQUENCES s
for xml path('')), 1, 1, ''), '&#x0D;', char(13));

print @script_ss
