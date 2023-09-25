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
     , power_vl = m.[power]
     , room_one_cnt = m.room1_cnt
     , room_two_cnt = m.room2_cnt
     , room_three_cnt = m.room3_cnt
     , room_four_cnt = m.room4_cnt
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
);

BULK INSERT sc_khb_srv.tb_atlfsl_bsc_update
       FROM 'D:\migra_data\bsc_update.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

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
      , CONVERT(NUMERIC(18), replace(m.managefee_info,',','')) mng_amt
   FROM sc_khb_srv.tb_atlfsl_bsc_info tabi
        INNER JOIN
        KMLS.dbo.mamul m
                ON tabi.asoc_atlfsl_no = m.mm_no
  WHERE isnumeric(m.managefee_info) = 1
)
UPDATE sc_khb_srv.tb_atlfsl_dlng_info
   SET mng_amt = duq.mng_amt
  FROM dlng_up_query duq
 WHERE sc_khb_srv.tb_atlfsl_dlng_info.atlfsl_bsc_info_pk = duq.atlfsl_bsc_info_pk;



/*txt파일로 update*/
CREATE TABLE sc_khb_srv.tb_atlfsl_dlng_update (
  asoc_atlfsl_no numeric(18, 0)
, mng_amt numeric(18, 0)
);

BULK INSERT sc_khb_srv.tb_atlfsl_dlng_update
       FROM 'D:\migra_data\dlng_update.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);


WITH bsc_pk_find AS 
(
 SELECT tabi.atlfsl_bsc_info_pk atlfsl_bsc_info_pk
      , tadu.mng_amt mng_amt
   FROM sc_khb_srv.tb_atlfsl_bsc_info tabi
        INNER JOIN
        sc_khb_srv.tb_atlfsl_dlng_update tadu
                ON tabi.asoc_atlfsl_no = tadu.asoc_atlfsl_no
)
UPDATE sc_khb_srv.tb_atlfsl_dlng_info
   SET mng_amt = bpf.mng_amt
  FROM bsc_pk_find bpf
 WHERE sc_khb_srv.tb_atlfsl_dlng_info.atlfsl_bsc_info_pk = bpf.atlfsl_bsc_info_pk;


DROP TABLE sc_khb_srv.tb_atlfsl_dlng_update;

SELECT * FROM sc_khb_srv.tb_atlfsl_dlng_info;


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
             ROWTERMINATOR = '0x0a'
);

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
             ROWTERMINATOR = '0x0a'
);


UPDATE sc_khb_srv.tb_lrea_office_info
   SET eml = lu.eml
     , lrea_grd_cd = lu.lrea_grd_cd
     , estbl_reg_no = lu.estbl_reg_no
  FROM sc_khb_srv.tb_lrea_update lu
 WHERE sc_khb_srv.tb_lrea_office_info.lrea_office_info_pk = lu.lrea_office_info_pk;

DROP TABLE sc_khb_srv.tb_lrea_update;

SELECT * FROM sc_khb_srv.tb_lrea_office_info;








































