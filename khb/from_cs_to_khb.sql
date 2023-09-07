/*
작성일: 230906
수정일: 
작성자: 조건영
작성 목적: cs에서 만든 txt파일로 앱DB에 이관 및 업데이트
*/



/*기존 tb_com_user의 공인 중개사 수*/
SELECT count(*)
  FROM sc_khb_srv.tb_com_user
 WHERE user_se_code = '02'; -- 18362
 
/*삭제*/
DROP TABLE sc_khb_srv.tb_com_user_update;

-- tb_com_user의 test 테이블 만들기(update 용)
CREATE TABLE sc_khb_srv.tb_com_user_update (
  user_no_pk sc_khb_srv.pk_n18 NOT NULL
, parnts_user_no_pk sc_khb_srv.pk_n18
, user_id sc_khb_srv.id_nv100
, user_nm sc_khb_srv.nm_nv500
, password sc_khb_srv.password_v500
, moblphon_no sc_khb_srv.no_v200
, email sc_khb_srv.email_v320
, user_se_code sc_khb_srv.cd_v20
, sbscrb_de sc_khb_srv.de_v10
, password_change_de sc_khb_srv.de_v10
, last_login_dt sc_khb_srv.dt
, last_login_ip sc_khb_srv.ip_v100
, error_co sc_khb_srv.cnt_n15
, error_dt sc_khb_srv.dt
, use_at sc_khb_srv.yn_c1
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
, refresh_tkn_cn sc_khb_srv.cn_nv4000
, soc_lgn_ty_cd sc_khb_srv.cd_v20
, user_img_url sc_khb_srv.url_nv4000
, lrea_office_nm sc_khb_srv.nm_nv500
, lrea_office_info_pk sc_khb_srv.pk_n18
, lrea_brffc_cd sc_khb_srv.cd_v20
);

BULK INSERT sc_khb_srv.tb_com_user_update
       FROM 'D:\migra_data\com_user_new.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '|||',
             ROWTERMINATOR = '\n'
);


alter table sc_khb_srv.tb_com_user_update add constraint pk_tb_com_user_update primary key(user_no_pk);

SELECT * FROM sc_khb_srv.tb_com_user_update;
SELECT count(*) FROM sc_khb_srv.tb_com_user_update; -- 165555
SELECT max(user_no_pk) FROM sc_khb_srv.tb_com_user_update; -- 165555


 
-- tb_lrea_office_info 테이블에 이메일 삽입
/*열 추가*/
ALTER TABLE sc_khb_srv.tb_lrea_office_info ALTER COLUMN email sc_khb_srv.email_v320;

/*comment 추가*/
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이메일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_lrea_office_info', @level2type=N'COLUMN', @level2name = N'email';


/*업데이트 전 확인*/
SELECT *
  FROM sc_khb_srv.tb_lrea_office_info
 WHERE email IS NOT NULL;
/*email이 있는 데이터가 없다.*/

SELECT loi.lrea_office_info_pk
     , cut.email
  FROM sc_khb_srv.tb_lrea_office_info loi
       LEFT JOIN 
       sc_khb_srv.tb_com_user_update cut
               ON loi.lrea_office_info_pk = cut.lrea_office_info_pk
 ORDER BY 1; -- 200996


/*업데이트*/
UPDATE sc_khb_srv.tb_lrea_office_info
   SET email = cut.email
  FROM sc_khb_srv.tb_lrea_office_info loi
       LEFT JOIN 
       sc_khb_srv.tb_com_user_update cut
               ON loi.lrea_office_info_pk = cut.lrea_office_info_pk;

/*업데이트 후 확인*/
SELECT lrea_office_info_pk, lrea_office_rprsv_nm, email
  FROM sc_khb_srv.tb_lrea_office_info
 WHERE eamil IS NOT NULL;
/*55958행에 email의 값이 삽입*/



-- tb_com_user의 공인중개사(02) 업데이트
/*user_id*/
UPDATE sc_khb_srv.tb_com_user
   SET user_id = cut.user_id
  FROM sc_khb_srv.tb_com_user cu
       INNER JOIN
       sc_khb_srv.tb_com_user_update cut
               ON cu.lrea_office_info_pk = cut.lrea_office_info_pk
 WHERE cu.user_se_code = '02'
   AND cu.lrea_office_info_pk = cu.lrea_office_info_pk;

/*user_id 확인*/
SELECT lrea_office_info_pk
     , user_nm
     , user_id
  FROM sc_khb_srv.tb_com_user 
 WHERE user_se_code = '02';
  
--/*password*/
--UPDATE sc_khb_srv.tb_com_user
--   SET password = cut.password
--  FROM sc_khb_srv.tb_com_user cu
--       INNER JOIN
--       sc_khb_srv.tb_com_user_update cut
--               ON cu.lrea_office_info_pk = cut.lrea_office_info_pk
-- WHERE cu.user_se_code = '02'
--   AND cu.lrea_office_info_pk = cu.lrea_office_info_pk;
--/*비밀번호는 한 행만 데이터 삽입*/
--
--/*password 확인*/
--SELECT lrea_office_info_pk 
--     , user_nm
--     , password
--  FROM sc_khb_srv.tb_com_user 
-- WHERE user_se_code = '02';
--
--UPDATE sc_khb_srv.tb_com_user
--   SET password = NULL;
/*다시 null값으로*/

/*email*/
UPDATE sc_khb_srv.tb_com_user
   SET email = cut.email
  FROM sc_khb_srv.tb_com_user cu
       INNER JOIN
       sc_khb_srv.tb_com_user_t cut
               ON cu.lrea_office_info_pk = cut.lrea_office_info_pk
 WHERE cu.user_se_code = '02'
   AND cu.lrea_office_info_pk = cu.lrea_office_info_pk;

/*email 확인*/
SELECT lrea_office_info_pk
     , user_id
     , email
  FROM sc_khb_srv.tb_com_user
 WHERE user_se_code = '02';

/*sbscrb_de*/
UPDATE sc_khb_srv.tb_com_user
   SET sbscrb_de = cut.sbscrb_de
  FROM sc_khb_srv.tb_com_user cu
       INNER JOIN
       sc_khb_srv.tb_com_user_update cut
               ON cu.lrea_office_info_pk = cut.lrea_office_info_pk
 WHERE cu.user_se_code = '02'
   AND cu.lrea_office_info_pk = cu.lrea_office_info_pk;

/*sbscrb_de 확인*/
SELECT lrea_office_info_pk
     , user_nm
     , sbscrb_de
  FROM sc_khb_srv.tb_com_user
 WHERE user_se_code = '02';

/*lrea_brffc_cd*/
UPDATE sc_khb_srv.tb_com_user
   SET lrea_brffc_cd = cut.lrea_brffc_cd
  FROM sc_khb_srv.tb_com_user cu
       INNER JOIN
       sc_khb_srv.tb_com_user_t cut
               ON cu.lrea_office_info_pk = cut.lrea_office_info_pk
 WHERE cu.user_se_code = '02'
   AND cu.lrea_office_info_pk = cu.lrea_office_info_pk;

/*lrea_brffc_cd 확인*/
SELECT lrea_office_info_pk
     , user_nm
     , lrea_brffc_cd
  FROM sc_khb_srv.tb_com_user 
 WHERE user_se_code = '02';

SELECT *
  FROM sc_khb_srv.tb_lrea_office_info
 WHERE lrea_office_info_pk = 12545;









































