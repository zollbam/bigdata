/*
프로시저, 함수를 생성하는 쿼리문을 추추하는 파일
작성 일시: 23-06-25
수정 일시: 23-07-03
작 성 자 : 조건영
*/

SELECT *
  FROM information_schema.routines;

-- DB의 프로시저와 함수 정보
SELECT ROUTINE_SCHEMA
     , ROUTINE_NAME
     , ROUTINE_DEFINITION
  FROM information_schema.routines
 WHERE ROUTINE_NAME NOT IN ('fn_split', 'fc_amt_unit_chg')
   AND ROUTINE_SCHEMA = 'sc_khb_srv'
 ORDER BY 2;



-- 프로시저와 함수의 권한 및 식
SELECT class_desc
     , object_name(major_id) "객체명"
     , user_name(grantee_principal_id) "권한 받은 유저"
     , ROUTINE_DEFINITION "식"
     , 'grant ' + 
				  stuff((SELECT ', ' + permission_name 
				           FROM sys.DATABASE_permissions
				          WHERE class_desc= dp.class_desc AND major_id=dp.major_id AND grantee_principal_id=dp.grantee_principal_id
				            FOR xml PATH('')),1,2,'') + 
				  ' on sc_khb_srv.' + 
				  object_name(major_id) + 
				  ' to ' + user_name(grantee_principal_id) + ';' "권한 부여 쿼리"
  FROM sys.DATABASE_permissions dp
       INNER JOIN 
       information_schema.routines isr
               ON object_name(dp.major_id) = isr.ROUTINE_NAME
 WHERE class_desc != 'DATABASE' 
   AND grantee_principal_id != 0
   AND object_name(major_id) NOT IN ('fn_split', 'fc_amt_unit_chg')
   AND isr.ROUTINE_SCHEMA = 'sc_khb_srv'
 GROUP BY class_desc, major_id, grantee_principal_id, ROUTINE_DEFINITION
 ORDER BY 2,3;





-- fc_ctpv_point
 CREATE FUNCTION sc_khb_srv.fc_ctpv_point (@ctpvCdPk int)
RETURNS nvarchar(max)
  BEGIN
        DECLARE @ctpvPoint nvarchar(max);

         SELECT @ctpvPoint = ctpv_crdnt.STAsText()
           FROM db_khb_srv.sc_khb_srv.tb_com_ctpv_cd
          WHERE ctpv_cd_pk = @ctpvCdPk;
 
RETURN @ctpvPoint
   END;


GRANT EXECUTE ON sc_khb_srv.fc_emd_li_point TO us_khb_adm;
GRANT EXECUTE ON sc_khb_srv.fc_emd_li_point TO us_khb_com;





-- fc_current_val
 CREATE FUNCTION sc_khb_srv.fc_current_val (@sequenceName varchar(100))
RETURNS int
  BEGIN
        DECLARE @currentValue sql_variant;

         SELECT @currentValue = current_value
           FROM sys.sequences
          WHERE name = @sequenceName;

RETURN CAST(@currentValue as int)
   END;

GRANT EXECUTE ON sc_khb_srv.fc_current_val TO us_khb_adm;
GRANT EXECUTE ON sc_khb_srv.fc_current_val TO us_khb_agnt;
GRANT EXECUTE ON sc_khb_srv.fc_current_val TO us_khb_com;
GRANT EXECUTE ON sc_khb_srv.fc_current_val TO us_khb_dev;
GRANT EXECUTE ON sc_khb_srv.fc_current_val TO us_khb_exif;
GRANT EXECUTE ON sc_khb_srv.fc_current_val TO us_khb_magnt;
GRANT EXECUTE ON sc_khb_srv.fc_current_val TO us_khb_mptl;
GRANT EXECUTE ON sc_khb_srv.fc_current_val TO us_khb_report;





-- fc_emd_li_pk_abbrev_addr
 CREATE FUNCTION sc_khb_srv.fc_emd_li_pk_abbrev_addr (@emdLiCdPk int)
RETURNS nvarchar(max)
  BEGIN
        DECLARE @emdLiAddr nvarchar(max);

        SELECT @emdLiAddr = tccc.ctpv_abbrev_nm  + ' ' + tcsc.sgg_nm + ' ' + tcelc.all_emd_li_nm
          FROM db_khb_srv.sc_khb_srv.tb_com_emd_li_cd tcelc 
               INNER JOIN 
               sc_khb_srv.tb_com_sgg_cd tcsc 
                       ON tcsc.sgg_cd_pk = tcelc.sgg_cd_pk 
               INNER JOIN 
               sc_khb_srv.tb_com_ctpv_cd tccc 
                       ON tccc.ctpv_cd_pk = tcelc.ctpv_cd_pk 
         WHERE tcelc.emd_li_cd_pk = @emdLiCdPk;

RETURN @emdLiAddr
   END;

GRANT EXECUTE ON sc_khb_srv.fc_emd_li_pk_abbrev_addr TO us_khb_adm;
GRANT EXECUTE ON sc_khb_srv.fc_emd_li_pk_abbrev_addr TO us_khb_com;
GRANT EXECUTE ON sc_khb_srv.fc_emd_li_pk_abbrev_addr TO us_khb_srch;





-- fc_emd_li_pk_addr
 CREATE FUNCTION sc_khb_srv.fc_emd_li_pk_addr (@emdLiCdPk int)
RETURNS nvarchar(max)
  BEGIN
        DECLARE @emdLiAddr nvarchar(max);

        SELECT @emdLiAddr = tccc.ctpv_nm + ' ' + tcsc.sgg_nm + ' ' + tcelc.all_emd_li_nm
          FROM db_khb_srv.sc_khb_srv.tb_com_emd_li_cd tcelc 
               INNER JOIN 
               sc_khb_srv.tb_com_sgg_cd tcsc 
                       ON tcsc.sgg_cd_pk = tcelc.sgg_cd_pk 
               INNER JOIN 
               sc_khb_srv.tb_com_ctpv_cd tccc 
                       ON tccc.ctpv_cd_pk = tcelc.ctpv_cd_pk 
         WHERE tcelc.emd_li_cd_pk = @emdLiCdPk;

RETURN @emdLiAddr
   END;

GRANT EXECUTE ON sc_khb_srv.fc_emd_li_pk_addr TO us_khb_adm;
GRANT EXECUTE ON sc_khb_srv.fc_emd_li_pk_addr TO us_khb_com;
GRANT EXECUTE ON sc_khb_srv.fc_emd_li_pk_addr TO us_khb_srch;





-- fc_emd_li_point
 CREATE FUNCTION sc_khb_srv.fc_emd_li_point (@emdLiCdPk int)
RETURNS nvarchar(max)
  BEGIN
        DECLARE @emdLiPoint nvarchar(max);

         SELECT @emdLiPoint = emd_li_crdnt.STAsText()
           FROM db_khb_srv.sc_khb_srv.tb_com_emd_li_cd
          WHERE emd_li_crdnt IS NOT NULL
            AND emd_li_cd_pk = @emdLiCdPk;
 
RETURN @emdLiPoint
   END;

grant EXECUTE on sc_khb_srv.fc_emd_li_point to us_khb_adm;
grant EXECUTE on sc_khb_srv.fc_emd_li_point to us_khb_com;





-- fc_sgg_point
 CREATE FUNCTION sc_khb_srv.fc_sgg_point (@sggCdPk int)
RETURNS nvarchar(max)
  BEGIN
        DECLARE @sggPoint nvarchar(max);

         SELECT @sggPoint = sgg_crdnt.STAsText()
           FROM db_khb_srv.sc_khb_srv.tb_com_sgg_cd
          WHERE sgg_cd_pk = @sggCdPk;
 
RETURN @sggPoint
END;

grant execute on sc_khb_srv.fc_sgg_point to us_khb_adm;
grant execute on sc_khb_srv.fc_sgg_point to us_khb_com;





-- fc_stdg_dong_cd_abbrev_addr
 CREATE function sc_khb_srv.fc_stdg_dong_cd_abbrev_addr (@stdgDongCd varchar(10))
RETURNS nvarchar(max)
  BEGIN
        DECLARE @stdgDongAddr nvarchar(max);

         SELECT @stdgDongAddr = tccc.ctpv_abbrev_nm + ' ' + tcsc.sgg_nm + ' ' + tcelc.all_emd_li_nm
           FROM sc_khb_srv.tb_com_emd_li_cd tcelc 
                INNER JOIN 
                sc_khb_srv.tb_com_sgg_cd tcsc 
                        ON tcsc.sgg_cd_pk = tcelc.sgg_cd_pk 
                INNER JOIN sc_khb_srv.tb_com_ctpv_cd tccc 
                        ON tccc.ctpv_cd_pk = tcelc.ctpv_cd_pk 
          WHERE tcelc.stdg_dong_cd = @stdgDongCd
            AND tcelc.stdg_dong_se_cd = 'B';

 RETURN @stdgDongAddr
    END;

GRANT EXECUTE ON sc_khb_srv.fc_stdg_dong_cd_abbrev_addr TO us_khb_adm;
GRANT EXECUTE ON sc_khb_srv.fc_stdg_dong_cd_abbrev_addr TO us_khb_com;
GRANT EXECUTE ON sc_khb_srv.fc_stdg_dong_cd_abbrev_addr TO us_khb_srch;





-- fc_stdg_dong_cd_addr
 CREATE FUNCTION sc_khb_srv.fc_stdg_dong_cd_addr (@stdgDongCd varchar(10))
RETURNS nvarchar(max)
  BEGIN
        DECLARE @stdgDongAddr nvarchar(max);

         SELECT @stdgDongAddr = tccc.ctpv_nm + ' ' + tcsc.sgg_nm + ' ' + tcelc.all_emd_li_nm
           FROM sc_khb_srv.tb_com_emd_li_cd tcelc 
                INNER JOIN
                sc_khb_srv.tb_com_sgg_cd tcsc 
                        ON tcsc.sgg_cd_pk = tcelc.sgg_cd_pk 
                INNER JOIN sc_khb_srv.tb_com_ctpv_cd tccc 
                        ON tccc.ctpv_cd_pk = tcelc.ctpv_cd_pk 
          WHERE tcelc.stdg_dong_cd = @stdgDongCd
            AND tcelc.stdg_dong_se_cd = 'B';

 RETURN @stdgDongAddr
    END;

grant EXECUTE on sc_khb_srv.fc_stdg_dong_cd_addr to us_khb_adm;
grant EXECUTE on sc_khb_srv.fc_stdg_dong_cd_addr to us_khb_com;
grant EXECUTE on sc_khb_srv.fc_stdg_dong_cd_addr to us_khb_srch;





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

        FETCH NEXT from cur_gtwy_svc_author into @pk;
    END

    CLOSE cur_gtwy_svc_author;
    DEALLOCATE cur_gtwy_svc_author;

GRANT EXECUTE ON sc_khb_srv.pc_com_author_copy to us_khb_com;





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
        END;

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
        END; 


 GRANT EXECUTE on sc_khb_srv.pc_com_group_del to us_khb_com;






