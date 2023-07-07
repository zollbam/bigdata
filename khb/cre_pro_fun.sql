/*
프로시저, 함수를 생성하는 쿼리문을 추추하는 파일
작성 일시: 23-06-25
수정 일시: 23-07-03
작 성 자 : 조건영
*/

SELECT *
  FROM information_schema.routines;

-- DB의 프로시저와 함수 정보
SELECT 
  ROUTINE_SCHEMA
, ROUTINE_NAME
, ROUTINE_DEFINITION
  FROM information_schema.routines
 WHERE ROUTINE_NAME != 'fn_split';

-- 프로시저와 함수의 권한
SELECT 
  class_desc
, object_name(major_id) "객체명"
, user_name(grantee_principal_id) "권한 받은 유저"
, 'grant ' + 
  stuff((SELECT ', ' + permission_name 
           FROM sys.DATABASE_permissions
          WHERE class_desc= dp.class_desc AND major_id=dp.major_id AND grantee_principal_id=dp.grantee_principal_id
            FOR xml PATH('')),1,2,'') + 
  ' on sc_khb_srv.' + 
  object_name(major_id) + 
  ' to ' + user_name(grantee_principal_id) + ';'
  FROM sys.DATABASE_permissions dp
 WHERE class_desc != 'DATABASE' 
       AND 
       grantee_principal_id != 0
       AND 
       object_name(major_id) = any(SELECT ROUTINE_NAME FROM information_schema.routines)
 GROUP BY class_desc, major_id, grantee_principal_id
 ORDER BY 2,3;



-- fc_emd_li_point
CREATE function sc_khb_srv.fc_emd_li_point (@emdLiCdPk int)
returns nvarchar(max)
begin
    declare @emdLiPoint nvarchar(max);

    select @emdLiPoint = geometry::STGeomFromText(concat('POINT(', json_value(emd_li_crdnt, '$.lng'),' ', json_value(emd_li_crdnt, '$.lat'), ')'), 4326).ToString()
      from db_khb_srv.sc_khb_srv.tb_com_emd_li_cd
     where emd_li_cd_pk = @emdLiCdPk
       and emd_li_crdnt <> '';
 
    return @emdLiPoint
END;


grant EXECUTE on sc_khb_srv.fc_emd_li_point to us_khb_adm;
grant EXECUTE on sc_khb_srv.fc_emd_li_point to us_khb_com;

-- fc_current_val
create function sc_khb_srv.fc_current_val (@SequenctName varchar(100))
returns int
begin
    declare @currentValue sql_variant;

    select @currentValue = current_value
      from sys.sequences
     where name = @SequenctName;
        
    return cast(@currentValue as int)

end;

grant EXECUTE on sc_khb_srv.fc_current_val to us_khb_adm;
grant EXECUTE on sc_khb_srv.fc_current_val to us_khb_agnt;
grant EXECUTE on sc_khb_srv.fc_current_val to us_khb_com;
grant EXECUTE on sc_khb_srv.fc_current_val to us_khb_dev;
grant EXECUTE on sc_khb_srv.fc_current_val to us_khb_exif;
grant EXECUTE on sc_khb_srv.fc_current_val to us_khb_magnt;
grant EXECUTE on sc_khb_srv.fc_current_val to us_khb_mptl;
grant EXECUTE on sc_khb_srv.fc_current_val to us_khb_report;

-- pc_com_author_copy
create procedure sc_khb_srv.pc_com_author_copy
(
    @frAuthorNoPk numeric
  , @toAuthorNoPk numeric
  , @userId nvarchar(200)
)
as

    declare @pk numeric;
    declare cur_group_author cursor for select group_no_pk from sc_khb_srv.tb_com_group_author where author_no_pk = @frAuthorNoPk;
    declare cur_scrin_author cursor for select scrin_no_pk from sc_khb_srv.tb_com_scrin_author where author_no_pk = @frAuthorNoPk;
    declare cur_gtwy_svc_author cursor for select gtwy_svc_pk from sc_khb_srv.tb_com_gtwy_svc_author where author_no_pk = @frAuthorNoPk;

    -- tb_com_group_author
    open cur_group_author;

    fetch next from cur_group_author into @pk;

    while @@FETCH_STATUS = 0
    
    begin
        insert into sc_khb_srv.tb_com_group_author (com_group_author_pk ,group_no_pk ,author_no_pk ,regist_id ,regist_dt)
        values (next value for sc_khb_srv.sq_com_group_author, @pk, @toAuthorNoPk, @userId, current_timestamp);
    
        fetch next from cur_group_author into @pk;
    end
    
    close cur_group_author;
    deallocate cur_group_author;

    -- tb_com_scrin_author
    open cur_scrin_author;

    fetch next from cur_scrin_author into @pk;

    while @@FETCH_STATUS = 0
    
    begin
        insert into sc_khb_srv.tb_com_scrin_author (com_scrin_author_pk ,scrin_no_pk ,author_no_pk ,regist_id ,regist_dt)
        values (next value for sc_khb_srv.sq_com_scrin_author, @pk, @toAuthorNoPk, @userId, current_timestamp);
    
        fetch next from cur_scrin_author into @pk;
    end
    
    close cur_scrin_author;
    deallocate cur_scrin_author;

    -- tb_com_gtwy_svc_author
    open cur_gtwy_svc_author;

    fetch next from cur_gtwy_svc_author into @pk;

    while @@FETCH_STATUS = 0
    
    begin
        insert into sc_khb_srv.tb_com_gtwy_svc_author(com_gtwy_svc_author_pk ,gtwy_svc_pk ,author_no_pk ,regist_id ,regist_dt)
        values (next value for sc_khb_srv.sq_com_gtwy_svc_author, @pk, @toAuthorNoPk, @userId, current_timestamp);
    
        fetch next from cur_gtwy_svc_author into @pk;
    end
    
    close cur_gtwy_svc_author;
    deallocate cur_gtwy_svc_author;

grant EXECUTE on sc_khb_srv.pc_com_author_copy to us_khb_com;

-- pc_com_author_del
create procedure sc_khb_srv.pc_com_author_del
(
    @authorNoPk numeric
)
as

    declare @rowCnt int;

    select @rowCnt = count(*)
      from sc_khb_srv.tb_com_author tca 
     where parnts_author_no_pk = @authorNoPk;

    if @rowCnt = 1
        begin
            delete from sc_khb_srv.tb_com_group_author where author_no_pk = @authorNoPk;
            delete from sc_khb_srv.tb_com_scrin_author where author_no_pk = @authorNoPk;
            delete from sc_khb_srv.tb_com_gtwy_svc_author where author_no_pk = @authorNoPk;
            delete from sc_khb_srv.tb_com_menu_author where author_no_pk = @authorNoPk;
            delete from sc_khb_srv.tb_com_author where author_no_pk = @authorNoPk;
        end;

grant EXECUTE on sc_khb_srv.pc_com_author_del to us_khb_com;

-- pc_com_group_copy
create procedure sc_khb_srv.pc_com_group_copy
(
    @frGroupNoPk numeric
  , @toGroupNoPk numeric
  , @userId nvarchar(200)
)
as

    declare @pk numeric;
    declare cur_user_group cursor for select user_no_pk from sc_khb_srv.tb_com_user_group where group_no_pk = @frGroupNoPk;
    declare cur_group_author cursor for select author_no_pk from sc_khb_srv.tb_com_group_author where group_no_pk = @frGroupNoPk;

    -- tb_com_user_group
    open cur_user_group;

    fetch next from cur_user_group into @pk;

    while @@FETCH_STATUS = 0
    
    begin
        insert into sc_khb_srv.tb_com_user_group(com_user_group_pk ,user_no_pk ,group_no_pk ,regist_id ,regist_dt)
        values (next value for sc_khb_srv.sq_com_user_group, @pk, @toGroupNoPk, @userId, current_timestamp);
    
        fetch next from cur_user_group into @pk;
    end
    
    close cur_user_group;
    deallocate cur_user_group;

    -- tb_com_group_author
    open cur_group_author;

    fetch next from cur_group_author into @pk;

    while @@FETCH_STATUS = 0
    
    begin
        insert into sc_khb_srv.tb_com_group_author(com_group_author_pk ,author_no_pk ,group_no_pk ,regist_id ,regist_dt)
        values (next value for sc_khb_srv.sq_com_group_author, @pk, @toGroupNoPk, @userId, current_timestamp);
    
        fetch next from cur_group_author into @pk;
    end
    
    close cur_group_author;
    deallocate cur_group_author;

grant EXECUTE on sc_khb_srv.pc_com_group_copy to us_khb_com;

-- pc_com_group_del
create procedure sc_khb_srv.pc_com_group_del
(
    @groupNoPk numeric
)
as

    declare @rowCnt int;

    select @rowCnt = count(*)
      from sc_khb_srv.tb_com_group tcg 
     where parnts_group_no_pk = @groupNoPk;

    if @rowCnt = 1
        begin
            delete from sc_khb_srv.tb_com_user_group where group_no_pk = @groupNoPk;
            delete from sc_khb_srv.tb_com_group_author where group_no_pk = @groupNoPk;
            delete from sc_khb_srv.tb_com_group where group_no_pk = @groupNoPk;
        end;

 GRANT EXECUTE on sc_khb_srv.pc_com_group_del to us_khb_com;






