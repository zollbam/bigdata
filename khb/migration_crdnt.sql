/*
작 성 일 : 230706
수 정 일 : 230720
작 성 자 : 조 건 영
사용 DB : mssql 2016 , 161번
사용 스키마 : sc_khb_srv 
작성 목적 : postgre에서 뽑아낸 좌표를 파일을 mssql의 좌표 데이터로 이관
 */

-- 시도/시군구 테이블 생성
CREATE TABLE sc_khb_srv.sd_sgg_crdnt(
    code varchar(500)
   ,crdnt varchar(500)
);


BULK INSERT sc_khb_srv.sd_sgg_crdnt
       FROM 'D:\migra_data\crdnt.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

SELECT * FROM sc_khb_srv.sd_sgg_crdnt;

-- 잘못입력된 데이터
SELECT DISTINCT
  s2.sgg_cd_pk 
, s2.sgg_nm "시군구 명"
, LEFT(d.stdg_dong_cd,5) "시군구 코드"
  FROM sc_khb_srv.tb_com_sgg_cd s2
       left JOIN 
       sc_khb_srv.tb_com_emd_li_cd d
           ON s2.sgg_cd_pk = d.sgg_cd_pk
 WHERE LEFT(d.stdg_dong_cd,5) IN ('43111', '43113');

/*
1) 43111
 - 청주시 청원구
 - 청주시 상당구 => O
2) 43113
 - 청주시 흥덕구 => O
 - 청주시 서원구
3) 44130
 - 천안시 데이터 없음
4) 48120
 - 창원시 데이터 없음
*/


-- 시군구 pk와 시군구 코드 매칭
CREATE VIEW sc_khb_srv.tb_sggmat
AS
SELECT
  sggmat.sgg_cd_pk
, ssc.crdnt
  FROM sc_khb_srv.sd_sgg_crdnt ssc
       INNER JOIN 
       (SELECT DISTINCT
          sgg_cd_pk "sgg_cd_pk"
        , substring(stdg_dong_cd, 1, 5) "sgg_cd"
          FROM sc_khb_srv.tb_com_emd_li_cd
         WHERE (sgg_cd_pk != 252 AND substring(stdg_dong_cd, 1, 5) != '43113' AND stdg_dong_se_cd != 'H') -- 43113, 250 인 데이터 뺵기
                OR 
               (sgg_cd_pk != 248 AND substring(stdg_dong_cd, 1, 5) != '43111' AND stdg_dong_se_cd != 'H') -- 43111, 248 인 데이터 빼기
       ) sggmat
           on ssc.code = sggmat.sgg_cd;


-- 시군구 테이블에 좌표 데이터 삽입
UPDATE sc_khb_srv.tb_com_sgg_cd SET sgg_crdnt = tb_sggmat.crdnt
  FROM sc_khb_srv.tb_sggmat
 WHERE tb_com_sgg_cd.sgg_cd_pk = tb_sggmat.sgg_cd_pk;


-- 시도pk 시도코드 매칭
CREATE VIEW sc_khb_srv.tb_sdmat
AS
SELECT
  cd.ctpv_cd_pk
, ssc.crdnt
  FROM (SELECT DISTINCT
          ctpv_cd_pk 
        , substring(stdg_dong_cd, 1, 2) "ctpv_cd"
           FROM sc_khb_srv.tb_com_emd_li_cd
       ) cd
       INNER JOIN
       sc_khb_srv.sd_sgg_crdnt ssc
           ON cd.ctpv_cd = ssc.code;


-- 시군구 테이블에 좌표 데이터 삽입
UPDATE sc_khb_srv.tb_com_ctpv_cd SET ctpv_crdnt = tb_sdmat.crdnt
  FROM sc_khb_srv.tb_sdmat
 WHERE tb_com_ctpv_cd.ctpv_cd_pk = tb_sdmat.ctpv_cd_pk;


-- 생성한 뷰
DROP VIEW sc_khb_srv.tb_sggmat;
DROP VIEW sc_khb_srv.tb_sdmat;







----------------------------------------------------------------이해 안 가는 부분 분석----------------------------------------------------------------
-- 테이블
SELECT *
  FROM sc_khb_srv.tb_com_emd_li_cd;
/*
23846 행
*/
 
CREATE TABLE sc_khb_srv.sd_sgg_crdnt(
    code varchar(500)
   ,crdnt varchar(500)
);


BULK INSERT sc_khb_srv.sd_sgg_crdnt
       FROM 'D:\migra_data\crdnt.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

CREATE VIEW sc_khb_srv.tb_sggmat
AS
SELECT
  sggmat.sgg_cd_pk
, ssc.code
, ssc.crdnt
  FROM sc_khb_srv.sd_sgg_crdnt ssc
       INNER JOIN 
       (SELECT DISTINCT
          sgg_cd_pk "sgg_cd_pk"
        , substring(stdg_dong_cd, 1, 5) "sgg_cd"
          FROM sc_khb_srv.tb_com_emd_li_cd
         WHERE (sgg_cd_pk != 252 AND substring(stdg_dong_cd, 1, 5) != '43113' AND stdg_dong_se_cd != 'H') -- 43113, 250 인 데이터 뺵기
                OR 
               (sgg_cd_pk != 248 AND substring(stdg_dong_cd, 1, 5) != '43111' AND stdg_dong_se_cd != 'H') -- 43111, 248 인 데이터 빼기
       ) sggmat
           on ssc.code = sggmat.sgg_cd;

SELECT * FROM sc_khb_srv.tb_sggmat;

-- 행정동
SELECT a.sgg_code, sgg_code_pk, count(*)
  FROM (
        SELECT DISTINCT
          substring(stdg_dong_cd, 1, 5) "sgg_code"
        , sgg_cd_pk "sgg_code_pk"
          FROM sc_khb_srv.tb_com_emd_li_cd
         WHERE stdg_dong_se_cd = 'H'
         GROUP BY substring(stdg_dong_cd, 1, 5), sgg_cd_pk) a
 GROUP BY a.sgg_code, sgg_code_pk
 ORDER BY 1, 2;
/*
1. 전체 : 3564 행
2. 시군구 코드 : 252 행
3. 행정동에서 잘못된 데이터
 1) 43111 + 248
 2) 43113 + 252
*/

-- 1) 올바른 데이터
SELECT
  emd_li_cd_pk
, ctpv_cd_pk
, sgg_cd_pk
, emd_li_nm
, all_emd_li_nm
, emd_li_crdnt.STAsText()
, stdg_dong_se_cd
, stdg_dong_cd
, synchrn_pnttm_vl
  FROM sc_khb_srv.tb_com_emd_li_cd 
 WHERE substring(stdg_dong_cd, 1, 5) = '43111' AND sgg_cd_pk = '249'
UNION 
SELECT
  emd_li_cd_pk
, ctpv_cd_pk
, sgg_cd_pk
, emd_li_nm
, all_emd_li_nm
, emd_li_crdnt.STAsText()
, stdg_dong_se_cd
, stdg_dong_cd
, synchrn_pnttm_vl
  FROM sc_khb_srv.tb_com_emd_li_cd
 WHERE substring(stdg_dong_cd, 1, 5) = '43113' AND sgg_cd_pk = '250';

-- 2) 잘못 된 데이터
SELECT
  emd_li_cd_pk
, ctpv_cd_pk
, sgg_cd_pk
, emd_li_nm
, all_emd_li_nm
, emd_li_crdnt.STAsText()
, stdg_dong_se_cd
, stdg_dong_cd
, synchrn_pnttm_vl
  FROM sc_khb_srv.tb_com_emd_li_cd 
 WHERE substring(stdg_dong_cd, 1, 5) = '43111' AND sgg_cd_pk = '248'
UNION 
SELECT
  emd_li_cd_pk
, ctpv_cd_pk
, sgg_cd_pk
, emd_li_nm
, all_emd_li_nm
, emd_li_crdnt.STAsText()
, stdg_dong_se_cd
, stdg_dong_cd
, synchrn_pnttm_vl
  FROM sc_khb_srv.tb_com_emd_li_cd
 WHERE substring(stdg_dong_cd, 1, 5) = '43113' AND sgg_cd_pk = '252';





-- 법정동
SELECT a.sgg_code, sgg_code_pk, count(*)
  FROM (
        SELECT DISTINCT
          substring(stdg_dong_cd, 1, 5) "sgg_code"
        , sgg_cd_pk "sgg_code_pk"
          FROM sc_khb_srv.tb_com_emd_li_cd
         WHERE stdg_dong_se_cd = 'B'
         GROUP BY substring(stdg_dong_cd, 1, 5), sgg_cd_pk) a
 GROUP BY a.sgg_code, sgg_code_pk
 ORDER BY 1, 2;
/*
전체 : 20282 행
시군구 코드 : 250 행
*/





-- 법정동과 행정동에서 동시에 없는 시군구 코드
SELECT DISTINCT substring(stdg_dong_cd, 1, 5) "H_sgg_code"
  FROM sc_khb_srv.tb_com_emd_li_cd
 WHERE stdg_dong_se_cd = 'H'
EXCEPT
SELECT DISTINCT
          substring(stdg_dong_cd, 1, 5) "B_sgg_code"
  FROM sc_khb_srv.tb_com_emd_li_cd
 WHERE stdg_dong_se_cd = 'B';


























