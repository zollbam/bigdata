/*
테이블을 작성해주는 쿼리문을 짜주는 파일
작성 일시: 23-06-10
수정 일시: 23-07-21
작 성 자 : 조건영

*/

-- 테이블 정보
SELECT 
  object_name(ep.major_id) "테이블명"
, ep.value "테이블명(한글)"
  FROM sys.extended_properties ep
       INNER JOIN
       information_schema.tables t 
           ON object_name(ep.major_id) = t.TABLE_NAME
 WHERE ep.minor_id = 0
       AND 
       t.TABLE_SCHEMA = 'sc_khb_srv'
       AND 
       CAST(ep.value AS varchar) NOT LIKE '%공통%'
--       CAST(ep.value AS varchar) LIKE '%공통%'
 ORDER BY 1;

-- 테이블의 열 정보(열번호 맞게 => comment 전부 보여줌)
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
, type_name(c.user_type_id) "사용자 타입"
, CASE WHEN c.IS_NULLABLE = 0 THEN ' NOT NULL'
       ELSE ''
  END "NULL여부"
, ep.value "컬럼명(한글)"
, c.column_id
FROM sys.columns c
     INNER JOIN
     information_schema.constraint_column_usage ccu
     	ON object_name(c.object_id) = ccu.TABLE_NAME
     LEFT JOIN
     sys.extended_properties ep
     	ON object_name(c.object_id) = object_name(ep.major_id) AND c.column_id = ep.minor_id
WHERE ccu.TABLE_SCHEMA = 'sc_khb_srv'
      AND
      object_name(c.object_id) = 'tb_link_apt_lttot_info'
--      AND 
--      CAST(ep.value AS varchar) LIKE '%%'
ORDER BY 1, c.column_id;

-- 컬럼 이름에 맞는 사용자 타입 찾기
SELECT 
  TABLE_SCHEMA "schema_name" 
, TABLE_NAME "table_name"
, COLUMN_NAME "column_name"
, CASE WHEN charindex('_', COLUMN_NAME) = 0 THEN COLUMN_NAME
       ELSE substring(RIGHT(COLUMN_NAME,5), charindex('_', RIGHT(COLUMN_NAME,5)) +1, len(RIGHT(COLUMN_NAME,5)))
  END + 
  CASE WHEN DATA_TYPE = 'decimal' THEN concat('_', 'd', NUMERIC_PRECISION, '_', NUMERIC_SCALE)
       WHEN DATA_TYPE = 'numeric' THEN concat('_', 'n', NUMERIC_PRECISION)
       WHEN DATA_TYPE = 'char' THEN concat('_', 'c', CHARACTER_MAXIMUM_LENGTH)
       WHEN DATA_TYPE = 'nchar' THEN concat('_', 'nc', CHARACTER_MAXIMUM_LENGTH)
       WHEN DATA_TYPE = 'varchar' THEN CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN '_vmax'
                                            ELSE concat('_', 'v', CHARACTER_MAXIMUM_LENGTH)
                                       END
       WHEN DATA_TYPE = 'nvarchar' THEN CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN '_nvmax'
                                             ELSE concat('_', 'nv', CHARACTER_MAXIMUM_LENGTH)
                                        END
       WHEN DATA_TYPE IN ('date', 'datetime') THEN ''
  END  + 
  CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL'
	   ELSE ''
  END "make_user_type"
  FROM information_schema.columns
 WHERE table_NAME = 'tb_link_subway_statn_info'
-- WHERE TABLE_NAME = 'tb_svc_bass_info';
/*
시스템 타입을 사용자 타입으로 변경하기 위해 만든 쿼리
*/

-- 타입 변경 업데이트 쿼리 작성
SELECT 
  'alter table ' + 
  tr.schema_name + '.' +
  tr.table_name + ' ' +
  'alter column ' +
  tr.column_name + ' ' +
  'sc_khb_srv.' + tr.make_user_type
  FROM (
        SELECT 
          TABLE_SCHEMA "schema_name" 
        , TABLE_NAME "table_name"
        , COLUMN_NAME "column_name"
        , CASE WHEN charindex('_', COLUMN_NAME) = 0 THEN COLUMN_NAME
               ELSE substring(RIGHT(COLUMN_NAME,5), charindex('_', RIGHT(COLUMN_NAME,5)) +1, len(RIGHT(COLUMN_NAME,5)))
          END + 
          CASE WHEN DATA_TYPE = 'decimal' THEN concat('_', 'd', NUMERIC_PRECISION, '_', NUMERIC_SCALE)
               WHEN DATA_TYPE = 'numeric' THEN concat('_', 'n', NUMERIC_PRECISION)
               WHEN DATA_TYPE = 'char' THEN concat('_', 'c', CHARACTER_MAXIMUM_LENGTH)
               WHEN DATA_TYPE = 'nchar' THEN concat('_', 'nc', CHARACTER_MAXIMUM_LENGTH)
               WHEN DATA_TYPE = 'varchar' THEN CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN '_vmax'
                                                    ELSE concat('_', 'v', CHARACTER_MAXIMUM_LENGTH)
                                               END
               WHEN DATA_TYPE = 'nvarchar' THEN CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN '_nvmax'
                                                     ELSE concat('_', 'nv', CHARACTER_MAXIMUM_LENGTH)
                                        END
               WHEN DATA_TYPE IN ('date', 'datetime') THEN ''
          END  + 
          CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL'
	           ELSE ''
          END "make_user_type"
         FROM information_schema.columns
        WHERE table_NAME = 'tb_com_sgg_cd'
       ) tr;


-- 테이블 생성 쿼리(시스템 타입)
SELECT DISTINCT c2.TABLE_NAME "테이블명",
       'CREATE TABLE ' + c2.TABLE_SCHEMA + '.' + c2.TABLE_NAME + ' (' + char(13) + '  ' +
       replace(
	   stuff((SELECT ', ' + c1.COLUMN_NAME + ' ' + 
		          CASE WHEN c1.DATA_TYPE IN ('decimal', 'numeric') THEN c1.DATA_TYPE + '(' + CAST(c1.NUMERIC_PRECISION AS varchar) + ', ' + CAST(c1.NUMERIC_SCALE AS varchar) + ')'
	                   WHEN c1.DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar') THEN c1.DATA_TYPE + '(' + 
	                       CASE WHEN c1.CHARACTER_MAXIMUM_LENGTH = -1 THEN 'max)' 
	                            ELSE CAST(c1.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
	                       END
	                   ELSE c1.DATA_TYPE
	              END + 
	              CASE WHEN c1.IS_NULLABLE = 'NO' THEN ' NOT NULL'
	                   ELSE ''
	              END +
                  CASE WHEN c1.COLUMN_DEFAULT IS NOT NULL THEN ' default ' + c1.COLUMN_DEFAULT
                       ELSE ''
                  END + char(13) + char(10)
              FROM information_schema.columns c1
              WHERE c1.TABLE_NAME = c2.TABLE_name
              	FOR xml PATH('')), 1, 2, ''), 
       '&#x0D;', '') +');' "테이블별 작성 스크립트"
--        + CASE WHEN ccu.COLUMN_NAME != '' THEN ', primary key (' + stuff((SELECT ', ' + COLUMN_NAME
--                                                                         FROM information_schema.constraint_column_usage ccu1
--                                                                        WHERE CONSTRAINT_NAME LIKE 'PK_%' AND ccu.TABLE_NAME = ccu1.TABLE_NAME
--                                                                          FOR xml PATH('')),1,2,'') + ')' + char(13) +');' END "테이블별 작성 스크립트"
  FROM information_schema.columns c2
--       INNER JOIN
--       information_schema.constraint_column_usage ccu
--           ON c2.TABLE_NAME = ccu.TABLE_NAME AND c2.COLUMN_NAME = ccu.COLUMN_NAME
-- WHERE ccu.CONSTRAINT_NAME LIKE 'pk%'
 WHERE c2.TABLE_SCHEMA = 'sc_khb_srv'
 GROUP BY c2.TABLE_SCHEMA, c2.TABLE_NAME -- , ccu.TABLE_NAME, ccu.COLUMN_NAME
 ORDER BY 1;

-- 테이블 생성 쿼리(사용자 타입)
--SELECT DISTINCT c2.TABLE_NAME "테이블명",
--       'CREATE TABLE ' + c2.TABLE_SCHEMA + '.' + c2.TABLE_NAME + ' (' + char(13) + '  ' +
--       replace(
--	   stuff((SELECT ', ' + c1.COLUMN_NAME + ' ' + 
--	                 'sc_khb_srv.' + type_name(sc.user_type_id) +
--	              CASE WHEN c1.IS_NULLABLE = 'NO' THEN ' NOT NULL'
--	                   ELSE ''
--	              END +
--                  CASE WHEN c1.COLUMN_DEFAULT IS NOT NULL THEN ' default ' + c1.COLUMN_DEFAULT
--                       ELSE ''
--                  END + char(13) + char(10)
--              FROM information_schema.columns c1
--                   INNER JOIN
--                   sys.columns sc
--                       ON object_name(sc.object_id) = c1.TABLE_NAME
--                          AND 
--                          sc.name = c1.COLUMN_NAME
--              WHERE c1.TABLE_NAME = c2.TABLE_name
--              ORDER BY ORDINAL_POSITION
--              	FOR xml PATH('')), 1, 2, ''),
--       '&#x0D;', '') + ');' "테이블별 작성 스크립트"
----       CASE WHEN ccu.COLUMN_NAME != '' THEN ', primary key (' + stuff((SELECT ', ' + COLUMN_NAME
----                                                                         FROM information_schema.constraint_column_usage ccu1
----                                                                        WHERE CONSTRAINT_NAME LIKE 'PK_%' AND ccu.TABLE_NAME = ccu1.TABLE_NAME
----                                                                          FOR xml PATH('')),1,2,'') + ')' + char(13) +');' END "테이블별 작성 스크립트"
--  FROM information_schema.columns c2
----       INNER JOIN
----       information_schema.constraint_column_usage ccu
----           ON c2.TABLE_NAME = ccu.TABLE_NAME AND c2.COLUMN_NAME = ccu.COLUMN_NAME
---- WHERE ccu.CONSTRAINT_NAME LIKE 'pk%'
-- WHERE c2.TABLE_SCHEMA = 'sc_khb_srv'
-- GROUP BY c2.TABLE_SCHEMA, c2.TABLE_NAME -- , ccu.TABLE_NAME, ccu.COLUMN_NAME
-- ORDER BY 1;

-- 테이블 생성 쿼리(사용자 타입) => 좌표 이슈로 인한 수정본
SELECT DISTINCT c2.TABLE_NAME "테이블명",
       'CREATE TABLE ' + c2.TABLE_SCHEMA + '.' + c2.TABLE_NAME + ' (' + char(13) + '  ' +
       replace(
	   stuff((SELECT ', ' + c1.COLUMN_NAME + ' ' + 
	                 CASE WHEN c1.COLUMN_NAME LIKE '%crdnt%' THEN 'geometry'
	                      ELSE 'sc_khb_srv.' + type_name(sc.user_type_id)
	                 END +
	              CASE WHEN c1.IS_NULLABLE = 'NO' THEN ' NOT NULL'
	                   ELSE ''
	              END +
                  CASE WHEN c1.COLUMN_DEFAULT IS NOT NULL THEN ' default ' + c1.COLUMN_DEFAULT
                       ELSE ''
                  END + char(13) + char(10)
              FROM information_schema.columns c1
                   INNER JOIN
                   sys.columns sc
                       ON object_name(sc.object_id) = c1.TABLE_NAME
                          AND 
                          sc.name = c1.COLUMN_NAME
              WHERE c1.TABLE_NAME = c2.TABLE_name
              ORDER BY ORDINAL_POSITION
              	FOR xml PATH('')), 1, 2, '') +
       CASE WHEN c2.TABLE_NAME = 'tb_lrea_office_info' THEN ', lrea_office_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
            WHEN c2.TABLE_NAME = 'tb_link_subway_statn_info' THEN ', statn_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
            WHEN c2.TABLE_NAME = 'tb_atlfsl_bsc_info' THEN ', atlfsl_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
--            WHEN c2.TABLE_NAME = 'tb_com_ctpv_cd' THEN ', ctpv_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
            WHEN c2.TABLE_NAME = 'tb_com_emd_li_cd' THEN ', emd_li_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
--            WHEN c2.TABLE_NAME = 'tb_com_sgg_cd' THEN ', sgg_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
            WHEN c2.TABLE_NAME = 'tb_hsmp_info' THEN ', hsmp_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
            ELSE ''
       END,
       '&#x0D;', '') + ');' "테이블별 작성 스크립트"
--       CASE WHEN ccu.COLUMN_NAME != '' THEN ', primary key (' + stuff((SELECT ', ' + COLUMN_NAME
--                                                                         FROM information_schema.constraint_column_usage ccu1
--                                                                        WHERE CONSTRAINT_NAME LIKE 'PK_%' AND ccu.TABLE_NAME = ccu1.TABLE_NAME
--                                                                          FOR xml PATH('')),1,2,'') + ')' + char(13) +');' END "테이블별 작성 스크립트"
  FROM information_schema.columns c2
--       INNER JOIN
--       information_schema.constraint_column_usage ccu
--           ON c2.TABLE_NAME = ccu.TABLE_NAME AND c2.COLUMN_NAME = ccu.COLUMN_NAME
-- WHERE ccu.CONSTRAINT_NAME LIKE 'pk%'
 WHERE c2.TABLE_SCHEMA = 'sc_khb_srv'
 GROUP BY c2.TABLE_SCHEMA, c2.TABLE_NAME -- , ccu.TABLE_NAME, ccu.COLUMN_NAME
 ORDER BY 1;

-- 테이블별 bulk insert 스크립트
SELECT 
  table_name
, 'bulk insert ' + TABLE_SCHEMA + '.' + TABLE_NAME + char(10) + 
  'from ''D:\migra_data\' + table_name + '.txt''' + char(10) +
  'with (' + char(10) +
  '    codepage = ''65001''' + char(10) +
  '  , fieldterminator = ''||''' + char(10) +
  '  , rowterminator = ''0x0a''' + char(10) +
  ');'
  FROM information_schema.tables
 ORDER BY 1;
/*from절에 있는 table_name은 파일명으로 직접 입력 해주어야 함*/
 
-- 문자형 타입 좌표 타입으로 변경 및 열 삭제
SELECT
  TABLE_NAME
, 'update ' + TABLE_SCHEMA + '.'+ TABLE_NAME + ' set ' + COLUMN_NAME + ' = geometry::STPointFromText(' + COLUMN_NAME + '_tmp, 4326)' + 
  ' WHERE ' + COLUMN_NAME + '_tmp NOT LIKE ''%null%'' AND ' + COLUMN_NAME + '_tmp NOT LIKE ''%0.0%'';' "좌표타입 데이터 입력쿼리"
, 'alter table ' + table_schema + '.' + table_name + ' drop column ' + column_name + '_tmp;' "열 삭제 쿼리"
  FROM information_schema.columns
 WHERE COLUMN_NAME LIKE '%crdnt%'
       AND
       table_name NOT LIKE '%index%'
       AND
       TABLE_SCHEMA = 'sc_khb_srv'
 ORDER BY 1;

-- 테이블 생성
 ---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_batch_hstry => 63477 ms
CREATE TABLE sc_khb_srv.tb_atlfsl_batch_hstry (
  atlfsl_batch_hstry_pk sc_khb_srv.pk_n18 NOT NULL
, cntnts_no sc_khb_srv.no_n15
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
, hstry_se_cd sc_khb_srv.cd_v20
, rslt_cd sc_khb_srv.cd_v20
, job_dt sc_khb_srv.dt
, err_cn sc_khb_srv.cn_nvmax
);

alter table sc_khb_srv.tb_atlfsl_batch_hstry add constraint pk_tb_atlfsl_batch_hstry primary key(atlfsl_batch_hstry_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_bsc_info => 63477 ms
CREATE TABLE sc_khb_srv.tb_atlfsl_bsc_info (
  atlfsl_bsc_info_pk sc_khb_srv.pk_n18 NOT NULL
, asoc_atlfsl_no sc_khb_srv.no_n15
, asoc_app_intrlck_no sc_khb_srv.no_n15
, lrea_office_info_pk sc_khb_srv.pk_n18
, ctpv_cd_pk sc_khb_srv.pk_n18
, sgg_cd_pk sc_khb_srv.pk_n18
, emd_li_cd_pk sc_khb_srv.pk_n18
, hsmp_info_pk sc_khb_srv.pk_n18
, hsmp_dtl_info_pk sc_khb_srv.pk_n18
, atlfsl_ty_cd sc_khb_srv.cd_v20
, atlfsl_dtl_ty_cd sc_khb_srv.cd_v20
, atlfsl_knd_cd sc_khb_srv.cd_v20
, stdg_dong_cd sc_khb_srv.cd_v20
, stdg_cd sc_khb_srv.cd_v20
, stdg_innb sc_khb_srv.innb_v20
, dong_innb sc_khb_srv.innb_v20
, mno sc_khb_srv.mno_n4
, sno sc_khb_srv.sno_n4
, aptcmpl_nm sc_khb_srv.nm_nv500
, ho_nm sc_khb_srv.nm_nv500
, atlfsl_crdnt geometry
, atlfsl_lot sc_khb_srv.lot_d13_10
, atlfsl_lat sc_khb_srv.lat_d12_10
, atlfsl_trsm_dt sc_khb_srv.dt
, bldg_aptcmpl_indct_yn sc_khb_srv.yn_c1
, pyeong_indct_yn sc_khb_srv.yn_c1
, vr_exst_yn sc_khb_srv.yn_c1
, img_exst_yn sc_khb_srv.yn_c1
, thema_cd_list sc_khb_srv.list_nv1000
, pic_no sc_khb_srv.no_n15
, pic_nm sc_khb_srv.nm_nv500
, pic_telno sc_khb_srv.telno_v30
, dtl_scrn_prsl_cnt sc_khb_srv.cnt_n15
, prvuse_area sc_khb_srv.area_d19_9
, sply_area sc_khb_srv.area_d19_9
, plot_area sc_khb_srv.area_d19_9
, arch_area sc_khb_srv.area_d19_9
, room_cnt sc_khb_srv.cnt_n15
, toilet_cnt sc_khb_srv.cnt_n15
, atlfsl_inq_cnt sc_khb_srv.cnt_n15
, flr_expsr_mthd_cd sc_khb_srv.cd_v20
, now_flr_expsr_mthd_cd sc_khb_srv.cd_v20
, flr_cnt sc_khb_srv.cnt_n15
, top_flr_cnt sc_khb_srv.cnt_n15
, grnd_flr_cnt sc_khb_srv.cnt_n15
, udgd_flr_cnt sc_khb_srv.cnt_n15
, stairs_stle_cd sc_khb_srv.cd_v20
, drc_cd sc_khb_srv.cd_v20
, blcn_cd sc_khb_srv.cd_v20
, pstn_expln_cn sc_khb_srv.cn_nvmax
, parkng_psblty_yn sc_khb_srv.yn_c1
, parkng_cnt sc_khb_srv.cnt_n15
, cmcn_day sc_khb_srv.day_nv100
, financ_amt sc_khb_srv.amt_n18
, use_yn sc_khb_srv.yn_c1
, clustr_info_stts_cd sc_khb_srv.cd_v20
, push_stts_cd sc_khb_srv.cd_v20
, reg_dt sc_khb_srv.dt
, mdfcn_dt sc_khb_srv.dt
, rcmdtn_yn sc_khb_srv.yn_c1
, auc_yn sc_khb_srv.yn_c1
, atlfsl_stts_cd sc_khb_srv.cd_v20
, atlfsl_crdnt_tmp sc_khb_srv.crdnt_v500
);

--BULK INSERT sc_khb_srv.tb_atlfsl_bsc_info
--       FROM 'D:\migra_data\product_info.txt'
--       WITH (
--             CODEPAGE = '65001',
--             FIELDTERMINATOR = '||',
--             ROWTERMINATOR = '0x0a'
--);

bulk insert sc_khb_srv.tb_atlfsl_bsc_info
from 'D:\migra_data\product_info_new.txt'
with (
    codepage = '65001'
  , fieldterminator = '||'
  , rowterminator = '0x0a'
);

alter table sc_khb_srv.tb_atlfsl_bsc_info add constraint pk_tb_atlfsl_bsc_info primary key(atlfsl_bsc_info_pk);

update sc_khb_srv.tb_atlfsl_bsc_info set atlfsl_crdnt = geometry::STPointFromText(atlfsl_crdnt_tmp, 4326) WHERE atlfsl_crdnt_tmp NOT LIKE '%null%' AND atlfsl_crdnt_tmp NOT LIKE '%0.0%';

alter table sc_khb_srv.tb_atlfsl_bsc_info drop column atlfsl_crdnt_tmp;

SET STATISTICS io OFF;




---------------------------------------------------------------------------------------------------
-- 좌표 데이터 삽입할 테이블
CREATE TABLE sc_khb_srv.test(
    code varchar(500)
   ,crdnt varchar(500)
);


BULK INSERT sc_khb_srv.test
       FROM 'D:\migra_data\crdnt.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_cfr_fclt_info => 15672 ms
CREATE TABLE sc_khb_srv.tb_atlfsl_cfr_fclt_info (
  atlfsl_cfr_fclt_info_pk sc_khb_srv.pk_n18 NOT NULL
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
, heat_mthd_cd_list sc_khb_srv.list_nv1000
, heat_fuel_cd_list sc_khb_srv.list_nv1000
, arclng_fclt_cd_list sc_khb_srv.list_nv1000
, lvlh_fclt_cd_list sc_khb_srv.list_nv1000
, scrty_fclt_cd_list sc_khb_srv.list_nv1000
, etc_fclt_cd_list sc_khb_srv.list_nv1000
, arclng_mthd_cd_list sc_khb_srv.list_nv1000
, reg_dt sc_khb_srv.dt
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_atlfsl_cfr_fclt_info
       FROM 'D:\migra_data\facilities_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_atlfsl_cfr_fclt_info add constraint pk_tb_atlfsl_cfr_fclt_info primary key(atlfsl_cfr_fclt_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_cmrc_dtl_info => 3902 ms
CREATE TABLE sc_khb_srv.tb_atlfsl_cmrc_dtl_info (
  atlfsl_cmrc_dtl_info_pk sc_khb_srv.pk_n18 NOT NULL
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
, atlfsl_ty_cd sc_khb_srv.cd_v20
, stdg_cd sc_khb_srv.cd_v20
, prvuse_area sc_khb_srv.area_d19_9
, flr_cnt sc_khb_srv.cnt_n15
, top_flr_cnt sc_khb_srv.cnt_n15
, room_cnt sc_khb_srv.cnt_n15
, toilet_cnt sc_khb_srv.cnt_n15
, cmcn_day sc_khb_srv.day_nv100
, drc_cd sc_khb_srv.cd_v20
, pstn_expln_cn sc_khb_srv.cn_nv4000
, sply_area sc_khb_srv.area_d19_9
, parkng_psblty_yn sc_khb_srv.yn_c1
, arch_area sc_khb_srv.area_d19_9
, plot_area sc_khb_srv.area_d19_9
, udgd_flr_cnt sc_khb_srv.cnt_n15
, grnd_flr_cnt sc_khb_srv.cnt_n15
, reg_dt sc_khb_srv.dt
, mdfcn_dt sc_khb_srv.dt
, use_yn sc_khb_srv.yn_c1
);

BULK INSERT sc_khb_srv.tb_atlfsl_cmrc_dtl_info
       FROM 'D:\migra_data\article_type_d_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_atlfsl_cmrc_dtl_info add constraint pk_tb_atlfsl_cmrc_dtl_info primary key(atlfsl_cmrc_dtl_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_dlng_info => 31640 ms
CREATE TABLE sc_khb_srv.tb_atlfsl_dlng_info (
  atlfsl_dlng_info_pk sc_khb_srv.pk_n18 NOT NULL
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
, dlng_se_cd sc_khb_srv.cd_v20
, trde_amt sc_khb_srv.amt_n18
, lfsts_amt sc_khb_srv.amt_n18
, mtht_amt sc_khb_srv.amt_n18
, financ_amt sc_khb_srv.amt_n18
, now_lfsts_amt sc_khb_srv.amt_n18
, now_mtht_amt sc_khb_srv.amt_n18
, premium sc_khb_srv.premium_n18
, reg_dt sc_khb_srv.dt
, mdfcn_dt sc_khb_srv.dt
, mng_amt sc_khb_srv.amt_n18
);

BULK INSERT sc_khb_srv.tb_atlfsl_dlng_info
       FROM 'D:\migra_data\trade_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_atlfsl_dlng_info add constraint pk_tb_atlfsl_dlng_info primary key(atlfsl_dlng_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_etc_dtl_info => 7208 ms
CREATE TABLE sc_khb_srv.tb_atlfsl_etc_dtl_info (
  atlfsl_etc_dtl_info_pk sc_khb_srv.pk_n18 NOT NULL
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
, atlfsl_ty_cd sc_khb_srv.cd_v20
, stdg_cd sc_khb_srv.cd_v20
, prvuse_area sc_khb_srv.area_d19_9
, flr_cnt sc_khb_srv.cnt_n15
, top_flr_cnt sc_khb_srv.cnt_n15
, room_cnt sc_khb_srv.cnt_n15
, cmcn_day sc_khb_srv.day_nv100
, drc_cd sc_khb_srv.cd_v20
, pstn_expln_cn sc_khb_srv.cn_nv4000
, sply_area sc_khb_srv.area_d19_9
, parkng_psblty_yn sc_khb_srv.yn_c1
, arch_area sc_khb_srv.area_d19_9
, plot_area sc_khb_srv.area_d19_9
, udgd_flr_cnt sc_khb_srv.cnt_n15
, grnd_flr_cnt sc_khb_srv.cnt_n15
, reg_dt sc_khb_srv.dt
, mdfcn_dt sc_khb_srv.dt
, use_yn sc_khb_srv.yn_c1
);

BULK INSERT sc_khb_srv.tb_atlfsl_etc_dtl_info
       FROM 'D:\migra_data\article_type_ef_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_atlfsl_etc_dtl_info add constraint pk_tb_atlfsl_etc_dtl_info primary key(atlfsl_etc_dtl_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_etc_info => 71645 ms
CREATE TABLE sc_khb_srv.tb_atlfsl_etc_info (
  atlfsl_etc_info_pk sc_khb_srv.pk_n18 NOT NULL
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
, mvn_se_cd sc_khb_srv.cd_v20
, mvn_psblty_wthn_month_cnt sc_khb_srv.cnt_n15
, mvn_psblty_aftr_month_cnt sc_khb_srv.cnt_n15
, mvn_cnsltn_psblty_yn sc_khb_srv.yn_c1
, atlfsl_sfe_expln_cn sc_khb_srv.cn_nvmax
, entry_road_yn sc_khb_srv.yn_c1
, atlfsl_expln_cn sc_khb_srv.cn_nvmax
, reg_dt sc_khb_srv.dt
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_atlfsl_etc_info
       FROM 'D:\migra_data\etc_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_atlfsl_etc_info add constraint pk_tb_atlfsl_etc_info primary key(atlfsl_etc_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_img_info => 92842 ms
CREATE TABLE sc_khb_srv.tb_atlfsl_img_info (
  atlfsl_img_info_pk sc_khb_srv.pk_n18 NOT NULL
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18 NOT NULL
, img_sn sc_khb_srv.sn_v200
, img_ty_cd sc_khb_srv.cd_v20
, img_file_nm sc_khb_srv.nm_nv500
, img_expln_cn sc_khb_srv.cn_nv4000
, img_url sc_khb_srv.url_nv4000
, thumb_img_url sc_khb_srv.url_nv4000
, orgnl_img_url sc_khb_srv.url_nv4000
, img_sort_ordr sc_khb_srv.ordr_n5
);

BULK INSERT sc_khb_srv.tb_atlfsl_img_info
       FROM 'D:\migra_data\product_img_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_atlfsl_img_info add constraint pk_tb_atlfsl_img_info primary key(atlfsl_img_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_inqry_info
CREATE TABLE sc_khb_srv.tb_atlfsl_inqry_info (
  atlfsl_inqry_info_pk sc_khb_srv.pk_n18 NOT NULL
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
, user_no_pk sc_khb_srv.pk_n18
, inqry_cn sc_khb_srv.cn_nv4000
, del_yn sc_khb_srv.yn_c1
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_atlfsl_inqry_info add constraint pk_tb_atlfsl_inqry_info primary key(atlfsl_inqry_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
-- tb_atlfsl_img_info => 92842 ms
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_land_usg_info => 16853 ms
CREATE TABLE sc_khb_srv.tb_atlfsl_land_usg_info (
  atlfsl_land_usg_info_pk sc_khb_srv.pk_n18 NOT NULL
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
, usg_rgn_se_cd sc_khb_srv.cd_v20
, trit_utztn_yn sc_khb_srv.yn_c1
, ctypln_yn sc_khb_srv.yn_c1
, arch_prmsn_yn sc_khb_srv.yn_c1
, land_dlng_prmsn_yn sc_khb_srv.yn_c1
, reg_dt sc_khb_srv.dt
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_atlfsl_land_usg_info
       FROM 'D:\migra_data\grnd_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_atlfsl_land_usg_info add constraint pk_tb_atlfsl_land_usg_info primary key(atlfsl_land_usg_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_reside_gnrl_dtl_info => 1898 ms
CREATE TABLE sc_khb_srv.tb_atlfsl_reside_gnrl_dtl_info (
  atlfsl_reside_gnrl_dtl_info_pk sc_khb_srv.pk_n18 NOT NULL
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
, atlfsl_ty_cd sc_khb_srv.cd_v20
, stdg_cd sc_khb_srv.cd_v20
, prvuse_area sc_khb_srv.area_d19_9
, flr_cnt sc_khb_srv.cnt_n15
, top_flr_cnt sc_khb_srv.cnt_n15
, room_cnt sc_khb_srv.cnt_n15
, toilet_cnt sc_khb_srv.cnt_n15
, cmcn_day sc_khb_srv.day_nv100
, drc_cd sc_khb_srv.cd_v20
, pstn_expln_cn sc_khb_srv.cn_nv4000
, sply_area sc_khb_srv.area_d19_9
, parkng_psblty_yn sc_khb_srv.yn_c1
, arch_area sc_khb_srv.area_d19_9
, plot_area sc_khb_srv.area_d19_9
, udgd_flr_cnt sc_khb_srv.cnt_n15
, grnd_flr_cnt sc_khb_srv.cnt_n15
, flr_expsr_mthd_cd sc_khb_srv.cd_v20
, now_flr_expsr_mthd_cd sc_khb_srv.cd_v20
, stairs_stle_cd sc_khb_srv.cd_v20
, reg_dt sc_khb_srv.dt
, mdfcn_dt sc_khb_srv.dt
, use_yn sc_khb_srv.yn_c1
);

BULK INSERT sc_khb_srv.tb_atlfsl_reside_gnrl_dtl_info
       FROM 'D:\migra_data\article_type_c_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_atlfsl_reside_gnrl_dtl_info add constraint pk_tb_atlfsl_reside_gnrl_dtl_info primary key(atlfsl_reside_gnrl_dtl_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_reside_set_dtl_info => 25549 ms
CREATE TABLE sc_khb_srv.tb_atlfsl_reside_set_dtl_info (
  atlfsl_reside_set_dtl_info_pk sc_khb_srv.pk_n18 NOT NULL
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
, atlfsl_ty_cd sc_khb_srv.cd_v20
, stdg_cd sc_khb_srv.cd_v20
, hsmp_info_pk sc_khb_srv.pk_n18
, prvuse_area sc_khb_srv.area_d19_9
, flr_cnt sc_khb_srv.cnt_n15
, top_flr_cnt sc_khb_srv.cnt_n15
, room_cnt sc_khb_srv.cnt_n15
, toilet_cnt sc_khb_srv.cnt_n15
, stairs_stle_cd sc_khb_srv.cd_v20
, cmcn_day sc_khb_srv.day_nv100
, drc_cd sc_khb_srv.cd_v20
, financ_amt sc_khb_srv.amt_n18
, aptcmpl_nm sc_khb_srv.nm_nv500
, ho_nm sc_khb_srv.nm_nv500
, flr_expsr_mthd_cd sc_khb_srv.cd_v20
, now_flr_expsr_mthd_cd sc_khb_srv.cd_v20
, blcn_cd sc_khb_srv.cd_v20
, reg_dt sc_khb_srv.dt
, mdfcn_dt sc_khb_srv.dt
, use_yn sc_khb_srv.yn_c1
);

BULK INSERT sc_khb_srv.tb_atlfsl_reside_set_dtl_info
       FROM 'D:\migra_data\article_type_ab_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_atlfsl_reside_set_dtl_info add constraint pk_tb_atlfsl_reside_set_dtl_info primary key(atlfsl_reside_set_dtl_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_author
CREATE TABLE sc_khb_srv.tb_com_author (
  author_no_pk sc_khb_srv.pk_n18 NOT NULL
, parnts_author_no_pk sc_khb_srv.pk_n18
, author_nm sc_khb_srv.nm_nv500
, rm_cn sc_khb_srv.cn_nv4000
, use_at sc_khb_srv.yn_c1
, valid_pd_begin_dt sc_khb_srv.dt
, valid_pd_end_dt sc_khb_srv.dt
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
, orgnzt_manage_at sc_khb_srv.yn_c1
);

alter table sc_khb_srv.tb_com_author add constraint pk_tb_com_author primary key(author_no_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_banner_info => 61 ms
CREATE TABLE sc_khb_srv.tb_com_banner_info (
  banner_info_pk sc_khb_srv.pk_n18 NOT NULL
, banner_ty_cd sc_khb_srv.cd_v20
, banner_se_cd sc_khb_srv.cd_v20
, thumb_img_url sc_khb_srv.url_nv4000
, banner_ordr sc_khb_srv.ordr_n5
, use_yn sc_khb_srv.yn_c1
, url sc_khb_srv.url_nv4000
, img_url sc_khb_srv.url_nv4000
, dtl_cn sc_khb_srv.cn_nvmax
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_com_banner_info
       FROM 'D:\migra_data\banner_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_com_banner_info add constraint pk_tb_com_banner_info primary key(banner_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_bbs => 405
CREATE TABLE sc_khb_srv.tb_com_bbs (
  bbs_pk sc_khb_srv.pk_n18 NOT NULL
, bbs_se_cd sc_khb_srv.cd_v20
, ttl_nm sc_khb_srv.nm_nv500
, cn sc_khb_srv.cn_nvmax
, del_yn sc_khb_srv.yn_c1
, rgtr_nm sc_khb_srv.nm_nv500
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_com_bbs
       FROM 'D:\migra_data\board_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_com_bbs add constraint pk_tb_com_bbs primary key(bbs_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_bbs_cmnt => 38 ms
CREATE TABLE sc_khb_srv.tb_com_bbs_cmnt (
  bbs_cmnt_pk sc_khb_srv.pk_n18 NOT NULL
, bbs_pk sc_khb_srv.pk_n18
, cn sc_khb_srv.cn_nvmax
, del_yn sc_khb_srv.yn_c1
, rgtr_nm sc_khb_srv.nm_nv500
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_com_bbs_cmnt
       FROM 'D:\migra_data\board_comment.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_com_bbs_cmnt add constraint pk_tb_com_bbs_cmnt primary key(bbs_cmnt_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_code
CREATE TABLE sc_khb_srv.tb_com_code (
  code_pk sc_khb_srv.pk_n18 NOT NULL
, parnts_code_pk sc_khb_srv.pk_n18
, code sc_khb_srv.cd_v20 NOT NULL
, code_nm sc_khb_srv.nm_nv500 NOT NULL
, sort_ordr sc_khb_srv.ordr_n5
, use_at sc_khb_srv.yn_c1
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
, rm_cn sc_khb_srv.cn_nv4000
, parent_code sc_khb_srv.cd_v20
, synchrn_pnttm_vl sc_khb_srv.vl_v100
);

BULK INSERT sc_khb_srv.tb_com_code
       FROM 'D:\migra_data\com_code_dea.txt'
       WITH (
            codepage = '65001',
            FIELDTERMINATOR = '||',
            ROWTERMINATOR = '0x0a'
);

BULK INSERT sc_khb_srv.tb_com_code
       FROM 'D:\migra_data\com_code_so.txt'
       WITH (
            codepage = '65001',
            FIELDTERMINATOR = '||',
            ROWTERMINATOR = '0x0a'
);

BULK INSERT sc_khb_srv.tb_com_code
       FROM 'D:\migra_data\mssql_com_code.txt'
       WITH (
            codepage = '65001',
            FIELDTERMINATOR = '||',
            ROWTERMINATOR = '\n'
);

alter table sc_khb_srv.tb_com_code add constraint pk_tb_com_code primary key(code_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_crtfc_tmpr
CREATE TABLE sc_khb_srv.tb_com_crtfc_tmpr (
  crtfc_pk sc_khb_srv.pk_n18 NOT NULL
, crtfc_se_code sc_khb_srv.cd_v20
, soc_lgn_ty_cd sc_khb_srv.cd_v20
, moblphon_no sc_khb_srv.no_v200
, moblphon_crtfc_sn sc_khb_srv.sn_v200
, moblphon_crtfc_at sc_khb_srv.yn_c1
, email sc_khb_srv.email_v320
, email_crtfc_sn sc_khb_srv.sn_v200
, email_crtfc_at sc_khb_srv.yn_c1
, sns_crtfc_sn sc_khb_srv.sn_v200
, sns_crtfc_at sc_khb_srv.yn_c1
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_crtfc_tmpr add constraint pk_tb_com_crtfc_tmpr primary key(crtfc_pk);

SET STATISTICS io OFF;
-----------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_ctpv_cd =>  ms
CREATE TABLE sc_khb_srv.tb_com_ctpv_cd (
  ctpv_cd_pk sc_khb_srv.pk_n18 NOT NULL
, ctpv_nm sc_khb_srv.nm_nv500
, ctpv_abbrev_nm sc_khb_srv.nm_nv500
, ctpv_crdnt geometry
, synchrn_pnttm_vl sc_khb_srv.vl_v100
);

bulk insert sc_khb_srv.tb_com_ctpv_cd
from 'D:\migra_data\sido_code.txt'
with (
    codepage = '65001'
  , fieldterminator = '||'
  , rowterminator = '0x0a'
);

alter table sc_khb_srv.tb_com_ctpv_cd add constraint pk_tb_com_ctpv_cd primary key(ctpv_cd_pk);

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

DROP VIEW sc_khb_srv.tb_sggmat;

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_device_info =>  ms
CREATE TABLE sc_khb_srv.tb_com_device_info (
  device_info_pk sc_khb_srv.pk_n18 NOT NULL
, user_no_pk sc_khb_srv.pk_n18
, push_tkn_cn sc_khb_srv.cn_nvmax
, device_id sc_khb_srv.id_nv100
, pltfom_se_cd sc_khb_srv.cd_v20
, del_yn sc_khb_srv.yn_c1
, lgn_dt sc_khb_srv.dt
, refresh_tkn_cn sc_khb_srv.cn_nvmax
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_device_info add constraint pk_tb_com_device_info primary key(device_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_device_ntcn_mapng_info =>  ms
CREATE TABLE sc_khb_srv.tb_com_device_ntcn_mapng_info (
  device_ntcn_mapng_info_pk sc_khb_srv.pk_n18 NOT NULL
, device_info_pk sc_khb_srv.pk_n18
, ntcn_info_pk sc_khb_srv.pk_n18
, trsm_yn sc_khb_srv.yn_c1
, trsm_rslt_cn sc_khb_srv.cn_nvmax
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_device_ntcn_mapng_info add constraint pk_tb_com_device_ntcn_mapng_info primary key(device_ntcn_mapng_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_device_stng_info =>  ms
CREATE TABLE sc_khb_srv.tb_com_device_stng_info (
  device_stng_info_pk sc_khb_srv.pk_n18 NOT NULL
, device_info_pk sc_khb_srv.pk_n18
, push_yn sc_khb_srv.yn_c1
, dstrbnc_prhibt_bgng_hm sc_khb_srv.hm_c4
, dstrbnc_prhibt_end_hm sc_khb_srv.hm_c4
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
, push_meta_info_pk sc_khb_srv.pk_n18
);

alter table sc_khb_srv.tb_com_device_stng_info add constraint pk_tb_com_device_stng_info primary key(device_stng_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_emd_li_cd => 428 ms
CREATE TABLE sc_khb_srv.tb_com_emd_li_cd (
  emd_li_cd_pk sc_khb_srv.pk_n18 NOT NULL
, ctpv_cd_pk sc_khb_srv.pk_n18 NOT NULL
, sgg_cd_pk sc_khb_srv.pk_n18 NOT NULL
, emd_li_nm sc_khb_srv.nm_nv500
, all_emd_li_nm sc_khb_srv.nm_nv500
, emd_li_crdnt geometry
, stdg_dong_se_cd sc_khb_srv.cd_v20
, stdg_dong_cd sc_khb_srv.cd_v20
, synchrn_pnttm_vl sc_khb_srv.vl_v100
, emd_li_crdnt_tmp sc_khb_srv.crdnt_v500
);

bulk insert sc_khb_srv.tb_com_emd_li_cd
from 'D:\migra_data\dong_code.txt'
with (
    codepage = '65001'
  , fieldterminator = '||'
  , rowterminator = '0x0a'
);

alter table sc_khb_srv.tb_com_emd_li_cd add constraint pk_tb_com_emd_li_cd primary key(emd_li_cd_pk);

update sc_khb_srv.tb_com_emd_li_cd set emd_li_crdnt = geometry::STPointFromText(emd_li_crdnt_tmp, 4326) WHERE emd_li_crdnt_tmp NOT LIKE '%null%' AND emd_li_crdnt_tmp NOT LIKE '%0.0%';

alter table sc_khb_srv.tb_com_emd_li_cd drop column emd_li_crdnt_tmp;

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_error_log
CREATE TABLE sc_khb_srv.tb_com_error_log (
  error_log_pk sc_khb_srv.pk_n18 NOT NULL
, user_id sc_khb_srv.id_nv100
, url sc_khb_srv.url_nv4000
, mthd_nm sc_khb_srv.nm_nv500
, paramtr_cn sc_khb_srv.cn_nv4000
, error_cn sc_khb_srv.cn_nv4000
, requst_ip_adres sc_khb_srv.addr_nv200
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_error_log add constraint pk_tb_com_error_log primary key(error_log_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------\
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_faq
CREATE TABLE sc_khb_srv.tb_com_faq (
  faq_no_pk sc_khb_srv.pk_n18 NOT NULL
, qestn_cn sc_khb_srv.cn_nv4000
, answer_cn sc_khb_srv.cn_nv4000
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
, ctgry_code sc_khb_srv.cd_v20
, svc_se_code sc_khb_srv.cd_v20
);

alter table sc_khb_srv.tb_com_faq add constraint pk_tb_com_faq primary key(faq_no_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_file
CREATE TABLE sc_khb_srv.tb_com_file (
  file_no_pk sc_khb_srv.pk_n18 NOT NULL
, orignl_nm sc_khb_srv.nm_nv500
, nm sc_khb_srv.nm_nv500
, cours sc_khb_srv.cours_v100
, file_size sc_khb_srv.size_v20
, dwld_co sc_khb_srv.co_n15
, extsn_nm sc_khb_srv.nm_nv500
, delete_at sc_khb_srv.yn_c1
, regist_dt sc_khb_srv.dt default (getdate())
, regist_id sc_khb_srv.id_nv100
, delete_dt sc_khb_srv.dt
, delete_id sc_khb_srv.id_nv100
);

alter table sc_khb_srv.tb_com_file add constraint pk_tb_com_file primary key(file_no_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
-- tb_com_file_mapng
CREATE TABLE sc_khb_srv.tb_com_file_mapng (
  file_no_pk sc_khb_srv.pk_n18 NOT NULL
, recsroom_no_pk sc_khb_srv.pk_n18
, user_no_pk sc_khb_srv.pk_n18
, event_no_pk sc_khb_srv.pk_n18
, othbc_dta_no_pk sc_khb_srv.pk_n18
);

alter table sc_khb_srv.tb_com_file_mapng add constraint pk_tb_com_file_mapng primary key(file_no_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_group
CREATE TABLE sc_khb_srv.tb_com_group (
  group_no_pk sc_khb_srv.pk_n18 NOT NULL
, parnts_group_no_pk sc_khb_srv.pk_n18
, group_nm sc_khb_srv.nm_nv500
, use_at sc_khb_srv.yn_c1
, rm_cn sc_khb_srv.cn_nv4000
, valid_pd_begin_dt sc_khb_srv.dt
, valid_pd_end_dt sc_khb_srv.dt
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_group add constraint pk_tb_com_group primary key(group_no_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_group_author
CREATE TABLE sc_khb_srv.tb_com_group_author (
  com_group_author_pk sc_khb_srv.pk_n18 NOT NULL
, group_no_pk sc_khb_srv.pk_n18 NOT NULL
, author_no_pk sc_khb_srv.pk_n18 NOT NULL
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_group_author add constraint pk_tb_com_group_author primary key(com_group_author_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_gtwy_svc
CREATE TABLE sc_khb_srv.tb_com_gtwy_svc (
  gtwy_svc_pk sc_khb_srv.pk_n18 NOT NULL
, gtwy_nm sc_khb_srv.nm_nv500
, gtwy_url sc_khb_srv.url_nv4000
, rm_cn sc_khb_srv.cn_nv4000
, use_at sc_khb_srv.yn_c1
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
, gtwy_method_nm sc_khb_srv.nm_nv500
);

alter table sc_khb_srv.tb_com_gtwy_svc add constraint pk_tb_com_gtwy_svc primary key(gtwy_svc_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_gtwy_svc_author
CREATE TABLE sc_khb_srv.tb_com_gtwy_svc_author (
  com_gtwy_svc_author_pk sc_khb_srv.pk_n18 NOT NULL
, author_no_pk sc_khb_srv.pk_n18 NOT NULL
, gtwy_svc_pk sc_khb_srv.pk_n18 NOT NULL
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_gtwy_svc_author add constraint pk_tb_com_gtwy_svc_author primary key(com_gtwy_svc_author_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_job_schdl_hstry => ms
CREATE TABLE sc_khb_srv.tb_com_job_schdl_hstry (
  job_schdl_hstry_pk sc_khb_srv.pk_n18 NOT NULL
, job_schdl_info_pk sc_khb_srv.pk_n18
, link_tbl_pk sc_khb_srv.pk_n18
, prgrs_rslt_cd sc_khb_srv.cd_v20
, err_cn sc_khb_srv.cn_nvmax
, excn_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_job_schdl_hstry add constraint pk_tb_com_job_schdl_hstry primary key(job_schdl_hstry_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_job_schdl_info => 33 ms
CREATE TABLE sc_khb_srv.tb_com_job_schdl_info (
  job_schdl_info_pk sc_khb_srv.pk_n18 NOT NULL
, job_se_cd sc_khb_srv.cd_v20
, job_nm sc_khb_srv.nm_nv500
, job_cycle sc_khb_srv.cycle_v20
, last_excn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_com_job_schdl_info
       FROM 'D:\migra_data\cron_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_com_job_schdl_info add constraint pk_tb_com_job_schdl_info primary key(job_schdl_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_login_hist
CREATE TABLE sc_khb_srv.tb_com_login_hist (
  login_hist_pk sc_khb_srv.pk_n18 NOT NULL
, user_id sc_khb_srv.id_nv100
, login_ip_adres sc_khb_srv.addr_nv200
, error_at sc_khb_srv.yn_c1
, error_code sc_khb_srv.cd_v20
, error_cn sc_khb_srv.cn_nv4000
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_login_hist add constraint pk_tb_com_login_hist primary key(login_hist_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_menu
CREATE TABLE sc_khb_srv.tb_com_menu (
  menu_no_pk sc_khb_srv.pk_n18 NOT NULL
, parnts_menu_no_pk sc_khb_srv.pk_n18
, menu_nm sc_khb_srv.nm_nv500
, sort_ordr sc_khb_srv.ordr_n5
, use_at sc_khb_srv.yn_c1
, rm_cn sc_khb_srv.cn_nv4000
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
, scrin_no_pk sc_khb_srv.pk_n18
, orgnzt_manage_at sc_khb_srv.yn_c1
, aplctn_code sc_khb_srv.cd_v20
);

alter table sc_khb_srv.tb_com_menu add constraint pk_tb_com_menu primary key(menu_no_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_menu_author
CREATE TABLE sc_khb_srv.tb_com_menu_author (
  com_menu_author_pk sc_khb_srv.pk_n18 NOT NULL
, author_no_pk sc_khb_srv.pk_n18 NOT NULL
, menu_no_pk sc_khb_srv.pk_n18 NOT NULL
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_menu_author add constraint pk_tb_com_menu_author primary key(com_menu_author_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_notice
CREATE TABLE sc_khb_srv.tb_com_notice (
  notice_no_pk sc_khb_srv.pk_n18 NOT NULL
, sj_nm sc_khb_srv.nm_nv500
, inqire_co sc_khb_srv.co_n15
, rm_cn sc_khb_srv.cn_nv4000
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
, notice_at sc_khb_srv.yn_c1
, notice_se_code sc_khb_srv.cd_v20
, svc_se_code sc_khb_srv.cd_v20
);

alter table sc_khb_srv.tb_com_notice add constraint pk_tb_com_notice primary key(notice_no_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_ntcn_info
CREATE TABLE sc_khb_srv.tb_com_ntcn_info (
  ntcn_info_pk sc_khb_srv.pk_n18 NOT NULL
, push_meta_info_pk sc_khb_srv.pk_n18
, ttl_nm sc_khb_srv.nm_nv500
, cn sc_khb_srv.cn_nvmax
, paramtr_cn sc_khb_srv.cn_nvmax
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_ntcn_info add constraint pk_tb_com_ntcn_info primary key(ntcn_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_push_meta_info
CREATE TABLE sc_khb_srv.tb_com_push_meta_info (
  push_meta_info_pk sc_khb_srv.pk_n18 NOT NULL
, push_nm sc_khb_srv.nm_nv500
, trsm_se_cd sc_khb_srv.cd_v20
, tpc_nm sc_khb_srv.nm_nv500
, user_se_cd sc_khb_srv.cd_v20
, retransm_yn sc_khb_srv.yn_c1
, retransm_cycle sc_khb_srv.cycle_v20
, use_yn sc_khb_srv.yn_c1
, dstrbnc_prhibt_stng_yn sc_khb_srv.yn_c1
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
, push_yn sc_khb_srv.yn_c1
);

alter table sc_khb_srv.tb_com_push_meta_info add constraint pk_tb_com_push_meta_info primary key(push_meta_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_qna
CREATE TABLE sc_khb_srv.tb_com_qna (
  qna_no_pk sc_khb_srv.pk_n18 NOT NULL
, parnts_qna_no_pk sc_khb_srv.pk_n18
, sj_nm sc_khb_srv.nm_nv500
, rm_cn sc_khb_srv.cn_nv4000
, secret_no_at sc_khb_srv.yn_c1
, secret_no sc_khb_srv.no_n15
, inqire_co sc_khb_srv.co_n15
, answer_dp_no sc_khb_srv.no_n15
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_qna add constraint pk_tb_com_qna primary key(qna_no_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_recsroom
CREATE TABLE sc_khb_srv.tb_com_recsroom (
  recsroom_no_pk sc_khb_srv.pk_n18 NOT NULL
, sj_nm sc_khb_srv.nm_nv500
, rm_cn sc_khb_srv.cn_nv4000
, inqire_co sc_khb_srv.co_n15
, file_use_at sc_khb_srv.yn_c1
, regist_dt sc_khb_srv.dt default (getdate())
, regist_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
, updt_id sc_khb_srv.id_nv100
);

alter table sc_khb_srv.tb_com_recsroom add constraint pk_tb_com_recsroom primary key(recsroom_no_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_rss_info
CREATE TABLE sc_khb_srv.tb_com_rss_info (
  rss_info_pk sc_khb_srv.pk_n18 NOT NULL
, rss_se_cd sc_khb_srv.cd_v20
, ttl_nm sc_khb_srv.nm_nv500
, cn sc_khb_srv.cn_nvmax
, hmpg_url sc_khb_srv.url_nv4000
, thumb_url sc_khb_srv.url_nv4000
, hashtag_list sc_khb_srv.list_nv1000
, pstg_day sc_khb_srv.day_nv100
, inq_cnt sc_khb_srv.cnt_n15
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
, wrtr_nm sc_khb_srv.nm_nv500
);

alter table sc_khb_srv.tb_com_rss_info add constraint pk_tb_com_rss_info primary key(rss_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_scrin
CREATE TABLE sc_khb_srv.tb_com_scrin (
  scrin_no_pk sc_khb_srv.pk_n18 NOT NULL
, scrin_nm sc_khb_srv.nm_nv500
, scrin_url sc_khb_srv.url_nv4000
, rm_cn sc_khb_srv.cn_nv4000
, use_at sc_khb_srv.yn_c1
, creat_author_at sc_khb_srv.yn_c1
, inqire_author_at sc_khb_srv.yn_c1
, updt_author_at sc_khb_srv.yn_c1
, delete_author_at sc_khb_srv.yn_c1
, excel_author_at sc_khb_srv.yn_c1
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_scrin add constraint pk_tb_com_scrin primary key(scrin_no_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_scrin_author
CREATE TABLE sc_khb_srv.tb_com_scrin_author (
  com_scrin_author_pk sc_khb_srv.pk_n18 NOT NULL
, author_no_pk sc_khb_srv.pk_n18 NOT NULL
, scrin_no_pk sc_khb_srv.pk_n18 NOT NULL
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_scrin_author add constraint pk_tb_com_scrin_author primary key(com_scrin_author_pk);

---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_sgg_cd => 40 ms
CREATE TABLE sc_khb_srv.tb_com_sgg_cd (
  sgg_cd_pk sc_khb_srv.pk_n18 NOT NULL
, ctpv_cd_pk sc_khb_srv.pk_n18 NOT NULL
, sgg_nm sc_khb_srv.nm_nv500
, sgg_crdnt geometry
, stdg_dong_se_cd sc_khb_srv.cd_v20
, synchrn_pnttm_vl sc_khb_srv.vl_v100
);

BULK INSERT sc_khb_srv.tb_com_sgg_cd
       FROM 'D:\migra_data\gugun_code.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_com_sgg_cd add constraint pk_tb_com_sgg_cd primary key(sgg_cd_pk);

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

DROP VIEW sc_khb_srv.tb_sdmat;

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_stplat_hist
CREATE TABLE sc_khb_srv.tb_com_stplat_hist (
  com_stplat_hist_pk sc_khb_srv.pk_n18 NOT NULL
, com_stplat_info_pk sc_khb_srv.pk_n18 NOT NULL
, stplat_se_code sc_khb_srv.cd_v20
, essntl_at sc_khb_srv.yn_c1
, file_cours_nm sc_khb_srv.nm_nv500
, stplat_begin_dt sc_khb_srv.dt
, stplat_end_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_stplat_hist add constraint pk_tb_com_stplat_hist primary key(com_stplat_hist_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- 
CREATE TABLE sc_khb_srv.tb_com_stplat_info (
  com_stplat_info_pk sc_khb_srv.pk_n18 NOT NULL
, svc_pk sc_khb_srv.pk_n18 NOT NULL
, stplat_se_code sc_khb_srv.cd_v20
, essntl_at sc_khb_srv.yn_c1
, file_cours_nm sc_khb_srv.nm_nv500
, use_at sc_khb_srv.yn_c1
, register_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updusr_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
, chnnl_id sc_khb_srv.id_nv100
);

alter table sc_khb_srv.tb_com_stplat_info add constraint pk_tb_com_stplat_info primary key(com_stplat_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_stplat_mapng
CREATE TABLE sc_khb_srv.tb_com_stplat_mapng (
  com_stplat_mapng_pk sc_khb_srv.pk_n18 NOT NULL
, com_stplat_info_pk sc_khb_srv.pk_n18
, user_no_pk sc_khb_srv.pk_n18
, stplat_agre_dt sc_khb_srv.dt
, stplat_reject_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_stplat_mapng add constraint pk_tb_com_stplat_mapng primary key(com_stplat_mapng_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_svc_ip_manage
CREATE TABLE sc_khb_srv.tb_com_svc_ip_manage (
  ip_manage_pk sc_khb_srv.pk_n18 NOT NULL
, author_no_pk sc_khb_srv.pk_n18
, ip_adres sc_khb_srv.addr_nv200
, ip_use_instt_nm sc_khb_srv.nm_nv500
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_svc_ip_manage add constraint pk_tb_com_svc_ip_manage primary key(ip_manage_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_thema_info => 35 ms
CREATE TABLE sc_khb_srv.tb_com_thema_info (
  thema_info_pk sc_khb_srv.pk_n18 NOT NULL
, thema_cd sc_khb_srv.cd_v20
, thema_cd_nm sc_khb_srv.nm_nv500
, thema_cn sc_khb_srv.cn_nv4000
, img_url sc_khb_srv.url_nv4000
, img_sort_ordr sc_khb_srv.ordr_n5
, use_yn sc_khb_srv.yn_c1
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
, rprs_yn sc_khb_srv.yn_c1
, atlfsl_reg_use_yn sc_khb_srv.yn_c1
);

BULK INSERT sc_khb_srv.tb_com_thema_info
       FROM 'D:\migra_data\theme_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_com_thema_info add constraint pk_tb_com_thema_info primary key(thema_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_user => 1521 + 1160 ms
CREATE TABLE sc_khb_srv.tb_com_user (
  user_no_pk sc_khb_srv.pk_n18 NOT NULL
, parnts_user_no_pk sc_khb_srv.pk_n18
, user_id sc_khb_srv.id_nv100
, user_nm sc_khb_srv.nm_nv500
, password sc_khb_srv.password_v500
, moblphon_no sc_khb_srv.no_v200
, email sc_khb_srv.email_v320
, user_se_code sc_khb_srv.cd_v20
, sbscrb_de sc_khb_srv.de_v10
, password_change_de sc_khb_srv.de_v10
, last_login_dt sc_khb_srv.dt
, last_login_ip sc_khb_srv.ip_v100
, error_co sc_khb_srv.co_n15
, error_dt sc_khb_srv.dt
, use_at sc_khb_srv.yn_c1
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
, refresh_tkn_cn sc_khb_srv.cn_nv4000
, soc_lgn_ty_cd sc_khb_srv.cd_v20
, user_img_url sc_khb_srv.url_nv4000
, lrea_office_nm sc_khb_srv.nm_nv500
, lrea_office_info_pk sc_khb_srv.pk_n18
);

BULK INSERT sc_khb_srv.tb_com_user
       FROM 'D:\migra_data\user_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

BULK INSERT sc_khb_srv.tb_com_user
       FROM 'D:\migra_data\realtor_info_user.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_com_user add constraint pk_tb_com_user primary key(user_no_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_user_author
CREATE TABLE sc_khb_srv.tb_com_user_author (
  user_author_pk sc_khb_srv.pk_n18 NOT NULL
, user_no_pk sc_khb_srv.pk_n18
, author_no_pk sc_khb_srv.pk_n18
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_user_author add constraint pk_tb_com_user_author primary key(user_author_pk);

---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_user_group =>  ms
CREATE TABLE sc_khb_srv.tb_com_user_group (
  com_user_group_pk sc_khb_srv.pk_n18 NOT NULL
, group_no_pk sc_khb_srv.pk_n18 NOT NULL
, user_no_pk sc_khb_srv.pk_n18 NOT NULL
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_com_user_group
       FROM 'D:\migra_data\user_info_user_group.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);
BULK INSERT sc_khb_srv.tb_com_user_group
       FROM 'D:\migra_data\realtor_info_user_group.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_com_user_group add constraint pk_tb_com_user_group primary key(com_user_group_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_user_ntcn_mapng_info =>  ms
CREATE TABLE sc_khb_srv.tb_com_user_ntcn_mapng_info (
  user_ntcn_mapng_info_pk sc_khb_srv.pk_n18 NOT NULL
, user_no_pk sc_khb_srv.pk_n18
, ntcn_info_pk sc_khb_srv.pk_n18
, ntcn_idnty_yn sc_khb_srv.yn_c1
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_com_user_ntcn_mapng_info add constraint pk_tb_com_user_ntcn_mapng_info primary key(user_ntcn_mapng_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_hsmp_dtl_info => 27525 ms
CREATE TABLE sc_khb_srv.tb_hsmp_dtl_info (
  hsmp_dtl_info_pk sc_khb_srv.pk_n18 NOT NULL
, hsmp_info_pk sc_khb_srv.pk_n18 NOT NULL
, sply_area sc_khb_srv.area_d19_9
, sply_area_pyeong sc_khb_srv.pyeong_d19_9
, pyeong_info sc_khb_srv.cn_nv4000
, prvuse_area sc_khb_srv.area_d19_9
, prvuse_area_pyeong sc_khb_srv.pyeong_d19_9
, ctrt_area sc_khb_srv.area_d19_9
, ctrt_area_pyeong sc_khb_srv.pyeong_d19_9
, dtl_lotno sc_khb_srv.lotno_nv100
, room_cnt sc_khb_srv.cnt_n15
, btr_cnt sc_khb_srv.cnt_n15
, pyeong_hh_cnt sc_khb_srv.cnt_n15
, drc_cd sc_khb_srv.cd_v20
, bay_cd sc_khb_srv.cd_v20
, stairs_stle_cd sc_khb_srv.cd_v20
, flrpln_url sc_khb_srv.url_nv4000
, estn_flrpln_url sc_khb_srv.url_nv4000
, use_yn sc_khb_srv.yn_c1
, reg_dt sc_khb_srv.dt
, mdfcn_dt sc_khb_srv.dt
, synchrn_pnttm_vl sc_khb_srv.vl_v100
);

BULK INSERT sc_khb_srv.tb_hsmp_dtl_info
       FROM 'D:\migra_data\danji_detail_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_hsmp_dtl_info add constraint pk_tb_hsmp_dtl_info primary key (hsmp_dtl_info_pk, hsmp_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_hsmp_info => 3408 ms
CREATE TABLE sc_khb_srv.tb_hsmp_info (
  hsmp_info_pk sc_khb_srv.pk_n18 NOT NULL
, hsmp_nm sc_khb_srv.nm_nv500
, ctpv_cd_pk sc_khb_srv.pk_n18
, sgg_cd_pk sc_khb_srv.pk_n18
, emd_li_cd_pk sc_khb_srv.pk_n18
, lotno sc_khb_srv.lotno_nv100
, rn_addr sc_khb_srv.addr_nv200
, tot_hh_cnt sc_khb_srv.cnt_n15
, tot_aptcmpl_cnt sc_khb_srv.cnt_n15
, flr_cnt sc_khb_srv.cnt_n15
, tot_parkng_cntom sc_khb_srv.cntom_n15
, hh_parkng_cntom sc_khb_srv.cntom_n15
, bldr_nm sc_khb_srv.nm_nv500
, cmcn_year sc_khb_srv.year_c4
, cmcn_mt sc_khb_srv.mt_c2
, compet_year sc_khb_srv.year_c4
, compet_mt sc_khb_srv.mt_c2
, heat_cd sc_khb_srv.cd_v20
, fuel_cd sc_khb_srv.cd_v20
, ctlg_cd sc_khb_srv.cd_v20
, mng_office_telno sc_khb_srv.telno_v30
, bus_rte_info sc_khb_srv.cn_nv4000
, subway_rte_info sc_khb_srv.cn_nv4000
, schl_info sc_khb_srv.cn_nv4000
, cvntl_info sc_khb_srv.cn_nv4000
, hsmp_crdnt geometry
, hsmp_lot sc_khb_srv.lot_d13_10
, hsmp_lat sc_khb_srv.lat_d12_10
, use_yn sc_khb_srv.yn_c1
, reg_dt sc_khb_srv.dt
, mdfcn_dt sc_khb_srv.dt
, synchrn_pnttm_vl sc_khb_srv.vl_v100
, hsmp_crdnt_tmp sc_khb_srv.crdnt_v500
);

BULK INSERT sc_khb_srv.tb_hsmp_info
       FROM 'D:\migra_data\danji_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_hsmp_info add constraint pk_tb_hsmp_info primary key(hsmp_info_pk);

update sc_khb_srv.tb_hsmp_info set hsmp_crdnt = geometry::STPointFromText(hsmp_crdnt_tmp, 4326) WHERE hsmp_crdnt_tmp NOT LIKE '%null%' AND hsmp_crdnt_tmp NOT LIKE '%0.0%';

alter table sc_khb_srv.tb_hsmp_info drop column hsmp_crdnt_tmp;

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_itrst_atlfsl_info => 3297 ms
CREATE TABLE sc_khb_srv.tb_itrst_atlfsl_info (
  itrst_atlfsl_info_pk sc_khb_srv.pk_n18 NOT NULL
, user_no_pk sc_khb_srv.pk_n18
, lrea_office_info_pk sc_khb_srv.pk_n18
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
, hsmp_info_pk sc_khb_srv.pk_n18
, emd_li_cd_pk sc_khb_srv.pk_n18
, use_yn sc_khb_srv.yn_c1
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_itrst_atlfsl_info
       FROM 'D:\migra_data\fav_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_itrst_atlfsl_info add constraint pk_tb_itrst_atlfsl_info primary key(itrst_atlfsl_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_apt_lttot_cmpet_rt_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_apt_lttot_cmpet_rt_info (
  house_mng_no sc_khb_srv.no_n15
, pbanc_no sc_khb_srv.no_n15
, mdl_no sc_khb_srv.no_n15
, house_ty_nm sc_khb_srv.nm_nv500
, sply_hh_cnt sc_khb_srv.cnt_n15
, rank sc_khb_srv.rank_n5
, reside_cd sc_khb_srv.cd_v20
, reside_cd_nm sc_khb_srv.nm_nv500
, rcpt_cnt sc_khb_srv.cnt_n15
, cmpet_rt_cn sc_khb_srv.cn_nvmax
, lwet_przwin_scr_cn sc_khb_srv.cn_nvmax
, top_przwin_scr_cn sc_khb_srv.cn_nvmax
, avrg_przwin_scr_cn sc_khb_srv.cn_nvmax
);

BULK INSERT sc_khb_srv.tb_link_apt_lttot_cmpet_rt_info
       FROM 'D:\migra_data\tb_apply_apt_lttot_info_cmpetrt.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_apt_lttot_house_ty_dtl_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_apt_lttot_house_ty_dtl_info (
  house_mng_no sc_khb_srv.no_n15
, pbanc_no sc_khb_srv.no_n15
, mdl_no sc_khb_srv.no_n15
, house_ty_nm sc_khb_srv.nm_nv500
, sply_area sc_khb_srv.area_d19_9
, gnrl_sply_hh_cnt sc_khb_srv.cnt_n15
, specl_sply_hh_cnt sc_khb_srv.cnt_n15
, specl_sply_mnych_hshld_hh_cnt sc_khb_srv.cnt_n15
, specl_sply_mrg_mrd_hh_cnt sc_khb_srv.cnt_n15
, specl_sply_lfe_frst_hh_cnt sc_khb_srv.cnt_n15
, specl_sply_odsn_parnts_suport_hh_cnt sc_khb_srv.cnt_n15
, specl_sply_inst_rcmdtn_hh_cnt sc_khb_srv.cnt_n15
, specl_sply_etc_hh_cnt sc_khb_srv.cnt_n15
, specl_sply_bfr_inst_hh_cnt sc_khb_srv.cnt_n15
, sply_lttot_top_amt sc_khb_srv.amt_n18
);

BULK INSERT sc_khb_srv.tb_link_apt_lttot_house_ty_dtl_info
       FROM 'D:\migra_data\tb_apply_apt_lttot_info_house_ty_detail.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_apt_lttot_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_apt_lttot_info (
  house_mng_no sc_khb_srv.no_n15
, pbanc_no sc_khb_srv.no_n15
, house_nm sc_khb_srv.nm_nv500
, house_se_cd sc_khb_srv.cd_v20
, house_se_cd_nm sc_khb_srv.nm_nv500
, house_dtl_se_cd sc_khb_srv.cd_v20
, house_dtl_se_cd_nm sc_khb_srv.nm_nv500
, lttot_se_cd sc_khb_srv.cd_v20
, lttot_se_cd_nm sc_khb_srv.nm_nv500
, sply_rgn_cd sc_khb_srv.cd_v20
, sply_rgn_nm sc_khb_srv.nm_nv500
, sply_pstn_zip sc_khb_srv.zip_c5
, sply_pstn_nm sc_khb_srv.nm_nv500
, sply_scale_cnt sc_khb_srv.cnt_n15
, rcrit_pbanc_day sc_khb_srv.day_nv100
, subscrpt_rcpt_bgng_day sc_khb_srv.day_nv100
, subscrpt_rcpt_end_day sc_khb_srv.day_nv100
, specl_sply_rcpt_bgng_day sc_khb_srv.day_nv100
, specl_sply_rcpt_end_day sc_khb_srv.day_nv100
, one_rank_rlvt_rgn_rcpt_day sc_khb_srv.day_nv100
, one_rank_gg_rgn_rcpt_day sc_khb_srv.day_nv100
, one_rank_etc_rcpt_day sc_khb_srv.day_nv100
, two_rank_rlvt_rgn_rcpt_day sc_khb_srv.day_nv100
, two_rank_gg_rgn_rcpt_day sc_khb_srv.day_nv100
, two_rank_etc_rcpt_day sc_khb_srv.day_nv100
, przwner_prsntn_day sc_khb_srv.day_nv100
, ctrt_bgng_day sc_khb_srv.day_nv100
, ctrt_end_day sc_khb_srv.day_nv100
, hmpg_url sc_khb_srv.url_nv4000
, cnstrc_bzenty_bldr_nm sc_khb_srv.nm_nv500
, refrnc_telno sc_khb_srv.telno_v30
, biz_mby_dvlr_nm sc_khb_srv.nm_nv500
, mvn_prnmnt_ym sc_khb_srv.ym_c6
, speclt_ovrhtng_spcfc_yn sc_khb_srv.yn_c1
, ajmt_trgt_rgn_yn sc_khb_srv.yn_c1
, lttot_pc_uplmt_yn sc_khb_srv.yn_c1
, imprmn_biz_yn sc_khb_srv.yn_c1
, public_house_spcfc_yn sc_khb_srv.yn_c1
, lrscl_bldlnd_devlop_spcfc_yn sc_khb_srv.yn_c1
, npln_prvopr_public_house_spcfc_yn sc_khb_srv.yn_c1
, lttot_info_url sc_khb_srv.url_nv4000
);

BULK INSERT sc_khb_srv.tb_link_apt_lttot_info
       FROM 'D:\migra_data\tb_apply_apt_lttot_info_detail.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_apt_nthg_rank_remndr_hh_lttot_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_info (
  house_mng_no sc_khb_srv.no_n15
, pbanc_no sc_khb_srv.no_n15
, house_nm sc_khb_srv.nm_nv500
, house_se_cd sc_khb_srv.cd_v20
, house_se_cd_nm sc_khb_srv.nm_nv500
, sply_pstn_zip sc_khb_srv.zip_c5
, sply_pstn_nm sc_khb_srv.nm_nv500
, sply_scale_cnt sc_khb_srv.cnt_n15
, rcrit_pbanc_day sc_khb_srv.day_nv100
, subscrpt_rcpt_bgng_day sc_khb_srv.day_nv100
, subscrpt_rcpt_end_day sc_khb_srv.day_nv100
, specl_sply_rcpt_bgng_day sc_khb_srv.day_nv100
, specl_sply_rcpt_end_day sc_khb_srv.day_nv100
, gnrl_sply_rcpt_bgng_day sc_khb_srv.day_nv100
, gnrl_sply_rcpt_end_day sc_khb_srv.day_nv100
, przwner_prsntn_day sc_khb_srv.day_nv100
, ctrt_bgng_day sc_khb_srv.day_nv100
, ctrt_end_day sc_khb_srv.day_nv100
, hmpg_url sc_khb_srv.url_nv4000
, biz_mby_dvlr_nm sc_khb_srv.nm_nv500
, refrnc_telno sc_khb_srv.telno_v30
, mvn_prnmnt_ym sc_khb_srv.ym_c6
, lttot_info_url sc_khb_srv.url_nv4000
);

BULK INSERT sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_info
       FROM 'D:\migra_data\tb_apply_apt_nthg_rank_remndr_hshld_lttot_info_detail.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_apt_nthg_rank_remndr_hh_lttot_ty_dtl_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_ty_dtl_info (
  house_mng_no sc_khb_srv.no_n15
, pbanc_no sc_khb_srv.no_n15
, mdl_no sc_khb_srv.no_n15
, mdl_ty_nm sc_khb_srv.nm_nv500
, sply_area sc_khb_srv.area_d19_9
, gnrl_sply_hh_cnt sc_khb_srv.cnt_n15
, specl_sply_hh_cnt sc_khb_srv.cnt_n15
, sply_lttot_top_amt sc_khb_srv.amt_n18
);

BULK INSERT sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_ty_dtl_info
       FROM 'D:\migra_data\tb_apply_apt_nthg_rank_remndr_hshld_lttot_info_house_ty_det.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_hsmp_area_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_hsmp_area_info (
  house_mng_no sc_khb_srv.no_n15
, pbanc_no sc_khb_srv.no_n15
, mdl_no sc_khb_srv.no_n15
, mdl_ty_nm sc_khb_srv.nm_nv500
, sply_area sc_khb_srv.area_d19_9
, gnrl_sply_hh_cnt sc_khb_srv.cnt_n15
, specl_sply_hh_cnt sc_khb_srv.cnt_n15
, sply_lttot_top_amt sc_khb_srv.amt_n18
);

BULK INSERT sc_khb_srv.tb_link_hsmp_area_info
       FROM 'D:\migra_data\tb_k_apt_hsmp_ar_info.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_hsmp_bsc_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_hsmp_bsc_info (
  hsmp_cd sc_khb_srv.cd_v20
, hsmp_nm sc_khb_srv.nm_nv500
, ctpv_nm sc_khb_srv.nm_nv500
, sgg_nm sc_khb_srv.nm_nv500
, eupmyeon_nm sc_khb_srv.nm_nv500
, dongli_nm sc_khb_srv.nm_nv500
, hsmp_clsf_nm sc_khb_srv.nm_nv500
, stdg_addr sc_khb_srv.addr_nv1000
, rn_addr sc_khb_srv.addr_nv200
, lttot_stle_nm sc_khb_srv.nm_nv500
, use_aprv_day sc_khb_srv.day_nv100
, aptcmpl_cnt sc_khb_srv.cnt_n15
, hh_cnt sc_khb_srv.cnt_n15
, mng_mthd_nm sc_khb_srv.nm_nv500
, heat_mthd_nm sc_khb_srv.nm_nv500
, crrdpr_type_nm sc_khb_srv.nm_nv500
, bldr_nm sc_khb_srv.nm_nv500
, dvlr_nm sc_khb_srv.nm_nv500
, house_mng_bsmn_nm sc_khb_srv.nm_nv500
, gnrl_mng_mthd_nm sc_khb_srv.nm_nv500
, gnrl_mng_nmpr_cnt sc_khb_srv.cnt_n15
, expens_mng_mthd_nm sc_khb_srv.nm_nv500
, expens_mng_nmpr_cnt sc_khb_srv.cnt_n15
, expens_mng_ctrt_bzenty_nm sc_khb_srv.nm_nv500
, cln_mng_mthd_nm sc_khb_srv.nm_nv500
, cln_mng_nmpr_cnt sc_khb_srv.cnt_n15
, fdndrk_prcs_mthd_nm sc_khb_srv.nm_nv500
, dsnf_mng_mthd_nm sc_khb_srv.nm_nv500
, fyer_dsnf_cnt sc_khb_srv.cnt_n15
, dsnf_mthd_nm sc_khb_srv.nm_nv500
, bldg_strct_nm sc_khb_srv.nm_nv500
, elcty_pwrsuply_cpcty sc_khb_srv.cpcty_d25_15
, hh_elcty_ctrt_mthd_nm sc_khb_srv.nm_nv500
, elcty_safe_mngr_apnt_mthd_nm sc_khb_srv.nm_nv500
, fire_rcivr_mthd_nm sc_khb_srv.nm_nv500
, wsp_mthd_nm sc_khb_srv.nm_nv500
, elvtr_mng_stle_nm sc_khb_srv.nm_nv500
, psnger_elvtr_cnt sc_khb_srv.cnt_n15
, frght_elvtr_cnt sc_khb_srv.cnt_n15
, psnger_frght_elvtr_cnt sc_khb_srv.cnt_n15
, pwdbs_elvtr_cnt sc_khb_srv.cnt_n15
, emgnc_elvtr_cnt sc_khb_srv.cnt_n15
, etc_elvtr_cnt sc_khb_srv.cnt_n15
, tot_parkng_cntom sc_khb_srv.cntom_n15
, grnd_parkng_cnt sc_khb_srv.cnt_n15
, udgd_parkng_cnt sc_khb_srv.cnt_n15
, cctv_cnt sc_khb_srv.cnt_n15
, parkng_cntrl_hrk_yn_nm sc_khb_srv.nm_nv500
, mngoffice_addr sc_khb_srv.addr_nv200
, mngoffice_telno sc_khb_srv.telno_v30
, mngoffice_fxno sc_khb_srv.fxno_v30
, anclr_wlfare_fclt_nm sc_khb_srv.nm_nv500
, join_day sc_khb_srv.day_nv100
, lttot_hh_cnt sc_khb_srv.cnt_n15
, rent_hh_cnt sc_khb_srv.cnt_n15
, top_flr_cnt sc_khb_srv.cnt_n15
, bdrg_top_flr_cnt sc_khb_srv.cnt_n15
, udgd_flr_cnt sc_khb_srv.cnt_n15
);

BULK INSERT sc_khb_srv.tb_link_hsmp_bsc_info
       FROM 'D:\migra_data\tb_k_apt_hsmp_bass_info.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_hsmp_managect_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_hsmp_managect_info (
  hsmp_cd sc_khb_srv.cd_v20
, hsmp_nm sc_khb_srv.nm_nv500
, ctpv_nm sc_khb_srv.nm_nv500
, sgg_nm sc_khb_srv.nm_nv500
, eupmyeon_nm sc_khb_srv.nm_nv500
, dongli_nm sc_khb_srv.nm_nv500
, ocrn_ym sc_khb_srv.ym_c6
, cmnuse_mng_ct sc_khb_srv.ct_n18
, labor_ct sc_khb_srv.ct_n18
, ofcrk_ct sc_khb_srv.ct_n18
, txs_pbldus_amt sc_khb_srv.amt_n18
, clth_ct sc_khb_srv.ct_n18
, edu_traing_ct sc_khb_srv.ct_n18
, vhcl_mntnc_ct sc_khb_srv.ct_n18
, anclr_ct sc_khb_srv.ct_n18
, cln_ct sc_khb_srv.ct_n18
, expens_ct sc_khb_srv.ct_n18
, dsnf_ct sc_khb_srv.ct_n18
, elvtr_mntnc_ct sc_khb_srv.ct_n18
, intlgnt_ntwrk_mntnc_ct sc_khb_srv.ct_n18
, rpairs_ct sc_khb_srv.ct_n18
, fclt_mntnc_ct sc_khb_srv.ct_n18
, safe_chck_ct sc_khb_srv.ct_n18
, dsstr_prevnt_ct sc_khb_srv.ct_n18
, cnsgn_mng_fee sc_khb_srv.fee_n18
, indiv_ct sc_khb_srv.ct_n18
, cmnuse_heat_ct sc_khb_srv.ct_n18
, prvuse_heat_ct sc_khb_srv.ct_n18
, cmnuse_hwtr_ct sc_khb_srv.ct_n18
, prvuse_hwtr_ct sc_khb_srv.ct_n18
, cmnuse_gas_ct sc_khb_srv.ct_n18
, prvuse_gas_ct sc_khb_srv.ct_n18
, cmnuse_elcty_ct sc_khb_srv.ct_n18
, prvuse_elcty_ct sc_khb_srv.ct_n18
, cmnuse_wtway_ct sc_khb_srv.ct_n18
, prvuse_wtway_ct sc_khb_srv.ct_n18
, wrrtn_dirt_fee sc_khb_srv.fee_n18
, lvlh_wste_fee sc_khb_srv.fee_n18
, residnt_rprs_mtg_oper_ct sc_khb_srv.ct_n18
, bldg_insrnc_amt sc_khb_srv.amt_n18
, elec_mng_cmit_oper_ct sc_khb_srv.ct_n18
, fdrm_rpairs_rsvmney_mt_levy_amt sc_khb_srv.amt_n18
, lngtr_rpairs_rsvmney_mt_use_amt sc_khb_srv.amt_n18
, lngtr_rpairs_rsvmney_tot_amt sc_khb_srv.amt_n18
, lngtr_rpairs_rsvmney_accml_rt sc_khb_srv.rt_d19_9
, etc_ern_mt_incm_amt sc_khb_srv.amt_n18
);

BULK INSERT sc_khb_srv.tb_link_hsmp_managect_info
       FROM 'D:\migra_data\tb_k_apt_managect_info.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_ofctl_cty_prvate_rent_lttot_cmpet_rt_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_cmpet_rt_info (
  house_mng_no sc_khb_srv.no_n15
, pbanc_no sc_khb_srv.no_n15
, mdl_no sc_khb_srv.no_n15
, house_ty_nm sc_khb_srv.nm_nv500
, sply_hh_cnt sc_khb_srv.cnt_n15
, residnt_prior_yn sc_khb_srv.yn_c1
, sply_se_nm sc_khb_srv.nm_nv500
, rcpt_cnt sc_khb_srv.cnt_n15
, cmpet_rt_cn sc_khb_srv.cn_nvmax
);

BULK INSERT sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_cmpet_rt_info
       FROM 'D:\migra_data\tb_apply_ofctl_cty_prvate_rent_lttot_info_cmpetrt.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_ofctl_cty_prvate_rent_lttot_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_info (
  house_mng_no sc_khb_srv.no_n15
, pbanc_no sc_khb_srv.no_n15
, house_nm sc_khb_srv.nm_nv500
, house_se_cd sc_khb_srv.cd_v20
, house_se_cd_nm sc_khb_srv.nm_nv500
, house_dtl_se_cd sc_khb_srv.cd_v20
, house_dtl_se_cd_nm sc_khb_srv.nm_nv500
, house_se_nm sc_khb_srv.nm_nv500
, sply_pstn_zip sc_khb_srv.zip_c5
, sply_pstn_nm sc_khb_srv.nm_nv500
, sply_scale_cnt sc_khb_srv.cnt_n15
, rcrit_pbanc_day sc_khb_srv.day_nv100
, subscrpt_rcpt_bgng_day sc_khb_srv.day_nv100
, subscrpt_rcpt_end_day sc_khb_srv.day_nv100
, przwner_prsntn_day sc_khb_srv.day_nv100
, ctrt_bgng_day sc_khb_srv.day_nv100
, ctrt_end_day sc_khb_srv.day_nv100
, hmpg_url sc_khb_srv.url_nv4000
, biz_mby_dvlr_nm sc_khb_srv.nm_nv500
, refrnc_telno sc_khb_srv.telno_v30
, mvn_prnmnt_ym sc_khb_srv.ym_c6
, lttot_info_url sc_khb_srv.url_nv4000
);

BULK INSERT sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_info
       FROM 'D:\migra_data\tb_apply_ofctl_cty_prvate_rent_lttot_info_detail.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_ofctl_cty_prvate_rent_lttot_ty_dtl_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_ty_dtl_info (
  house_mng_no sc_khb_srv.no_n15
, pbanc_no sc_khb_srv.no_n15
, mdl_no sc_khb_srv.no_n15
, group_nm sc_khb_srv.nm_nv500
, ty_nm sc_khb_srv.nm_nv500
, prvuse_area sc_khb_srv.area_d19_9
, sply_hh_cnt sc_khb_srv.cnt_n15
, sply_lttot_top_amt sc_khb_srv.amt_n18
, subscrpt_aply_amt sc_khb_srv.amt_n18
);

BULK INSERT sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_ty_dtl_info
       FROM 'D:\migra_data\tb_apply_ofctl_cty_prvate_rent_lttot_house_ty_info_detail.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_public_sprt_prvate_rent_lttot_cmpet_rt_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_public_sprt_prvate_rent_lttot_cmpet_rt_info (
  house_mng_no sc_khb_srv.no_n15
, pbanc_no sc_khb_srv.no_n15
, mdl_no sc_khb_srv.no_n15
, house_ty_nm sc_khb_srv.nm_nv500
, sply_hh_cnt sc_khb_srv.cnt_n15
, sply_type_cd sc_khb_srv.cd_v20
, sply_type_cd_nm sc_khb_srv.nm_nv500
, altmnt_hh_cnt sc_khb_srv.cnt_n15
, rcpt_cnt sc_khb_srv.cnt_n15
, cmpet_rt_cn sc_khb_srv.cn_nvmax
);

BULK INSERT sc_khb_srv.tb_link_public_sprt_prvate_rent_lttot_cmpet_rt_info
       FROM 'D:\migra_data\tb_apply_public_sport_prvate_rent_lttot_info_cmpetrt.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_remndr_hh_lttot_cmpet_rt_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_remndr_hh_lttot_cmpet_rt_info (
  house_mng_no sc_khb_srv.no_n15
, pbanc_no sc_khb_srv.no_n15
, beffat_aftfat_se_cd sc_khb_srv.cd_v20
, house_ty_nm sc_khb_srv.nm_nv500
, sply_hh_cnt sc_khb_srv.cnt_n15
, rcpt_cnt sc_khb_srv.cnt_n15
, cmpet_rt_cn sc_khb_srv.cn_nvmax
);

BULK INSERT sc_khb_srv.tb_link_remndr_hh_lttot_cmpet_rt_info
       FROM 'D:\migra_data\tb_apply_remndr_hshld_lttot_info_cmpetrt.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_rtrcn_re_sply_lttot_cmpet_rt_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_rtrcn_re_sply_lttot_cmpet_rt_info (
  house_mng_no sc_khb_srv.no_n15
, pbanc_no sc_khb_srv.no_n15
, mdl_no sc_khb_srv.no_n15
, house_ty_nm sc_khb_srv.nm_nv500
, gnrl_sply_altmnt_hh_cnt sc_khb_srv.cnt_n15
, mnych_hshld_altmnt_hh_cnt sc_khb_srv.cnt_n15
, mrg_mrd_altmnt_hh_cnt sc_khb_srv.cnt_n15
, lfe_frst_altmnt_hh_cnt sc_khb_srv.cnt_n15
, odsn_parnts_suport_altmnt_hh_cnt sc_khb_srv.cnt_n15
, inst_rcmdtn_altmnt_hh_cnt sc_khb_srv.cnt_n15
, gnrl_sply_rcpt_cnt sc_khb_srv.cnt_n15
, mnych_hshld_rcpt_cnt sc_khb_srv.cnt_n15
, mrg_mrd_rcpt_cnt sc_khb_srv.cnt_n15
, lfe_frst_rcpt_cnt sc_khb_srv.cnt_n15
, odsn_parnts_suport_rcpt_cnt sc_khb_srv.cnt_n15
, inst_rcmdtn_rcpt_cnt sc_khb_srv.cnt_n15
, gnrl_sply_cmpet_rt_cn sc_khb_srv.cn_nvmax
, mnych_hshld_cmpet_rt_cn sc_khb_srv.cn_nvmax
, mrg_mrd_cmpet_rt_cn sc_khb_srv.cn_nvmax
, lfe_frst_cmpet_rt_cn sc_khb_srv.cn_nvmax
, odsn_parnts_suport_cmpet_rt_cn sc_khb_srv.cn_nvmax
, inst_rcmdtn_cmpet_rt_cn sc_khb_srv.cn_nvmax
);

BULK INSERT sc_khb_srv.tb_link_rtrcn_re_sply_lttot_cmpet_rt_info
       FROM 'D:\migra_data\tb_apply_cancl_re_suply_lttot_info_cmpetrt.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_subway_statn_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_subway_statn_info (
  statn_no sc_khb_srv.no_v200
, statn_nm sc_khb_srv.nm_nv500
, rte_no sc_khb_srv.no_v200
, rte_nm sc_khb_srv.nm_nv500
, eng_statn_nm sc_khb_srv.nm_nv500
, chcrt_statn_nm sc_khb_srv.nm_nv500
, trnsit_statn_se_nm sc_khb_srv.nm_nv500
, trnsit_rte_no sc_khb_srv.no_v200
, trnsit_rte_nm sc_khb_srv.nm_nv500
, statn_lat sc_khb_srv.lat_d12_10
, statn_lot sc_khb_srv.lot_d13_10
, oper_inst_nm sc_khb_srv.nm_nv500
, statn_rn_addr sc_khb_srv.addr_nv200
, statn_telno sc_khb_srv.telno_v30
, data_crtr_day sc_khb_srv.day_nv100
, statn_crdnt geometry
, stdg_cd sc_khb_srv.cd_v20
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
, statn_crdnt_tmp sc_khb_srv.crdnt_v500
);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_lrea_office_info => 8777 ms
CREATE TABLE sc_khb_srv.tb_link_apt_lttot_info (
  house_mng_no sc_khb_srv.no_n15
, pbanc_no sc_khb_srv.no_n15
, house_nm sc_khb_srv.nm_nv500
, house_se_cd sc_khb_srv.cd_v20
, house_se_cd_nm sc_khb_srv.nm_nv500
, house_dtl_se_cd sc_khb_srv.cd_v20
, house_dtl_se_cd_nm sc_khb_srv.nm_nv500
, lttot_se_cd sc_khb_srv.cd_v20
, lttot_se_cd_nm sc_khb_srv.nm_nv500
, sply_rgn_cd sc_khb_srv.cd_v20
, sply_rgn_nm sc_khb_srv.nm_nv500
, sply_pstn_zip sc_khb_srv.zip_c5
, sply_pstn_nm sc_khb_srv.nm_nv500
, sply_scale_cnt sc_khb_srv.cnt_n15
, rcrit_pbanc_day sc_khb_srv.day_nv100
, subscrpt_rcpt_bgng_day sc_khb_srv.day_nv100
, subscrpt_rcpt_end_day sc_khb_srv.day_nv100
, specl_sply_rcpt_bgng_day sc_khb_srv.day_nv100
, specl_sply_rcpt_end_day sc_khb_srv.day_nv100
, one_rank_rlvt_rgn_rcpt_day sc_khb_srv.day_nv100
, one_rank_gg_rgn_rcpt_day sc_khb_srv.day_nv100
, one_rank_etc_rcpt_day sc_khb_srv.day_nv100
, two_rank_rlvt_rgn_rcpt_day sc_khb_srv.day_nv100
, two_rank_gg_rgn_rcpt_day sc_khb_srv.day_nv100
, two_rank_etc_rcpt_day sc_khb_srv.day_nv100
, przwner_prsntn_day sc_khb_srv.day_nv100
, ctrt_bgng_day sc_khb_srv.day_nv100
, ctrt_end_day sc_khb_srv.day_nv100
, hmpg_url sc_khb_srv.url_nv4000
, cnstrc_bzenty_bldr_nm sc_khb_srv.nm_nv500
, refrnc_telno sc_khb_srv.telno_v30
, biz_mby_dvlr_nm sc_khb_srv.nm_nv500
, mvn_prnmnt_ym sc_khb_srv.ym_c6
, speclt_ovrhtng_spcfc_yn sc_khb_srv.yn_c1
, ajmt_trgt_rgn_yn sc_khb_srv.yn_c1
, lttot_pc_uplmt_yn sc_khb_srv.yn_c1
, imprmn_biz_yn sc_khb_srv.yn_c1
, public_house_spcfc_yn sc_khb_srv.yn_c1
, lrscl_bldlnd_devlop_spcfc_yn sc_khb_srv.yn_c1
, npln_prvopr_public_house_spcfc_yn sc_khb_srv.yn_c1
, lttot_info_url sc_khb_srv.url_nv4000
);

BULK INSERT sc_khb_srv.tb_lrea_office_info
       FROM 'D:\migra_data\realtor_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_lrea_office_info add constraint pk_tb_lrea_office_info primary key(lrea_office_info_pk);

update sc_khb_srv.tb_lrea_office_info set lrea_office_crdnt = geometry::STPointFromText(lrea_office_crdnt_tmp, 4326) WHERE lrea_office_crdnt_tmp NOT LIKE '%null%' AND lrea_office_crdnt_tmp NOT LIKE '%0.0%';

alter table sc_khb_srv.tb_lrea_office_info drop column lrea_office_crdnt_tmp;

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_lttot_info => 197 ms
CREATE TABLE sc_khb_srv.tb_lttot_info (
  lttot_info_pk sc_khb_srv.pk_n18 NOT NULL
, lttot_info_ttl_nm sc_khb_srv.nm_nv500
, lttot_info_cn sc_khb_srv.cn_nvmax
, ctpv_cd_pk sc_khb_srv.pk_n18
, ctpv_nm sc_khb_srv.nm_nv500
, sgg_cd_pk sc_khb_srv.pk_n18
, sgg_nm sc_khb_srv.nm_nv500
, emd_li_cd_pk sc_khb_srv.pk_n18
, all_emd_li_nm sc_khb_srv.nm_nv500
, dtl_addr sc_khb_srv.addr_nv200
, sply_scale_cn sc_khb_srv.cn_nv4000
, sply_house_area_cn sc_khb_srv.cn_nvmax
, lttot_pc_cn sc_khb_srv.cn_nv4000
, rcrit_pbanc_day sc_khb_srv.day_nv100
, subscrpt_rcpt_day_list sc_khb_srv.list_nv1000
, przwner_prsntn_day sc_khb_srv.day_nv100
, mvn_prnmnt_day sc_khb_srv.day_nv100
, ctrt_pd sc_khb_srv.pd_nv50
, bldr_nm sc_khb_srv.nm_nv500
, mdlhs_opnng_day sc_khb_srv.day_nv100
, lttot_inqry_info_cn sc_khb_srv.cn_nv4000
, cvntl_info_cn sc_khb_srv.cn_nvmax
, trnsport_envrn_info_cn sc_khb_srv.cn_nvmax
, edu_envrn_info_cn sc_khb_srv.cn_nvmax
, img_url sc_khb_srv.url_nv4000
, rgtr_id sc_khb_srv.id_nv100
, reg_day sc_khb_srv.day_nv100
, synchrn_pnttm_vl sc_khb_srv.vl_v100
);

BULK INSERT sc_khb_srv.tb_lttot_info
       FROM 'D:\migra_data\bunyang_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_lttot_info add constraint pk_tb_lttot_info primary key(lttot_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
-- tb_svc_bass_info
CREATE TABLE sc_khb_srv.tb_svc_bass_info (
  svc_pk sc_khb_srv.pk_n18 NOT NULL
, api_no_pk sc_khb_srv.pk_n18
, svc_nm sc_khb_srv.nm_nv500
, svc_cl_code sc_khb_srv.cd_v20
, svc_ty_code sc_khb_srv.cd_v20
, svc_url sc_khb_srv.url_nv4000
, svc_cn sc_khb_srv.cn_nv4000
, file_data_at sc_khb_srv.yn_c1
, othbc_at sc_khb_srv.yn_c1
, delete_at sc_khb_srv.yn_c1
, inqire_co sc_khb_srv.co_n15
, use_provd_co sc_khb_srv.co_n15
, regist_id sc_khb_srv.id_nv100
, regist_dt sc_khb_srv.dt default (getdate())
, updt_id sc_khb_srv.id_nv100
, updt_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_svc_bass_info add constraint pk_tb_svc_bass_info primary key(svc_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_user_atlfsl_img_info => 15414 ms
CREATE TABLE sc_khb_srv.tb_user_atlfsl_img_info (
  user_atlfsl_img_info_pk sc_khb_srv.pk_n18 NOT NULL
, user_atlfsl_info_pk sc_khb_srv.pk_n18
, sort_ordr sc_khb_srv.ordr_n5
, img_file_nm sc_khb_srv.nm_nv500
, img_url sc_khb_srv.url_nv4000
, thumb_img_url sc_khb_srv.url_nv4000
, srvr_img_file_nm sc_khb_srv.nm_nv500
, local_img_file_nm sc_khb_srv.nm_nv500
, thumb_img_file_nm sc_khb_srv.nm_nv500
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_user_atlfsl_img_info
       FROM 'D:\migra_data\user_mamul_photo.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_user_atlfsl_img_info add constraint pk_tb_user_atlfsl_img_info primary key(user_atlfsl_img_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_user_atlfsl_info => 706 ms
CREATE TABLE sc_khb_srv.tb_user_atlfsl_info (
  user_atlfsl_info_pk sc_khb_srv.pk_n18 NOT NULL
, user_no_pk sc_khb_srv.pk_n18
, preocupy_lrea_cnt sc_khb_srv.cd_v20
, atlfsl_knd_cd sc_khb_srv.cd_v20
, dlng_se_cd sc_khb_srv.cd_v20
, atlfsl_stts_cd sc_khb_srv.cd_v20
, ctpv_cd_pk sc_khb_srv.pk_n18
, ctpv_nm sc_khb_srv.nm_nv500
, sgg_cd_pk sc_khb_srv.pk_n18
, sgg_nm sc_khb_srv.nm_nv500
, emd_li_cd_pk sc_khb_srv.pk_n18
, all_emd_li_nm sc_khb_srv.nm_nv500
, mno sc_khb_srv.mno_n4
, sno sc_khb_srv.sno_n4
, aptcmpl_nm sc_khb_srv.nm_nv500
, ho_nm sc_khb_srv.nm_nv500
, lat sc_khb_srv.lat_d12_10
, lot sc_khb_srv.lot_d13_10
, trde_pc sc_khb_srv.pc_n10
, lfsts_pc sc_khb_srv.pc_n10
, mtht_yyt_pc sc_khb_srv.pc_n10
, room_cnt sc_khb_srv.cnt_n15
, btr_cnt sc_khb_srv.cnt_n15
, lrea_office_atmc_chc_yn sc_khb_srv.yn_c1
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_user_atlfsl_info
       FROM 'D:\migra_data\user_mamul.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_user_atlfsl_info add constraint pk_tb_user_atlfsl_info primary key(user_atlfsl_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_user_atlfsl_preocupy_info
CREATE TABLE sc_khb_srv.tb_user_atlfsl_preocupy_info (
  user_mapng_info_pk sc_khb_srv.pk_n18 NOT NULL
, user_atlfsl_info_pk sc_khb_srv.pk_n18
, lrea_office_info_pk sc_khb_srv.pk_n18
, preocupy_yn sc_khb_srv.yn_c1
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_user_atlfsl_preocupy_info
       FROM 'D:\migra_data\user_mamul_agent.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_user_atlfsl_preocupy_info add constraint pk_tb_user_atlfsl_preocupy_info primary key(user_mapng_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------



-- com유저에게 테이블 권한 주기
SELECT 
  table_name
, 'grant select, insert, delete, update on ' + TABLE_SCHEMA + '.' + table_name + ' to us_khb_com;' "테이블 권한 부여"
  FROM information_schema.tables
 WHERE TABLE_SCHEMA = 'sc_khb_srv'
--       AND 
--       TABLE_NAME = 'tb_atlfsl_batch_hstry'
 ORDER BY 1;

grant select, insert, delete, update on sc_khb_srv.tb_atlfsl_batch_hstry to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_atlfsl_bsc_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_atlfsl_cfr_fclt_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_atlfsl_cmrc_dtl_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_atlfsl_dlng_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_atlfsl_etc_dtl_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_atlfsl_etc_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_atlfsl_img_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_atlfsl_land_usg_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_atlfsl_reside_gnrl_dtl_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_atlfsl_reside_set_dtl_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_author to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_banner_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_bbs to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_bbs_cmnt to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_code to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_crtfc_tmpr to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_ctpv_cd to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_emd_li_cd to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_error_log to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_faq to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_file to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_file_mapng to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_group to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_group_author to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_gtwy_svc to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_gtwy_svc_author to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_job_schdl_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_login_hist to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_menu to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_menu_author to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_notice to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_qna to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_recsroom to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_scrin to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_scrin_author to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_sgg_cd to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_stplat_hist to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_stplat_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_stplat_mapng to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_svc_ip_manage to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_thema_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_user to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_user_author to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_com_user_group to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_hsmp_dtl_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_hsmp_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_itrst_atlfsl_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_lrea_office_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_lttot_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_svc_bass_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_user_atlfsl_img_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_user_atlfsl_info to us_khb_com;
grant select, insert, delete, update on sc_khb_srv.tb_user_atlfsl_preocupy_info to us_khb_com;


-- 나머지 유저에게는 tb_com_error_log DML권한 주기
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_dev;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_agent;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_exif;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_magnt;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_mptl;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_report;





grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_bsc_info to us_khb_exif;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_cfr_fclt_info to us_khb_exif;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_cmrc_dtl_info to us_khb_exif;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_dlng_info to us_khb_exif;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_etc_dtl_info to us_khb_exif;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_etc_info to us_khb_exif;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_img_info to us_khb_exif;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_land_usg_info to us_khb_exif;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_reside_gnrl_dtl_info to us_khb_exif;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_atlfsl_reside_set_dtl_info to us_khb_exif;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_author to us_khb_com;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_banner_info to us_khb_com;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_bbs to us_khb_com;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_bbs_cmnt to us_khb_com;
--grant SELECT on sc_khb_srv.tb_com_code to us_khb_adm;
--grant SELECT on sc_khb_srv.tb_com_code to us_khb_agnt;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_code to us_khb_com;
--grant SELECT on sc_khb_srv.tb_com_code to us_khb_dev;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_code to us_khb_exif;
--grant SELECT on sc_khb_srv.tb_com_code to us_khb_magnt;
--grant SELECT on sc_khb_srv.tb_com_code to us_khb_mptl;
--grant SELECT on sc_khb_srv.tb_com_code to us_khb_report;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_crtfc_tmpr to us_khb_com;
grant SELECT on sc_khb_srv.tb_com_ctpv_cd to us_khb_adm;
grant SELECT on sc_khb_srv.tb_com_ctpv_cd to us_khb_agnt;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_ctpv_cd to us_khb_com;
grant SELECT on sc_khb_srv.tb_com_ctpv_cd to us_khb_dev;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_ctpv_cd to us_khb_exif;
grant SELECT on sc_khb_srv.tb_com_ctpv_cd to us_khb_magnt;
grant SELECT on sc_khb_srv.tb_com_ctpv_cd to us_khb_mptl;
grant SELECT on sc_khb_srv.tb_com_ctpv_cd to us_khb_report;
grant SELECT on sc_khb_srv.tb_com_emd_li_cd to us_khb_adm;
grant SELECT on sc_khb_srv.tb_com_emd_li_cd to us_khb_agnt;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_emd_li_cd to us_khb_com;
grant SELECT on sc_khb_srv.tb_com_emd_li_cd to us_khb_dev;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_emd_li_cd to us_khb_exif;
grant SELECT on sc_khb_srv.tb_com_emd_li_cd to us_khb_magnt;
grant SELECT on sc_khb_srv.tb_com_emd_li_cd to us_khb_mptl;
grant SELECT on sc_khb_srv.tb_com_emd_li_cd to us_khb_report;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_error_log to us_khb_agnt;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_error_log to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_error_log to us_khb_dev;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_error_log to us_khb_exif;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_error_log to us_khb_magnt;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_error_log to us_khb_mptl;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_error_log to us_khb_report;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_faq to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_file to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_file_mapng to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_group to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_group_author to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_gtwy_svc to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_gtwy_svc_author to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_job_schdl_hstry to us_khb_com;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_job_schdl_info to us_khb_com;
grant SELECT on sc_khb_srv.tb_com_job_schdl_info to us_khb_exif;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_login_hist to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_menu to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_menu_author to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_notice to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_qna to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_recsroom to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_scrin to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_scrin_author to us_khb_com;
grant SELECT on sc_khb_srv.tb_com_sgg_cd to us_khb_adm;
grant SELECT on sc_khb_srv.tb_com_sgg_cd to us_khb_agnt;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_sgg_cd to us_khb_com;
grant SELECT on sc_khb_srv.tb_com_sgg_cd to us_khb_dev;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_sgg_cd to us_khb_exif;
grant SELECT on sc_khb_srv.tb_com_sgg_cd to us_khb_magnt;
grant SELECT on sc_khb_srv.tb_com_sgg_cd to us_khb_mptl;
grant SELECT on sc_khb_srv.tb_com_sgg_cd to us_khb_report;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_stplat_hist to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_stplat_info to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_stplat_mapng to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_svc_ip_manage to us_khb_com;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_thema_info to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_user to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_user_author to us_khb_com;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_com_user_group to us_khb_com;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_hsmp_dtl_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_hsmp_dtl_info to us_khb_mptl;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_hsmp_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_hsmp_info to us_khb_mptl;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_itrst_atlfsl_info to us_khb_mptl;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_lrea_office_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_lrea_office_info to us_khb_mptl;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_lttot_info to us_khb_exif;
grant SELECT on sc_khb_srv.tb_lttot_info to us_khb_mptl;
--grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_svc_bass_info to us_khb_com;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_user_atlfsl_img_info to us_khb_mptl;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_user_atlfsl_info to us_khb_mptl;
grant DELETE, INSERT, SELECT, UPDATE on sc_khb_srv.tb_user_atlfsl_preocupy_info to us_khb_mptl;










-- 해당 용어가 com인지 app인지 확인
SELECT 
  table_name
, COLUMN_NAME 
  FROM information_schema.columns
 WHERE 
--       (COLUMN_NAME LIKE 'at'
--       OR
       COLUMN_NAME LIKE '%:_at' ESCAPE ':'
       OR
--       COLUMN_NAME LIKE '%at:_%' ESCAPE ':')
--       AND
       TABLE_SCHEMA = 'sc_khb_srv'
 ORDER BY 1;

-- 해당 용어의 데이터의 중복값을 제거하고 데이터 확인
SELECT 
  'select distinct ' + char(10) + 
  '  ''' + a.table_name + ''' "table_name"' + char(10) +
  ', ''' + a.column_name + ''' "column_name"' + char(10) +
  ', ' + 'cast(' + a.column_name + ' as varchar(50))' + ' "result"' + char(10) +
  '  from sc_khb_srv.' + a.table_name + char(10) + 
  'union'
FROM(
    SELECT 
      table_name
    , COLUMN_NAME 
      FROM information_schema.columns
     WHERE 
--          (
           COLUMN_NAME LIKE '%:_yn' ESCAPE ':'
--           OR
--           COLUMN_NAME LIKE '%at:_%' ESCAPE ':'
--)
           AND
           COLUMN_NAME NOT LIKE '%:_pk' ESCAPE ':'
           AND
           COLUMN_NAME NOT LIKE '%:_dt' ESCAPE ':'
           AND 
           table_schema = 'sc_khb_srv') a;



















