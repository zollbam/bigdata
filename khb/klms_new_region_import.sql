/*
작성일 : 23-08-04
수정일 : 23-08-04
작성자 : 조건영
사용DB : mssql2016 한방테스트 162번
사용목적 : 변경된 시도 데이터들을 상대로 좌표가 잘 들어가는지 확인하기 위해
*/

-- tb_com_emd_li_cd 테이블 생성
CREATE TABLE sc_khb_srv.tb_com_emd_li_new_cd (
  emd_li_cd_pk sc_khb_srv.pk_n18 NOT NULL
, ctpv_cd_pk sc_khb_srv.pk_n18 NOT NULL
, sgg_cd_pk sc_khb_srv.pk_n18 NOT NULL
, emd_li_nm sc_khb_srv.nm_nv500
, all_emd_li_nm sc_khb_srv.nm_nv500
, emd_li_crdnt geometry
, stdg_dong_se_cd sc_khb_srv.cd_v20
, stdg_dong_cd sc_khb_srv.cd_v20
, synchrn_pnttm_vl sc_khb_srv.vl_v100
, emd_li_crdnt_tmp sc_khb_srv.crdnt_v500
);

bulk insert sc_khb_srv.tb_com_emd_li_new_cd
from 'D:\migra_data\new_dong_code.txt'
with (
    codepage = '65001'
  , fieldterminator = '||'
  , rowterminator = '\n'
);

alter table sc_khb_srv.tb_com_emd_li_new_cd add constraint pk_tb_com_emd_li_new_cd primary key(emd_li_cd_pk);

update sc_khb_srv.tb_com_emd_li_new_cd set emd_li_crdnt = geometry::STPointFromText(emd_li_crdnt_tmp, 4326) WHERE emd_li_crdnt_tmp NOT LIKE '%null%' AND emd_li_crdnt_tmp NOT LIKE '%0.0%';

alter table sc_khb_srv.tb_com_emd_li_new_cd drop column emd_li_crdnt_tmp;



-- tb_com_sgg_cd 테이블 생성
CREATE TABLE sc_khb_srv.tb_com_new_sgg_cd (
  sgg_cd_pk sc_khb_srv.pk_n18 NOT NULL
, ctpv_cd_pk sc_khb_srv.pk_n18 NOT NULL
, sgg_nm sc_khb_srv.nm_nv500
, sgg_crdnt geometry
, stdg_dong_se_cd sc_khb_srv.cd_v20
, synchrn_pnttm_vl sc_khb_srv.vl_v100
);

BULK INSERT sc_khb_srv.tb_com_new_sgg_cd
       FROM 'D:\migra_data\new_gugun_code.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_com_new_sgg_cd add constraint pk_tb_com_new_sgg_cd primary key(sgg_cd_pk);



-- tb_com_ctpv_cd 테이블 생성
CREATE TABLE sc_khb_srv.tb_com_new_ctpv_cd (
  ctpv_cd_pk sc_khb_srv.pk_n18 NOT NULL
, ctpv_nm sc_khb_srv.nm_nv500
, ctpv_abbrev_nm sc_khb_srv.nm_nv500
, ctpv_crdnt geometry
, synchrn_pnttm_vl sc_khb_srv.vl_v100
);

bulk insert sc_khb_srv.tb_com_new_ctpv_cd
from 'D:\migra_data\sido_new_code.txt'
with (
    codepage = '65001'
  , fieldterminator = '||'
  , rowterminator = '0x0a'
);

alter table sc_khb_srv.tb_com_new_ctpv_cd add constraint pk_tb_com_new_ctpv_cd primary key(ctpv_cd_pk);

SELECT * FROM sc_khb_srv.tb_com_new_ctpv_cd;



-- 시도/시군구 코드별 좌표 테이블 생성
CREATE TABLE sc_khb_srv.sd_region_new_crdnt(
    code varchar(500)
   ,crdnt varchar(500)
);

BULK INSERT sc_khb_srv.sd_region_new_crdnt
       FROM 'D:\migra_data\crdnt_new.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);



-- 시도 매칭 (klms <=>  161/162서버)
CREATE VIEW sc_khb_srv.tb_new_sdmat
AS
SELECT
	  cd.ctpv_cd_pk
	, ssc.crdnt
  FROM (
        SELECT DISTINCT
	          ctpv_cd_pk 
	        , substring(stdg_dong_cd, 1, 2) "ctpv_cd"
          FROM sc_khb_srv.tb_com_emd_li_new_cd
       ) cd
       INNER JOIN
       sc_khb_srv.sd_region_new_crdnt ssc
           ON cd.ctpv_cd = ssc.code;

SELECT * FROM sc_khb_srv.sd_region_new_crdnt;



-- 시도 좌표 삽입
UPDATE sc_khb_srv.tb_com_new_ctpv_cd SET ctpv_crdnt = tb_new_sdmat.crdnt
  FROM sc_khb_srv.tb_new_sdmat
 WHERE tb_com_new_ctpv_cd.ctpv_cd_pk = tb_new_sdmat.ctpv_cd_pk;

SELECT * FROM sc_khb_srv.tb_com_new_ctpv_cd;



-- 시군구 매칭 (klms <=>  161/162서버)
CREATE VIEW sc_khb_srv.tb_sggmat
AS
SELECT
  sggmat.sgg_cd_pk
, ssc.code
, ssc.crdnt
  FROM sc_khb_srv.sd_region_new_crdnt ssc
       INNER JOIN 
       (
        SELECT DISTINCT
          sgg_cd_pk "sgg_cd_pk"
        , substring(stdg_dong_cd, 1, 5) "sgg_cd"
          FROM sc_khb_srv.tb_com_emd_li_cd
         WHERE (sgg_cd_pk != 252 AND substring(stdg_dong_cd, 1, 5) != '43113' AND stdg_dong_se_cd != 'H') -- 43113, 250 인 데이터 뺵기
                OR 
               (sgg_cd_pk != 248 AND substring(stdg_dong_cd, 1, 5) != '43111' AND stdg_dong_se_cd != 'H') -- 43111, 248 인 데이터 빼기
       ) sggmat
           on ssc.code = sggmat.sgg_cd
 ORDER BY 2;



-- 시군구 좌표 삽입
UPDATE sc_khb_srv.tb_com_new_sgg_cd SET sgg_crdnt = tb_sggmat.crdnt
  FROM sc_khb_srv.tb_sggmat
 WHERE tb_com_new_sgg_cd.sgg_cd_pk = tb_sggmat.sgg_cd_pk;

SELECT * FROM sc_khb_srv.tb_com_new_sgg_cd;





























