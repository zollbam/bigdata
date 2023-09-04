/*
시퀀스를 생성 및 업데이트
시작 일시: 23-06-28
수정 일시: 230816
작 성 자: 조건영
작성 목적 : 시퀀스의 생성 및 권한 부여
사용 DB : mssql 2016
*/

-- 시퀀스 생성 쿼리문 스크립트 작성(161)
SELECT TABLE_NAME,
  'CREATE SEQUENCE ' + TABLE_SCHEMA + '.' + replace(table_name, 'tb_', 'sq_') + char(13) +
  '    START WITH 1' + char(13) + 
  '    INCREMENT BY 1' + char(13) +
  '    MINVALUE 1' + char(13) +
  '    MAXVALUE 999999999999999999' + char(13) +
  '    CACHE;' + char(13) "시퀀스 생성"
  FROM information_schema.tables
 WHERE TABLE_SCHEMA = 'sc_khb_srv'
       AND 
       TABLE_NAME NOT LIKE '%link%'
       AND 
       TABLE_NAME NOT LIKE 'vw:_%' ESCAPE ':'
 ORDER BY 1;



-- 시퀀스 생성 쿼리문
CREATE SEQUENCE sc_khb_srv.sq_atlfsl_batch_hstry
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_bsc_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_cfr_fclt_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_dlng_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_etc_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_img_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_inqry_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_land_usg_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_thema_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_author
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_banner_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_bbs
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_bbs_cmnt
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_crtfc_tmpr
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_code
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_crtfc_tmpr
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_ctpv_cd
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_device_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_device_ntcn_mapng_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_device_stng_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_emd_li_cd
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_error_log
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_faq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_file
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_file_mapng
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_group
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_group_author
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_gtwy_svc
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_gtwy_svc_author
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_job_schdl_hstry
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_job_schdl_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_login_hist
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_menu
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_menu_author
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_notice
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_ntcn_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_push_meta_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_qna
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_recsroom
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_rss_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_scrin
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_scrin_author
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_sgg_cd
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_stplat_hist
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_stplat_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_stplat_mapng
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_svc_ip_manage
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_thema_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_user
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_user_author
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_user_group
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_user_ntcn_mapng_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_hsmp_dtl_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_hsmp_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_itrst_atlfsl_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_lrea_office_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_lrea_schdl_ntcn_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_lrea_sns_url_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_lrea_spclty_fld_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_lttot_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_svc_bass_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_user_atlfsl_img_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_user_atlfsl_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_user_atlfsl_preocupy_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_user_atlfsl_thema_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;



-- 시퀀스 최대값 수정 쿼리문 스크립트 작성(161)
SELECT TABLE_NAME,
  'alter SEQUENCE ' + TABLE_SCHEMA + '.' + replace(table_name, 'tb_', 'sq_') + ' MAXVALUE 999999999999999999;' "시퀀스 최대값 수정"
  FROM information_schema.tables
 WHERE TABLE_SCHEMA = 'sc_khb_srv'
       AND 
       TABLE_NAME NOT LIKE '%link%'
       AND 
       TABLE_NAME NOT LIKE 'vw:_%' ESCAPE ':'
 ORDER BY 1;



-- 시퀀스 최대값 수정
/*복사 붙여넣기*/



-- 시퀀스 값 업데이트(161)
SELECT name, current_value
  FROM sys.sequences
 ORDER BY 1;

-- 각 테이블 pk의 최대값 구하기 스크립트 작성(161)
SELECT object_name(object_id),
  'select max(' + name + ') from sc_khb_srv.' + object_name(object_id) + ';'
  FROM sys.columns
 WHERE object_name(object_id) IN (SELECT table_name 
                                    FROM information_schema.tables 
                                   WHERE TABLE_SCHEMA = 'sc_khb_srv'
                                     AND TABLE_NAME NOT LIKE '%link%'
                                     AND TABLE_NAME NOT LIKE 'vw:_%' ESCAPE ':'
                                     AND TABLE_NAME NOT IN ('tb_tmp','tb_tmp_2','tb_tmp_3','tb_tmp_4','tb_tmp_5','tb_tmp_sec','tb_tmp_t','tb_jado_index'))
   AND column_id = 1
 ORDER BY 1;

select max(atlfsl_batch_hstry_pk) from sc_khb_srv.tb_atlfsl_batch_hstry;
select max(atlfsl_bsc_info_pk) from sc_khb_srv.tb_atlfsl_bsc_info;
select max(atlfsl_cfr_fclt_info_pk) from sc_khb_srv.tb_atlfsl_cfr_fclt_info;
select max(atlfsl_dlng_info_pk) from sc_khb_srv.tb_atlfsl_dlng_info;
select max(atlfsl_etc_info_pk) from sc_khb_srv.tb_atlfsl_etc_info;
select max(atlfsl_img_info_pk) from sc_khb_srv.tb_atlfsl_img_info;
select max(atlfsl_inqry_info_pk) from sc_khb_srv.tb_atlfsl_inqry_info;
select max(atlfsl_land_usg_info_pk) from sc_khb_srv.tb_atlfsl_land_usg_info;
select max(atlfsl_thema_info_pk) from sc_khb_srv.tb_atlfsl_thema_info;
select max(author_no_pk) from sc_khb_srv.tb_com_author;
select max(banner_info_pk) from sc_khb_srv.tb_com_banner_info;
select max(bbs_pk) from sc_khb_srv.tb_com_bbs;
select max(bbs_cmnt_pk) from sc_khb_srv.tb_com_bbs_cmnt;
select max(code_pk) from sc_khb_srv.tb_com_code;
select max(crtfc_pk) from sc_khb_srv.tb_com_crtfc_tmpr;
select max(ctpv_cd_pk) from sc_khb_srv.tb_com_ctpv_cd;
select max(device_info_pk) from sc_khb_srv.tb_com_device_info;
select max(device_ntcn_mapng_info_pk) from sc_khb_srv.tb_com_device_ntcn_mapng_info;
select max(device_stng_info_pk) from sc_khb_srv.tb_com_device_stng_info;
select max(emd_li_cd_pk) from sc_khb_srv.tb_com_emd_li_cd;
select max(error_log_pk) from sc_khb_srv.tb_com_error_log;
select max(faq_no_pk) from sc_khb_srv.tb_com_faq;
select max(file_no_pk) from sc_khb_srv.tb_com_file;
select max(file_no_pk) from sc_khb_srv.tb_com_file_mapng;
select max(group_no_pk) from sc_khb_srv.tb_com_group;
select max(com_group_author_pk) from sc_khb_srv.tb_com_group_author;
select max(gtwy_svc_pk) from sc_khb_srv.tb_com_gtwy_svc;
select max(com_gtwy_svc_author_pk) from sc_khb_srv.tb_com_gtwy_svc_author;
select max(job_schdl_hstry_pk) from sc_khb_srv.tb_com_job_schdl_hstry;
select max(job_schdl_info_pk) from sc_khb_srv.tb_com_job_schdl_info;
select max(login_hist_pk) from sc_khb_srv.tb_com_login_hist;
select max(menu_no_pk) from sc_khb_srv.tb_com_menu;
select max(com_menu_author_pk) from sc_khb_srv.tb_com_menu_author;
select max(notice_no_pk) from sc_khb_srv.tb_com_notice;
select max(ntcn_info_pk) from sc_khb_srv.tb_com_ntcn_info;
select max(push_meta_info_pk) from sc_khb_srv.tb_com_push_meta_info;
select max(qna_no_pk) from sc_khb_srv.tb_com_qna;
select max(recsroom_no_pk) from sc_khb_srv.tb_com_recsroom;
select max(rss_info_pk) from sc_khb_srv.tb_com_rss_info;
select max(scrin_no_pk) from sc_khb_srv.tb_com_scrin;
select max(com_scrin_author_pk) from sc_khb_srv.tb_com_scrin_author;
select max(sgg_cd_pk) from sc_khb_srv.tb_com_sgg_cd;
select max(com_stplat_hist_pk) from sc_khb_srv.tb_com_stplat_hist;
select max(com_stplat_info_pk) from sc_khb_srv.tb_com_stplat_info;
select max(com_stplat_mapng_pk) from sc_khb_srv.tb_com_stplat_mapng;
select max(ip_manage_pk) from sc_khb_srv.tb_com_svc_ip_manage;
select max(thema_info_pk) from sc_khb_srv.tb_com_thema_info;
select max(user_no_pk) from sc_khb_srv.tb_com_user;
select max(user_author_pk) from sc_khb_srv.tb_com_user_author;
select max(com_user_group_pk) from sc_khb_srv.tb_com_user_group;
select max(user_ntcn_mapng_info_pk) from sc_khb_srv.tb_com_user_ntcn_mapng_info;
select max(hsmp_dtl_info_pk) from sc_khb_srv.tb_hsmp_dtl_info;
select max(hsmp_info_pk) from sc_khb_srv.tb_hsmp_info;
select max(itrst_atlfsl_info_pk) from sc_khb_srv.tb_itrst_atlfsl_info;
select max(lrea_office_info_pk) from sc_khb_srv.tb_lrea_office_info;
select max(lrea_schdl_ntcn_info_pk) from sc_khb_srv.tb_lrea_schdl_ntcn_info;
select max(lrea_sns_url_info_pk) from sc_khb_srv.tb_lrea_sns_url_info;
select max(lrea_spclty_fld_info_pk) from sc_khb_srv.tb_lrea_spclty_fld_info;
select max(lttot_info_pk) from sc_khb_srv.tb_lttot_info;
select max(svc_pk) from sc_khb_srv.tb_svc_bass_info;
select max(user_atlfsl_img_info_pk) from sc_khb_srv.tb_user_atlfsl_img_info;
select max(user_atlfsl_info_pk) from sc_khb_srv.tb_user_atlfsl_info;
select max(user_atlfsl_preocupy_info_pk) from sc_khb_srv.tb_user_atlfsl_preocupy_info;
select max(user_atlfsl_thema_info_pk) from sc_khb_srv.tb_user_atlfsl_thema_info;


-- 시퀀스 업데이트(162)
/*
현재 시퀀스값 확인하기
=> 밑에 쿼리문으로 나온 결과를 복사 붙여넣기 하면 각 테이블별 pk의 최대값을 구할 수 있다.

마지막 union은 삭제 시키고 실행 시키자
*/
SELECT 
  'with max_value as (' +
  stuff((
		  SELECT ' ' + char(10) +
		  'select ''' + TABLE_NAME + ''' "table_name", max(' + COLUMN_NAME + ') "max_value"' + char(10) + 
		  '  from ' + TABLE_SCHEMA + '.' + TABLE_NAME +
		  CASE WHEN TABLE_NAME = 'tb_user_atlfsl_thema_info' THEN ''
		       WHEN TABLE_NAME != (SELECT TOP 1 TABLE_NAME
		                              FROM information_schema.tables
		                             WHERE TABLE_SCHEMA = 'sc_khb_srv'
		                             ORDER BY 1 DESC) THEN char(10) + ' union'
		       ELSE ''
		  END
		  FROM information_schema.columns
		 WHERE ORDINAL_POSITION=1
		   AND TABLE_SCHEMA = 'sc_khb_srv'
		   AND TABLE_NAME NOT LIKE '%link%'
           AND TABLE_NAME NOT LIKE 'vw:_%' ESCAPE ':'
           AND TABLE_NAME NOT IN ('tb_tmp','tb_tmp_2','tb_tmp_3','tb_tmp_4','tb_tmp_5','tb_tmp_sec','tb_tmp_t','tb_jado_index')
		 ORDER BY TABLE_NAME
		 FOR xml PATH('')), 1, 1, '') + char(10) +
  ')' + char(10) +
  'SELECT * from max_value;';

/*위의 쿼리결과 복사붙여 넣기 한 스크립트*/
with max_value as (
select 'tb_atlfsl_batch_hstry' "table_name", max(atlfsl_batch_hstry_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_batch_hstry
 union 
select 'tb_atlfsl_bsc_info' "table_name", max(atlfsl_bsc_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_bsc_info
 union 
select 'tb_atlfsl_cfr_fclt_info' "table_name", max(atlfsl_cfr_fclt_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_cfr_fclt_info
 union 
select 'tb_atlfsl_dlng_info' "table_name", max(atlfsl_dlng_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_dlng_info
 union 
select 'tb_atlfsl_etc_info' "table_name", max(atlfsl_etc_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_etc_info
 union 
select 'tb_atlfsl_img_info' "table_name", max(atlfsl_img_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_img_info
 union 
select 'tb_atlfsl_inqry_info' "table_name", max(atlfsl_inqry_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_inqry_info
 union 
select 'tb_atlfsl_land_usg_info' "table_name", max(atlfsl_land_usg_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_land_usg_info
 union 
select 'tb_atlfsl_thema_info' "table_name", max(atlfsl_thema_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_thema_info
 union 
select 'tb_com_author' "table_name", max(author_no_pk) "max_value"
  from sc_khb_srv.tb_com_author
 union 
select 'tb_com_banner_info' "table_name", max(banner_info_pk) "max_value"
  from sc_khb_srv.tb_com_banner_info
 union 
select 'tb_com_bbs' "table_name", max(bbs_pk) "max_value"
  from sc_khb_srv.tb_com_bbs
 union 
select 'tb_com_bbs_cmnt' "table_name", max(bbs_cmnt_pk) "max_value"
  from sc_khb_srv.tb_com_bbs_cmnt
 union 
select 'tb_com_code' "table_name", max(code_pk) "max_value"
  from sc_khb_srv.tb_com_code
 union 
select 'tb_com_crtfc_tmpr' "table_name", max(crtfc_pk) "max_value"
  from sc_khb_srv.tb_com_crtfc_tmpr
 union 
select 'tb_com_ctpv_cd' "table_name", max(ctpv_cd_pk) "max_value"
  from sc_khb_srv.tb_com_ctpv_cd
 union 
select 'tb_com_device_info' "table_name", max(device_info_pk) "max_value"
  from sc_khb_srv.tb_com_device_info
 union 
select 'tb_com_device_ntcn_mapng_info' "table_name", max(device_ntcn_mapng_info_pk) "max_value"
  from sc_khb_srv.tb_com_device_ntcn_mapng_info
 union 
select 'tb_com_device_stng_info' "table_name", max(device_stng_info_pk) "max_value"
  from sc_khb_srv.tb_com_device_stng_info
 union 
select 'tb_com_emd_li_cd' "table_name", max(emd_li_cd_pk) "max_value"
  from sc_khb_srv.tb_com_emd_li_cd
 union 
select 'tb_com_error_log' "table_name", max(error_log_pk) "max_value"
  from sc_khb_srv.tb_com_error_log
 union 
select 'tb_com_faq' "table_name", max(faq_no_pk) "max_value"
  from sc_khb_srv.tb_com_faq
 union 
select 'tb_com_file' "table_name", max(file_no_pk) "max_value"
  from sc_khb_srv.tb_com_file
 union 
select 'tb_com_file_mapng' "table_name", max(file_no_pk) "max_value"
  from sc_khb_srv.tb_com_file_mapng
 union 
select 'tb_com_group' "table_name", max(group_no_pk) "max_value"
  from sc_khb_srv.tb_com_group
 union 
select 'tb_com_group_author' "table_name", max(com_group_author_pk) "max_value"
  from sc_khb_srv.tb_com_group_author
 union 
select 'tb_com_gtwy_svc' "table_name", max(gtwy_svc_pk) "max_value"
  from sc_khb_srv.tb_com_gtwy_svc
 union 
select 'tb_com_gtwy_svc_author' "table_name", max(com_gtwy_svc_author_pk) "max_value"
  from sc_khb_srv.tb_com_gtwy_svc_author
 union 
select 'tb_com_job_schdl_hstry' "table_name", max(job_schdl_hstry_pk) "max_value"
  from sc_khb_srv.tb_com_job_schdl_hstry
 union 
select 'tb_com_job_schdl_info' "table_name", max(job_schdl_info_pk) "max_value"
  from sc_khb_srv.tb_com_job_schdl_info
 union 
select 'tb_com_login_hist' "table_name", max(login_hist_pk) "max_value"
  from sc_khb_srv.tb_com_login_hist
 union 
select 'tb_com_menu' "table_name", max(menu_no_pk) "max_value"
  from sc_khb_srv.tb_com_menu
 union 
select 'tb_com_menu_author' "table_name", max(com_menu_author_pk) "max_value"
  from sc_khb_srv.tb_com_menu_author
 union 
select 'tb_com_notice' "table_name", max(notice_no_pk) "max_value"
  from sc_khb_srv.tb_com_notice
 union 
select 'tb_com_ntcn_info' "table_name", max(ntcn_info_pk) "max_value"
  from sc_khb_srv.tb_com_ntcn_info
 union 
select 'tb_com_push_meta_info' "table_name", max(push_meta_info_pk) "max_value"
  from sc_khb_srv.tb_com_push_meta_info
 union 
select 'tb_com_qna' "table_name", max(qna_no_pk) "max_value"
  from sc_khb_srv.tb_com_qna
 union 
select 'tb_com_recsroom' "table_name", max(recsroom_no_pk) "max_value"
  from sc_khb_srv.tb_com_recsroom
 union 
select 'tb_com_rss_info' "table_name", max(rss_info_pk) "max_value"
  from sc_khb_srv.tb_com_rss_info
 union 
select 'tb_com_scrin' "table_name", max(scrin_no_pk) "max_value"
  from sc_khb_srv.tb_com_scrin
 union 
select 'tb_com_scrin_author' "table_name", max(com_scrin_author_pk) "max_value"
  from sc_khb_srv.tb_com_scrin_author
 union 
select 'tb_com_sgg_cd' "table_name", max(sgg_cd_pk) "max_value"
  from sc_khb_srv.tb_com_sgg_cd
 union 
select 'tb_com_stplat_hist' "table_name", max(com_stplat_hist_pk) "max_value"
  from sc_khb_srv.tb_com_stplat_hist
 union 
select 'tb_com_stplat_info' "table_name", max(com_stplat_info_pk) "max_value"
  from sc_khb_srv.tb_com_stplat_info
 union 
select 'tb_com_stplat_mapng' "table_name", max(com_stplat_mapng_pk) "max_value"
  from sc_khb_srv.tb_com_stplat_mapng
 union 
select 'tb_com_svc_ip_manage' "table_name", max(ip_manage_pk) "max_value"
  from sc_khb_srv.tb_com_svc_ip_manage
 union 
select 'tb_com_thema_info' "table_name", max(thema_info_pk) "max_value"
  from sc_khb_srv.tb_com_thema_info
 union 
select 'tb_com_user' "table_name", max(user_no_pk) "max_value"
  from sc_khb_srv.tb_com_user
 union 
select 'tb_com_user_author' "table_name", max(user_author_pk) "max_value"
  from sc_khb_srv.tb_com_user_author
 union 
select 'tb_com_user_group' "table_name", max(com_user_group_pk) "max_value"
  from sc_khb_srv.tb_com_user_group
 union 
select 'tb_com_user_ntcn_mapng_info' "table_name", max(user_ntcn_mapng_info_pk) "max_value"
  from sc_khb_srv.tb_com_user_ntcn_mapng_info
 union 
select 'tb_hsmp_dtl_info' "table_name", max(hsmp_dtl_info_pk) "max_value"
  from sc_khb_srv.tb_hsmp_dtl_info
 union 
select 'tb_hsmp_info' "table_name", max(hsmp_info_pk) "max_value"
  from sc_khb_srv.tb_hsmp_info
 union 
select 'tb_itrst_atlfsl_info' "table_name", max(itrst_atlfsl_info_pk) "max_value"
  from sc_khb_srv.tb_itrst_atlfsl_info
 union 
select 'tb_lrea_office_info' "table_name", max(lrea_office_info_pk) "max_value"
  from sc_khb_srv.tb_lrea_office_info
 union 
select 'tb_lrea_schdl_ntcn_info' "table_name", max(lrea_schdl_ntcn_info_pk) "max_value"
  from sc_khb_srv.tb_lrea_schdl_ntcn_info
 union 
select 'tb_lrea_sns_url_info' "table_name", max(lrea_sns_url_info_pk) "max_value"
  from sc_khb_srv.tb_lrea_sns_url_info
 union 
select 'tb_lrea_spclty_fld_info' "table_name", max(lrea_spclty_fld_info_pk) "max_value"
  from sc_khb_srv.tb_lrea_spclty_fld_info
 union 
select 'tb_lttot_info' "table_name", max(lttot_info_pk) "max_value"
  from sc_khb_srv.tb_lttot_info
 union 
select 'tb_svc_bass_info' "table_name", max(svc_pk) "max_value"
  from sc_khb_srv.tb_svc_bass_info
 union 
select 'tb_user_atlfsl_img_info' "table_name", max(user_atlfsl_img_info_pk) "max_value"
  from sc_khb_srv.tb_user_atlfsl_img_info
 union 
select 'tb_user_atlfsl_info' "table_name", max(user_atlfsl_info_pk) "max_value"
  from sc_khb_srv.tb_user_atlfsl_info
 union 
select 'tb_user_atlfsl_preocupy_info' "table_name", max(user_atlfsl_preocupy_info_pk) "max_value"
  from sc_khb_srv.tb_user_atlfsl_preocupy_info
 union 
select 'tb_user_atlfsl_thema_info' "table_name", max(user_atlfsl_thema_info_pk) "max_value"
  from sc_khb_srv.tb_user_atlfsl_thema_info
)
SELECT * from max_value;


-- 현재 시퀀스값에 맞게 업데이트
SELECT 
  'with max_value as (' +
  stuff((
		  SELECT ' ' + char(10) +
		  'select ''' + TABLE_NAME + ''' "table_name", max(' + COLUMN_NAME + ') "max_value"' + char(10) + 
		  '  from ' + TABLE_SCHEMA + '.' + TABLE_NAME +
		  CASE WHEN table_name = 'tb_user_atlfsl_thema_info' THEN '' 
		       WHEN TABLE_NAME != (SELECT TOP 1 TABLE_NAME
		                              FROM information_schema.tables
		                             WHERE TABLE_SCHEMA = 'sc_khb_srv'
		                             ORDER BY 1 DESC) THEN char(10) + ' union'
		       ELSE ''
		  END
		  FROM information_schema.columns
		 WHERE ORDINAL_POSITION=1
		   AND TABLE_SCHEMA = 'sc_khb_srv'
		   AND TABLE_NAME NOT LIKE '%link%'
           AND TABLE_NAME NOT LIKE 'vw:_%' ESCAPE ':'
           AND TABLE_NAME NOT IN ('tb_tmp','tb_tmp_2','tb_tmp_3','tb_tmp_4','tb_tmp_5','tb_tmp_sec','tb_tmp_t','tb_jado_index')
		 ORDER BY TABLE_NAME
		 FOR xml PATH('')), 1, 1, '') + char(10) +
  ')' + char(10) +
  'SELECT
     replace(table_name, ''tb_'', ''sq_'') "시퀀스명"
   , concat(''alter sequence sc_khb_srv.'', 
            replace(table_name, ''tb_'', ''sq_''),
            '' restart with '',
            CASE WHEN max_value IS NULL THEN 1
                 ELSE max_value + 1
            END,
            '';'') "시퀀스 업데이트 쿼리"
     from max_value;';

with max_value as (
select 'tb_atlfsl_batch_hstry' "table_name", max(atlfsl_batch_hstry_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_batch_hstry
 union 
select 'tb_atlfsl_bsc_info' "table_name", max(atlfsl_bsc_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_bsc_info
 union 
select 'tb_atlfsl_cfr_fclt_info' "table_name", max(atlfsl_cfr_fclt_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_cfr_fclt_info
 union 
select 'tb_atlfsl_dlng_info' "table_name", max(atlfsl_dlng_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_dlng_info
 union 
select 'tb_atlfsl_etc_info' "table_name", max(atlfsl_etc_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_etc_info
 union 
select 'tb_atlfsl_img_info' "table_name", max(atlfsl_img_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_img_info
 union 
select 'tb_atlfsl_inqry_info' "table_name", max(atlfsl_inqry_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_inqry_info
 union 
select 'tb_atlfsl_land_usg_info' "table_name", max(atlfsl_land_usg_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_land_usg_info
 union 
select 'tb_atlfsl_thema_info' "table_name", max(atlfsl_thema_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_thema_info
 union 
select 'tb_com_author' "table_name", max(author_no_pk) "max_value"
  from sc_khb_srv.tb_com_author
 union 
select 'tb_com_banner_info' "table_name", max(banner_info_pk) "max_value"
  from sc_khb_srv.tb_com_banner_info
 union 
select 'tb_com_bbs' "table_name", max(bbs_pk) "max_value"
  from sc_khb_srv.tb_com_bbs
 union 
select 'tb_com_bbs_cmnt' "table_name", max(bbs_cmnt_pk) "max_value"
  from sc_khb_srv.tb_com_bbs_cmnt
 union 
select 'tb_com_code' "table_name", max(code_pk) "max_value"
  from sc_khb_srv.tb_com_code
 union 
select 'tb_com_crtfc_tmpr' "table_name", max(crtfc_pk) "max_value"
  from sc_khb_srv.tb_com_crtfc_tmpr
 union 
select 'tb_com_ctpv_cd' "table_name", max(ctpv_cd_pk) "max_value"
  from sc_khb_srv.tb_com_ctpv_cd
 union 
select 'tb_com_device_info' "table_name", max(device_info_pk) "max_value"
  from sc_khb_srv.tb_com_device_info
 union 
select 'tb_com_device_ntcn_mapng_info' "table_name", max(device_ntcn_mapng_info_pk) "max_value"
  from sc_khb_srv.tb_com_device_ntcn_mapng_info
 union 
select 'tb_com_device_stng_info' "table_name", max(device_stng_info_pk) "max_value"
  from sc_khb_srv.tb_com_device_stng_info
 union 
select 'tb_com_emd_li_cd' "table_name", max(emd_li_cd_pk) "max_value"
  from sc_khb_srv.tb_com_emd_li_cd
 union 
select 'tb_com_error_log' "table_name", max(error_log_pk) "max_value"
  from sc_khb_srv.tb_com_error_log
 union 
select 'tb_com_faq' "table_name", max(faq_no_pk) "max_value"
  from sc_khb_srv.tb_com_faq
 union 
select 'tb_com_file' "table_name", max(file_no_pk) "max_value"
  from sc_khb_srv.tb_com_file
 union 
select 'tb_com_file_mapng' "table_name", max(file_no_pk) "max_value"
  from sc_khb_srv.tb_com_file_mapng
 union 
select 'tb_com_group' "table_name", max(group_no_pk) "max_value"
  from sc_khb_srv.tb_com_group
 union 
select 'tb_com_group_author' "table_name", max(com_group_author_pk) "max_value"
  from sc_khb_srv.tb_com_group_author
 union 
select 'tb_com_gtwy_svc' "table_name", max(gtwy_svc_pk) "max_value"
  from sc_khb_srv.tb_com_gtwy_svc
 union 
select 'tb_com_gtwy_svc_author' "table_name", max(com_gtwy_svc_author_pk) "max_value"
  from sc_khb_srv.tb_com_gtwy_svc_author
 union 
select 'tb_com_job_schdl_hstry' "table_name", max(job_schdl_hstry_pk) "max_value"
  from sc_khb_srv.tb_com_job_schdl_hstry
 union 
select 'tb_com_job_schdl_info' "table_name", max(job_schdl_info_pk) "max_value"
  from sc_khb_srv.tb_com_job_schdl_info
 union 
select 'tb_com_login_hist' "table_name", max(login_hist_pk) "max_value"
  from sc_khb_srv.tb_com_login_hist
 union 
select 'tb_com_menu' "table_name", max(menu_no_pk) "max_value"
  from sc_khb_srv.tb_com_menu
 union 
select 'tb_com_menu_author' "table_name", max(com_menu_author_pk) "max_value"
  from sc_khb_srv.tb_com_menu_author
 union 
select 'tb_com_notice' "table_name", max(notice_no_pk) "max_value"
  from sc_khb_srv.tb_com_notice
 union 
select 'tb_com_ntcn_info' "table_name", max(ntcn_info_pk) "max_value"
  from sc_khb_srv.tb_com_ntcn_info
 union 
select 'tb_com_push_meta_info' "table_name", max(push_meta_info_pk) "max_value"
  from sc_khb_srv.tb_com_push_meta_info
 union 
select 'tb_com_qna' "table_name", max(qna_no_pk) "max_value"
  from sc_khb_srv.tb_com_qna
 union 
select 'tb_com_recsroom' "table_name", max(recsroom_no_pk) "max_value"
  from sc_khb_srv.tb_com_recsroom
 union 
select 'tb_com_rss_info' "table_name", max(rss_info_pk) "max_value"
  from sc_khb_srv.tb_com_rss_info
 union 
select 'tb_com_scrin' "table_name", max(scrin_no_pk) "max_value"
  from sc_khb_srv.tb_com_scrin
 union 
select 'tb_com_scrin_author' "table_name", max(com_scrin_author_pk) "max_value"
  from sc_khb_srv.tb_com_scrin_author
 union 
select 'tb_com_sgg_cd' "table_name", max(sgg_cd_pk) "max_value"
  from sc_khb_srv.tb_com_sgg_cd
 union 
select 'tb_com_stplat_hist' "table_name", max(com_stplat_hist_pk) "max_value"
  from sc_khb_srv.tb_com_stplat_hist
 union 
select 'tb_com_stplat_info' "table_name", max(com_stplat_info_pk) "max_value"
  from sc_khb_srv.tb_com_stplat_info
 union 
select 'tb_com_stplat_mapng' "table_name", max(com_stplat_mapng_pk) "max_value"
  from sc_khb_srv.tb_com_stplat_mapng
 union 
select 'tb_com_svc_ip_manage' "table_name", max(ip_manage_pk) "max_value"
  from sc_khb_srv.tb_com_svc_ip_manage
 union 
select 'tb_com_thema_info' "table_name", max(thema_info_pk) "max_value"
  from sc_khb_srv.tb_com_thema_info
 union 
select 'tb_com_user' "table_name", max(user_no_pk) "max_value"
  from sc_khb_srv.tb_com_user
 union 
select 'tb_com_user_author' "table_name", max(user_author_pk) "max_value"
  from sc_khb_srv.tb_com_user_author
 union 
select 'tb_com_user_group' "table_name", max(com_user_group_pk) "max_value"
  from sc_khb_srv.tb_com_user_group
 union 
select 'tb_com_user_ntcn_mapng_info' "table_name", max(user_ntcn_mapng_info_pk) "max_value"
  from sc_khb_srv.tb_com_user_ntcn_mapng_info
 union 
select 'tb_hsmp_dtl_info' "table_name", max(hsmp_dtl_info_pk) "max_value"
  from sc_khb_srv.tb_hsmp_dtl_info
 union 
select 'tb_hsmp_info' "table_name", max(hsmp_info_pk) "max_value"
  from sc_khb_srv.tb_hsmp_info
 union 
select 'tb_itrst_atlfsl_info' "table_name", max(itrst_atlfsl_info_pk) "max_value"
  from sc_khb_srv.tb_itrst_atlfsl_info
 union 
select 'tb_lrea_office_info' "table_name", max(lrea_office_info_pk) "max_value"
  from sc_khb_srv.tb_lrea_office_info
 union 
select 'tb_lrea_schdl_ntcn_info' "table_name", max(lrea_schdl_ntcn_info_pk) "max_value"
  from sc_khb_srv.tb_lrea_schdl_ntcn_info
 union 
select 'tb_lrea_sns_url_info' "table_name", max(lrea_sns_url_info_pk) "max_value"
  from sc_khb_srv.tb_lrea_sns_url_info
 union 
select 'tb_lrea_spclty_fld_info' "table_name", max(lrea_spclty_fld_info_pk) "max_value"
  from sc_khb_srv.tb_lrea_spclty_fld_info
 union 
select 'tb_lttot_info' "table_name", max(lttot_info_pk) "max_value"
  from sc_khb_srv.tb_lttot_info
 union 
select 'tb_svc_bass_info' "table_name", max(svc_pk) "max_value"
  from sc_khb_srv.tb_svc_bass_info
 union 
select 'tb_user_atlfsl_img_info' "table_name", max(user_atlfsl_img_info_pk) "max_value"
  from sc_khb_srv.tb_user_atlfsl_img_info
 union 
select 'tb_user_atlfsl_info' "table_name", max(user_atlfsl_info_pk) "max_value"
  from sc_khb_srv.tb_user_atlfsl_info
 union 
select 'tb_user_atlfsl_preocupy_info' "table_name", max(user_atlfsl_preocupy_info_pk) "max_value"
  from sc_khb_srv.tb_user_atlfsl_preocupy_info
 union 
select 'tb_user_atlfsl_thema_info' "table_name", max(user_atlfsl_thema_info_pk) "max_value"
  from sc_khb_srv.tb_user_atlfsl_thema_info
)
SELECT
     replace(table_name, 'tb_', 'sq_') "시퀀스명"
   , concat('alter sequence sc_khb_srv.', 
            replace(table_name, 'tb_', 'sq_'),
            ' restart with ',
            CASE WHEN max_value IS NULL THEN 1
                 ELSE max_value + 1
            END,
            ';') "시퀀스 업데이트 쿼리"
     from max_value;


alter sequence sc_khb_srv.sq_atlfsl_batch_hstry restart with 48788649;
alter sequence sc_khb_srv.sq_atlfsl_bsc_info restart with 20849890;
alter sequence sc_khb_srv.sq_atlfsl_cfr_fclt_info restart with 20848922;
alter sequence sc_khb_srv.sq_atlfsl_dlng_info restart with 20848926;
alter sequence sc_khb_srv.sq_atlfsl_etc_info restart with 20848922;
alter sequence sc_khb_srv.sq_atlfsl_img_info restart with 836227;
alter sequence sc_khb_srv.sq_atlfsl_inqry_info restart with 1;
alter sequence sc_khb_srv.sq_atlfsl_land_usg_info restart with 20848922;
alter sequence sc_khb_srv.sq_atlfsl_thema_info restart with 155376;
alter sequence sc_khb_srv.sq_com_author restart with 5;
alter sequence sc_khb_srv.sq_com_banner_info restart with 23;
alter sequence sc_khb_srv.sq_com_bbs restart with 173;
alter sequence sc_khb_srv.sq_com_bbs_cmnt restart with 68;
alter sequence sc_khb_srv.sq_com_code restart with 1322;
alter sequence sc_khb_srv.sq_com_crtfc_tmpr restart with 154;
alter sequence sc_khb_srv.sq_com_ctpv_cd restart with 18;
alter sequence sc_khb_srv.sq_com_device_info restart with 22;
alter sequence sc_khb_srv.sq_com_device_ntcn_mapng_info restart with 161;
alter sequence sc_khb_srv.sq_com_device_stng_info restart with 157;
alter sequence sc_khb_srv.sq_com_emd_li_cd restart with 24356;
alter sequence sc_khb_srv.sq_com_error_log restart with 5870;
alter sequence sc_khb_srv.sq_com_faq restart with 1;
alter sequence sc_khb_srv.sq_com_file restart with 1;
alter sequence sc_khb_srv.sq_com_file_mapng restart with 1;
alter sequence sc_khb_srv.sq_com_group restart with 5;
alter sequence sc_khb_srv.sq_com_group_author restart with 11;
alter sequence sc_khb_srv.sq_com_gtwy_svc restart with 470;
alter sequence sc_khb_srv.sq_com_gtwy_svc_author restart with 617;
alter sequence sc_khb_srv.sq_com_job_schdl_hstry restart with 639;
alter sequence sc_khb_srv.sq_com_job_schdl_info restart with 16;
alter sequence sc_khb_srv.sq_com_login_hist restart with 1590;
alter sequence sc_khb_srv.sq_com_menu restart with 76;
alter sequence sc_khb_srv.sq_com_menu_author restart with 78;
alter sequence sc_khb_srv.sq_com_notice restart with 3;
alter sequence sc_khb_srv.sq_com_ntcn_info restart with 113;
alter sequence sc_khb_srv.sq_com_push_meta_info restart with 27;
alter sequence sc_khb_srv.sq_com_qna restart with 1;
alter sequence sc_khb_srv.sq_com_recsroom restart with 1;
alter sequence sc_khb_srv.sq_com_rss_info restart with 64397;
alter sequence sc_khb_srv.sq_com_scrin restart with 127;
alter sequence sc_khb_srv.sq_com_scrin_author restart with 136;
alter sequence sc_khb_srv.sq_com_sgg_cd restart with 253;
alter sequence sc_khb_srv.sq_com_stplat_hist restart with 1;
alter sequence sc_khb_srv.sq_com_stplat_info restart with 1;
alter sequence sc_khb_srv.sq_com_stplat_mapng restart with 1;
alter sequence sc_khb_srv.sq_com_svc_ip_manage restart with 1;
alter sequence sc_khb_srv.sq_com_thema_info restart with 80;
alter sequence sc_khb_srv.sq_com_user restart with 73470;
alter sequence sc_khb_srv.sq_com_user_author restart with 1;
alter sequence sc_khb_srv.sq_com_user_group restart with 73106;
alter sequence sc_khb_srv.sq_com_user_ntcn_mapng_info restart with 109;
alter sequence sc_khb_srv.sq_hsmp_dtl_info restart with 222;
alter sequence sc_khb_srv.sq_hsmp_info restart with 10055181;
alter sequence sc_khb_srv.sq_itrst_atlfsl_info restart with 34431;
alter sequence sc_khb_srv.sq_lrea_office_info restart with 1601796;
alter sequence sc_khb_srv.sq_lrea_schdl_ntcn_info restart with 50;
alter sequence sc_khb_srv.sq_lrea_sns_url_info restart with 3;
alter sequence sc_khb_srv.sq_lrea_spclty_fld_info restart with 4;
alter sequence sc_khb_srv.sq_lttot_info restart with 1310;
alter sequence sc_khb_srv.sq_svc_bass_info restart with 3;
alter sequence sc_khb_srv.sq_user_atlfsl_img_info restart with 158443;
alter sequence sc_khb_srv.sq_user_atlfsl_info restart with 20906;
alter sequence sc_khb_srv.sq_user_atlfsl_preocupy_info restart with 23201;
alter sequence sc_khb_srv.sq_user_atlfsl_thema_info restart with 1;

-- 유저에게 시퀀스 권한 주기
DECLARE @user_name nvarchar(100) = 'us_khb_com'
SELECT 
  name
, 'grant update on sc_khb_srv.' + name + ' to ' + @user_name + ';' "시퀀스 권한 부여"
  FROM sys.sequences
 WHERE name NOT LIKE '%com%'
       AND 
       name NOT IN ('sq_atlfsl_batch_hstry', 'sq_svc_bass_info')
 ORDER BY 1;

grant update on sc_khb_srv.sq_atlfsl_bsc_info to us_khb_mptl;
grant update on sc_khb_srv.sq_atlfsl_cfr_fclt_info to us_khb_mptl;
grant update on sc_khb_srv.sq_atlfsl_cmrc_dtl_info to us_khb_mptl;
grant update on sc_khb_srv.sq_atlfsl_dlng_info to us_khb_mptl;
grant update on sc_khb_srv.sq_atlfsl_etc_dtl_info to us_khb_mptl;
grant update on sc_khb_srv.sq_atlfsl_etc_info to us_khb_mptl;
grant update on sc_khb_srv.sq_atlfsl_img_info to us_khb_mptl;
grant update on sc_khb_srv.sq_atlfsl_land_usg_info to us_khb_mptl;
grant update on sc_khb_srv.sq_atlfsl_reside_gnrl_dtl_info to us_khb_mptl;
grant update on sc_khb_srv.sq_atlfsl_reside_set_dtl_info to us_khb_mptl;
grant update on sc_khb_srv.sq_hsmp_dtl_info to us_khb_mptl;
grant update on sc_khb_srv.sq_hsmp_info to us_khb_mptl;
grant update on sc_khb_srv.sq_com_rss_info to us_khb_exif;
grant update on sc_khb_srv.sq_itrst_atlfsl_info to us_khb_mptl;
grant update on sc_khb_srv.sq_lrea_office_info to us_khb_mptl;
grant update on sc_khb_srv.sq_lttot_info to us_khb_mptl;
grant update on sc_khb_srv.sq_user_atlfsl_img_info to us_khb_mptl;
grant update on sc_khb_srv.sq_user_atlfsl_info to us_khb_mptl;
grant update on sc_khb_srv.sq_user_atlfsl_preocupy_info to us_khb_mptl;


-- alter 권한
GRANT ALTER ON sc_khb_srv.sq_com_user_ntcn_mapng_info TO us_khb_com;

-- 다른 유저에게 sq_com_error_log 권한 주기
grant update on sc_khb_srv.sq_com_error_log to us_khb_dev;
grant update on sc_khb_srv.sq_com_error_log to us_khb_agnt;
grant update on sc_khb_srv.sq_com_error_log to us_khb_exif;
grant update on sc_khb_srv.sq_com_error_log to us_khb_magnt;
grant update on sc_khb_srv.sq_com_error_log to us_khb_mptl;
grant update on sc_khb_srv.sq_com_error_log to us_khb_report;

-- 현재 시스템 시퀀스의 값 확인
SELECT
  name
, start_value
, INCREMENT
, minimum_value
, maximum_value
, current_value
  FROM sys.sequences
 ORDER BY 1;


-- 시퀀스 생성 쿼리문 스크립트 작성(161)
SELECT
  replace(name, 'sq_', 'tb_') "테이블명"
, name "시퀀스명"
, 'drop sequence ' + schema_name(schema_id) + '.' + name + ';' "시퀀스 삭제 쿼리문"
  FROM sys.sequences
 WHERE schema_id = 5
 ORDER BY 1;

-- 테이블이 없는 시퀀스 삭제
SELECT 
  name "시퀀스명"
, 'drop sequence ' + schema_name(schema_id) + '.' + name + ';' "시퀀스 삭제 쿼리문"
  FROM sys.sequences s1
 WHERE s1.name NOT IN (
                       SELECT s.name "seq_nm"
                         FROM information_schema.tables t
                              INNER join
                              sys.sequences s
                                  ON t.TABLE_NAME = replace(s.name, 'sq_', 'tb_')
                                     OR
                                     replace(t.TABLE_NAME, 'tb_', 'sq_') = s.name)
 ORDER BY 1;






















