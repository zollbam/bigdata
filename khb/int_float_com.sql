/*
작성일: 231005
수정일: 
작성자: 조건영
작성 목적: kmls와 한방app쪽 정수 실수 비교
*/

-- kmls과 app 매칭 테이블 비교
SELECT m.user_no "kmls", tabi.pic_no "app"
  FROM KMLS.dbo.mamul m 
       INNER JOIN 
       sc_khb_srv.tb_atlfsl_bsc_info tabi
               ON m.mm_no = tabi.asoc_atlfsl_no
 WHERE m.user_no <> tabi.pic_no;




-- 테이블에서 숫자형 컬럼 찾기
SELECT TABLE_NAME
     , COLUMN_NAME
     , DATA_TYPE
  FROM (
		SELECT TABLE_NAME TABLE_NAME
		     , COLUMN_NAME COLUMN_NAME
		     , ORDINAL_POSITION ORDINAL_POSITION
		     , concat(DATA_TYPE, '(', NUMERIC_PRECISION, ',', NUMERIC_SCALE, ')') DATA_TYPE
		     , CASE WHEN charindex('_', COLUMN_NAME) = 0 THEN COLUMN_NAME
		            ELSE replace(substring(RIGHT(COLUMN_NAME, 6), charindex('_', RIGHT(COLUMN_NAME, 6), 2) +1, len(RIGHT(COLUMN_NAME,6))), '_', '')
		        END DO_NAME
		  FROM information_schema.columns
		 WHERE TABLE_SCHEMA = 'sc_khb_srv'
		   AND DATA_TYPE IN ('int', 'numeric', 'decimal')
		   AND TABLE_NAME LIKE 'tb_%'
	   ) a
 WHERE DO_NAME NOT IN ('pk', 'lat', 'lot')
 ORDER BY TABLE_NAME, ORDINAL_POSITION;




-- cs에서 실수 인지 확인
/*tb_atlfsl_bsc_info*/

/*
 * 1. dtl_scrn_prsl_cnt
 *  - app에서만??
*/
--SELECT user_no
--  FROM KMLS.dbo.MAMUL
-- WHERE round(CONVERT(NUMERIC(21, 3), replace(replace(user_no,',',''),'\','')), 1) 
--        - FLOOR(round(CONVERT(NUMERIC(21, 3), replace(replace(user_no,',',''),'\','')), 1)) <> 0;

/*
 * 2. parkng_cnt
 *  - 실수 2개 존재 13212454, 14985643
 *  - 하지만 기초 테이블에는 존재 X
 *  - 161과 cloud에는 벌써 numeric(15,0)에서 decimal(13,3)이라고 타입이 변경된 상태!!
*/
SELECT mm_no, parking 
  FROM KMLS.dbo.MAMUL_KRENAPP_REAL
 WHERE round(CONVERT(NUMERIC(21, 3), replace(replace(parking,',',''),'\','')), 1) 
        - FLOOR(round(CONVERT(NUMERIC(21, 3), replace(replace(parking,',',''),'\','')), 1)) <> 0;

SELECT * FROM sc_khb_srv.tb_atlfsl_bsc_info tabi WHERE asoc_atlfsl_no IN (13212454, 14985643);

/*
 * 3. room_one_cnt
 *  - 실수 1개 존재 441
 *  - 하지만 기초 테이블에는 존재 X
*/
SELECT mm_no, room1_cnt
  FROM KMLS.dbo.MAMUL
 WHERE round(CONVERT(NUMERIC(21, 3), replace(replace(room1_cnt,',',''),'\','')), 1) 
        - FLOOR(round(CONVERT(NUMERIC(21, 3), replace(replace(room1_cnt,',',''),'\','')), 1)) <> 0;

SELECT * FROM sc_khb_srv.tb_atlfsl_bsc_info tabi WHERE asoc_atlfsl_no = 441;

/*
 * 4. room_three_cnt
 *  - 실수 1개 존재 441
 *  - 하지만 기초 테이블에는 존재 X
*/
SELECT mm_no, room3_cnt
  FROM KMLS.dbo.MAMUL
 WHERE round(CONVERT(NUMERIC(21, 3), replace(replace(room3_cnt,',',''),'\','')), 1) 
        - FLOOR(round(CONVERT(NUMERIC(21, 3), replace(replace(room3_cnt,',',''),'\','')), 1)) <> 0;

SELECT * FROM sc_khb_srv.tb_atlfsl_bsc_info tabi WHERE asoc_atlfsl_no = 441;

/*
 * 4. expect_hh_cnt
 *  - 실수 15개 존재
 *  - 하지만 기초 테이블에는 존재 X
*/
SELECT mm_no, estimate_cnt
  FROM KMLS.dbo.MAMUL
 WHERE round(CONVERT(NUMERIC(21, 3), replace(replace(estimate_cnt,',',''),'\','')), 1) 
        - FLOOR(round(CONVERT(NUMERIC(21, 3), replace(replace(estimate_cnt,',',''),'\','')), 1)) <> 0;

SELECT * 
  FROM sc_khb_srv.tb_atlfsl_bsc_info tabi 
 WHERE asoc_atlfsl_no IN (
                          SELECT mm_no
                            FROM KMLS.dbo.MAMUL
						   WHERE round(CONVERT(NUMERIC(21, 3), replace(replace(estimate_cnt,',',''),'\','')), 1) 
						          - FLOOR(round(CONVERT(NUMERIC(21, 3), replace(replace(estimate_cnt,',',''),'\','')), 1)) <> 0
                         );





/*tb_atlfsl_dlng_info*/
/*
 * 1. mng_amt
 *  - 실수 23개 존재 
 *  - 하지만 기초 테이블에는 존재 X
*/
SELECT mm_no, managefee_info
  FROM KMLS.dbo.MAMUL
 WHERE round(CONVERT(NUMERIC(21, 3), replace(replace(managefee_info,',',''),'\','')), 1) 
        - FLOOR(round(CONVERT(NUMERIC(21, 3), replace(replace(managefee_info,',',''),'\','')), 1)) <> 0
   AND isnumeric(managefee_info) = 1;

SELECT * 
  FROM sc_khb_srv.tb_atlfsl_bsc_info tabi 
 WHERE asoc_atlfsl_no IN (
                          SELECT mm_no
						    FROM KMLS.dbo.MAMUL
						   WHERE round(CONVERT(NUMERIC(21, 3), replace(replace(managefee_info,',',''),'\','')), 1) 
						          - FLOOR(round(CONVERT(NUMERIC(21, 3), replace(replace(managefee_info,',',''),'\','')), 1)) <> 0
						     AND isnumeric(managefee_info) = 1
                         );





/*tb_hsmp_info*/
/*
 * 1. cnt_sede_park
 *  - 52598개 데이터 중에 실수 26571개 존재 
 *  - 하지만 기초 테이블에는 존재
*/
SELECT danji_no, cnt_sede_park
  FROM KMLS.dbo.DANJI
 WHERE round(CONVERT(NUMERIC(21, 3), replace(replace(cnt_sede_park,',',''),'\','')), 1) 
        - FLOOR(round(CONVERT(NUMERIC(21, 3), replace(replace(cnt_sede_park,',',''),'\','')), 1)) <> 0;

SELECT *
  FROM sc_khb_srv.tb_hsmp_info thi 
 WHERE hsmp_info_pk IN (
                        SELECT danji_no
						  FROM KMLS.dbo.DANJI
						 WHERE round(CONVERT(NUMERIC(21, 3), replace(replace(cnt_sede_park,',',''),'\','')), 1) 
						        - FLOOR(round(CONVERT(NUMERIC(21, 3), replace(replace(cnt_sede_park,',',''),'\','')), 1)) <> 0
                       );





-- 정수부분 범위 이탈
/*tb_atlfsl_bsc_info*/

/*
 * 1. mno
 *  - 본번이 4자리 이상인 데이터가 존재 new_bon_no는 3개지만, old_bon_no는 1,119
*/
SELECT mm_no, old_bon_no
  FROM KMLS.dbo.MAMUL
 WHERE old_bon_no > 10000;

SELECT mm_no, new_bon_no
  FROM KMLS.dbo.MAMUL
 WHERE new_bon_no > 10000;

/*
 * 2. sno
 *  - 본번이 4자리 이상인 데이터가 존재 new_bon_no는 1개지만, old_bu_no는 3723
*/
SELECT mm_no, old_bu_no 
  FROM KMLS.dbo.MAMUL
 WHERE old_bu_no > 10000;

SELECT count(*)
  FROM KMLS.dbo.MAMUL
 WHERE old_bu_no > 10000;

SELECT mm_no, new_bu_no
  FROM KMLS.dbo.MAMUL
 WHERE new_bu_no > 10000;

/*
 * 2. land_area
 *  - 정수 범위 10자리를 벗어나는 데이터 존재 6개
 *  - 23345275, 26989776, 2065460, 18271434, 22594471, 8241017
*/
SELECT mm_no, toji_meter
  FROM KMLS.dbo.MAMUL
 WHERE toji_meter > 10000000000;

/*
 * 3. qota_area
 *  - 정수 범위 10자리를 벗어나는 데이터 존재 8개
 *  - 12073419, 12487535, 33720011, 25937393, 32793585, 16841357, 30565988, 31894946
*/
SELECT mm_no, jibun_meter
  FROM KMLS.dbo.MAMUL
 WHERE jibun_meter > 10000000000;

















