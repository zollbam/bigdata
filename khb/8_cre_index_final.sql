/*
작성 일자 : 230921
수정 일자 : 
작 성 자 : 조건영
작성 목적 : 인덱스 생성
*/



-- SPATIAL INDEX 생성
create spatial index si_tb_com_ctpv_cd_01 on sc_khb_srv.tb_com_ctpv_cd(ctpv_crdnt)
with (bounding_box = (0, 0, 200, 100));

create spatial index si_tb_com_sgg_cd_01 on sc_khb_srv.tb_com_sgg_cd(sgg_crdnt)
with (bounding_box = (0, 0, 200, 100));

create spatial index si_tb_com_emd_li_cd_01 on sc_khb_srv.tb_com_emd_li_cd(emd_li_crdnt)
with (bounding_box = (0, 0, 200, 100));

create spatial index si_tb_atlfsl_bsc_info_01 on sc_khb_srv.tb_atlfsl_bsc_info(atlfsl_crdnt)
with (bounding_box = (0, 0, 200, 100));

create spatial index si_tb_hsmp_info_01 on sc_khb_srv.tb_hsmp_info(hsmp_crdnt)
with (bounding_box = (0, 0, 200, 100));

create spatial index si_tb_lrea_office_info_01 on sc_khb_srv.tb_lrea_office_info(lrea_office_crdnt)
with (bounding_box = (0, 0, 200, 100));

create spatial index si_tb_link_hsmp_bsc_info_01 on sc_khb_srv.tb_link_hsmp_bsc_info (hsmp_crdnt)
with (bounding_box = (0, 0, 200, 100));




-- NONCLUSTER INSEX
create index ix_tb_atlfsl_bsc_info_01 on sc_khb_srv.tb_com_emd_li_cd(stdg_dong_cd);
create index ix_tb_link_hsmp_bsc_info_01 on sc_khb_srv.tb_link_hsmp_bsc_info(stdg_addr);










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
   AND (i.name LIKE 'si%' 
    OR i.name LIKE 'ix%')
 ORDER BY 4, 5;


























