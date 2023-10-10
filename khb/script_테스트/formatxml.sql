/*
작성일 : 230821
수정일 : 230822
작성자 : 조건영
작성 목적 : point(경도 위도) 텍스트 파일을 바로 geometry타입으로 저장 시키기 위해
          새로운 방법인 insert into openrowset을 찾았다.
          여기에는 이관할 파일과 format 파일이 있어야 한다.

참조 사이트
 1. xsi:type => format xml 파일의 타입 정리
  - https://learn.microsoft.com/en-us/openspecs/sql_data_portability/ms-bcp/51298f0a-c9ac-463a-8e01-76d25ebaca3c
*/


-- format xml파일 내용 작성 쿼리 => 테이블 이름을 직접 지정
SELECT TABLE_NAME 
     , concat('<?xml version="1.0" encoding="utf-8"?>', char(10),
              '<BCPFORMAT xmlns="http://schemas.microsoft.com/sqlserver/2004/bulkload/format" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">', char(10),
              '<RECORD>', char(10),
              replace(
                      replace(
                              stuff((
                                     SELECT '<FIELD ID="' + 
                                            CAST(ROW_NUMBER() OVER (ORDER BY ORDINAL_POSITION) AS varchar(4000)) + 
                                            '" xsi:type="CharTerm" TERMINATOR="' +
                                            CASE WHEN ORDINAL_POSITION = (SELECT max(ORDINAL_POSITION) 
                                                                            FROM information_schema.columns
                                                                           WHERE TABLE_SCHEMA = 'sc_khb_srv'
                                                                             AND table_name = 'tb_lrea_office_info') 
                                                                                                                   THEN '\n'
                                                 ELSE '||'
                                            END + 
                                            '" MAX_LENGTH="' +
                                            CASE WHEN DATA_TYPE IN ('char', 'nvarchar', 'varchar') THEN 
                                                                                                        CASE WHEN COLUMN_NAME LIKE '%:_cn' ESCAPE ':' THEN '2147483647'
	                                                                                                         WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN '4000'
                                                                                                             ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS nvarchar(4000))
                                                                                                        END
                                                 WHEN DATA_TYPE IN ('decimal', 'int', 'numeric') THEN CAST(NUMERIC_PRECISION+NUMERIC_SCALE AS nvarchar(4000))
                                                 WHEN DATA_TYPE IN ('datetime', 'geometry') THEN '4000'
                                            END + '"/>' + char(10)
                                       FROM information_schema.columns c1
                                      WHERE c1.TABLE_NAME = c2.TABLE_NAME
                                        FOR xml PATH('')), 1, 0, ''),'&lt;', '<'), '&gt;', '>'),
              '</RECORD>', char(10),
              '<ROW>', char(10),
              replace(
                      replace(
                              stuff((
                                     SELECT '<COLUMN SOURCE="' + 
                                            CAST(ROW_NUMBER() OVER (ORDER BY ORDINAL_POSITION) AS varchar(4000)) + 
                                            '" NAME="' +
                                            COLUMN_NAME + 
                                            '" xsi:type="' +
                                            CASE WHEN DATA_TYPE = 'char' THEN 'SQLCHAR'
                                                 WHEN DATA_TYPE = 'nvarchar' THEN 'SQLNVARCHAR'
                                                 WHEN DATA_TYPE = 'varchar' THEN 'SQLVARYCHAR'
                                                 WHEN DATA_TYPE = 'decimal' THEN 'SQLFLT8'
                                                 WHEN DATA_TYPE = 'int' THEN 'SQLINT'
                                                 WHEN DATA_TYPE = 'numeric' THEN 'SQLNUMERIC'
                                                 WHEN DATA_TYPE = 'datetime' THEN 'SQLDATETIME'
                                                 WHEN DATA_TYPE = 'geometry' THEN 'SQLNVARCHAR'
                                            END +'"/>' + char(10)
                                       FROM information_schema.columns c1
                                      WHERE c1.TABLE_NAME = c2.TABLE_NAME
                                        FOR xml PATH('')), 1, 0, ''),'&lt;', '<'), '&gt;', '>'), 
              '</ROW>', char(10),
              '</BCPFORMAT>')
  FROM information_schema.columns c2
 WHERE TABLE_SCHEMA = 'sc_khb_srv'
   AND table_name = 'tb_lrea_office_info'
 GROUP BY TABLE_NAME;
/*
테이블 이름 변경시 서브쿼리에 있는 where절에도 테이블 이름을 변경 해주어야 한다. => 총 2개의 조건을 변경 시켜야 함
*/


-- 테이블 생성 쿼리
SELECT DISTINCT c2.TABLE_NAME "테이블명",
       'CREATE TABLE ' + c2.TABLE_SCHEMA + '.' + c2.TABLE_NAME + ' (' + char(13) + '  ' +
       replace(
			   stuff((
			          SELECT ', ' + c1.COLUMN_NAME + ' ' + 
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
		                            AND sc.name = c1.COLUMN_NAME
		               WHERE c1.TABLE_NAME = c2.TABLE_name
		               ORDER BY ORDINAL_POSITION
		              	 FOR xml PATH('')
		             ), 1, 2, '') +
		             CASE WHEN c2.TABLE_NAME = 'tb_com_emd_li_cd' THEN ', emd_li_crdnt_tmp sc_khb_srv.crdnt_v500' + char(13)
		                  ELSE ''
		             END,
               '&#x0D;', ''
              ) + ');' "테이블별 작성 스크립트"
  FROM information_schema.columns c2
 WHERE c2.TABLE_SCHEMA = 'sc_khb_srv'
 GROUP BY c2.TABLE_SCHEMA, c2.TABLE_NAME 
 ORDER BY 1;


-- insert into openrowset
SELECT TABLE_NAME
     , 'insert into ' + c2.TABLE_SCHEMA + '.' + c2.TABLE_NAME + char(10) +
       'select' + char(10) +
       '  ' +
       stuff(
             (SELECT ', a.' + COLUMN_NAME + char(10)
                FROM information_schema.columns c1
               WHERE c1.TABLE_NAME = c2.TABLE_NAME
               ORDER BY c1.ORDINAL_POSITION
                 FOR xml PATH('')
             )
            , 1, 2, '') + 
       '  from openrowset(
                  bulk ''D:\migra_data\.txt''
                , FORMATFILE = ''D:\formatxml\' + c2.TABLE_NAME + '.xml''
                , codepage = 65001
                 ) as a;'
  FROM information_schema.columns c2
 WHERE TABLE_SCHEMA = 'sc_khb_srv'
 GROUP BY c2.TABLE_SCHEMA, c2.TABLE_NAME;
/*파일명은 직접 지정하자!!!*/


-- format xml파일 내용 작성 쿼리 => 전체 테이블
--SELECT TABLE_NAME 
--     , concat('<?xml version="1.0" encoding="utf-8"?>', char(10),
--              '<BCPFORMAT xmlns="http://schemas.microsoft.com/sqlserver/2004/bulkload/format" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">', char(10),
--              '<RECORD>', char(10),
--              replace(
--                      replace(
--                              stuff((
--                                     SELECT '<FIELD ID="' + 
--                                            CAST(ROW_NUMBER() OVER (ORDER BY ORDINAL_POSITION) AS varchar(4000)) + 
--                                            '" xsi:type="CharTerm" TERMINATOR="' +
--                                            CASE WHEN ORDINAL_POSITION = (SELECT max(ORDINAL_POSITION) 
--                                                                            FROM information_schema.columns
--                                                                           WHERE TABLE_SCHEMA = 'sc_khb_srv'
--                                                                         ) 
--                                                                           THEN '\n'
--                                                 ELSE '||'
--                                            END + 
--                                            '" MAX_LENGTH="' +
--                                            CASE WHEN DATA_TYPE IN ('char', 'nvarchar', 'varchar') THEN 
--                                                                                                        CASE WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN '4000'
--                                                                                                             ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS nvarchar(4000))
--                                                                                                        END
--                                                 WHEN DATA_TYPE IN ('decimal', 'int', 'numeric') THEN CAST(NUMERIC_PRECISION+NUMERIC_SCALE AS nvarchar(4000))
--                                                 WHEN DATA_TYPE IN ('datetime', 'geometry') THEN '4000'
--                                            END + '"/>' + char(10)
--                                       FROM information_schema.columns c1
--                                      WHERE c1.TABLE_NAME = c2.TABLE_NAME
--                                        FOR xml PATH('')), 1, 0, ''),'&lt;', '<'), '&gt;', '>'),
--              '</RECORD>', char(10),
--              '<ROW>', char(10),
--              replace(
--                      replace(
--                              stuff((
--                                     SELECT '<COLUMN SOURCE="' + 
--                                            CAST(ROW_NUMBER() OVER (ORDER BY ORDINAL_POSITION) AS varchar(4000)) + 
--                                            '" NAME="' +
--                                            COLUMN_NAME + 
--                                            '" xsi:type="' +
--                                            CASE WHEN DATA_TYPE = 'char' THEN 'SQLCHAR'
--                                                 WHEN DATA_TYPE = 'nvarchar' THEN 'SQLNVARCHAR'
--                                                 WHEN DATA_TYPE = 'varchar' THEN 'SQLVARYCHAR'
--                                                 WHEN DATA_TYPE = 'decimal' THEN 'SQLFLT8'
--                                                 WHEN DATA_TYPE = 'int' THEN 'SQLINT'
--                                                 WHEN DATA_TYPE = 'numeric' THEN 'SQLNUMERIC'
--                                                 WHEN DATA_TYPE = 'datetime' THEN 'SQLDATETIME'
--                                                 WHEN DATA_TYPE = 'geometry' THEN 'SQLNVARCHAR'
--                                            END +'"/>' + char(10)
--                                       FROM information_schema.columns c1
--                                      WHERE c1.TABLE_NAME = c2.TABLE_NAME
--                                        FOR xml PATH('')), 1, 0, ''),'&lt;', '<'), '&gt;', '>'), 
--              '</ROW>', char(10),
--              '</BCPFORMAT>')
--  FROM information_schema.columns c2
-- WHERE TABLE_SCHEMA = 'sc_khb_srv'
--   AND TABLE_NAME NOT LIKE '%vw:_%' ESCAPE ':'
-- GROUP BY TABLE_NAME;
/*
마지막 열에만 '\n' 붙이는 경우가 있는데 전체 테이블로 할 경우 특정한 열에 대해서만
max값인 열 번호를 지정 할 수 없어서 마지막 열에도 '||'가 나오는 경우가 있다.
*/


/*모든 테이블의 생성 삭제 연습은 162번에서 했다!!!*/

-- tb_atlfsl_batch_hstry
DROP TABLE sc_khb_srv.tb_atlfsl_batch_hstry;

CREATE TABLE sc_khb_srv.tb_atlfsl_batch_hstry (
  atlfsl_batch_hstry_pk sc_khb_srv.pk_n18 NOT NULL
, cntnts_no sc_khb_srv.no_n15
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
, hstry_se_cd sc_khb_srv.cd_v20
, rslt_cd sc_khb_srv.cd_v20
, job_dt sc_khb_srv.dt
, err_cn sc_khb_srv.cn_nvmax
);

insert into sc_khb_srv.tb_atlfsl_batch_hstry
select
  a.atlfsl_batch_hstry_pk
, a.cntnts_no
, a.atlfsl_bsc_info_pk
, a.hstry_se_cd
, a.rslt_cd
, a.job_dt
, a.err_cn
  from openrowset(
                  bulk 'D:\migra_data\product_batch_history.txt'
                , FORMATFILE = 'D:\formatxml\tb_atlfsl_batch_hstry.xml'
                , codepage = 65001
                 ) as a;

ALTER TABLE sc_khb_srv.tb_atlfsl_batch_hstry ADD CONSTRAINT pk_atlfsl_batch_hstry_pk PRIMARY KEY (atlfsl_batch_hstry_pk);

SELECT * FROM sc_khb_srv.tb_atlfsl_batch_hstry;



-- tb_atlfsl_bsc_info
DROP TABLE sc_khb_srv.tb_atlfsl_bsc_info;

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
, land_area sc_khb_srv.decimal
, qota_area sc_khb_srv.decimal
, use_inspct_day sc_khb_srv.nvarchar
, bldg_usg_cd sc_khb_srv.varchar
, lndr_se_cd sc_khb_srv.varchar
, ktchn_se_cd sc_khb_srv.varchar
, btr_se_cd sc_khb_srv.varchar
, blcn_estn_yn sc_khb_srv.char
, power_vl sc_khb_srv.decimal
, room_one_cnt sc_khb_srv.numeric
, room_two_cnt sc_khb_srv.numeric
, room_three_cnt sc_khb_srv.numeric
, room_four_cnt sc_khb_srv.numeric
);

insert into sc_khb_srv.tb_atlfsl_bsc_info
select
  a.atlfsl_bsc_info_pk
, a.asoc_atlfsl_no
, a.asoc_app_intrlck_no
, a.lrea_office_info_pk
, a.ctpv_cd_pk
, a.sgg_cd_pk
, a.emd_li_cd_pk
, a.hsmp_info_pk
, a.hsmp_dtl_info_pk
, a.atlfsl_ty_cd
, a.atlfsl_dtl_ty_cd
, a.atlfsl_knd_cd
, a.stdg_dong_cd
, a.stdg_cd
, a.stdg_innb
, a.dong_innb
, a.mno
, a.sno
, a.aptcmpl_nm
, a.ho_nm
, a.atlfsl_crdnt
, a.atlfsl_lot
, a.atlfsl_lat
, a.atlfsl_trsm_dt
, a.bldg_aptcmpl_indct_yn
, a.pyeong_indct_yn
, a.vr_exst_yn
, a.img_exst_yn
, a.thema_cd_list
, a.pic_no
, a.pic_nm
, a.pic_telno
, a.dtl_scrn_prsl_cnt
, a.prvuse_area
, a.sply_area
, a.plot_area
, a.arch_area
, a.room_cnt
, a.toilet_cnt
, a.atlfsl_inq_cnt
, a.flr_expsr_mthd_cd
, a.now_flr_expsr_mthd_cd
, a.flr_cnt
, a.top_flr_cnt
, a.grnd_flr_cnt
, a.udgd_flr_cnt
, a.stairs_stle_cd
, a.drc_cd
, a.blcn_cd
, a.pstn_expln_cn
, a.parkng_psblty_yn
, a.parkng_cnt
, a.cmcn_day
, a.financ_amt
, a.use_yn
, a.clustr_info_stts_cd
, a.push_stts_cd
, a.rcmdtn_yn
, a.auc_yn
, a.atlfsl_stts_cd
, a.totar
, a.atlfsl_vrfc_yn
, a.atlfsl_vrfc_day
, a.reg_id
, a.reg_dt
, a.mdfcn_id
, a.mdfcn_dt
  from openrowset(
                  bulk 'D:\migra_data\product_info_openrowset.txt'
                , FORMATFILE = 'D:\formatxml\tb_atlfsl_bsc_info.xml'
                , codepage = 65001
                 ) as a;

ALTER TABLE sc_khb_srv.tb_atlfsl_bsc_info ADD CONSTRAINT pk_tb_atlfsl_bsc_info PRIMARY KEY (atlfsl_bsc_info_pk);

SELECT * FROM sc_khb_srv.tb_atlfsl_bsc_info;



-- tb_atlfsl_cfr_fclt_info
DROP TABLE sc_khb_srv.tb_atlfsl_cfr_fclt_info;

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

insert into sc_khb_srv.tb_atlfsl_cfr_fclt_info
select
  a.atlfsl_cfr_fclt_info_pk
, a.atlfsl_bsc_info_pk
, a.heat_mthd_cd_list
, a.heat_fuel_cd_list
, a.arclng_fclt_cd_list
, a.lvlh_fclt_cd_list
, a.scrty_fclt_cd_list
, a.etc_fclt_cd_list
, a.arclng_mthd_cd_list
, a.reg_dt
, a.mdfcn_dt
  from openrowset(
                  bulk 'D:\migra_data\facilities_info.txt'
                , FORMATFILE = 'D:\formatxml\tb_atlfsl_cfr_fclt_info.xml'
                , codepage = 65001
                 ) as a;

alter table sc_khb_srv.tb_atlfsl_cfr_fclt_info add constraint pk_tb_atlfsl_cfr_fclt_info primary key(atlfsl_cfr_fclt_info_pk);



-- tb_atlfsl_dlng_info
DROP TABLE sc_khb_srv.tb_atlfsl_dlng_info;

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

insert into sc_khb_srv.tb_atlfsl_dlng_info
select
  a.atlfsl_dlng_info_pk
, a.atlfsl_bsc_info_pk
, a.dlng_se_cd
, a.trde_amt
, a.lfsts_amt
, a.mtht_amt
, a.financ_amt
, a.now_lfsts_amt
, a.now_mtht_amt
, a.premium
, a.reg_dt
, a.mdfcn_dt
, a.mng_amt
  from openrowset(
                  bulk 'D:\migra_data\.txt'
                , FORMATFILE = 'D:\formatxml\tb_atlfsl_dlng_info.xml'
                , codepage = 65001
                 ) as a;

insert into sc_khb_srv.tb_atlfsl_dlng_info
select
  a.atlfsl_dlng_info_pk
, a.atlfsl_bsc_info_pk
, a.dlng_se_cd
, a.trde_amt
, a.lfsts_amt
, a.mtht_amt
, a.financ_amt
, a.now_lfsts_amt
, a.now_mtht_amt
, a.premium
, a.reg_dt
, a.mdfcn_dt
, a.mng_amt
  from openrowset(
                  bulk 'D:\migra_data\trade_info.txt'
                , FORMATFILE = 'D:\formatxml\tb_atlfsl_dlng_info.xml'
                , codepage = 65001
                 ) as a;

alter table sc_khb_srv.tb_atlfsl_dlng_info add constraint pk_tb_atlfsl_dlng_info primary key(atlfsl_dlng_info_pk);



-- tb_atlfsl_etc_info
DROP TABLE sc_khb_srv.tb_atlfsl_etc_info;

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

insert into sc_khb_srv.tb_atlfsl_etc_info
select
  a.atlfsl_etc_info_pk
, a.atlfsl_bsc_info_pk
, a.mvn_se_cd
, a.mvn_psblty_wthn_month_cnt
, a.mvn_psblty_aftr_month_cnt
, a.mvn_cnsltn_psblty_yn
, a.atlfsl_sfe_expln_cn
, a.entry_road_yn
, a.atlfsl_expln_cn
, a.reg_dt
, a.mdfcn_dt
  from openrowset(
                  bulk 'D:\migra_data\etc_info.txt'
                , FORMATFILE = 'D:\formatxml\tb_atlfsl_etc_info.xml'
                , codepage = 65001
                 ) as a;

alter table sc_khb_srv.tb_atlfsl_etc_info add constraint pk_tb_atlfsl_etc_info primary key(atlfsl_etc_info_pk);



-- tb_atlfsl_img_info
DROP TABLE sc_khb_srv.tb_atlfsl_img_info;

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

insert into sc_khb_srv.tb_atlfsl_img_info
select
  a.atlfsl_img_info_pk
, a.atlfsl_bsc_info_pk
, a.img_sn
, a.img_ty_cd
, a.img_file_nm
, a.img_expln_cn
, a.img_url
, a.thumb_img_url
, a.orgnl_img_url
, a.img_sort_ordr
  from openrowset(
                  bulk 'D:\migra_data\product_img_info.txt'
                , FORMATFILE = 'D:\formatxml\tb_atlfsl_img_info.xml'
                , codepage = 65001
                 ) as a;

alter table sc_khb_srv.tb_atlfsl_img_info add constraint pk_tb_atlfsl_img_info primary key(atlfsl_img_info_pk);



-- tb_atlfsl_inqry_info


-- tb_atlfsl_land_usg_info
DROP TABLE sc_khb_srv.tb_atlfsl_land_usg_info;

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

insert into sc_khb_srv.tb_atlfsl_land_usg_info
select
  a.atlfsl_land_usg_info_pk
, a.atlfsl_bsc_info_pk
, a.usg_rgn_se_cd
, a.trit_utztn_yn
, a.ctypln_yn
, a.arch_prmsn_yn
, a.land_dlng_prmsn_yn
, a.reg_dt
, a.mdfcn_dt
  from openrowset(
                  bulk 'D:\migra_data\grnd_info.txt'
                , FORMATFILE = 'D:\formatxml\tb_atlfsl_land_usg_info.xml'
                , codepage = 65001
                 ) as a;

alter table sc_khb_srv.tb_atlfsl_land_usg_info add constraint pk_tb_atlfsl_land_usg_info primary key(atlfsl_land_usg_info_pk);

SELECT * FROM sc_khb_srv.tb_atlfsl_land_usg_info;



-- tb_atlfsl_thema_info
DROP TABLE sc_khb_srv.tb_atlfsl_thema_info;

CREATE TABLE sc_khb_srv.tb_atlfsl_thema_info (
  atlfsl_thema_info_pk sc_khb_srv.pk_n18 NOT NULL
, atlfsl_bsc_info_pk sc_khb_srv.pk_n18
, thema_info_pk sc_khb_srv.pk_n18
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

insert into sc_khb_srv.tb_atlfsl_thema_info
select
  a.atlfsl_thema_info_pk
, a.atlfsl_bsc_info_pk
, a.thema_info_pk
, a.reg_id
, a.reg_dt
, a.mdfcn_id
, a.mdfcn_dt
  from openrowset(
                  bulk 'D:\migra_data\product_thema.txt'
                , FORMATFILE = 'D:\formatxml\tb_atlfsl_thema_info.xml'
                , codepage = 65001
                 ) as a;

alter table sc_khb_srv.tb_atlfsl_thema_info add constraint pk_tb_atlfsl_thema_info primary key(atlfsl_thema_info_pk);

SELECT * FROM sc_khb_srv.tb_atlfsl_thema_info;



-- tb_com_author


-- tb_com_banner_info
DROP TABLE sc_khb_srv.tb_com_banner_info;

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

insert into sc_khb_srv.tb_com_banner_info
select
  a.banner_info_pk
, a.banner_ty_cd
, a.banner_se_cd
, a.thumb_img_url
, a.banner_ordr
, a.use_yn
, a.url
, a.img_url
, a.dtl_cn
, a.reg_id
, a.reg_dt
, a.mdfcn_id
, a.mdfcn_dt
  from openrowset(
                  bulk 'D:\migra_data\banner_info.txt'
                , FORMATFILE = 'D:\formatxml\tb_com_banner_info.xml'
                , codepage = 65001
                 ) as a;

alter table sc_khb_srv.tb_com_banner_info add constraint pk_tb_com_banner_info primary key(banner_info_pk);

SELECT * FROM sc_khb_srv.tb_com_banner_info;



-- tb_com_bbs
DROP TABLE sc_khb_srv.tb_com_bbs;

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

insert into sc_khb_srv.tb_com_bbs
select
  a.bbs_pk
, a.bbs_se_cd
, a.ttl_nm
, a.cn
, a.del_yn
, a.rgtr_nm
, a.reg_id
, a.reg_dt
, a.mdfcn_id
, a.mdfcn_dt
  from openrowset(
                  bulk 'D:\migra_data\board_info.txt'
                , FORMATFILE = 'D:\formatxml\tb_com_bbs.xml'
                , codepage = 65001
                 ) as a;

alter table sc_khb_srv.tb_com_bbs add constraint pk_tb_com_bbs primary key(bbs_pk);

SELECT * FROM sc_khb_srv.tb_com_bbs;



-- tb_com_bbs_cmnt
DROP TABLE sc_khb_srv.tb_com_bbs_cmnt;

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

insert into sc_khb_srv.tb_com_bbs_cmnt
select
  a.bbs_cmnt_pk
, a.bbs_pk
, a.cn
, a.del_yn
, a.rgtr_nm
, a.reg_id
, a.reg_dt
, a.mdfcn_id
, a.mdfcn_dt
  from openrowset(
                  bulk 'D:\migra_data\board_comment.txt'
                , FORMATFILE = 'D:\formatxml\tb_com_bbs_cmnt.xml'
                , codepage = 65001
                 ) as a;

alter table sc_khb_srv.tb_com_bbs_cmnt add constraint pk_tb_com_bbs_cmnt primary key(bbs_cmnt_pk);

SELECT * FROM sc_khb_srv.tb_com_bbs_cmnt;



-- tb_com_code
DROP TABLE sc_khb_srv.tb_com_code;

CREATE TABLE sc_khb_srv.tb_com_code (
  code_pk sc_khb_srv.pk_n18 NOT NULL
, parnts_code_pk sc_khb_srv.pk_n18
, code sc_khb_srv.cd_v20 
, code_nm sc_khb_srv.nm_nv500 
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

insert into sc_khb_srv.tb_com_code
select
  a.code_pk
, a.parnts_code_pk
, a.code
, a.code_nm
, a.sort_ordr
, a.use_at
, a.regist_id
, a.regist_dt
, a.updt_id
, a.updt_dt
, a.rm_cn
, a.parnts_code
  from openrowset(
                  bulk 'D:\migra_data\com_code_dea.txt'
                , FORMATFILE = 'D:\formatxml\tb_com_code.xml'
                , codepage = 65001
                 ) as a;

insert into sc_khb_srv.tb_com_code
select
  a.code_pk
, a.parnts_code_pk
, a.code
, a.code_nm
, a.sort_ordr
, a.use_at
, a.regist_id
, a.regist_dt
, a.updt_id
, a.updt_dt
, a.rm_cn
, a.parnts_code
  from openrowset(
                  bulk 'D:\migra_data\com_code_so.txt'
                , FORMATFILE = 'D:\formatxml\tb_com_code.xml'
                , codepage = 65001
                 ) as a;

insert into sc_khb_srv.tb_com_code
select
  a.code_pk
, a.parnts_code_pk
, a.code
, a.code_nm
, a.sort_ordr
, a.use_at
, a.regist_id
, a.regist_dt
, a.updt_id
, a.updt_dt
, a.rm_cn
, a.parnts_code
  from openrowset(
                  bulk 'D:\migra_data\mssql_com_code.txt'
                , FORMATFILE = 'D:\formatxml\tb_com_code_mssql.xml'
                , codepage = 65001
                 ) as a;
/*안됨 => SQL Error [4832] [S0001]: 대량 로드: 데이터 파일에서 예기치 않은 파일 끝에 도달했습니다.*/

alter table sc_khb_srv.tb_com_code add constraint pk_tb_com_code primary key(code_pk);

SELECT * FROM sc_khb_srv.tb_com_code ORDER BY code_pk desc;



-- tb_com_crtfc_tmpr


-- tb_com_ctpv_cd


-- tb_com_device_info


-- tb_com_device_ntcn_mapng_info


-- tb_com_device_stng_info


-- tb_com_emd_li_cd
DROP TABLE sc_khb_srv.tb_com_emd_li_cd;

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
);

insert into sc_khb_srv.tb_com_emd_li_cd
select
  a.emd_li_cd_pk
, a.ctpv_cd_pk
, a.sgg_cd_pk
, a.emd_li_nm
, a.all_emd_li_nm
, a.emd_li_crdnt
, a.stdg_dong_se_cd
, a.stdg_dong_cd
, a.reg_id
, a.reg_dt
, a.mdfcn_id
, a.mdfcn_dt
  from openrowset(
                  bulk 'D:\migra_data\dong_code_openrowset.txt'
                , FORMATFILE = 'D:\formatxml\tb_com_emd_li_cd.xml'
                , codepage = 65001
                 ) as a;

alter table sc_khb_srv.tb_com_emd_li_cd add constraint pk_tb_com_emd_li_cd primary key(emd_li_cd_pk);

SELECT * FROM sc_khb_srv.tb_com_emd_li_cd;



-- tb_com_error_log


-- tb_com_faq


-- tb_com_file


-- tb_com_file_mapng


-- tb_com_group


-- tb_com_group_author


-- tb_com_gtwy_svc


-- tb_com_gtwy_svc_author


-- tb_com_job_schdl_hstry


-- tb_com_job_schdl_info


-- tb_com_login_hist


-- tb_com_menu


-- tb_com_menu_author


-- tb_com_notice


-- tb_com_ntcn_info


-- tb_com_push_meta_info


-- tb_com_qna


-- tb_com_recsroom


-- tb_com_rss_info


-- tb_com_scrin


-- tb_com_scrin_author


-- tb_com_sgg_cd


-- tb_com_stplat_hist


-- tb_com_stplat_info


-- tb_com_stplat_mapng


-- tb_com_svc_ip_manage


-- tb_com_thema_info


-- tb_com_user


-- tb_com_user_author


-- tb_com_user_group


-- tb_com_user_ntcn_mapng_info


-- tb_hsmp_dtl_info


-- tb_hsmp_info
DROP TABLE sc_khb_srv.tb_hsmp_info;

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
, hsmp_crdnt geometry
, hsmp_lot sc_khb_srv.lot_d13_10
, hsmp_lat sc_khb_srv.lat_d12_10
, use_yn sc_khb_srv.yn_c1
, reg_id sc_khb_srv.id_nv100
, reg_dt sc_khb_srv.dt
, mdfcn_id sc_khb_srv.id_nv100
, mdfcn_dt sc_khb_srv.dt
);

insert into sc_khb_srv.tb_hsmp_info
select
  a.hsmp_info_pk
, a.hsmp_nm
, a.ctpv_cd_pk
, a.sgg_cd_pk
, a.emd_li_cd_pk
, a.lotno
, a.rn_addr
, a.tot_hh_cnt
, a.tot_aptcmpl_cnt
, a.flr_cnt
, a.tot_parkng_cntom
, a.hh_parkng_cntom
, a.bldr_nm
, a.cmcn_year
, a.cmcn_mt
, a.compet_year
, a.compet_mt
, a.heat_cd
, a.fuel_cd
, a.ctgry_cd
, a.mng_office_telno
, a.bus_rte_info
, a.subway_rte_info
, a.schl_info
, a.cvntl_info
, a.hsmp_crdnt
, a.hsmp_lot
, a.hsmp_lat
, a.use_yn
, a.reg_id
, a.reg_dt
, a.mdfcn_id
, a.mdfcn_dt
  from openrowset(
                  bulk 'D:\migra_data\danji_info_openrowset.txt'
                , FORMATFILE = 'D:\formatxml\tb_hsmp_info.xml'
                , codepage = 65001
                 ) as a;

alter table sc_khb_srv.tb_hsmp_info add constraint pk_tb_hsmp_info primary key(hsmp_info_pk);

SELECT * FROM sc_khb_srv.tb_hsmp_info WHERE hsmp_lot = 0;



-- tb_itrst_atlfsl_info


-- tb_jado_index


-- tb_link_apt_lttot_cmpet_rt_info


-- tb_link_apt_lttot_house_ty_dtl_info


-- tb_link_apt_lttot_info


-- tb_link_apt_nthg_rank_remndr_hh_lttot_info


-- tb_link_apt_nthg_rank_remndr_hh_lttot_ty_dtl_info


-- tb_link_hsmp_area_info


-- tb_link_hsmp_bsc_info
DROP TABLE sc_khb_srv.tb_link_hsmp_bsc_info;

CREATE TABLE sc_khb_srv.tb_link_hsmp_bsc_info(
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

insert into sc_khb_srv.tb_link_hsmp_bsc_info
select
  a.hsmp_cd 
, a.hsmp_nm
, a.ctpv_nm
, a.sgg_nm
, a.eupmyeon_nm
, a.dongli_nm
, a.hsmp_clsf_nm
, a.stdg_addr
, a.rn_addr
, a.lttot_stle_nm
, a.use_aprv_day
, a.aptcmpl_cnt
, a.hh_cnt
, a.mng_mthd_nm
, a.heat_mthd_nm
, a.crrdpr_type_nm
, a.bldr_nm
, a.dvlr_nm
, a.house_mng_bsmn_nm
, a.gnrl_mng_mthd_nm
, a.gnrl_mng_nmpr_cnt
, a.expens_mng_mthd_nm
, a.expens_mng_nmpr_cnt
, a.expens_mng_ctrt_bzenty_nm
, a.cln_mng_mthd_nm
, a.cln_mng_nmpr_cnt
, a.fdndrk_prcs_mthd_nm
, a.dsnf_mng_mthd_nm
, a.fyer_dsnf_cnt
, a.dsnf_mthd_nm
, a.bldg_strct_nm
, a.elcty_pwrsuply_cpcty
, a.hh_elcty_ctrt_mthd_nm
, a.elcty_safe_mngr_apnt_mthd_nm
, a.fire_rcivr_mthd_nm
, a.wsp_mthd_nm
, a.elvtr_mng_stle_nm
, a.psnger_elvtr_cnt
, a.frght_elvtr_cnt
, a.psnger_frght_elvtr_cnt
, a.pwdbs_elvtr_cnt
, a.emgnc_elvtr_cnt
, a.etc_elvtr_cnt
, a.tot_parkng_cntom
, a.grnd_parkng_cnt
, a.udgd_parkng_cnt
, a.cctv_cnt
, a.parkng_cntrl_hrk_yn_nm
, a.mng_office_addr
, a.mng_office_telno
, a.mng_office_fxno
, a.anclr_wlfare_fclt_nm
, a.join_day
, a.lttot_hh_cnt
, a.rent_hh_cnt
, a.top_flr_cnt
, a.bdrg_top_flr_cnt
, a.udgd_flr_cnt
, a.hsmp_lat
, a.hsmp_lot
, a.hsmp_crdnt
  from openrowset(
                  bulk 'D:\migra_data\tb_k_apt_hsmp_bass_info_openrowset.txt'
                , FORMATFILE = 'D:\formatxml\tb_link_hsmp_bsc_info.xml'
                , codepage = 65001
                 ) as a;

alter table sc_khb_srv.tb_link_hsmp_bsc_info add constraint pk_tb_link_hsmp_bsc_info primary key (hsmp_cd);

SELECT * FROM sc_khb_srv.tb_link_hsmp_bsc_info;


-- tb_link_hsmp_managect_info


-- tb_link_ofctl_cty_prvate_rent_lttot_cmpet_rt_info


-- tb_link_ofctl_cty_prvate_rent_lttot_info


-- tb_link_ofctl_cty_prvate_rent_lttot_ty_dtl_info


-- tb_link_public_sprt_prvate_rent_lttot_cmpet_rt_info


-- tb_link_remndr_hh_lttot_cmpet_rt_info


-- tb_link_rtrcn_re_sply_lttot_cmpet_rt_info


-- tb_link_subway_statn_info
DROP TABLE sc_khb_srv.tb_link_subway_statn_info;

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

insert into sc_khb_srv.tb_link_subway_statn_info
select
  a.statn_no
, a.statn_nm
, a.rte_no
, a.rte_nm
, a.eng_statn_nm
, a.chcrt_statn_nm
, a.trnsit_statn_se_nm
, a.trnsit_rte_no
, a.trnsit_rte_nm
, a.statn_lat
, a.statn_lot
, a.oper_inst_nm
, a.statn_rn_addr
, a.statn_telno
, a.data_crtr_day
, a.statn_crdnt
, a.stdg_cd
, a.reg_id
, a.reg_dt
, a.mdfcn_id
, a.mdfcn_dt
  from openrowset(
                  bulk 'D:\migra_data\tb_kric_statn_info_openrowset.txt'
                , FORMATFILE = 'D:\formatxml\tb_link_subway_statn_info.xml'
                , codepage = 65001
                 ) as a;

SELECT statn_crdnt.STAsText(), * FROM sc_khb_srv.tb_link_subway_statn_info;



-- tb_lrea_office_info
DROP TABLE sc_khb_srv.tb_lrea_office_info;

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
, eml sc_khb_srv.email_v320
, curprc_pvsn_yn sc_khb_srv.yn_c1
, lrea_grd_cd sc_khb_srv.cd_v20
, estbl_reg_no sc_khb_srv.no_v200
);

insert into sc_khb_srv.tb_lrea_office_info
select
  a.lrea_office_info_pk
, a.bzmn_no
, a.lrea_office_nm
, a.lrea_office_rprsv_nm
, a.tlphon_type_cd
, a.safety_no
, a.lrea_office_rprs_telno
, a.lrea_telno
, a.lrea_office_addr
, a.ctpv_cd_pk
, a.sgg_cd_pk
, a.stdg_innb
, a.dong_innb
, a.user_level_no
, a.rprs_img_one_url
, a.rprs_img_two_url
, a.rprs_img_three_url
, a.lat
, a.lot
, a.user_ty_cd
, a.stts_cd
, a.use_yn
, a.lrea_office_crdnt
, a.hmpg_url
, a.reg_id
, a.reg_dt
, a.mdfcn_id
, a.mdfcn_dt
, a.lrea_office_intrcn_cn
, a.eml
, a.curprc_pvsn_yn
, a.lrea_grd_cd
, a.estbl_reg_no
  from openrowset(
                  bulk 'D:\migra_data\.txt'
                , FORMATFILE = 'D:\formatxml\tb_lrea_office_info.xml'
                , codepage = 65001
                 ) as a;

alter table sc_khb_srv.tb_lrea_office_info add constraint pk_tb_lrea_office_info primary key(lrea_office_info_pk);

SELECT * FROM sc_khb_srv.tb_lrea_office_info;

-- tb_lrea_schdl_ntcn_info


-- tb_lrea_sns_url_info


-- tb_lrea_spclty_fld_info


-- tb_lttot_info


-- tb_svc_bass_info


-- tb_user_atlfsl_img_info


-- tb_user_atlfsl_info


-- tb_user_atlfsl_preocupy_info


-- tb_user_atlfsl_thema_info






























