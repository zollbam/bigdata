/*
사용자 타입을 생성하는 파일
작성 일시: 23-06-25
수정 일시: 23-06-29
작 성 자 : 조건영

참조 사이트
 1) 사용자 타입 권한 부여
  - https://camcap.tistory.com/entry/%EC%82%AC%EC%9A%A9%EC%9E%90-%EC%A0%95%EC%9D%98-%ED%83%80%EC%9E%85%EC%97%90-%EA%B6%8C%ED%95%9C-%EB%B6%80%EC%97%AC-%EC%BF%BC%EB%A6%AC-%EC%9E%91%EC%A0%95%EC%8B%9C-%EC%A3%BC%EC%9D%98%EC%A0%90
  - https://learn.microsoft.com/ko-kr/sql/t-sql/statements/create-type-transact-sql?view=sql-server-ver16
  - https://atotw.tistory.com/319
*/

-- 열별 마지막 용어 확인 
SELECT 
  table_name "테이블명"
, COLUMN_NAME "컬럼명"
, CASE WHEN charindex('_', COLUMN_NAME) = 0 THEN COLUMN_NAME
       ELSE substring(RIGHT(COLUMN_NAME,5), charindex('_', RIGHT(COLUMN_NAME,5)) +1, len(RIGHT(COLUMN_NAME,5)))
  END "마지막 용어"
, DOMAIN_NAME "사용자 타입"
, CASE WHEN DATA_TYPE IN ('decimal', 'numeric') 
           THEN DATA_TYPE + '(' + CAST(NUMERIC_PRECISION AS varchar) + ', ' + CAST(NUMERIC_SCALE AS varchar) + ')'
	   WHEN DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar') 
	       THEN DATA_TYPE + '(' + 
	            CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 
	                     THEN 'max)' 
	                 ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
	        END
	   ELSE DATA_TYPE
  END "시스템 타입"
  FROM information_schema.columns
 WHERE TABLE_SCHEMA = 'sc_khb_srv'
--       AND
--       DOMAIN_NAME IS NULL
 ORDER BY 1;

-- 사용자 타입 => 기본 타입
SELECT 
  schema_name(schema_id) "schema_name"
, name "user_type_name"
, CASE WHEN type_name(system_type_id) IN ('numeric', 'decimal') THEN concat(type_name(system_type_id), '(', PRECISION,', ', SCALE, ')')
       WHEN type_name(system_type_id) IN ('char', 'varchar') THEN concat(type_name(system_type_id), '(', max_length, ')')
       WHEN type_name(system_type_id) IN ('nchar', 'nvarchar') THEN concat(type_name(system_type_id), '(', max_length/2, ')')
       ELSE type_name(system_type_id)
  END "system_type_name"
  FROM sys.types
 WHERE system_type_id != user_type_id 
       AND 
       name NOT IN ('hierarchyid','geometry','geography','sysname')
       AND
       schema_name(schema_id) = 'sc_khb_srv'
 ORDER BY 1, 2;

-- 사용자 타입 생성 스크립트 쿼리문
SELECT user_type_name,
  'create type ' +
  schema_name + '.' +
  user_type_name + 
  ' from ' + system_type_name + ';' "사용자 타입 생성 스크립트"
  FROM (
       SELECT 
         schema_name(schema_id) "schema_name"
       , name "user_type_name"
       , CASE WHEN type_name(system_type_id) IN ('numeric', 'decimal') THEN concat(type_name(system_type_id), '(', PRECISION,', ', SCALE, ')')
              WHEN type_name(system_type_id) IN ('char', 'varchar') THEN concat(type_name(system_type_id), '(', max_length, ')')
              WHEN type_name(system_type_id) IN ('nchar', 'nvarchar') THEN CASE WHEN max_length = -1 
                                                                                    THEN concat(type_name(system_type_id), '(max)')
                                                                                ELSE concat(type_name(system_type_id), '(', max_length/2, ')')
                                                                           END
              ELSE type_name(system_type_id)
         END "system_type_name"
         FROM sys.types
        WHERE system_type_id != user_type_id 
              AND 
              name NOT IN ('hierarchyid','geometry','geography','sysname')
              AND
              schema_name(schema_id) = 'sc_khb_srv'
--              AND
--              name LIKE 'pc%'
       ) a
 ORDER BY 1;

-- 사용자 타입 생성
create type sc_khb_srv.addr_nv200 from nvarchar(200);
create type sc_khb_srv.amt_n18 from numeric(18, 0);
create type sc_khb_srv.area_n19_9 from numeric(19, 9);
create type sc_khb_srv.at_c1 from char(1);
create type sc_khb_srv.cd_v20 from varchar(20);
create type sc_khb_srv.cn_nv4000 from nvarchar(4000);
create type sc_khb_srv.cn_nvmax from nvarchar(max);
create type sc_khb_srv.cnt_n15 from numeric(15, 0);
create type sc_khb_srv.cntom_n15 from numeric(15, 0);
create type sc_khb_srv.co_n15 from numeric(15, 0);
create type sc_khb_srv.cours_v100 from varchar(100);
create type sc_khb_srv.crdnt_v500 from varchar(500);
create type sc_khb_srv.cycle_v20 from varchar(20);
create type sc_khb_srv.day_nv100 from nvarchar(100);
create type sc_khb_srv.de_v10 from varchar(10);
create type sc_khb_srv.dt from datetime;
create type sc_khb_srv.dt_v10 from varchar(10);
create type sc_khb_srv.email_v320 from varchar(320);
create type sc_khb_srv.id_nv100 from nvarchar(100);
create type sc_khb_srv.innb_v20 from varchar(20);
create type sc_khb_srv.lat_n12_10 from numeric(12, 10);
create type sc_khb_srv.list_nv1000 from nvarchar(1000);
create type sc_khb_srv.lot_n13_10 from numeric(13, 10);
create type sc_khb_srv.lotno_nv100 from nvarchar(100);
create type sc_khb_srv.mno_n4 from numeric(4, 0);
create type sc_khb_srv.mt_c2 from char(2);
create type sc_khb_srv.nm_nv500 from nvarchar(500);
create type sc_khb_srv.no_n15 from numeric(15, 0);
create type sc_khb_srv.no_v200 from varchar(200);
create type sc_khb_srv.ordr_n5 from numeric(5, 0);
create type sc_khb_srv.pc_n10 from decimal(10, 0);
create type sc_khb_srv.pd_nv50 from nvarchar(50);
create type sc_khb_srv.pk_n9 from numeric(9, 0);
create type sc_khb_srv.premium_n18 from numeric(18, 0);
create type sc_khb_srv.pyeong_n_19_9 from numeric(19, 9);
create type sc_khb_srv.size_v20 from varchar(20);
create type sc_khb_srv.sn_v20 from varchar(20);
create type sc_khb_srv.sno_n4 from numeric(4, 0);
create type sc_khb_srv.telno_v30 from varchar(30);
create type sc_khb_srv.url_nv4000 from nvarchar(4000);
create type sc_khb_srv.vl_n25_15 from numeric(25, 15);
create type sc_khb_srv.vl_v100 from varchar(100);
create type sc_khb_srv.year_c4 from char(4);
create type sc_khb_srv.yn_c1 from char(1);

-- 사용자 타입 삭제 스크립트 쿼리문
SELECT user_type_name,
  'drop type ' +
  schema_name + '.' +
  user_type_name + ';' "사용자 타입 삭제 스크립트"
  FROM (
       SELECT 
         schema_name(schema_id) "schema_name"
       , name "user_type_name"
       , CASE WHEN type_name(system_type_id) IN ('numeric', 'decimal') THEN concat(type_name(system_type_id), '(', PRECISION,', ', SCALE, ')')
              WHEN type_name(system_type_id) IN ('char', 'varchar') THEN concat(type_name(system_type_id), '(', max_length, ')')
              WHEN type_name(system_type_id) IN ('nchar', 'nvarchar') THEN concat(type_name(system_type_id), '(', max_length/2, ')')
              ELSE type_name(system_type_id)
         END "system_type_name"
         FROM sys.types
        WHERE system_type_id != user_type_id 
              AND 
              name NOT IN ('hierarchyid','geometry','geography','sysname')
              AND
              schema_name(schema_id) = 'sc_khb_srv') a
-- WHERE user_type_name LIKE '%cn%'
 ORDER BY 1;

-- 사용자 타입 삭제
drop TYPE [sc_khb_srv].[code_v20];

-- 사용자 타입 권한 부여 스크립트 쿼리문
DECLARE @user_name varchar(100) = 'us_khb_com' -- 유저명은 원하는 대로 변경
SELECT user_type_name,
  'grant references on type::' +
  schema_name + '.' +
  user_type_name + 
  ' to ' + @user_name + ';' 
  "사용자 타입 권한 부여 스크립트"
  FROM (
       SELECT 
         schema_name(schema_id) "schema_name"
       , name "user_type_name"
       , CASE WHEN type_name(system_type_id) IN ('numeric', 'decimal') THEN concat(type_name(system_type_id), '(', PRECISION,', ', SCALE, ')')
              WHEN type_name(system_type_id) IN ('char', 'varchar') THEN concat(type_name(system_type_id), '(', max_length, ')')
              WHEN type_name(system_type_id) IN ('nchar', 'nvarchar') THEN concat(type_name(system_type_id), '(', max_length/2, ')')
              ELSE type_name(system_type_id)
         END "system_type_name"
         FROM sys.types
        WHERE system_type_id != user_type_id 
              AND 
              name NOT IN ('hierarchyid','geometry','geography','sysname')
              AND
              schema_name(schema_id) = 'sc_khb_srv') a
 ORDER BY 1;

-- 사용자 타입 권한 부여
/*us_khb_adm*/
GRANT REFERENCES ON TYPE::sc_khb_srv.lot_n13_10 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.lat_n12_10 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.list_nv1000 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.cours_v100 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.size_v20 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.co_n15 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.at_c1 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.pyeong_n_19_9 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.telno_v30 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.cntom_n15 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.year_c4 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.mt_c2 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.lotno_nv100 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.pd_nv50 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.sn_v20 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.day_nv100 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.pc_n10 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.pk_n9 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.innb_v20 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.ordr_n5 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.nm_nv500 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.id_nv100 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.url_nv4000 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.cnt_n15 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.mno_n4 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.addr_nv200 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nv4000 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_n15 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_v200 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.de_v10 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.email_v320 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.crdnt_v500 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.sno_n4 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.yn_c1 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nvmax TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.cycle_v20 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_v100 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.cd_v20 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_n25_15 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.amt_n18 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.premium_n18 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt_v10 TO us_khb_adm;
GRANT REFERENCES ON TYPE::sc_khb_srv.area_n19_9 TO us_khb_adm;

/*us_khb_com*/
GRANT REFERENCES ON TYPE::sc_khb_srv.lot_n13_10 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.lat_n12_10 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.list_nv1000 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.cours_v100 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.size_v20 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.co_n15 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.at_c1 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.pyeong_n_19_9 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.telno_v30 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.cntom_n15 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.year_c4 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.mt_c2 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.lotno_nv100 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.pd_nv50 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.sn_v20 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.day_nv100 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.pc_n10 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.pk_n9 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.innb_v20 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.ordr_n5 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.nm_nv500 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.id_nv100 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.url_nv4000 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.cnt_n15 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.mno_n4 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.addr_nv200 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nv4000 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_n15 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_v200 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.de_v10 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.email_v320 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.crdnt_v500 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.sno_n4 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.yn_c1 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nvmax TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.cycle_v20 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_v100 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.cd_v20 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_n25_15 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.amt_n18 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.premium_n18 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt_v10 TO us_khb_com;
GRANT REFERENCES ON TYPE::sc_khb_srv.area_n19_9 TO us_khb_com;

/*us_khb_dev*/
GRANT REFERENCES ON TYPE::sc_khb_srv.lot_n13_10 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.lat_n12_10 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.list_nv1000 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.cours_v100 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.size_v20 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.co_n15 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.at_c1 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.pyeong_n_19_9 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.telno_v30 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.cntom_n15 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.year_c4 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.mt_c2 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.lotno_nv100 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.pd_nv50 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.sn_v20 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.day_nv100 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.pc_n10 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.pk_n9 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.innb_v20 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.ordr_n5 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.nm_nv500 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.id_nv100 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.url_nv4000 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.cnt_n15 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.mno_n4 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.addr_nv200 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nv4000 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_n15 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_v200 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.de_v10 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.email_v320 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.crdnt_v500 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.sno_n4 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.yn_c1 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nvmax TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.cycle_v20 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_v100 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.cd_v20 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_n25_15 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.amt_n18 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.premium_n18 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt_v10 TO us_khb_dev;
GRANT REFERENCES ON TYPE::sc_khb_srv.area_n19_9 TO us_khb_dev;

/*us_khb_agnt*/
GRANT REFERENCES ON TYPE::sc_khb_srv.lot_n13_10 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.lat_n12_10 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.list_nv1000 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.cours_v100 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.size_v20 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.co_n15 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.at_c1 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.pyeong_n_19_9 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.telno_v30 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.cntom_n15 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.year_c4 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.mt_c2 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.lotno_nv100 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.pd_nv50 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.sn_v20 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.day_nv100 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.pc_n10 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.pk_n9 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.innb_v20 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.ordr_n5 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.nm_nv500 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.id_nv100 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.url_nv4000 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.cnt_n15 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.mno_n4 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.addr_nv200 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nv4000 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_n15 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_v200 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.de_v10 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.email_v320 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.crdnt_v500 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.sno_n4 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.yn_c1 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nvmax TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.cycle_v20 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_v100 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.cd_v20 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_n25_15 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.amt_n18 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.premium_n18 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt_v10 TO us_khb_agnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.area_n19_9 TO us_khb_agnt;

/*us_khb_exif*/
GRANT REFERENCES ON TYPE::sc_khb_srv.lot_n13_10 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.lat_n12_10 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.list_nv1000 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.cours_v100 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.size_v20 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.co_n15 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.at_c1 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.pyeong_n_19_9 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.telno_v30 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.cntom_n15 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.year_c4 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.mt_c2 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.lotno_nv100 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.pd_nv50 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.sn_v20 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.day_nv100 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.pc_n10 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.pk_n9 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.innb_v20 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.ordr_n5 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.nm_nv500 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.id_nv100 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.url_nv4000 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.cnt_n15 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.mno_n4 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.addr_nv200 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nv4000 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_n15 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_v200 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.de_v10 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.email_v320 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.crdnt_v500 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.sno_n4 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.yn_c1 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nvmax TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.cycle_v20 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_v100 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.cd_v20 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_n25_15 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.amt_n18 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.premium_n18 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt_v10 TO us_khb_exif;
GRANT REFERENCES ON TYPE::sc_khb_srv.area_n19_9 TO us_khb_exif;

/*us_khb_magnt*/
GRANT REFERENCES ON TYPE::sc_khb_srv.lot_n13_10 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.lat_n12_10 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.list_nv1000 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.cours_v100 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.size_v20 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.co_n15 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.at_c1 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.pyeong_n_19_9 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.telno_v30 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.cntom_n15 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.year_c4 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.mt_c2 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.lotno_nv100 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.pd_nv50 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.sn_v20 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.day_nv100 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.pc_n10 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.pk_n9 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.innb_v20 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.ordr_n5 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.nm_nv500 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.id_nv100 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.url_nv4000 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.cnt_n15 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.mno_n4 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.addr_nv200 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nv4000 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_n15 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_v200 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.de_v10 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.email_v320 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.crdnt_v500 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.sno_n4 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.yn_c1 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nvmax TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.cycle_v20 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_v100 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.cd_v20 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_n25_15 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.amt_n18 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.premium_n18 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt_v10 TO us_khb_magnt;
GRANT REFERENCES ON TYPE::sc_khb_srv.area_n19_9 TO us_khb_magnt;

/*us_khb_mptl*/
GRANT REFERENCES ON TYPE::sc_khb_srv.lot_n13_10 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.lat_n12_10 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.list_nv1000 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.cours_v100 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.size_v20 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.co_n15 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.at_c1 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.pyeong_n_19_9 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.telno_v30 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.cntom_n15 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.year_c4 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.mt_c2 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.lotno_nv100 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.pd_nv50 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.sn_v20 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.day_nv100 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.pc_n10 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.pk_n9 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.innb_v20 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.ordr_n5 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.nm_nv500 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.id_nv100 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.url_nv4000 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.cnt_n15 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.mno_n4 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.addr_nv200 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nv4000 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_n15 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_v200 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.de_v10 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.email_v320 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.crdnt_v500 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.sno_n4 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.yn_c1 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nvmax TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.cycle_v20 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_v100 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.cd_v20 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_n25_15 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.amt_n18 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.premium_n18 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt_v10 TO us_khb_mptl;
GRANT REFERENCES ON TYPE::sc_khb_srv.area_n19_9 TO us_khb_mptl;

/*us_khb_report*/
GRANT REFERENCES ON TYPE::sc_khb_srv.lot_n13_10 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.lat_n12_10 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.list_nv1000 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.cours_v100 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.size_v20 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.co_n15 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.at_c1 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.pyeong_n_19_9 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.telno_v30 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.cntom_n15 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.year_c4 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.mt_c2 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.lotno_nv100 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.pd_nv50 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.sn_v20 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.day_nv100 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.pc_n10 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.pk_n9 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.innb_v20 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.ordr_n5 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.nm_nv500 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.id_nv100 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.url_nv4000 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.cnt_n15 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.mno_n4 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.addr_nv200 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nv4000 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_n15 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.no_v200 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.de_v10 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.email_v320 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.crdnt_v500 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.sno_n4 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.yn_c1 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.cn_nvmax TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.cycle_v20 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_v100 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.cd_v20 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.vl_n25_15 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.amt_n18 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.premium_n18 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.dt_v10 TO us_khb_report;
GRANT REFERENCES ON TYPE::sc_khb_srv.area_n19_9 TO us_khb_report;



















