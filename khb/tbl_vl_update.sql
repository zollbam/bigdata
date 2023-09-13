/*
작성일: 230909
수정일: 
작성자: 조건영
작성 목적: cs에서 만든 txt파일로 앱DB에 이관 및 업데이트
*/



-- txt파일 만들기(cs 운영인 20번에서 사용하는 쿼리문)
SELECT CAST(ROW_NUMBER() OVER (ORDER BY m.mem_no) AS nvarchar(max)) + '|||' + -- "user_no_pk"
       CAST(ROW_NUMBER() OVER (ORDER BY m.mem_no) AS nvarchar(max)) + '|||' + -- "parnts_user_no_pk"
       CASE WHEN um.user_id IS NULL OR um.user_id = '' THEN ''
            ELSE CAST(um.user_id AS nvarchar(max))
       END + '|||' + -- "user_id"
       CASE WHEN m.owner_nm IS NULL OR m.owner_nm = '' THEN ''
            ELSE CAST(m.owner_nm AS nvarchar(max))
       END + '|||' + -- "user_nm"
       CASE WHEN um.user_pw IS NULL OR um.user_pw = '' THEN ''
            ELSE CAST(um.user_pw AS nvarchar(max))
       END + '|||' + -- "password"
       CASE WHEN m.hp IS NULL OR m.hp = '' THEN ''
            ELSE CAST(m.hp AS nvarchar(max))
       END + '|||' + -- "moblphon_no"
       CASE WHEN m.email IS NULL OR m.email = '' THEN ''
            ELSE CAST(m.email AS nvarchar(max))
       END + '|||' + -- "email"
       '02' + '|||' + -- "user_se_code"
        CASE WHEN m.comp_reg_date IS NULL OR m.comp_reg_date = '' THEN ''
            ELSE CAST(m.comp_reg_date AS nvarchar(max))
       END + '|||' + -- "sbscrb_de"
       '' + '|||' + -- "password_change_de"
       '' + '|||' + -- "last_login_dt"
       '' + '|||' + -- "last_login_ip"
       '' + '|||' + -- "error_co"
       '' + '|||' + -- "error_dt"
       CASE WHEN um.use_yn IS NULL OR um.use_yn = '' THEN ''
            ELSE CAST(um.use_yn AS nvarchar(max))
       END + '|||' + -- "use_at"
       '' + '|||' + -- "regist_id"
       CASE WHEN m.wdate IS NULL OR m.wdate = '' THEN ''
            ELSE CAST(m.wdate AS nvarchar(max))
       END + '|||' + -- "regist_dt"
       '' + '|||' + -- "updt_id"
       '' + '|||' + -- "updt_dt"
       '' + '|||' + -- "refresh_tkn_cn"
       '' + '|||' + -- "soc_lgn_ty_cd"
       '' + '|||' + -- "user_img_url"
       CASE WHEN m.company IS NULL OR m.company = '' THEN ''
            ELSE CAST(m.company AS nvarchar(max))
       END + '|||' + -- "lrea_office_nm"
       CASE WHEN m.mem_no IS NULL OR m.mem_no = '' THEN ''
            ELSE CAST(m.mem_no AS nvarchar(max))
       END  + '|||' + -- "lrea_office_info_pk"
       CASE WHEN m.branch_code IS NULL OR m.branch_code = '' THEN ''
            ELSE CAST(m.branch_code AS nvarchar(max))
       END -- "lrea_brffc_cd"
  FROM [MEMBER] m
       INNER JOIN
       user_mst um
               ON m.mem_no = um.mem_no
 WHERE um.master_yn = 'Y' 
--   AND owner_nm NOT LIKE '%지부'
   AND wdate IS NOT NULL
   AND um.user_no != 179951
   AND m.mem_no <= 1566372;

/*
1. 해당 쿼리는 162이나 161번에서는 사용 불가
2. user_lrea_update.txt 파일에 해당 결과를 복사 붙여넣고 수동으로 저장
3. 행의 수는 165555개 이다.
4. 
*/



-- update 테이블 생성
-- tb_com_user의 test 테이블 만들기(update 용)
CREATE TABLE sc_khb_srv.tb_user_lrea_update (
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

BULK INSERT sc_khb_srv.tb_user_lrea_update
       FROM 'D:\migra_data\user_lrea_update.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '|||',
             ROWTERMINATOR = '\n'
);


alter table sc_khb_srv.tb_user_lrea_update add constraint pk_tb_user_lrea_update primary key(user_no_pk);

SELECT * FROM sc_khb_srv.tb_user_lrea_update;


-- tb_lrea_office_info 테이블에 이메일 삽입
UPDATE sc_khb_srv.tb_lrea_office_info
   SET eml = ulu.email
  FROM sc_khb_srv.tb_lrea_office_info loi
       LEFT JOIN 
       sc_khb_srv.tb_user_lrea_update ulu
               ON loi.lrea_office_info_pk = ulu.lrea_office_info_pk;

/*업데이트 후 확인*/
SELECT lrea_office_info_pk, lrea_office_rprsv_nm, eml
  FROM sc_khb_srv.tb_lrea_office_info
 WHERE eml IS NOT NULL;



-- tb_com_user의 공인중개사(02) 업데이트
/*user_id*/
UPDATE sc_khb_srv.tb_com_user
   SET user_id = ulu.user_id
  FROM sc_khb_srv.tb_com_user cu
       INNER JOIN
       sc_khb_srv.tb_user_lrea_update ulu
               ON cu.lrea_office_info_pk = ulu.lrea_office_info_pk
 WHERE cu.user_se_code = '02'
   AND cu.lrea_office_info_pk = cu.lrea_office_info_pk;

/*업데이트 후 확인*/
SELECT lrea_office_info_pk
     , user_nm
     , user_id
  FROM sc_khb_srv.tb_com_user 
 WHERE user_se_code = '02';


/*email*/
UPDATE sc_khb_srv.tb_com_user
   SET email = ulu.email
  FROM sc_khb_srv.tb_com_user cu
       INNER JOIN
       sc_khb_srv.tb_user_lrea_update ulu
               ON cu.lrea_office_info_pk = ulu.lrea_office_info_pk
 WHERE cu.user_se_code = '02'
   AND cu.lrea_office_info_pk = cu.lrea_office_info_pk;

/*업데이트 후 확인*/
SELECT lrea_office_info_pk
     , user_id
     , email
  FROM sc_khb_srv.tb_com_user
 WHERE user_se_code = '02';



-- tb_com_job_schdl_info의 time_stamp UPDATE







-- tb_atlfsl_bsc_info 테이블 rcmdtn_yn, auc_yn, atlfsl_stts_cd UPDATE








-- tb_atlfsl_dlng_info 테이블 mng_amt UPDATE















