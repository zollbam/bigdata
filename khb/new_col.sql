/*
작성일: 231010
수정일: 
작성자: 조건영
작성 목적: 기존 테이블에 추가되는 새로운 열 정리 => update필요!!
*/

-- 1. tb_atlfsl_bsc_info

/*
1. 신규 신청 (cs MAMUL 테이블의 기준 컬럼명)
  1) 현관구조 - stair_cd 
   - 현관?? 계단??
   - tb_atlfsl_bsc_info테이블에 stairs_stle_cd열 존재
  2) 건물유형 - building_type_cd
   - 공통코드인 데이터
   - 열을 합치는 것이 좋을지 나누는 것이 좋을지 생각 필요
    => 매물_형태_코드라는 열을 만들어
       factory_type_cd, building_type_cd, warehouse_type_cd을 합칠까??
  3) 관리비 항목 - mnexItem_info
  4) 형태 - warehouse_type_cd
  5) 구역명 - zone
*/

-- 1) 현관구조 - stair_cd
/*열 존재*/
SELECT atlfsl_bsc_info_pk, stairs_stle_cd
  FROM sc_khb_srv.tb_atlfsl_bsc_info tabi;

/*cs와 app 비교*/
SELECT tabi.atlfsl_bsc_info_pk
     , tabi.asoc_atlfsl_no
     , tabi.stairs_stle_cd "app"
     , m.stair_cd "kmls"
  FROM sc_khb_srv.tb_atlfsl_bsc_info tabi
       INNER JOIN
       KMLS.dbo.mamul m
               ON tabi.asoc_atlfsl_no = m.mm_no
 WHERE tabi.stairs_stle_cd <> m.stair_cd;

/*cs와 기존 app 비교*/
SELECT a.product_no "pre_app_product_no"
     , m.mm_no "kmls_mm_no"
     , a.stair_cd "pre_app"
     , m.stair_cd "kmls"
  FROM (
        SELECT product_no, stair_cd
          FROM hanbang.hanbang.article_type_ab_info atai
         WHERE PRODUCT_NO NOT IN (20573945, 20572451, 20630308, 11750025, 20540281, 20240916, 20278099, 11713105, 19837747)
         UNION 
        SELECT product_no, stair_cd
          FROM hanbang.hanbang.article_type_c_info atci
       ) a
       INNER JOIN
       KMLS.dbo.mamul m
               ON a.product_no = m.mm_no
 WHERE a.stair_cd <> m.stair_cd;

/*
 * 1. stairs_stle_cd
 *  - maria의 stair_cd를 가져와 벌써 열이 만들어져 있다
 * 2. 서로 다른 값 존재(cs vs app)
 *  - 161번에는 125개
 *  - cloud에는 276개
 * 3. 서로 다른 값 존재(cs vs 기존 app)
 *  - MAMUL테이블의 6716378개 데이터중 67733개 존재한다.
*/





-- 2) 건물유형 - building_type_cd(공통코드 460)
/*건물유형 고유값*/
SELECT DISTINCT building_type_cd
  FROM KMLS.dbo.MAMUL
 ORDER BY 1;

/*com_code*/
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H460';

/*
 * 1. 고유값
 *  - 01~04존재
 * 2. 공통코드
 *  - 01(아파트형), 02(지원시설), 03(상가내), 04(주택일부)
 * 3. 열 생성
 *  - 벌써 열이 생성된 "매물_구분_코드"에 사용되는 factory_type_cd의 코드명은 형태이지만
 *    동일한 유형의 열이름을 사용하는 building_type_cd는 유형이라 "매물_구분_코드"에 합칠지
 *    다른 열을 만들지 고민!!
*/





-- 3) 관리비 항목 - mnexItem_info
SELECT mm_no
     , mnexItem_info
     , len(mnexItem_info)
  FROM kmls.dbo.mamul
 WHERE mnexItem_info IS NOT NULL
   AND mnexItem_info <> ''
 ORDER BY len(mnexItem_info) DESC;

/*
 * 1. 길이
 *  - 최대 길이 16
 * 2. 열이름
 *  - 관리비_내용(managect_cn)
*/
SELECT pstn_expln_cn FROM sc_khb_srv.tb_atlfsl_bsc_info;




-- 4) 형태 - warehouse_type_cd(공통코드 470)
/*건물유형 고유값*/
SELECT DISTINCT warehouse_type_cd
  FROM KMLS.dbo.MAMUL
 ORDER BY 1;

/*com_code*/
SELECT *
  FROM sc_khb_srv.tb_com_code tcc
 WHERE parnts_code = 'H470';

/*
 * 1. 고유값
 *  - 01~04존재
 * 2. 공통코드
 *  - 01(창고전용), 02(건물일부), 03(야적장), 04(축사)
 * 3. 열 생성
 *  - 벌써 열이 생성된 "매물_구분_코드"에 사용되는 factory_type_cd의 코드명은 형태이고
 *    warehouse_type_cd도 동일한 "형태"라 "매물_구분_코드"에 합칠지
 *    다른 열을 만들지 고민!!
*/





-- 5) 구역명 - zone
/*cate_cd*/
SELECT DISTINCT cate_cd
  FROM KMLS.dbo.mamul
 WHERE ZONE <> '';

/*길이*/
SELECT mm_no
     , ZONE
     , len(ZONE)
  FROM KMLS.dbo.mamul
 WHERE ZONE <> ''
 ORDER BY len(ZONE) DESC;

/*
 * 1. cate_cd
 *  - zone값이 있는 데이터는 '19'로 한글명은 '재개발'
 * 2. 길이
 *  - 최대 길이는 24로 nm_도메인인 nvarchar(500)사용가능
 * 3. 열이름
 *  - 구역_명(zone_nm)
*/





-- 2. tb_user_atlfsl_preocupy_info

/*
tb_user_atlfsl_preocupy_info 사용자 매물 선점정보 테이블 컬럼 추가 요청
1. atlfsl_bsc_info_pk : 매물기본정보PK
 - 해당 컬럼은 공인중개사 팀에서 비지니스로직상 필요한 컬럼
*/

-- 1) atlfsl_bsc_info_pk
/*기존app(maria 15번)*/
SELECT *
  FROM hanbang.hanbang.user_mamul_agent uma;

/*user_atlfsl_info_pk(mm_no) VS asoc_atlfsl_no(mm_no)*/
SELECT tabi.atlfsl_bsc_info_pk
     , tabi.asoc_atlfsl_no
     , tuapi.user_atlfsl_info_pk
  FROM sc_khb_srv.tb_atlfsl_bsc_info tabi
       INNER JOIN
       sc_khb_srv.tb_user_atlfsl_preocupy_info tuapi
               ON tabi.asoc_atlfsl_no = tuapi.user_atlfsl_info_pk;


/*
 * 1. 기존 app에 존재하는 mm_no
 *  - cs에 있는 mm_no열과 동일한줄 알고 매물기초테이블의 asoc_atlfsl_no와 inner join 했지만 0개가 나왔다.
 *   => 열 추가 후 업데이트하는 것이 아니다.
 * 2. 
*/








































