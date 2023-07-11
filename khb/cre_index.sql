/*
인덱스 생성 쿼리문 파일
작성 일시: 230620
수정 일시: 230629
작 성 자 : 조건영
*/

-- 인덱스 쿼리를 만들기 위한 정보(161)
SELECT 
  i.name "index_name"
, ic.index_id 
, ic.index_column_id
, schema_name(o.schema_id) "schema_name" 
, object_name(i.object_id) "table_name"
, c.name "column_name"
, i.type_desc "cluster_se"
, i.is_unique "unique_yn"
  FROM sys.indexes i
       INNER JOIN
       sys.index_columns ic
           ON i.object_id = ic.object_id 
              AND 
              i.index_id = ic.index_id
       INNER JOIN
       sys.columns c
           ON c.object_id = i.object_id
              AND 
              c.column_id = ic.column_id
       INNER JOIN 
       sys.objects o 
           ON o.object_id = c.object_id 
 WHERE object_name(i.object_id) IN (SELECT TABLE_name 
                                      FROM information_schema.tables
                                     WHERE table_schema = 'sc_khb_srv')
--       AND
--       name COLLATE korean_wansung_cs_as LIKE '%pk_%'
 ORDER BY 4, 5;


-- 인덱스 쿼리 스크립트 만들기
WITH index_info AS (
SELECT 
  i.name "index_name"
, ic.index_id 
, ic.index_column_id
, schema_name(o.schema_id) "schema_name" 
, object_name(i.object_id) "table_name"
, c.name "column_name"
, i.type_desc "cluster_se"
, i.is_unique "unique_yn"
  FROM sys.indexes i
       INNER JOIN
       sys.index_columns ic
           ON i.object_id = ic.object_id 
              AND 
              i.index_id = ic.index_id
       INNER JOIN
       sys.columns c
           ON c.object_id = i.object_id
              AND 
              c.column_id = ic.column_id
       INNER JOIN 
       sys.objects o 
           ON o.object_id = c.object_id 
 WHERE object_name(i.object_id) IN (SELECT TABLE_name 
                                      FROM information_schema.tables
                                     WHERE table_schema = 'sc_khb_srv')
--       AND
--       name COLLATE korean_wansung_cs_as LIKE '%pk_%'
)
SELECT table_name "테이블명",
  CASE WHEN unique_yn = 1 THEN 
                               CASE WHEN cluster_se = 'CLUSTERED' THEN 'create unique CLUSTERED index '
                                    ELSE 'create unique index '
                               END
       ELSE 
            CASE WHEN cluster_se = 'CLUSTERED' THEN 'create CLUSTERED index '
                 ELSE 'create index '
            END
  END + 
  ii1.index_name + ' on ' +
  schema_name + '.' + 
  table_name + '(' +
  stuff((SELECT ', ' + column_name 
           FROM index_info
          WHERE index_name = ii1.index_name 
                AND
                index_id = ii1.index_id
--                     AND 
--                     table_name = ii1.table_name
            FOR xml PATH('')), 1, 2, '') + ');' "인덱스 생성 스크립트"
  FROM index_info ii1
 GROUP BY index_name, index_id, schema_name, table_name, cluster_se, unique_yn
ORDER BY 1;

-- 인덱스 생성 (162)
create unique CLUSTERED index pk_tb_atlfsl_bsc_info on sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_bsc_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_atlfsl_cfr_fclt_info on sc_khb_srv.tb_atlfsl_cfr_fclt_info(atlfsl_cfr_fclt_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_atlfsl_cmrc_dtl_info on sc_khb_srv.tb_atlfsl_cmrc_dtl_info(atlfsl_cmrc_dtl_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_atlfsl_dlng_info on sc_khb_srv.tb_atlfsl_dlng_info(atlfsl_dlng_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_atlfsl_etc_dtl_info on sc_khb_srv.tb_atlfsl_etc_dtl_info(atlfsl_etc_dtl_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_atlfsl_etc_info on sc_khb_srv.tb_atlfsl_etc_info(atlfsl_etc_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_atlfsl_img_info on sc_khb_srv.tb_atlfsl_img_info(atlfsl_img_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_atlfsl_land_usg_info on sc_khb_srv.tb_atlfsl_land_usg_info(atlfsl_land_usg_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_atlfsl_reside_gnrl_dtl_info on sc_khb_srv.tb_atlfsl_reside_gnrl_dtl_info(atlfsl_reside_gnrl_dtl_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_atlfsl_reside_set_dtl_info on sc_khb_srv.tb_atlfsl_reside_set_dtl_info(atlfsl_reside_set_dtl_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_author_01 on sc_khb_srv.tb_com_author(parnts_author_no_pk);
create unique CLUSTERED index PK__tb_com_a__53DDB1248A6843F9 on sc_khb_srv.tb_com_author(author_no_pk);
create unique index pk_tb_com_author on sc_khb_srv.tb_com_author(author_no_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_com_banner_info on sc_khb_srv.tb_com_banner_info(banner_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_com_bbs on sc_khb_srv.tb_com_bbs(bbs_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_com_bbs_cmnt on sc_khb_srv.tb_com_bbs_cmnt(bbs_cmnt_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_code_01 on sc_khb_srv.tb_com_code(parnts_code_pk);
create unique CLUSTERED index PK__tb_com_c__9A4F35F8846BCC0C on sc_khb_srv.tb_com_code(code_pk);
create unique index pk_tb_com_code on sc_khb_srv.tb_com_code(code_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index PK__tb_com_c__30E01A22B25E99C5 on sc_khb_srv.tb_com_crtfc_tmpr(crtfc_pk);
create unique index pk_tb_com_crtfc_tmpr on sc_khb_srv.tb_com_crtfc_tmpr(crtfc_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_com_ctpv_cd on sc_khb_srv.tb_com_ctpv_cd(ctpv_cd_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_com_emd_li_cd on sc_khb_srv.tb_com_emd_li_cd(emd_li_cd_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index PK__tb_com_e__D67F21434852434E on sc_khb_srv.tb_com_error_log(error_log_pk);
create unique index pk_tb_com_error_log on sc_khb_srv.tb_com_error_log(error_log_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index PK__tb_com_f__DB7F0588B4926731 on sc_khb_srv.tb_com_faq(faq_no_pk);\
create unique index pk_tb_com_faq on sc_khb_srv.tb_com_faq(faq_no_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_file_04 on sc_khb_srv.tb_com_file(file_no_pk);
create unique CLUSTERED index PK__tb_com_f__1BCB6A93791E6A44 on sc_khb_srv.tb_com_file(file_no_pk);
create unique index pk_tb_com_file on sc_khb_srv.tb_com_file(file_no_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_file_mapng_02 on sc_khb_srv.tb_com_file_mapng(recsroom_no_pk);
create index if_tb_com_file_mapng_03 on sc_khb_srv.tb_com_file_mapng(user_no_pk);
create index if_tb_com_file_mapng_04 on sc_khb_srv.tb_com_file_mapng(file_no_pk);
create unique CLUSTERED index PK__tb_com_f__1BCB6A93CA3BB047 on sc_khb_srv.tb_com_file_mapng(file_no_pk);
create unique index pk_tb_com_file_mapng on sc_khb_srv.tb_com_file_mapng(file_no_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_group_01 on sc_khb_srv.tb_com_group(parnts_group_no_pk);
create index if_tb_com_group_02 on sc_khb_srv.tb_com_group(user_no_pk);
create unique CLUSTERED index PK__tb_com_g__5908E1087DE885ED on sc_khb_srv.tb_com_group(group_no_pk);
create unique index pk_tb_com_group on sc_khb_srv.tb_com_group(group_no_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_group_author_01 on sc_khb_srv.tb_com_group_author(group_no_pk);
create index if_tb_com_group_author_02 on sc_khb_srv.tb_com_group_author(author_no_pk);
create unique CLUSTERED index PK__tb_com_g__21890C612511840D on sc_khb_srv.tb_com_group_author(com_group_author_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index PK__tb_com_g__EF21FF14BFFBC53B on sc_khb_srv.tb_com_gtwy_svc(gtwy_svc_pk);
create unique index pk_tb_com_gtwy_svc on sc_khb_srv.tb_com_gtwy_svc(gtwy_svc_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_gtwy_svc_author_01 on sc_khb_srv.tb_com_gtwy_svc_author(author_no_pk);
create index if_tb_com_gtwy_svc_author_02 on sc_khb_srv.tb_com_gtwy_svc_author(gtwy_svc_pk);
create unique CLUSTERED index PK__tb_com_g__ECE45093F58E1B90 on sc_khb_srv.tb_com_gtwy_svc_author(com_gtwy_svc_author_pk);
create unique index pk_tb_com_gtwy_svc_author on sc_khb_srv.tb_com_gtwy_svc_author(com_gtwy_svc_author_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_com_job_schdl_info on sc_khb_srv.tb_com_job_schdl_info(job_schdl_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index PK__tb_com_l__633D5262819B791A on sc_khb_srv.tb_com_login_hist(login_hist_pk);
create unique index pk_tb_com_login_hist on sc_khb_srv.tb_com_login_hist(login_hist_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_menu_01 on sc_khb_srv.tb_com_menu(scrin_no_pk);
create index if_tb_com_menu_02 on sc_khb_srv.tb_com_menu(parnts_menu_no_pk);
create unique CLUSTERED index PK__tb_com_m__C390607E2899EA42 on sc_khb_srv.tb_com_menu(menu_no_pk);
create unique index pk_tb_com_menu on sc_khb_srv.tb_com_menu(menu_no_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_menu_author_01 on sc_khb_srv.tb_com_menu_author(author_no_pk);
create index if_tb_com_menu_author_02 on sc_khb_srv.tb_com_menu_author(menu_no_pk);
create unique CLUSTERED index PK__tb_com_m__C97EC7FFB8545CF2 on sc_khb_srv.tb_com_menu_author(com_menu_author_pk);
create unique index pk_tb_com_menu_author on sc_khb_srv.tb_com_menu_author(com_menu_author_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index PK__tb_com_n__1CB35AC0841B98B6 on sc_khb_srv.tb_com_notice(notice_no_pk);
create unique index pk_tb_com_notice on sc_khb_srv.tb_com_notice(notice_no_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_qna_01 on sc_khb_srv.tb_com_qna(parnts_qna_no_pk);
create unique CLUSTERED index PK__tb_com_q__243D7A450DA6D617 on sc_khb_srv.tb_com_qna(qna_no_pk);
create unique index pk_tb_com_qna on sc_khb_srv.tb_com_qna(qna_no_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index PK__tb_com_r__953E0E3B43D90493 on sc_khb_srv.tb_com_recsroom(recsroom_no_pk);
create unique index pk_tb_com_recsroom on sc_khb_srv.tb_com_recsroom(recsroom_no_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index PK__tb_com_s__BCE50492EAB1A3B6 on sc_khb_srv.tb_com_scrin(scrin_no_pk);
create unique index pk_tb_com_scrin on sc_khb_srv.tb_com_scrin(scrin_no_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_scrin_author_01 on sc_khb_srv.tb_com_scrin_author(author_no_pk);
create index if_tb_com_scrin_author_02 on sc_khb_srv.tb_com_scrin_author(scrin_no_pk);
create unique CLUSTERED index PK__tb_com_s__D991AE2298D12669 on sc_khb_srv.tb_com_scrin_author(com_scrin_author_pk);
create unique index pk_tb_com_scrin_author on sc_khb_srv.tb_com_scrin_author(com_scrin_author_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_com_sgg_cd on sc_khb_srv.tb_com_sgg_cd(sgg_cd_pk);
create index if_tb_com_stplat_hist_01 on sc_khb_srv.tb_com_stplat_hist(com_stplat_info_pk);
create unique CLUSTERED index PK__tb_com_s__E1181CA7224D7A84 on sc_khb_srv.tb_com_stplat_hist(com_stplat_hist_pk);
create unique index pk_tb_com_stplat_hist on sc_khb_srv.tb_com_stplat_hist(com_stplat_hist_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_stplat_info_01 on sc_khb_srv.tb_com_stplat_info(svc_pk);
create unique CLUSTERED index PK__tb_com_s__69E0A88FBF460B64 on sc_khb_srv.tb_com_stplat_info(com_stplat_info_pk);
create unique index pk_tb_com_stplat_info on sc_khb_srv.tb_com_stplat_info(com_stplat_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_stplat_mapng_01 on sc_khb_srv.tb_com_stplat_mapng(com_stplat_info_pk);
create index if_tb_com_stplat_mapng_02 on sc_khb_srv.tb_com_stplat_mapng(user_no_pk);
create unique CLUSTERED index PK__tb_com_s__B42075F18B309671 on sc_khb_srv.tb_com_stplat_mapng(com_stplat_mapng_pk);
create unique index pk_tb_com_stplat_mapng on sc_khb_srv.tb_com_stplat_mapng(com_stplat_mapng_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_svc_ip_manage_01 on sc_khb_srv.tb_com_svc_ip_manage(author_no_pk);
create unique CLUSTERED index PK__tb_com_s__AE57FB379DE417DF on sc_khb_srv.tb_com_svc_ip_manage(ip_manage_pk);
create unique index pk_tb_com_svc_ip_manage on sc_khb_srv.tb_com_svc_ip_manage(ip_manage_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_user_01 on sc_khb_srv.tb_com_user(parnts_user_no_pk);
create unique CLUSTERED index pk_tb_com_user on sc_khb_srv.tb_com_user(user_no_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_user_author_01 on sc_khb_srv.tb_com_user_author(author_no_pk);
create index if_tb_com_user_author_02 on sc_khb_srv.tb_com_user_author(user_no_pk);
create unique CLUSTERED index PK__tb_com_u__DBED4DAAC5B3639A on sc_khb_srv.tb_com_user_author(user_author_pk);
create unique index pk_tb_com_user_author on sc_khb_srv.tb_com_user_author(user_author_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create index if_tb_com_user_group_02 on sc_khb_srv.tb_com_user_group(user_no_pk);
create index if_tb_com_user_group_03 on sc_khb_srv.tb_com_user_group(group_no_pk);
create unique CLUSTERED index PK__tb_com_u__CA8FAFE9B459C49D on sc_khb_srv.tb_com_user_group(com_user_group_pk);
create unique index pk_tb_com_user_group on sc_khb_srv.tb_com_user_group(com_user_group_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_hsmp_dtl_info on sc_khb_srv.tb_hsmp_dtl_info(hsmp_dtl_info_pk, hsmp_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_hsmp_info on sc_khb_srv.tb_hsmp_info(hsmp_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_itrst_atlfsl_info on sc_khb_srv.tb_itrst_atlfsl_info(itrst_atlfsl_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_lrea_office_info on sc_khb_srv.tb_lrea_office_info(lrea_office_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index pk_tb_lttot_info on sc_khb_srv.tb_lttot_info(lttot_info_pk);
--------------------------------------------------------------------------------------------------------------------------------------
create unique CLUSTERED index PK__tb_svc_b__C5B2B92E1CE3989D on sc_khb_srv.tb_svc_bass_info(svc_pk);
create unique index pk_tb_svc_bass_info on sc_khb_srv.tb_svc_bass_info(svc_pk);
--------------------------------------------------------------------------------------------------------------------------------------


 





 














