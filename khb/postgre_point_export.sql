/*
작 성 일 : 230706
수 정 일 : 230719
작 성 자 : 조 건 영
사용 DB : postgresql
사용 스키마 : sc_appd_srv 
사용 테이블 : tb_legal_zone_info_sig
작성 목적 : tb_legal_zone_info_sig안에 있는 멀티 폴리곤을 활용하여 좌표를 추출하여 mssql의 시도/시군구 테이블에 넣기 위해
*/

-- 시군구코드와 멀티 폴리곤으로 각 시군구의 중심점 잡기
SELECT  
  signgu_code
, concat('point(', 
         CAST(st_x(st_pointonsurface(st_mpolyfromtext(string_agg(st_astext(lc_info), ',' ORDER BY signgu_code), 4326))) AS NUMERIC(13,10)),
         ' ',
         CAST(st_y(st_pointonsurface(st_mpolyfromtext(string_agg(st_astext(lc_info), ',' ORDER BY signgu_code), 4326))) AS NUMERIC(12,10)),
         ')')
  FROM tb_legal_zone_info_sig
 GROUP BY signgu_code;

-- 시도코드와 멀티 폴리곤으로 각 시도의 중심점 잡기
-- 1) st_pointonsurface
SELECT  
  LEFT(signgu_code,2)
, st_collect(st_pointonsurface(st_geomcollfromtext(concat('geometrycollection(', string_agg(st_astext(lc_info), ',' ORDER BY signgu_code), ')'))), 
                               st_geomcollfromtext(concat('geometrycollection(', string_agg(st_astext(lc_info), ',' ORDER BY signgu_code), ')')))
  FROM tb_legal_zone_info_sig tlzis
 GROUP BY LEFT(signgu_code,2);

SELECT  
  LEFT(signgu_code,2),
  concat('point(', 
         CAST(st_x(st_pointonsurface(st_geomcollfromtext(concat('geometrycollection(', string_agg(st_astext(lc_info), ',' ORDER BY signgu_code), ')')))) AS NUMERIC(13,10)),
         ' ',
         CAST(st_y(st_pointonsurface(st_geomcollfromtext(concat('geometrycollection(', string_agg(st_astext(lc_info), ',' ORDER BY signgu_code), ')')))) AS NUMERIC(12,10)),
         ')')
  FROM tb_legal_zone_info_sig tlzis
 GROUP BY LEFT(signgu_code,2);

-- 2) st_centroid
SELECT  
  LEFT(signgu_code,2)
, st_collect(st_centroid(st_geomcollfromtext(concat('geometrycollection(', string_agg(st_astext(lc_info), ',' ORDER BY signgu_code), ')'))),
                         st_geomcollfromtext(concat('geometrycollection(', string_agg(st_astext(lc_info), ',' ORDER BY signgu_code), ')')))
  FROM tb_legal_zone_info_sig tlzis
 GROUP BY LEFT(signgu_code,2);

SELECT  
  LEFT(signgu_code,2),
  concat('point(', 
         CAST(st_x(st_centroid(st_geomcollfromtext(concat('geometrycollection(', string_agg(st_astext(lc_info), ',' ORDER BY signgu_code), ')')))) AS NUMERIC(13,10)),
         ' ',
         CAST(st_y(st_centroid(st_geomcollfromtext(concat('geometrycollection(', string_agg(st_astext(lc_info), ',' ORDER BY signgu_code), ')')))) AS NUMERIC(12,10)),
         ')')
  FROM tb_legal_zone_info_sig tlzis
 GROUP BY LEFT(signgu_code,2);





-- 시도, 시군구 코드에 대한 중심점 좌표 데이터
SELECT
  concat(code, '||', crdnt)
  FROM (
        SELECT  
          signgu_code "code"
        , concat('point(', 
                 CAST(st_x(st_pointonsurface(st_mpolyfromtext(string_agg(st_astext(lc_info), ',' ORDER BY signgu_code), 4326))) AS NUMERIC(13,10)),
                 ' ',
                 CAST(st_y(st_pointonsurface(st_mpolyfromtext(string_agg(st_astext(lc_info), ',' ORDER BY signgu_code), 4326))) AS NUMERIC(12,10)),
                 ')') "crdnt"
          FROM tb_legal_zone_info_sig
         GROUP BY signgu_code
        union
        SELECT  
          LEFT(signgu_code,2) "code",
          concat('point(', 
                 CAST(st_x(st_centroid(st_geomcollfromtext(concat('geometrycollection(', string_agg(st_astext(lc_info), ',' ORDER BY signgu_code), ')')))) AS NUMERIC(13,10)),
                 ' ',
                 CAST(st_y(st_centroid(st_geomcollfromtext(concat('geometrycollection(', string_agg(st_astext(lc_info), ',' ORDER BY signgu_code), ')')))) AS NUMERIC(12,10)),
                 ')') "crdnt"
          FROM tb_legal_zone_info_sig tlzis
         GROUP BY LEFT(signgu_code,2)) a
 ORDER BY 1;
/*
나온 쿼리 결과를 엑셀 파일로 복사
 -> crdnt.txt : 강원도, 군위군 변경 전
 -> crdnt_new.txt : 강원도, 군위군 변경 후
시도/시군구 코드와 좌표를 ||로 구분하고 행 구분은 \n
resultset tetch size를 270이상으로 맞추고 쿼리 실행
*/



















































