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
              WHEN type_name(system_type_id) IN ('nchar', 'nvarchar') THEN concat(type_name(system_type_id), '(', max_length/2, ')')
              ELSE type_name(system_type_id)
         END "system_type_name"
         FROM sys.types
        WHERE system_type_id != user_type_id 
              AND 
              name NOT IN ('hierarchyid','geometry','geography','sysname')
              AND
              schema_name(schema_id) = 'sc_khb_srv'
              AND
              name LIKE 'pc%'
       ) a
 ORDER BY 1;

-- 사용자 타입 생성
CREATE TYPE [sc_khb_srv].[dt]
    FROM DATETIME NULL;

CREATE TYPE [sc_khb_srv].[pk_n9]
    FROM NUMERIC(9) NULL;

CREATE TYPE [sc_khb_srv].[sn_v20]
    FROM VARCHAR(20) NULL;

CREATE TYPE [sc_khb_srv].[innb_v20]
    FROM VARCHAR(20) NULL;

CREATE TYPE [sc_khb_srv].[telno_v30]
    FROM VARCHAR(30) NULL;

CREATE TYPE [sc_khb_srv].[vl_n25_15]
    FROM NUMERIC(25,15) NULL;

CREATE TYPE [sc_khb_srv].[nm_nv500]
    FROM NATIONAL CHARACTER VARYING(500) NULL;

CREATE TYPE [sc_khb_srv].[id_nv100]
    FROM NATIONAL CHARACTER VARYING(100) NULL;

CREATE TYPE [sc_khb_srv].[url_nv4000]
    FROM NATIONAL CHARACTER VARYING(4000) NULL;

CREATE TYPE [sc_khb_srv].[addr_nv200]
    FROM NATIONAL CHARACTER VARYING(200) NULL;

CREATE TYPE [sc_khb_srv].[cnt_n15]
    FROM NUMERIC(15) NULL;

CREATE TYPE [sc_khb_srv].[cd_v20]
    FROM VARCHAR(20) NULL;

CREATE TYPE [sc_khb_srv].[cn_nv4000]
    FROM NATIONAL CHARACTER VARYING(4000) NULL;

CREATE TYPE [sc_khb_srv].[cn_nvmax]
    FROM NATIONAL CHARACTER VARYING(max) NULL;

CREATE TYPE [sc_khb_srv].[no_n15]
    FROM NUMERIC(15) NULL;

CREATE TYPE [sc_khb_srv].[no_v200]
    FROM VARCHAR(200) NULL;

CREATE TYPE [sc_khb_srv].[de_v10]
    FROM VARCHAR(10) NULL;

CREATE TYPE [sc_khb_srv].[email_v320]
    FROM VARCHAR(320) NULL;

CREATE TYPE [sc_khb_srv].[lat_n12_10]
    FROM NUMERIC(12,10) NULL;

CREATE TYPE [sc_khb_srv].[lot_n13_10]
    FROM NUMERIC(13,10) NULL;

CREATE TYPE [sc_khb_srv].[crdnt_v500]
    FROM VARCHAR(500) NULL;

CREATE TYPE [sc_khb_srv].[vl_v100]
    FROM VARCHAR(100) NULL;

CREATE TYPE [sc_khb_srv].[yn_c1]
    FROM CHAR(1) NULL;

CREATE TYPE [sc_khb_srv].[at_c1]
    FROM CHAR(1) NULL;

CREATE TYPE [sc_khb_srv].[cycle_v20]
    FROM VARCHAR(20) NULL;

CREATE TYPE [sc_khb_srv].[ordr_n5]
    FROM NUMERIC(5) NULL;

CREATE TYPE [sc_khb_srv].[mno_n4]
    FROM NUMERIC(4) NULL;

CREATE TYPE [sc_khb_srv].[sno_n4]
    FROM NUMERIC(4) NULL;

CREATE TYPE [sc_khb_srv].[amt_n18]
    FROM NUMERIC(18) NULL;

CREATE TYPE [sc_khb_srv].[premium_n18]
    FROM NUMERIC(18) NULL;

CREATE TYPE [sc_khb_srv].[day_nv100]
    FROM NVARCHAR(100) NULL;

CREATE TYPE [sc_khb_srv].[dt_v10]
    FROM VARCHAR(10) NULL;

CREATE TYPE [sc_khb_srv].[area_n19_9]
    FROM NUMERIC(19,9) NULL;

CREATE TYPE [sc_khb_srv].[list_nv1000]
    FROM NVARCHAR(1000) NULL;

CREATE TYPE [sc_khb_srv].[pyeong_n_19_9]
    FROM NUMERIC(19,9) NULL;

CREATE TYPE [sc_khb_srv].[lotno_nv100]
    FROM NVARCHAR(100) NULL;

CREATE TYPE [sc_khb_srv].[cntom_n15]
    FROM NUMERIC(15) NULL;

CREATE TYPE [sc_khb_srv].[year_c4]
    FROM CHAR(4) NULL;

CREATE TYPE [sc_khb_srv].[mt_c2]
    FROM CHAR(2) NULL;

CREATE TYPE [sc_khb_srv].[pd_nv50]
    FROM NVARCHAR(50) NULL;

CREATE TYPE [sc_khb_srv].[co_n15]
    FROM NUMERIC(15,0) NULL;

CREATE TYPE [sc_khb_srv].[code_v20]
    FROM varchar(20) NULL;

create type sc_khb_srv.pc_n10 
    FROM NUMERIC(10, 0);

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
drop TYPE [sc_khb_srv].[list_nv1000_t];

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



















