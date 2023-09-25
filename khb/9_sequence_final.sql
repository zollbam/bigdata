/*
작성 일자 : 230921
수정 일자 : 
작 성 자 : 조건영
작성 목적 : 시퀀스 생성 및 권한 부여
*/





-- 시퀀스 생성
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

CREATE SEQUENCE sc_khb_srv.sq_com_cnrs_info
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

CREATE SEQUENCE sc_khb_srv.sq_hsmp_curprc_info
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

CREATE SEQUENCE sc_khb_srv.sq_lrea_itrst_lttot_info
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999999999
    CACHE;

CREATE SEQUENCE sc_khb_srv.sq_lrea_mntrng_hsmp_info
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





-- 현재 시퀀스 값 확인
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
select 'tb_lrea_itrst_lttot_info' "table_name", max(lrea_itrst_lttot_info_pk) "max_value"
  from sc_khb_srv.tb_lrea_itrst_lttot_info
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




-- 현재 값에 맞게 업데이트
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
select 'tb_lrea_itrst_lttot_info' "table_name", max(lrea_itrst_lttot_info_pk) "max_value"
  from sc_khb_srv.tb_lrea_itrst_lttot_info
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


/*시퀀스 값 UPDATE*/
alter sequence sc_khb_srv.sq_atlfsl_bsc_info restart with 25068171;
alter sequence sc_khb_srv.sq_atlfsl_cfr_fclt_info restart with 25067188;
alter sequence sc_khb_srv.sq_atlfsl_dlng_info restart with 25067192;
alter sequence sc_khb_srv.sq_atlfsl_etc_info restart with 25067188;
alter sequence sc_khb_srv.sq_atlfsl_img_info restart with 972868;
alter sequence sc_khb_srv.sq_atlfsl_inqry_info restart with 1;
alter sequence sc_khb_srv.sq_atlfsl_land_usg_info restart with 25067188;
alter sequence sc_khb_srv.sq_atlfsl_thema_info restart with 170004;
alter sequence sc_khb_srv.sq_com_author restart with 5;
alter sequence sc_khb_srv.sq_com_banner_info restart with 1;
alter sequence sc_khb_srv.sq_com_cnrs_info restart with 1;
alter sequence sc_khb_srv.sq_com_code restart with 1265;
alter sequence sc_khb_srv.sq_com_crtfc_tmpr restart with 232;
alter sequence sc_khb_srv.sq_com_ctpv_cd restart with 18;
alter sequence sc_khb_srv.sq_com_device_info restart with 1;
alter sequence sc_khb_srv.sq_com_device_ntcn_mapng_info restart with 1;
alter sequence sc_khb_srv.sq_com_device_stng_info restart with 1;
alter sequence sc_khb_srv.sq_com_emd_li_cd restart with 24372;
alter sequence sc_khb_srv.sq_com_error_log restart with 1;
alter sequence sc_khb_srv.sq_com_faq restart with 1;
alter sequence sc_khb_srv.sq_com_file restart with 1;
alter sequence sc_khb_srv.sq_com_file_mapng restart with 1;
alter sequence sc_khb_srv.sq_com_group restart with 5;
alter sequence sc_khb_srv.sq_com_group_author restart with 11;
alter sequence sc_khb_srv.sq_com_gtwy_svc restart with 571;
alter sequence sc_khb_srv.sq_com_gtwy_svc_author restart with 764;
alter sequence sc_khb_srv.sq_com_job_schdl_hstry restart with 1;
alter sequence sc_khb_srv.sq_com_job_schdl_info restart with 39;
alter sequence sc_khb_srv.sq_com_login_hist restart with 1;
alter sequence sc_khb_srv.sq_com_menu restart with 79;
alter sequence sc_khb_srv.sq_com_menu_author restart with 81;
alter sequence sc_khb_srv.sq_com_notice restart with 1;
alter sequence sc_khb_srv.sq_com_ntcn_info restart with 1;
alter sequence sc_khb_srv.sq_com_push_meta_info restart with 27;
alter sequence sc_khb_srv.sq_com_qna restart with 1;
alter sequence sc_khb_srv.sq_com_recsroom restart with 1;
alter sequence sc_khb_srv.sq_com_rss_info restart with 74668;
alter sequence sc_khb_srv.sq_com_scrin restart with 146;
alter sequence sc_khb_srv.sq_com_scrin_author restart with 160;
alter sequence sc_khb_srv.sq_com_sgg_cd restart with 253;
alter sequence sc_khb_srv.sq_com_stplat_hist restart with 1;
alter sequence sc_khb_srv.sq_com_stplat_info restart with 1;
alter sequence sc_khb_srv.sq_com_stplat_mapng restart with 1;
alter sequence sc_khb_srv.sq_com_svc_ip_manage restart with 1;
alter sequence sc_khb_srv.sq_com_thema_info restart with 80;
alter sequence sc_khb_srv.sq_com_user restart with 70962;
alter sequence sc_khb_srv.sq_com_user_author restart with 1;
alter sequence sc_khb_srv.sq_com_user_group restart with 70962;
alter sequence sc_khb_srv.sq_com_user_ntcn_mapng_info restart with 1;
alter sequence sc_khb_srv.sq_hsmp_curprc_info restart with 12369025;
alter sequence sc_khb_srv.sq_hsmp_dtl_info restart with 222;
alter sequence sc_khb_srv.sq_hsmp_info restart with 10055560;
alter sequence sc_khb_srv.sq_itrst_atlfsl_info restart with 36611;
alter sequence sc_khb_srv.sq_lrea_itrst_lttot_info restart with 1;
alter sequence sc_khb_srv.sq_lrea_mntrng_hsmp_info restart with 14406;
alter sequence sc_khb_srv.sq_lrea_office_info restart with 1604747;
alter sequence sc_khb_srv.sq_lrea_schdl_ntcn_info restart with 1;
alter sequence sc_khb_srv.sq_lrea_sns_url_info restart with 1;
alter sequence sc_khb_srv.sq_lrea_spclty_fld_info restart with 1;
alter sequence sc_khb_srv.sq_lttot_info restart with 1310;
alter sequence sc_khb_srv.sq_svc_bass_info restart with 1;
alter sequence sc_khb_srv.sq_user_atlfsl_img_info restart with 163098;
alter sequence sc_khb_srv.sq_user_atlfsl_info restart with 21869;
alter sequence sc_khb_srv.sq_user_atlfsl_preocupy_info restart with 23504;
alter sequence sc_khb_srv.sq_user_atlfsl_thema_info restart with 4;





-- 시퀀스 권한 부여
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
grant ALTER, UPDATE on sc_khb_srv.sq_com_device_ntcn_mapng_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_device_stng_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_emd_li_cd to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_error_log to us_khb_agnt;
grant UPDATE on sc_khb_srv.sq_com_error_log to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_error_log to us_khb_dev;
grant UPDATE on sc_khb_srv.sq_com_error_log to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_com_error_log to us_khb_magnt;
grant UPDATE on sc_khb_srv.sq_com_error_log to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_com_error_log to us_khb_report;
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
grant ALTER, UPDATE on sc_khb_srv.sq_com_user_ntcn_mapng_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_hsmp_curprc_info to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_hsmp_dtl_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_hsmp_dtl_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_hsmp_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_hsmp_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_itrst_atlfsl_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_itrst_atlfsl_info to us_khb_exif;
grant UPDATE on sc_khb_srv.sq_itrst_atlfsl_info to us_khb_mptl;
grant UPDATE on sc_khb_srv.sq_lrea_itrst_lttot_info to us_khb_magnt;
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










