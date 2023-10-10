/*
시퀀스를 생성 및 업데이트
시작 일시: 23-06-28
수정 일시: 230816
작 성 자: 조건영
작성 목적 : 시퀀스의 생성 및 권한 부여
사용 DB : mssql 2016
*/

-- 시퀀스 생성 쿼리문 스크립트 작성(161)
SELECT SEQUENCE_NAME
     , 'CREATE SEQUENCE ' + SEQUENCE_SCHEMA  + '.' + SEQUENCE_NAME + char(13) +
       '    START WITH 1' + char(13) + 
       '    INCREMENT BY 1' + char(13) +
       '    MINVALUE 1' + char(13) +
       '    MAXVALUE 999999999999999999' + char(13) +
       '    CACHE;' + char(13) "시퀀스 생성"
  FROM information_schema.sequences
 ORDER BY SEQUENCE_NAME;

-- 시퀀스 생성 쿼리문



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
   AND object_name(object_id) LIKE 'tb:_%' ESCAPE ':'
 ORDER BY 1;






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
           AND TABLE_NAME LIKE 'tb:_%' ESCAPE ':'
           AND TABLE_NAME NOT IN ('tb_atlfsl_batch_hstry'
                                , 'tb_com_bbs'
                                , 'tb_com_bbs_cmnt'
                                , 'tb_com_user_update'
                                , 'tb_tmp','tb_tmp_2'
                                , 'tb_tmp_3'
                                , 'tb_tmp_4'
                                , 'tb_tmp_5'
                                , 'tb_tmp_sec'
                                , 'tb_tmp_t'
                                , 'tb_jado_index'
                                , 'tb_cs_mamul'
                                , 'tb_lrea_update'
                                , 'tb_atlfsl_bsc_update')
		 ORDER BY TABLE_NAME
		 FOR xml PATH('')), 1, 1, '') + char(10) +
  ')' + char(10) +
  'SELECT * from max_value;';

/*위의 쿼리결과 복사붙여 넣기 한 스크립트*/
with max_value as (
select 'tb_atlfsl_bsc_info' "table_name", max(atlfsl_bsc_info_pk) "max_value"
  from sc_khb_srv.tb_atlfsl_bsc_info
 union 
select 'tb_atlfsl_bsc_update' "table_name", max(asoc_atlfsl_no) "max_value"
  from sc_khb_srv.tb_atlfsl_bsc_update
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
select 'tb_com_cnrs_info' "table_name", max(cnrs_info_pk) "max_value"
  from sc_khb_srv.tb_com_cnrs_info
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
select 'tb_hsmp_curprc_info' "table_name", max(hsmp_curprc_info_pk) "max_value"
  from sc_khb_srv.tb_hsmp_curprc_info
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
select 'tb_lrea_mntrng_hsmp_info' "table_name", max(lrea_mntrng_hsmp_info_pk) "max_value"
  from sc_khb_srv.tb_lrea_mntrng_hsmp_info
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
           AND TABLE_NAME LIKE 'tb:_%' ESCAPE ':'
           AND TABLE_NAME NOT IN ('tb_atlfsl_batch_hstry'
                                , 'sq_atlfsl_bsc_update'
                                , 'tb_com_bbs'
                                , 'tb_com_bbs_cmnt'
                                , 'tb_com_user_update'
                                , 'tb_tmp','tb_tmp_2'
                                , 'tb_tmp_3'
                                , 'tb_tmp_4'
                                , 'tb_tmp_5'
                                , 'tb_tmp_sec'
                                , 'tb_tmp_t'
                                , 'tb_jado_index'
                                , 'tb_cs_mamul'
                                , 'tb_lrea_update')
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
select 'tb_com_cnrs_info' "table_name", max(cnrs_info_pk) "max_value"
  from sc_khb_srv.tb_com_cnrs_info
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
select 'tb_hsmp_curprc_info' "table_name", max(hsmp_curprc_info_pk) "max_value"
  from sc_khb_srv.tb_hsmp_curprc_info
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
select 'tb_lrea_mntrng_hsmp_info' "table_name", max(lrea_mntrng_hsmp_info_pk) "max_value"
  from sc_khb_srv.tb_lrea_mntrng_hsmp_info
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


alter sequence sc_khb_srv.sq_atlfsl_bsc_info restart with 20849890;
alter sequence sc_khb_srv.sq_atlfsl_cfr_fclt_info restart with 20848922;
alter sequence sc_khb_srv.sq_atlfsl_dlng_info restart with 20848926;
alter sequence sc_khb_srv.sq_atlfsl_etc_info restart with 20848922;
alter sequence sc_khb_srv.sq_atlfsl_img_info restart with 831815;
alter sequence sc_khb_srv.sq_atlfsl_inqry_info restart with 1;
alter sequence sc_khb_srv.sq_atlfsl_land_usg_info restart with 20848922;
alter sequence sc_khb_srv.sq_atlfsl_thema_info restart with 155376;
alter sequence sc_khb_srv.sq_com_author restart with 5;
alter sequence sc_khb_srv.sq_com_banner_info restart with 23;
alter sequence sc_khb_srv.sq_com_cnrs_info restart with 27;
alter sequence sc_khb_srv.sq_com_code restart with 1613;
alter sequence sc_khb_srv.sq_com_crtfc_tmpr restart with 232;
alter sequence sc_khb_srv.sq_com_ctpv_cd restart with 18;
alter sequence sc_khb_srv.sq_com_device_info restart with 35;
alter sequence sc_khb_srv.sq_com_device_ntcn_mapng_info restart with 191;
alter sequence sc_khb_srv.sq_com_device_stng_info restart with 290;
alter sequence sc_khb_srv.sq_com_emd_li_cd restart with 24356;
alter sequence sc_khb_srv.sq_com_error_log restart with 15740;
alter sequence sc_khb_srv.sq_com_faq restart with 1;
alter sequence sc_khb_srv.sq_com_file restart with 1;
alter sequence sc_khb_srv.sq_com_file_mapng restart with 1;
alter sequence sc_khb_srv.sq_com_group restart with 5;
alter sequence sc_khb_srv.sq_com_group_author restart with 11;
alter sequence sc_khb_srv.sq_com_gtwy_svc restart with 568;
alter sequence sc_khb_srv.sq_com_gtwy_svc_author restart with 761;
alter sequence sc_khb_srv.sq_com_job_schdl_hstry restart with 16151;
alter sequence sc_khb_srv.sq_com_job_schdl_info restart with 38;
alter sequence sc_khb_srv.sq_com_login_hist restart with 2621;
alter sequence sc_khb_srv.sq_com_menu restart with 79;
alter sequence sc_khb_srv.sq_com_menu_author restart with 81;
alter sequence sc_khb_srv.sq_com_notice restart with 3;
alter sequence sc_khb_srv.sq_com_ntcn_info restart with 214;
alter sequence sc_khb_srv.sq_com_push_meta_info restart with 27;
alter sequence sc_khb_srv.sq_com_qna restart with 1;
alter sequence sc_khb_srv.sq_com_recsroom restart with 1;
alter sequence sc_khb_srv.sq_com_rss_info restart with 74594;
alter sequence sc_khb_srv.sq_com_scrin restart with 145;
alter sequence sc_khb_srv.sq_com_scrin_author restart with 159;
alter sequence sc_khb_srv.sq_com_sgg_cd restart with 253;
alter sequence sc_khb_srv.sq_com_stplat_hist restart with 1;
alter sequence sc_khb_srv.sq_com_stplat_info restart with 1;
alter sequence sc_khb_srv.sq_com_stplat_mapng restart with 1;
alter sequence sc_khb_srv.sq_com_svc_ip_manage restart with 1;
alter sequence sc_khb_srv.sq_com_thema_info restart with 80;
alter sequence sc_khb_srv.sq_com_user restart with 73486;
alter sequence sc_khb_srv.sq_com_user_author restart with 1;
alter sequence sc_khb_srv.sq_com_user_group restart with 73122;
alter sequence sc_khb_srv.sq_com_user_ntcn_mapng_info restart with 169;
alter sequence sc_khb_srv.sq_hsmp_curprc_info restart with 3027702;
alter sequence sc_khb_srv.sq_hsmp_dtl_info restart with 222;
alter sequence sc_khb_srv.sq_hsmp_info restart with 10055181;
alter sequence sc_khb_srv.sq_itrst_atlfsl_info restart with 34434;
alter sequence sc_khb_srv.sq_lrea_mntrng_hsmp_info restart with 13943;
alter sequence sc_khb_srv.sq_lrea_office_info restart with 1601796;
alter sequence sc_khb_srv.sq_lrea_schdl_ntcn_info restart with 62;
alter sequence sc_khb_srv.sq_lrea_sns_url_info restart with 120;
alter sequence sc_khb_srv.sq_lrea_spclty_fld_info restart with 179;
alter sequence sc_khb_srv.sq_lttot_info restart with 1310;
alter sequence sc_khb_srv.sq_svc_bass_info restart with 3;
alter sequence sc_khb_srv.sq_user_atlfsl_img_info restart with 158443;
alter sequence sc_khb_srv.sq_user_atlfsl_info restart with 20909;
alter sequence sc_khb_srv.sq_user_atlfsl_preocupy_info restart with 23249;
alter sequence sc_khb_srv.sq_user_atlfsl_thema_info restart with 4;

-- 유저에게 시퀀스 권한 주기
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
  ' to ' + user_name(grantee_principal_id) + ';' "시퀀스 권한 부여 쿼리"
  FROM sys.DATABASE_permissions dp
 WHERE class_desc != 'DATABASE' 
       AND 
       grantee_principal_id != 0
       AND 
       object_name(major_id) = ANY(SELECT name FROM sys.sequences)
 GROUP BY class_desc, major_id, grantee_principal_id
 ORDER BY 2,3;


-- update 권한
grant UPDATE on sc_khb_srv.sq_atlfsl_bsc_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_atlfsl_bsc_info to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_atlfsl_bsc_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_atlfsl_cfr_fclt_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_atlfsl_cfr_fclt_info to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_atlfsl_cfr_fclt_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_atlfsl_dlng_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_atlfsl_dlng_info to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_atlfsl_dlng_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_atlfsl_etc_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_atlfsl_etc_info to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_atlfsl_etc_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_atlfsl_img_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_atlfsl_img_info to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_atlfsl_img_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_atlfsl_inqry_info to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_atlfsl_inqry_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_atlfsl_land_usg_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_atlfsl_land_usg_info to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_atlfsl_land_usg_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_atlfsl_thema_info to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_atlfsl_thema_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_com_author to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_banner_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_cnrs_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_code to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_code to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_com_crtfc_tmpr to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_ctpv_cd to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_device_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_device_stng_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_emd_li_cd to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_faq to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_file to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_file_mapng to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_group to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_group_author to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_gtwy_svc to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_gtwy_svc_author to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_job_schdl_hstry to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_job_schdl_hstry to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_com_job_schdl_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_login_hist to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_menu to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_menu_author to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_notice to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_ntcn_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_push_meta_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_qna to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_recsroom to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_rss_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_rss_info to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_com_scrin to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_scrin_author to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_sgg_cd to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_stplat_hist to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_stplat_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_stplat_mapng to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_svc_ip_manage to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_thema_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_user to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_user_author to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_user_group to us_khb_com;
grant UPDATE on sc_khb_srv.sq_hsmp_curprc_info to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_hsmp_dtl_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_hsmp_dtl_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_hsmp_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_hsmp_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_itrst_atlfsl_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_itrst_atlfsl_info to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_itrst_atlfsl_info to us_khb_mptl;
grant update on sc_khb_srv.sq_lrea_itrst_lttot_info to us_khb_magnt;
grant UPDATE on sc_khb_srv.sq_lrea_mntrng_hsmp_info to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_lrea_office_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_lrea_office_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_lrea_schdl_ntcn_info to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_lrea_schdl_ntcn_info to us_khb_magnt;
grant UPDATE on sc_khb_srv.sq_lrea_sns_url_info to us_khb_magnt;
grant UPDATE on sc_khb_srv.sq_lrea_spclty_fld_info to us_khb_magnt;
grant UPDATE on sc_khb_srv.sq_lttot_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_lttot_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_svc_bass_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_user_atlfsl_img_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_user_atlfsl_img_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_user_atlfsl_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_user_atlfsl_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_user_atlfsl_preocupy_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_user_atlfsl_preocupy_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_user_atlfsl_thema_info to us_khb_mptl;


-- alter 권한
grant ALTER, UPDATE on sc_khb_srv.sq_com_device_ntcn_mapng_info to us_khb_com;
grant ALTER, UPDATE on sc_khb_srv.sq_com_user_ntcn_mapng_info to us_khb_com;


-- 다른 유저에게 sq_com_error_log 권한 주기
grant UPDATE on sc_khb_srv.sq_com_error_log to us_khb_agnt;
grant UPDATE on sc_khb_srv.sq_com_error_log to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_error_log to us_khb_dev;
grant UPDATE on sc_khb_srv.sq_com_error_log to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_com_error_log to us_khb_magnt;
grant UPDATE on sc_khb_srv.sq_com_error_log to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_com_error_log to us_khb_report;


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


-- 시퀀스 삭제 쿼리문 스크립트 작성(161)
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























