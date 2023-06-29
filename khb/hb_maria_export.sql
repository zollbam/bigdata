/*
마리아db에서 테이블을 txt파일로 만드는 작업파일
204번
작성 일시: 230601
수정 일시: 230629
작 성 자 : 조건영
*/

-- 테이블 열 정보
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, COLUMN_COMMENT
  FROM information_schema.COLUMNS
 WHERE TABLE_SCHEMA='hanbang' AND (DATA_TYPE IN ('VARCHAR','TEXT','varbinary'));

-- 열 값에서 줄바꿈 있는 열 찾기
/*쿼리문은 mssql_tbl엑셀파일의 "줄바꿈 열 찾기"시트에 존재*/
SELECT * FROM hanbang.appmamul_list WHERE has_vr like concat('%',char(13),'%');
SELECT * FROM hanbang.autocomp WHERE GEOCODE like concat('%',char(13),'%');
SELECT * FROM hanbang.danji_info WHERE GEOCODE like concat('%',char(13),'%');
SELECT * FROM hanbang.dong_code WHERE GEOCODE like concat('%',char(13),'%');
SELECT * FROM hanbang.gugun_code WHERE GEOCODE like concat('%',char(13),'%');
SELECT * FROM hanbang.map_bjd_polygon WHERE POLYGON_JSON like concat('%',char(13),'%');
SELECT * FROM hanbang.map_cluster WHERE COUNT_INFO like concat('%',char(13),'%');
SELECT * FROM hanbang.map_cluster_info WHERE COUNT_INFO like concat('%',char(13),'%');
SELECT * FROM hanbang.product_info WHERE PRODUCT_GEOCODE like concat('%',char(13),'%');
SELECT * FROM hanbang.realtor_info WHERE COMPANY_GEOCODE like concat('%',char(13),'%');
SELECT * FROM hanbang.sido_code WHERE GEOCODE like concat('%',char(13),'%');
SELECT * FROM hanbang.subway_code WHERE SUBWAY_GEOCODE like concat('%',char(13),'%');
SELECT * FROM hanbang.user_info WHERE user_hp like concat('%',char(13),'%');

-- SELECT ~ into outfile 문을 사용한 쿼리문(case when)
SET @db_name = 'hanbang';
-- SET @tbl_name = 'article_type_ab_info';
SELECT imq.table_name, concat('select ', char(13), '  ', 
--                               group_concat(imq.re SEPARATOR ', '), 
                              group_concat(imq.re ORDER BY imq.ORDINAL_POSITION SEPARATOR ', '), 
                              'into outfile ''/var/lib/mysql/backup/', imq.table_name, '.txt''', char(13), 
                              '        FIELDS TERMINATED BY ''|''', char(13), 
                              '        LINES TERMINATED BY ''\\n''', char(13), 'FROM ', @db_name, '.',imq.table_name, ' LIMIT 1000000;') ex_query
  FROM (SELECT TABLE_NAME, COLUMN_NAME,
               concat(CASE WHEN DATA_TYPE IN ('char','varchar','nchar','nvarchar','text','longtext','varbinary','enum') 
                                          THEN concat('CASE WHEN ', COLUMN_NAME, ' IS NULL THEN '''' WHEN ', COLUMN_NAME, ' = '''' THEN '' '' ELSE ', COLUMN_NAME, ' END')
                           WHEN DATA_TYPE IN ('int','double','float','bigint','datetime') 
                                          THEN concat('CASE WHEN ', COLUMN_NAME, ' IS NULL THEN '''' ELSE ', COLUMN_NAME, ' END')
               END, char(13)) "re", ORDINAL_POSITION
          FROM information_schema.COLUMNS
         WHERE TABLE_SCHEMA=@db_name 
--               AND table_name = @tbl_name
--          ORDER BY ORDINAL_POSITION
         ) imq
 GROUP BY imq.table_name;

-- SELECT ~ into outfile 문을 사용한 쿼리문(ifnull + replace)
SET @db_name = 'hanbang';
SELECT imq.table_name, concat('select ', char(13), '  ', 
--                               group_concat(imq.re SEPARATOR ', '), 
                              group_concat(imq.re ORDER BY imq.ORDINAL_POSITION SEPARATOR ', '), 
                              'into outfile ''/var/lib/mysql/backup/', imq.table_name, '.txt''', char(13), 
                              '        FIELDS TERMINATED BY ''||''', char(13), 
                              '        LINES TERMINATED BY ''\\n''', char(13), 'FROM ', @db_name, '.',imq.table_name, ' LIMIT 10000000;') ex_query
  FROM (SELECT TABLE_NAME, COLUMN_NAME,
               concat('IFNULL(REPLACE(', COLUMN_NAME, ',CONCAT(CHAR(10)), ''''), '''')', char(13)) "re", ORDINAL_POSITION
          FROM information_schema.COLUMNS
         WHERE TABLE_SCHEMA=@db_name 
--               AND table_name = @tbl_name
--          ORDER BY ORDINAL_POSITION
         ) imq
 GROUP BY imq.table_name;

-- 원하는 테이블명(TABLE_NAME)에서 쿼리문(query) 복사 붙여넣기
select 
  IFNULL(REPLACE(BANNER_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(BAN_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(BAN_URL_ADDRESS,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(IMG_URL_BAN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CRE_USER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CRE_DATETIME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(UPD_USER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(UPD_DATETIME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(IMG_ORDER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(BANNER_USE_YN,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/banner_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
FROM hanbang.banner_info LIMIT 1000000;

select 
  CASE WHEN PRODUCT_NO IS NULL THEN '' ELSE PRODUCT_NO END
, CASE WHEN KAR_MM_NO IS NULL THEN '' ELSE KAR_MM_NO END
, CASE WHEN KAR_CONTENT_NO IS NULL THEN '' ELSE KAR_CONTENT_NO END
, CASE WHEN REALTOR_NO IS NULL THEN '' ELSE REALTOR_NO END
, CASE WHEN PRODUCT_GEOCODE IS NULL THEN '' WHEN PRODUCT_GEOCODE = '' THEN ' ' ELSE PRODUCT_GEOCODE END
, CASE WHEN PRODUCT_CATE_CD IS NULL THEN '' WHEN PRODUCT_CATE_CD = '' THEN ' ' ELSE PRODUCT_CATE_CD END
, CASE WHEN ARTICLE_INFO_TYPE IS NULL THEN '' WHEN ARTICLE_INFO_TYPE = '' THEN ' ' ELSE ARTICLE_INFO_TYPE END
, CASE WHEN ADDR_CODE IS NULL THEN '' WHEN ADDR_CODE = '' THEN ' ' ELSE ADDR_CODE END
, CASE WHEN SIDO_NO IS NULL THEN '' ELSE SIDO_NO END
, CASE WHEN GUGUN_NO IS NULL THEN '' ELSE GUGUN_NO END
, CASE WHEN DONG_NO IS NULL THEN '' ELSE DONG_NO END
, CASE WHEN HDONG_NO IS NULL THEN '' ELSE HDONG_NO END
, CASE WHEN BDONG_NO IS NULL THEN '' ELSE BDONG_NO END
, CASE WHEN BON_NO IS NULL THEN '' ELSE BON_NO END
, CASE WHEN BU_NO IS NULL THEN '' ELSE BU_NO END
, CASE WHEN STAT IS NULL THEN '' WHEN STAT = '' THEN ' ' ELSE STAT END
, CASE WHEN DANJI_NO IS NULL THEN '' ELSE DANJI_NO END
, CASE WHEN DANJI_DETAIL_NO IS NULL THEN '' ELSE DANJI_DETAIL_NO END
, CASE WHEN THEME_CDS IS NULL THEN '' WHEN THEME_CDS = '' THEN ' ' ELSE THEME_CDS END
, CASE WHEN PRODUCT_LNG IS NULL THEN '' ELSE PRODUCT_LNG END
, CASE WHEN PRODUCT_LAT IS NULL THEN '' ELSE PRODUCT_LAT END
, CASE WHEN MM_DONG_NM IS NULL THEN '' WHEN MM_DONG_NM = '' THEN ' ' ELSE MM_DONG_NM END
, CASE WHEN HO_NM IS NULL THEN '' WHEN HO_NM = '' THEN ' ' ELSE HO_NM END
, CASE WHEN MM_TRANS_DATE IS NULL THEN '' ELSE MM_TRANS_DATE END
, CASE WHEN CLICK_CNT IS NULL THEN '' ELSE CLICK_CNT END
, CASE WHEN USER_NO IS NULL THEN '' ELSE USER_NO END
, CASE WHEN USER_NM IS NULL THEN '' WHEN USER_NM = '' THEN ' ' ELSE USER_NM END
, CASE WHEN USER_TEL_NO IS NULL THEN '' WHEN USER_TEL_NO = '' THEN ' ' ELSE USER_TEL_NO END
, CASE WHEN EXCLS_SPC IS NULL THEN '' ELSE EXCLS_SPC END
, CASE WHEN ROOM IS NULL THEN '' ELSE ROOM END
, CASE WHEN OPEN_APT_DONG_YN IS NULL THEN '' WHEN OPEN_APT_DONG_YN = '' THEN ' ' ELSE OPEN_APT_DONG_YN END
, CASE WHEN OPEN_APT_TYPE_YN IS NULL THEN '' WHEN OPEN_APT_TYPE_YN = '' THEN ' ' ELSE OPEN_APT_TYPE_YN END
, CASE WHEN VR_YN IS NULL THEN '' WHEN VR_YN = '' THEN ' ' ELSE VR_YN END
, CASE WHEN IMG_YN IS NULL THEN '' WHEN IMG_YN = '' THEN ' ' ELSE IMG_YN END
, CASE WHEN REG_DT IS NULL THEN '' ELSE REG_DT END
, CASE WHEN UPDT_DT IS NULL THEN '' ELSE UPDT_DT END
, CASE WHEN VIEW_CNT IS NULL THEN '' ELSE VIEW_CNT END
, CASE WHEN CLUSTER_STATE IS NULL THEN '' WHEN CLUSTER_STATE = '' THEN ' ' ELSE CLUSTER_STATE END
, CASE WHEN PUSH_STATE IS NULL THEN '' WHEN PUSH_STATE = '' THEN ' ' ELSE PUSH_STATE END
into outfile '/var/lib/mysql/backup/product_info_1.txt'
        FIELDS TERMINATED BY '^'
        LINES TERMINATED BY '\n'
FROM hanbang.product_info;



SELECT @@profiling;
SET profiling = 1;
SET @@profiling_history_size=100;
SHOW profiles;

SELECT * FROM product_info;


-- product_batch_history


-- product_info
select 
  IFNULL(REPLACE(PRODUCT_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(KAR_MM_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(KAR_CONTENT_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REALTOR_NO,CONCAT(CHAR(10)), ''), '')
, CASE WHEN PRODUCT_LNG < 100 THEN IFNULL(REPLACE(concat('{"lng":',json_extract(PRODUCT_GEOCODE,'$.lat'), ',"lat:":', json_extract(PRODUCT_GEOCODE,'$.lng'),'}'),CONCAT(CHAR(10)), ''), '')
       ELSE IFNULL(REPLACE(PRODUCT_GEOCODE,CONCAT(CHAR(10)), ''), '') END
, IFNULL(REPLACE(PRODUCT_CATE_CD,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ARTICLE_INFO_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ADDR_CODE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(GUGUN_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DONG_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(HDONG_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(BDONG_NO,CONCAT(CHAR(10)), ''), '')
, CASE WHEN LENGTH(BON_NO)<=4 THEN IFNULL(REPLACE(BON_NO,CONCAT(CHAR(10)), ''), '') ELSE '' END
, CASE WHEN LENGTH(BU_NO)<=4 THEN IFNULL(REPLACE(BU_NO,CONCAT(CHAR(10)), ''), '') ELSE '' END
, IFNULL(REPLACE(STAT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DANJI_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DANJI_DETAIL_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(THEME_CDS,CONCAT(CHAR(10)), ''), '')
, CASE WHEN PRODUCT_LNG > 100 THEN IFNULL(REPLACE(PRODUCT_LNG,CONCAT(CHAR(10)), ''), '') ELSE IFNULL(REPLACE(PRODUCT_LAT,CONCAT(CHAR(10)), ''), '') END
, CASE WHEN PRODUCT_LAT < 100 THEN IFNULL(REPLACE(PRODUCT_LAT,CONCAT(CHAR(10)), ''), '') ELSE IFNULL(REPLACE(PRODUCT_LNG,CONCAT(CHAR(10)), ''), '') END
, IFNULL(REPLACE(MM_DONG_NM,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(HO_NM,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(MM_TRANS_DATE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CLICK_CNT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(USER_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(USER_NM,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(USER_TEL_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(EXCLS_SPC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ROOM,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(OPEN_APT_DONG_YN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(OPEN_APT_TYPE_YN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(VR_YN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(IMG_YN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REG_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(UPDT_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(VIEW_CNT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CLUSTER_STATE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(PUSH_STATE,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/product_info_en.txt'
        CHARACTER SET utf8
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.product_info
 WHERE REALTOR_NO != 0
 LIMIT 10000000;

SELECT count(*)
  FROM product_info
 WHERE json_extract(PRODUCT_GEOCODE, '$.lat')>100;

SELECT count(*)
  FROM product_info
 WHERE LENGTH(BON_NO)>5;

SELECT count(*)
  FROM product_info
 WHERE LENGTH(BU_NO)>5;

SELECT count(*)
  FROM product_info
 WHERE PRODUCT_LAT > 100;

SELECT count(*)
  FROM product_info
 WHERE PRODUCT_LNG < 40 AND PRODUCT_LNG !=0;

-- facilities_info
SELECT
  IFNULL(REPLACE(fi.FACILITES_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(fi.PRODUCT_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(fi.HEAT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(fi.FUEL,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(fi.AIRCON,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(fi.LIFE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(fi.SECURITY,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(fi.ETC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(fi.COLD_CD,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(fi.REG_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(fi.UPDT_DT,CONCAT(CHAR(10)), ''), '')
  INTO OUTFILE '/var/lib/mysql/backup/facilities_info.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.facilities_info fi
       INNER JOIN
       hanbang.product_info pi2 
     	  ON pi2.PRODUCT_NO = fi.PRODUCT_NO
 WHERE fi.PRODUCT_NO NOT IN (SELECT product_no FROM product_info WHERE realtor_no=0)
 LIMIT 10000000;

SELECT count(*)
  FROM facilities_info
 WHERE PRODUCT_NO IN (SELECT PRODUCT_NO
                        FROM facilities_info
                      EXCEPT 
                      SELECT PRODUCT_NO
                        FROM product_info);

-- article_type_d_info
select 
  IFNULL(REPLACE(d.ARTICLE_D_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.PRODUCT_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.ARTICLE_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.CORTAR_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.EXCLS_SPC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.FLOOR,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.TOTAL_FLOOR,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.ROOM,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.RESTROOM,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.C_DATE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.DIRECTION,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.LOCAL_NDC_YN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.SPLY_SPC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.PARKING_PSBL,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.BUILD_SPC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.GRND_SPC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.DNFLR_CNT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.UPFLR_CNT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.REG_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.UPDT_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(d.STAT,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/article_type_d_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.article_type_d_info d
       INNER JOIN
       hanbang.product_info pi2 
           ON d.PRODUCT_NO = pi2.PRODUCT_NO
 WHERE d.ARTICLE_D_NO != 3043522
     LIMIT 10000000;

SELECT count(*)
  FROM article_type_d_info
 WHERE PRODUCT_NO IN (SELECT PRODUCT_NO
                        FROM article_type_d_info
                      EXCEPT 
                      SELECT PRODUCT_NO
                        FROM product_info);

SELECT *
  FROM article_type_d_info  
 WHERE ARTICLE_D_NO = 3043522;

-- trade_info
select 
  IFNULL(REPLACE(ti.TRADE_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ti.PRODUCT_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ti.TRADE_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ti.DEAL_PRICE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ti.DEPOSIT_PRICE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ti.RENTAL_PRICE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ti.LOAN_PRICE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ti.AL_DEPOSIT_PRICE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ti.AL_RENTAL_PRICE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ti.PREM_PRICE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ti.REG_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ti.UPDT_DT,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/trade_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.trade_info ti
       INNER JOIN
       hanbang.product_info pi2 
           ON ti.PRODUCT_NO = pi2.PRODUCT_NO
 WHERE ti.PRODUCT_NO NOT IN (SELECT product_no FROM product_info WHERE realtor_no=0)
 LIMIT 10000000;

SELECT count(*)
  FROM trade_info
 WHERE PRODUCT_NO IN (SELECT PRODUCT_NO
                        FROM trade_info
                      EXCEPT 
                      SELECT PRODUCT_NO
                        FROM product_info);

-- article_type_ef_info
select 
  IFNULL(REPLACE(ef.ARTICLE_EF_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.PRODUCT_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.ARTICLE_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.CORTAR_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.EXCLS_SPC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.FLOOR,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.TOTAL_FLOOR,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.ROOM,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.C_DATE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.DIRECTION,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(OPTION_INFO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(DTL_ADDR,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.LOCAL_NDC_YN,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(BLD_TYPE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(PLACE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.SPLY_SPC,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(HOUSE_HOLD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(PARKING,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.PARKING_PSBL,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.BUILD_SPC,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(TOTAL_SPC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.GRND_SPC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.DNFLR_CNT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.UPFLR_CNT,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(ELEVATOR,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(GUNRAK_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(BUILD_NAME,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(CUR_USG,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(RCMD_USG,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(SELL_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(BLDG_ARCH_TYPE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(USE_EPWR_TP_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(USG_AREA,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(AREA_NO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(BIZ_STEP_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(CONST_COMPANY,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(EXPECT_SPC,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(ZONE_METER,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(ESTIMATE_CNT,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(YONGJUK_RATE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(GUNPE_RATE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(POWER,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(JIMOK_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(JIMOK_GUSUNG,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(YONG_JIYUK1_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(YONG_JIYUK2_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(ROAD_METER,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(AMT_REAL_INVEST,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(AMT_MOVE_FREE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(SUKBAK_IPJI_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(FACTORY_TYPE_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(FACTORY_CATE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(BUILDING_TYPE_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(WAREHOUSE_TYPE_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(AMT_MOVE_NOFREE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(SUKBAK_CATE_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(FACTORY_IPJI_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(FLOOR_HIGH,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(JIBUN_METER,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(RECOM_USE2,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(GRND_SHR_SPC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.REG_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.UPDT_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ef.STAT,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/article_type_ef_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.article_type_ef_info ef
       INNER JOIN
       hanbang.product_info pi2 
           ON ef.PRODUCT_NO = pi2.PRODUCT_NO
 LIMIT 10000000;

SELECT count(*)
  FROM article_type_ef_info
 WHERE PRODUCT_NO IN (SELECT PRODUCT_NO
                        FROM article_type_ef_info
                      EXCEPT 
                      SELECT PRODUCT_NO
                        FROM product_info);

-- etc_info
select
  IFNULL(REPLACE(ei.ETC_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ei.PRODUCT_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ei.MVI_TYPE_CD,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ei.MVI_MONTH_CNT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ei.MVI_AFTER_YM,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ei.MVI_DSC_PSBL_YN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ei.FEATURE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ei.FROAD_YN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ei.ATCL_DESC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ei.REG_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ei.UPDT_DT,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/etc_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.etc_info ei
       INNER JOIN
       hanbang.product_info pi2 
           ON ei.PRODUCT_NO = pi2.PRODUCT_NO
 WHERE ei.PRODUCT_NO NOT IN (SELECT product_no FROM product_info WHERE realtor_no=0)
 LIMIT 10000000;

SELECT count(*)
  FROM etc_info
 WHERE PRODUCT_NO IN (SELECT PRODUCT_NO
                        FROM etc_info
                      EXCEPT 
                      SELECT PRODUCT_NO
                        FROM product_info);

-- product_img_info
SELECT
  ROW_NUMBER () OVER (ORDER BY pii.PRODUCT_NO, pii.IMG_SEQ, pii.IMG_TYPE)
, IFNULL(REPLACE(pii.PRODUCT_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(pii.IMG_SEQ,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(pii.IMG_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(pii.IMG_FILE_NAME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(pii.IMG_DESC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(pii.IMG_URL_TH,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(pii.IMG_URL_MTH,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(pii.IMG_URL_ORG,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(pii.ORDER_STR,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/product_img_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.product_img_info pii
       INNER JOIN
       product_info pi2
           ON pii.PRODUCT_NO = pi2.PRODUCT_NO
 LIMIT 10000000;

SELECT count(*)
  FROM product_img_info
 WHERE PRODUCT_NO IN (SELECT PRODUCT_NO
                        FROM product_img_info
                      EXCEPT 
                      SELECT PRODUCT_NO
                        FROM product_info);

-- product_statistics


-- grnd_info
select 
  IFNULL(REPLACE(gi.GRND_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(gi.PRODUCT_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(gi.USG_AREA_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(gi.CNTRY_USE_YN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(gi.CITY_PLAN_YN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(gi.BLDG_ALW_YN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(gi.GRND_TRAD_ALW_YN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(gi.REG_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(gi.UPDT_DT,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/grnd_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.grnd_info gi
       INNER JOIN
       product_info pi2
           ON gi.PRODUCT_NO = pi2.PRODUCT_NO
 WHERE gi.PRODUCT_NO NOT IN (SELECT product_no FROM product_info WHERE realtor_no=0)
 LIMIT 10000000;

SELECT count(*)
  FROM grnd_info
 WHERE PRODUCT_NO IN (SELECT PRODUCT_NO
                        FROM grnd_info
                      EXCEPT 
                      SELECT PRODUCT_NO
                        FROM product_info);

-- article_type_c_info
select 
  IFNULL(REPLACE(c.ARTICLE_C_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.PRODUCT_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.ARTICLE_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.CORTAR_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.EXCLS_SPC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.FLOOR,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.TOTAL_FLOOR,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.ROOM,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.RESTROOM,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.C_DATE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.DIRECTION,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(DOOR_TYPE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(DUPLEX_YN,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(OPTION_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(MNEX,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(OPTION_INFO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(DTL_ADDR,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.LOCAL_NDC_YN,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(BLD_TYPE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(PLACE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.SPLY_SPC,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(GRND_SHR_SPC,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(HOUSE_HOLD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(PARKING,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.PARKING_PSBL,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.BUILD_SPC,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(TOTAL_SPC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.GRND_SPC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.DNFLR_CNT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.UPFLR_CNT,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(RDVLP_AREA,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(ELEVATOR,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(GUNRAK_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(SHAPE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(BLD_DONG,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(ROOM1_CNT,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(ROOM2_CNT,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(ROOM3_CNT,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(ROOM4_CNT,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(ROOM_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(YOKSIL_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(SETAK_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(JUBANG_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(JIBUN_METER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.FLR_EXPS_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.FCOR_FLR_EXPS_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.STAIR_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(PARK_CNT,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(CONST_USE_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(BALCONY_CD,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.REG_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.UPDT_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(c.STAT,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/article_type_c_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.article_type_c_info c
       INNER JOIN
       hanbang.product_info pi2
           ON c.PRODUCT_NO = pi2.PRODUCT_NO
 LIMIT 10000000;

SELECT count(*)
  FROM article_type_c_info
 WHERE PRODUCT_NO IN (SELECT PRODUCT_NO
                        FROM article_type_c_info
                      EXCEPT 
                      SELECT PRODUCT_NO
                        FROM product_info);

-- article_type_ab_info
select 
  IFNULL(REPLACE(ab.ARTICLE_AB_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.PRODUCT_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.ARTICLE_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.CORTAR_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.APT_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.EXCLS_SPC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.FLOOR,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.TOTAL_FLOOR,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.ROOM,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.RESTROOM,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.STAIR_CD,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.C_DATE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.DIRECTION,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(I_SALE_PRICE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(PREMIUM,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.LOAN_PRICE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(PTP_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.APT_DONG,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.HO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(DOOR_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.FLR_EXPS_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.FCOR_FLR_EXPS_TYPE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(USAGE_TEXT,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(DUPLEX_YN,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(OPTION_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(MNEX,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(OPTION_INFO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(OFFICETEL_USE_CD,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.BALCONY_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(BALCONY_EXT_YN,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(ROOM_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(SALE_TYPE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(AMT_REAL_INVEST,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(AMT_PAY,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(MID_GBN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.REG_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.UPDT_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ab.STAT,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/article_type_ab_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.article_type_ab_info ab
       INNER JOIN
       product_info pi2
           ON ab.PRODUCT_NO = pi2.PRODUCT_NO
 WHERE ab.PRODUCT_NO NOT IN (SELECT product_no FROM product_info WHERE realtor_no=0)
 LIMIT 10000000;

SELECT count(*)
  FROM article_type_ab_info
 WHERE PRODUCT_NO IN (SELECT PRODUCT_NO
                        FROM article_type_ab_info
                      EXCEPT 
                      SELECT PRODUCT_NO
                        FROM product_info);

-- banner_info
select 
  IFNULL(REPLACE(BANNER_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(BAN_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(BAN_URL_ADDRESS,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(IMG_URL_BAN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(IMG_ORDER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(BANNER_USE_YN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CRE_USER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CRE_DATETIME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(UPD_USER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(UPD_DATETIME,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/banner_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.banner_info 
 LIMIT 10000000;

-- board_comment
select 
  IFNULL(REPLACE(COMMENT_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(BOARD_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CONTENTS,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DEL_YN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REG_USER_NM,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REG_USER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REG_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(UPDT_DT,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/board_comment.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.board_comment 
 LIMIT 10000000;

-- board_info
select 
  IFNULL(REPLACE(BOARD_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(BOARD_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(TITLE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CONTENTS,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DEL_YN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REG_USER_NM,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REG_USER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REG_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(UPDT_USER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(UPDT_DT,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/board_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.board_info 
 LIMIT 10000000;

-- com_code
/*대분류*/
select 
  ROW_NUMBER () OVER(ORDER BY GUBUN, grd_cd, code) code_pk
, ROW_NUMBER () OVER(ORDER BY GUBUN, grd_cd) parnts_code_pk
, IFNULL(REPLACE(concat(GUBUN,code),CONCAT(CHAR(10)), ''), '') code
, IFNULL(REPLACE(CODE_NM,CONCAT(CHAR(10)), ''), '') code_nm
, IFNULL(REPLACE(CODE_VAL,CONCAT(CHAR(10)), ''), '') sort_ordr
, IFNULL(REPLACE(STAT,CONCAT(CHAR(10)), ''), '') use_at
, '' regist_id
, '' regist_dt
, '' updt_id
, '' updt_dt
, IFNULL(REPLACE(CODE_DESC,CONCAT(CHAR(10)), ''), '') rm_cn
, IFNULL(REPLACE(concat(GUBUN,grd_cd),CONCAT(CHAR(10)), ''), '') parent_code
, IFNULL(REPLACE(SYS_TIMESTAMP,CONCAT(CHAR(10)), ''), '') synchrn_pnttm_vl
  into outfile '/var/lib/mysql/backup/com_code_dea.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM (SELECT * FROM hanbang.com_code union
        SELECT 'H', '000', '710', '두레_가입_형태', null, null, 'Y', null union
        SELECT 'H', '000', '720', '두레_게시판_형태', null, null, 'Y', null union
        SELECT 'H', '000', '721', '매물_용도', null, null, 'Y', null union
        SELECT 'H', '000', '820', '건축물_용도', null, null, 'Y', NULL) a
 WHERE grd_cd = '000'
 ORDER BY 1, 2
 LIMIT 10000000;

/*소분류*/
select 
  ROW_NUMBER () OVER(ORDER BY GUBUN, grd_cd) + 71 code_pk
, DENSE_RANK () OVER(ORDER BY GUBUN, grd_cd) parnts_code_pk
, IFNULL(REPLACE(CODE,CONCAT(CHAR(10)), ''), '') code
, IFNULL(REPLACE(CODE_NM,CONCAT(CHAR(10)), ''), '') code_nm
, IFNULL(REPLACE(CODE_VAL,CONCAT(CHAR(10)), ''), '') sort_ordr
, IFNULL(REPLACE(STAT,CONCAT(CHAR(10)), ''), '') use_at
, '' regist_id
, '' regist_dt
, '' updt_id
, '' updt_dt
, IFNULL(REPLACE(CODE_DESC,CONCAT(CHAR(10)), ''), '') rm_cn
, IFNULL(REPLACE(concat(GUBUN, grd_cd),CONCAT(CHAR(10)), ''), '') parent_code
, IFNULL(REPLACE(SYS_TIMESTAMP,CONCAT(CHAR(10)), ''), '') synchrn_pnttm_vl
  into outfile '/var/lib/mysql/backup/com_code_so.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM (SELECT * FROM hanbang.com_code union
        SELECT 'H', '000', '710', '두레_가입_형태', null, null, 'Y', null union
        SELECT 'H', '000', '720', '두레_게시판_형태', null, null, 'Y', null union
        SELECT 'H', '000', '721', '매물_용도', null, null, 'Y', null union
        SELECT 'H', '000', '820', '건축물_용도', null, null, 'Y', NULL) a
 WHERE grd_cd != '000'
 ORDER BY 1, 2
 LIMIT 10000000;

-- sido_code
select 
  IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SIDO_NAME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SIDO_NAME_ALIAS,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(GEOCODE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SYS_TIMESTAMP,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/sido_code.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.sido_code 
 LIMIT 10000000;

-- dong_code
select 
  IFNULL(REPLACE(DONG_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(GUGUN_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DONG_NAME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DONG_NAME_DISP,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(GEOCODE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DONG_GBN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(JUNGBU_CODE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SYS_TIMESTAMP,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/dong_code.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.dong_code 
 LIMIT 10000000;

-- cron_info
select 
  IFNULL(REPLACE(CRON_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CRON_CATE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CRON_NAME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CRON_EXP,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CRON_EC_TIME,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/cron_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.cron_info
 WHERE CRON_EC_TIME IS NOT NULL 
 LIMIT 10000000;

-- gugun_code
select 
  IFNULL(REPLACE(GUGUN_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(GUGUN_NAME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(GEOCODE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DISP_GBN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SYS_TIMESTAMP,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/gugun_code.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.gugun_code 
 LIMIT 10000000;

-- thema_info
select 
  IFNULL(REPLACE(THEME_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(THEME_CDS,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(THEME_NAME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(THEME_SUBNAME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(THEME_URL_ADDRESS,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(THEME_DESCRIBE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(IMG_DESC,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(THEME_USE_YN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CRE_USER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CRE_DATETIME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(UPD_USER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(UPD_DATETIME,CONCAT(CHAR(10)), ''), '')
  into outfile '/var/lib/mysql/backup/theme_info.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.theme_info 
 LIMIT 10000000;

-- user_info
/*tb_com_user*/
select 
  IFNULL(REPLACE(mem_no,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(mem_no,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(social_key,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(user_nm,CONCAT(CHAR(10)), ''), '')
, ''
-- , IFNULL(REPLACE(user_passwd,CONCAT(CHAR(10)), ''), '')
, ''
-- , IFNULL(REPLACE(user_hp,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(CAST(DES_DECRYPT(USER_HP, 'kar170919') AS CHAR(10000) CHARACTER SET utf8),CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(user_email,CONCAT(CHAR(10)), ''), '')
, '03'
, ''
, ''
, ''
, ''
, ''
, ''
, IFNULL(REPLACE(use_yn,CONCAT(CHAR(10)), ''), '')
, ''
, IFNULL(REPLACE(reg_date,CONCAT(CHAR(10)), ''), '')
, ''
, IFNULL(REPLACE(mod_date,CONCAT(CHAR(10)), ''), '')
, ''
, ''
, IFNULL(REPLACE(social_type,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(mem_img,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(platform,CONCAT(CHAR(10)), ''), '')
, ''
, ''
-- , IFNULL(REPLACE(user_passwd_tmp,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(user_token,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(device_id,CONCAT(CHAR(10)), ''), '')
  into outfile '/var/lib/mysql/backup/user_info.txt'
	   CHARACTER SET utf8
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.user_info 
 LIMIT 10000000;

/*tb_com_user_group*/
SELECT
  ROW_NUMBER() OVER (ORDER BY mem_no)
, 4
, IFNULL(REPLACE(mem_no,CONCAT(CHAR(10)), ''), '')
, ''
, IFNULL(REPLACE(reg_date,CONCAT(CHAR(10)), ''), '')
, ''
, IFNULL(REPLACE(mod_date,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(social_key,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(user_nm,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(user_passwd,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(user_hp,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(CAST(DES_DECRYPT(USER_HP, 'kar170919') AS CHAR(10000) CHARACTER SET utf8),CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(user_email,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(use_yn,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(social_type,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(mem_img,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(platform,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(user_passwd_tmp,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(user_token,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(device_id,CONCAT(CHAR(10)), ''), '')
  into outfile '/var/lib/mysql/backup/user_info_user_group.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.user_info 
 LIMIT 10000000;

-- danji_detail_info
select
  IFNULL(REPLACE(ddi.DANJI_DETAIL_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.DANJI_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.GONG_METER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.GONG_PYUNG,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.PYUNG_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.JUN_METER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.JUN_PYUNG,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.CONT_METER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.CONT_PYUNG,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.DEJI_JIBUN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.ROOM_CNT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.BATH_CNT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.PYUNG_SEDE_CNT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.DIRECTION_CD,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.BAY_CD,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.STAIR_CD,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.URL_DRAWING,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.E_URL_DRAWING,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.STAT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.REG_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.UPT_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ddi.SYS_TIMESTAMP,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/danji_detail_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.danji_detail_info ddi
       INNER JOIN
       hanbang.danji_info di
           ON ddi.DANJI_NO = di.DANJI_NO
 LIMIT 10000000;

SELECT count(*)
  FROM danji_detail_info
 WHERE DANJI_NO IN (SELECT DANJI_NO
                        FROM danji_detail_info
                      EXCEPT 
                      SELECT DANJI_NO
                        FROM danji_info);

-- tb_hsmp_info
select 
  IFNULL(REPLACE(DANJI_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DANJI_NAME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(GUGUN_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DONG_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(JIBUN,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ROAD_ADDR,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CNT_TOT_SEDE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CNT_TOT_DONG,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(TOP_FLOOR,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CNT_TOT_PARK,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CNT_SEDE_PARK,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SIGONGSA,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(I_YEAR,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(I_MONTH,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(C_YEAR,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(C_MONTH,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(WARM_CD,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(FUEL_CD,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CATE_CD,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(GWAN_TELNO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(BUS,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SUBWAY,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SCHOOL,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SISUL,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(GEOCODE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DANJI_LNG,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DANJI_LAT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(STAT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REG_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(UPT_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SYS_TIMESTAMP,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/danji_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.danji_info 
 LIMIT 10000000;

-- fav_info
select 
  ROW_NUMBER () OVER (ORDER BY REG_DT)
, CASE WHEN USER_TYPE = 'U' THEN IFNULL(REPLACE(MEM_NO,CONCAT(CHAR(10)), ''), '')
       ELSE ''
  END
, CASE WHEN USER_TYPE = 'R' THEN IFNULL(REPLACE(MEM_NO,CONCAT(CHAR(10)), ''), '')
       ELSE ''
  END
, CASE WHEN FAV_CATE_CD = 'P' THEN IFNULL(REPLACE(FAV_SEQ_NO,CONCAT(CHAR(10)), ''), '')
       ELSE ''
  END
, CASE WHEN FAV_CATE_CD = 'D' THEN IFNULL(REPLACE(FAV_SEQ_NO,CONCAT(CHAR(10)), ''), '')
       ELSE ''
  END
, CASE WHEN FAV_CATE_CD = 'R' THEN IFNULL(REPLACE(FAV_SEQ_NO,CONCAT(CHAR(10)), ''), '')
       ELSE ''
  END
, IFNULL(REPLACE(STAT,CONCAT(CHAR(10)), ''), '')
, ''
, IFNULL(REPLACE(REG_DT,CONCAT(CHAR(10)), ''), '')
, ''
, IFNULL(REPLACE(UPDT_DT,CONCAT(CHAR(10)), ''), '')
  into outfile '/var/lib/mysql/backup/fav_info.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.fav_info 
 WHERE ((USER_TYPE = 'U' AND MEM_NO IN (SELECT mem_no FROM user_info))
       OR 
       (USER_TYPE = 'R' AND MEM_NO IN (SELECT REALTOR_NO FROM realtor_info)))
       AND 
       ((FAV_CATE_CD = 'D' AND FAV_SEQ_NO IN (SELECT danji_no FROM danji_info di))
       OR 
       (FAV_CATE_CD = 'R' AND FAV_SEQ_NO IN (SELECT dong_no FROM dong_code dc))
       OR 
       (FAV_CATE_CD = 'P' AND FAV_SEQ_NO IN (SELECT product_no FROM product_info pi2 )))
LIMIT 10000000;

SELECT count(*)
  FROM fav_info
 WHERE USER_TYPE = 'U' AND MEM_NO NOT IN (SELECT mem_no FROM user_info); -- 831

SELECT count(*)
  FROM fav_info
 WHERE USER_TYPE = 'R' AND MEM_NO NOT IN (SELECT REALTOR_NO FROM realtor_info); -- 0

SELECT count(*)
  FROM fav_info
 WHERE FAV_CATE_CD = 'D' AND FAV_SEQ_NO NOT IN (SELECT danji_no FROM danji_info); -- 0

SELECT count(*)
  FROM fav_info
 WHERE FAV_CATE_CD = 'R' AND FAV_SEQ_NO NOT IN (SELECT dong_no FROM dong_code); -- 0

SELECT count(*)
  FROM fav_info
 WHERE FAV_CATE_CD = 'P' AND FAV_SEQ_NO NOT IN (SELECT product_no FROM product_info); -- 129831

-- realtor_info
 /*tb_lrea_office_info*/
select 
  IFNULL(REPLACE(REALTOR_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(BIZ_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(COMPANY_NAME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(COMPANY_RSTV_NAME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(EXPS_TEL_TYPE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(COMPANY_SAFETY_PHONE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(COMPANY_RSTN_PHONE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REALTOR_PHONE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(COMPANY_ADDR,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(GUGUN_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DONG_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(HDONG_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(USER_LEVEL,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REALTOR_PIC1,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REALTOR_PIC2,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REALTOR_PIC3,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REALTOR_LAT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REALTOR_LNG,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(MEM_TYPE_CD,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(STATUS_CODE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REG_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(UPT_DT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(STAT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(COMPANY_GEOCODE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SYS_TIMESTAMP,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(HOMEPAGE,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/realtor_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.realtor_info 
 LIMIT 10000000;

/*tb_com_user*/
SELECT
  ROW_NUMBER () OVER (ORDER BY REALTOR_NO) + 49001
, ROW_NUMBER () OVER (ORDER BY REALTOR_NO) + 49001
, ''
, IFNULL(REPLACE(COMPANY_RSTV_NAME,CONCAT(CHAR(10)), ''), '')
, ''
, IFNULL(REPLACE(REALTOR_PHONE,CONCAT(CHAR(10)), ''), '')
, ''
, ''
, ''
, ''
, ''
, ''
, ''
, ''
, IFNULL(REPLACE(STAT,CONCAT(CHAR(10)), ''), '')
, ''
, IFNULL(REPLACE(REG_DT,CONCAT(CHAR(10)), ''), '')
, ''
, IFNULL(REPLACE(UPT_DT,CONCAT(CHAR(10)), ''), '')
, ''
, ''
, ''
, IFNULL(REPLACE(REALTOR_PIC1,CONCAT(CHAR(10)), ''), '')
, ''
, IFNULL(REPLACE(COMPANY_NAME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REALTOR_NO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(BIZ_NO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(EXPS_TEL_TYPE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(COMPANY_SAFETY_PHONE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(COMPANY_RSTN_PHONE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(COMPANY_ADDR,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(GUGUN_NO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(DONG_NO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(HDONG_NO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(USER_LEVEL,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(REALTOR_PIC2,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(REALTOR_PIC3,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(REALTOR_LAT,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(REALTOR_LNG,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(MEM_TYPE_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(STATUS_CODE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(COMPANY_GEOCODE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(SYS_TIMESTAMP,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(HOMEPAGE,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/realtor_info_user.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.realtor_info ri 
       INNER JOIN
       (SELECT DISTINCT mem_no 
          FROM hanbang.fav_info 
         WHERE USER_TYPE = 'R'
         UNION
        SELECT DISTINCT mem_no
          FROM hanbang.user_mamul_agent) a
           ON ri.REALTOR_NO = a.mem_no
 ORDER BY 1
 LIMIT 10000000;

/*tb_com_user_group*/
select 
  ROW_NUMBER () OVER (ORDER BY REALTOR_NO) + 48647
, 3
, ROW_NUMBER () OVER (ORDER BY REALTOR_NO) + 49001
, ''
, IFNULL(REPLACE(REG_DT,CONCAT(CHAR(10)), ''), '')
, ''
, IFNULL(REPLACE(UPT_DT,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(REALTOR_NO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(BIZ_NO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(COMPANY_NAME,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(COMPANY_RSTV_NAME,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(EXPS_TEL_TYPE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(COMPANY_SAFETY_PHONE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(COMPANY_RSTN_PHONE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(REALTOR_PHONE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(COMPANY_ADDR,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(GUGUN_NO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(DONG_NO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(HDONG_NO,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(USER_LEVEL,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(REALTOR_PIC1,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(REALTOR_PIC2,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(REALTOR_PIC3,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(REALTOR_LNG,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(REALTOR_LAT,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(MEM_TYPE_CD,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(STATUS_CODE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(STAT,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(COMPANY_GEOCODE,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(SYS_TIMESTAMP,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(HOMEPAGE,CONCAT(CHAR(10)), ''), '')
  into outfile '/var/lib/mysql/backup/realtor_info_user_group.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.realtor_info ri 
       INNER JOIN
       (SELECT DISTINCT mem_no 
          FROM hanbang.fav_info 
         WHERE USER_TYPE = 'R'
         UNION
        SELECT DISTINCT mem_no
          FROM hanbang.user_mamul_agent) a
           ON ri.REALTOR_NO = a.mem_no
 ORDER BY 1
 LIMIT 10000000;

-- bunyang_info
select 
  IFNULL(REPLACE(BUNYANG_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(BUNYANG_SUBJECT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(BUNYANG_CONTENT,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SIDO_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SIDO_NAME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(GUGUN_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(GUGUN_NAME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DONG_NO,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(DONG_NAME,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(ADDR_DETAIL,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(BIZ_SIZE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(PRIVATE_AREA,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(PARCEL_PRICE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(RECRUIT_DATE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(APP_DATE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(PRIZE_WIN_DATE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(MOVE_IN_DATE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(CONTRACT_DATE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(BUILDER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(OPEN_HOUSES,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(PRESALE_INQUIRY,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(COMFORTS,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(TRAFFIC_ENV,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(EDU_ENV,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(IMG_URL,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(INPUT_USER,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(REG_DATE,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(SYS_TIMESTAMP,CONCAT(CHAR(10)), ''), '')
into outfile '/var/lib/mysql/backup/bunyang_info.txt'
        FIELDS TERMINATED BY '||'
        LINES TERMINATED BY '\n'
  FROM hanbang.bunyang_info 
 LIMIT 10000000;

-- user_mamul_photo
select 
  ROW_NUMBER () OVER (ORDER BY regdate)
, IFNULL(REPLACE(mm_no,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(seq,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(file_title,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(file_url,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(thumb_url,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(file_nm_server,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(file_nm_user,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(file_nm_thumb,CONCAT(CHAR(10)), ''), '')
, ''
, IFNULL(REPLACE(regdate,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(key_str,CONCAT(CHAR(10)), ''), '')
, ''
, ''
  into outfile '/var/lib/mysql/backup/user_mamul_photo.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.user_mamul_photo
 WHERE mm_no IN (SELECT mm_no
                   FROM user_mamul um
                        INNER JOIN 
                        user_info ui
                           ON um.user_no=ui.mem_no)
 LIMIT 10000000;

SELECT count(*)
  FROM user_mamul_photo ump
 WHERE mm_no NOT IN (SELECT mm_no
                   FROM user_mamul um
                        INNER JOIN 
                        user_info ui
                           ON um.user_no=ui.mem_no);

-- user_mamul
select 
  IFNULL(REPLACE(mm_no,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(user_no,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(agent_cnt,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(cate_cd,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(gure_cd,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(state_cd,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(cost,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(cost_month,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(space,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(cost_month_fr,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(space_fr,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(sido_no,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(sido_no_nm,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(gugun_no,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(gugun_no_nm,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(dong_no,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(dong_no_nm,CONCAT(CHAR(10)), ''), '')
, CASE WHEN LENGTH(BON_NO)<=4 THEN IFNULL(REPLACE(BON_NO,CONCAT(CHAR(10)), ''), '') ELSE '' END
, CASE WHEN LENGTH(BU_NO)<=4 THEN IFNULL(REPLACE(BU_NO,CONCAT(CHAR(10)), ''), '') ELSE '' END
, ''
, ''
, IFNULL(REPLACE(coor_lat,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(coor_lng,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(cost_fr,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(address,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(title,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(feature,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(msg_cnt,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(photo_url,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(cust_name,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(cust_tel,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(find_option,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(amt_sell_fr,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(amt_sell_to,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(amt_guar_fr,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(amt_guar_to,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(amt_month_fr,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(amt_month_to,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(floor_fr,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(floor_to,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(jun_meter_fr,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(jun_meter_to,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(gong_meter_fr,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(gong_meter_to,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(room_cnt_fr,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(room_cnt_to,CONCAT(CHAR(10)), ''), '')
, ''
-- , IFNULL(REPLACE(move_date,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(photo_list,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(area_list,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(agent_list,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(open_type,CONCAT(CHAR(10)), ''), '')
, ''
, IFNULL(REPLACE(um.reg_date,CONCAT(CHAR(10)), ''), '')
, ''
, IFNULL(REPLACE(um.mod_date,CONCAT(CHAR(10)), ''), '')
  INTO outfile '/var/lib/mysql/backup/user_mamul.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.user_mamul um
       INNER JOIN 
       user_info ui 
          ON um.user_no = ui.mem_no
 WHERE um.reg_date < '2023-05-01'
 LIMIT 10000000;

SELECT count(*)
  FROM user_mamul
 WHERE LENGTH(bon_no)>4;

SELECT count(*)
  FROM user_mamul
 WHERE LENGTH(bu_no)>4;

SELECT count(*)
  FROM user_mamul
 WHERE user_no IN (SELECT user_no
                     FROM user_mamul
                   EXCEPT 
                   SELECT mem_no
                     FROM user_info);

SELECT count(*)
  FROM user_mamul
 WHERE reg_date > '2023-05-01';

-- user_mamul_agent
select 
  ROW_NUMBER () OVER (ORDER BY mm_no, mem_no)
, IFNULL(REPLACE(mm_no,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(mem_no,CONCAT(CHAR(10)), ''), '')
, IFNULL(REPLACE(is_selected,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(com_addr,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(com_lat,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(com_long,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(com_name,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(com_tel,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(com_tel_safe,CONCAT(CHAR(10)), ''), '')
-- , IFNULL(REPLACE(owner_nm,CONCAT(CHAR(10)), ''), '')
, ''
, ''
, ''
, ''
  into outfile '/var/lib/mysql/backup/user_mamul_agent.txt'
       FIELDS TERMINATED BY '||'
       LINES TERMINATED BY '\n'
  FROM hanbang.user_mamul_agent
 WHERE mm_no IN (SELECT mm_no
                   FROM user_mamul um
                        INNER JOIN 
                        user_info ui
                           ON um.user_no=ui.mem_no
                  WHERE um.reg_date < '2023-05-01')
       AND 
       mem_no IN (SELECT realtor_no FROM realtor_info)
 LIMIT 10000000;

SELECT count(*)
  FROM user_mamul_agent
 WHERE mm_no NOT IN (SELECT mm_no
                       FROM user_mamul um
                            INNER JOIN 
                            user_info ui
                                ON um.user_no=ui.mem_no
                      WHERE um.reg_date < '2023-05-01'); -- 259

SELECT count(*)
  FROM user_mamul_agent
 WHERE mem_no NOT IN (SELECT realtor_no FROM realtor_info); -- 7

SHOW profiles;
















