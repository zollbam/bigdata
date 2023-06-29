/*
시퀀스를 생성 및 업데이트
23년 6월 29일 
162번에서 작업한 파일
*/

-- 시퀀스 생성 쿼리문 스크립트 작성(161)
SELECT *
  FROM sys.sequences
 ORDER BY 1;

/*
CREATE SEQUENCE sc_khb_srv.sq_svc_bass_info
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
*/

SELECT TABLE_NAME,
  'CREATE SEQUENCE ' + TABLE_SCHEMA + '.sq' + SUBSTRING(TABLE_NAME, 3,LEN(TABLE_NAME)) + char(13) +
  '    START WITH 1' + char(13) + 
  '    INCREMENT BY 1' + char(13) +
  '    MINVALUE 1' + char(13) +
  '    MAXVALUE 999999999' + char(13) +
  '    CACHE;' + char(13) "시퀀스 생성"
  FROM information_schema.tables
 WHERE TABLE_SCHEMA = 'sc_khb_srv'
 ORDER BY 1;

-- 시퀀스 생성 쿼리문(162)
CREATE SEQUENCE sc_khb_srv.sq_atlfsl_batch_hstry
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_bsc_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_cfr_fclt_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_cmrc_dtl_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_dlng_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_etc_dtl_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_etc_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_img_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_land_usg_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_reside_gnrl_dtl_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_atlfsl_reside_set_dtl_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_author
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_banner_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_bbs
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_bbs_cmnt
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_code
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_crtfc_tmpr
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_ctpv_cd
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_emd_li_cd
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_error_log
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_faq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_file
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_file_mapng
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_group
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_group_author
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_gtwy_svc
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_gtwy_svc_author
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_job_schdl_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_login_hist
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_menu
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_menu_author
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_notice
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_qna
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_recsroom
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_scrin
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_scrin_author
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_sgg_cd
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_stplat_hist
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_stplat_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_stplat_mapng
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_svc_ip_manage
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_thema_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_user
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_user_author
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_com_user_group
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_hsmp_dtl_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_hsmp_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_itrst_atlfsl_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_lrea_office_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_lttot_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_svc_bass_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_user_atlfsl_img_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_user_atlfsl_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_user_atlfsl_preocupy_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999
    CACHE;


-- 시퀀스 값 업데이트(161)
SELECT name, current_value
  FROM sys.sequences
 ORDER BY 1;

-- 각 테이블 pk의 최대값 구하기 스크립트 작성(161)
SELECT object_name(object_id),
  'select max(' + name + ') from sc_khb_srv.' + object_name(object_id) + ';'
  FROM sys.columns
 WHERE object_name(object_id) IN (SELECT table_name FROM information_schema.tables WHERE table_schema='sc_khb_srv')
       AND
       column_id = 1
 ORDER BY 1;

select max(atlfsl_batch_hstry_pk) from sc_khb_srv.tb_atlfsl_batch_hstry; -- null
select max(atlfsl_bsc_info_pk) from sc_khb_srv.tb_atlfsl_bsc_info; -- 20849889
select max(atlfsl_cfr_fclt_info_pk) from sc_khb_srv.tb_atlfsl_cfr_fclt_info; -- 20848921
select max(atlfsl_cmrc_dtl_info_pk) from sc_khb_srv.tb_atlfsl_cmrc_dtl_info; -- 3098700
select max(atlfsl_dlng_info_pk) from sc_khb_srv.tb_atlfsl_dlng_info; -- 20848925
select max(atlfsl_etc_dtl_info_pk) from sc_khb_srv.tb_atlfsl_etc_dtl_info; -- 3760091
select max(atlfsl_etc_info_pk) from sc_khb_srv.tb_atlfsl_etc_info; -- 20848921
select max(atlfsl_img_info_pk) from sc_khb_srv.tb_atlfsl_img_info; -- 836226
select max(atlfsl_land_usg_info_pk) from sc_khb_srv.tb_atlfsl_land_usg_info; -- 20848921
select max(atlfsl_reside_gnrl_dtl_info_pk) from sc_khb_srv.tb_atlfsl_reside_gnrl_dtl_info; -- 4154099
select max(atlfsl_reside_set_dtl_info_pk) from sc_khb_srv.tb_atlfsl_reside_set_dtl_info; -- 9840743
select max(author_no_pk) from sc_khb_srv.tb_com_author; -- 4
select max(banner_info_pk) from sc_khb_srv.tb_com_banner_info; -- 13
select max(bbs_pk) from sc_khb_srv.tb_com_bbs; -- 172
select max(bbs_cmnt_pk) from sc_khb_srv.tb_com_bbs_cmnt; -- 67
select max(code_pk) from sc_khb_srv.tb_com_code; -- 1165
select max(crtfc_pk) from sc_khb_srv.tb_com_crtfc_tmpr; -- 10
select max(ctpv_cd_pk) from sc_khb_srv.tb_com_ctpv_cd; -- 17
select max(emd_li_cd_pk) from sc_khb_srv.tb_com_emd_li_cd; -- 24371
select max(error_log_pk) from sc_khb_srv.tb_com_error_log; -- 1067
select max(faq_no_pk) from sc_khb_srv.tb_com_faq; -- null
select max(file_no_pk) from sc_khb_srv.tb_com_file; -- null
select max(file_no_pk) from sc_khb_srv.tb_com_file_mapng; -- null
select max(group_no_pk) from sc_khb_srv.tb_com_group; -- 6
select max(com_group_author_pk) from sc_khb_srv.tb_com_group_author; -- 10
select max(gtwy_svc_pk) from sc_khb_srv.tb_com_gtwy_svc; -- 155
select max(com_gtwy_svc_author_pk) from sc_khb_srv.tb_com_gtwy_svc_author; -- 229
select max(job_schdl_info_pk) from sc_khb_srv.tb_com_job_schdl_info; -- 12
select max(login_hist_pk) from sc_khb_srv.tb_com_login_hist; -- 308
select max(menu_no_pk) from sc_khb_srv.tb_com_menu; -- 24
select max(com_menu_author_pk) from sc_khb_srv.tb_com_menu_author; -- 38
select max(notice_no_pk) from sc_khb_srv.tb_com_notice; -- 2
select max(qna_no_pk) from sc_khb_srv.tb_com_qna; -- null
select max(recsroom_no_pk) from sc_khb_srv.tb_com_recsroom; -- null
select max(scrin_no_pk) from sc_khb_srv.tb_com_scrin; -- 54
select max(com_scrin_author_pk) from sc_khb_srv.tb_com_scrin_author; -- 55
select max(sgg_cd_pk) from sc_khb_srv.tb_com_sgg_cd; -- 252
select max(com_stplat_hist_pk) from sc_khb_srv.tb_com_stplat_hist; -- null
select max(com_stplat_info_pk) from sc_khb_srv.tb_com_stplat_info; -- null
select max(com_stplat_mapng_pk) from sc_khb_srv.tb_com_stplat_mapng; -- null
select max(ip_manage_pk) from sc_khb_srv.tb_com_svc_ip_manage; -- null
select max(thema_info_pk) from sc_khb_srv.tb_com_thema_info; -- 79
select max(user_no_pk) from sc_khb_srv.tb_com_user; -- 67363
select max(user_author_pk) from sc_khb_srv.tb_com_user_author; -- null
select max(com_user_group_pk) from sc_khb_srv.tb_com_user_group; -- 54722
select max(hsmp_dtl_info_pk) from sc_khb_srv.tb_hsmp_dtl_info; -- 221
select max(hsmp_info_pk) from sc_khb_srv.tb_hsmp_info; -- 10055180
select max(itrst_atlfsl_info_pk) from sc_khb_srv.tb_itrst_atlfsl_info; -- 34386
select max(lrea_office_info_pk) from sc_khb_srv.tb_lrea_office_info; -- 1601795
select max(lttot_info_pk) from sc_khb_srv.tb_lttot_info; -- 1309
select max(svc_pk) from sc_khb_srv.tb_svc_bass_info; -- 2 
select max(user_atlfsl_img_info_pk) from sc_khb_srv.tb_user_atlfsl_img_info; -- 158442
select max(user_atlfsl_info_pk) from sc_khb_srv.tb_user_atlfsl_info; -- 20905
select max(user_mapng_info_pk) from sc_khb_srv.tb_user_atlfsl_preocupy_info; -- 23200
$data = iconv("euc-kr","utf-8",$data);
-- 시퀀스 업데이트(162)
/*
ALTER SEQUENCE sc_khb_srv.sq_com_author RESTART WITH 5;
*/
SELECT name, current_value
  FROM sys.sequences
 ORDER BY 1;

ALTER SEQUENCE sc_khb_srv.sq_atlfsl_batch_hstry RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_atlfsl_bsc_info RESTART WITH 20849890;
ALTER SEQUENCE sc_khb_srv.sq_atlfsl_cfr_fclt_info RESTART WITH 20848922;
ALTER SEQUENCE sc_khb_srv.sq_atlfsl_cmrc_dtl_info RESTART WITH 3098701;
ALTER SEQUENCE sc_khb_srv.sq_atlfsl_dlng_info RESTART WITH 20848926;
ALTER SEQUENCE sc_khb_srv.sq_atlfsl_etc_dtl_info RESTART WITH 3760092;
ALTER SEQUENCE sc_khb_srv.sq_atlfsl_etc_info RESTART WITH 20848922;
ALTER SEQUENCE sc_khb_srv.sq_atlfsl_img_info RESTART WITH 836227;
ALTER SEQUENCE sc_khb_srv.sq_atlfsl_land_usg_info RESTART WITH 20848922;
ALTER SEQUENCE sc_khb_srv.sq_atlfsl_reside_gnrl_dtl_info RESTART WITH 4154100;
ALTER SEQUENCE sc_khb_srv.sq_atlfsl_reside_set_dtl_info RESTART WITH 9840744;
ALTER SEQUENCE sc_khb_srv.sq_com_author RESTART WITH 5;
ALTER SEQUENCE sc_khb_srv.sq_com_banner_info RESTART WITH 20;
ALTER SEQUENCE sc_khb_srv.sq_com_bbs RESTART WITH 173;
ALTER SEQUENCE sc_khb_srv.sq_com_bbs_cmnt RESTART WITH 68;
ALTER SEQUENCE sc_khb_srv.sq_com_code RESTART WITH 1166;
ALTER SEQUENCE sc_khb_srv.sq_com_crtfc_tmpr RESTART WITH 11;
ALTER SEQUENCE sc_khb_srv.sq_com_ctpv_cd RESTART WITH 18;
ALTER SEQUENCE sc_khb_srv.sq_com_emd_li_cd RESTART WITH 24372;
ALTER SEQUENCE sc_khb_srv.sq_com_error_log RESTART WITH 1068;
ALTER SEQUENCE sc_khb_srv.sq_com_faq RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_file RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_file_mapng RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_group RESTART WITH 7;
ALTER SEQUENCE sc_khb_srv.sq_com_group_author RESTART WITH 11;
ALTER SEQUENCE sc_khb_srv.sq_com_gtwy_svc RESTART WITH 156;
ALTER SEQUENCE sc_khb_srv.sq_com_gtwy_svc_author RESTART WITH 230;
ALTER SEQUENCE sc_khb_srv.sq_com_job_schdl_info RESTART WITH 13;
ALTER SEQUENCE sc_khb_srv.sq_com_login_hist RESTART WITH 309;
ALTER SEQUENCE sc_khb_srv.sq_com_menu RESTART WITH 25;
ALTER SEQUENCE sc_khb_srv.sq_com_menu_author RESTART WITH 39;
ALTER SEQUENCE sc_khb_srv.sq_com_notice RESTART WITH 3;
ALTER SEQUENCE sc_khb_srv.sq_com_qna RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_recsroom RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_scrin RESTART WITH 55;
ALTER SEQUENCE sc_khb_srv.sq_com_scrin_author RESTART WITH 56;
ALTER SEQUENCE sc_khb_srv.sq_com_sgg_cd RESTART WITH 253;
ALTER SEQUENCE sc_khb_srv.sq_com_stplat_hist RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_stplat_info RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_stplat_mapng RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_svc_ip_manage RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_thema_info RESTART WITH 80;
ALTER SEQUENCE sc_khb_srv.sq_com_user RESTART WITH 67364;
ALTER SEQUENCE sc_khb_srv.sq_com_user_author RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_user_group RESTART WITH 67010;
ALTER SEQUENCE sc_khb_srv.sq_hsmp_dtl_info RESTART WITH 222;
ALTER SEQUENCE sc_khb_srv.sq_hsmp_info RESTART WITH 10055181;
ALTER SEQUENCE sc_khb_srv.sq_itrst_atlfsl_info RESTART WITH 34387;
ALTER SEQUENCE sc_khb_srv.sq_lrea_office_info RESTART WITH 1601796;
ALTER SEQUENCE sc_khb_srv.sq_lttot_info RESTART WITH 1310;
ALTER SEQUENCE sc_khb_srv.sq_svc_bass_info RESTART WITH 3;
ALTER SEQUENCE sc_khb_srv.sq_user_atlfsl_img_info RESTART WITH 158443;
ALTER SEQUENCE sc_khb_srv.sq_user_atlfsl_info RESTART WITH 20906;
ALTER SEQUENCE sc_khb_srv.sq_user_atlfsl_preocupy_info RESTART WITH 23201;

-- com유저에게 시퀀스 권한(161)
/*
grant UPDATE on sc_khb_srv.sq_com_author to us_khb_com;
*/
SELECT name "시퀀스명",
  'grant update on sc_khb_srv.' + name + ' to us_khb_com;' "com에게 시퀀스 권한 부여"
  FROM sys.sequences
 ORDER BY 1;

grant update on sc_khb_srv.sq_atlfsl_batch_hstry to us_khb_com;
grant update on sc_khb_srv.sq_atlfsl_bsc_info to us_khb_com;
grant update on sc_khb_srv.sq_atlfsl_cfr_fclt_info to us_khb_com;
grant update on sc_khb_srv.sq_atlfsl_cmrc_dtl_info to us_khb_com;
grant update on sc_khb_srv.sq_atlfsl_dlng_info to us_khb_com;
grant update on sc_khb_srv.sq_atlfsl_etc_dtl_info to us_khb_com;
grant update on sc_khb_srv.sq_atlfsl_etc_info to us_khb_com;
grant update on sc_khb_srv.sq_atlfsl_img_info to us_khb_com;
grant update on sc_khb_srv.sq_atlfsl_land_usg_info to us_khb_com;
grant update on sc_khb_srv.sq_atlfsl_reside_gnrl_dtl_info to us_khb_com;
grant update on sc_khb_srv.sq_atlfsl_reside_set_dtl_info to us_khb_com;
grant update on sc_khb_srv.sq_com_author to us_khb_com;
grant update on sc_khb_srv.sq_com_banner_info to us_khb_com;
grant update on sc_khb_srv.sq_com_bbs to us_khb_com;
grant update on sc_khb_srv.sq_com_bbs_cmnt to us_khb_com;
grant update on sc_khb_srv.sq_com_code to us_khb_com;
grant update on sc_khb_srv.sq_com_crtfc_tmpr to us_khb_com;
grant update on sc_khb_srv.sq_com_ctpv_cd to us_khb_com;
grant update on sc_khb_srv.sq_com_emd_li_cd to us_khb_com;
grant update on sc_khb_srv.sq_com_error_log to us_khb_com;
grant update on sc_khb_srv.sq_com_faq to us_khb_com;
grant update on sc_khb_srv.sq_com_file to us_khb_com;
grant update on sc_khb_srv.sq_com_file_mapng to us_khb_com;
grant update on sc_khb_srv.sq_com_group to us_khb_com;
grant update on sc_khb_srv.sq_com_group_author to us_khb_com;
grant update on sc_khb_srv.sq_com_gtwy_svc to us_khb_com;
grant update on sc_khb_srv.sq_com_gtwy_svc_author to us_khb_com;
grant update on sc_khb_srv.sq_com_job_schdl_info to us_khb_com;
grant update on sc_khb_srv.sq_com_login_hist to us_khb_com;
grant update on sc_khb_srv.sq_com_menu to us_khb_com;
grant update on sc_khb_srv.sq_com_menu_author to us_khb_com;
grant update on sc_khb_srv.sq_com_notice to us_khb_com;
grant update on sc_khb_srv.sq_com_qna to us_khb_com;
grant update on sc_khb_srv.sq_com_recsroom to us_khb_com;
grant update on sc_khb_srv.sq_com_scrin to us_khb_com;
grant update on sc_khb_srv.sq_com_scrin_author to us_khb_com;
grant update on sc_khb_srv.sq_com_sgg_cd to us_khb_com;
grant update on sc_khb_srv.sq_com_stplat_hist to us_khb_com;
grant update on sc_khb_srv.sq_com_stplat_info to us_khb_com;
grant update on sc_khb_srv.sq_com_stplat_mapng to us_khb_com;
grant update on sc_khb_srv.sq_com_svc_ip_manage to us_khb_com;
grant update on sc_khb_srv.sq_com_thema_info to us_khb_com;
grant update on sc_khb_srv.sq_com_user to us_khb_com;
grant update on sc_khb_srv.sq_com_user_author to us_khb_com;
grant update on sc_khb_srv.sq_com_user_group to us_khb_com;
grant update on sc_khb_srv.sq_hsmp_dtl_info to us_khb_com;
grant update on sc_khb_srv.sq_hsmp_info to us_khb_com;
grant update on sc_khb_srv.sq_itrst_atlfsl_info to us_khb_com;
grant update on sc_khb_srv.sq_lrea_office_info to us_khb_com;
grant update on sc_khb_srv.sq_lttot_info to us_khb_com;
grant update on sc_khb_srv.sq_svc_bass_info to us_khb_com;
grant update on sc_khb_srv.sq_user_atlfsl_img_info to us_khb_com;
grant update on sc_khb_srv.sq_user_atlfsl_info to us_khb_com;
grant update on sc_khb_srv.sq_user_atlfsl_preocupy_info to us_khb_com;

-- 다른 유저에게 sq_com_error_log 권한 주기
grant update on sc_khb_srv.sq_com_error_log to us_khb_dev;
grant update on sc_khb_srv.sq_com_error_log to us_khb_agnt;
grant update on sc_khb_srv.sq_com_error_log to us_khb_exif;
grant update on sc_khb_srv.sq_com_error_log to us_khb_magnt;
grant update on sc_khb_srv.sq_com_error_log to us_khb_mptl;
grant update on sc_khb_srv.sq_com_error_log to us_khb_report;


















