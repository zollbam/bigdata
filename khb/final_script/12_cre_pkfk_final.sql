/*
작성 일자 : 230920
수정 일자 : 
작 성 자 : 조건영
작성 목적 : 테이블 comment 추가 하는 작업
*/


-- tb_atlfsl_bsc_info
alter table sc_khb_srv.tb_atlfsl_bsc_info add constraint FK_tb_atlfsl_bsc_info_tb_lrea_office_info_lrea_office_info_pk foreign key (lrea_office_info_pk) references sc_khb_srv.tb_lrea_office_info(lrea_office_info_pk);

-- tb_atlfsl_cfr_fclt_info
alter table sc_khb_srv.tb_atlfsl_cfr_fclt_info add constraint FK_tb_atlfsl_cfr_fclt_info_tb_atlfsl_bsc_info_atlfsl_bsc_info_pk foreign key (atlfsl_bsc_info_pk) references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

-- tb_atlfsl_dlng_info
alter table sc_khb_srv.tb_atlfsl_dlng_info add constraint FK_tb_atlfsl_dlng_info_tb_atlfsl_bsc_info_atlfsl_bsc_info_pk foreign key (atlfsl_bsc_info_pk) references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

-- tb_atlfsl_etc_info
alter table sc_khb_srv.tb_atlfsl_etc_info add constraint FK_tb_atlfsl_etc_info_tb_atlfsl_bsc_info_atlfsl_bsc_info_pk foreign key (atlfsl_bsc_info_pk) references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

-- tb_atlfsl_img_info
alter table sc_khb_srv.tb_atlfsl_img_info add constraint FK_tb_atlfsl_img_info_tb_atlfsl_bsc_info_atlfsl_bsc_info_pk foreign key (atlfsl_bsc_info_pk) references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

-- tb_atlfsl_inqry_info
alter table sc_khb_srv.tb_atlfsl_inqry_info add constraint FK_tb_atlfsl_inqry_info_tb_atlfsl_bsc_info_atlfsl_bsc_info_pk foreign key (atlfsl_bsc_info_pk) references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);
alter table sc_khb_srv.tb_atlfsl_inqry_info add constraint FK_tb_atlfsl_inqry_info_tb_com_user_user_no_pk foreign key (user_no_pk) references sc_khb_srv.tb_com_user(user_no_pk);

-- tb_atlfsl_land_usg_info
alter table sc_khb_srv.tb_atlfsl_land_usg_info add constraint FK_tb_atlfsl_land_usg_info_tb_atlfsl_bsc_info_atlfsl_bsc_info_pk foreign key (atlfsl_bsc_info_pk) references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);

-- tb_atlfsl_thema_info
alter table sc_khb_srv.tb_atlfsl_thema_info add constraint FK_tb_atlfsl_thema_info_tb_atlfsl_bsc_info_atlfsl_bsc_info_pk foreign key (atlfsl_bsc_info_pk) references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);
alter table sc_khb_srv.tb_atlfsl_thema_info add constraint FK_tb_atlfsl_thema_info_tb_com_thema_info_thema_info_pk foreign key (thema_info_pk) references sc_khb_srv.tb_com_thema_info(thema_info_pk);

-- tb_com_device_info
alter table sc_khb_srv.tb_com_device_info add constraint FK_tb_com_device_info_tb_com_user_user_no_pk foreign key (user_no_pk) references sc_khb_srv.tb_com_user(user_no_pk);

-- tb_com_device_ntcn_mapng_info
alter table sc_khb_srv.tb_com_device_ntcn_mapng_info add constraint FK_tb_com_device_ntcn_mapng_info_tb_com_device_info_device_info_pk foreign key (device_info_pk) references sc_khb_srv.tb_com_device_info(device_info_pk);
alter table sc_khb_srv.tb_com_device_ntcn_mapng_info add constraint FK_tb_com_device_ntcn_mapng_info_tb_com_ntcn_info_ntcn_info_pk foreign key (ntcn_info_pk) references sc_khb_srv.tb_com_ntcn_info(ntcn_info_pk);

-- tb_com_device_stng_info
alter table sc_khb_srv.tb_com_device_stng_info add constraint FK_tb_com_device_stng_info_tb_com_device_info_device_info_pk foreign key (device_info_pk) references sc_khb_srv.tb_com_device_info(device_info_pk);

-- tb_com_emd_li_cd
alter table sc_khb_srv.tb_com_emd_li_cd add constraint FK_tb_com_emd_li_cd_tb_com_ctpv_cd_ctpv_cd_pk foreign key (ctpv_cd_pk) references sc_khb_srv.tb_com_ctpv_cd(ctpv_cd_pk);
alter table sc_khb_srv.tb_com_emd_li_cd add constraint FK_tb_com_emd_li_cd_tb_com_sgg_cd_sgg_cd_pk foreign key (sgg_cd_pk) references sc_khb_srv.tb_com_sgg_cd(sgg_cd_pk);

-- tb_com_file
alter table sc_khb_srv.tb_com_file add constraint FK_tb_com_file_tb_com_file_mapng_file_no_pk foreign key (file_no_pk) references sc_khb_srv.tb_com_file_mapng(file_no_pk);

-- tb_com_file_mapng
alter table sc_khb_srv.tb_com_file_mapng add constraint FK_tb_com_file_mapng_tb_com_recsroom_recsroom_no_pk foreign key (recsroom_no_pk) references sc_khb_srv.tb_com_recsroom(recsroom_no_pk);
alter table sc_khb_srv.tb_com_file_mapng add constraint FK_tb_com_file_mapng_tb_com_user_user_no_pk foreign key (user_no_pk) references sc_khb_srv.tb_com_user(user_no_pk);

-- tb_com_group_author
alter table sc_khb_srv.tb_com_group_author add constraint FK_tb_com_group_author_tb_com_author_author_no_pk foreign key (author_no_pk) references sc_khb_srv.tb_com_author(author_no_pk);
alter table sc_khb_srv.tb_com_group_author add constraint FK_tb_com_group_author_tb_com_group_group_no_pk foreign key (group_no_pk) references sc_khb_srv.tb_com_group(group_no_pk);

-- tb_com_gtwy_svc_author
alter table sc_khb_srv.tb_com_gtwy_svc_author add constraint FK_tb_com_gtwy_svc_author_tb_com_author_author_no_pk foreign key (author_no_pk) references sc_khb_srv.tb_com_author(author_no_pk);
alter table sc_khb_srv.tb_com_gtwy_svc_author add constraint FK_tb_com_gtwy_svc_author_tb_com_gtwy_svc_gtwy_svc_pk foreign key (gtwy_svc_pk) references sc_khb_srv.tb_com_gtwy_svc(gtwy_svc_pk);

-- tb_com_job_schdl_hstry
alter table sc_khb_srv.tb_com_job_schdl_hstry add constraint fk_tb_com_job_schdl_hstry_tb_com_job_schdl_info foreign key (job_schdl_info_pk) references sc_khb_srv.tb_com_job_schdl_info(job_schdl_info_pk);

-- tb_com_menu
alter table sc_khb_srv.tb_com_menu add constraint FK_tb_com_menu_tb_com_scrin_scrin_no_pk foreign key (scrin_no_pk) references sc_khb_srv.tb_com_scrin(scrin_no_pk);

-- tb_com_menu_author
alter table sc_khb_srv.tb_com_menu_author add constraint FK_tb_com_menu_author_tb_com_author_author_no_pk foreign key (author_no_pk) references sc_khb_srv.tb_com_author(author_no_pk);
alter table sc_khb_srv.tb_com_menu_author add constraint FK_tb_com_menu_author_tb_com_menu_menu_no_pk foreign key (menu_no_pk) references sc_khb_srv.tb_com_menu(menu_no_pk);

-- tb_com_scrin_author
alter table sc_khb_srv.tb_com_scrin_author add constraint FK_tb_com_scrin_author_tb_com_author_author_no_pk foreign key (author_no_pk) references sc_khb_srv.tb_com_author(author_no_pk);
alter table sc_khb_srv.tb_com_scrin_author add constraint FK_tb_com_scrin_author_tb_com_scrin_scrin_no_pk foreign key (scrin_no_pk) references sc_khb_srv.tb_com_scrin(scrin_no_pk);

-- tb_com_sgg_cd
alter table sc_khb_srv.tb_com_sgg_cd add constraint FK_tb_com_sgg_cd_tb_com_ctpv_cd_ctpv_cd_pk foreign key (ctpv_cd_pk) references sc_khb_srv.tb_com_ctpv_cd(ctpv_cd_pk);

-- tb_com_stplat_hist
alter table sc_khb_srv.tb_com_stplat_hist add constraint FK_tb_com_stplat_hist_tb_com_stplat_info_com_stplat_info_pk foreign key (com_stplat_info_pk) references sc_khb_srv.tb_com_stplat_info(com_stplat_info_pk);

-- tb_com_stplat_mapng
alter table sc_khb_srv.tb_com_stplat_mapng add constraint FK_tb_com_stplat_mapng_tb_com_stplat_info_com_stplat_info_pk foreign key (com_stplat_info_pk) references sc_khb_srv.tb_com_stplat_info(com_stplat_info_pk);
alter table sc_khb_srv.tb_com_stplat_mapng add constraint FK_tb_com_stplat_mapng_tb_com_user_user_no_pk foreign key (user_no_pk) references sc_khb_srv.tb_com_user(user_no_pk);

-- tb_com_svc_ip_manage
alter table sc_khb_srv.tb_com_svc_ip_manage add constraint FK_tb_com_svc_ip_manage_tb_com_author_author_no_pk foreign key (author_no_pk) references sc_khb_srv.tb_com_author(author_no_pk);

-- tb_com_user_author
alter table sc_khb_srv.tb_com_user_author add constraint FK_tb_com_user_author_tb_com_author_author_no_pk foreign key (author_no_pk) references sc_khb_srv.tb_com_author(author_no_pk);
alter table sc_khb_srv.tb_com_user_author add constraint FK_tb_com_user_author_tb_com_user_user_no_pk foreign key (user_no_pk) references sc_khb_srv.tb_com_user(user_no_pk);

-- tb_com_user_group
alter table sc_khb_srv.tb_com_user_group add constraint FK_tb_com_user_group_tb_com_group_group_no_pk foreign key (group_no_pk) references sc_khb_srv.tb_com_group(group_no_pk);
alter table sc_khb_srv.tb_com_user_group add constraint FK_tb_com_user_group_tb_com_user_user_no_pk foreign key (user_no_pk) references sc_khb_srv.tb_com_user(user_no_pk);

-- tb_com_user_ntcn_mapng_info
alter table sc_khb_srv.tb_com_user_ntcn_mapng_info add constraint FK_tb_com_user_ntcn_mapng_info_tb_com_ntcn_info_ntcn_info_pk foreign key (ntcn_info_pk) references sc_khb_srv.tb_com_ntcn_info(ntcn_info_pk);
alter table sc_khb_srv.tb_com_user_ntcn_mapng_info add constraint FK_tb_com_user_ntcn_mapng_info_tb_com_user_user_no_pk foreign key (user_no_pk) references sc_khb_srv.tb_com_user(user_no_pk);

-- tb_hsmp_curprc_info
alter table sc_khb_srv.tb_hsmp_curprc_info add constraint FK_tb_hsmp_curprc_info_tb_hsmp_info_hsmp_info_pk foreign key (hsmp_info_pk) references sc_khb_srv.tb_hsmp_info(hsmp_info_pk);

-- tb_hsmp_dtl_info
alter table sc_khb_srv.tb_hsmp_dtl_info add constraint FK_tb_hsmp_dtl_info_tb_hsmp_info_hsmp_info_pk foreign key (hsmp_info_pk) references sc_khb_srv.tb_hsmp_info(hsmp_info_pk);

-- tb_itrst_atlfsl_info
alter table sc_khb_srv.tb_itrst_atlfsl_info add constraint FK_tb_itrst_atlfsl_info_tb_atlfsl_bsc_info_atlfsl_bsc_info_pk foreign key (atlfsl_bsc_info_pk) references sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);
alter table sc_khb_srv.tb_itrst_atlfsl_info add constraint FK_tb_itrst_atlfsl_info_tb_com_user_user_no_pk foreign key (user_no_pk) references sc_khb_srv.tb_com_user(user_no_pk);
alter table sc_khb_srv.tb_itrst_atlfsl_info add constraint FK_tb_itrst_atlfsl_info_tb_hsmp_info_hsmp_info_pk foreign key (hsmp_info_pk) references sc_khb_srv.tb_hsmp_info(hsmp_info_pk);
alter table sc_khb_srv.tb_itrst_atlfsl_info add constraint FK_tb_itrst_atlfsl_info_tb_lrea_office_info_lrea_office_info_pk foreign key (lrea_office_info_pk) references sc_khb_srv.tb_lrea_office_info(lrea_office_info_pk);

-- tb_lrea_itrst_lttot_info
alter table sc_khb_srv.tb_lrea_itrst_lttot_info add constraint FK_tb_lrea_itrst_lttot_info_tb_lrea_office_info_lrea_office_info_pk foreign key (lrea_office_info_pk) references sc_khb_srv.tb_lrea_office_info(lrea_office_info_pk);

-- tb_lrea_mntrng_hsmp_info
alter table sc_khb_srv.tb_lrea_mntrng_hsmp_info add constraint FK_tb_lrea_mntrng_hsmp_info_tb_hsmp_info_hsmp_info_pk foreign key (hsmp_info_pk) references sc_khb_srv.tb_hsmp_info(hsmp_info_pk);
alter table sc_khb_srv.tb_lrea_mntrng_hsmp_info add constraint FK_tb_lrea_mntrng_hsmp_info_tb_lrea_office_info_lrea_office_info_pk foreign key (lrea_office_info_pk) references sc_khb_srv.tb_lrea_office_info(lrea_office_info_pk);

-- tb_lrea_schdl_ntcn_info
alter table sc_khb_srv.tb_lrea_schdl_ntcn_info add constraint FK_tb_lrea_schdl_ntcn_info_tb_lrea_office_info_lrea_office_info_pk foreign key (lrea_office_info_pk) references sc_khb_srv.tb_lrea_office_info(lrea_office_info_pk);

-- tb_lrea_sns_url_info
alter table sc_khb_srv.tb_lrea_sns_url_info add constraint FK_tb_lrea_sns_url_info_tb_lrea_office_info_lrea_office_info_pk foreign key (lrea_office_info_pk) references sc_khb_srv.tb_lrea_office_info(lrea_office_info_pk)

-- tb_lrea_spclty_fld_info
alter table sc_khb_srv.tb_lrea_spclty_fld_info add constraint FK_tb_lrea_spclty_fld_info_tb_lrea_office_info_lrea_office_info_pk foreign key (lrea_office_info_pk) references sc_khb_srv.tb_lrea_office_info(lrea_office_info_pk);

-- tb_user_atlfsl_img_info
alter table sc_khb_srv.tb_user_atlfsl_img_info add constraint FK_tb_user_atlfsl_img_info_tb_user_atlfsl_info_user_atlfsl_info_pk foreign key (user_atlfsl_info_pk) references sc_khb_srv.tb_user_atlfsl_info(user_atlfsl_info_pk);

-- tb_user_atlfsl_info
alter table sc_khb_srv.tb_user_atlfsl_info add constraint FK_tb_user_atlfsl_info_tb_com_user_user_no_pk foreign key (user_no_pk) references sc_khb_srv.tb_com_user(user_no_pk);

-- tb_user_atlfsl_preocupy_info
alter table sc_khb_srv.tb_user_atlfsl_preocupy_info add constraint FK_tb_user_atlfsl_preocupy_info_tb_lrea_office_info_lrea_office_info_pk foreign key (lrea_office_info_pk) references sc_khb_srv.tb_lrea_office_info(lrea_office_info_pk);
alter table sc_khb_srv.tb_user_atlfsl_preocupy_info add constraint FK_tb_user_atlfsl_preocupy_info_tb_user_atlfsl_info_user_atlfsl_info_pk foreign key (user_atlfsl_info_pk) references sc_khb_srv.tb_user_atlfsl_info(user_atlfsl_info_pk);

-- tb_user_atlfsl_thema_info
alter table sc_khb_srv.tb_user_atlfsl_thema_info add constraint FK_tb_user_atlfsl_thema_info_tb_com_thema_info_thema_info_pk foreign key (thema_info_pk) references sc_khb_srv.tb_com_thema_info(thema_info_pk);
alter table sc_khb_srv.tb_user_atlfsl_thema_info add constraint FK_tb_user_atlfsl_thema_info_tb_user_atlfsl_info_user_atlfsl_info_pk foreign key (user_atlfsl_info_pk) references sc_khb_srv.tb_user_atlfsl_info(user_atlfsl_info_pk);












--------------------------------------------충돌 => 해결--------------------------------------------


alter table sc_khb_srv.tb_lrea_mntrng_hsmp_info
add constraint FK_tb_lrea_office_info_tb_lrea_mntrng_hsmp_info_lrea_office_info_pk
foreign key (lrea_office_info_pk)
references sc_khb_srv.tb_lrea_office_info(lrea_office_info_pk);

SELECT lrea_office_info_pk
  FROM sc_khb_srv.tb_lrea_mntrng_hsmp_info
EXCEPT
SELECT lrea_office_info_pk
  FROM sc_khb_srv.tb_lrea_office_info;

SELECT *
  FROM sc_khb_srv.tb_lrea_mntrng_hsmp_info
 WHERE lrea_office_info_pk = 1506505;
 
/*
1. lrea_office_info_pk이 1506505때문에 충돌 => 1개
2. tb_lrea_office_info테이블과 inner join해서 삽입 시 충돌X
*/


alter table sc_khb_srv.tb_lrea_mntrng_hsmp_info
add constraint FK_tb_hsmp_info_tb_lrea_mntrng_hsmp_info_hsmp_info_pk
foreign key (hsmp_info_pk)
references sc_khb_srv.tb_hsmp_info(hsmp_info_pk);


SELECT hsmp_info_pk
  FROM sc_khb_srv.tb_lrea_mntrng_hsmp_info
EXCEPT
SELECT hsmp_info_pk
  FROM sc_khb_srv.tb_hsmp_info;



/*
1. 충돌 개수 289개 
2. tb_hsmp_info inner join해서 삽입 시 충돌X
*/










