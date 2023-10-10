/*
작성 일자 : 230908
수정 일자 : 
작 성 자 : 조건영
작성 목적 : 운영서버를 만들기 위한 최종 정리 파일(txt파일 만들기) 
*/



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_atlfsl_bsc_info => openrowset방법
select 
  IFNULL(REPLACE(pi2.PRODUCT_NO,CONCAT(CHAR(10)), ''), '') atlfsl_bsc_info_pk 
, IFNULL(REPLACE(KAR_MM_NO, CONCAT(CHAR(10)), ''), '') asoc_atlfsl_no 
, IFNULL(REPLACE(KAR_CONTENT_NO,CONCAT(CHAR(10)), ''), '') asoc_app_intrlck_no 
, IFNULL(REPLACE(REALTOR_NO,CONCAT(CHAR(10)), ''), '') lrea_office_info_pk 
, IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '') ctpv_cd_pk 
, IFNULL(REPLACE(GUGUN_NO,CONCAT(CHAR(10)), ''), '') sgg_cd_pk 
, IFNULL(REPLACE(DONG_NO,CONCAT(CHAR(10)), ''), '') emd_li_cd_pk
, IFNULL(REPLACE(CASE WHEN atai.APT_NO IS NULL 
                        OR atai.APT_NO = 0
                                           THEN CASE WHEN pi2.DANJI_NO IS NULL 
                                                       OR pi2.DANJI_NO = 0
                                                                           THEN NULL
                                                     ELSE pi2.DANJI_NO
                                                 END 
                      ELSE atai.APT_NO
                  END
                , CONCAT(CHAR(10))
                , '')
       , '') hsmp_info_pk
, IFNULL(REPLACE(DANJI_DETAIL_NO,CONCAT(CHAR(10)), ''), '') hsmp_dtl_info_pk 
, IFNULL(REPLACE(substring(ifnull(ifnull(ifnull(atai.ARTICLE_TYPE, atci.ARTICLE_TYPE), atdi.ARTICLE_TYPE), atei.ARTICLE_TYPE), 1, 1),CONCAT(CHAR(10)), ''), '') atlfsl_ty_cd -- article
, IFNULL(REPLACE(ifnull(ifnull(ifnull(atai.ARTICLE_TYPE, atci.ARTICLE_TYPE), atdi.ARTICLE_TYPE), atei.ARTICLE_TYPE),CONCAT(CHAR(10)), ''), '') atlfsl_dtl_ty_cd -- article
, IFNULL(REPLACE(PRODUCT_CATE_CD,CONCAT(CHAR(10)), ''), '') atlfsl_knd_cd 
, IFNULL(REPLACE(ADDR_CODE,CONCAT(CHAR(10)), ''), '') stdg_dong_cd
, IFNULL(REPLACE(ifnull(ifnull(ifnull(atai.CORTAR_NO, atci.CORTAR_NO), atdi.CORTAR_NO), atei.CORTAR_NO),CONCAT(CHAR(10)), ''), '') stdg_cd -- article
, IFNULL(REPLACE(BDONG_NO, CONCAT(CHAR(10)), ''), '') stdg_innb 
, IFNULL(REPLACE(HDONG_NO, CONCAT(CHAR(10)), ''), '') dong_innb 
, CASE WHEN BON_NO = 0 THEN ''
       ELSE CASE WHEN LENGTH(BON_NO)<=4 THEN IFNULL(REPLACE(BON_NO,CONCAT(CHAR(10)), ''), '') 
                 ELSE '' 
             END 
   END mno 
, CASE WHEN BU_NO = 0 THEN ''
       ELSE CASE WHEN LENGTH(BU_NO)<=4 THEN IFNULL(REPLACE(BU_NO,CONCAT(CHAR(10)), ''), '') 
                 ELSE '' 
        END 
   END sno 
, IFNULL(REPLACE(CASE WHEN atai.APT_DONG IS NULL
                                             THEN CASE WHEN pi2.MM_DONG_NM IS NULL OR pi2.MM_DONG_NM = '0'
                                                                                THEN NULL
                                                       ELSE pi2.MM_DONG_NM
                                                   END
                      ELSE atai.APT_DONG
                  END
               , CONCAT(CHAR(10))
               , '')
       , '') aptcmpl_nm
, IFNULL(REPLACE(CASE WHEN HO_NM IN ('', '0') THEN NULL
                      ELSE HO_NM 
                  END 
               , CONCAT(CHAR(10))
               , '')
       , '') ho_nm
, CASE WHEN PRODUCT_LAT IN (NULL, 0) THEN ''
	   WHEN PRODUCT_LNG > 100 THEN IFNULL(REPLACE(concat('point(', PRODUCT_LNG, ' ', PRODUCT_LAT, ')'), CONCAT(CHAR(10)), ''), '') 
       ELSE IFNULL(REPLACE(concat('point(', PRODUCT_LAT, ' ', PRODUCT_LNG, ')'), CONCAT(CHAR(10)), ''), '') 
   END atlfsl_crdnt 
, CASE WHEN PRODUCT_LNG IS NULL OR PRODUCT_LNG =0 THEN ''
       WHEN PRODUCT_LNG > 100 THEN IFNULL(REPLACE(PRODUCT_LNG,CONCAT(CHAR(10)), ''), '')
       ELSE IFNULL(REPLACE(PRODUCT_LAT,CONCAT(CHAR(10)), ''), '') 
   END atlfsl_lot 
, CASE WHEN PRODUCT_LAT IS NULL OR PRODUCT_LAT =0 THEN ''
       WHEN PRODUCT_LAT < 100 THEN IFNULL(REPLACE(PRODUCT_LAT,CONCAT(CHAR(10)), ''), '')
       ELSE IFNULL(REPLACE(PRODUCT_LNG,CONCAT(CHAR(10)), ''), '') 
   END atlfsl_lat
, IFNULL(REPLACE(MM_TRANS_DATE,CONCAT(CHAR(10)), ''), '') atlfsl_trsm_dt
, IFNULL(REPLACE(CASE WHEN OPEN_APT_DONG_YN = '' THEN NULL
                      ELSE OPEN_APT_DONG_YN
                  END 
               , CONCAT(CHAR(10))
               , '')
       , '') bldg_aptcmpl_indct_yn
, IFNULL(REPLACE(OPEN_APT_TYPE_YN,CONCAT(CHAR(10)), ''), '') pyeong_indct_yn
, IFNULL(REPLACE(VR_YN,CONCAT(CHAR(10)), ''), '') vr_exst_yn
, IFNULL(REPLACE(IMG_YN,CONCAT(CHAR(10)), ''), '') img_exst_yn
, IFNULL(REPLACE(USER_NO,CONCAT(CHAR(10)), ''), '') pic_no
, IFNULL(REPLACE(USER_NM,CONCAT(CHAR(10)), ''), '') pic_nm
, IFNULL(REPLACE(USER_TEL_NO,CONCAT(CHAR(10)), ''), '') pic_telno
, IFNULL(REPLACE(CLICK_CNT,CONCAT(CHAR(10)), ''), '') dtl_scrn_prsl_cnt
, IFNULL(REPLACE(ifnull(ifnull(ifnull(atai.EXCLS_SPC, atci.EXCLS_SPC), atdi.EXCLS_SPC), atei.EXCLS_SPC),CONCAT(CHAR(10)), ''), '') prvuse_area
, IFNULL(REPLACE(ifnull(ifnull(atci.SPLY_SPC, atdi.SPLY_SPC), atei.SPLY_SPC),CONCAT(CHAR(10)), ''), '') sply_area
, IFNULL(REPLACE(ifnull(ifnull(atci.GRND_SPC, atdi.GRND_SPC), atei.GRND_SPC),CONCAT(CHAR(10)), ''), '') plot_area
, IFNULL(REPLACE(ifnull(ifnull(atci.BUILD_SPC, atdi.BUILD_SPC), atei.BUILD_SPC),CONCAT(CHAR(10)), ''), '') arch_area
, IFNULL(REPLACE(pi2.ROOM,CONCAT(CHAR(10)), ''), '') room_cnt
, IFNULL(REPLACE(ifnull(ifnull(atai.RESTROOM, atci.RESTROOM), atdi.RESTROOM),CONCAT(CHAR(10)), ''), '') toilet_cnt
, IFNULL(REPLACE(VIEW_CNT,CONCAT(CHAR(10)), ''), '') atlfsl_inq_cnt
, IFNULL(REPLACE(ifnull(atai.FLR_EXPS_TYPE, atci.FLR_EXPS_TYPE),CONCAT(CHAR(10)), ''), '') flr_expsr_mthd_cd
, IFNULL(REPLACE(ifnull(atai.FCOR_FLR_EXPS_TYPE, atci.FCOR_FLR_EXPS_TYPE),CONCAT(CHAR(10)), ''), '') now_flr_expsr_mthd_cd
, IFNULL(REPLACE(ifnull(ifnull(ifnull(atai.FLOOR, atci.FLOOR), atdi.FLOOR), atei.FLOOR),CONCAT(CHAR(10)), ''), '') flr_cnt
, IFNULL(REPLACE(ifnull(ifnull(ifnull(atai.TOTAL_FLOOR, atci.TOTAL_FLOOR), atdi.TOTAL_FLOOR), atei.TOTAL_FLOOR),CONCAT(CHAR(10)), ''), '') top_flr_cnt
, IFNULL(REPLACE(ifnull(ifnull(atci.UPFLR_CNT, atdi.UPFLR_CNT), atei.UPFLR_CNT),CONCAT(CHAR(10)), ''), '') grnd_flr_cnt
, IFNULL(REPLACE(ifnull(ifnull(atci.DNFLR_CNT, atdi.DNFLR_CNT), atei.DNFLR_CNT),CONCAT(CHAR(10)), ''), '') udgd_flr_cnt
, IFNULL(REPLACE(ifnull(atai.STAIR_CD, atci.STAIR_CD),CONCAT(CHAR(10)), ''), '') stairs_stle_cd
, IFNULL(REPLACE(
         CASE WHEN ifnull(ifnull(ifnull(atai.DIRECTION, atci.DIRECTION), atdi.DIRECTION), atei.DIRECTION) = 'EE' THEN '01'
              WHEN ifnull(ifnull(ifnull(atai.DIRECTION, atci.DIRECTION), atdi.DIRECTION), atei.DIRECTION) = 'WW' THEN '02'
              WHEN ifnull(ifnull(ifnull(atai.DIRECTION, atci.DIRECTION), atdi.DIRECTION), atei.DIRECTION) = 'SS' THEN '03'
              WHEN ifnull(ifnull(ifnull(atai.DIRECTION, atci.DIRECTION), atdi.DIRECTION), atei.DIRECTION) = 'NN' THEN '04'
              WHEN ifnull(ifnull(ifnull(atai.DIRECTION, atci.DIRECTION), atdi.DIRECTION), atei.DIRECTION) = 'ES' THEN '05'
              WHEN ifnull(ifnull(ifnull(atai.DIRECTION, atci.DIRECTION), atdi.DIRECTION), atei.DIRECTION) = 'WS' THEN '06'
              WHEN ifnull(ifnull(ifnull(atai.DIRECTION, atci.DIRECTION), atdi.DIRECTION), atei.DIRECTION) = 'EN' THEN '07'
              WHEN ifnull(ifnull(ifnull(atai.DIRECTION, atci.DIRECTION), atdi.DIRECTION), atei.DIRECTION) = 'WN' THEN '08'
              ELSE ''
          END, CONCAT(CHAR(10)), ''), '') drc_cd
, IFNULL(REPLACE(ifnull(atai.BALCONY_CD, atci.BALCONY_CD),CONCAT(CHAR(10)), ''), '') blcn_cd
, IFNULL(REPLACE(ifnull(ifnull(atci.PLACE, atdi.PLACE), atei.PLACE),CONCAT(CHAR(10)), ''), '') pstn_expln_cn
, IFNULL(REPLACE(ifnull(ifnull(atci.PARKING_PSBL, atdi.PARKING_PSBL), atei.PARKING_PSBL),CONCAT(CHAR(10)), ''), '') parkng_psblty_yn
, IFNULL(REPLACE(ifnull(ifnull(atci.PARKING, atdi.PARKING), atei.PARKING),CONCAT(CHAR(10)), ''), '') parkng_cnt
, IFNULL(REPLACE(ifnull(ifnull(ifnull(atai.C_DATE, atci.C_DATE), atdi.C_DATE), atei.C_DATE),CONCAT(CHAR(10)), ''), '') cmcn_day
, IFNULL(REPLACE(atai.LOAN_PRICE,CONCAT(CHAR(10)), ''), '') financ_amt
, IFNULL(REPLACE(pi2.STAT,CONCAT(CHAR(10)), ''), '') use_yn
, IFNULL(REPLACE(CLUSTER_STATE,CONCAT(CHAR(10)), ''), '') clustr_info_stts_cd
, IFNULL(REPLACE(PUSH_STATE,CONCAT(CHAR(10)), ''), '') push_stts_cd
, '' rcmdtn_yn -- 
, '' auc_yn
, '' atlfsl_stts_cd
, IFNULL(
         CASE WHEN atei.total_spc IN (NULL, 0) 
                                  THEN CASE WHEN atdi.total_spc IN (NULL, 0) 
                                                                THEN atci.total_spc
                                            ELSE atdi.total_spc
                                        END 
              ELSE atei.total_spc
          END,
         ''
         ) totar
, '' atlfsl_vrfc_yn
, '' atlfsl_vrfc_day
, '' reg_id
, IFNULL(REPLACE(pi2.REG_DT,CONCAT(CHAR(10)), ''), '') reg_dt
, '' mdfcn_id
, IFNULL(REPLACE(pi2.UPDT_DT,CONCAT(CHAR(10)), ''), '') mdfcn_dt
, '' land_area
, '' qota_area
, '' use_inspct_day
, '' bldg_usg_cd
, '' lndr_se_cd
, '' ktchn_se_cd
, '' btr_se_cd
, '' blcn_estn_yn
, '' power_vl
, '' room_one_cnt
, '' room_two_cnt
, '' room_three_cnt
, '' room_four_cnt
, '' expitm_nm
, '' elvtr_yn
, '' drc_crtr_nm
, '' now_tpbiz_nm
, '' rcmdtn_usg_one_nm
, '' rcmdtn_usg_two_nm
, '' house_area
, '' house_area_pyeong
, '' sopsrt_area
, '' sopsrt_area_pyeong
, '' ofc_area
, '' ofc_area_pyeong
, '' sale_se_cd
, '' flr_hg_vl
, '' nearby_road_vl
, '' bdst_usg_cd
, '' biz_step_cd
, '' slctn_bldr_nm
, '' expect_sply_area
, '' expect_sply_area_pyeong
, '' expect_hh_cnt
, '' zone_tot_area
, '' zone_tot_area_pyeong
, '' expect_fart
, '' btl_rt
, '' reg_rentbzmn_yn
, '' atlfsl_usg_cd
, '' atlfsl_se_cd
, '' atlfsl_lct_cd
, '' atlfsl_strct_cd
  into outfile '/var/lib/mysql/backup/product_info_openrowset.txt'
        FIELDS TERMINATED BY '||' ESCAPED BY ''
        LINES TERMINATED BY '\n'
  from hanbang.product_info pi2 
       left join hanbang.article_type_ab_info atai
                    on atai.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_c_info atci
                    on atci.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_d_info atdi
                    on atdi.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_ef_info atei
                    on atei.PRODUCT_NO = pi2.PRODUCT_NO
 where pi2.PRODUCT_CATE_CD not in ('03', '04') -- 주상복합, 주상복합분양권 제외
   AND pi2.REALTOR_NO != 0
 LIMIT 10000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_atlfsl_cfr_fclt_info => into 방법
WITH bsc AS
( 
select
  IFNULL(REPLACE(pi2.PRODUCT_NO,CONCAT(CHAR(10)), ''), '') atlfsl_bsc_info_pk 
  from hanbang.product_info pi2 
       left join hanbang.article_type_ab_info atai
                    on atai.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_c_info atci
                    on atci.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_d_info atdi
                    on atdi.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_ef_info atei
                    on atei.PRODUCT_NO = pi2.PRODUCT_NO
 where pi2.PRODUCT_CATE_CD not in ('03', '04') -- 주상복합, 주상복합분양권 제외
   AND pi2.REALTOR_NO != 0
) 
SELECT
  IFNULL(REPLACE(fi.FACILITES_NO,CONCAT(CHAR(10)), ''), '') atlfsl_cfr_fclt_info_pk
, IFNULL(REPLACE(fi.PRODUCT_NO,CONCAT(CHAR(10)), ''), '') atlfsl_bsc_info_pk
, IFNULL(REPLACE(fi.HEAT,CONCAT(CHAR(10)), ''), '') heat_mthd_cd_list
, IFNULL(REPLACE(fi.FUEL,CONCAT(CHAR(10)), ''), '') heat_fuel_cd_list
, IFNULL(REPLACE(fi.AIRCON,CONCAT(CHAR(10)), ''), '') arclng_fclt_cd_list
, IFNULL(REPLACE(fi.LIFE,CONCAT(CHAR(10)), ''), '') lvlh_fclt_cd_list
, IFNULL(REPLACE(fi.SECURITY,CONCAT(CHAR(10)), ''), '') scrty_fclt_cd_list
, IFNULL(REPLACE(fi.ETC,CONCAT(CHAR(10)), ''), '') etc_fclt_cd_list
, IFNULL(REPLACE(fi.COLD_CD,CONCAT(CHAR(10)), ''), '') arclng_mthd_cd_list
, IFNULL(REPLACE(fi.REG_DT,CONCAT(CHAR(10)), ''), '') reg_dt
, IFNULL(REPLACE(fi.UPDT_DT,CONCAT(CHAR(10)), ''), '') mdfcn_dt
  INTO OUTFILE '/var/lib/mysql/backup/facilities_info.txt'
       FIELDS TERMINATED BY '||' ESCAPED BY ''
       LINES TERMINATED BY '\n'
  FROM bsc
       INNER JOIN
       hanbang.facilities_info fi
               ON atlfsl_bsc_info_pk = fi.PRODUCT_NO
 LIMIT 10000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_atlfsl_dlng_info => into 방법
WITH bsc AS
( 
select 
  IFNULL(REPLACE(pi2.PRODUCT_NO,CONCAT(CHAR(10)), ''), '') atlfsl_bsc_info_pk 
  from hanbang.product_info pi2 
       left join hanbang.article_type_ab_info atai
                    on atai.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_c_info atci
                    on atci.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_d_info atdi
                    on atdi.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_ef_info atei
                    on atei.PRODUCT_NO = pi2.PRODUCT_NO
 where pi2.PRODUCT_CATE_CD not in ('03', '04') -- 주상복합, 주상복합분양권 제외
   AND REALTOR_NO != 0
) 
select 
  IFNULL(REPLACE(ti.TRADE_NO,CONCAT(CHAR(10)), ''), '') atlfsl_dlng_info_pk
, IFNULL(REPLACE(ti.PRODUCT_NO,CONCAT(CHAR(10)), ''), '') atlfsl_bsc_info_pk
, IFNULL(REPLACE(ti.TRADE_TYPE,CONCAT(CHAR(10)), ''), '') dlng_se_cd
, IFNULL(REPLACE(ti.DEAL_PRICE,CONCAT(CHAR(10)), ''), '') trde_amt
, IFNULL(REPLACE(ti.DEPOSIT_PRICE,CONCAT(CHAR(10)), ''), '') lfsts_amt
, IFNULL(REPLACE(ti.RENTAL_PRICE,CONCAT(CHAR(10)), ''), '') mtht_amt
, IFNULL(REPLACE(ti.LOAN_PRICE,CONCAT(CHAR(10)), ''), '') financ_amt
, IFNULL(REPLACE(ti.AL_DEPOSIT_PRICE,CONCAT(CHAR(10)), ''), '') now_lfsts_amt
, IFNULL(REPLACE(ti.AL_RENTAL_PRICE,CONCAT(CHAR(10)), ''), '') now_mtht_amt
, IFNULL(REPLACE(ti.PREM_PRICE,CONCAT(CHAR(10)), ''), '') premium
, IFNULL(REPLACE(ti.REG_DT,CONCAT(CHAR(10)), ''), '') reg_dt
, IFNULL(REPLACE(ti.UPDT_DT,CONCAT(CHAR(10)), ''), '') mdfcn_dt
, '' mng_amt
, '' fclt_amt
, '' pay_amt
, '' mdstrm_amt_int_se_cd
, '' rl_invt_amt
, '' nintr_moving_amt
, '' int_moving_amt
into outfile '/var/lib/mysql/backup/trade_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM bsc
       INNER JOIN
       hanbang.trade_info ti
               ON atlfsl_bsc_info_pk = ti.PRODUCT_NO
 LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_atlfsl_etc_info => into 방법
WITH bsc AS
( 
select 
  IFNULL(REPLACE(pi2.PRODUCT_NO,CONCAT(CHAR(10)), ''), '') atlfsl_bsc_info_pk 
  from hanbang.product_info pi2 
       left join hanbang.article_type_ab_info atai
                    on atai.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_c_info atci
                    on atci.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_d_info atdi
                    on atdi.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_ef_info atei
                    on atei.PRODUCT_NO = pi2.PRODUCT_NO
 where pi2.PRODUCT_CATE_CD not in ('03', '04') -- 주상복합, 주상복합분양권 제외
   AND pi2.REALTOR_NO != 0
)
select
  IFNULL(REPLACE(ei.ETC_NO,CONCAT(CHAR(10)), ''), '') atlfsl_etc_info_pk
, IFNULL(REPLACE(ei.PRODUCT_NO,CONCAT(CHAR(10)), ''), '') atlfsl_bsc_info_pk
, IFNULL(REPLACE(ei.MVI_TYPE_CD,CONCAT(CHAR(10)), ''), '') mvn_se_cd
, IFNULL(REPLACE(ei.MVI_MONTH_CNT,CONCAT(CHAR(10)), ''), '') mvn_psblty_wthn_month_cnt
, IFNULL(REPLACE(ei.MVI_AFTER_YM,CONCAT(CHAR(10)), ''), '') mvn_psblty_aftr_ym
, IFNULL(REPLACE(ei.MVI_DSC_PSBL_YN,CONCAT(CHAR(10)), ''), '') mvn_cnsltn_psblty_yn
, IFNULL(REPLACE(ei.FEATURE,CONCAT(CHAR(10)), ''), '') atlfsl_sfe_expln_cn
, IFNULL(REPLACE(ei.FROAD_YN,CONCAT(CHAR(10)), ''), '') entry_road_yn
, IFNULL(REPLACE(ei.ATCL_DESC,CONCAT(CHAR(10)), ''), '') atlfsl_expln_cn
, IFNULL(REPLACE(ei.REG_DT,CONCAT(CHAR(10)), ''), '') reg_dt
, IFNULL(REPLACE(ei.UPDT_DT,CONCAT(CHAR(10)), ''), '') mdfcn_dt
into outfile '/var/lib/mysql/backup/etc_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM bsc
       INNER JOIN
       hanbang.etc_info ei
               ON atlfsl_bsc_info_pk = ei.PRODUCT_NO
 LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_atlfsl_img_info => into 방법
WITH bsc AS
( 
select 
  IFNULL(REPLACE(pi2.PRODUCT_NO,CONCAT(CHAR(10)), ''), '') atlfsl_bsc_info_pk 
  from hanbang.product_info pi2 
       left join hanbang.article_type_ab_info atai
                    on atai.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_c_info atci
                    on atci.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_d_info atdi
                    on atdi.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_ef_info atei
                    on atei.PRODUCT_NO = pi2.PRODUCT_NO
 where pi2.PRODUCT_CATE_CD not in ('03', '04') -- 주상복합, 주상복합분양권 제외
   AND pi2.REALTOR_NO != 0
)
SELECT
  ROW_NUMBER () OVER (ORDER BY pii.PRODUCT_NO, pii.IMG_SEQ, pii.IMG_TYPE) atlfsl_img_info_pk
, IFNULL(REPLACE(pii.PRODUCT_NO,CONCAT(CHAR(10)), ''), '') atlfsl_bsc_info_pk
, IFNULL(REPLACE(pii.IMG_SEQ,CONCAT(CHAR(10)), ''), '') img_sn
, IFNULL(REPLACE(pii.IMG_TYPE,CONCAT(CHAR(10)), ''), '') img_ty_cd
, IFNULL(REPLACE(pii.IMG_FILE_NAME,CONCAT(CHAR(10)), ''), '') img_file_nm
, IFNULL(REPLACE(pii.IMG_DESC,CONCAT(CHAR(10)), ''), '') img_expln_cn
, IFNULL(REPLACE(pii.IMG_URL_TH,CONCAT(CHAR(10)), ''), '') img_url
, IFNULL(REPLACE(pii.IMG_URL_MTH,CONCAT(CHAR(10)), ''), '') thumb_img_url
, IFNULL(REPLACE(pii.IMG_URL_ORG,CONCAT(CHAR(10)), ''), '') orgnl_img_url
, IFNULL(REPLACE(pii.ORDER_STR,CONCAT(CHAR(10)), ''), '') img_sort_ordr
into outfile '/var/lib/mysql/backup/product_img_info.txt'
        FIELDS TERMINATED BY '||' ESCAPED BY ''
        LINES TERMINATED BY '\n'
  FROM hanbang.product_img_info pii
       INNER JOIN
       bsc
               ON atlfsl_bsc_info_pk = pii.PRODUCT_NO
 LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_atlfsl_inqry_info => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_atlfsl_land_usg_info => into 방법
WITH bsc AS ( 
select 
  IFNULL(REPLACE(pi2.PRODUCT_NO,CONCAT(CHAR(10)), ''), '') atlfsl_bsc_info_pk 
  from hanbang.product_info pi2 
       left join hanbang.article_type_ab_info atai
                    on atai.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_c_info atci
                    on atci.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_d_info atdi
                    on atdi.PRODUCT_NO = pi2.PRODUCT_NO 
       left join hanbang.article_type_ef_info atei
                    on atei.PRODUCT_NO = pi2.PRODUCT_NO
 where pi2.PRODUCT_CATE_CD not in ('03', '04') -- 주상복합, 주상복합분양권 제외
   AND pi2.REALTOR_NO != 0
)
select 
  IFNULL(REPLACE(gi.GRND_NO,CONCAT(CHAR(10)), ''), '') atlfsl_bsc_info_pk
, IFNULL(REPLACE(gi.PRODUCT_NO,CONCAT(CHAR(10)), ''), '') atlfsl_bsc_info_pk
, IFNULL(REPLACE(gi.USG_AREA_TYPE,CONCAT(CHAR(10)), ''), '') usg_rgn_se_cd
, IFNULL(REPLACE(gi.CNTRY_USE_YN,CONCAT(CHAR(10)), ''), '') trit_utztn_yn
, IFNULL(REPLACE(gi.CITY_PLAN_YN,CONCAT(CHAR(10)), ''), '') ctypln_yn
, IFNULL(REPLACE(gi.BLDG_ALW_YN,CONCAT(CHAR(10)), ''), '') arch_prmsn_yn
, IFNULL(REPLACE(gi.GRND_TRAD_ALW_YN,CONCAT(CHAR(10)), ''), '') land_dlng_prmsn_yn
, IFNULL(REPLACE(gi.REG_DT,CONCAT(CHAR(10)), ''), '') reg_dt
, IFNULL(REPLACE(gi.UPDT_DT,CONCAT(CHAR(10)), ''), '') mdfcn_dt
, '' ldcg_cd
, '' ldcg_nm
, '' usg_rgn_one_cd
, '' usg_rgn_two_cd
, '' now_usg_rgn_nm
into outfile '/var/lib/mysql/backup/grnd_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.grnd_info gi
       INNER JOIN
       bsc 
               ON atlfsl_bsc_info_pk = gi.PRODUCT_NO
 LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_atlfsl_thema_info => into 방법
SELECT ROW_NUMBER() OVER(ORDER BY B.product_no, B.COMMA_CNT) atlfsl_thema_info_pk
     , B.product_no atlfsl_bsc_info_pk
     , CASE WHEN B.COMMA_CNT = 1 THEN IFNULL(REPLACE(CAST(B.DATA AS int),CONCAT(CHAR(10)), ''), '') 
            ELSE IFNULL(REPLACE(CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(B.DATA, ',', S.the_no), ',', -1)) AS int),CONCAT(CHAR(10)), ''), '')
        END thema_info_pk
     , '' reg_id
     , '' reg_dt
     , '' mdfcn_id
     , '' mdfcn_dt
  into outfile '/var/lib/mysql/backup/product_thema.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM (SELECT A.product_no
             , CASE WHEN A.DATA LIKE '%,%'
                                THEN (LENGTH(A.DATA) - LENGTH(REPLACE(A.DATA, ',', ''))) / LENGTH(',') + 1
                    WHEN LENGTH(A.DATA) = 3
                                THEN 1
                    ELSE 0
               END AS COMMA_CNT -- 콤마의 개수
             , A.DATA
             , RANK() OVER(PARTITION BY A.product_no ORDER BY A.DATA) AS the_no
          FROM (SELECT pi2.product_no
                     , THEME_CDS AS DATA
                  FROM product_info pi2
                       left join 
                       hanbang.article_type_ab_info atai
                              on atai.PRODUCT_NO = pi2.PRODUCT_NO 
                       left join 
                       hanbang.article_type_c_info atci
                              on atci.PRODUCT_NO = pi2.PRODUCT_NO 
                       left join 
                       hanbang.article_type_d_info atdi
                              on atdi.PRODUCT_NO = pi2.PRODUCT_NO 
                       left join 
                       hanbang.article_type_ef_info atei
                              on atei.PRODUCT_NO = pi2.PRODUCT_NO
                 where pi2.PRODUCT_CATE_CD not in ('03', '04') -- 주상복합, 주상복합분양권 제외
                ) A
       ) B
       INNER JOIN 
       (SELECT CAST(seq AS INT) as the_no
          FROM seq_1_to_74
       ) S
               ON (S.the_no <= B.COMMA_CNT)
 ORDER BY 1, 2, 3
 LIMIT 10000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_author => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_banner_info => into 방법




/*------------------------------------------------------------------------------------------------------------------------------------*/
-- board_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- board_comment => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_cnrs_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_code => into 방법
/*대분류*/
select 
  ROW_NUMBER () OVER(ORDER BY GUBUN, grd_cd, code) code_pk
, ROW_NUMBER () OVER(ORDER BY GUBUN, grd_cd) parnts_code_pk
, IFNULL(REPLACE(concat(GUBUN,code),CONCAT(CHAR(10)), ''), '') code
, IFNULL(REPLACE(CODE_NM,CONCAT(CHAR(10)), ''), '') code_nm 
, IFNULL(REPLACE(CODE_VAL,CONCAT(CHAR(10)), ''), '') sort_ordr
, IFNULL(REPLACE(STAT,CONCAT(CHAR(10)), ''), '') use_at
, '' regist_id
, '' regist_dt
, '' updt_id
, '' updt_dt
, IFNULL(REPLACE(CODE_DESC,CONCAT(CHAR(10)), ''), '') rm_cn
, IFNULL(REPLACE(concat(GUBUN,code),CONCAT(CHAR(10)), ''), '') parent_code
  into outfile '/var/lib/mysql/backup/com_code_dea.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM (SELECT * FROM hanbang.com_code union
        SELECT 'H', '000', '710', '두레_가입_형태', null, null, 'Y', null union
        SELECT 'H', '000', '720', '두레_게시판_형태', null, null, 'Y', null union
        SELECT 'H', '000', '721', '매물_용도', null, null, 'Y', null union
        SELECT 'H', '000', '820', '건축물_용도', null, null, 'Y', NULL) a
 WHERE grd_cd = '000'
   AND concat(GUBUN, code) != 'A170'
 ORDER BY 1, 2
 LIMIT 100000000;

/*소분류*/
select 
  ROW_NUMBER () OVER(ORDER BY GUBUN, grd_cd) + 71 code_pk
, DENSE_RANK () OVER(ORDER BY GUBUN, grd_cd) parnts_code_pk
, IFNULL(REPLACE(CODE,CONCAT(CHAR(10)), ''), '') code
, IFNULL(REPLACE(CODE_NM,CONCAT(CHAR(10)), ''), '') code_nm
, IFNULL(REPLACE(CODE_VAL,CONCAT(CHAR(10)), ''), '') sort_ordr
, IFNULL(REPLACE(STAT,CONCAT(CHAR(10)), ''), '') use_at
, '' regist_id
, '' regist_dt
, '' updt_id
, '' updt_dt
, IFNULL(REPLACE(CODE_DESC,CONCAT(CHAR(10)), ''), '') rm_cn
, IFNULL(REPLACE(concat(GUBUN, grd_cd),CONCAT(CHAR(10)), ''), '') parent_code
  into outfile '/var/lib/mysql/backup/com_code_so.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.com_code
 WHERE grd_cd != '000'
   AND concat(GUBUN, grd_cd) != 'A170'
 ORDER BY 1, 2
 LIMIT 100000000;

/*
1. mssql에서도 이관할 데이터가 존재
 => mssql_export.sql 파일에서 mssql_com_code.txt 파일 생성
*/



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_crtfc_tmpr => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_ctpv_cd => bulk 방법
select 
  IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '') ctpv_cd_pk
, IFNULL(REPLACE(SIDO_NAME,CONCAT(CHAR(10)), ''), '') ctpv_nm
, IFNULL(REPLACE(SIDO_NAME_ALIAS,CONCAT(CHAR(10)), ''), '') ctpv_abbrev_nm
, '' ctpv_crdnt
, '' reg_id
, '' reg_dt
, '' mdfcn_id
, '' mdfcn_dt
into outfile '/var/lib/mysql/backup/sido_code.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
FROM hanbang.sido_code 
LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_device_info => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_device_ntcn_mapng_info => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_device_stng_info => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_emd_li_cd => bulk 방법
select
  IFNULL(REPLACE(DONG_NO,CONCAT(CHAR(10)), ''), '') emd_li_cd_pk
, IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '') ctpv_cd_pk
, IFNULL(REPLACE(GUGUN_NO,CONCAT(CHAR(10)), ''), '') sgg_cd_pk
, IFNULL(REPLACE(DONG_NAME,CONCAT(CHAR(10)), ''), '') emd_li_nm
, IFNULL(REPLACE(DONG_NAME_DISP,CONCAT(CHAR(10)), ''), '') all_emd_li_nm
, CASE WHEN json_extract(GEOCODE, '$.lng') = 'null' 
            THEN ''
       ELSE IFNULL(REPLACE(IFNULL(REPLACE(concat('point(', json_extract(GEOCODE, '$.lng'), ' ', json_extract(GEOCODE, '$.lat'), ')'),CONCAT(CHAR(10)), ''), ''),CONCAT(CHAR(10)), ''), '')
  END emd_li_crdnt
, IFNULL(REPLACE(DONG_GBN,CONCAT(CHAR(10)), ''), '') stdg_dong_se_cd
, IFNULL(REPLACE(JUNGBU_CODE,CONCAT(CHAR(10)), ''), '') stdg_dong_cd
, '' reg_id
, '' reg_dt
, '' mdfcn_id
, '' mdfcn_dt
  into outfile '/var/lib/mysql/backup/dong_code_openrowset.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.dong_code 
 LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_error_log => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_faq => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_file => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_file_mapng => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_group => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_group_author => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_gtwy_svc => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_gtwy_svc_author => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_job_schdl_hstry => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_job_schdl_info => bulk 방법
/*
mssql에서 전체 가져오기
운영에서 time_stamp 최대값 업데이트 하기
*/


WITH cron_timestamp AS
(
SELECT 
	  'sidoBatch' AS "CRON_NAME"
	, max(SYS_TIMESTAMP) AS "timestamp"
  from sido_code
 union
SELECT 
	  'gugunBatch' AS "CRON_NAME"
	, max(SYS_TIMESTAMP) AS "timestamp"
  from gugun_code
 union
SELECT 
	  'dongBatch' AS "CRON_NAME"
	, max(SYS_TIMESTAMP) AS "timestamp"
  from dong_code
 union
SELECT 
	  'comCodeBatch' AS "CRON_NAME"
	, max(SYS_TIMESTAMP) AS "timestamp"
  from com_code
 union 
SELECT 
	  'danjiBatch' AS "CRON_NAME"
	, max(SYS_TIMESTAMP) AS "timestamp"
  from danji_info
 union
SELECT 
	  'danjiDetailBatch' AS "CRON_NAME"
	, max(SYS_TIMESTAMP) AS "timestamp"
  from danji_detail_info
 UNION
SELECT 
	  'officeBatch' AS "CRON_NAME"
	, max(SYS_TIMESTAMP) AS "timestamp"
  from realtor_info
 UNION
SELECT 
	  'lttotBatch' AS "CRON_NAME"
	, max(SYS_TIMESTAMP) AS "timestamp"
  from bunyang_info
)
SELECT *
  INTO OUTFILE '/var/lib/mysql/backup/timestamp_update.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM cron_timestamp;


/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_login_hist => bulk 방법




/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_menu => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_menu_author => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_notice => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_ntcn_info => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_push_meta_info => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_qna => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_recsroom => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_rss_info => bulk 방법
/*mssql에서 전체 가져오기*/



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_scrin => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_scrin_author => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_sgg_cd => bulk 방법
select 
  IFNULL(REPLACE(GUGUN_NO,CONCAT(CHAR(10)), ''), '') sgg_cd_pk
, IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '') ctpv_cd_pk
, IFNULL(REPLACE(GUGUN_NAME,CONCAT(CHAR(10)), ''), '') sgg_nm
, '' sgg_crdnt
, IFNULL(REPLACE(DISP_GBN,CONCAT(CHAR(10)), ''), '') stdg_dong_se_cd
, '' reg_id
, '' reg_dt
, '' mdfcn_id
, '' mdfcn_dt
  into outfile '/var/lib/mysql/backup/gugun_code.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.gugun_code 
 LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_stplat_hist => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_stplat_mapng => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_svc_ip_manage => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_thema_info => bulk 방법
select 
  IFNULL(REPLACE(THEME_NO,CONCAT(CHAR(10)), ''), '') thema_info_pk
, IFNULL(REPLACE(THEME_CDS,CONCAT(CHAR(10)), ''), '') thema_cd
, IFNULL(REPLACE(THEME_NAME,CONCAT(CHAR(10)), ''), '') thema_cd_nm
, IFNULL(REPLACE(THEME_SUBNAME,CONCAT(CHAR(10)), ''), '') thema_cn
, IFNULL(REPLACE(THEME_URL_ADDRESS,CONCAT(CHAR(10)), ''), '') img_url
, IFNULL(REPLACE(IMG_DESC,CONCAT(CHAR(10)), ''), '') img_sort_ordr
, IFNULL(REPLACE(THEME_USE_YN,CONCAT(CHAR(10)), ''), '') use_yn
, IFNULL(REPLACE(CRE_USER,CONCAT(CHAR(10)), ''), '') reg_id
, IFNULL(REPLACE(CRE_DATETIME,CONCAT(CHAR(10)), ''), '') reg_dt
, IFNULL(REPLACE(UPD_USER,CONCAT(CHAR(10)), ''), '') mdfcn_id
, IFNULL(REPLACE(UPD_DATETIME,CONCAT(CHAR(10)), ''), '') mdfcn_dt
, '' rprs_yn
, '' atlfsl_reg_use_yn
  into outfile '/var/lib/mysql/backup/theme_info.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.theme_info 
 LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_user => bulk 방법
/*user_info*/
select 
  IFNULL(REPLACE(mem_no,CONCAT(CHAR(10)), ''), '') user_no_pk
, IFNULL(REPLACE(mem_no,CONCAT(CHAR(10)), ''), '') parnts_user_no_pk
, IFNULL(REPLACE(concat(social_type,social_key), CONCAT(CHAR(10)), ''), '') user_id
, IFNULL(REPLACE(user_nm,CONCAT(CHAR(10)), ''), '') user_nm
, '' password
, '' moblphon_no
, IFNULL(REPLACE(user_email,CONCAT(CHAR(10)), ''), '') email
, '03' user_se_code
, '' sbscrb_de
, '' password_change_de
, '' last_login_dt
, '' last_login_ip
, '' error_co
, '' error_dt
, IFNULL(REPLACE(use_yn,CONCAT(CHAR(10)), ''), '') use_at
, '' regist_id
, IFNULL(REPLACE(reg_date, CONCAT(CHAR(10)), ''), '') regist_dt
, '' updt_id
, IFNULL(REPLACE(mod_date,CONCAT(CHAR(10)), ''), '') updt_dt
, '' refresh_tkn_cn
, IFNULL(REPLACE(social_type,CONCAT(CHAR(10)), ''), '') soc_lgn_ty_cd
, IFNULL(REPLACE(mem_img,CONCAT(CHAR(10)), ''), '') user_img_url
, '' lrea_office_nm
, '' lrea_office_info_pk
, '' lrea_brffc_cd
  into outfile '/var/lib/mysql/backup/user_info.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.user_info 
 WHERE length(ifnull(social_key, '')) > 0
 LIMIT 100000000;

/*realtor_info*/
SELECT
  ROW_NUMBER () OVER (ORDER BY REALTOR_NO) + 49001 user_no_pk
, ROW_NUMBER () OVER (ORDER BY REALTOR_NO) + 49001 parnts_user_no_pk
, '' user_id -- 나중에 업데이트
, IFNULL(REPLACE(COMPANY_RSTV_NAME,CONCAT(CHAR(10)), ''), '') user_nm 
, '' password
, IFNULL(REPLACE(REALTOR_PHONE,CONCAT(CHAR(10)), ''), '') moblphon_no
, '' email
, '02' user_se_code
, '' sbscrb_de 
, '' password_change_de 
, '' last_login_dt
, '' last_login_ip
, '' error_co
, '' error_dt
, IFNULL(REPLACE(STAT,CONCAT(CHAR(10)), ''), '') use_at
, '' regist_id
, IFNULL(REPLACE(REG_DT,CONCAT(CHAR(10)), ''), '') regist_dt
, '' updt_id
, IFNULL(REPLACE(UPT_DT,CONCAT(CHAR(10)), ''), '') updt_dt
, '' refresh_tkn_cn
, '' soc_lgn_ty_cd
, IFNULL(REPLACE(REALTOR_PIC1,CONCAT(CHAR(10)), ''), '') user_img_url
, IFNULL(REPLACE(COMPANY_NAME,CONCAT(CHAR(10)), ''), '') lrea_office_nm
, IFNULL(REPLACE(REALTOR_NO,CONCAT(CHAR(10)), ''), '') lrea_office_info_pk
, '' lrea_brffc_cd 
into outfile '/var/lib/mysql/backup/realtor_info_user.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.realtor_info ri 
       INNER JOIN
       (SELECT DISTINCT mem_no 
          FROM hanbang.fav_info 
         WHERE USER_TYPE = 'R'
         UNION
        SELECT DISTINCT mem_no
          FROM hanbang.user_mamul_agent) a
           ON ri.REALTOR_NO = a.mem_no
 ORDER BY 1
 LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_user_author => bulk 방법



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_com_user_group => bulk 방법
/*user_info*/
SELECT
  ROW_NUMBER() OVER (ORDER BY mem_no) com_user_group_pk
, 4 group_no_pk
, IFNULL(REPLACE(mem_no,CONCAT(CHAR(10)), ''), '') user_no_pk
, concat(social_type,social_key) regist_id
, IFNULL(REPLACE(reg_date,CONCAT(CHAR(10)), ''), '') regist_dt
, '' updt_id
, IFNULL(REPLACE(mod_date,CONCAT(CHAR(10)), ''), '') updt_dt
  into outfile '/var/lib/mysql/backup/user_info_user_group.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.user_info 
 WHERE length(ifnull(social_key, '')) > 0
 LIMIT 10000000;

/*realtor_info*/
select 
  ROW_NUMBER () OVER (ORDER BY REALTOR_NO) + 48647 com_user_group_pk
, 3 group_no_pk
, ROW_NUMBER () OVER (ORDER BY REALTOR_NO) + 49001 user_no_pk
, '' regist_id
, IFNULL(REPLACE(REG_DT,CONCAT(CHAR(10)), ''), '') regist_dt
, '' updt_id
, IFNULL(REPLACE(UPT_DT,CONCAT(CHAR(10)), ''), '') updt_dt
  into outfile '/var/lib/mysql/backup/realtor_info_user_group.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.realtor_info ri 
       INNER JOIN
       (SELECT DISTINCT mem_no 
          FROM hanbang.fav_info 
         WHERE USER_TYPE = 'R'
         UNION
        SELECT DISTINCT mem_no
          FROM hanbang.user_mamul_agent) a
           ON ri.REALTOR_NO = a.mem_no
 ORDER BY 1
 LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_hsmp_dtl_info => bulk 방법
select
  IFNULL(REPLACE(ddi.DANJI_DETAIL_NO,CONCAT(CHAR(10)), ''), '') hsmp_dtl_info_pk
, IFNULL(REPLACE(ddi.DANJI_NO,CONCAT(CHAR(10)), ''), '') hsmp_info_pk
, IFNULL(REPLACE(ddi.GONG_METER,CONCAT(CHAR(10)), ''), '') sply_area
, IFNULL(REPLACE(ddi.GONG_PYUNG,CONCAT(CHAR(10)), ''), '') sply_area_pyeong
, IFNULL(REPLACE(ddi.PYUNG_TYPE,CONCAT(CHAR(10)), ''), '') pyeong_info
, IFNULL(REPLACE(ddi.JUN_METER,CONCAT(CHAR(10)), ''), '') prvuse_area
, IFNULL(REPLACE(ddi.JUN_PYUNG,CONCAT(CHAR(10)), ''), '') prvuse_area_pyeong
, IFNULL(REPLACE(ddi.CONT_METER,CONCAT(CHAR(10)), ''), '') ctrt_area
, IFNULL(REPLACE(ddi.CONT_PYUNG,CONCAT(CHAR(10)), ''), '') ctrt_area_pyeong
, IFNULL(REPLACE(ddi.DEJI_JIBUN,CONCAT(CHAR(10)), ''), '') dtl_lotno
, IFNULL(REPLACE(ddi.ROOM_CNT,CONCAT(CHAR(10)), ''), '') room_cnt
, IFNULL(REPLACE(ddi.BATH_CNT,CONCAT(CHAR(10)), ''), '') btr_cnt
, IFNULL(REPLACE(ddi.PYUNG_SEDE_CNT,CONCAT(CHAR(10)), ''), '') pyeong_hh_cnt
, IFNULL(REPLACE(ddi.DIRECTION_CD,CONCAT(CHAR(10)), ''), '') drc_cd
, IFNULL(REPLACE(ddi.BAY_CD,CONCAT(CHAR(10)), ''), '') bay_cd
, IFNULL(REPLACE(ddi.STAIR_CD,CONCAT(CHAR(10)), ''), '') stairs_stle_cd
, IFNULL(REPLACE(ddi.URL_DRAWING,CONCAT(CHAR(10)), ''), '') flrpln_url
, IFNULL(REPLACE(ddi.E_URL_DRAWING,CONCAT(CHAR(10)), ''), '') estn_flrpln_url
, IFNULL(REPLACE(ddi.STAT,CONCAT(CHAR(10)), ''), '') use_yn
, '' reg_id
, IFNULL(REPLACE(ddi.REG_DT,CONCAT(CHAR(10)), ''), '') reg_dt
, '' mdfcn_id
, IFNULL(REPLACE(ddi.UPT_DT,CONCAT(CHAR(10)), ''), '') mdfcn_dt
into outfile '/var/lib/mysql/backup/danji_detail_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.danji_detail_info ddi
       INNER JOIN
       hanbang.danji_info di
           ON ddi.DANJI_NO = di.DANJI_NO
 LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_hsmp_info => openrowset 방법
select 
  IFNULL(REPLACE(DANJI_NO,CONCAT(CHAR(10)), ''), '') hsmp_info_pk
, IFNULL(REPLACE(DANJI_NAME,CONCAT(CHAR(10)), ''), '') hsmp_nm
, IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '') ctpv_cd_pk
, IFNULL(REPLACE(GUGUN_NO,CONCAT(CHAR(10)), ''), '') sgg_cd_pk
, IFNULL(REPLACE(DONG_NO,CONCAT(CHAR(10)), ''), '') emd_li_cd_pk
, IFNULL(REPLACE(JIBUN,CONCAT(CHAR(10)), ''), '') lotno
, IFNULL(REPLACE(ROAD_ADDR,CONCAT(CHAR(10)), ''), '') rn_addr
, IFNULL(REPLACE(CNT_TOT_SEDE,CONCAT(CHAR(10)), ''), '') tot_hh_cnt
, IFNULL(REPLACE(CNT_TOT_DONG,CONCAT(CHAR(10)), ''), '') tot_aptcmpl_cnt
, IFNULL(REPLACE(TOP_FLOOR,CONCAT(CHAR(10)), ''), '') flr_cnt
, IFNULL(REPLACE(CNT_TOT_PARK,CONCAT(CHAR(10)), ''), '') tot_parkng_cntom
, IFNULL(REPLACE(CNT_SEDE_PARK,CONCAT(CHAR(10)), ''), '') hh_parkng_cntom
, IFNULL(REPLACE(SIGONGSA,CONCAT(CHAR(10)), ''), '') bldr_nm
, IFNULL(REPLACE(I_YEAR,CONCAT(CHAR(10)), ''), '') cmcn_year
, IFNULL(REPLACE(I_MONTH,CONCAT(CHAR(10)), ''), '') cmcn_mt
, IFNULL(REPLACE(C_YEAR,CONCAT(CHAR(10)), ''), '') compet_year
, IFNULL(REPLACE(C_MONTH,CONCAT(CHAR(10)), ''), '') compet_mt
, IFNULL(REPLACE(WARM_CD,CONCAT(CHAR(10)), ''), '') heat_cd
, IFNULL(REPLACE(FUEL_CD,CONCAT(CHAR(10)), ''), '') fuel_cd
, IFNULL(REPLACE(CATE_CD,CONCAT(CHAR(10)), ''), '') ctgry_cd
, IFNULL(REPLACE(GWAN_TELNO,CONCAT(CHAR(10)), ''), '') mng_office_telno
, IFNULL(REPLACE(BUS,CONCAT(CHAR(10)), ''), '') bus_rte_info
, IFNULL(REPLACE(SUBWAY,CONCAT(CHAR(10)), ''), '') subway_rte_info
, IFNULL(REPLACE(SCHOOL,CONCAT(CHAR(10)), ''), '') schl_info
, IFNULL(REPLACE(SISUL,CONCAT(CHAR(10)), ''), '') cvntl_info
, CASE WHEN GEOCODE NOT LIKE '%0.0%' AND GEOCODE NOT LIKE '%null%'
                    THEN concat('point(', json_value(GEOCODE, '$.lng'), ' ', json_value(GEOCODE, '$.lat'), ')')
       ELSE ''
  END hsmp_crdnt
, CASE WHEN GEOCODE NOT LIKE '%0.0%' AND GEOCODE NOT LIKE '%null%'
                    THEN IFNULL(REPLACE(DANJI_LNG,CONCAT(CHAR(10)), ''), '')
       ELSE ''
  END hsmp_lot
, CASE WHEN GEOCODE NOT LIKE '%0.0%' AND GEOCODE NOT LIKE '%null%'
                    THEN IFNULL(REPLACE(DANJI_LAT,CONCAT(CHAR(10)), ''), '')
       ELSE ''
  END hsmp_lat
, IFNULL(REPLACE(STAT,CONCAT(CHAR(10)), ''), '') use_yn
, '' reg_id
, IFNULL(REPLACE(REG_DT,CONCAT(CHAR(10)), ''), '') reg_dt
, '' mdfcn_id
, IFNULL(REPLACE(UPT_DT,CONCAT(CHAR(10)), ''), '') mdfcn_dt
  into outfile '/var/lib/mysql/backup/danji_info_openrowset.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.danji_info LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_itrst_atlfsl_info => bulk 방법
select 
  ROW_NUMBER () OVER (ORDER BY REG_DT) itrst_atlfsl_info_pk
, CASE WHEN USER_TYPE = 'U' THEN IFNULL(REPLACE(MEM_NO,CONCAT(CHAR(10)), ''), '') 
       ELSE ''
  END user_no_pk
, CASE WHEN USER_TYPE = 'R' THEN IFNULL(REPLACE(MEM_NO,CONCAT(CHAR(10)), ''), '')
       ELSE ''
  END lrea_office_info_pk
, CASE WHEN FAV_CATE_CD = 'P' THEN IFNULL(REPLACE(FAV_SEQ_NO,CONCAT(CHAR(10)), ''), '')
       ELSE ''
  END atlfsl_bsc_info_pk
, CASE WHEN FAV_CATE_CD = 'D' THEN IFNULL(REPLACE(FAV_SEQ_NO,CONCAT(CHAR(10)), ''), '')
       ELSE ''
  END hsmp_info_pk
, CASE WHEN FAV_CATE_CD = 'R' THEN IFNULL(REPLACE(FAV_SEQ_NO,CONCAT(CHAR(10)), ''), '')
       ELSE ''
  END emd_li_cd_pk
, IFNULL(REPLACE(STAT,CONCAT(CHAR(10)), ''), '') use_yn
, '' reg_id
, IFNULL(REPLACE(REG_DT,CONCAT(CHAR(10)), ''), '') reg_dt
, '' mdfcn_id
, IFNULL(REPLACE(UPDT_DT,CONCAT(CHAR(10)), ''), '') mdfcn_dt
, '' rprs_yn
, '' lttot_tbl_se_cd
, '' house_mng_no
  into outfile '/var/lib/mysql/backup/fav_info.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.fav_info 
 WHERE ((USER_TYPE = 'U' AND MEM_NO IN (SELECT mem_no FROM user_info))
       OR 
       (USER_TYPE = 'R' AND MEM_NO IN (SELECT REALTOR_NO FROM realtor_info)))
       AND 
       ((FAV_CATE_CD = 'D' AND FAV_SEQ_NO IN (SELECT danji_no FROM danji_info di))
       OR 
       (FAV_CATE_CD = 'R' AND FAV_SEQ_NO IN (SELECT dong_no FROM dong_code dc))
       OR 
       (FAV_CATE_CD = 'P' AND FAV_SEQ_NO IN (SELECT product_no FROM product_info pi2 WHERE realtor_no != 0)))
LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_link_apt_lttot_cmpet_rt_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_link_apt_lttot_house_ty_dtl_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_link_apt_lttot_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_link_apt_nthg_rank_remndr_hh_lttot_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_link_apt_nthg_rank_remndr_hh_lttot_ty_dtl_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_link_hsmp_area_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_link_hsmp_bsc_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_link_hsmp_managect_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_link_ofctl_cty_prvate_rent_lttot_cmpet_rt_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_link_ofctl_cty_prvate_rent_lttot_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_link_ofctl_cty_prvate_rent_lttot_ty_dtl_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_link_public_sprt_prvate_rent_lttot_cmpet_rt_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_link_remndr_hh_lttot_cmpet_rt_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_link_rtrcn_re_sply_lttot_cmpet_rt_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_link_subway_statn_info => 



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_lrea_office_info => openrowset 방법
select 
  IFNULL(REPLACE(REALTOR_NO,CONCAT(CHAR(10)), ''), '') lrea_office_info_pk
, IFNULL(REPLACE(BIZ_NO,CONCAT(CHAR(10)), ''), '') bzmn_no
, IFNULL(REPLACE(COMPANY_NAME,CONCAT(CHAR(10)), ''), '') lrea_office_nm
, IFNULL(REPLACE(COMPANY_RSTV_NAME,CONCAT(CHAR(10)), ''), '') lrea_office_rprsv_nm
, IFNULL(REPLACE(EXPS_TEL_TYPE,CONCAT(CHAR(10)), ''), '') tlphon_type_cd
, IFNULL(REPLACE(COMPANY_SAFETY_PHONE,CONCAT(CHAR(10)), ''), '') safety_no
, IFNULL(REPLACE(COMPANY_RSTN_PHONE,CONCAT(CHAR(10)), ''), '') lrea_office_rprs_telno
, IFNULL(REPLACE(REALTOR_PHONE,CONCAT(CHAR(10)), ''), '') lrea_telno
, IFNULL(REPLACE(COMPANY_ADDR,CONCAT(CHAR(10)), ''), '') lrea_office_addr
, IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '') ctpv_cd_pk
, IFNULL(REPLACE(GUGUN_NO,CONCAT(CHAR(10)), ''), '') sgg_cd_pk
, IFNULL(REPLACE(DONG_NO,CONCAT(CHAR(10)), ''), '') stdg_innb
, IFNULL(REPLACE(HDONG_NO,CONCAT(CHAR(10)), ''), '') dong_innb
, IFNULL(REPLACE(USER_LEVEL,CONCAT(CHAR(10)), ''), '') user_level_no
, IFNULL(REPLACE(REALTOR_PIC1,CONCAT(CHAR(10)), ''), '') rprs_img_one_url
, IFNULL(REPLACE(REALTOR_PIC2,CONCAT(CHAR(10)), ''), '') rprs_img_two_url
, IFNULL(REPLACE(REALTOR_PIC3,CONCAT(CHAR(10)), ''), '') rprs_img_three_url
, CASE WHEN COMPANY_GEOCODE NOT LIKE '%null%' AND COMPANY_GEOCODE NOT LIKE '%0.0%'
                            THEN IFNULL(REPLACE(REALTOR_LAT,CONCAT(CHAR(10)), ''), '')
       ELSE ''
  END lat
, CASE WHEN COMPANY_GEOCODE NOT LIKE '%null%' AND COMPANY_GEOCODE NOT LIKE '%0.0%'
                            THEN IFNULL(REPLACE(REALTOR_LNG,CONCAT(CHAR(10)), ''), '')
       ELSE ''
  END lot
, IFNULL(REPLACE(MEM_TYPE_CD,CONCAT(CHAR(10)), ''), '') user_ty_cd
, IFNULL(REPLACE(STATUS_CODE,CONCAT(CHAR(10)), ''), '') stts_cd
, IFNULL(REPLACE(STAT,CONCAT(CHAR(10)), ''), '') use_yn
, CASE WHEN COMPANY_GEOCODE NOT LIKE '%null%' AND COMPANY_GEOCODE NOT LIKE '%0.0%'
                            THEN IFNULL(REPLACE(concat('point(', json_extract(COMPANY_GEOCODE, '$.lng'), ' ', json_extract(COMPANY_GEOCODE, '$.lat'), ')'), CONCAT(CHAR(10)), ''), '')
       ELSE ''
  END lrea_office_crdnt
, IFNULL(REPLACE(HOMEPAGE,CONCAT(CHAR(10)), ''), '') hmpg_url
, '' reg_id
, IFNULL(REPLACE(REG_DT,CONCAT(CHAR(10)), ''), '') reg_dt
, '' mdfcn_id
, IFNULL(REPLACE(UPT_DT,CONCAT(CHAR(10)), ''), '') mdfcn_dt
, '' lrea_office_intrcn_cn
, '' eml 
, '' lrea_grd_cd
, '' estbl_reg_no
into outfile '/var/lib/mysql/backup/realtor_info_openrowset.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.realtor_info 
 LIMIT 100000000;


SELECT * FROM realtor_info ri;
/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_lttot_info => 
select 
  IFNULL(REPLACE(BUNYANG_NO,CONCAT(CHAR(10)), ''), '') lttot_info_pk
, IFNULL(REPLACE(BUNYANG_SUBJECT,CONCAT(CHAR(10)), ''), '') lttot_info_ttl_nm
, IFNULL(REPLACE(BUNYANG_CONTENT,CONCAT(CHAR(10)), ''), '') lttot_info_cn
, IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '') ctpv_cd_pk
, IFNULL(REPLACE(SIDO_NAME,CONCAT(CHAR(10)), ''), '') ctpv_nm
, IFNULL(REPLACE(GUGUN_NO,CONCAT(CHAR(10)), ''), '') sgg_cd_pk
, IFNULL(REPLACE(GUGUN_NAME,CONCAT(CHAR(10)), ''), '') sgg_nm
, IFNULL(REPLACE(DONG_NO,CONCAT(CHAR(10)), ''), '') emd_li_cd_pk
, IFNULL(REPLACE(DONG_NAME,CONCAT(CHAR(10)), ''), '') all_emd_li_nm
, IFNULL(REPLACE(ADDR_DETAIL,CONCAT(CHAR(10)), ''), '') dtl_addr
, IFNULL(REPLACE(BIZ_SIZE,CONCAT(CHAR(10)), ''), '') sply_scale_cn
, IFNULL(REPLACE(PRIVATE_AREA,CONCAT(CHAR(10)), ''), '') sply_house_area_cn
, IFNULL(REPLACE(PARCEL_PRICE,CONCAT(CHAR(10)), ''), '') lttot_pc_cn
, IFNULL(REPLACE(RECRUIT_DATE,CONCAT(CHAR(10)), ''), '') rcrit_pbanc_day
, IFNULL(REPLACE(APP_DATE,CONCAT(CHAR(10)), ''), '') subscrpt_rcpt_day_list
, IFNULL(REPLACE(PRIZE_WIN_DATE,CONCAT(CHAR(10)), ''), '') przwner_prsntn_day
, IFNULL(REPLACE(MOVE_IN_DATE,CONCAT(CHAR(10)), ''), '') mvn_prnmnt_day
, IFNULL(REPLACE(CONTRACT_DATE,CONCAT(CHAR(10)), ''), '') ctrt_pd
, IFNULL(REPLACE(BUILDER,CONCAT(CHAR(10)), ''), '') bldr_nm
, IFNULL(REPLACE(OPEN_HOUSES,CONCAT(CHAR(10)), ''), '') mdlhs_opnng_day
, IFNULL(REPLACE(PRESALE_INQUIRY,CONCAT(CHAR(10)), ''), '') lttot_inqry_info_cn
, IFNULL(REPLACE(COMFORTS,CONCAT(CHAR(10)), ''), '') cvntl_info_cn
, IFNULL(REPLACE(TRAFFIC_ENV,CONCAT(CHAR(10)), ''), '') trnsport_envrn_info_cn
, IFNULL(REPLACE(EDU_ENV,CONCAT(CHAR(10)), ''), '') edu_envrn_info_cn
, IFNULL(REPLACE(IMG_URL,CONCAT(CHAR(10)), ''), '') img_url
, IFNULL(REPLACE(INPUT_USER,CONCAT(CHAR(10)), ''), '') reg_id
, IFNULL(REPLACE(REG_DATE,CONCAT(CHAR(10)), ''), '') reg_dt
, '' mdfcn_id
, '' mdfcn_dt
into outfile '/var/lib/mysql/backup/bunyang_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.bunyang_info 
 LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_user_atlfsl_img_info => bulk 방법
select 
  ROW_NUMBER () OVER (ORDER BY regdate) user_atlfsl_img_info_pk
, IFNULL(REPLACE(mm_no,CONCAT(CHAR(10)), ''), '') user_atlfsl_info_pk
, IFNULL(REPLACE(seq,CONCAT(CHAR(10)), ''), '') sort_ordr
, IFNULL(REPLACE(file_title,CONCAT(CHAR(10)), ''), '') img_file_nm
, IFNULL(REPLACE(file_url,CONCAT(CHAR(10)), ''), '') img_url
, IFNULL(REPLACE(thumb_url,CONCAT(CHAR(10)), ''), '') thumb_img_url
, IFNULL(REPLACE(file_nm_server,CONCAT(CHAR(10)), ''), '') srvr_img_file_nm
, IFNULL(REPLACE(file_nm_user,CONCAT(CHAR(10)), ''), '') local_img_file_nm
, IFNULL(REPLACE(file_nm_thumb,CONCAT(CHAR(10)), ''), '') thumb_img_file_nm
, '' reg_id
, IFNULL(REPLACE(regdate,CONCAT(CHAR(10)), ''), '') reg_dt
, '' mdfcn_id
, '' mdfcn_dt
  into outfile '/var/lib/mysql/backup/user_mamul_photo.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.user_mamul_photo
 WHERE mm_no IN (SELECT mm_no
                   FROM user_mamul um
                        INNER JOIN 
                        user_info ui
                           ON um.user_no=ui.mem_no)
 LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_user_atlfsl_info => bulk 방법
select 
  IFNULL(REPLACE(mm_no,CONCAT(CHAR(10)), ''), '') user_atlfsl_info_pk
, IFNULL(REPLACE(user_no,CONCAT(CHAR(10)), ''), '') user_no_pk
, IFNULL(REPLACE(agent_cnt,CONCAT(CHAR(10)), ''), '') preocupy_lrea_cnt
, IFNULL(REPLACE(cate_cd,CONCAT(CHAR(10)), ''), '') atlfsl_knd_cd
, IFNULL(REPLACE(gure_cd,CONCAT(CHAR(10)), ''), '') dlng_se_cd
, IFNULL(REPLACE(state_cd,CONCAT(CHAR(10)), ''), '') atlfsl_stts_cd
, IFNULL(REPLACE(sido_no,CONCAT(CHAR(10)), ''), '') ctpv_cd_pk
, IFNULL(REPLACE(sido_no_nm,CONCAT(CHAR(10)), ''), '') ctpv_nm
, IFNULL(REPLACE(gugun_no,CONCAT(CHAR(10)), ''), '') sgg_cd_pk
, IFNULL(REPLACE(gugun_no_nm,CONCAT(CHAR(10)), ''), '') sgg_nm
, IFNULL(REPLACE(dong_no,CONCAT(CHAR(10)), ''), '') emd_li_cd_pk
, IFNULL(REPLACE(dong_no_nm,CONCAT(CHAR(10)), ''), '') all_emd_li_nm
, CASE WHEN LENGTH(BON_NO)<=4 THEN IFNULL(REPLACE(BON_NO,CONCAT(CHAR(10)), ''), '') ELSE '' END mno
, CASE WHEN LENGTH(BU_NO)<=4 THEN IFNULL(REPLACE(BU_NO,CONCAT(CHAR(10)), ''), '') ELSE '' END sno
, IFNULL(REPLACE(coor_lat,CONCAT(CHAR(10)), ''), '') lat
, IFNULL(REPLACE(coor_lng,CONCAT(CHAR(10)), ''), '') lot
, IFNULL(REPLACE(cost_fr,CONCAT(CHAR(10)), ''), '') trde_pc
, IFNULL(REPLACE(amt_guar_to,CONCAT(CHAR(10)), ''), '') lfsts_pc
, IFNULL(REPLACE(amt_month_to,CONCAT(CHAR(10)), ''), '') mtht_yyt_pc
, IFNULL(REPLACE(room_cnt_to,CONCAT(CHAR(10)), ''), '') room_cnt
, '' btr_cnt
, IFNULL(REPLACE(open_type,CONCAT(CHAR(10)), ''), '') lrea_office_atmc_chc_yn
, '' reg_id
, IFNULL(REPLACE(um.reg_date,CONCAT(CHAR(10)), ''), '') reg_dt
, '' mdfcn_id
, IFNULL(REPLACE(um.mod_date,CONCAT(CHAR(10)), ''), '') mdfcn_dt
, '' dtl_addr
, '' del_yn
  INTO outfile '/var/lib/mysql/backup/user_mamul.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.user_mamul um
       INNER JOIN 
       user_info ui 
          ON um.user_no = ui.mem_no
 LIMIT 100000000;



/*------------------------------------------------------------------------------------------------------------------------------------*/
-- tb_user_atlfsl_preocupy_info => bulk 방법
select 
  ROW_NUMBER () OVER (ORDER BY mm_no, mem_no) user_atlfsl_preocupy_info_pk
, IFNULL(REPLACE(mm_no,CONCAT(CHAR(10)), ''), '') user_atlfsl_info_pk
, IFNULL(REPLACE(mem_no,CONCAT(CHAR(10)), ''), '') lrea_office_info_pk
, IFNULL(REPLACE(is_selected,CONCAT(CHAR(10)), ''), '') preocupy_yn
, '' reg_id
, '' reg_dt
, '' mdfcn_id
, '' mdfcn_dt
  into outfile '/var/lib/mysql/backup/user_mamul_agent.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.user_mamul_agent
 WHERE mm_no IN (SELECT mm_no
                   FROM user_mamul um
                        INNER JOIN 
                        user_info ui
                           ON um.user_no=ui.mem_no
                )
   AND mem_no IN (SELECT realtor_no FROM realtor_info)
 LIMIT 100000000;












