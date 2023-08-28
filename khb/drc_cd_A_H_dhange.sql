/*
작성일: 230824
수정일: 
작성자: 조건영
작성 목적
 - com_code의 앱 방향 데이터를 삭제
 - 매물_기초 정보에 있는 영어로 된 방향 코드를 숫자 코드로 바꿈
*/

-- 데이터 확인
SELECT *
  FROM sc_khb_srv.tb_com_code;
 WHERE parnts_code_pk = 101;

SELECT atlfsl_bsc_info_pk, drc_cd
  FROM sc_khb_srv.tb_atlfsl_bsc_info;

-- A => H
/*앱과 협회에서 쓰는 코드을 매핑하기 위한 코드*/
SELECT L.code "H_code"
     , R.code "A_code"
     , L.code_nm "code_nm"
  FROM (
        SELECT code, code_nm
          FROM sc_khb_srv.tb_com_code
         WHERE parnts_code_pk = 111
           AND code_pk != parnts_code_pk
       ) L
       LEFT JOIN
       (
        SELECT code, code_nm
          FROM sc_khb_srv.tb_com_code
         WHERE parnts_code_pk = 101
           AND code_pk != parnts_code_pk
       ) R
              ON R.code_nm = L.code_nm;
/*
기존 매칭
H_code, A_code, code_nm
01	    EE	    동
02	    WW	    서
03	    SS	    남
04	    NN	    북
05	    ES	    남동
06	    WS	    남서
07	    EN	    북동
08	    WN	    북서
09	    	    없음
*/


-- tb_atlfsl_bsc_info 의 drc_cd 열 값변경 
/*
영어로 되어 있던 데이터를 숫자로 변경
 ex) EE => 01, WS => 06
*/
WITH a_h_cd_change AS 
(
 SELECT L.code "H_code"
      , R.code "A_code"
      , L.code_nm "code_nm"
   FROM (
         SELECT code, code_nm
           FROM sc_khb_srv.tb_com_code
          WHERE parnts_code_pk = 111
            AND code_pk != parnts_code_pk
        ) L
        LEFT JOIN
        (
         SELECT code, code_nm
           FROM sc_khb_srv.tb_com_code
          WHERE parnts_code_pk = 101
            AND code_pk != parnts_code_pk
        ) R
               ON R.code_nm = L.code_nm
)
UPDATE sc_khb_srv.tb_atlfsl_bsc_info 
   SET drc_cd = ah.H_code
  FROM sc_khb_srv.tb_atlfsl_bsc_info bi
       LEFT JOIN
       a_h_cd_change ah
           ON bi.drc_cd = ah.a_code;



-- 백업 데이터 생성
SELECT 'insert into sc_khb_srv.tb_com_code values (' +
       CAST(code_pk AS nvarchar(max)) + ', ' +
       CAST(parnts_code_pk AS nvarchar(max)) + ', ' +
       '''' + code + ''', ' +
       '''' + code_nm + ''', ' +
       CASE WHEN sort_ordr IS NULL THEN 'NULL, '
            ELSE CAST(sort_ordr AS nvarchar(max)) + ', ' 
       END +
       '''' + use_at + ''', ' +
       CASE WHEN regist_id IS NULL THEN 'NULL,'
            ELSE '''' + regist_id + ''', '
       END +
       '''' + format(regist_dt, 'yyyy-MM-dd hh:mm:ss.fff') + ''', ' +
       CASE WHEN updt_id IS NULL THEN 'NULL, '
            ELSE '''' + updt_id + ''', ' 
       END +
       CASE WHEN updt_dt IS NULL THEN 'NULL, '
            ELSE '''' + format(updt_dt, 'yyyy-MM-dd hh:mm:ss.fff') + ''', ' 
       END +
       CASE WHEN rm_cn IS NULL THEN 'NULL, '
            ELSE '''' + rm_cn + ''', '
       END  + 
       '''' + parnts_code + ''');'
  FROM sc_khb_srv.tb_com_code
 WHERE parnts_code_pk = 101;


-- 삽입(백업) 쿼리
/*
앱 방향 코드 백업을 위한 쿼리문
데이터 순서: code_pk, parnts_code_pk, code, code_nm, sort_ordr, use_at, regist_id, regist_dt, updt_id, updt_dt, rm_cn, parnts_code
*/
insert into sc_khb_srv.tb_com_code values (101, 101, 'A170', '방향', NULL, 'Y', NULL,'2023-06-02 06:38:12.467', NULL, NULL, '한방-네이버 코드 연동', 'A170       ');
insert into sc_khb_srv.tb_com_code values (172, 101, 'EE', '동', 1, 'Y', NULL,'2023-06-02 06:38:37.453', NULL, NULL, NULL, 'A170');
insert into sc_khb_srv.tb_com_code values (173, 101, 'EN', '북동', 7, 'Y', NULL,'2023-06-02 06:38:37.453', NULL, NULL, NULL, 'A170');
insert into sc_khb_srv.tb_com_code values (174, 101, 'ES', '남동', 5, 'Y', NULL,'2023-06-02 06:38:37.453', NULL, NULL, NULL, 'A170');
insert into sc_khb_srv.tb_com_code values (175, 101, 'NN', '북', 4, 'Y', NULL,'2023-06-02 06:38:37.453', NULL, NULL, NULL, 'A170');
insert into sc_khb_srv.tb_com_code values (176, 101, 'SS', '남', 3, 'Y', NULL,'2023-06-02 06:38:37.453', NULL, NULL, NULL, 'A170');
insert into sc_khb_srv.tb_com_code values (177, 101, 'WN', '북서', 8, 'Y', NULL,'2023-06-02 06:38:37.453', NULL, NULL, NULL, 'A170');
insert into sc_khb_srv.tb_com_code values (178, 101, 'WS', '남서', 6, 'Y', NULL,'2023-06-02 06:38:37.453', NULL, NULL, NULL, 'A170');
insert into sc_khb_srv.tb_com_code values (179, 101, 'WW', '서', 2, 'Y', NULL,'2023-06-02 06:38:37.453', NULL, NULL, NULL, 'A170');


-- 앱 방향 데이터 삭제
DELETE FROM sc_khb_srv.tb_com_code WHERE parnts_code_pk = 101;






































