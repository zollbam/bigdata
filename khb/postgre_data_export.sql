/*
작 성 일 : 230706
수 정 일 : 230810
작 성 자 : 조 건 영
사용 DB : postgresql , 192.168.0.5, 3524번
사용 스키마 : sc_appd_srv
작성 목적 : mssql로 이관을 위한 postgre테이블 데이터 txt 파일로 만들기
*/


-- 테이블별 txt파일을 만들기 위한 쿼리 생성
SELECT
  table_schema
, table_name
, E'select \nconcat_ws(''||'',\n' ||
  string_agg(concat('case when ',column_name, ' is null then '''' else ', column_name, '::varchar(4000) end'), E',\n') ||
  E')\n  from ' ||
  table_name || ';' "txt파일 생성을 위한 쿼리"
  FROM information_schema.COLUMNS
 WHERE table_schema = 'sc_appd_srv'
--       AND 
--       table_name IN ('tb_apply_apt_lttot_info_cmpetrt', 
--                      'tb_apply_apt_lttot_info_detail',
--                      'tb_apply_apt_lttot_info_house_ty_detail',
--                      'tb_apply_apt_nthg_rank_remndr_hshld_lttot_info_detail',
--                      'tb_apply_apt_nthg_rank_remndr_hshld_lttot_info_house_ty_det', 
--                      'tb_apply_cancl_re_suply_lttot_info_cmpetrt',
--                      'tb_apply_ofctl_cty_prvate_rent_lttot_house_ty_info_detail',
--                      'tb_apply_ofctl_cty_prvate_rent_lttot_info_cmpetrt',
--                      'tb_apply_ofctl_cty_prvate_rent_lttot_info_detail',
--                      'tb_apply_public_sport_prvate_rent_lttot_info_cmpetrt',
--                      'tb_apply_remndr_hshld_lttot_info_cmpetrt',
--                      'tb_k_apt_hsmp_ar_info'
--                     )
 GROUP BY table_schema, table_name
HAVING table_name = 'tb_apply_ofctl_cty_prvate_rent_lttot_info_detail'
 ORDER BY 2;
/*
해당 쿼리는 데이터를 뽑아내는 스크립트로
결과를 txt파일로 저장 시켜 엔터를 한번 치고
테이블 명으로 파일을 저장 시켜 161/162번에 파일을 전송하자~~~
 => 엔터를 치지 않으면 마지막 행이 이관이 안됨
*/





-- postgre => tb_apply_apt_lttot_info_cmpetrt
-- mssql => tb_link_apt_lttot_cmpet_rt_info
select 
concat_ws('||',
case when house_manage_no is null then '' else house_manage_no::varchar(4000) end,
case when pblanc_no is null then '' else pblanc_no::varchar(4000) end,
case when model_no is null then '' else model_no::varchar(4000) end,
case when house_ty_nm is null then '' else house_ty_nm::varchar(4000) end,
case when suply_hshld_co is null then '' else suply_hshld_co::varchar(4000) end,
case when rank is null then '' else rank::varchar(4000) end,
case when reside_code is null then '' else reside_code::varchar(4000) end,
case when reside_code_nm is null then '' else reside_code_nm::varchar(4000) end,
case when rcept_co is null then '' else rcept_co::varchar(4000) end,
case when cmpet_rt_cn is null then '' else cmpet_rt_cn::varchar(4000) end,
case when lwet_przwin_score_cn is null then '' else lwet_przwin_score_cn::varchar(4000) end,
case when top_przwin_score_cn is null then '' else top_przwin_score_cn::varchar(4000) end,
case when avrg_przwin_score_cn is null then '' else avrg_przwin_score_cn::varchar(4000) end)
  from tb_apply_apt_lttot_info_cmpetrt; -- 7853 행





-- postgre => tb_apply_apt_lttot_info_house_ty_detail
-- mssql => tb_link_apt_lttot_house_ty_dtl_info
select 
concat_ws('||',
case when house_manage_no is null then '' else house_manage_no::varchar(4000) end,
case when pblanc_no is null then '' else pblanc_no::varchar(4000) end,
case when model_no is null then '' else model_no::varchar(4000) end,
case when house_ty is null then '' else house_ty::varchar(4000) end,
case when suply_ar is null then '' else suply_ar::varchar(4000) end,
case when gnrl_suply_hshld_co is null then '' else gnrl_suply_hshld_co::varchar(4000) end,
case when specl_suply_hshld_co is null then '' else specl_suply_hshld_co::varchar(4000) end,
case when specl_suply_mnychgagu_hshld_co is null then '' else specl_suply_mnychgagu_hshld_co::varchar(4000) end,
case when specl_suply_mrrg_mrd_hshld_co is null then '' else specl_suply_mrrg_mrd_hshld_co::varchar(4000) end,
case when specl_suply_lfe_frst_hshld_co is null then '' else specl_suply_lfe_frst_hshld_co::varchar(4000) end,
case when specl_suply_odsn_parnts_suport_hshld_co is null then '' else specl_suply_odsn_parnts_suport_hshld_co::varchar(4000) end,
case when specl_suply_instt_recomend_hshld_co is null then '' else specl_suply_instt_recomend_hshld_co::varchar(4000) end,
case when specl_suply_etc_hshld_co is null then '' else specl_suply_etc_hshld_co::varchar(4000) end,
case when specl_suply_before_instt_hshld_co is null then '' else specl_suply_before_instt_hshld_co::varchar(4000) end,
case when suply_lttot_top_amount is null then '' else suply_lttot_top_amount::varchar(4000) end)
  from tb_apply_apt_lttot_info_house_ty_detail; -- 8412 행





-- postgre => tb_apply_apt_lttot_info_detail
-- mssql => tb_link_apt_lttot_info
select 
concat_ws('||',
case when house_manage_no is null then '' else house_manage_no::varchar(4000) end,
case when pblanc_no is null then '' else pblanc_no::varchar(4000) end,
case when house_nm is null then '' else house_nm::varchar(4000) end,
case when house_se_code is null then '' else house_se_code::varchar(4000) end,
case when housese_code_nm is null then '' else housese_code_nm::varchar(4000) end,
case when house_detail_se_code is null then '' else house_detail_se_code::varchar(4000) end,
case when house_detail_se_code_nm is null then '' else house_detail_se_code_nm::varchar(4000) end,
case when lttot_se_code is null then '' else lttot_se_code::varchar(4000) end,
case when lttot_se_code_nm is null then '' else lttot_se_code_nm::varchar(4000) end,
case when suply_area_code is null then '' else suply_area_code::varchar(4000) end,
case when suply_area_nm is null then '' else suply_area_nm::varchar(4000) end,
case when suply_lc_zip is null then '' else suply_lc_zip::varchar(4000) end,
case when suply_lc_nm is null then '' else suply_lc_nm::varchar(4000) end,
case when suply_scale_co is null then '' else suply_scale_co::varchar(4000) end,
case when rcrit_pblanc_de is null then '' else rcrit_pblanc_de::varchar(4000) end,
case when subscrpt_rcept_begin_de is null then '' else subscrpt_rcept_begin_de::varchar(4000) end,
case when subscrpt_rcept_end_de is null then '' else subscrpt_rcept_end_de::varchar(4000) end,
case when specl_suply_rcept_begin_de is null then '' else specl_suply_rcept_begin_de::varchar(4000) end,
case when specl_suply_rcept_end_de is null then '' else specl_suply_rcept_end_de::varchar(4000) end,
case when onerank_crrspnd_area_rcept_de is null then '' else onerank_crrspnd_area_rcept_de::varchar(4000) end,
case when onerank_gg_area_rcept_de is null then '' else onerank_gg_area_rcept_de::varchar(4000) end,
case when onerank_etc_area_rcept_de is null then '' else onerank_etc_area_rcept_de::varchar(4000) end,
case when tworank_crrspnd_area_rcept_de is null then '' else tworank_crrspnd_area_rcept_de::varchar(4000) end,
case when tworank_gg_area_rcept_de is null then '' else tworank_gg_area_rcept_de::varchar(4000) end,
case when tworank_etc_area_rcept_de is null then '' else tworank_etc_area_rcept_de::varchar(4000) end,
case when przwner_presnatn_de is null then '' else przwner_presnatn_de::varchar(4000) end,
case when cntrct_begin_de is null then '' else cntrct_begin_de::varchar(4000) end,
case when cntrct_end_de is null then '' else cntrct_end_de::varchar(4000) end,
case when hmpg_adres is null then '' else hmpg_adres::varchar(4000) end,
case when cnstrc_entrps_cnstrctprofs_nm is null then '' else cnstrc_entrps_cnstrctprofs_nm::varchar(4000) end,
case when inqry_offic_telno is null then '' else inqry_offic_telno::varchar(4000) end,
case when bsns_mby_opertnprofs_nm is null then '' else bsns_mby_opertnprofs_nm::varchar(4000) end,
case when mvn_prearnge_mt is null then '' else mvn_prearnge_mt::varchar(4000) end,
case when speclt_kwacolumn_earth_at is null then '' else speclt_kwacolumn_earth_at::varchar(4000) end,
case when mdat_target_area_at is null then '' else mdat_target_area_at::varchar(4000) end,
case when lttotpc_uplmt_at is null then '' else lttotpc_uplmt_at::varchar(4000) end,
case when imprmn_bsns_at is null then '' else imprmn_bsns_at::varchar(4000) end,
case when public_house_earth_at is null then '' else public_house_earth_at::varchar(4000) end,
case when lrscl_bldlnd_devlop_earth_at is null then '' else lrscl_bldlnd_devlop_earth_at::varchar(4000) end,
case when npln_prvopr_public_house_earth_at is null then '' else npln_prvopr_public_house_earth_at::varchar(4000) end,
case when lttot_info_url is null then '' else lttot_info_url::varchar(4000) END,
'',
'',
'',
'',
'',
'',
'')
  from tb_apply_apt_lttot_info_detail; -- 88 행





-- postgre => tb_apply_apt_nthg_rank_remndr_hshld_lttot_info_detail
-- mssql => tb_link_apt_nthg_rank_remndr_hh_lttot_info
select 
concat_ws('||',
case when house_manage_no is null then '' else house_manage_no::varchar(4000) end,
case when pblanc_no is null then '' else pblanc_no::varchar(4000) end,
case when house_nm is null then '' else house_nm::varchar(4000) end,
case when house_se_code is null then '' else house_se_code::varchar(4000) end,
case when house_se_code_nm is null then '' else house_se_code_nm::varchar(4000) end,
case when suply_lc_zip is null then '' else suply_lc_zip::varchar(4000) end,
case when suply_lc_nm is null then '' else suply_lc_nm::varchar(4000) end,
case when suply_scale_co is null then '' else suply_scale_co::varchar(4000) end,
case when rcrit_pblanc_de is null then '' else rcrit_pblanc_de::varchar(4000) end,
case when subscrpt_rcept_begin_de is null then '' else subscrpt_rcept_begin_de::varchar(4000) end,
case when subscrpt_rcept_end_de is null then '' else subscrpt_rcept_end_de::varchar(4000) end,
case when specl_suply_rcept_begin_de is null then '' else specl_suply_rcept_begin_de::varchar(4000) end,
case when specl_suply_rcept_end_de is null then '' else specl_suply_rcept_end_de::varchar(4000) end,
case when gnrl_suply_rcept_begin_de is null then '' else gnrl_suply_rcept_begin_de::varchar(4000) end,
case when gnrl_suply_rcept_end_de is null then '' else gnrl_suply_rcept_end_de::varchar(4000) end,
case when przwner_presnatn_de is null then '' else przwner_presnatn_de::varchar(4000) end,
case when cntrct_begin_de is null then '' else cntrct_begin_de::varchar(4000) end,
case when cntrct_end_de is null then '' else cntrct_end_de::varchar(4000) end,
case when hmpg_url is null then '' else hmpg_url::varchar(4000) end,
case when bsns_mby_opertnprofs_nm is null then '' else bsns_mby_opertnprofs_nm::varchar(4000) end,
case when inqry_offic_telno is null then '' else inqry_offic_telno::varchar(4000) end,
case when mvn_prearnge_mt is null then '' else mvn_prearnge_mt::varchar(4000) end,
case when lttot_info_url is null then '' else lttot_info_url::varchar(4000) END,
'',
'',
'',
'',
'',
'',
'')
  from tb_apply_apt_nthg_rank_remndr_hshld_lttot_info_detail; -- 59 행





-- postgre => tb_apply_apt_nthg_rank_remndr_hshld_lttot_info_house_ty_det
-- mssql => tb_link_apt_nthg_rank_remndr_hh_lttot_ty_dtl_info
select 
concat_ws('||',
case when house_manage_no is null then '' else house_manage_no::varchar(4000) end,
case when pblanc_no is null then '' else pblanc_no::varchar(4000) end,
case when model_no is null then '' else model_no::varchar(4000) end,
case when model_ty_nm is null then '' else model_ty_nm::varchar(4000) end,
case when suply_ar is null then '' else suply_ar::varchar(4000) end,
case when gnrl_suply_hshld_co is null then '' else gnrl_suply_hshld_co::varchar(4000) end,
case when specl_suply_hshld_co is null then '' else specl_suply_hshld_co::varchar(4000) end,
case when suply_lttot_top_amount is null then '' else suply_lttot_top_amount::varchar(4000) end)
  from tb_apply_apt_nthg_rank_remndr_hshld_lttot_info_house_ty_det; -- 2218 행





-- postgre => tb_k_apt_hsmp_ar_info
-- mssql => tb_link_hsmp_area_info
select 
concat_ws('||',
case when hsmp_code is null then '' else hsmp_code::varchar(4000) end,
case when hsmp_nm is null then '' else hsmp_nm::varchar(4000) end,
case when atpt_nm is null then '' else atpt_nm::varchar(4000) end,
case when signgu_nm is null then '' else signgu_nm::varchar(4000) end,
case when eupmyeon_nm is null then '' else eupmyeon_nm::varchar(4000) end,
case when dongli_nm is null then '' else dongli_nm::varchar(4000) end,
case when dong_co is null then '' else dong_co::varchar(4000) end,
case when totar is null then '' else totar::varchar(4000) end,
case when managect_levy_ar is null then '' else managect_levy_ar::varchar(4000) end,
case when reside_dvr_ar is null then '' else reside_dvr_ar::varchar(4000) end,
case when dvr_ar is null then '' else dvr_ar::varchar(4000) end,
case when hshld_co is null then '' else hshld_co::varchar(4000) end,
case when bildregstr_totar is null then '' else bildregstr_totar::varchar(4000) end)
  from tb_k_apt_hsmp_ar_info; -- 80320 행


select 
case when hsmp_code is null then '' else hsmp_code::varchar(4000) end,
case when hsmp_nm is null then '' else hsmp_nm::varchar(4000) end,
case when atpt_nm is null then '' else atpt_nm::varchar(4000) end,
case when signgu_nm is null then '' else signgu_nm::varchar(4000) end,
case when eupmyeon_nm is null then '' else eupmyeon_nm::varchar(4000) end,
case when dongli_nm is null then '' else dongli_nm::varchar(4000) end,
case when dong_co is null then '' else dong_co::varchar(4000) end,
case when totar is null then '' else totar::varchar(4000) end,
case when managect_levy_ar is null then '' else managect_levy_ar::varchar(4000) end,
case when reside_dvr_ar is null then '' else reside_dvr_ar::varchar(4000) end,
case when dvr_ar is null then '' else dvr_ar::varchar(4000) end,
case when hshld_co is null then '' else hshld_co::varchar(4000) end,
case when bildregstr_totar is null then '' else bildregstr_totar::varchar(4000) end
  from tb_k_apt_hsmp_ar_info; -- 80320 행

-- postgre => tb_k_apt_hsmp_bass_info
--          , tb_rn_adres_buld
--          , tb_rn_spce_buld 
-- mssql => tb_link_hsmp_bsc_info
select 
concat_ws('||',
case when tkahbi.hsmp_code is null then '' else tkahbi.hsmp_code::varchar(4000) end,
case when tkahbi.hsmp_nm is null then '' else tkahbi.hsmp_nm::varchar(4000) end,
case when tkahbi.atpt_nm is null then '' else tkahbi.atpt_nm::varchar(4000) end,
case when tkahbi.signgu_nm is null then '' else tkahbi.signgu_nm::varchar(4000) end,
case when tkahbi.eupmyeon_nm is null then '' else tkahbi.eupmyeon_nm::varchar(4000) end,
case when tkahbi.dongli_nm is null then '' else tkahbi.dongli_nm::varchar(4000) end,
case when tkahbi.hsmp_cl_nm is null then '' else tkahbi.hsmp_cl_nm::varchar(4000) end,
case when tkahbi.legaldong_adres is null then '' else tkahbi.legaldong_adres::varchar(4000) end,
case when tkahbi.rn_adres is null then '' else tkahbi.rn_adres::varchar(4000) end,
case when tkahbi.lttot_stle_nm is null then '' else tkahbi.lttot_stle_nm::varchar(4000) end,
case when tkahbi.use_confm_de is null then '' else tkahbi.use_confm_de::varchar(4000) end,
case when tkahbi.dong_co is null then '' else tkahbi.dong_co::varchar(4000) end,
case when tkahbi.hshld_co is null then '' else tkahbi.hshld_co::varchar(4000) end,
case when tkahbi.manage_mthd_nm is null then '' else tkahbi.manage_mthd_nm::varchar(4000) end,
case when tkahbi.heat_mthd_nm is null then '' else tkahbi.heat_mthd_nm::varchar(4000) end,
case when tkahbi.crrdpr_ty_nm is null then '' else tkahbi.crrdpr_ty_nm::varchar(4000) end,
case when tkahbi.cnstrctprofs_nm is null then '' else tkahbi.cnstrctprofs_nm::varchar(4000) end,
case when tkahbi.opertnprofs_nm is null then '' else tkahbi.opertnprofs_nm::varchar(4000) end,
case when tkahbi.housemgbsman_nm is null then '' else tkahbi.housemgbsman_nm::varchar(4000) end,
case when tkahbi.gnrl_manage_mthd_nm is null then '' else tkahbi.gnrl_manage_mthd_nm::varchar(4000) end,
case when tkahbi.gnrl_manage_nmpr_co is null then '' else tkahbi.gnrl_manage_nmpr_co::varchar(4000) end,
case when tkahbi.expens_manage_mthd_nm is null then '' else tkahbi.expens_manage_mthd_nm::varchar(4000) end,
case when tkahbi.expens_manage_nmpr_co is null then '' else tkahbi.expens_manage_nmpr_co::varchar(4000) end,
case when tkahbi.expens_manage_cntrct_entrps_nm is null then '' else tkahbi.expens_manage_cntrct_entrps_nm::varchar(4000) end,
case when tkahbi.cln_manage_mthd_nm is null then '' else tkahbi.cln_manage_mthd_nm::varchar(4000) end,
case when tkahbi.cln_manage_nmpr_co is null then '' else tkahbi.cln_manage_nmpr_co::varchar(4000) end,
case when tkahbi.fdwater_process_mth_nm is null then '' else tkahbi.fdwater_process_mth_nm::varchar(4000) end,
case when tkahbi.dsnf_manage_mthd_nm is null then '' else tkahbi.dsnf_manage_mthd_nm::varchar(4000) end,
case when tkahbi.fyer_dsnf_co is null then '' else tkahbi.fyer_dsnf_co::varchar(4000) end,
case when tkahbi.dsnf_mth_nm is null then '' else tkahbi.dsnf_mth_nm::varchar(4000) end,
case when tkahbi.buld_strct_nm is null then '' else tkahbi.buld_strct_nm::varchar(4000) end,
case when tkahbi.elcty_cobfe_cpcty is null then '' else tkahbi.elcty_cobfe_cpcty::varchar(4000) end,
case when tkahbi.hshld_elcty_cntrct_mthd_nm is null then '' else tkahbi.hshld_elcty_cntrct_mthd_nm::varchar(4000) end,
case when tkahbi.elcty_safe_mngr_apnt_mthd_nm is null then '' else tkahbi.elcty_safe_mngr_apnt_mthd_nm::varchar(4000) end,
case when tkahbi.fire_recptnban_mthd_nm is null then '' else tkahbi.fire_recptnban_mthd_nm::varchar(4000) end,
case when tkahbi.wsp_mthd_nm is null then '' else tkahbi.wsp_mthd_nm::varchar(4000) end,
case when tkahbi.elvtr_manage_stle_nm is null then '' else tkahbi.elvtr_manage_stle_nm::varchar(4000) end,
case when tkahbi.psnger_elvtr_co is null then '' else tkahbi.psnger_elvtr_co::varchar(4000) end,
case when tkahbi.frght_elvtr_co is null then '' else tkahbi.frght_elvtr_co::varchar(4000) end,
case when tkahbi.psnger_frght_elvtr_co is null then '' else tkahbi.psnger_frght_elvtr_co::varchar(4000) end,
case when tkahbi.troblrit_elvtr_co is null then '' else tkahbi.troblrit_elvtr_co::varchar(4000) end,
case when tkahbi.emgnc_elvtr_co is null then '' else tkahbi.emgnc_elvtr_co::varchar(4000) end,
case when tkahbi.etc_elvtr_co is null then '' else tkahbi.etc_elvtr_co::varchar(4000) end,
case when tkahbi.tot_parkng_alge is null then '' else tkahbi.tot_parkng_alge::varchar(4000) end,
case when tkahbi.ground_parkng_alge is null then '' else tkahbi.ground_parkng_alge::varchar(4000) end,
case when tkahbi.undgrnd_parkng_alge is null then '' else tkahbi.undgrnd_parkng_alge::varchar(4000) end,
case when tkahbi.cctv_alge is null then '' else tkahbi.cctv_alge::varchar(4000) end,
case when tkahbi.parkngcntrl_hrk_at_nm is null then '' else tkahbi.parkngcntrl_hrk_at_nm::varchar(4000) end,
case when tkahbi.manageoffice_adres is null then '' else tkahbi.manageoffice_adres::varchar(4000) end,
case when tkahbi.manageoffice_cttpc is null then '' else tkahbi.manageoffice_cttpc::varchar(4000) end,
case when tkahbi.manageoffice_fax is null then '' else tkahbi.manageoffice_fax::varchar(4000) end,
case when tkahbi.mrn_cmpnint_fclty_nm is null then '' else tkahbi.mrn_cmpnint_fclty_nm::varchar(4000) end,
case when tkahbi.sbscrb_de is null then '' else tkahbi.sbscrb_de::varchar(4000) end,
case when tkahbi.lttot_hshld_co is null then '' else tkahbi.lttot_hshld_co::varchar(4000) end,
case when tkahbi.rent_hshld_co is null then '' else tkahbi.rent_hshld_co::varchar(4000) end,
case when tkahbi.top_floor_co is null then '' else tkahbi.top_floor_co::varchar(4000) end,
case when tkahbi.bildregstr_top_floor_co is null then '' else tkahbi.bildregstr_top_floor_co::varchar(4000) end,
case when tkahbi.undgrnd_floor_co is null then '' else tkahbi.undgrnd_floor_co::varchar(4000) END,
case WHEN trunc(st_y(st_centroid(st_collect(trsb.lc_info)))::numeric, 10) IS NULL THEN '' ELSE trunc(st_y(st_centroid(st_collect(trsb.lc_info)))::numeric, 10)::varchar(4000) end,
case WHEN trunc(st_x(st_centroid(st_collect(trsb.lc_info)))::numeric, 10) IS NULL THEN '' ELSE trunc(st_x(st_centroid(st_collect(trsb.lc_info)))::numeric, 10)::varchar(4000) end,
'')
  from tb_k_apt_hsmp_bass_info tkahbi
       left outer join 
       tb_rn_adres_buld trab
           on trab.atpt_nm = tkahbi.atpt_nm
              and 
              trab.signgu_nm = tkahbi.signgu_nm
              and 
              trab.road_nm = trim(split_part(trim(replace(tkahbi.rn_adres, tkahbi.atpt_nm||' '||tkahbi.signgu_nm, '')), ' ', 1))
              and 
              trab.buld_mnnm_no = case when length(regexp_replace(split_part(trim(split_part(split_part(trim(replace(tkahbi.rn_adres, tkahbi.atpt_nm||' '||tkahbi.signgu_nm, '')), ' ', 2), ',', 1)), '-', 1), '[^0-9]', '', 'g')) = 0 then null
                                       else regexp_replace(split_part(trim(split_part(split_part(trim(replace(tkahbi.rn_adres, tkahbi.atpt_nm||' '||tkahbi.signgu_nm, '')), ' ', 2), ',', 1)), '-', 1), '[^0-9]', '', 'g')::numeric
                                  end
              and trab.buld_slno_no = case when length(regexp_replace(split_part(trim(split_part(split_part(trim(replace(tkahbi.rn_adres, tkahbi.atpt_nm||' '||tkahbi.signgu_nm, '')), ' ', 2), ',', 1)), '-', 2), '[^0-9]', '', 'g')) = 0 then 0
                                           else regexp_replace(split_part(trim(split_part(split_part(trim(replace(tkahbi.rn_adres, tkahbi.atpt_nm||' '||tkahbi.signgu_nm, '')), ' ', 2), ',', 1)), '-', 2), '[^0-9]', '', 'g')::numeric
                                      end
       left outer join 
       tb_rn_spce_buld trsb
           on trsb.signgu_code = substring(trab.legaldong_code, 1, 5)
              and 
              trsb.rn_code = substring(trab.rn_code, 6, 7)
              and 
              trsb.buld_mnnm_no = trab.buld_mnnm_no
              and 
              trsb.buld_slno_no = trab.buld_slno_no
 group by tkahbi.hsmp_code
        , tkahbi.hsmp_nm
        , tkahbi.atpt_nm
        , tkahbi.signgu_nm
        , tkahbi.eupmyeon_nm
        , tkahbi.dongli_nm
        , tkahbi.hsmp_cl_nm
        , tkahbi.legaldong_adres
        , tkahbi.rn_adres
        , tkahbi.lttot_stle_nm
        , tkahbi.use_confm_de
        , tkahbi.dong_co
        , tkahbi.hshld_co
        , tkahbi.manage_mthd_nm
        , tkahbi.heat_mthd_nm
        , tkahbi.crrdpr_ty_nm
        , tkahbi.cnstrctprofs_nm
        , tkahbi.opertnprofs_nm
        , tkahbi.housemgbsman_nm
        , tkahbi.gnrl_manage_mthd_nm
        , tkahbi.gnrl_manage_nmpr_co
        , tkahbi.expens_manage_mthd_nm
        , tkahbi.expens_manage_nmpr_co
        , tkahbi.expens_manage_cntrct_entrps_nm
        , tkahbi.cln_manage_mthd_nm
        , tkahbi.cln_manage_nmpr_co
        , tkahbi.fdwater_process_mth_nm
        , tkahbi.dsnf_manage_mthd_nm
        , tkahbi.fyer_dsnf_co
        , tkahbi.dsnf_mth_nm
        , tkahbi.buld_strct_nm
        , tkahbi.elcty_cobfe_cpcty
        , tkahbi.hshld_elcty_cntrct_mthd_nm
        , tkahbi.elcty_safe_mngr_apnt_mthd_nm
        , tkahbi.fire_recptnban_mthd_nm
        , tkahbi.wsp_mthd_nm
        , tkahbi.elvtr_manage_stle_nm
        , tkahbi.psnger_elvtr_co
        , tkahbi.frght_elvtr_co
        , tkahbi.psnger_frght_elvtr_co
        , tkahbi.troblrit_elvtr_co
        , tkahbi.emgnc_elvtr_co
        , tkahbi.etc_elvtr_co
        , tkahbi.tot_parkng_alge
        , tkahbi.ground_parkng_alge
        , tkahbi.undgrnd_parkng_alge
        , tkahbi.cctv_alge
        , tkahbi.parkngcntrl_hrk_at_nm
        , tkahbi.manageoffice_adres
        , tkahbi.manageoffice_cttpc
        , tkahbi.manageoffice_fax
        , tkahbi.mrn_cmpnint_fclty_nm
        , tkahbi.sbscrb_de
        , tkahbi.lttot_hshld_co
        , tkahbi.rent_hshld_co
        , tkahbi.top_floor_co
        , tkahbi.bildregstr_top_floor_co
        , tkahbi.undgrnd_floor_co; -- 18318 행

/*openrowset 방법*/
SELECT
concat_ws('||',
case when tkahbi.hsmp_code is null then '' else tkahbi.hsmp_code::varchar(4000) END,
case when tkahbi.hsmp_nm is null then '' else tkahbi.hsmp_nm::varchar(4000) END,
case when tkahbi.atpt_nm is null then '' else tkahbi.atpt_nm::varchar(4000) END,
case when tkahbi.signgu_nm is null then '' else tkahbi.signgu_nm::varchar(4000) END,
case when tkahbi.eupmyeon_nm is null then '' else tkahbi.eupmyeon_nm::varchar(4000) END,
case when tkahbi.dongli_nm is null then '' else tkahbi.dongli_nm::varchar(4000) END,
case when tkahbi.hsmp_cl_nm is null then '' else tkahbi.hsmp_cl_nm::varchar(4000) END,
case when tkahbi.legaldong_adres is null then '' else tkahbi.legaldong_adres::varchar(4000) END,
case when tkahbi.rn_adres is null then '' else tkahbi.rn_adres::varchar(4000) END,
case when tkahbi.lttot_stle_nm is null then '' else tkahbi.lttot_stle_nm::varchar(4000) END,
case when tkahbi.use_confm_de is null then '' else tkahbi.use_confm_de::varchar(4000) END,
case when tkahbi.dong_co is null then '' else tkahbi.dong_co::varchar(4000) end,
case when tkahbi.hshld_co is null then '' else tkahbi.hshld_co::varchar(4000) end,
case when tkahbi.manage_mthd_nm is null then '' else tkahbi.manage_mthd_nm::varchar(4000) end,
case when tkahbi.heat_mthd_nm is null then '' else tkahbi.heat_mthd_nm::varchar(4000) end,
case when tkahbi.crrdpr_ty_nm is null then '' else tkahbi.crrdpr_ty_nm::varchar(4000) end,
case when tkahbi.cnstrctprofs_nm is null then '' else tkahbi.cnstrctprofs_nm::varchar(4000) end,
case when tkahbi.opertnprofs_nm is null then '' else tkahbi.opertnprofs_nm::varchar(4000) end,
case when tkahbi.housemgbsman_nm is null then '' else tkahbi.housemgbsman_nm::varchar(4000) end,
case when tkahbi.gnrl_manage_mthd_nm is null then '' else tkahbi.gnrl_manage_mthd_nm::varchar(4000) end,
case when tkahbi.gnrl_manage_nmpr_co is null then '' else tkahbi.gnrl_manage_nmpr_co::varchar(4000) end,
case when tkahbi.expens_manage_mthd_nm is null then '' else tkahbi.expens_manage_mthd_nm::varchar(4000) end,
case when tkahbi.expens_manage_nmpr_co is null then '' else tkahbi.expens_manage_nmpr_co::varchar(4000) end,
case when tkahbi.expens_manage_cntrct_entrps_nm is null then '' else tkahbi.expens_manage_cntrct_entrps_nm::varchar(4000) end,
case when tkahbi.cln_manage_mthd_nm is null then '' else tkahbi.cln_manage_mthd_nm::varchar(4000) end,
case when tkahbi.cln_manage_nmpr_co is null then '' else tkahbi.cln_manage_nmpr_co::varchar(4000) end,
case when tkahbi.fdwater_process_mth_nm is null then '' else tkahbi.fdwater_process_mth_nm::varchar(4000) end,
case when tkahbi.dsnf_manage_mthd_nm is null then '' else tkahbi.dsnf_manage_mthd_nm::varchar(4000) end,
case when tkahbi.fyer_dsnf_co is null then '' else tkahbi.fyer_dsnf_co::varchar(4000) end,
case when tkahbi.dsnf_mth_nm is null then '' else tkahbi.dsnf_mth_nm::varchar(4000) end,
case when tkahbi.buld_strct_nm is null then '' else tkahbi.buld_strct_nm::varchar(4000) end,
case when tkahbi.elcty_cobfe_cpcty is null then '' else tkahbi.elcty_cobfe_cpcty::varchar(4000) end,
case when tkahbi.hshld_elcty_cntrct_mthd_nm is null then '' else tkahbi.hshld_elcty_cntrct_mthd_nm::varchar(4000) end,
case when tkahbi.elcty_safe_mngr_apnt_mthd_nm is null then '' else tkahbi.elcty_safe_mngr_apnt_mthd_nm::varchar(4000) end,
case when tkahbi.fire_recptnban_mthd_nm is null then '' else tkahbi.fire_recptnban_mthd_nm::varchar(4000) end,
case when tkahbi.wsp_mthd_nm is null then '' else tkahbi.wsp_mthd_nm::varchar(4000) end,
case when tkahbi.elvtr_manage_stle_nm is null then '' else tkahbi.elvtr_manage_stle_nm::varchar(4000) end,
case when tkahbi.psnger_elvtr_co is null then '' else tkahbi.psnger_elvtr_co::varchar(4000) end,
case when tkahbi.frght_elvtr_co is null then '' else tkahbi.frght_elvtr_co::varchar(4000) end,
case when tkahbi.psnger_frght_elvtr_co is null then '' else tkahbi.psnger_frght_elvtr_co::varchar(4000) end,
case when tkahbi.troblrit_elvtr_co is null then '' else tkahbi.troblrit_elvtr_co::varchar(4000) end,
case when tkahbi.emgnc_elvtr_co is null then '' else tkahbi.emgnc_elvtr_co::varchar(4000) end,
case when tkahbi.etc_elvtr_co is null then '' else tkahbi.etc_elvtr_co::varchar(4000) end,
case when tkahbi.tot_parkng_alge is null then '' else tkahbi.tot_parkng_alge::varchar(4000) end,
case when tkahbi.ground_parkng_alge is null then '' else tkahbi.ground_parkng_alge::varchar(4000) end,
case when tkahbi.undgrnd_parkng_alge is null then '' else tkahbi.undgrnd_parkng_alge::varchar(4000) end,
case when tkahbi.cctv_alge is null then '' else tkahbi.cctv_alge::varchar(4000) end,
case when tkahbi.parkngcntrl_hrk_at_nm is null then '' else tkahbi.parkngcntrl_hrk_at_nm::varchar(4000) end,
case when tkahbi.manageoffice_adres is null then '' else tkahbi.manageoffice_adres::varchar(4000) end,
case when tkahbi.manageoffice_cttpc is null then '' else tkahbi.manageoffice_cttpc::varchar(4000) end,
case when tkahbi.manageoffice_fax is null then '' else tkahbi.manageoffice_fax::varchar(4000) end,
case when tkahbi.mrn_cmpnint_fclty_nm is null then '' else tkahbi.mrn_cmpnint_fclty_nm::varchar(4000) end,
case when tkahbi.sbscrb_de is null then '' else tkahbi.sbscrb_de::varchar(4000) end,
case when tkahbi.lttot_hshld_co is null then '' else tkahbi.lttot_hshld_co::varchar(4000) end,
case when tkahbi.rent_hshld_co is null then '' else tkahbi.rent_hshld_co::varchar(4000) end,
case when tkahbi.top_floor_co is null then '' else tkahbi.top_floor_co::varchar(4000) end,
case when tkahbi.bildregstr_top_floor_co is null then '' else tkahbi.bildregstr_top_floor_co::varchar(4000) end,
case when tkahbi.undgrnd_floor_co is null then '' else tkahbi.undgrnd_floor_co::varchar(4000) END,
case WHEN trunc(st_y(st_centroid(st_collect(trsb.lc_info)))::numeric, 10) IS NULL THEN '' ELSE trunc(st_y(st_centroid(st_collect(trsb.lc_info)))::numeric, 10)::varchar(4000) END, -- hsmp_lat
case WHEN trunc(st_x(st_centroid(st_collect(trsb.lc_info)))::numeric, 10) IS NULL THEN '' ELSE trunc(st_x(st_centroid(st_collect(trsb.lc_info)))::numeric, 10)::varchar(4000) END, -- hsmp_lot
case WHEN trunc(st_y(st_centroid(st_collect(trsb.lc_info)))::numeric, 10) IS NULL THEN '' 
     ELSE concat('point(', trunc(st_x(st_centroid(st_collect(trsb.lc_info)))::numeric, 10), ' ',trunc(st_y(st_centroid(st_collect(trsb.lc_info)))::numeric, 10), ')') END -- hsmp_crdnt
) AS RESULT
  from tb_k_apt_hsmp_bass_info tkahbi
       left outer join 
       tb_rn_adres_buld trab
           on trab.atpt_nm = tkahbi.atpt_nm
              and 
              trab.signgu_nm = tkahbi.signgu_nm
              and 
              trab.road_nm = trim(split_part(trim(replace(tkahbi.rn_adres, tkahbi.atpt_nm||' '||tkahbi.signgu_nm, '')), ' ', 1))
              and 
              trab.buld_mnnm_no = case when length(regexp_replace(split_part(trim(split_part(split_part(trim(replace(tkahbi.rn_adres, tkahbi.atpt_nm||' '||tkahbi.signgu_nm, '')), ' ', 2), ',', 1)), '-', 1), '[^0-9]', '', 'g')) = 0 then null
                                       else regexp_replace(split_part(trim(split_part(split_part(trim(replace(tkahbi.rn_adres, tkahbi.atpt_nm||' '||tkahbi.signgu_nm, '')), ' ', 2), ',', 1)), '-', 1), '[^0-9]', '', 'g')::numeric
                                  end
              and trab.buld_slno_no = case when length(regexp_replace(split_part(trim(split_part(split_part(trim(replace(tkahbi.rn_adres, tkahbi.atpt_nm||' '||tkahbi.signgu_nm, '')), ' ', 2), ',', 1)), '-', 2), '[^0-9]', '', 'g')) = 0 then 0
                                           else regexp_replace(split_part(trim(split_part(split_part(trim(replace(tkahbi.rn_adres, tkahbi.atpt_nm||' '||tkahbi.signgu_nm, '')), ' ', 2), ',', 1)), '-', 2), '[^0-9]', '', 'g')::numeric
                                      end
       left outer join 
       tb_rn_spce_buld trsb
           on trsb.signgu_code = substring(trab.legaldong_code, 1, 5)
              and 
              trsb.rn_code = substring(trab.rn_code, 6, 7)
              and 
              trsb.buld_mnnm_no = trab.buld_mnnm_no
              and 
              trsb.buld_slno_no = trab.buld_slno_no
 group by tkahbi.hsmp_code
        , tkahbi.hsmp_nm
        , tkahbi.atpt_nm
        , tkahbi.signgu_nm
        , tkahbi.eupmyeon_nm
        , tkahbi.dongli_nm
        , tkahbi.hsmp_cl_nm
        , tkahbi.legaldong_adres
        , tkahbi.rn_adres
        , tkahbi.lttot_stle_nm
        , tkahbi.use_confm_de
        , tkahbi.dong_co
        , tkahbi.hshld_co
        , tkahbi.manage_mthd_nm
        , tkahbi.heat_mthd_nm
        , tkahbi.crrdpr_ty_nm
        , tkahbi.cnstrctprofs_nm
        , tkahbi.opertnprofs_nm
        , tkahbi.housemgbsman_nm
        , tkahbi.gnrl_manage_mthd_nm
        , tkahbi.gnrl_manage_nmpr_co
        , tkahbi.expens_manage_mthd_nm
        , tkahbi.expens_manage_nmpr_co
        , tkahbi.expens_manage_cntrct_entrps_nm
        , tkahbi.cln_manage_mthd_nm
        , tkahbi.cln_manage_nmpr_co
        , tkahbi.fdwater_process_mth_nm
        , tkahbi.dsnf_manage_mthd_nm
        , tkahbi.fyer_dsnf_co
        , tkahbi.dsnf_mth_nm
        , tkahbi.buld_strct_nm
        , tkahbi.elcty_cobfe_cpcty
        , tkahbi.hshld_elcty_cntrct_mthd_nm
        , tkahbi.elcty_safe_mngr_apnt_mthd_nm
        , tkahbi.fire_recptnban_mthd_nm
        , tkahbi.wsp_mthd_nm
        , tkahbi.elvtr_manage_stle_nm
        , tkahbi.psnger_elvtr_co
        , tkahbi.frght_elvtr_co
        , tkahbi.psnger_frght_elvtr_co
        , tkahbi.troblrit_elvtr_co
        , tkahbi.emgnc_elvtr_co
        , tkahbi.etc_elvtr_co
        , tkahbi.tot_parkng_alge
        , tkahbi.ground_parkng_alge
        , tkahbi.undgrnd_parkng_alge
        , tkahbi.cctv_alge
        , tkahbi.parkngcntrl_hrk_at_nm
        , tkahbi.manageoffice_adres
        , tkahbi.manageoffice_cttpc
        , tkahbi.manageoffice_fax
        , tkahbi.mrn_cmpnint_fclty_nm
        , tkahbi.sbscrb_de
        , tkahbi.lttot_hshld_co
        , tkahbi.rent_hshld_co
        , tkahbi.top_floor_co
        , tkahbi.bildregstr_top_floor_co
        , tkahbi.undgrnd_floor_co; -- 18375 행



-- postgre => tb_k_apt_managect_info
-- mssql => tb_link_hsmp_managect_info
select 
concat_ws('||',
case when hsmp_code is null then '' else hsmp_code::varchar(4000) end,
case when hsmp_nm is null then '' else hsmp_nm::varchar(4000) end,
case when atpt_nm is null then '' else atpt_nm::varchar(4000) end,
case when signgu_nm is null then '' else signgu_nm::varchar(4000) end,
case when eupmyeon_nm is null then '' else eupmyeon_nm::varchar(4000) end,
case when dongli_nm is null then '' else dongli_nm::varchar(4000) end,
case when occrrnc_ym is null then '' else occrrnc_ym::varchar(4000) end,
case when cmnuse_manage_ct is null then '' else cmnuse_manage_ct::varchar(4000) end,
case when lbr_ct is null then '' else lbr_ct::varchar(4000) end,
case when ofcrk_ct is null then '' else ofcrk_ct::varchar(4000) end,
case when taxdue is null then '' else taxdue::varchar(4000) end,
case when clth_ct is null then '' else clth_ct::varchar(4000) end,
case when edc_traing_ct is null then '' else edc_traing_ct::varchar(4000) end,
case when vhcle_mntnc_ct is null then '' else vhcle_mntnc_ct::varchar(4000) end,
case when mrn_ct is null then '' else mrn_ct::varchar(4000) end,
case when cln_ct is null then '' else cln_ct::varchar(4000) end,
case when expens_ct is null then '' else expens_ct::varchar(4000) end,
case when dsnf_ct is null then '' else dsnf_ct::varchar(4000) end,
case when elvtr_mntnc_ct is null then '' else elvtr_mntnc_ct::varchar(4000) end,
case when intstntwrk_mntnc_ct is null then '' else intstntwrk_mntnc_ct::varchar(4000) end,
case when rpairs_ct is null then '' else rpairs_ct::varchar(4000) end,
case when fclty_mntnc_ct is null then '' else fclty_mntnc_ct::varchar(4000) end,
case when safe_chck_ct is null then '' else safe_chck_ct::varchar(4000) end,
case when dsstr_prevnt_ct is null then '' else dsstr_prevnt_ct::varchar(4000) end,
case when cnsgn_manage_fee is null then '' else cnsgn_manage_fee::varchar(4000) end,
case when indvdlz_rntfee is null then '' else indvdlz_rntfee::varchar(4000) end,
case when cmnuse_heat_ct is null then '' else cmnuse_heat_ct::varchar(4000) end,
case when dvr_heat_ct is null then '' else dvr_heat_ct::varchar(4000) end,
case when cmnuse_htwtr_ct is null then '' else cmnuse_htwtr_ct::varchar(4000) end,
case when dvr_htwtr_ct is null then '' else dvr_htwtr_ct::varchar(4000) end,
case when cmnuse_gas_rntfee is null then '' else cmnuse_gas_rntfee::varchar(4000) end,
case when dvr_gas_rntfee is null then '' else dvr_gas_rntfee::varchar(4000) end,
case when cmnuse_elcty_rntfee is null then '' else cmnuse_elcty_rntfee::varchar(4000) end,
case when dvr_elcty_rntfee is null then '' else dvr_elcty_rntfee::varchar(4000) end,
case when cmnuse_cptl_rntfee is null then '' else cmnuse_cptl_rntfee::varchar(4000) end,
case when dvr_cptl_rntfee is null then '' else dvr_cptl_rntfee::varchar(4000) end,
case when wrrtn_dirt_fee is null then '' else wrrtn_dirt_fee::varchar(4000) end,
case when lvlh_wste_fee is null then '' else lvlh_wste_fee::varchar(4000) end,
case when mvnman_reprsnt_mtg_opernon is null then '' else mvnman_reprsnt_mtg_opernon::varchar(4000) end,
case when buld_irncf is null then '' else buld_irncf::varchar(4000) end,
case when elec_manage_cmit_opernon is null then '' else elec_manage_cmit_opernon::varchar(4000) end,
case when inorg_rpairs_rsvmney_mt_levyam is null then '' else inorg_rpairs_rsvmney_mt_levyam::varchar(4000) end,
case when inorg_rpairs_rsvmney_mt_usgamt is null then '' else inorg_rpairs_rsvmney_mt_usgamt::varchar(4000) end,
case when inorg_rpairs_rsvmney_tot_amount is null then '' else inorg_rpairs_rsvmney_tot_amount::varchar(4000) end,
case when inorg_rpairs_rsvmney_accmlrt is null then '' else inorg_rpairs_rsvmney_accmlrt::varchar(4000) end,
case when etc_ern_mt_incme_amount is null then '' else etc_ern_mt_incme_amount::varchar(4000) end)
  from tb_k_apt_managect_info
 LIMIT 200000; -- 200000 행
  
select 
concat_ws('||',
case when hsmp_code is null then '' else hsmp_code::varchar(4000) end,
case when hsmp_nm is null then '' else hsmp_nm::varchar(4000) end,
case when atpt_nm is null then '' else atpt_nm::varchar(4000) end,
case when signgu_nm is null then '' else signgu_nm::varchar(4000) end,
case when eupmyeon_nm is null then '' else eupmyeon_nm::varchar(4000) end,
case when dongli_nm is null then '' else dongli_nm::varchar(4000) end,
case when occrrnc_ym is null then '' else occrrnc_ym::varchar(4000) end,
case when cmnuse_manage_ct is null then '' else cmnuse_manage_ct::varchar(4000) end,
case when lbr_ct is null then '' else lbr_ct::varchar(4000) end,
case when ofcrk_ct is null then '' else ofcrk_ct::varchar(4000) end,
case when taxdue is null then '' else taxdue::varchar(4000) end,
case when clth_ct is null then '' else clth_ct::varchar(4000) end,
case when edc_traing_ct is null then '' else edc_traing_ct::varchar(4000) end,
case when vhcle_mntnc_ct is null then '' else vhcle_mntnc_ct::varchar(4000) end,
case when mrn_ct is null then '' else mrn_ct::varchar(4000) end,
case when cln_ct is null then '' else cln_ct::varchar(4000) end,
case when expens_ct is null then '' else expens_ct::varchar(4000) end,
case when dsnf_ct is null then '' else dsnf_ct::varchar(4000) end,
case when elvtr_mntnc_ct is null then '' else elvtr_mntnc_ct::varchar(4000) end,
case when intstntwrk_mntnc_ct is null then '' else intstntwrk_mntnc_ct::varchar(4000) end,
case when rpairs_ct is null then '' else rpairs_ct::varchar(4000) end,
case when fclty_mntnc_ct is null then '' else fclty_mntnc_ct::varchar(4000) end,
case when safe_chck_ct is null then '' else safe_chck_ct::varchar(4000) end,
case when dsstr_prevnt_ct is null then '' else dsstr_prevnt_ct::varchar(4000) end,
case when cnsgn_manage_fee is null then '' else cnsgn_manage_fee::varchar(4000) end,
case when indvdlz_rntfee is null then '' else indvdlz_rntfee::varchar(4000) end,
case when cmnuse_heat_ct is null then '' else cmnuse_heat_ct::varchar(4000) end,
case when dvr_heat_ct is null then '' else dvr_heat_ct::varchar(4000) end,
case when cmnuse_htwtr_ct is null then '' else cmnuse_htwtr_ct::varchar(4000) end,
case when dvr_htwtr_ct is null then '' else dvr_htwtr_ct::varchar(4000) end,
case when cmnuse_gas_rntfee is null then '' else cmnuse_gas_rntfee::varchar(4000) end,
case when dvr_gas_rntfee is null then '' else dvr_gas_rntfee::varchar(4000) end,
case when cmnuse_elcty_rntfee is null then '' else cmnuse_elcty_rntfee::varchar(4000) end,
case when dvr_elcty_rntfee is null then '' else dvr_elcty_rntfee::varchar(4000) end,
case when cmnuse_cptl_rntfee is null then '' else cmnuse_cptl_rntfee::varchar(4000) end,
case when dvr_cptl_rntfee is null then '' else dvr_cptl_rntfee::varchar(4000) end,
case when wrrtn_dirt_fee is null then '' else wrrtn_dirt_fee::varchar(4000) end,
case when lvlh_wste_fee is null then '' else lvlh_wste_fee::varchar(4000) end,
case when mvnman_reprsnt_mtg_opernon is null then '' else mvnman_reprsnt_mtg_opernon::varchar(4000) end,
case when buld_irncf is null then '' else buld_irncf::varchar(4000) end,
case when elec_manage_cmit_opernon is null then '' else elec_manage_cmit_opernon::varchar(4000) end,
case when inorg_rpairs_rsvmney_mt_levyam is null then '' else inorg_rpairs_rsvmney_mt_levyam::varchar(4000) end,
case when inorg_rpairs_rsvmney_mt_usgamt is null then '' else inorg_rpairs_rsvmney_mt_usgamt::varchar(4000) end,
case when inorg_rpairs_rsvmney_tot_amount is null then '' else inorg_rpairs_rsvmney_tot_amount::varchar(4000) end,
case when inorg_rpairs_rsvmney_accmlrt is null then '' else inorg_rpairs_rsvmney_accmlrt::varchar(4000) end,
case when etc_ern_mt_incme_amount is null then '' else etc_ern_mt_incme_amount::varchar(4000) end)
  from tb_k_apt_managect_info
OFFSET 200000; -- 95882 행
-- 전체 295882 행





-- postgre => tb_apply_ofctl_cty_prvate_rent_lttot_info_cmpetrt
-- mssql => tb_link_ofctl_cty_prvate_rent_lttot_cmpet_rt_info
select 
concat_ws('||',
case when house_manage_no is null then '' else house_manage_no::varchar(4000) end,
case when pblanc_no is null then '' else pblanc_no::varchar(4000) end,
case when model_no is null then '' else model_no::varchar(4000) end,
case when house_ty_nm is null then '' else house_ty_nm::varchar(4000) end,
case when suply_hshld_co is null then '' else suply_hshld_co::varchar(4000) end,
case when residnt_prior_at is null then '' else residnt_prior_at::varchar(4000) end,
case when suply_se_nm is null then '' else suply_se_nm::varchar(4000) end,
case when rcept_co is null then '' else rcept_co::varchar(4000) end,
case when cmpet_rt_cn is null then '' else cmpet_rt_cn::varchar(4000) end)
  from tb_apply_ofctl_cty_prvate_rent_lttot_info_cmpetrt; -- 1090 행





-- postgre => tb_apply_ofctl_cty_prvate_rent_lttot_info_detail
-- mssql => tb_link_ofctl_cty_prvate_rent_lttot_info
select 
concat_ws('||',
case when house_manage_no is null then '' else house_manage_no::varchar(4000) end,
case when pblanc_no is null then '' else pblanc_no::varchar(4000) end,
case when house_nm is null then '' else house_nm::varchar(4000) end,
case when house_se_code is null then '' else house_se_code::varchar(4000) end,
case when house_se_code_nm is null then '' else house_se_code_nm::varchar(4000) end,
case when house_detail_se_code is null then '' else house_detail_se_code::varchar(4000) end,
case when house_detail_se_code_nm is null then '' else house_detail_se_code_nm::varchar(4000) end,
case when house_se_nm is null then '' else house_se_nm::varchar(4000) end,
case when suply_lc_zip is null then '' else suply_lc_zip::varchar(4000) end,
case when suply_lc_nm is null then '' else suply_lc_nm::varchar(4000) end,
case when suply_scale is null then '' else suply_scale::varchar(4000) end,
case when rcrit_pblanc_de is null then '' else rcrit_pblanc_de::varchar(4000) end,
case when subscrpt_rcept_begin_de is null then '' else subscrpt_rcept_begin_de::varchar(4000) end,
case when subscrpt_rcept_end_de is null then '' else subscrpt_rcept_end_de::varchar(4000) end,
case when przwner_presnatn_de is null then '' else przwner_presnatn_de::varchar(4000) end,
case when cntrct_begin_de is null then '' else cntrct_begin_de::varchar(4000) end,
case when cntrct_end_de is null then '' else cntrct_end_de::varchar(4000) end,
case when hmpg_url is null then '' else hmpg_url::varchar(4000) end,
case when bsns_mby_opertnprofs_nm is null then '' else bsns_mby_opertnprofs_nm::varchar(4000) end,
case when inqry_offic_telno is null then '' else inqry_offic_telno::varchar(4000) end,
case when mvn_prearnge_mt is null then '' else mvn_prearnge_mt::varchar(4000) end,
case when lttot_info_url is null then '' else lttot_info_url::varchar(4000) end),
'',
'',
'',
'',
'',
'',
''
  from tb_apply_ofctl_cty_prvate_rent_lttot_info_detail; -- 29 행





-- postgre => tb_apply_ofctl_cty_prvate_rent_lttot_house_ty_info_detail
-- mssql => tb_link_ofctl_cty_prvate_rent_lttot_ty_dtl_info
select 
concat_ws('||',
case when house_manage_no is null then '' else house_manage_no::varchar(4000) end,
case when pblanc_no is null then '' else pblanc_no::varchar(4000) end,
case when model_no is null then '' else model_no::varchar(4000) end,
case when group_nm is null then '' else group_nm::varchar(4000) end,
case when ty_nm is null then '' else ty_nm::varchar(4000) end,
case when dvr_ar is null then '' else dvr_ar::varchar(4000) end,
case when suply_hshld_co is null then '' else suply_hshld_co::varchar(4000) end,
case when suply_lttot_top_amount is null then '' else suply_lttot_top_amount::varchar(4000) end,
case when subscrpt_reqst_amount is null then '' else subscrpt_reqst_amount::varchar(4000) end)
  from tb_apply_ofctl_cty_prvate_rent_lttot_house_ty_info_detail; -- 2527 행





-- postgre => tb_apply_public_sport_prvate_rent_lttot_info_cmpetrt
-- mssql => tb_link_public_sprt_prvate_rent_lttot_cmpet_rt_info
select 
concat_ws('||',
case when house_manage_no is null then '' else house_manage_no::varchar(4000) end,
case when pblanc_no is null then '' else pblanc_no::varchar(4000) end,
case when model_no is null then '' else model_no::varchar(4000) end,
case when house_ty_nm is null then '' else house_ty_nm::varchar(4000) end,
case when suply_hshld_co is null then '' else suply_hshld_co::varchar(4000) end,
case when suply_ty_code is null then '' else suply_ty_code::varchar(4000) end,
case when suply_ty_code_nm is null then '' else suply_ty_code_nm::varchar(4000) end,
case when asign_hshld_co is null then '' else asign_hshld_co::varchar(4000) end,
case when rcept_co is null then '' else rcept_co::varchar(4000) end,
case when cmpet_rt_cn is null then '' else cmpet_rt_cn::varchar(4000) end)
  from tb_apply_public_sport_prvate_rent_lttot_info_cmpetrt; -- 424 행





-- postgre => tb_apply_remndr_hshld_lttot_info_cmpetrt
-- mssql => tb_link_remndr_hh_lttot_cmpet_rt_info
select 
concat_ws('||',
case when house_manage_no is null then '' else house_manage_no::varchar(4000) end,
case when pblanc_no is null then '' else pblanc_no::varchar(4000) end,
case when beffat_aftfat_se_code is null then '' else beffat_aftfat_se_code::varchar(4000) end,
case when house_ty_nm is null then '' else house_ty_nm::varchar(4000) end,
case when suply_hshld_co is null then '' else suply_hshld_co::varchar(4000) end,
case when rcept_co is null then '' else rcept_co::varchar(4000) end,
case when cmpet_rt_cn is null then '' else cmpet_rt_cn::varchar(4000) end)
  from tb_apply_remndr_hshld_lttot_info_cmpetrt; -- 2071 행





-- postgre => tb_apply_cancl_re_suply_lttot_info_cmpetrt
-- mssql => tb_link_rtrcn_re_sply_lttot_cmpet_rt_info
select 
concat_ws('||',
case when house_manage_no is null then '' else house_manage_no::varchar(4000) end,
case when pblanc_no is null then '' else pblanc_no::varchar(4000) end,
case when model_no is null then '' else model_no::varchar(4000) end,
case when house_ty_nm is null then '' else house_ty_nm::varchar(4000) end,
--case when suply_hshld_co is null then '' else suply_hshld_co::varchar(4000) end,
case when gnrl_suply_asign_hshld_co is null then '' else gnrl_suply_asign_hshld_co::varchar(4000) end,
case when mnych_gagu_asign_hshld_co is null then '' else mnych_gagu_asign_hshld_co::varchar(4000) end,
case when mrrg_mrd_asign_hshld_co is null then '' else mrrg_mrd_asign_hshld_co::varchar(4000) end,
case when lfe_frst_asign_hshld_co is null then '' else lfe_frst_asign_hshld_co::varchar(4000) end,
case when odsn_parnts_suport_asign_hshld_co is null then '' else odsn_parnts_suport_asign_hshld_co::varchar(4000) end,
case when instt_recomend_asign_hshld_co is null then '' else instt_recomend_asign_hshld_co::varchar(4000) end,
case when gnrl_suply_rcept_co is null then '' else gnrl_suply_rcept_co::varchar(4000) end,
case when mnych_gagu_rcept_co is null then '' else mnych_gagu_rcept_co::varchar(4000) end,
case when mrrg_mrd_rcept_co is null then '' else mrrg_mrd_rcept_co::varchar(4000) end,
case when lfe_frst_rcept_co is null then '' else lfe_frst_rcept_co::varchar(4000) end,
case when odsn_parnts_suport_rcept_co is null then '' else odsn_parnts_suport_rcept_co::varchar(4000) end,
case when instt_recomend_rcept_co is null then '' else instt_recomend_rcept_co::varchar(4000) end,
case when gnrl_suply_cmpet_rt_cn is null then '' else gnrl_suply_cmpet_rt_cn::varchar(4000) end,
case when mnych_gagu_cmpet_rt_cn is null then '' else mnych_gagu_cmpet_rt_cn::varchar(4000) end,
case when mrrg_mrd_cmpet_rt_cn is null then '' else mrrg_mrd_cmpet_rt_cn::varchar(4000) end,
case when lfe_frst_cmpet_rt_cn is null then '' else lfe_frst_cmpet_rt_cn::varchar(4000) end,
case when odsn_parnts_suport_cmpet_rt_cn is null then '' else odsn_parnts_suport_cmpet_rt_cn::varchar(4000) end,
case when instt_recomend_cmpet_rt_cn is null then '' else instt_recomend_cmpet_rt_cn::varchar(4000) end)
  from tb_apply_cancl_re_suply_lttot_info_cmpetrt; -- 142 행





-- postgre => tb_kric_statn_info
--          , tb_legal_zone_info_emg
--          , tb_legal_zone_info_lio
-- mssql => tb_link_subway_statn_info
select 
  concat_ws('||',
            case when tksi.statn_no is null then '' else tksi.statn_no::varchar(4000) end,
            case when tksi.statn_nm is null then '' else tksi.statn_nm::varchar(4000) end,
            case when tksi.route_no is null then '' else tksi.route_no::varchar(4000) end,
            case when tksi.route_nm is null then '' else tksi.route_nm::varchar(4000) end,
            case when tksi.eng_statn_nm is null then '' else tksi.eng_statn_nm::varchar(4000) end,
            case when tksi.chcrt_statn_nm is null then '' else tksi.chcrt_statn_nm::varchar(4000) end,
            case when tksi.trnsit_statn_se_nm is null then '' else tksi.trnsit_statn_se_nm::varchar(4000) end,
            case when tksi.trnsit_route_no is null then '' else tksi.trnsit_route_no::varchar(4000) end,
            case when tksi.trnsit_route_nm is null then '' else tksi.trnsit_route_nm::varchar(4000) end,
            case when trunc(st_y(tksi.lc_info)::numeric, 10) is null then '' else trunc(st_y(tksi.lc_info)::numeric, 10)::varchar(4000) end,
            case when trunc(st_x(tksi.lc_info)::numeric, 10) is null then '' else trunc(st_x(tksi.lc_info)::numeric, 10)::varchar(4000) end,
            case when tksi.oper_instt_nm is null then '' else tksi.oper_instt_nm::varchar(4000) end,
            case when tksi.statn_rn_adres is null then '' else tksi.statn_rn_adres::varchar(4000) end,
            case when tksi.statn_telno is null then '' else tksi.statn_telno::varchar(4000) end,
            case when tksi.data_stdr_de is null then '' else tksi.data_stdr_de::varchar(4000) end,
            '',
            case when coalesce (tlzil.li_code, tlzie.emd_code||'00') is null then '' else coalesce (tlzil.li_code, tlzie.emd_code||'00')::varchar(4000) end,
            '',
            '',
            '',
            '')
  from tb_kric_statn_info tksi
       left outer join 
       tb_legal_zone_info_emg tlzie
               on st_contains(tlzie.lc_info, tksi.lc_info)
       left outer JOIN
       tb_legal_zone_info_lio tlzil
               on st_contains(tlzil.lc_info, tksi.lc_info); -- 1053 행
/*
무슨 원인인지는 모르겠으나 4122인 신반포 데이터가 메모장에 붙여넣기 하면 ""가 생겨서 복사 붙여넣기후 큰 따옴표를 지우고 저장시키자
*/

/*openrowset 방법*/
select 
  concat_ws('||',
            case when tksi.statn_no is null then '' else tksi.statn_no::varchar(4000) end,
            case when tksi.statn_nm is null then '' else tksi.statn_nm::varchar(4000) end,
            case when tksi.route_no is null then '' else tksi.route_no::varchar(4000) end,
            case when tksi.route_nm is null then '' else tksi.route_nm::varchar(4000) end,
            case when tksi.eng_statn_nm is null then '' else tksi.eng_statn_nm::varchar(4000) end,
            case when tksi.chcrt_statn_nm is null then '' else tksi.chcrt_statn_nm::varchar(4000) end,
            case when tksi.trnsit_statn_se_nm is null then '' else tksi.trnsit_statn_se_nm::varchar(4000) end,
            case when tksi.trnsit_route_no is null then '' else tksi.trnsit_route_no::varchar(4000) end,
            case when tksi.trnsit_route_nm is null then '' else tksi.trnsit_route_nm::varchar(4000) end,
            case when trunc(st_y(tksi.lc_info)::numeric, 10) is NULL OR trunc(st_y(tksi.lc_info)::numeric, 10) = 0 
                                                             then '' 
                 else trunc(st_y(tksi.lc_info)::numeric, 10)::varchar(4000) END,
            case when trunc(st_x(tksi.lc_info)::numeric, 10) is null OR trunc(st_x(tksi.lc_info)::numeric, 10) = 0
                                                             then ''
                 else trunc(st_x(tksi.lc_info)::numeric, 10)::varchar(4000) END,
            case when tksi.oper_instt_nm is null then '' else tksi.oper_instt_nm::varchar(4000) end,
            case when tksi.statn_rn_adres is null then '' else tksi.statn_rn_adres::varchar(4000) end,
            case when tksi.statn_telno is null then '' else tksi.statn_telno::varchar(4000) end,
            case when tksi.data_stdr_de is null then '' else tksi.data_stdr_de::varchar(4000) end,
            case when trunc(st_y(tksi.lc_info)::numeric, 10) is null then '' 
                 else concat('point(', trunc(st_x(tksi.lc_info)::numeric, 10), ' ', trunc(st_y(tksi.lc_info)::numeric, 10), ')') end,
            case when coalesce (tlzil.li_code, tlzie.emd_code||'00') is null then '' else coalesce (tlzil.li_code, tlzie.emd_code||'00')::varchar(4000) end,
            '',
            '',
            '',
            '')
  from tb_kric_statn_info tksi
       left outer join 
       tb_legal_zone_info_emg tlzie
               on st_contains(tlzie.lc_info, tksi.lc_info)
       left outer JOIN
       tb_legal_zone_info_lio tlzil
               on st_contains(tlzil.lc_info, tksi.lc_info); -- 1053 행
/*
무슨 원인인지는 모르겠으나 4122인 신반포 데이터가 메모장에 붙여넣기 하면 ""가 생겨서 복사 붙여넣기후 큰 따옴표를 지우고 저장시키자 => 해당 데이터 앞뒤쪽 다 생김
*/
























