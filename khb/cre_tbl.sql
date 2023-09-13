/*
테이블을 작성해주는 쿼리문을 짜주는 파일
작성 일시: 23-06-10
수정 일시: 230904
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
--       AND 
--       CAST(ep.value AS varchar) NOT LIKE '%공통%'
--       CAST(ep.value AS varchar) LIKE '%공통%'
 ORDER BY 1;

-- 테이블의 열 정보(열번호 맞게 => pk가 존재하는 테이블만)
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
--      AND
--      object_name(c.object_id) = 'tb_com_user'
--      AND 
--      CAST(ep.value AS varchar) LIKE '%%'
ORDER BY 1, c.column_id;

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
     LEFT JOIN
     sys.extended_properties ep
     	ON object_name(c.object_id) = object_name(ep.major_id) AND c.column_id = ep.minor_id
WHERE c.name like '%eml%'
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
 WHERE table_NAME = 'tb_com_user'
 ORDER BY ORDINAL_POSITION;
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
        WHERE table_NAME = 'tb_lrea_office_info'
       ) tr;
/*geometry은 설정을 안 해 두어서 null 발생*/


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
       CASE WHEN c2.TABLE_NAME = 'tb_com_emd_li_cd' THEN ', emd_li_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
--            WHEN c2.TABLE_NAME = 'tb_link_subway_statn_info' THEN ', statn_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
--            WHEN c2.TABLE_NAME = 'tb_atlfsl_bsc_info' THEN ', atlfsl_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
--            WHEN c2.TABLE_NAME = 'tb_com_ctpv_cd' THEN ', ctpv_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
--            WHEN c2.TABLE_NAME = 'tb_lrea_office_info' THEN ', lrea_office_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
--            WHEN c2.TABLE_NAME = 'tb_com_sgg_cd' THEN ', sgg_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
--            WHEN c2.TABLE_NAME = 'tb_hsmp_info' THEN ', hsmp_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
--            WHEN c2.TABLE_NAME = 'tb_link_hsmp_bsc_info' THEN ', hsmp_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
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


-- insert into openrowset
SELECT TABLE_NAME
     , stuff((SELECT '' + COLUMN_NAME))
  FROM information_schema.columns;

-- 테이블 생성
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_batch_hstry =>  ms
CREATE TABLE sc_khb_srv.tb_atlfsl_batch_hstry (
  atlfsl_batch_hstry_pk sc_khb_srv.pk_n18 NOT NULL
, cntnts_no sc_khb_srv.no_n15
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
, hstry_se_cd sc_khb_srv.cd_v20
, rslt_cd sc_khb_srv.cd_v20
, job_dt sc_khb_srv.dt
, err_cn sc_khb_srv.cn_nvmax
);

BULK INSERT sc_khb_srv.tb_atlfsl_batch_hstry
       FROM 'D:\migra_data\product_batch_history.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_atlfsl_batch_hstry add constraint pk_tb_atlfsl_batch_hstry primary key(atlfsl_batch_hstry_pk);

SELECT * FROM sc_khb_srv.tb_atlfsl_batch_hstry;
SELECT count(*) FROM sc_khb_srv.tb_atlfsl_batch_hstry; -- 114054
SELECT max(atlfsl_batch_hstry_pk) FROM sc_khb_srv.tb_atlfsl_batch_hstry; -- 48788648

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
, rcmdtn_yn sc_khb_srv.yn_c1
, auc_yn sc_khb_srv.yn_c1
, atlfsl_stts_cd sc_khb_srv.cd_v20
, totar sc_khb_srv.totar_d19_9
, atlfsl_vrfc_yn sc_khb_srv.yn_c1
, atlfsl_vrfc_day sc_khb_srv.day_nv100
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
--, atlfsl_crdnt_tmp sc_khb_srv.crdnt_v500
);


/*AS방법으로 테이블 만들기*/
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
, atlfsl_crdnt AS CASE WHEN (atlfsl_lot IS NULL OR atlfsl_lot = 0) THEN NULL
                       ELSE geometry::STPointFromText(concat('point(', atlfsl_lot, ' ', atlfsl_lat, ')'), 4326)
                  END 
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
, rcmdtn_yn sc_khb_srv.yn_c1
, auc_yn sc_khb_srv.yn_c1
, atlfsl_stts_cd sc_khb_srv.cd_v20
, totar sc_khb_srv.totar_d19_9
, atlfsl_vrfc_yn sc_khb_srv.yn_c1
, atlfsl_vrfc_day sc_khb_srv.day_nv100
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_atlfsl_bsc_info
       FROM 'D:\migra_data\product_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
); -- article 테이블 삭제 전

bulk insert sc_khb_srv.tb_atlfsl_bsc_info
from 'D:\migra_data\product_info_new.txt'
with (
    codepage = '65001'
  , fieldterminator = '||'
  , rowterminator = '0x0a'
); -- 연면적 추가 전

/*totar추가 되었을 때 totar열에 새로운 값 추가하기*/
WITH spc_tbl AS
(
    SELECT DISTINCT product_no, total_spc
      FROM (
			 SELECT product_no, total_spc
		       FROM hanbang.hanbang.article_type_c_info
		      UNION 
		     SELECT product_no, total_spc
		       FROM hanbang.hanbang.article_type_d_info
		      UNION 
		     SELECT product_no, total_spc
		       FROM hanbang.hanbang.article_type_ef_info
		   ) a
)
UPDATE sc_khb_srv.tb_atlfsl_bsc_info 
   SET totar = total_spc
          FROM spc_tbl
 WHERE sc_khb_srv.tb_atlfsl_bsc_info.atlfsl_bsc_info_pk = spc_tbl.product_no;
/*
txt파일을 만들지 않고 hanbang db를 이용하여 바로 값을 추가!!!
*/

BULK INSERT sc_khb_srv.tb_atlfsl_bsc_info
       FROM 'D:\migra_data\product_info_test.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
); 

-- AS 방법
bulk insert sc_khb_srv.tb_atlfsl_bsc_info
from 'D:\migra_data\product_info_spc.txt'
with (
    codepage = '65001'
  , fieldterminator = '||'
  , rowterminator = '0x0a'
);

alter table sc_khb_srv.tb_atlfsl_bsc_info add constraint pk_tb_atlfsl_bsc_info primary key(atlfsl_bsc_info_pk);

update sc_khb_srv.tb_atlfsl_bsc_info set atlfsl_crdnt = geometry::STPointFromText(atlfsl_crdnt_tmp, 4326) WHERE atlfsl_crdnt_tmp NOT LIKE '%null%' AND atlfsl_crdnt_tmp NOT LIKE '%0.0%';

alter table sc_khb_srv.tb_atlfsl_bsc_info drop column atlfsl_crdnt_tmp;

SELECT * FROM sc_khb_srv.tb_atlfsl_bsc_info;
SELECT count(*) FROM sc_khb_srv.tb_atlfsl_bsc_info; -- 740079
SELECT max(atlfsl_bsc_info_pk) FROM sc_khb_srv.tb_atlfsl_bsc_info; -- 20849889

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

/*pk-fk관계를 위한 데이터 삭제*/
DELETE sc_khb_srv.tb_atlfsl_cfr_fclt_info 
 WHERE atlfsl_bsc_info_pk in (
                              SELECT atlfsl_bsc_info_pk 
                                FROM sc_khb_srv.tb_atlfsl_cfr_fclt_info
                              EXCEPT
                              SELECT atlfsl_bsc_info_pk 
                                FROM sc_khb_srv.tb_atlfsl_bsc_info tabi);

SELECT * FROM sc_khb_srv.tb_atlfsl_cfr_fclt_info;
SELECT count(*) FROM sc_khb_srv.tb_atlfsl_cfr_fclt_info; -- 746717
SELECT max(atlfsl_cfr_fclt_info_pk) FROM sc_khb_srv.tb_atlfsl_cfr_fclt_info; -- 20848921

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_cmrc_dtl_info => 3902 ms
--CREATE TABLE sc_khb_srv.tb_atlfsl_cmrc_dtl_info (
--  atlfsl_cmrc_dtl_info_pk sc_khb_srv.pk_n18 NOT NULL
--, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
--, atlfsl_ty_cd sc_khb_srv.cd_v20
--, stdg_cd sc_khb_srv.cd_v20
--, prvuse_area sc_khb_srv.area_d19_9
--, flr_cnt sc_khb_srv.cnt_n15
--, top_flr_cnt sc_khb_srv.cnt_n15
--, room_cnt sc_khb_srv.cnt_n15
--, toilet_cnt sc_khb_srv.cnt_n15
--, cmcn_day sc_khb_srv.day_nv100
--, drc_cd sc_khb_srv.cd_v20
--, pstn_expln_cn sc_khb_srv.cn_nv4000
--, sply_area sc_khb_srv.area_d19_9
--, parkng_psblty_yn sc_khb_srv.yn_c1
--, arch_area sc_khb_srv.area_d19_9
--, plot_area sc_khb_srv.area_d19_9
--, udgd_flr_cnt sc_khb_srv.cnt_n15
--, grnd_flr_cnt sc_khb_srv.cnt_n15
--, reg_dt sc_khb_srv.dt
--, mdfcn_dt sc_khb_srv.dt
--, use_yn sc_khb_srv.yn_c1
--);
--
--BULK INSERT sc_khb_srv.tb_atlfsl_cmrc_dtl_info
--       FROM 'D:\migra_data\article_type_d_info.txt'
--       WITH (
--             CODEPAGE = '65001',
--             FIELDTERMINATOR = '||',
--             ROWTERMINATOR = '0x0a'
--);
--
--alter table sc_khb_srv.tb_atlfsl_cmrc_dtl_info add constraint pk_tb_atlfsl_cmrc_dtl_info primary key(atlfsl_cmrc_dtl_info_pk);

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

SELECT * FROM sc_khb_srv.tb_atlfsl_dlng_info;
SELECT count(*) FROM sc_khb_srv.tb_atlfsl_dlng_info; -- 746717
SELECT max(atlfsl_dlng_info_pk) FROM sc_khb_srv.tb_atlfsl_dlng_info; -- 20848925

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_etc_dtl_info => 7208 ms
--CREATE TABLE sc_khb_srv.tb_atlfsl_etc_dtl_info (
--  atlfsl_etc_dtl_info_pk sc_khb_srv.pk_n18 NOT NULL
--, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
--, atlfsl_ty_cd sc_khb_srv.cd_v20
--, stdg_cd sc_khb_srv.cd_v20
--, prvuse_area sc_khb_srv.area_d19_9
--, flr_cnt sc_khb_srv.cnt_n15
--, top_flr_cnt sc_khb_srv.cnt_n15
--, room_cnt sc_khb_srv.cnt_n15
--, cmcn_day sc_khb_srv.day_nv100
--, drc_cd sc_khb_srv.cd_v20
--, pstn_expln_cn sc_khb_srv.cn_nv4000
--, sply_area sc_khb_srv.area_d19_9
--, parkng_psblty_yn sc_khb_srv.yn_c1
--, arch_area sc_khb_srv.area_d19_9
--, plot_area sc_khb_srv.area_d19_9
--, udgd_flr_cnt sc_khb_srv.cnt_n15
--, grnd_flr_cnt sc_khb_srv.cnt_n15
--, reg_dt sc_khb_srv.dt
--, mdfcn_dt sc_khb_srv.dt
--, use_yn sc_khb_srv.yn_c1
--);
--
--BULK INSERT sc_khb_srv.tb_atlfsl_etc_dtl_info
--       FROM 'D:\migra_data\article_type_ef_info.txt'
--       WITH (
--             CODEPAGE = '65001',
--             FIELDTERMINATOR = '||',
--             ROWTERMINATOR = '0x0a'
--);
--
--alter table sc_khb_srv.tb_atlfsl_etc_dtl_info add constraint pk_tb_atlfsl_etc_dtl_info primary key(atlfsl_etc_dtl_info_pk);

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
, mvn_psblty_aftr_ym sc_khb_srv.ym_c6
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

SELECT * FROM sc_khb_srv.tb_atlfsl_etc_info;
SELECT count(*) FROM sc_khb_srv.tb_atlfsl_etc_info; -- 746717
SELECT max(atlfsl_etc_info_pk) FROM sc_khb_srv.tb_atlfsl_etc_info; -- 20848921

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

SELECT * FROM sc_khb_srv.tb_atlfsl_img_info;
SELECT count(*) FROM sc_khb_srv.tb_atlfsl_img_info; -- 836226
SELECT max(atlfsl_img_info_pk) FROM sc_khb_srv.tb_atlfsl_img_info; -- 836226

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
, prsl_yn sc_khb_srv.yn_c1
);

alter table sc_khb_srv.tb_atlfsl_inqry_info add constraint pk_tb_atlfsl_inqry_info primary key(atlfsl_inqry_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
-- tb_atlfsl_land_usg_info => 92842 ms
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

SELECT * FROM sc_khb_srv.tb_atlfsl_land_usg_info;
SELECT count(*) FROM sc_khb_srv.tb_atlfsl_land_usg_info; -- 746717
SELECT max(atlfsl_land_usg_info_pk) FROM sc_khb_srv.tb_atlfsl_land_usg_info; -- 20848921

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_thema_info
CREATE TABLE sc_khb_srv.tb_atlfsl_thema_info (
  atlfsl_thema_info_pk sc_khb_srv.pk_n18 NOT NULL
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
, thema_info_pk sc_khb_srv.pk_n18
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_atlfsl_thema_info
       FROM 'D:\migra_data\product_thema.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '0x0a'
            );

alter table sc_khb_srv.tb_atlfsl_thema_info add constraint pk_tb_atlfsl_thema_info primary key(atlfsl_thema_info_pk);

SELECT * FROM sc_khb_srv.tb_atlfsl_thema_info;
SELECT count(*) FROM sc_khb_srv.tb_atlfsl_thema_info; -- 155375
SELECT max(atlfsl_thema_info_pk) FROM sc_khb_srv.tb_atlfsl_thema_info; -- 155375 

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_reside_gnrl_dtl_info => 1898 ms
--CREATE TABLE sc_khb_srv.tb_atlfsl_reside_gnrl_dtl_info (
--  atlfsl_reside_gnrl_dtl_info_pk sc_khb_srv.pk_n18 NOT NULL
--, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
--, atlfsl_ty_cd sc_khb_srv.cd_v20
--, stdg_cd sc_khb_srv.cd_v20
--, prvuse_area sc_khb_srv.area_d19_9
--, flr_cnt sc_khb_srv.cnt_n15
--, top_flr_cnt sc_khb_srv.cnt_n15
--, room_cnt sc_khb_srv.cnt_n15
--, toilet_cnt sc_khb_srv.cnt_n15
--, cmcn_day sc_khb_srv.day_nv100
--, drc_cd sc_khb_srv.cd_v20
--, pstn_expln_cn sc_khb_srv.cn_nv4000
--, sply_area sc_khb_srv.area_d19_9
--, parkng_psblty_yn sc_khb_srv.yn_c1
--, arch_area sc_khb_srv.area_d19_9
--, plot_area sc_khb_srv.area_d19_9
--, udgd_flr_cnt sc_khb_srv.cnt_n15
--, grnd_flr_cnt sc_khb_srv.cnt_n15
--, flr_expsr_mthd_cd sc_khb_srv.cd_v20
--, now_flr_expsr_mthd_cd sc_khb_srv.cd_v20
--, stairs_stle_cd sc_khb_srv.cd_v20
--, reg_dt sc_khb_srv.dt
--, mdfcn_dt sc_khb_srv.dt
--, use_yn sc_khb_srv.yn_c1
--);
--
--BULK INSERT sc_khb_srv.tb_atlfsl_reside_gnrl_dtl_info
--       FROM 'D:\migra_data\article_type_c_info.txt'
--       WITH (
--             CODEPAGE = '65001',
--             FIELDTERMINATOR = '||',
--             ROWTERMINATOR = '0x0a'
--);
--
--alter table sc_khb_srv.tb_atlfsl_reside_gnrl_dtl_info add constraint pk_tb_atlfsl_reside_gnrl_dtl_info primary key(atlfsl_reside_gnrl_dtl_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_atlfsl_reside_set_dtl_info => 25549 ms
--CREATE TABLE sc_khb_srv.tb_atlfsl_reside_set_dtl_info (
--  atlfsl_reside_set_dtl_info_pk sc_khb_srv.pk_n18 NOT NULL
--, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
--, atlfsl_ty_cd sc_khb_srv.cd_v20
--, stdg_cd sc_khb_srv.cd_v20
--, hsmp_info_pk sc_khb_srv.pk_n18
--, prvuse_area sc_khb_srv.area_d19_9
--, flr_cnt sc_khb_srv.cnt_n15
--, top_flr_cnt sc_khb_srv.cnt_n15
--, room_cnt sc_khb_srv.cnt_n15
--, toilet_cnt sc_khb_srv.cnt_n15
--, stairs_stle_cd sc_khb_srv.cd_v20
--, cmcn_day sc_khb_srv.day_nv100
--, drc_cd sc_khb_srv.cd_v20
--, financ_amt sc_khb_srv.amt_n18
--, aptcmpl_nm sc_khb_srv.nm_nv500
--, ho_nm sc_khb_srv.nm_nv500
--, flr_expsr_mthd_cd sc_khb_srv.cd_v20
--, now_flr_expsr_mthd_cd sc_khb_srv.cd_v20
--, blcn_cd sc_khb_srv.cd_v20
--, reg_dt sc_khb_srv.dt
--, mdfcn_dt sc_khb_srv.dt
--, use_yn sc_khb_srv.yn_c1
--);
--
--BULK INSERT sc_khb_srv.tb_atlfsl_reside_set_dtl_info
--       FROM 'D:\migra_data\article_type_ab_info.txt'
--       WITH (
--             CODEPAGE = '65001',
--             FIELDTERMINATOR = '||',
--             ROWTERMINATOR = '0x0a'
--);
--
--alter table sc_khb_srv.tb_atlfsl_reside_set_dtl_info add constraint pk_tb_atlfsl_reside_set_dtl_info primary key(atlfsl_reside_set_dtl_info_pk);

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

SELECT * FROM sc_khb_srv.tb_com_banner_info;
SELECT count(*) FROM sc_khb_srv.tb_com_banner_info; -- 12
SELECT max(banner_info_pk) FROM sc_khb_srv.tb_com_banner_info; -- 13 

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

SELECT * FROM sc_khb_srv.tb_com_banner_info;
SELECT count(*) FROM sc_khb_srv.tb_com_banner_info; -- 12
SELECT max(banner_info_pk) FROM sc_khb_srv.tb_com_banner_info; -- 13 

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
, mdfcn_id sc_khb_srv.id_nv100
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

SELECT * FROM sc_khb_srv.tb_com_bbs_cmnt;
SELECT count(*) FROM sc_khb_srv.tb_com_bbs_cmnt; -- 67
SELECT max(bbs_cmnt_pk) FROM sc_khb_srv.tb_com_bbs_cmnt; -- 67

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_cnrs_info =>  ms
CREATE TABLE sc_khb_srv.tb_com_cnrs_info (
  cnrs_info_pk sc_khb_srv.pk_n18 NOT NULL
, cnrs_ttl_nm sc_khb_srv.nm_nv500
, cnrs_cn sc_khb_srv.cn_nvmax
, img_url sc_khb_srv.url_nv4000
, url_paramtr_cn sc_khb_srv.cn_nvmax
, aplctn_cd sc_khb_srv.cd_v20
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);


ALTER TABLE sc_khb_srv.tb_com_cnrs_info ADD CONSTRAINT pk_tb_com_cnrs_info PRIMARY KEY  CLUSTERED (cnrs_info_pk);

SELECT * FROM sc_khb_srv.tb_com_cnrs_info;
SELECT count(*) FROM sc_khb_srv.tb_com_cnrs_info; -- 0
SELECT max(cnrs_info_pk) FROM sc_khb_srv.tb_com_cnrs_info; -- null

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
, parnts_code sc_khb_srv.cd_v20
--, synchrn_pnttm_vl sc_khb_srv.vl_v100
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

-- com_code에서 부모_코드 없던 데이터들 부모 코드에 맞게 데이터 삽입
--SELECT * FROM sc_khb_srv.tb_com_code WHERE parnts_code IS NULL;
--UPDATE sc_khb_srv.tb_com_code SET parnts_code = b.code
--FROM sc_khb_srv.tb_com_code a
--     LEFT JOIN
--     (
--      SELECT code_pk, code
--        FROM sc_khb_srv.tb_com_code
--       WHERE parnts_code IS NULL
--         AND code_pk = parnts_code_pk) b
--                 ON a.parnts_code_pk = b.code_pk
-- WHERE a.parnts_code IS NULL;

SELECT * FROM sc_khb_srv.tb_com_code;
SELECT count(*) FROM sc_khb_srv.tb_com_code; -- 1207
SELECT max(code_pk) FROM sc_khb_srv.tb_com_code; -- 1207

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
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

bulk insert sc_khb_srv.tb_com_ctpv_cd
from 'D:\migra_data\sido_code.txt'
with (
    codepage = '65001'
  , fieldterminator = '||'
  , rowterminator = '0x0a'
);

alter table sc_khb_srv.tb_com_ctpv_cd add constraint pk_tb_com_ctpv_cd primary key(ctpv_cd_pk);

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


-- 시도 테이블에 좌표 데이터 삽입
UPDATE sc_khb_srv.tb_com_ctpv_cd SET ctpv_crdnt = tb_sdmat.crdnt
  FROM sc_khb_srv.tb_sdmat
 WHERE tb_com_ctpv_cd.ctpv_cd_pk = tb_sdmat.ctpv_cd_pk;

DROP VIEW sc_khb_srv.tb_sdmat;


-- 시도청 좌표 수동으로 삽입
SELECT 'update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = ''' +
       ctpv_crdnt.STAsText() + 
       ''' where ctpv_cd_pk = ' + CAST(ctpv_cd_pk AS varchar(2)) + ';'
  FROM sc_khb_srv.tb_com_ctpv_cd; 


-- 시도청 좌표 수동으로 삽입쿼리문
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (126.978142 37.566778)' where ctpv_cd_pk = 1;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (127.009453 37.275126)' where ctpv_cd_pk = 2;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (126.705897 37.456182)' where ctpv_cd_pk = 3;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (129.074972 35.179797)' where ctpv_cd_pk = 4;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (128.60167 35.871385)' where ctpv_cd_pk = 5;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (126.851423 35.160068)' where ctpv_cd_pk = 6;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (127.384819 36.350476)' where ctpv_cd_pk = 7;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (129.311528 35.539607)' where ctpv_cd_pk = 8;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (127.729764 37.885398)' where ctpv_cd_pk = 9;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (128.692384 35.238288)' where ctpv_cd_pk = 10;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (128.505596 36.576055)' where ctpv_cd_pk = 11;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (126.462913 34.816245)' where ctpv_cd_pk = 12;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (127.108716 35.820351)' where ctpv_cd_pk = 13;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (126.672856 36.65887)' where ctpv_cd_pk = 14;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (127.491439 36.635696)' where ctpv_cd_pk = 15;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (127.286514 36.478131)' where ctpv_cd_pk = 16;
update sc_khb_srv.tb_com_ctpv_cd set ctpv_crdnt = 'POINT (126.531231 33.499593)' where ctpv_cd_pk = 17;

SELECT * FROM sc_khb_srv.tb_com_ctpv_cd;
SELECT count(*) FROM sc_khb_srv.tb_com_ctpv_cd; -- 17
SELECT max(ctpv_cd_pk) FROM sc_khb_srv.tb_com_ctpv_cd; -- 17

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
, dstrbnc_prhibt_bgng_hm sc_khb_srv.hm_c4
, dstrbnc_prhibt_end_hm sc_khb_srv.hm_c4
, dstrbnc_prhibt_yn sc_khb_srv.yn_c1
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
, ntcn_trsm_scs_cnt sc_khb_srv.cnt_n15
, ntcn_trsm_fail_cnt sc_khb_srv.cnt_n15
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
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
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

SELECT * FROM sc_khb_srv.tb_com_emd_li_cd;
SELECT count(*) FROM sc_khb_srv.tb_com_emd_li_cd; -- 23846
SELECT max(emd_li_cd_pk) FROM sc_khb_srv.tb_com_emd_li_cd; -- 24371

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
, requst_ip_adres sc_khb_srv.addr_nv1000
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
, dwld_co sc_khb_srv.cnt_n15
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

bulk insert sc_khb_srv.tb_com_group
from 'D:\migra_data\mssql_com_group.txt'
with (
    codepage = '65001'
  , fieldterminator = '||'
  , rowterminator = '\n'
);

alter table sc_khb_srv.tb_com_group add constraint pk_tb_com_group primary key(group_no_pk);

SELECT * FROM sc_khb_srv.tb_com_group;
SELECT count(*) FROM sc_khb_srv.tb_com_group; -- 4
SELECT max(group_no_pk) FROM sc_khb_srv.tb_com_group; -- 4

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
, excn_hms sc_khb_srv.hms_c6
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
, synchrn_pnttm_vl sc_khb_srv.vl_v100
, excn_srvc_nm sc_khb_srv.nm_nv500
, job_expln_cn sc_khb_srv.cn_nvmax
);

/*타임 스탬프 추가전 쿼리*/
--BULK INSERT sc_khb_srv.tb_com_job_schdl_info
--       FROM 'D:\migra_data\cron_info.txt'
--       WITH (
--             CODEPAGE = '65001',
--             FIELDTERMINATOR = '||',
--             ROWTERMINATOR = '0x0a'
--);

BULK INSERT sc_khb_srv.tb_com_job_schdl_info
       FROM 'D:\migra_data\cron_info_timestamp.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_com_job_schdl_info add constraint pk_tb_com_job_schdl_info primary key(job_schdl_info_pk);

-- 데이터 삽입
--INSERT INTO sc_khb_srv.tb_com_job_schdl_info VALUES (14, 'news', 'all', '0 0 0/7 * * *', '2023-08-17 14:00:00.040', null);
--INSERT INTO sc_khb_srv.tb_com_job_schdl_info VALUES (15, 'lttot', 'batch', '0 30 1-22 * * *', NULL, null);

UPDATE sc_khb_srv.tb_com_job_schdl_info SET synchrn_pnttm_vl = (SELECT max(synchrn_pnttm_vl) FROM sc_khb_srv.tb_lttot_info)
 WHERE job_se_cd='lttot';
/*tb_lttot_info테이블 만들고 다시 시도*/

SELECT * FROM sc_khb_srv.tb_com_job_schdl_info;
SELECT count(*) FROM sc_khb_srv.tb_com_job_schdl_info; -- 9
SELECT max(job_schdl_info_pk) FROM sc_khb_srv.tb_com_job_schdl_info; -- 12

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_com_login_hist
CREATE TABLE sc_khb_srv.tb_com_login_hist (
  login_hist_pk sc_khb_srv.pk_n18 NOT NULL
, user_id sc_khb_srv.id_nv100
, login_ip_adres sc_khb_srv.addr_nv1000
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
, inqire_co sc_khb_srv.cnt_n15
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
, ntcn_rsvt_dt sc_khb_srv.dt
, ntcn_trgt_se_cd sc_khb_srv.cd_v20
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
, dstrbnc_prhibt_excl_yn sc_khb_srv.yn_c1
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
, inqire_co sc_khb_srv.cnt_n15
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
, inqire_co sc_khb_srv.cnt_n15
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
, id_vl sc_khb_srv.vl_v100
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
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_com_sgg_cd
       FROM 'D:\migra_data\gugun_code.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_com_sgg_cd add constraint pk_tb_com_sgg_cd primary key(sgg_cd_pk);

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


-- 시군구 좌표 수동으로 삽입
SELECT 'update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = ''' +
       sgg_crdnt.STAsText() + 
       ''' where sgg_cd_pk = ' + CAST(sgg_cd_pk AS varchar(3)) + ';'
  FROM sc_khb_srv.tb_com_sgg_cd;


-- 시군구 좌표 수동으로 삽입 쿼리문
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.8831992387 37.7099794299)' where sgg_cd_pk = 1;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.3800794499 38.3904036159)' where sgg_cd_pk = 2;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.0447070926 37.5154255898)' where sgg_cd_pk = 3;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.1726676791 37.2575827951)' where sgg_cd_pk = 4;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.51722708 38.1751621225)' where sgg_cd_pk = 5;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.988376974 38.1651422564)' where sgg_cd_pk = 6;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.6213003485 38.011989357)' where sgg_cd_pk = 7;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.4590847216 37.2180180203)' where sgg_cd_pk = 8;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.8998165755 37.3251692031)' where sgg_cd_pk = 9;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.2501219711 38.1006435615)' where sgg_cd_pk = 10;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.7041102251 37.3700341549)' where sgg_cd_pk = 11;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.35082042 38.2189070954)' where sgg_cd_pk = 12;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.7873395454 37.8802366864)' where sgg_cd_pk = 13;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.9581756493 37.2038619322)' where sgg_cd_pk = 14;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.4415313668 37.5440200517)' where sgg_cd_pk = 15;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.1849431378 37.7490630899)' where sgg_cd_pk = 16;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.6858099398 38.1408712823)' where sgg_cd_pk = 17;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.985022 37.491803)' where sgg_cd_pk = 18;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.4076639836 37.8110415039)' where sgg_cd_pk = 19;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9008446325 37.6612989227)' where sgg_cd_pk = 20;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.806348339 37.6813600359)' where sgg_cd_pk = 21;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.7246663121 37.6772954459)' where sgg_cd_pk = 22;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.004139616 37.4341012591)' where sgg_cd_pk = 23;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.8670524277 37.4483221818)' where sgg_cd_pk = 24;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.2918225815 37.4002881213)' where sgg_cd_pk = 25;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.1327294897 37.6013479662)' where sgg_cd_pk = 26;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9207338792 37.3418739667)' where sgg_cd_pk = 27;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.6017292712 37.6848297145)' where sgg_cd_pk = 28;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.2578392576 37.6430181841)' where sgg_cd_pk = 29;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0670043078 37.9207325135)' where sgg_cd_pk = 30;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.7823346824 37.5062888885)' where sgg_cd_pk = 31;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0944924401 37.3754700355)' where sgg_cd_pk = 34;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.1044442687 37.4357797878)' where sgg_cd_pk = 35;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.1697774894 37.4399961468)' where sgg_cd_pk = 36;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9654356278 37.2641281999)' where sgg_cd_pk = 37;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0562056796 37.2761853312)' where sgg_cd_pk = 38;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0038446111 37.3180833667)' where sgg_cd_pk = 39;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0174980233 37.2752575756)' where sgg_cd_pk = 40;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.8340123876 37.3934960338)' where sgg_cd_pk = 41;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.7948319803 37.3293707192)' where sgg_cd_pk = 42;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.8574899231 37.3228492344)' where sgg_cd_pk = 43;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.3060720484 37.0249598108)' where sgg_cd_pk = 44;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9548279935 37.4011664397)' where sgg_cd_pk = 45;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9028063125 37.4046041747)' where sgg_cd_pk = 46;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0140723466 37.8053067296)' where sgg_cd_pk = 47;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.5813374415 37.5189173887)' where sgg_cd_pk = 48;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.6442322316 37.2877507155)' where sgg_cd_pk = 49;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0421474479 38.105246639)' where sgg_cd_pk = 50;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0512540807 37.163155603)' where sgg_cd_pk = 51;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.1184427972 37.2701033475)' where sgg_cd_pk = 52;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0885209993 37.3328797621)' where sgg_cd_pk = 53;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.2399792906 37.2218899547)' where sgg_cd_pk = 54;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9893338086 37.3581376151)' where sgg_cd_pk = 55;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0664296439 37.7331622303)' where sgg_cd_pk = 56;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.4519883417 37.2014907573)' where sgg_cd_pk = 57;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.8076298033 37.8491910049)' where sgg_cd_pk = 58;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0039226341 37.023124511)' where sgg_cd_pk = 59;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.2372309182 37.9676709824)' where sgg_cd_pk = 60;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.2116282798 37.5303145007)' where sgg_cd_pk = 61;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9142121351 37.153556947)' where sgg_cd_pk = 62;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.5894210782 34.871541995)' where sgg_cd_pk = 63;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.9269571401 35.7120668692)' where sgg_cd_pk = 64;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.3210923445 35.0104358318)' where sgg_cd_pk = 65;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.8616222028 35.2731072631)' where sgg_cd_pk = 66;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.8813230039 34.8239756389)' where sgg_cd_pk = 67;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.767335953 35.4932209812)' where sgg_cd_pk = 68;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.109293745 35.038230492)' where sgg_cd_pk = 69;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.9073037455 35.3976865504)' where sgg_cd_pk = 70;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.0506569694 35.4031112581)' where sgg_cd_pk = 71;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.2758606078 35.3853919383)' where sgg_cd_pk = 72;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.1271862684 35.2010813465)' where sgg_cd_pk = 73;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.472528164 35.5259244502)' where sgg_cd_pk = 74;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.4673079559 35.1382226846)' where sgg_cd_pk = 75;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.5443599066 35.2271445842)' where sgg_cd_pk = 76;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.6707250155 35.19843343)' where sgg_cd_pk = 77;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.6351363468 35.3052396788)' where sgg_cd_pk = 78;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.7682643202 35.1248461578)' where sgg_cd_pk = 79;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.362535904 34.9027893374)' where sgg_cd_pk = 80;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.7852982774 35.1361351608)' where sgg_cd_pk = 81;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.4414962577 35.2826755255)' where sgg_cd_pk = 82;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.7211106208 35.5436397995)' where sgg_cd_pk = 83;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.1679309563 35.5999675934)' where sgg_cd_pk = 84;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.804556192 35.8465080824)' where sgg_cd_pk = 85;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.2075618094 35.8598925581)' where sgg_cd_pk = 86;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.3100423714 35.7318477405)' where sgg_cd_pk = 87;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.3639459917 36.2114554598)' where sgg_cd_pk = 88;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.572657 36.242945)' where sgg_cd_pk = 89;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.0489530698 36.0435991761)' where sgg_cd_pk = 90;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.13342179 36.6926720245)' where sgg_cd_pk = 91;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.9018357301 36.9234360663)' where sgg_cd_pk = 92;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.096200983 36.4470382113)' where sgg_cd_pk = 93;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.2261474208 35.916217665)' where sgg_cd_pk = 94;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.724913245 36.5594422949)' where sgg_cd_pk = 95;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.2936811562 36.470227052)' where sgg_cd_pk = 96;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.1360540231 36.6852506801)' where sgg_cd_pk = 97;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.5347769084 36.8806141151)' where sgg_cd_pk = 98;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.9150881498 36.0072258721)' where sgg_cd_pk = 99;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.4719983246 36.6514681492)' where sgg_cd_pk = 100;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (130.8587327731 37.5049264501)' where sgg_cd_pk = 101;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.2844886438 36.895121685)' where sgg_cd_pk = 102;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.5935333236 36.361787813)' where sgg_cd_pk = 103;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.8847235451 35.7064032735)' where sgg_cd_pk = 104;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.0962045153 36.3778200155)' where sgg_cd_pk = 105;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.464504457 36.0061619588)' where sgg_cd_pk = 106;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.4315522822 35.9621053206)' where sgg_cd_pk = 107;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.1931040839 36.1734983275)' where sgg_cd_pk = 108;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.7393259444 35.1643304022)' where sgg_cd_pk = 109;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.8799938383 35.1016433633)' where sgg_cd_pk = 110;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9612143502 35.1189171737)' where sgg_cd_pk = 111;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9096706192 35.1898563524)' where sgg_cd_pk = 112;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.854047811 35.1347676239)' where sgg_cd_pk = 113;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.5814523863 35.8337367908)' where sgg_cd_pk = 114;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.5283301606 35.8211374854)' where sgg_cd_pk = 115;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.4827662839 35.7137519823)' where sgg_cd_pk = 116;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.6817704097 35.9339530313)' where sgg_cd_pk = 117;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.5802204332 35.9307092258)' where sgg_cd_pk = 118;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.548368984 35.8756247915)' where sgg_cd_pk = 119;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.661525413 35.834533003)' where sgg_cd_pk = 120;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.5952311024 35.8672070672)' where sgg_cd_pk = 121;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.442603927 36.4091126916)' where sgg_cd_pk = 122;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.4679273037 36.3172945802)' where sgg_cd_pk = 123;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.3404765437 36.2775515269)' where sgg_cd_pk = 124;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.3452494691 36.382259239)' where sgg_cd_pk = 125;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.4021071561 36.2783813606)' where sgg_cd_pk = 126;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.9173479476 35.157564114)' where sgg_cd_pk = 127;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.0903466563 35.2583436073)' where sgg_cd_pk = 128;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.1927284762 35.285383572)' where sgg_cd_pk = 129;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.0899196518 35.1263052475)' where sgg_cd_pk = 130;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.045072374 35.1274299268)' where sgg_cd_pk = 131;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.0795317033 35.2048422989)' where sgg_cd_pk = 132;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.0469966452 35.1678466273)' where sgg_cd_pk = 133;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.0212146585 35.2319489657)' where sgg_cd_pk = 134;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.9860123632 35.1597247878)' where sgg_cd_pk = 135;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.9768471556 35.0850277072)' where sgg_cd_pk = 136;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.0194032031 35.0959104776)' where sgg_cd_pk = 137;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.1131519158 35.1612312293)' where sgg_cd_pk = 138;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.086160835 35.1788376954)' where sgg_cd_pk = 139;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.0655872459 35.0751194158)' where sgg_cd_pk = 140;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.03070252 35.1061138159)' where sgg_cd_pk = 141;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.1420310156 35.2014145407)' where sgg_cd_pk = 142;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0625023653 37.4960663228)' where sgg_cd_pk = 143;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.1472465818 37.5489099674)' where sgg_cd_pk = 144;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0047716834 37.6470830047)' where sgg_cd_pk = 145;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.818658698 37.5657480208)' where sgg_cd_pk = 146;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9508742636 37.465385348)' where sgg_cd_pk = 147;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.089430654 37.5481464248)' where sgg_cd_pk = 148;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.8539984426 37.4955977255)' where sgg_cd_pk = 149;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.8998271691 37.4600688345)' where sgg_cd_pk = 150;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0732697385 37.6551445619)' where sgg_cd_pk = 151;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0328064239 37.6659596199)' where sgg_cd_pk = 152;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.051858828 37.5838172005)' where sgg_cd_pk = 153;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9483484621 37.4965070103)' where sgg_cd_pk = 154;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.8979978546 37.5621643994)' where sgg_cd_pk = 155;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9331494205 37.5827434862)' where sgg_cd_pk = 156;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0136769523 37.4769666531)' where sgg_cd_pk = 157;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0414268527 37.5507585391)' where sgg_cd_pk = 158;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0277407149 37.6069808826)' where sgg_cd_pk = 159;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.1059516007 37.504835814)' where sgg_cd_pk = 160;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.8622817222 37.5270524825)' where sgg_cd_pk = 161;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9146852392 37.5206647197)' where sgg_cd_pk = 162;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9803212603 37.5311077053)' where sgg_cd_pk = 163;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9266084527 37.6174882336)' where sgg_cd_pk = 164;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9667261798 37.5990906904)' where sgg_cd_pk = 165;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9929697052 37.5579274434)' where sgg_cd_pk = 166;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0931497653 37.5954117342)' where sgg_cd_pk = 167;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.269708778 36.5704023964)' where sgg_cd_pk = 168;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.3256560472 35.505578131)' where sgg_cd_pk = 169;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.4240981474 35.5215118247)' where sgg_cd_pk = 170;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.3974623486 35.5977150907)' where sgg_cd_pk = 171;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.1646820049 35.5271072993)' where sgg_cd_pk = 172;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (129.3051011083 35.5720034375)' where sgg_cd_pk = 173;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.433732558 37.711045303)' where sgg_cd_pk = 174;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.7357374314 37.5586284434)' where sgg_cd_pk = 175;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.6649538265 37.4569760973)' where sgg_cd_pk = 176;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.753374989 37.4305594939)' where sgg_cd_pk = 177;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.6363824974 37.4821396957)' where sgg_cd_pk = 178;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.7169102876 37.4943330911)' where sgg_cd_pk = 179;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.6620235551 37.5552218665)' where sgg_cd_pk = 180;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.6398376971 37.3905441979)' where sgg_cd_pk = 181;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (124.6753246518 37.9494874333)' where sgg_cd_pk = 182;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.4569769803 37.4752105034)' where sgg_cd_pk = 183;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.7297456562 34.6165208902)' where sgg_cd_pk = 184;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.36074344 34.6346929135)' where sgg_cd_pk = 185;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.2847458449 35.2031960544)' where sgg_cd_pk = 186;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.6577110474 35.0432896169)' where sgg_cd_pk = 187;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.5017864766 35.230696351)' where sgg_cd_pk = 188;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.7410482049 34.9891097023)' where sgg_cd_pk = 189;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9756355197 35.2912075354)' where sgg_cd_pk = 190;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.3678679599 34.7946441602)' where sgg_cd_pk = 191;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.4648630104 34.9640439068)' where sgg_cd_pk = 192;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.1662179866 34.8112453946)' where sgg_cd_pk = 193;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.3711222905 35.0104419023)' where sgg_cd_pk = 194;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.1238940528 34.7368473807)' where sgg_cd_pk = 195;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.6700727689 34.7576204154)' where sgg_cd_pk = 196;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.4974733368 35.296923189)' where sgg_cd_pk = 197;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.7046533515 34.805811982)' where sgg_cd_pk = 198;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.6913271414 34.3448801145)' where sgg_cd_pk = 199;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.7692371523 35.3387974008)' where sgg_cd_pk = 200;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9577498114 34.6499286876)' where sgg_cd_pk = 201;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.2566740126 34.4699054362)' where sgg_cd_pk = 202;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.5499857653 35.1041429294)' where sgg_cd_pk = 203;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.5668167839 34.5275137434)' where sgg_cd_pk = 204;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.03068659 35.0190077731)' where sgg_cd_pk = 205;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.590874232 35.4379012148)' where sgg_cd_pk = 206;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.7466371418 35.9342384735)' where sgg_cd_pk = 207;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9182079762 35.7924967561)' where sgg_cd_pk = 208;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.480565235 35.4316117503)' where sgg_cd_pk = 209;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.7168813384 35.9283265332)' where sgg_cd_pk = 210;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.7039659575 35.6904988253)' where sgg_cd_pk = 211;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.171825441 35.427752984)' where sgg_cd_pk = 212;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.2452107085 35.8749028515)' where sgg_cd_pk = 213;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.0047487606 36.0200178147)' where sgg_cd_pk = 214;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.26105099829999 35.6187254234)' where sgg_cd_pk = 215;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.5499477424 35.653552293)' where sgg_cd_pk = 216;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.125316211 35.8523940107)' where sgg_cd_pk = 217;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.1340407698 35.7859546267)' where sgg_cd_pk = 218;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.907394178 35.6100876921)' where sgg_cd_pk = 219;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.4570276381 35.8240334506)' where sgg_cd_pk = 220;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.5946493665 33.339238484)' where sgg_cd_pk = 221;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.4816470257 33.419295782)' where sgg_cd_pk = 222;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.224581244 36.2909534879)' where sgg_cd_pk = 223;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.042851491 36.4780211898)' where sgg_cd_pk = 224;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.4697740873 36.1251962018)' where sgg_cd_pk = 225;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.1573414411 36.201695032799996)' where sgg_cd_pk = 226;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.6467569181 36.9070721259)' where sgg_cd_pk = 227;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.6429225597 36.3499767564)' where sgg_cd_pk = 228;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.87142105 36.2291387834)' where sgg_cd_pk = 229;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.4851244999 36.810006851)' where sgg_cd_pk = 230;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.7353671097 36.0961227917)' where sgg_cd_pk = 231;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.9774669031 36.7953877814)' where sgg_cd_pk = 232;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.8505278419 36.6651991767)' where sgg_cd_pk = 233;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.2260296552 36.7559269597)' where sgg_cd_pk = 234;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.1703843948 36.8791145827)' where sgg_cd_pk = 235;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.8476136443 36.4435369892)' where sgg_cd_pk = 236;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.2418599844 36.7809107917)' where sgg_cd_pk = 237;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (126.6081433816 36.5662642216)' where sgg_cd_pk = 238;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.8363203856 36.774303069)' where sgg_cd_pk = 239;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.3866833748 36.9791821794)' where sgg_cd_pk = 240;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.7280453801 36.4913518182)' where sgg_cd_pk = 241;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.7954386464 36.1643666519)' where sgg_cd_pk = 242;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.6521883365 36.3080116913)' where sgg_cd_pk = 243;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.5521674008 36.9946218353)' where sgg_cd_pk = 244;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (128.1550371 37.0349931535)' where sgg_cd_pk = 245;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.592656726 36.780627903)' where sgg_cd_pk = 246;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.4414811379 36.8805408314)' where sgg_cd_pk = 247;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.5092186295 36.712543676)' where sgg_cd_pk = 248;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.5397021296 36.5690965541)' where sgg_cd_pk = 249;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.3784335609 36.6433051673)' where sgg_cd_pk = 250;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.8693961956 37.0057418233)' where sgg_cd_pk = 251;
update sc_khb_srv.tb_com_sgg_cd set sgg_crdnt = 'POINT (127.4153639194 36.5479235433)' where sgg_cd_pk = 252;

SELECT * FROM sc_khb_srv.tb_com_sgg_cd;
SELECT count(*) FROM sc_khb_srv.tb_com_sgg_cd; -- 250
SELECT max(sgg_cd_pk) FROM sc_khb_srv.tb_com_sgg_cd; -- 252

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
-- tb_com_stplat_info
CREATE TABLE sc_khb_srv.tb_com_stplat_info (
  com_stplat_info_pk sc_khb_srv.pk_n18 NOT NULL
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
, ip_adres sc_khb_srv.addr_nv1000
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

SELECT * FROM sc_khb_srv.tb_com_thema_info;
SELECT count(*) FROM sc_khb_srv.tb_com_thema_info; -- 79
SELECT max(thema_info_pk) FROM sc_khb_srv.tb_com_thema_info; -- 79

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
, error_co sc_khb_srv.cnt_n15
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
, lrea_brffc_cd sc_khb_srv.cd_v20
);

BULK INSERT sc_khb_srv.tb_com_user
       FROM 'D:\migra_data\user_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

/**/
BULK INSERT sc_khb_srv.tb_com_user
       FROM 'D:\migra_data\realtor_info_user.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_com_user add constraint pk_tb_com_user primary key(user_no_pk);

SELECT * FROM sc_khb_srv.tb_com_user;
SELECT count(*) FROM sc_khb_srv.tb_com_user; -- 67009
SELECT max(user_no_pk) FROM sc_khb_srv.tb_com_user; -- 67363

/*프로젝트 관리자들 데이터도 나중에 넣어야함 insert문을 만들던지 파일을 만들던지*/

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

SELECT * FROM sc_khb_srv.tb_com_user_group;
SELECT count(*) FROM sc_khb_srv.tb_com_user_group; -- 67009
SELECT max(com_user_group_pk) FROM sc_khb_srv.tb_com_user_group; -- 67009

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
, device_ntcn_reg_cd sc_khb_srv.cd_v20
, lrea_brffc_cd sc_khb_srv.cd_v20
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
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_hsmp_dtl_info
       FROM 'D:\migra_data\danji_detail_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_hsmp_dtl_info add constraint pk_tb_hsmp_dtl_info primary key (hsmp_dtl_info_pk, hsmp_info_pk);

SELECT * FROM sc_khb_srv.tb_hsmp_dtl_info;
SELECT count(*) FROM sc_khb_srv.tb_hsmp_dtl_info; -- 270312
SELECT max(hsmp_dtl_info_pk) FROM sc_khb_srv.tb_hsmp_dtl_info; -- 221 
SELECT max(hsmp_info_pk) FROM sc_khb_srv.tb_hsmp_dtl_info; -- 10055180

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
, rn_addr sc_khb_srv.addr_nv1000
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
, ctgry_cd sc_khb_srv.cd_v20
, mng_office_telno sc_khb_srv.telno_v30
, bus_rte_info sc_khb_srv.cn_nv4000
, subway_rte_info sc_khb_srv.cn_nv4000
, schl_info sc_khb_srv.cn_nv4000
, cvntl_info sc_khb_srv.cn_nv4000
, hsmp_crdnt AS CASE WHEN hsmp_lot IS NULL OR hsmp_lat IS NULL THEN NULL
                     ELSE geometry::STPointFromText(concat('point(', hsmp_lot, ' ', hsmp_lat, ')'), 4326)
                END
, hsmp_lot sc_khb_srv.lot_d13_10
, hsmp_lat sc_khb_srv.lat_d12_10
, use_yn sc_khb_srv.yn_c1
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_hsmp_info
       FROM 'D:\migra_data\danji_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_hsmp_info add constraint pk_tb_hsmp_info primary key(hsmp_info_pk);

--update sc_khb_srv.tb_hsmp_info set hsmp_crdnt = geometry::STPointFromText(hsmp_crdnt_tmp, 4326) WHERE hsmp_crdnt_tmp NOT LIKE '%null%' AND hsmp_crdnt_tmp NOT LIKE '%0.0%';

--alter table sc_khb_srv.tb_hsmp_info drop column hsmp_crdnt_tmp;

SELECT * FROM sc_khb_srv.tb_hsmp_info;
SELECT count(*) FROM sc_khb_srv.tb_hsmp_info; -- 61420
SELECT max(hsmp_info_pk) FROM sc_khb_srv.tb_hsmp_info; -- 10055180 

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_itrst_atlfsl_info => ms
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
, rprs_yn sc_khb_srv.yn_c1
, lttot_tbl_se_cd sc_khb_srv.cd_v20
, house_mng_no sc_khb_srv.no_n15
--, lttot_info_pk sc_khb_srv.pk_n18 -- 열 삭제
);

BULK INSERT sc_khb_srv.tb_itrst_atlfsl_info
       FROM 'D:\migra_data\fav_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_itrst_atlfsl_info add constraint pk_tb_itrst_atlfsl_info primary key(itrst_atlfsl_info_pk);

SELECT * FROM sc_khb_srv.tb_itrst_atlfsl_info;
SELECT count(*) FROM sc_khb_srv.tb_itrst_atlfsl_info; -- 34386
SELECT max(itrst_atlfsl_info_pk) FROM sc_khb_srv.tb_itrst_atlfsl_info; -- 34386

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

SELECT * FROM sc_khb_srv.tb_link_apt_lttot_cmpet_rt_info;
SELECT count(*) FROM sc_khb_srv.tb_link_apt_lttot_cmpet_rt_info; -- 7853

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

SELECT * FROM sc_khb_srv.tb_link_apt_lttot_house_ty_dtl_info;
SELECT count(*) FROM sc_khb_srv.tb_link_apt_lttot_house_ty_dtl_info; -- 8412

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
, stdg_cd sc_khb_srv.cd_v20
, ctpv_cd_pk sc_khb_srv.pk_n18
, sgg_cd_pk sc_khb_srv.pk_n18
, emd_li_cd_pk sc_khb_srv.pk_n18
, lttot_lat sc_khb_srv.lat_d12_10
, lttot_lot sc_khb_srv.lot_d13_10
, lttot_crdnt geometry
);

BULK INSERT sc_khb_srv.tb_link_apt_lttot_info
       FROM 'D:\migra_data\tb_apply_apt_lttot_info_detail.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

UPDATE sc_khb_srv.tb_link_apt_lttot_info 
SET stdg_cd = dp.innb, 
    ctpv_cd_pk = dp.ctpv_cd_pk, 
    sgg_cd_pk = dp.sgg_cd_pk, 
    emd_li_cd_pk = dp.emd_li_cd_pk
  from (
		select tlali.sply_pstn_nm
		     , tccc.ctpv_cd_pk 
		     , tcsc.sgg_cd_pk 
		     , tcelc.emd_li_cd_pk 
		     , tcelc.stdg_dong_cd 
		       as innb
		     , substring(ltrim(replace(tlali.sply_pstn_nm, tccc.ctpv_nm + ' ' + tcsc.sgg_nm + ' ' + tcelc.all_emd_li_nm, '')), 
		                 0, 
		                 PatIndex('%[^0-9,-]%', ltrim(replace(tlali.sply_pstn_nm, tccc.ctpv_nm + ' ' + tcsc.sgg_nm + ' ' + tcelc.all_emd_li_nm, ''))))
		       as jibun
		     , tcelc.all_emd_li_nm
		     , row_number() over (partition by tlali.sply_pstn_nm order by tcelc.emd_li_cd_pk desc) as rn
		  from sc_khb_srv.tb_link_apt_lttot_info tlali
		       left outer join sc_khb_srv.tb_com_ctpv_cd tccc 
		                    on (tlali.sply_pstn_nm like tccc.ctpv_nm + ' %' 
		                    or tlali.sply_pstn_nm like tccc.ctpv_abbrev_nm + ' %')
		       left outer join sc_khb_srv.tb_com_sgg_cd tcsc 
		                    on tcsc.ctpv_cd_pk = tccc.ctpv_cd_pk 
		                   and tlali.sply_pstn_nm like '% ' + tcsc.sgg_nm  + ' %' 
		       left outer join sc_khb_srv.tb_com_emd_li_cd tcelc 
		                    on tcelc.ctpv_cd_pk = tccc.ctpv_cd_pk 
		                   and tcelc.sgg_cd_pk = tcsc.sgg_cd_pk
		                   and tlali.sply_pstn_nm like '% ' + tcelc.all_emd_li_nm + ' %'
		                   and tcelc.stdg_dong_se_cd = 'B'
	   ) dp
 where rn = 1
   AND sc_khb_srv.tb_link_apt_lttot_info.sply_pstn_nm = dp.sply_pstn_nm;

SELECT * FROM sc_khb_srv.tb_link_apt_lttot_info;
SELECT count(*) FROM sc_khb_srv.tb_link_apt_lttot_info; -- 88

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
, stdg_cd sc_khb_srv.cd_v20
, ctpv_cd_pk sc_khb_srv.pk_n18
, sgg_cd_pk sc_khb_srv.pk_n18
, emd_li_cd_pk sc_khb_srv.pk_n18
, lttot_lat sc_khb_srv.lat_d12_10
, lttot_lot sc_khb_srv.lot_d13_10
, lttot_crdnt geometry
);

BULK INSERT sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_info
       FROM 'D:\migra_data\tb_apply_apt_nthg_rank_remndr_hshld_lttot_info_detail.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

UPDATE sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_info
SET stdg_cd= dp.innb, 
    ctpv_cd_pk = dp.ctpv_cd_pk, 
    sgg_cd_pk = dp.sgg_cd_pk, 
    emd_li_cd_pk = dp.emd_li_cd_pk
  from (
		select tlali.sply_pstn_nm
		     , tccc.ctpv_cd_pk 
		     , tcsc.sgg_cd_pk 
		     , tcelc.emd_li_cd_pk 
		     , tcelc.stdg_dong_cd 
		       as innb
		     , substring(ltrim(replace(tlali.sply_pstn_nm, tccc.ctpv_nm + ' ' + tcsc.sgg_nm + ' ' + tcelc.all_emd_li_nm, ''))
		       , 0, PatIndex('%[^0-9,-]%', ltrim(replace(tlali.sply_pstn_nm, tccc.ctpv_nm + ' ' + tcsc.sgg_nm + ' ' + tcelc.all_emd_li_nm, ''))))
		       as jibun
		     , tcelc.all_emd_li_nm
		     , row_number() over (partition by tlali.sply_pstn_nm order by tcelc.emd_li_cd_pk desc) as rn
		  from sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_info tlali
		       left outer join sc_khb_srv.tb_com_ctpv_cd tccc 
		                    on (tlali.sply_pstn_nm like tccc.ctpv_nm + ' %' 
		                    or tlali.sply_pstn_nm like tccc.ctpv_abbrev_nm + ' %')
		       left outer join sc_khb_srv.tb_com_sgg_cd tcsc 
		                    on tcsc.ctpv_cd_pk = tccc.ctpv_cd_pk 
		                   and tlali.sply_pstn_nm like '% ' + tcsc.sgg_nm  + ' %' 
		       left outer join sc_khb_srv.tb_com_emd_li_cd tcelc 
		                    on tcelc.ctpv_cd_pk = tccc.ctpv_cd_pk 
		                   and tcelc.sgg_cd_pk = tcsc.sgg_cd_pk
		                   and tlali.sply_pstn_nm like '% ' + tcelc.all_emd_li_nm + ' %'
		                   and tcelc.stdg_dong_se_cd = 'B'
		       ) dp
 where rn = 1
   AND sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_info.sply_pstn_nm = dp.sply_pstn_nm;

SELECT * FROM sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_info;
SELECT count(*) FROM sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_info; -- 59

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

SELECT * FROM sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_ty_dtl_info;
SELECT count(*) FROM sc_khb_srv.tb_link_apt_nthg_rank_remndr_hh_lttot_ty_dtl_info; -- 2218

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_hsmp_area_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_hsmp_area_info (
  hsmp_cd sc_khb_srv.cd_v20
, hsmp_nm sc_khb_srv.nm_nv500
, ctpv_nm sc_khb_srv.nm_nv500
, sgg_nm sc_khb_srv.nm_nv500
, eupmyeon_nm sc_khb_srv.nm_nv500
, dongli_nm sc_khb_srv.nm_nv500
, aptcmpl_cnt sc_khb_srv.cnt_n15
, totar sc_khb_srv.totar_d19_9
, managect_levy_area sc_khb_srv.area_d19_9
, reside_prvuse_area sc_khb_srv.area_d19_9
, prvuse_area sc_khb_srv.area_d19_9
, hh_cnt sc_khb_srv.cnt_n15
, bdrg_totar sc_khb_srv.totar_d19_9
);

BULK INSERT sc_khb_srv.tb_link_hsmp_area_info
       FROM 'D:\migra_data\tb_k_apt_hsmp_ar_info.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

SELECT * FROM sc_khb_srv.tb_link_hsmp_area_info;
SELECT count(*) FROM sc_khb_srv.tb_link_hsmp_area_info; -- 80320

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_link_hsmp_bsc_info =>  ms
CREATE TABLE sc_khb_srv.tb_link_hsmp_bsc_info (
  hsmp_cd sc_khb_srv.cd_v20 NOT NULL 
, hsmp_nm sc_khb_srv.nm_nv500
, ctpv_nm sc_khb_srv.nm_nv500
, sgg_nm sc_khb_srv.nm_nv500
, eupmyeon_nm sc_khb_srv.nm_nv500
, dongli_nm sc_khb_srv.nm_nv500
, hsmp_clsf_nm sc_khb_srv.nm_nv500
, stdg_addr sc_khb_srv.addr_nv1000
, rn_addr sc_khb_srv.addr_nv1000
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
, mng_office_addr sc_khb_srv.addr_nv1000
, mng_office_telno sc_khb_srv.telno_v30
, mng_office_fxno sc_khb_srv.fxno_v30
, anclr_wlfare_fclt_nm sc_khb_srv.nm_nv500
, join_day sc_khb_srv.day_nv100
, lttot_hh_cnt sc_khb_srv.cnt_n15
, rent_hh_cnt sc_khb_srv.cnt_n15
, top_flr_cnt sc_khb_srv.cnt_n15
, bdrg_top_flr_cnt sc_khb_srv.cnt_n15
, udgd_flr_cnt sc_khb_srv.cnt_n15
, hsmp_lat sc_khb_srv.lat_d12_10
, hsmp_lot sc_khb_srv.lot_d13_10
, hsmp_crdnt geometry
);

BULK INSERT sc_khb_srv.tb_link_hsmp_bsc_info
       FROM 'D:\migra_data\tb_k_apt_hsmp_bass_info.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

UPDATE sc_khb_srv.tb_link_hsmp_bsc_info SET hsmp_crdnt = geometry::STPointFromText(concat('point(', hsmp_lot, ' ', hsmp_lat, ')'), 4326) WHERE hsmp_lat IS NOT NULL;


/*다른 방법*/
--CREATE TABLE sc_khb_srv.tb_link_hsmp_bsc_info (
--  hsmp_cd sc_khb_srv.cd_v20 not null
--, hsmp_nm sc_khb_srv.nm_nv500
--, ctpv_nm sc_khb_srv.nm_nv500
--, sgg_nm sc_khb_srv.nm_nv500
--, eupmyeon_nm sc_khb_srv.nm_nv500
--, dongli_nm sc_khb_srv.nm_nv500
--, hsmp_clsf_nm sc_khb_srv.nm_nv500
--, stdg_addr sc_khb_srv.addr_nv1000
--, rn_addr sc_khb_srv.addr_nv1000
--, lttot_stle_nm sc_khb_srv.nm_nv500
--, use_aprv_day sc_khb_srv.day_nv100
--, aptcmpl_cnt sc_khb_srv.cnt_n15
--, hh_cnt sc_khb_srv.cnt_n15
--, mng_mthd_nm sc_khb_srv.nm_nv500
--, heat_mthd_nm sc_khb_srv.nm_nv500
--, crrdpr_type_nm sc_khb_srv.nm_nv500
--, bldr_nm sc_khb_srv.nm_nv500
--, dvlr_nm sc_khb_srv.nm_nv500
--, house_mng_bsmn_nm sc_khb_srv.nm_nv500
--, gnrl_mng_mthd_nm sc_khb_srv.nm_nv500
--, gnrl_mng_nmpr_cnt sc_khb_srv.cnt_n15
--, expens_mng_mthd_nm sc_khb_srv.nm_nv500
--, expens_mng_nmpr_cnt sc_khb_srv.cnt_n15
--, expens_mng_ctrt_bzenty_nm sc_khb_srv.nm_nv500
--, cln_mng_mthd_nm sc_khb_srv.nm_nv500
--, cln_mng_nmpr_cnt sc_khb_srv.cnt_n15
--, fdndrk_prcs_mthd_nm sc_khb_srv.nm_nv500
--, dsnf_mng_mthd_nm sc_khb_srv.nm_nv500
--, fyer_dsnf_cnt sc_khb_srv.cnt_n15
--, dsnf_mthd_nm sc_khb_srv.nm_nv500
--, bldg_strct_nm sc_khb_srv.nm_nv500
--, elcty_pwrsuply_cpcty sc_khb_srv.cpcty_d25_15
--, hh_elcty_ctrt_mthd_nm sc_khb_srv.nm_nv500
--, elcty_safe_mngr_apnt_mthd_nm sc_khb_srv.nm_nv500
--, fire_rcivr_mthd_nm sc_khb_srv.nm_nv500
--, wsp_mthd_nm sc_khb_srv.nm_nv500
--, elvtr_mng_stle_nm sc_khb_srv.nm_nv500
--, psnger_elvtr_cnt sc_khb_srv.cnt_n15
--, frght_elvtr_cnt sc_khb_srv.cnt_n15
--, psnger_frght_elvtr_cnt sc_khb_srv.cnt_n15
--, pwdbs_elvtr_cnt sc_khb_srv.cnt_n15
--, emgnc_elvtr_cnt sc_khb_srv.cnt_n15
--, etc_elvtr_cnt sc_khb_srv.cnt_n15
--, tot_parkng_cntom sc_khb_srv.cntom_n15
--, grnd_parkng_cnt sc_khb_srv.cnt_n15
--, udgd_parkng_cnt sc_khb_srv.cnt_n15
--, cctv_cnt sc_khb_srv.cnt_n15
--, parkng_cntrl_hrk_yn_nm sc_khb_srv.nm_nv500
--, mngoffice_addr sc_khb_srv.addr_nv1000
--, mngoffice_telno sc_khb_srv.telno_v30
--, mngoffice_fxno sc_khb_srv.fxno_v30
--, anclr_wlfare_fclt_nm sc_khb_srv.nm_nv500
--, join_day sc_khb_srv.day_nv100
--, lttot_hh_cnt sc_khb_srv.cnt_n15
--, rent_hh_cnt sc_khb_srv.cnt_n15
--, top_flr_cnt sc_khb_srv.cnt_n15
--, bdrg_top_flr_cnt sc_khb_srv.cnt_n15
--, udgd_flr_cnt sc_khb_srv.cnt_n15
--, hsmp_lat sc_khb_srv.lat_d12_10
--, hsmp_lot sc_khb_srv.lot_d13_10
--, hsmp_crdnt AS iif(hsmp_lot IS NOT NULL, geometry::STPointFromText(concat('point(', hsmp_lot, ' ', hsmp_lat, ')'), 4326), NULL)
--);
--
--BULK INSERT sc_khb_srv.tb_link_hsmp_bsc_info
--       FROM 'D:\migra_data\tb_k_apt_hsmp_bass_info.txt'
--       WITH (
--             codepage = '65001',
--             fieldterminator = '||',
--             rowterminator = '\n'
--            );

ALTER TABLE sc_khb_srv.tb_link_hsmp_bsc_info ADD CONSTRAINT pk_tb_link_hsmp_bsc_info PRIMARY KEY (hsmp_cd);

SELECT * FROM sc_khb_srv.tb_link_hsmp_bsc_info;
SELECT count(*) FROM sc_khb_srv.tb_link_hsmp_bsc_info; -- 18318

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

SELECT * FROM sc_khb_srv.tb_link_hsmp_managect_info;
SELECT count(*) FROM sc_khb_srv.tb_link_hsmp_managect_info; -- 295882

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

SELECT * FROM sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_cmpet_rt_info;
SELECT count(*) FROM sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_cmpet_rt_info; -- 1090

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
, stdg_cd sc_khb_srv.cd_v20
, ctpv_cd_pk sc_khb_srv.pk_n18
, sgg_cd_pk sc_khb_srv.pk_n18
, emd_li_cd_pk sc_khb_srv.pk_n18
, lttot_lat sc_khb_srv.lat_d12_10
, lttot_lot sc_khb_srv.lot_d13_10
, lttot_crdnt geometry
);

BULK INSERT sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_info
       FROM 'D:\migra_data\tb_apply_ofctl_cty_prvate_rent_lttot_info_detail.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '\n'
            );

UPDATE sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_info
   SET stdg_cd = dp.innb, 
       ctpv_cd_pk = dp.ctpv_cd_pk, 
       sgg_cd_pk = dp.sgg_cd_pk, 
       emd_li_cd_pk = dp.emd_li_cd_pk
  from (
		select tlali.sply_pstn_nm
		     , tccc.ctpv_cd_pk 
		     , tcsc.sgg_cd_pk 
		     , tcelc.emd_li_cd_pk 
		     , tcelc.stdg_dong_cd 
		       as innb
--		     , substring(ltrim(replace(tlali.sply_pstn_nm, tccc.ctpv_nm + ' ' + tcsc.sgg_nm + ' ' + tcelc.all_emd_li_nm, ''))
--		       , 0, PatIndex('%[^0-9,-]%', ltrim(replace(tlali.sply_pstn_nm, tccc.ctpv_nm + ' ' + tcsc.sgg_nm + ' ' + tcelc.all_emd_li_nm, ''))))
--		       as jibun
		     , tcelc.all_emd_li_nm
		     , row_number() over (partition by tlali.sply_pstn_nm order by tcelc.emd_li_cd_pk desc) as rn
		  from sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_info tlali
		       left outer join sc_khb_srv.tb_com_ctpv_cd tccc 
		                    on (tlali.sply_pstn_nm like tccc.ctpv_nm + ' %' 
		                    or tlali.sply_pstn_nm like tccc.ctpv_abbrev_nm + ' %')
		       left outer join sc_khb_srv.tb_com_sgg_cd tcsc 
		                    on tcsc.ctpv_cd_pk = tccc.ctpv_cd_pk 
		                   and tlali.sply_pstn_nm like '% ' + tcsc.sgg_nm  + ' %' 
		       left outer join sc_khb_srv.tb_com_emd_li_cd tcelc 
		                    on tcelc.ctpv_cd_pk = tccc.ctpv_cd_pk 
		                   and tcelc.sgg_cd_pk = tcsc.sgg_cd_pk
		                   and tlali.sply_pstn_nm like '% ' + tcelc.all_emd_li_nm + ' %'
		                   and tcelc.stdg_dong_se_cd = 'B'
		       ) dp
 where rn = 1
   AND sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_info.sply_pstn_nm = dp.sply_pstn_nm;

SELECT * FROM sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_info;
SELECT count(*) FROM sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_info; -- 29

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

SELECT * FROM sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_ty_dtl_info;
SELECT count(*) FROM sc_khb_srv.tb_link_ofctl_cty_prvate_rent_lttot_ty_dtl_info; -- 2527

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

SELECT * FROM sc_khb_srv.tb_link_public_sprt_prvate_rent_lttot_cmpet_rt_info;
SELECT count(*) FROM sc_khb_srv.tb_link_public_sprt_prvate_rent_lttot_cmpet_rt_info; -- 848

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

SELECT * FROM sc_khb_srv.tb_link_remndr_hh_lttot_cmpet_rt_info;
SELECT count(*) FROM sc_khb_srv.tb_link_remndr_hh_lttot_cmpet_rt_info; -- 2071

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

SELECT * FROM sc_khb_srv.tb_link_rtrcn_re_sply_lttot_cmpet_rt_info;
SELECT count(*) FROM sc_khb_srv.tb_link_rtrcn_re_sply_lttot_cmpet_rt_info; -- 142

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
, statn_rn_addr sc_khb_srv.addr_nv1000
, statn_telno sc_khb_srv.telno_v30
, data_crtr_day sc_khb_srv.day_nv100
, statn_crdnt geometry
, stdg_cd sc_khb_srv.cd_v20
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_link_subway_statn_info
       FROM 'D:\migra_data\tb_kric_statn_info.txt'
       WITH (
             codepage = '65001',
             fieldterminator = '||',
             rowterminator = '0x0a'
            );

UPDATE sc_khb_srv.tb_link_subway_statn_info SET statn_crdnt = geometry::STPointFromText(concat('point(',statn_lot, ' ',statn_lat, ')'), 4326);

/*AS 방법*/
--CREATE TABLE sc_khb_srv.tb_link_subway_statn_info (
--  statn_no sc_khb_srv.no_v200
--, statn_nm sc_khb_srv.nm_nv500
--, rte_no sc_khb_srv.no_v200
--, rte_nm sc_khb_srv.nm_nv500
--, eng_statn_nm sc_khb_srv.nm_nv500
--, chcrt_statn_nm sc_khb_srv.nm_nv500
--, trnsit_statn_se_nm sc_khb_srv.nm_nv500
--, trnsit_rte_no sc_khb_srv.no_v200
--, trnsit_rte_nm sc_khb_srv.nm_nv500
--, statn_lat sc_khb_srv.lat_d12_10
--, statn_lot sc_khb_srv.lot_d13_10
--, oper_inst_nm sc_khb_srv.nm_nv500
--, statn_rn_addr sc_khb_srv.addr_nv1000
--, statn_telno sc_khb_srv.telno_v30
--, data_crtr_day sc_khb_srv.day_nv100
--, statn_crdnt AS iif(statn_lot IS NOT NULL, 
--                     geometry::STPointFromText(concat('point(', statn_lot, ' ', statn_lat, ')'), 4326),
--                     NULL
--                    )
--, stdg_cd sc_khb_srv.cd_v20
--, reg_id sc_khb_srv.id_nv100
--, reg_dt sc_khb_srv.dt
--, mdfcn_id sc_khb_srv.id_nv100
--, mdfcn_dt sc_khb_srv.dt
--);
--
--BULK INSERT sc_khb_srv.tb_link_subway_statn_info
--       FROM 'D:\migra_data\tb_kric_statn_info.txt'
--       WITH (
--             codepage = '65001',
--             fieldterminator = '||',
--             rowterminator = '0x0a'
--            );

/*노선명 축약 update*/
UPDATE sc_khb_srv.tb_link_subway_statn_info 
   SET rte_nm = ( 
                 CASE when rte_nm in ('경부선', '경원선', '경인선') then '1호선'
		              when rte_nm in ('3호선', '일산선') then '3호선'
             		  when rte_nm in ('4호선', '안산과천선', '진접선') then '4호선'
		              when rte_nm in ('7호선', '도시철도 7호선') then '7호선'
		              when rte_nm in ('8호선') then '8호선'
		              when rte_nm in ('수도권  도시철도 9호선') then '9호선'
		              when rte_nm in ('인천국제공항선') then '공항'
		              when rte_nm in ('경의중앙선') then '경의중앙'
		              when rte_nm in ('경춘선') then '경춘'
		              when rte_nm in ('수인선', '분당선') then '수인분당'
		              when rte_nm in ('신분당선') then '신분당'
		              when rte_nm in ('경강선') then '경강'
		              when rte_nm in ('서해선') then '서해'
		              when rte_nm in ('인천지하철 1호선') then '인천1'
		              when rte_nm in ('인천지하철 2호선') then '인천2'
		              when rte_nm in ('우이신설선') then '우이신설'
		              when rte_nm in ('김포골드라인') then '김포골드'
		              when rte_nm in ('수도권 경량도시철도 신림선') then '신림'
		              when rte_nm in ('부산 도시철도 1호선') then '1호선'
		              when rte_nm in ('부산 도시철도 2호선') then '2호선'
		              when rte_nm in ('부산 도시철도 3호선') then '3호선'
		              when rte_nm in ('부산 경량도시철도 4호선') then '4호선'
		              when rte_nm in ('부산김해경전철') then '부산김해'
		              when rte_nm in ('동해선') then '동해'
		              when rte_nm in ('대구 도시철도 1호선') then '1호선'
		              when rte_nm in ('대구 도시철도 2호선') then '2호선'
		              when rte_nm in ('대구 도시철도 3호선') then '3호선'
		              when rte_nm in ('광주도시철도 1호선') then '1호선'
		              when rte_nm in ('대전 도시철도 1호선') then '1호선'
		              ELSE rte_nm
	             END
	            );

SELECT * FROM sc_khb_srv.tb_link_subway_statn_info;
SELECT count(*) FROM sc_khb_srv.tb_link_subway_statn_info; -- 1053

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_lrea_office_info => 8777 ms
CREATE TABLE sc_khb_srv.tb_lrea_office_info (
  lrea_office_info_pk sc_khb_srv.pk_n18 NOT NULL
, bzmn_no sc_khb_srv.no_v200
, lrea_office_nm sc_khb_srv.nm_nv500
, lrea_office_rprsv_nm sc_khb_srv.nm_nv500
, tlphon_type_cd sc_khb_srv.cd_v20
, safety_no sc_khb_srv.no_v200
, lrea_office_rprs_telno sc_khb_srv.telno_v30
, lrea_telno sc_khb_srv.telno_v30
, lrea_office_addr sc_khb_srv.addr_nv1000
, ctpv_cd_pk sc_khb_srv.pk_n18
, sgg_cd_pk sc_khb_srv.pk_n18
, stdg_innb sc_khb_srv.innb_v20
, dong_innb sc_khb_srv.innb_v20
, user_level_no sc_khb_srv.no_v200
, rprs_img_one_url sc_khb_srv.url_nv4000
, rprs_img_two_url sc_khb_srv.url_nv4000
, rprs_img_three_url sc_khb_srv.url_nv4000
, lat sc_khb_srv.lat_d12_10
, lot sc_khb_srv.lot_d13_10
, user_ty_cd sc_khb_srv.cd_v20
, stts_cd sc_khb_srv.cd_v20
, use_yn sc_khb_srv.yn_c1
, lrea_office_crdnt geometry
, hmpg_url sc_khb_srv.url_nv4000
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
, lrea_office_intrcn_cn sc_khb_srv.cn_nvmax
, eml sc_khb_srv.varchar
);

/*AS 방법*/
--CREATE TABLE sc_khb_srv.tb_lrea_office_info (
--  lrea_office_info_pk sc_khb_srv.pk_n18 NOT NULL
--, bzmn_no sc_khb_srv.no_v200
--, lrea_office_nm sc_khb_srv.nm_nv500
--, lrea_office_rprsv_nm sc_khb_srv.nm_nv500
--, tlphon_type_cd sc_khb_srv.cd_v20
--, safety_no sc_khb_srv.no_v200
--, lrea_office_rprs_telno sc_khb_srv.telno_v30
--, lrea_telno sc_khb_srv.telno_v30
--, lrea_office_addr sc_khb_srv.addr_nv1000
--, ctpv_cd_pk sc_khb_srv.pk_n18
--, sgg_cd_pk sc_khb_srv.pk_n18
--, stdg_innb sc_khb_srv.innb_v20
--, dong_innb sc_khb_srv.innb_v20
--, user_level_no sc_khb_srv.no_v200
--, rprs_img_one_url sc_khb_srv.url_nv4000
--, rprs_img_two_url sc_khb_srv.url_nv4000
--, rprs_img_three_url sc_khb_srv.url_nv4000
--, lat sc_khb_srv.lat_d12_10
--, lot sc_khb_srv.lot_d13_10
--, user_ty_cd sc_khb_srv.cd_v20
--, stts_cd sc_khb_srv.cd_v20
--, use_yn sc_khb_srv.yn_c1
--, lrea_office_crdnt AS CASE WHEN lat IS NULL OR lat = 0 THEN NULL 
--                            ELSE geometry::STPointFromText(concat('point(', lot, ' ', lat, ')'), 4326)
--                       END
--, hmpg_url sc_khb_srv.url_nv4000
--, reg_id sc_khb_srv.id_nv100
--, reg_dt sc_khb_srv.dt
--, mdfcn_id sc_khb_srv.id_nv100
--, mdfcn_dt sc_khb_srv.dt
--, lrea_office_intrcn_cn sc_khb_srv.cn_nvmax
--);
--
--BULK INSERT sc_khb_srv.tb_lrea_office_info
--       FROM 'D:\migra_data\realtor_info_test.txt'
--       WITH (
--             CODEPAGE = '65001',
--             FIELDTERMINATOR = '||',
--             ROWTERMINATOR = '0x0a'
--);

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

SELECT * FROM sc_khb_srv.tb_lrea_office_info;
SELECT count(*) FROM sc_khb_srv.tb_lrea_office_info; -- 200996
SELECT max(lrea_office_info_pk) FROM sc_khb_srv.tb_lrea_office_info; -- 1601795

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_lrea_schdl_ntcn_info =>  ms 
CREATE TABLE sc_khb_srv.tb_lrea_schdl_ntcn_info (
  lrea_schdl_ntcn_info_pk sc_khb_srv.pk_n18 NOT NULL
, schdl_se_cd sc_khb_srv.cd_v20
, schdl_type_cd sc_khb_srv.cd_v20
, lrea_office_info_pk sc_khb_srv.pk_n18
, schdl_se_pk sc_khb_srv.pk_n18
, schdl_ntcn_day sc_khb_srv.day_nv100
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_lrea_schdl_ntcn_info add constraint pk_tb_lrea_schdl_ntcn_info primary key(lrea_schdl_ntcn_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_lrea_sns_url_info =>  ms 
CREATE TABLE sc_khb_srv.tb_lrea_sns_url_info (
  lrea_sns_url_info_pk sc_khb_srv.pk_n18 NOT NULL
, lrea_office_info_pk sc_khb_srv.pk_n18
, sns_cd sc_khb_srv.cd_v20
, sns_url sc_khb_srv.url_nv4000
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_lrea_sns_url_info add constraint pk_tb_lrea_sns_url_info primary key(lrea_sns_url_info_pk);

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_lrea_spclty_fld_info =>  ms 
CREATE TABLE sc_khb_srv.tb_lrea_spclty_fld_info (
  lrea_spclty_fld_info_pk sc_khb_srv.pk_n18 NOT NULL
, lrea_office_info_pk sc_khb_srv.pk_n18
, spclty_fld_cd sc_khb_srv.cd_v20
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_lrea_spclty_fld_info add constraint pk_tb_lrea_spclty_fld_info primary key(lrea_spclty_fld_info_pk);

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
, dtl_addr sc_khb_srv.addr_nv1000
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
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

BULK INSERT sc_khb_srv.tb_lttot_info
       FROM 'D:\migra_data\bunyang_info.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_lttot_info add constraint pk_tb_lttot_info primary key(lttot_info_pk);

SELECT * FROM sc_khb_srv.tb_lttot_info;
SELECT count(*) FROM sc_khb_srv.tb_lttot_info; -- 1241
SELECT max(lttot_info_pk) FROM sc_khb_srv.tb_lttot_info; -- 1309

/*테이블 만들고 다시 tb_com_job_schdl_info테이블로 돌아가서 update*/

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
, inqire_co sc_khb_srv.cnt_n15
, use_provd_co sc_khb_srv.cnt_n15
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

SELECT * FROM sc_khb_srv.tb_user_atlfsl_img_info;
SELECT count(*) FROM sc_khb_srv.tb_user_atlfsl_img_info; -- 158442
SELECT max(user_atlfsl_img_info_pk) FROM sc_khb_srv.tb_user_atlfsl_img_info; -- 158442

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
, dtl_addr sc_khb_srv.addr_nv1000
);

BULK INSERT sc_khb_srv.tb_user_atlfsl_info
       FROM 'D:\migra_data\user_mamul.txt'
       WITH (
             CODEPAGE = '65001',
             FIELDTERMINATOR = '||',
             ROWTERMINATOR = '0x0a'
);

alter table sc_khb_srv.tb_user_atlfsl_info add constraint pk_tb_user_atlfsl_info primary key(user_atlfsl_info_pk);

SELECT * FROM sc_khb_srv.tb_user_atlfsl_info;
SELECT count(*) FROM sc_khb_srv.tb_user_atlfsl_info; -- 20513
SELECT max(user_atlfsl_info_pk) FROM sc_khb_srv.tb_user_atlfsl_info; -- 20905

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_user_atlfsl_preocupy_info
CREATE TABLE sc_khb_srv.tb_user_atlfsl_preocupy_info (
  user_atlfsl_preocupy_info_pk sc_khb_srv.pk_n18 NOT NULL
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

alter table sc_khb_srv.tb_user_atlfsl_preocupy_info add constraint pk_tb_user_atlfsl_preocupy_info primary key(user_atlfsl_preocupy_info_pk);

SELECT * FROM sc_khb_srv.tb_user_atlfsl_preocupy_info;
SELECT count(*) FROM sc_khb_srv.tb_user_atlfsl_preocupy_info; -- 23200
SELECT max(user_atlfsl_preocupy_info_pk) FROM sc_khb_srv.tb_user_atlfsl_preocupy_info; -- 23200

SET STATISTICS io OFF;
---------------------------------------------------------------------------------------------------
SET STATISTICS time ON;
SET STATISTICS io ON;
-- tb_user_atlfsl_thema_info
CREATE TABLE sc_khb_srv.tb_user_atlfsl_thema_info (
  user_atlfsl_thema_info_pk sc_khb_srv.pk_n18 NOT NULL
, user_atlfsl_info_pk sc_khb_srv.pk_n18
, thema_info_pk sc_khb_srv.pk_n18
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

alter table sc_khb_srv.tb_user_atlfsl_thema_info add constraint pk_tb_user_atlfsl_thema_info primary key(user_atlfsl_thema_info_pk);

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




































