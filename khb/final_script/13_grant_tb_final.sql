/*
작성 일시: 230919
수정 일시: 
작 성 자 : 조건영
작성 목적 : 테이블 및 사용자 타입 권한 부여
*/




-- 테이블 권한 부여 => 133개
/*tb_atlfsl_bsc_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_bsc_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_atlfsl_bsc_info to us_khb_mptl;
grant SELECT on sc_khb_srv.tb_atlfsl_bsc_info to us_khb_srch;

/*tb_atlfsl_cfr_fclt_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_cfr_fclt_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_atlfsl_cfr_fclt_info to us_khb_mptl;

/*tb_atlfsl_dlng_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_dlng_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_atlfsl_dlng_info to us_khb_mptl;

/*tb_atlfsl_etc_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_etc_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_atlfsl_etc_info to us_khb_mptl;

/*tb_atlfsl_img_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_img_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_atlfsl_img_info to us_khb_mptl;

/*tb_atlfsl_inqry_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_inqry_info to us_khb_mptl;

/*tb_atlfsl_land_usg_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_land_usg_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_atlfsl_land_usg_info to us_khb_mptl;

/*tb_atlfsl_thema_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_thema_info to us_khb_exif;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_thema_info to us_khb_mptl;

/*tb_com_author*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_author to us_khb_com;

/*tb_com_banner_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_banner_info to us_khb_com;

/*tb_com_cnrs_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_cnrs_info to us_khb_com;

/*tb_com_code*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_code to us_khb_com;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_code to us_khb_exif;
grant SELECT on sc_khb_srv.tb_com_code to us_khb_mptl;
grant SELECT on sc_khb_srv.tb_com_code to us_khb_srch;

/*tb_com_crtfc_tmpr*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_crtfc_tmpr to us_khb_com;

/*tb_com_ctpv_cd*/
grant SELECT on sc_khb_srv.tb_com_ctpv_cd to us_khb_com;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_ctpv_cd to us_khb_exif;
grant SELECT on sc_khb_srv.tb_com_ctpv_cd to us_khb_mptl;
grant SELECT on sc_khb_srv.tb_com_ctpv_cd to us_khb_srch;

/*tb_com_device_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_device_info to us_khb_com;

/*tb_com_device_ntcn_mapng_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_device_ntcn_mapng_info to us_khb_com;

/*tb_com_device_stng_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_device_stng_info to us_khb_com;

/*tb_com_emd_li_cd*/
grant SELECT on sc_khb_srv.tb_com_emd_li_cd to us_khb_com;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_emd_li_cd to us_khb_exif;
grant SELECT on sc_khb_srv.tb_com_emd_li_cd to us_khb_mptl;
grant SELECT on sc_khb_srv.tb_com_emd_li_cd to us_khb_srch;

/*tb_com_error_log*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_error_log to us_khb_agnt;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_error_log to us_khb_com;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_error_log to us_khb_exif;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_error_log to us_khb_magnt;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_error_log to us_khb_mptl;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_error_log to us_khb_report;

/*tb_com_faq*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_faq to us_khb_com;

/*tb_com_file*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_file to us_khb_com;

/*tb_com_file_mapng*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_file_mapng to us_khb_com;

/*tb_com_group*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_group to us_khb_com;

/*tb_com_group_author*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_group_author to us_khb_com;

/*tb_com_gtwy_svc*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_gtwy_svc to us_khb_com;

/*tb_com_gtwy_svc_author*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_gtwy_svc_author to us_khb_com;

/*tb_com_job_schdl_hstry*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_job_schdl_hstry to us_khb_com;
grant INSERT on sc_khb_srv.tb_com_job_schdl_hstry to us_khb_exif;

/*tb_com_job_schdl_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_job_schdl_info to us_khb_com;
grant SELECT on sc_khb_srv.tb_com_job_schdl_info to us_khb_exif;

/*tb_com_login_hist*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_login_hist to us_khb_com;

/*tb_com_menu*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_menu to us_khb_com;

/*tb_com_menu_author*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_menu_author to us_khb_com;

/*tb_com_notice*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_notice to us_khb_com;

/*tb_com_ntcn_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_ntcn_info to us_khb_com;

/*tb_com_push_meta_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_push_meta_info to us_khb_com;

/*tb_com_qna*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_qna to us_khb_com;

/*tb_com_recsroom*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_recsroom to us_khb_com;

/*tb_com_rss_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_rss_info to us_khb_com;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_rss_info to us_khb_exif;

/*tb_com_scrin*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_scrin to us_khb_com;

/*tb_com_scrin_author*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_scrin_author to us_khb_com;

/*tb_com_sgg_cd*/
grant SELECT on sc_khb_srv.tb_com_sgg_cd to us_khb_com;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_sgg_cd to us_khb_exif;
grant SELECT on sc_khb_srv.tb_com_sgg_cd to us_khb_mptl;
grant SELECT on sc_khb_srv.tb_com_sgg_cd to us_khb_srch;

/*tb_com_stplat_hist*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_stplat_hist to us_khb_com;

/*tb_com_stplat_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_stplat_info to us_khb_com;

/*tb_com_stplat_mapng*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_stplat_mapng to us_khb_com;

/*tb_com_svc_ip_manage*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_svc_ip_manage to us_khb_com;

/*tb_com_thema_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_thema_info to us_khb_com;
grant INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_thema_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_com_thema_info to us_khb_mptl;

/*tb_com_user*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_user to us_khb_com;

/*tb_com_user_author*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_user_author to us_khb_com;

/*tb_com_user_group*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_user_group to us_khb_com;

/*tb_com_user_ntcn_mapng_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_user_ntcn_mapng_info to us_khb_com;

/*tb_hsmp_curprc_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_hsmp_curprc_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_hsmp_curprc_info to us_khb_mptl;

/*tb_hsmp_dtl_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_hsmp_dtl_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_hsmp_dtl_info to us_khb_mptl;

/*tb_hsmp_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_hsmp_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_hsmp_info to us_khb_mptl;
grant SELECT on sc_khb_srv.tb_hsmp_info to us_khb_srch;

/*tb_itrst_atlfsl_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_itrst_atlfsl_info to us_khb_mptl;

/*tb_link_apt_lttot_cmpet_rt_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_link_apt_lttot_cmpet_rt_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_link_apt_lttot_cmpet_rt_info to us_khb_mptl;

/*tb_link_apt_lttot_house_ty_dtl_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_link_apt_lttot_house_ty_dtl_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_link_apt_lttot_house_ty_dtl_info to us_khb_mptl;

/*tb_link_apt_lttot_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_link_apt_lttot_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_link_apt_lttot_info to us_khb_mptl;

/*tb_link_apt_nthg_rank_remndr_hh_lttot_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_info to us_khb_mptl;

/*tb_link_apt_nthg_rank_remndr_hh_lttot_ty_dtl_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_ty_dtl_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_ty_dtl_info to us_khb_mptl;

/*tb_link_hsmp_area_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_link_hsmp_area_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_link_hsmp_area_info to us_khb_mptl;

/*tb_link_hsmp_bsc_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_link_hsmp_bsc_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_link_hsmp_bsc_info to us_khb_mptl;

/*tb_link_hsmp_managect_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_link_hsmp_managect_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_link_hsmp_managect_info to us_khb_mptl;

/*tb_link_ofctl_cty_prvate_rent_lttot_cmpet_rt_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_cmpet_rt_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_cmpet_rt_info to us_khb_mptl;

/*tb_link_ofctl_cty_prvate_rent_lttot_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_info to us_khb_mptl;

/*tb_link_ofctl_cty_prvate_rent_lttot_ty_dtl_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_ty_dtl_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_ty_dtl_info to us_khb_mptl;

/*tb_link_public_sprt_prvate_rent_lttot_cmpet_rt_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_link_public_sprt_prvate_rent_lttot_cmpet_rt_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_link_public_sprt_prvate_rent_lttot_cmpet_rt_info to us_khb_mptl;

/*tb_link_remndr_hh_lttot_cmpet_rt_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_link_remndr_hh_lttot_cmpet_rt_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_link_remndr_hh_lttot_cmpet_rt_info to us_khb_mptl;

/*tb_link_rtrcn_re_sply_lttot_cmpet_rt_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_link_rtrcn_re_sply_lttot_cmpet_rt_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_link_rtrcn_re_sply_lttot_cmpet_rt_info to us_khb_mptl;

/*tb_link_subway_statn_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_link_subway_statn_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_link_subway_statn_info to us_khb_mptl;
grant SELECT on sc_khb_srv.tb_link_subway_statn_info to us_khb_srch;

/*tb_lrea_itrst_lttot_info*/
GRANT DELETE,INSERT,SELECT,UPDATE ON sc_khb_srv.tb_lrea_itrst_lttot_info TO us_khb_magnt;

/*tb_lrea_mntrng_hsmp_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_lrea_mntrng_hsmp_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_lrea_mntrng_hsmp_info to us_khb_mptl;

/*tb_lrea_office_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_lrea_office_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_lrea_office_info to us_khb_mptl;
grant SELECT on sc_khb_srv.tb_lrea_office_info to us_khb_srch;

/*tb_lrea_schdl_ntcn_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_lrea_schdl_ntcn_info to us_khb_exif;

/*tb_lrea_sns_url_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_lrea_sns_url_info to us_khb_magnt;

/*tb_lrea_spclty_fld_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_lrea_spclty_fld_info to us_khb_magnt;

/*tb_lttot_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_lttot_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_lttot_info to us_khb_mptl;
grant SELECT on sc_khb_srv.tb_lttot_info to us_khb_srch;

/*tb_svc_bass_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_svc_bass_info to us_khb_com;

/*tb_user_atlfsl_img_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_user_atlfsl_img_info to us_khb_mptl;

/*tb_user_atlfsl_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_user_atlfsl_info to us_khb_mptl;

/*tb_user_atlfsl_preocupy_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_user_atlfsl_preocupy_info to us_khb_mptl;

/*tb_user_atlfsl_thema_info*/
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_user_atlfsl_thema_info to us_khb_mptl;











