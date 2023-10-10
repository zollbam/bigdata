/*
작성 일자 : 230908
수정 일자 : 
작 성 자 : 조건영
작성 목적 : 생성한 테이블에 update로 값 채워 넣기
*/



-- tb_atlfsl_bsc_info
/*inner join으로 update*/
UPDATE sc_khb_srv.tb_atlfsl_bsc_info
   SET 
       rcmdtn_yn = m.chu_yn
     , auc_yn = m.kyungmae_yn
     , atlfsl_stts_cd = m.state_cd
     , atlfsl_vrfc_yn = m.confirm_yn
     , atlfsl_vrfc_day = m.confirm_date
     , land_area = CASE WHEN m.toji_meter < 10000000000 THEN m.toji_meter
                        ELSE NULL
                    END
     , qota_area = CASE WHEN m.jibun_meter < 10000000000 THEN m.jibun_meter
                        ELSE NULL
                    END
     , use_inspct_day = m.use_confirm_day
     , bldg_usg_cd = m.building_use_cd
     , lndr_se_cd = m.setak_cd
     , ktchn_se_cd = m.jubang_cd
     , btr_se_cd = m.yoksil_cd
     , blcn_estn_yn = m.balcony_ext_yn
     , power_vl = CASE WHEN m.[power] < 100000000000000000000 THEN [power]
                       ELSE NULL
                   END
     , room_one_cnt = CASE WHEN m.room1_cnt < 10000000000 THEN m.room1_cnt
                           ELSE NULL
                       END -- 실수 존재
     , room_two_cnt = m.room2_cnt
     , room_three_cnt = m.room3_cnt -- 실수 존재
     , room_four_cnt = m.room4_cnt
     , expitm_nm = m.expenses_item_info
     , elvtr_yn = m.elevator_yn
     , drc_crtr_nm = m.direction_info
     , now_tpbiz_nm = m.curr_upjong
     , rcmdtn_usg_one_nm = m.recommend_use1
     , rcmdtn_usg_two_nm = m.recommend_use2
     , house_area = m.house_meter
     , house_area_pyeong = m.house_pyung
     , sopsrt_area = m.sangga_meter
     , sopsrt_area_pyeong = m.sangga_pyung
     , ofc_area = m.office_meter
     , ofc_area_pyeong = m.office_pyung
     , sale_se_cd = m.sell_cd
     , flr_hg_vl = m.floor_high
     , nearby_road_vl = m.road_meter
     , bdst_usg_cd = m.build_use_cd
     , biz_step_cd = m.biz_step_cd
     , slctn_bldr_nm = m.const_company
     , expect_sply_area = m.estimate_meter
     , expect_sply_area_pyeong = m.estimate_pyung
     , expect_hh_cnt = m.estimate_cnt
     , zone_tot_area = m.zone_meter
     , zone_tot_area_pyeong = m.zone_pyung
     , expect_fart = m.yongjuk_rate
     , btl_rt = m.gunpe_rate
     , reg_rentbzmn_yn = m.rentalhouse_apply_yn
     , atlfsl_usg_cd = CASE WHEN officetel_use_cd <> '' THEN officetel_use_cd -- 오피스텔용도(G140)
                            WHEN building_cate_cd <> '' THEN building_cate_cd -- 건물종류(재개발)(G340)
                            WHEN store_use_cd <> '' THEN store_use_cd -- 주용도_상가점포(G550)
				            WHEN office_use_cd <> '' THEN office_use_cd -- 주용도_사무실(G560)
				            WHEN building_use_cd <> '' THEN building_use_cd -- 건물주용도(G520)
				            else '' 
		                END
     , atlfsl_se_cd = CASE WHEN sukbak_cate_cd <> '' THEN sukbak_cate_cd -- 숙박물건종류(G400)
				           WHEN factory_type_cd <> '' THEN factory_type_cd -- 공장형태(G420)
				--           WHEN warehouse_type_cd <> '' THEN warehouse_type_cd
				--           WHEN building_type_cd <> '' THEN building_type_cd
				           WHEN factory_cate <> '' THEN factory_cate -- 공장종류
				           WHEN saleType <> '' THEN saleType -- 분양구분
				           WHEN sangga_cd <> '' THEN sangga_cd -- 상가구분(G350)
				           WHEN gunrak_cd <> '' THEN gunrak_cd -- 군락형태(G320)
				           ELSE ''
                       END
     , atlfsl_lct_cd = CASE WHEN sangga_ipji_cd <> '' THEN sangga_ipji_cd -- 상가입지(G580)
				            WHEN office_ipji_cd <> '' THEN office_ipji_cd -- 사무실입지(G570)
				            WHEN sukbak_ipji_cd <> '' THEN sukbak_ipji_cd -- 숙박입지(G410)
				            WHEN factory_ipji_cd <> '' THEN factory_ipji_cd -- 공장입지(G440)
				            ELSE ''
                        END
     , atlfsl_strct_cd = CASE WHEN const_struc_cd <> '' THEN const_struc_cd -- 건축구조(공장)(G450)
					          WHEN office_ipji_cd <> '' THEN office_ipji_cd -- 방구조(G250)
					          ELSE ''
                          END
  FROM KMLS.dbo.mamul m
 WHERE sc_khb_srv.tb_atlfsl_bsc_info.asoc_atlfsl_no = m.mm_no;

SELECT * FROM sc_khb_srv.tb_atlfsl_bsc_info tabi;


/*txt파일로 update*/
CREATE TABLE sc_khb_srv.tb_atlfsl_bsc_update (
  asoc_atlfsl_no numeric(15, 0) NOT NULL 
, rcmdtn_yn char(1)
, auc_yn char(1)
, atlfsl_stts_cd varchar(20)
, atlfsl_vrfc_yn char(1)
, atlfsl_vrfc_day nvarchar(100)
, land_area decimal(19, 9)
, qota_area decimal(19, 9)
, use_inspct_day nvarchar(100)
, bldg_usg_cd varchar(20)
, lndr_se_cd varchar(20)
, ktchn_se_cd varchar(20)
, btr_se_cd varchar(20)
, blcn_estn_yn char(1)
, power_vl decimal(25, 15)
, room_one_cnt numeric(15, 0)
, room_two_cnt numeric(15, 0)
, room_three_cnt numeric(15, 0)
, room_four_cnt numeric(15, 0)
, expitm_nm nvarchar(500)
, elvtr_yn char(1)
, drc_crtr_nm nvarchar(500)
, now_tpbiz_nm nvarchar(500)
, rcmdtn_usg_one_nm nvarchar(500)
, rcmdtn_usg_two_nm nvarchar(500)
, house_area decimal(19, 9)
, house_area_pyeong decimal(19, 9)
, sopsrt_area decimal(19, 9)
, sopsrt_area_pyeong decimal(19, 9)
, ofc_area decimal(19, 9)
, ofc_area_pyeong decimal(19, 9)
, sale_se_cd varchar(20)
, flr_hg_vl decimal(25, 15)
, nearby_road_vl decimal(25, 15)
, bdst_usg_cd varchar(20)
, biz_step_cd varchar(20)
, slctn_bldr_nm nvarchar(500)
, expect_sply_area decimal(19, 9)
, expect_sply_area_pyeong decimal(19, 9)
, expect_hh_cnt numeric(15, 0)
, zone_tot_area decimal(19, 9)
, zone_tot_area_pyeong decimal(19, 9)
, expect_fart decimal(19, 9)
, btl_rt decimal(19, 9)
, reg_rentbzmn_yn char(1)
, atlfsl_usg_cd varchar(20)
, atlfsl_se_cd varchar(20)
, atlfsl_lct_cd varchar(20)
, atlfsl_strct_cd varchar(20)
);

TRUNCATE TABLE sc_khb_srv.tb_atlfsl_bsc_update;

BULK INSERT sc_khb_srv.tb_atlfsl_bsc_update
       FROM 'D:\migra_data\bsc_update.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '\n'
);

BULK INSERT sc_khb_srv.tb_atlfsl_bsc_update
       FROM 'D:\migra_data\bsc_update_1.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '\n'
);

SELECT * FROM sc_khb_srv.tb_atlfsl_bsc_update;

UPDATE sc_khb_srv.tb_atlfsl_bsc_info
   SET 
       rcmdtn_yn = a.rcmdtn_yn
     , auc_yn = a.auc_yn
     , atlfsl_stts_cd = a.atlfsl_stts_cd
     , atlfsl_vrfc_yn = a.atlfsl_vrfc_yn
     , atlfsl_vrfc_day = a.atlfsl_vrfc_day
     , land_area = a.land_area
     , qota_area = a.qota_area
     , use_inspct_day = a.use_inspct_day
     , bldg_usg_cd = a.bldg_usg_cd
     , lndr_se_cd = a.lndr_se_cd
     , ktchn_se_cd = a.ktchn_se_cd
     , btr_se_cd = a.btr_se_cd
     , blcn_estn_yn = a.blcn_estn_yn
     , power_vl = a.power_vl
     , room_one_cnt = a.room_one_cnt
     , room_two_cnt = a.room_two_cnt
     , room_three_cnt = a.room_three_cnt
     , room_four_cnt = a.room_four_cnt
  FROM sc_khb_srv.tb_atlfsl_bsc_update a
 WHERE sc_khb_srv.tb_atlfsl_bsc_info.asoc_atlfsl_no = a.asoc_atlfsl_no;

DROP TABLE sc_khb_srv.tb_atlfsl_bsc_update;

SELECT * FROM sc_khb_srv.tb_atlfsl_bsc_update;



-- tb_atlfsl_dlng_info
/*inner join으로 update*/
WITH dlng_up_query AS
(
 SELECT tabi.atlfsl_bsc_info_pk atlfsl_bsc_info_pk
      , CONVERT(nvarchar(max), CONVERT(NUMERIC(18), replace(replace(managefee_info,',',''),'\',''))) mng_amt
      , CONVERT(varchar(max), CONVERT(NUMERIC(18), amt_sisul, 3)) fclt_amt
      , CONVERT(varchar(max), CONVERT(NUMERIC(18), amt_pay, 3)) pay_amt
      , mid_gbn mdstrm_amt_int_se_cd
      , CONVERT(varchar(max), CONVERT(NUMERIC(18), amt_real_invest, 3)) rl_invt_amt
      , CONVERT(varchar(max), CONVERT(NUMERIC(18), amt_move_free, 3)) nintr_moving_amt
      , CONVERT(varchar(max), CONVERT(NUMERIC(18), amt_move_nofree, 3)) int_moving_amt
   FROM sc_khb_srv.tb_atlfsl_bsc_info tabi
        INNER JOIN
        KMLS.dbo.mamul m
                ON tabi.asoc_atlfsl_no = m.mm_no
  WHERE isnumeric(m.managefee_info) = 1
    AND round(CONVERT(NUMERIC(21, 3), replace(replace(managefee_info,',',''),'\','')), 1) 
        - FLOOR(round(CONVERT(NUMERIC(21, 3), replace(replace(managefee_info,',',''),'\','')), 1)) = 0
)
UPDATE sc_khb_srv.tb_atlfsl_dlng_info
   SET mng_amt = duq.mng_amt
     , fclt_amt = duq.fclt_amt
     , pay_amt = duq.pay_amt
     , mdstrm_amt_int_se_cd = duq.mdstrm_amt_int_se_cd
     , rl_invt_amt = duq.rl_invt_amt
     , nintr_moving_amt = duq.nintr_moving_amt
     , int_moving_amt = duq.int_moving_amt
  FROM dlng_up_query duq
 WHERE sc_khb_srv.tb_atlfsl_dlng_info.atlfsl_bsc_info_pk = duq.atlfsl_bsc_info_pk;



/*txt파일로 update*/
CREATE TABLE sc_khb_srv.tb_atlfsl_dlng_update (
  asoc_atlfsl_no numeric(18, 0)
, mng_amt numeric(18, 0)
, fclt_amt numeric(18, 0)
, pay_amt numeric(18, 0)
, mdstrm_amt_int_se_cd varchar(20)
, rl_invt_amt numeric(18, 0)
, nintr_moving_amt numeric(18, 0)
, int_moving_amt numeric(18, 0)
);

BULK INSERT sc_khb_srv.tb_atlfsl_dlng_update
       FROM 'D:\migra_data\dlng_update_1.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '\n'
);

BULK INSERT sc_khb_srv.tb_atlfsl_dlng_update
       FROM 'D:\migra_data\dlng_update_2.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '\n'
);

SELECT * FROM sc_khb_srv.tb_atlfsl_dlng_update;

WITH bsc_pk_find AS 
(
 SELECT tabi.atlfsl_bsc_info_pk atlfsl_bsc_info_pk
      , tadu.mng_amt mng_amt
      , tadu.fclt_amt fclt_amt
      , tadu.pay_amt pay_amt
      , tadu.mdstrm_amt_int_se_cd mdstrm_amt_int_se_cd
      , tadu.rl_invt_amt rl_invt_amt
      , tadu.nintr_moving_amt nintr_moving_amt
      , tadu.int_moving_amt int_moving_amt
   FROM sc_khb_srv.tb_atlfsl_bsc_info tabi
        INNER JOIN
        sc_khb_srv.tb_atlfsl_dlng_update tadu
                ON tabi.asoc_atlfsl_no = tadu.asoc_atlfsl_no
)
UPDATE sc_khb_srv.tb_atlfsl_dlng_info
   SET mng_amt = bpf.mng_amt
     , fclt_amt = bpf.fclt_amt
     , pay_amt = bpf.pay_amt
     , mdstrm_amt_int_se_cd = bpf.mdstrm_amt_int_se_cd
     , rl_invt_amt = bpf.rl_invt_amt
     , nintr_moving_amt = bpf.nintr_moving_amt
     , int_moving_amt = bpf.int_moving_amt
  FROM bsc_pk_find bpf
 WHERE sc_khb_srv.tb_atlfsl_dlng_info.atlfsl_bsc_info_pk = bpf.atlfsl_bsc_info_pk;

DROP TABLE sc_khb_srv.tb_atlfsl_dlng_update;

SELECT * FROM sc_khb_srv.tb_atlfsl_dlng_info;


-- tb_atlfsl_land_usg_info
/*inner join으로 update*/
WITH land_usg_up_query AS
(
 SELECT tabi.atlfsl_bsc_info_pk atlfsl_bsc_info_pk
      , jimok_cd ldcg_cd
      , jimok_gusung ldcg_nm
      , yong_jiyuk1_cd usg_rgn_one_cd
      , yong_jiyuk2_cd usg_rgn_two_cd
      , curr_use now_usg_rgn_nm
   FROM sc_khb_srv.tb_atlfsl_bsc_info tabi
        INNER JOIN
        KMLS.dbo.mamul m
                ON tabi.asoc_atlfsl_no = m.mm_no
)
UPDATE sc_khb_srv.tb_atlfsl_land_usg_info
   SET ldcg_cd = luuq.ldcg_cd
     , ldcg_nm = luuq.ldcg_nm
     , usg_rgn_one_cd = luuq.usg_rgn_one_cd
     , usg_rgn_two_cd = luuq.usg_rgn_two_cd
     , now_usg_rgn_nm = luuq.now_usg_rgn_nm
  FROM land_usg_up_query luuq
 WHERE sc_khb_srv.tb_atlfsl_land_usg_info.atlfsl_bsc_info_pk = luuq.atlfsl_bsc_info_pk;


/*txt파일로 update*/
CREATE TABLE sc_khb_srv.tb_atlfsl_land_usg_update (
  asoc_atlfsl_no numeric(18, 0)
, ldcg_cd varchar(20)
, ldcg_nm nvarchar(500)
, usg_rgn_one_cd varchar(20)
, usg_rgn_two_cd varchar(20)
, now_usg_rgn_nm nvarchar(500)
);

TRUNCATE TABLE sc_khb_srv.tb_atlfsl_land_usg_update;

BULK INSERT sc_khb_srv.tb_atlfsl_land_usg_update
       FROM 'D:\migra_data\land_usg_update.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '\n'
);

BULK INSERT sc_khb_srv.tb_atlfsl_land_usg_update
       FROM 'D:\migra_data\land_usg_update_2.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '\n'
);

SELECT count(*) FROM sc_khb_srv.tb_atlfsl_land_usg_update;

WITH bsc_pk_find AS 
(
 SELECT tabi.atlfsl_bsc_info_pk atlfsl_bsc_info_pk
      , taluu.ldcg_cd ldcg_cd
      , taluu.ldcg_nm ldcg_nm
      , taluu.usg_rgn_one_cd usg_rgn_one_cd
      , taluu.usg_rgn_two_cd usg_rgn_two_cd
      , taluu.now_usg_rgn_nm now_usg_rgn_nm
   FROM sc_khb_srv.tb_atlfsl_bsc_info tabi
        INNER JOIN
        sc_khb_srv.tb_atlfsl_land_usg_update taluu
                ON tabi.asoc_atlfsl_no = taluu.asoc_atlfsl_no
)
UPDATE sc_khb_srv.tb_atlfsl_land_usg_info
   SET ldcg_cd = bpf.ldcg_cd
     , ldcg_nm = bpf.ldcg_nm
     , usg_rgn_one_cd = bpf.usg_rgn_one_cd
     , usg_rgn_two_cd = bpf.usg_rgn_two_cd
     , now_usg_rgn_nm = bpf.now_usg_rgn_nm
  FROM bsc_pk_find bpf
 WHERE sc_khb_srv.tb_atlfsl_land_usg_info.atlfsl_bsc_info_pk = bpf.atlfsl_bsc_info_pk; -- 222482개 행 변경

DROP TABLE sc_khb_srv.tb_atlfsl_land_usg_update;

SELECT * FROM sc_khb_srv.tb_atlfsl_land_usg_info;


-- tb_com_user
/*inner join으로 update*/
UPDATE sc_khb_srv.tb_com_user
   SET user_id = um.user_id
  FROM kmls.dbo.user_mst um
 WHERE sc_khb_srv.tb_com_user.lrea_office_info_pk = um.mem_no
   AND sc_khb_srv.tb_com_user.user_se_code = '02';


/*txt파일로 update*/
CREATE TABLE sc_khb_srv.tb_com_user_update (
  lrea_office_info_pk numeric(18, 0) NOT NULL
, user_id nvarchar(100)
);

BULK INSERT sc_khb_srv.tb_com_user_update
       FROM 'D:\migra_data\user_update.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '\n'
);

SELECT * FROM sc_khb_srv.tb_com_user_update;

UPDATE sc_khb_srv.tb_com_user
   SET user_id = cuu.user_id
  FROM sc_khb_srv.tb_com_user_update cuu
 WHERE sc_khb_srv.tb_com_user.lrea_office_info_pk = cuu.lrea_office_info_pk
   AND sc_khb_srv.tb_com_user.user_se_code = '02';
  
DROP TABLE sc_khb_srv.tb_com_user_update;

SELECT * FROM sc_khb_srv.tb_com_user WHERE user_se_code = '02';



-- tb_lrea_office_info
/*join으로 update*/
UPDATE sc_khb_srv.tb_lrea_office_info
   SET eml = m.email
     , curprc_pvsn_yn = CASE WHEN kmmt.MONTR_MBER_STTUS_CD = '02' THEN 'Y'
                             ELSE 'N'
                         END
     , lrea_grd_cd = m.jumin_no 
     , estbl_reg_no = m.comp_reg_no
  FROM KMLS.dbo.[MEMBER] m
       LEFT JOIN
       kmls.dbo.KRI_MONTR_MBER_TB kmmt
              ON m.mem_no = kmmt.MBER_NO
 WHERE sc_khb_srv.tb_lrea_office_info.lrea_office_info_pk = m.mem_no;


/*txt파일로 update*/
CREATE TABLE sc_khb_srv.tb_lrea_update (
  lrea_office_info_pk numeric(18, 0) NOT NULL
, eml varchar(320)
, lrea_grd_cd varchar(20)
, estbl_reg_no varchar(200)
);

BULK INSERT sc_khb_srv.tb_lrea_update
       FROM 'D:\migra_data\lrea_update.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '\n'
);

SELECT * FROM sc_khb_srv.tb_lrea_update;

UPDATE sc_khb_srv.tb_lrea_office_info
   SET eml = lu.eml
     , lrea_grd_cd = lu.lrea_grd_cd
     , estbl_reg_no = lu.estbl_reg_no
  FROM sc_khb_srv.tb_lrea_update lu
 WHERE sc_khb_srv.tb_lrea_office_info.lrea_office_info_pk = lu.lrea_office_info_pk;

DROP TABLE sc_khb_srv.tb_lrea_update;

SELECT * FROM sc_khb_srv.tb_lrea_office_info;








































