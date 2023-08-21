/*
작성일 : 23-08-01
수정일 : 23-08-21
사용 DB : 20번 KLMS
작성자 : 조건영
*/

-- cs 동코드 => app 동코드
SELECT 
  d.dong_no
, d.sido_no
, d.gugun_no
, d.dong
, d.dong_disp
, geometry::STPointFromText('point(' + CAST(lng AS varchar(100)) + ' ' + CAST(lat AS varchar(100)) + ')', 4326)
, d.dong_gbn
, d.jungbu_cd
, CONVERT(varchar(max), CONVERT(VARBINARY(20), d.time_stamp), 1)
  FROM dong_code d
 WHERE d.sido_no = 5;


SELECT lng
  FROM DONG_CODE ;


-- dong좌표로 시도의 폴리곤 및 좌표 찾기
SELECT 
  sido_no
, sido
, geometry::STMPointFromText(
  'multipoint(' +
  stuff((select ' , (' + CAST(d1.lng AS varchar(100)) + ' ' + CAST(d1.lat AS varchar(1000)) + ')'
           from DONG_CODE d1
          WHERE d1.sido_no = d2.sido_no
            AND lng IS NOT NULL
            AND lng != 0
            FOR xml PATH('')) , 1, 2, '') 
  + ')'
  , 4326).STAsText() "mpoint"
, geometry::STMPointFromText(
  'multipoint(' +
  stuff((select ' , (' + CAST(d1.lng AS varchar(100)) + ' ' + CAST(d1.lat AS varchar(1000)) + ')'
           from DONG_CODE d1
          WHERE d1.sido_no = d2.sido_no
            AND lng IS NOT NULL
            AND lng != 0
            FOR xml PATH('')) , 1, 2, '') 
  + ')'
  , 4326).STConvexHull().STAsText() "convexhull"
, geometry::STMPointFromText(
  'multipoint(' +
  stuff((select ' , (' + CAST(d1.lng AS varchar(100)) + ' ' + CAST(d1.lat AS varchar(1000)) + ')'
           from DONG_CODE d1
          WHERE d1.sido_no = d2.sido_no
            AND lng IS NOT NULL
            AND lng != 0
            FOR xml PATH('')) , 1, 2, '') 
  + ')'
  , 4326).STConvexHull().STCentroid().STAsText() "centroid"
, geometry::STMPointFromText(
  'multipoint(' +
  stuff((select ' , (' + CAST(d1.lng AS varchar(100)) + ' ' + CAST(d1.lat AS varchar(1000)) + ')'
           from DONG_CODE d1
          WHERE d1.sido_no = d2.sido_no
            AND lng IS NOT NULL
            AND lng != 0
            FOR xml PATH('')) , 1, 2, '') 
  + ')'
  , 4326).STConvexHull().STPointOnSurface().STAsText() "surface"
  FROM DONG_CODE d2
 WHERE dong_gbn = 'B'
   AND d2.lng != 0
 GROUP BY sido_no, sido
 ORDER BY 1;




-- dong좌표로 시군구의 폴리곤 및 좌표 찾기
SELECT 
  sido_no "시도 pk"
, sido "시도 명"
, gugun_no "구군 pk"
, gugun "구군 명"
, geometry::STGeomCollFromText('GEOMETRYCOLLECTION(' + 
  geometry::STMPointFromText(
  'multipoint(' +
  stuff((select ' , (' + CAST(d1.lng AS varchar(100)) + ' ' + CAST(d1.lat AS varchar(1000)) + ')'
           from DONG_CODE d1
          WHERE d1.sido_no = d2.sido_no
            AND d1.gugun_no = d2.gugun_no
            AND lng IS NOT NULL
            AND lng != 0
            FOR xml PATH('')) , 1, 2, '') 
  + ')'
  , 4326).STConvexHull().STAsText() 
  + ', ' + geometry::STMPointFromText(
  'multipoint(' +
  stuff((select ' , (' + CAST(d1.lng AS varchar(100)) + ' ' + CAST(d1.lat AS varchar(1000)) + ')'
           from DONG_CODE d1
          WHERE d1.sido_no = d2.sido_no
            AND d1.gugun_no = d2.gugun_no
            AND lng IS NOT NULL
            AND lng != 0
            FOR xml PATH('')) , 1, 2, '') 
  + ')'
  , 4326).STConvexHull().STCentroid().STAsText() + ')', 4326).STAsText() "centroid"
, geometry::STGeomCollFromText('GEOMETRYCOLLECTION(' + 
  geometry::STMPointFromText(
  'multipoint(' +
  stuff((select ' , (' + CAST(d1.lng AS varchar(100)) + ' ' + CAST(d1.lat AS varchar(1000)) + ')'
           from DONG_CODE d1
          WHERE d1.sido_no = d2.sido_no
            AND d1.gugun_no = d2.gugun_no
            AND lng IS NOT NULL
            AND lng != 0
            FOR xml PATH('')) , 1, 2, '') 
  + ')'
  , 4326).STConvexHull().STAsText() 
  + ', ' + geometry::STMPointFromText(
  'multipoint(' +
  stuff((select ' , (' + CAST(d1.lng AS varchar(100)) + ' ' + CAST(d1.lat AS varchar(1000)) + ')'
           from DONG_CODE d1
          WHERE d1.sido_no = d2.sido_no
            AND d1.gugun_no = d2.gugun_no
            AND lng IS NOT NULL
            AND lng != 0
            FOR xml PATH('')) , 1, 2, '') 
  + ')'
  , 4326).STConvexHull().STPointOnSurface().STAsText() + ')', 4326).STAsText() "surface"
  FROM DONG_CODE d2
-- WHERE gugun LIKE '%보령%'
 GROUP BY sido_no, sido, gugun_no, gugun
 ORDER BY 1;





-- 위도 경도 평균으로 구한 좌표
SELECT sido_no
     , geometry::STPointFromText('point(' + CAST(sum(lng)/count(lng) AS varchar(500)) + ' ' + CAST(sum(lat)/count(lat) AS varchar(500)) + ')', 4326).STAsText()
  FROM DONG_CODE
 WHERE lat !=0 OR lat IS NOT NULL
 GROUP BY sido_no
UNION
SELECT 
  sido_no
, geometry::STMPointFromText(
  'multipoint(' +
  stuff((select ' , (' + CAST(d1.lng AS varchar(100)) + ' ' + CAST(d1.lat AS varchar(1000)) + ')'
           from DONG_CODE d1
          WHERE d1.sido_no = d2.sido_no
            AND lng IS NOT NULL
            AND lng != 0
            FOR xml PATH('')) , 1, 2, '') 
  + ')'
  , 4326).STConvexHull().STAsText() "convexhull"
  FROM DONG_CODE d2
 WHERE dong_gbn = 'B'
   AND d2.lng != 0
 GROUP BY sido_no
 ORDER BY 1;





-- 위도나 경도의 중앙값을 찾아서 시군구/시도 좌표 찾기
SELECT sido_no
     , sido
     , geometry::STPointFromText('point(' + CAST(sum(lng)/count(lng) AS varchar(500))+ ' ' + CAST(sum(lat)/count(lat) AS varchar(5000)) + ')', 4326).STAsText()
  FROM (
SELECT dong_no
     , dong_gbn
     , jungbu_cd
     , sido_no
     , sido
     , gugun_no
     , gugun
     , dong
     , dong_disp
     , lng
     , lat
     , ROW_NUMBER() OVER (PARTITION BY sido_no ORDER BY lat,lng) "rank" 
  FROM DONG_CODE
 WHERE dong_gbn = 'B'
   AND lng IS NOT NULL
   AND lng != 0) a
 GROUP BY sido_no,sido,rank 
HAVING rank = (max(rank)+1)/2 OR (rank = (max(rank))/2 AND rank = (max(rank))/2 + 1)
 ORDER BY sido_no;





-- KLMS 테이블 정보
SELECT 
  t.TABLE_NAME "테이블명"
, ep.comment
  FROM (
        SELECT 
          object_name(major_id) "table_name"
        , value "comment"
          FROM sys.extended_properties
         WHERE minor_id = 0
       ) ep
       RIGHT JOIN
       information_schema.tables t 
           ON ep.TABLE_name = t.TABLE_NAME
 ORDER BY 1;
/*
 - vw_~~~가 2개씩 확장속겅이 지정 되어 있다.
 - 각 뷰의 확장속성 2개는 모두 MS_Description가 아니다.
*/





-- KLMS 컬럼 정보
SELECT DISTINCT
	  object_name(c.object_id) "테이블명"
	, c.NAME "컬럼명"
	, CASE WHEN type_name(c.system_type_id) = 'numeric'
	            THEN type_name(c.system_type_id) + '(' + CAST(c.PRECISION AS varchar) + ')'
	       WHEN type_name(c.system_type_id) = 'decimal'
	            THEN type_name(c.system_type_id) + '(' + CAST(c.PRECISION AS varchar) + ', ' + CAST(c.SCALE AS varchar) + ')'
	       WHEN type_name(c.system_type_id) IN ('char', 'varchar') 
	            THEN type_name(c.system_type_id) + '(' + CAST(c.MAX_LENGTH AS varchar) + ')'
	       WHEN type_name(c.system_type_id) IN ('nchar', 'nvarchar') 
	            THEN type_name(c.system_type_id) + '(' + 
	                									 CASE WHEN c.MAX_LENGTH = -1 THEN 'max' 
	                                                          ELSE CAST(c.MAX_LENGTH/2 AS varchar)
	                                                     END + 
	                                               ')'
	       ELSE type_name(c.system_type_id)
	  END "시스템 타입"
--	, type_name(c.user_type_id) "사용자 타입"
	, CASE WHEN c.IS_NULLABLE = 0 THEN ' NOT NULL'
	       ELSE ''
	  END "NULL여부"
	, ep.value "컬럼명(한글)"
	, c.column_id
  FROM sys.columns c
       LEFT JOIN
       sys.extended_properties ep
     	      ON object_name(c.object_id) = object_name(ep.major_id) 
     	     AND c.column_id = ep.minor_id
 WHERE object_name(c.object_id) = 'DANJI_CONV_TEST'
 ORDER BY 1, c.column_id;


SELECT * FROM sys.extended_properties WHERE object_name(major_id) = 'danji_detail';


-- 테이블 명 찾기
SELECT TABLE_NAME
  FROM information_schema.tables
 WHERE table_name like '%GUGUN_CODE%'
 ORDER BY TABLE_NAME;





-- 열이름으로 테이블 명 찾기
SELECT
	  table_name
	, COLUMN_NAME
  FROM information_schema.columns
 WHERE COLUMN_NAME like '%drawing%'
 ORDER BY TABLE_NAME;





-- DONG_CODE => tb_com_emd_li_cd
SELECT TABLE_NAME
  FROM information_schema.tables
 WHERE table_name like '%DONG_CODE%'
 ORDER BY TABLE_NAME;
/*DONG_CODE라는 테이블이 여러개 최신 테이블로 사용???*/

SELECT
  dong_no
, sido_no
, gugun_no
, dong
, dong_disp
, 'point(' + CAST(lng AS varchar(500)) + ' ' + CAST(lat AS varchar(500)) + ')'
, dong_gbn
, jungbu_cd
, time_stamp
, CONVERT(int, CONVERT(varbinary,time_stamp,1))
, CONVERT(varchar(max), CONVERT(VARBINARY(20), time_stamp), 1)
  FROM DONG_CODE;



-- GUGUN_CODE => tb_com_emd_li_cd
SELECT TABLE_NAME
  FROM information_schema.tables
 WHERE table_name like '%GUGUN_CODE%'
 ORDER BY TABLE_NAME;
/*GUGUN_CODE라는 테이블이 여러개 최신 테이블로 사용???*/

SELECT
  gugun_no
, sido_no
, gugun
, ''
, disp_gbn
, CONVERT(varchar(max), CONVERT(varbinary(20), time_stamp), 1)
  FROM GUGUN_CODE;



-- SIDO_CODE => tb_com_ctpv_cd
SELECT TABLE_NAME
  FROM information_schema.tables
 WHERE table_name like '%SIDO_CODE%'
 ORDER BY TABLE_NAME;
/*SIDO_CODE라는 테이블이 여러개 최신 테이블로 사용???*/

SELECT
  sido_no
, sido
, sido_s
, ''
, CONVERT(varchar(max), CONVERT(varbinary(20), time_stamp), 1)
  FROM SIDO_CODE;



-- DANJI => tb_hsmp_info
SELECT TABLE_NAME
  FROM information_schema.tables
 WHERE table_name like '%DANJI%'
 ORDER BY TABLE_NAME;
/*SIDO_CODE라는 테이블이 여러개 최신 테이블로 사용???*/


SELECT
	  d.danji_no
	, d.danji_name
	, d.sido_no
	, d.gugun_no
	, d.dong_no
	, d.jibun
	, d.road_addr
	, d.cnt_tot_sede
	, d.cnt_tot_dong
	, d.top_floor
	, d.cnt_tot_park
	, d.cnt_sede_park
	, d.sigongsa
	, d.i_year
	, d.i_month
	, d.c_year
	, d.c_month
	, d.warm_cd
	, d.fuel_cd
	, d.cate_cd
	, d.gwan_telno
	, d.bus
	, d.subway
	, d.school
	, d.sisul
	, 'point(' + CAST(dc.lng AS varchar(500)) + ' ' + CAST(dc.lat AS varchar(500)) + ')'
	, dc.lng
	, dc.lat
	, useYn
	, getdate()
	, edit_date
	, CONVERT(varchar(max), CONVERT(varbinary(20), d.time_stamp), 1)
	, CONVERT(varchar(max), CONVERT(varbinary(20), dc.time_stamp), 1)
  FROM DANJI d
       INNER JOIN
       DANJI_COOR dc
               ON d.danji_no = dc.danji_no;

SELECT * FROM DANJI;

-- DANJI_DETAIL => tb_hsmp_dtl_info
SELECT TABLE_NAME
  FROM information_schema.tables
 WHERE table_name like '%DANJI_DETAIL%'
 ORDER BY TABLE_NAME;
/*DANJI_DETAIL라는 테이블이 여러개 최신 테이블로 사용???*/


SELECT *
  FROM DANJI_DETAIL;



/*DANJI_DETAIL
DANJI_DETAIL_20190522
DANJI_DETAIL_20201125
DANJI_DETAIL_CONV_TEST
DANJI_DETAIL_DLOG
KRI_DANJI_DETAIL_TB
Moon_DANJI_DETAIL
NAVER_DANJI_DETAIL
New_DANJI_DETAIL
New_NAVER_DANJI_DETAIL*/



-- COM_CODE => tb_com_code
SELECT TABLE_NAME
  FROM information_schema.tables
 WHERE table_name like '%app%'
 ORDER BY TABLE_NAME;
/*COM_CODE라는 테이블이 여러개 최신 테이블로 사용???*/

/*대분류*/
SELECT
	  ROW_NUMBER () OVER (ORDER BY grp_cd, item_cd) "code_pk"
	, ROW_NUMBER () OVER (ORDER BY grp_cd, item_cd) "parnts_code_pk"
	, 'H' + item_cd "code"
	, item_nm "code_nm"
	, item_value "sort_ordr"
	, use_yn "use_at"
	, '' "regist_id"
	, '' "regist_dt"
	, '' "updt_id"
	, '' "updt_dt"
	, note "rm_cn"
	, 'H' + item_cd "parnts_code"
	, CONVERT(varchar(max), CONVERT(varbinary(20),time_stamp), 1) "synchrn_pnttm_vl"
  FROM (
       SELECT grp_cd, item_cd, item_nm, item_value, use_yn, note, time_stamp FROM COM_CODE WHERE grp_cd = '000' union
       SELECT '000', '710', '두레_가입_형태', null, 'Y', NULL, null union
       SELECT '000', '720', '두레_게시판_형태', null, 'Y', null, null union
       SELECT '000', '721', '매물_용도', null, 'Y', null, null UNION
       SELECT '000', '813', '부동산전대차', NULL, 'Y', NULL, NULL UNION
       SELECT '000', '820', '건축물_용도', null, 'Y', NULL, null
       ) a;


/*소분류*/
SELECT
      grp_cd
	, ROW_NUMBER () OVER(ORDER BY grp_cd, item_cd) + 68 "code_pk"
	, DENSE_RANK () OVER(ORDER BY grp_cd) "parnts_code_pk"
	, item_cd "code"
	, item_nm "code_nm"
	, item_value "sort_ordr"
	, use_yn "use_at"
	, '' "regist_id"
	, '' "regist_dt"
	, '' "updt_id"
	, '' "updt_dt"
	, note "rm_cn"
	, 'H' + grp_cd "parnts_code"
	, CONVERT(varchar(max), CONVERT(varbinary(20),time_stamp), 1) "synchrn_pnttm_vl"
  FROM COM_CODE
 WHERE grp_cd != '000';



-- BUNYANG_INFO => tb_lttot_info
SELECT TABLE_NAME
  FROM information_schema.tables
 WHERE table_name like '%BUN%'
 ORDER BY TABLE_NAME;
/*BUNYANG라는 테이블이 여러개 최신 테이블로 사용???*/



SELECT 
	  idx
	, bunyang_subject
	, bunyang_content
	, sido
	, Sido_name
	, goo
	, goo_name
	, dong
	, dong_name
	, address_etc
	, Business_size
	, Private_area
	, parcelPrice
	, recruitDate
	, applicationDate
	, prizewinnerDate
	, moveInDate
	, contractDate
	, builder
	, Open_Houses
	, presale_inquiry
	, comforts
	, trafficEnvironment
	, educationEnvironment
	, 'http://www.kren.co.kr/admin/Upload_files/bunyang/' + imgfile
	, input_user
	, regdate
	, CONVERT(varchar(max), CONVERT(varbinary(20),timestamp), 1) "synchrn_pnttm_vl"
  FROM bunyang_info_20190710 -- 1033
 ORDER BY idx;



-- MEMBER => realtor_info
SELECT TABLE_NAME
  FROM information_schema.tables
 WHERE table_name like '%MEMBER%'
 ORDER BY TABLE_NAME;
/*MEMBER라는 테이블이 여러개 최신 테이블로 사용???*/



SELECT count(*)
  FROM member_update_result;

SELECT
  m1.mem_no
, m1.owner_nm
, m1.company
, m2.mem_no
, m2.owner_nm
, m2.company
  FROM MEMBER_20190522 m1
       INNER JOIN
       MEMBER_20230615 m2
           ON m1.mem_no  = m2.mem_no;


FROM MEMBER m1
     INNER JOIN
     MEMBER_20190409 m2
             ON m1.mem_no = m2.mem_no 
     INNER JOIN 
     MEMBER_20190522 m3
             ON m2.mem_no 
     INNER JOIN 
     member_2019지부통합전
             ON 
     MEMBER_20230615
     MEMBER_BLOCK

SELECT *
FROM (SELECT *
  FROM MEMBER
UNION ALL
SELECT * 
  FROM MEMBER_20190409
 WHERE mem_no != ALL(SELECT mem_no FROM member)) a;

SELECT * FROM MEMBER_20190409;
SELECT * FROM MEMBER;

SELECT count(*)
FROM (
SELECT
  mem_no
, jumin_no
, owner_nm
, company
, phone
, CAST(fax AS varchar(20))
, CAST(hp AS varchar(20))
, company_num
, homepage
, wdate
, is_out
, regdate
, dong_no
, old_bon_no
, old_bu_no
, road_no
, new_bon_no
, new_bu_no
, simple_addr
, simple_company
, comp_reg_no
, comp_reg_date
, email
, add_addr
, conversion_memo
, conversion_date
, init_use_yn
, nphone
, nhp
, branch_code
, mem_type_cd
, status_code
, kren_use_grade
, grade_valid_term
, uptea
, upjong
, match_dong_cd
, KRENSTART
, time_stamp
, CAST(UseBarginPass AS varchar(1))
, BarginPass
, bdong_no
, hdong_no
, UseMamulPass
, UseCustomPass
, san_cd
, MyCustomType
, CAST(UseMamulExcelPass AS varchar(1))
, CAST(UseBarginExcelPass AS varchar(1))
, UseCustomExcelPass
  FROM MEMBER_20190522
--UNION ALL 
--SELECT *
--  FROM MEMBER_20230615
UNION ALL 
SELECT *
  FROM MEMBER) a;















