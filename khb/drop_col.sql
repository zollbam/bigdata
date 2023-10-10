/*
230927에 추가된 칼럼 중 누락 컬럼 조사 및 추가 사항

작성 일시: 23-10-05
수정 일시: 
작 성 자 : 조건영

2. 9.27. 컬럼 추가 요청에 빠진 컬럼들(추가 필요, cs MAMUL 테이블의 기준 컬럼명)
  1) 군락형태 - gunrak_cd => (atlfsl_se_cd, 매물_구분_코드)
  2) 분양권구분 - saleType => (atlfsl_se_cd, 매물_구분_코드)
  3) 건축구조 - const_struc_cd => (atlfsl_strct_cd, 매물_구조_코드)
  4) 물건종류 - sukbak_cate_cd => (atlfsl_se_cd, 매물_구분_코드)
  5) 건물종류 - building_cate_cd => (atlfsl_usg_cd, 매물_용도_코드)
  6) 공장형태 - factory_type_cd => (atlfsl_se_cd, 매물_구분_코드)


3. 추가사항
  1) 넣어주신 매물_입지_코드(atlfsl_lct_cd)에 따른 공통코드 필요
    - 기존 입지, 입지조건, 상가입지, 사무실 입지 별도 공통코드가 존재했었음
      > 합쳐진 컬럼의 공통코드가 필요함

*/


--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 22222222222222222222222222222222 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓--

-- gunrak_cd => atlfsl_se_cd
SELECT mm_no, gunrak_cd, tabi.atlfsl_se_cd
  FROM KMLS.dbo.MAMUL m 
       INNER JOIN 
       sc_khb_srv.tb_atlfsl_bsc_info tabi 
               ON m.mm_no = tabi.asoc_atlfsl_no
 WHERE m.gunrak_cd <> '';
   AND gunrak_cd <> tabi.atlfsl_se_cd;





-- saleType => atlfsl_se_cd
SELECT mm_no, saleType, tabi.atlfsl_se_cd
  FROM KMLS.dbo.MAMUL m
       INNER JOIN 
       sc_khb_srv.tb_atlfsl_bsc_info tabi
               ON m.mm_no = tabi.asoc_atlfsl_no
 WHERE saleType <> ''
   AND saleType <> tabi.atlfsl_se_cd;





-- sukbak_cate_cd => atlfsl_se_cd
SELECT mm_no, sukbak_cate_cd, tabi.atlfsl_se_cd
  FROM KMLS.dbo.MAMUL m
       INNER JOIN 
       sc_khb_srv.tb_atlfsl_bsc_info tabi
               ON m.mm_no = tabi.asoc_atlfsl_no
 WHERE sukbak_cate_cd <> ''
   AND sukbak_cate_cd <> tabi.atlfsl_se_cd;





-- factory_type_cd => atlfsl_se_cd
SELECT mm_no, factory_type_cd, tabi.atlfsl_se_cd
  FROM KMLS.dbo.MAMUL m
       INNER JOIN 
       sc_khb_srv.tb_atlfsl_bsc_info tabi
               ON m.mm_no = tabi.asoc_atlfsl_no
 WHERE factory_type_cd <> ''
   AND factory_type_cd <> tabi.atlfsl_se_cd;





-- const_struc_cd => atlfsl_strct_cd
SELECT mm_no, const_struc_cd, tabi.atlfsl_strct_cd
  FROM KMLS.dbo.MAMUL m
       INNER JOIN 
       sc_khb_srv.tb_atlfsl_bsc_info tabi
               ON m.mm_no = tabi.asoc_atlfsl_no
 WHERE const_struc_cd <> ''
   AND const_struc_cd <> tabi.atlfsl_strct_cd;





-- building_cate_cd => atlfsl_usg_cd
SELECT mm_no, building_cate_cd, tabi.atlfsl_usg_cd
  FROM KMLS.dbo.MAMUL m
       INNER JOIN 
       sc_khb_srv.tb_atlfsl_bsc_info tabi
               ON m.mm_no = tabi.asoc_atlfsl_no
 WHERE building_cate_cd <> ''
   AND building_cate_cd <> tabi.atlfsl_usg_cd;





--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 333333333333333333333333333333333 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓--
SELECT *
  FROM
      (
SELECT mm_no
     , CASE WHEN officetel_use_cd <> '' THEN officetel_use_cd -- 오피스텔용도(G140)
            WHEN building_cate_cd <> '' THEN building_cate_cd -- 건물종류(재개발)(G340)
            WHEN building_use_cd <> '' THEN building_use_cd -- 건물주용도(G520)
            WHEN store_use_cd <> '' THEN store_use_cd -- 주용도_상가점포(G550)
            WHEN office_use_cd <> '' THEN office_use_cd -- 주용도_사무실(G560)
--            WHEN const_use_cd <> '' THEN const_use_cd -- 건물용도(G310)
            else '' 
		END "atlfsl_usg_cd_kmls"
     , tabi.atlfsl_usg_cd atlfsl_usg_cd
	 , CASE WHEN gunrak_cd <> '' THEN gunrak_cd -- 군락형태(G320)
		    WHEN sangga_cd <> '' THEN sangga_cd -- 상가구분(G350)
		    WHEN sukbak_cate_cd <> '' THEN sukbak_cate_cd -- 숙박물건종류(G400)
            WHEN factory_type_cd <> '' THEN factory_type_cd -- 공장형태(G420)
            WHEN factory_cate <> '' THEN factory_cate -- 공장종류
            WHEN saleType <> '' THEN saleType -- 분양구분
--            WHEN building_cate_cd <> '' THEN building_cate_cd -- 건물종류(재개발)(G340)
--            WHEN warehouse_type_cd <> '' THEN warehouse_type_cd -- 창고형태(G470)
--            WHEN building_type_cd <> '' THEN building_type_cd -- 건물유형(G460)
            ELSE ''
        END "atlfsl_se_cd_kmls"
     , tabi.atlfsl_se_cd atlfsl_se_cd
     , CASE WHEN sukbak_ipji_cd <> '' THEN sukbak_ipji_cd -- 숙박입지(G410)
            WHEN factory_ipji_cd <> '' THEN factory_ipji_cd -- 공장입지(G440)
	        WHEN office_ipji_cd <> '' THEN office_ipji_cd -- 사무실입지(G570)
	        WHEN sangga_ipji_cd <> '' THEN sangga_ipji_cd -- 상가입지(G580)
            ELSE ''
        END "atlfsl_lct_cd_kmls"
     , tabi.atlfsl_lct_cd atlfsl_lct_cd
     , CASE WHEN room_cd <> '' THEN room_cd -- 방구조(G250)
	        WHEN const_struc_cd <> '' THEN const_struc_cd -- 건축구조(공장)(G450)
            ELSE ''
        END "atlfsl_strct_cd_kmls"
     , tabi.atlfsl_strct_cd atlfsl_strct_cd
  FROM KMLS.dbo.mamul m
       INNER JOIN
       sc_khb_srv.tb_atlfsl_bsc_info tabi
               ON m.mm_no = tabi.asoc_atlfsl_no
 WHERE mm_no !=0
      ) a
 WHERE atlfsl_strct_cd_kmls <> atlfsl_strct_cd
--       atlfsl_usg_cd_kmls <> atlfsl_usg_cd
--       atlfsl_se_cd_kmls <> atlfsl_se_cd
--       atlfsl_lct_cd_kmls <> atlfsl_lct_cd
--       atlfsl_strct_cd_kmls <> atlfsl_strct_cd
 ORDER BY mm_no;





-- 코드 찾기
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE code_nm like '%분양%';




-- 매물종류
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H100';

/*
01	아파트
02	아파트분양권
03	주상복합
04	주상복합분양권
05	오피스텔
06	오피스텔분양권
07	연립
08	빌라
09	다세대
10	단독
11	다가구
12	상가주택
13	원룸
14	상가점포
15	상업용건물
16	사무실
18	토지
19	재개발
20	숙박
21	펜션
22	전원주택
23	공장
24	지식산업센터
25	창고
*/

---- atlfsl_usg_cd ----

-- 오피스텔 용도
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H140';

-- 건물종류(재개발)
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H340';

-- 건물-주용도
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H520';

-- 상가점포 주용도
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H550';

-- 사무실 주용도
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H560';


-- 건물용도 (const_use_cd)
--SELECT *
--  FROM sc_khb_srv.tb_com_code tcc
-- WHERE parnts_code = 'H310';



---- atlfsl_se_cd ----

-- 군락형태
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H320';

-- 상가구분
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H350';

-- 숙박물건종류
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H400';

-- 공장형태
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H420';

/* 공장종류와 분양구분은 코드가 존재 X */



---- atlfsl_lct_cd ----

-- 입지조건(숙박)
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H410';

-- 입지(공장,아파트형공장,창고)
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H440';

-- 입지(공장,아파트형공장,창고)
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H570';

-- 입지(공장,아파트형공장,창고)
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H580';



---- atlfsl_strct_cd ----

-- 룸구조
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H250';

-- 건축구조
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H450';




