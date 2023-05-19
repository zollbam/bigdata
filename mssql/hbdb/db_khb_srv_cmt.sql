/*
mssql 버전
    Microsoft SQL Server 2016 (SP3) (KB5003279) - 13.0.6300.2 (X64) 
	Aug  7 2021 01:20:37 
	Copyright (c) Microsoft Corporation
	Enterprise Evaluation Edition (64-bit) on Windows Server 2016 Standard Evaluation 10.0 <X64> (Build 14393: ) (Hypervisor)

날짜: 23-05-19

한방 TESTDB를 위한 쿼리문
*/

-- 버전확인
SELECT @@version;

-- DB 생성
CREATE DATABASE db_khb_srv;

-- 스키마 생성
USE db_khb_srv
GO
create schema sc_khb_srv;

-- 로그인 유저 생성
USE master GO; /*실행 안 해도 상관 X*/
create login us_khb_adm with password = 'adm!#24', default_database = db_khb_srv;
create login us_khb_com with password = 'com!#24', default_database = db_khb_srv;
create login us_khb_dev with password = 'dev!#24', default_database = db_khb_srv;
create login us_khb_agent with password = 'agent!#24', default_database = db_khb_srv;
create login us_khb_exif with password = 'exif!#24', default_database = db_khb_srv;
create login us_khb_magnt with password = 'magnt!#24', default_database = db_khb_srv;
create login us_khb_mptl with password = 'mptl!#24', default_database = db_khb_srv;
create login us_khb_report with password = 'report!#24', default_database = db_khb_srv;

-- 유저 생성
USE db_khb_srv GO;
create user us_khb_adm for login us_khb_adm with default_schema = sc_khb_srv;
create user us_khb_com for login us_khb_com with default_schema = sc_khb_srv;
create user us_khb_dev for login us_khb_dev with default_schema = sc_khb_srv;
create user us_khb_agent for login us_khb_agent with default_schema = sc_khb_srv;
create user us_khb_exif for login us_khb_exif with default_schema = sc_khb_srv;
create user us_khb_magnt for login us_khb_magnt with default_schema = sc_khb_srv;
create user us_khb_mptl for login us_khb_mptl with default_schema = sc_khb_srv;
create user us_khb_report for login us_khb_report with default_schema = sc_khb_srv;

-- 스키마 권한 부여
-- user 'sa'에서 진행
GRANT control ON SCHEMA::sc_khb_srv TO us_khb_adm;
REVOKE control ON SCHEMA::sc_khb_srv from us_khb_adm;

-- 유저 권한 부여
ALTER SERVER ROLE [dbcreator] ADD MEMBER [us_khb_adm];
ALTER SERVER ROLE [sysadmin] ADD MEMBER [us_khb_adm];

-- ALTER SERVER ROLE [dbcreator] drop MEMBER [us_khb_adm];
/*create login으로 생성된 "로그인"에 ROLE이 부여*/

-- 스키마 정보 확인
SELECT * FROM sys.schemas;

-- db 용량 확인
EXEC sp_helpdb "db_khb_srv";

use db_khb_srv;
EXEC sp_spaceused 'db_khb_srv.sc_khb_srv.tb_com_author';

-- 테이블 생성
CREATE TABLE sc_khb_srv.tb_com_menu (
  menu_no_pk decimal(9,0) NOT NULL
, parnts_menu_no_pk decimal(9,0)
, menu_nm varchar(500)
, sort_ordr decimal(10,0)
, use_at char(1)
, rm_cn varchar(4000)
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, scrin_no_pk decimal(9,0)
, orgnzt_manage_at char(1)
, PRIMARY KEY (menu_no_pk)
);
CREATE INDEX if_tb_com_menu_01 ON sc_khb_srv.tb_com_menu (scrin_no_pk);
CREATE UNIQUE INDEX pk_tb_com_menu ON sc_khb_srv.tb_com_menu (menu_no_pk);
CREATE INDEX if_tb_com_menu_02 ON sc_khb_srv.tb_com_menu (parnts_menu_no_pk);

CREATE TABLE sc_khb_srv.tb_com_group_author (
  com_group_author_pk decimal(9,0) NOT NULL
, group_no_pk decimal(9,0) NOT NULL
, author_no_pk decimal(9,0) NOT NULL
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, PRIMARY KEY (com_group_author_pk)
);
CREATE INDEX if_tb_com_group_author_01 ON sc_khb_srv.tb_com_group_author (group_no_pk);
CREATE INDEX if_tb_com_group_author_02 ON sc_khb_srv.tb_com_group_author (author_no_pk);
CREATE UNIQUE INDEX pk_tb_com_group_author ON sc_khb_srv.tb_com_group_author (com_group_author_pk);

CREATE TABLE sc_khb_srv.tb_com_group (
  group_no_pk decimal(9,0) NOT NULL
, parnts_group_no_pk decimal(9,0)
, group_nm varchar(500)
, use_at char(1)
, rm_cn varchar(4000)
, valid_pd_begin_dt date
, valid_pd_end_dt date
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, orgnzt_confm_at char(1)
, orgnzt_manage_at char(1)
, user_no_pk decimal(9,0)
, PRIMARY KEY (group_no_pk)
);
CREATE UNIQUE INDEX pk_tb_com_group ON sc_khb_srv.tb_com_group (group_no_pk);
CREATE INDEX if_tb_com_group_02 ON sc_khb_srv.tb_com_group (user_no_pk);
CREATE INDEX if_tb_com_group_01 ON sc_khb_srv.tb_com_group (parnts_group_no_pk);

CREATE TABLE sc_khb_srv.tb_com_user_group (
  com_user_group_pk decimal(9,0) NOT NULL
, group_no_pk decimal(9,0) NOT NULL
, user_no_pk decimal(9,0) NOT NULL
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, PRIMARY KEY (com_user_group_pk)
);
CREATE INDEX if_tb_com_user_group_03 ON sc_khb_srv.tb_com_user_group (group_no_pk);
CREATE INDEX if_tb_com_user_group_02 ON sc_khb_srv.tb_com_user_group (user_no_pk);
CREATE UNIQUE INDEX pk_tb_com_user_group ON sc_khb_srv.tb_com_user_group (com_user_group_pk);

CREATE TABLE sc_khb_srv.tb_com_scrin (
  scrin_no_pk decimal(9,0) NOT NULL
, scrin_nm varchar(500)
, scrin_url varchar(4000)
, rm_cn varchar(4000)
, use_at char(1)
, creat_author_at char(1)
, inqire_author_at char(1)
, updt_author_at char(1)
, delete_author_at char(1)
, excel_author_at char(1)
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, PRIMARY KEY (scrin_no_pk)
);
CREATE UNIQUE INDEX pk_tb_com_scrin ON sc_khb_srv.tb_com_scrin (scrin_no_pk);

CREATE TABLE sc_khb_srv.tb_com_scrin_author (
  com_scrin_author_pk decimal(9,0) NOT NULL
, author_no_pk decimal(9,0) NOT NULL
, scrin_no_pk decimal(9,0) NOT NULL
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, PRIMARY KEY (com_scrin_author_pk)
);
CREATE UNIQUE INDEX pk_tb_com_scrin_author ON sc_khb_srv.tb_com_scrin_author (com_scrin_author_pk);
CREATE INDEX if_tb_com_scrin_author_01 ON sc_khb_srv.tb_com_scrin_author (author_no_pk);
CREATE INDEX if_tb_com_scrin_author_02 ON sc_khb_srv.tb_com_scrin_author (scrin_no_pk);

CREATE TABLE sc_khb_srv.tb_com_author (
  author_no_pk decimal(9,0) NOT NULL
, parnts_author_no_pk decimal(9,0)
, author_nm varchar(500)
, rm_cn varchar(4000)
, use_at char(1)
, valid_pd_begin_dt date
, valid_pd_end_dt date
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, orgnzt_manage_at char(1)
, PRIMARY KEY (author_no_pk)
);
CREATE UNIQUE INDEX pk_tb_com_author ON sc_khb_srv.tb_com_author (author_no_pk);
CREATE INDEX if_tb_com_author_01 ON sc_khb_srv.tb_com_author (parnts_author_no_pk);

CREATE TABLE sc_khb_srv.tb_com_user_author (
  user_author_pk decimal(9,0) NOT NULL
, user_no_pk decimal(9,0)
, author_no_pk decimal(9,0)
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, PRIMARY KEY (user_author_pk)
);
CREATE UNIQUE INDEX pk_tb_com_user_author ON sc_khb_srv.tb_com_user_author (user_author_pk);
CREATE INDEX if_tb_com_user_author_01 ON sc_khb_srv.tb_com_user_author (author_no_pk);
CREATE INDEX if_tb_com_user_author_02 ON sc_khb_srv.tb_com_user_author (user_no_pk);

CREATE TABLE sc_khb_srv.tb_com_user (
  user_no_pk decimal(9,0) NOT NULL
, parnts_user_no_pk decimal(9,0)
, user_id varchar(100)
, user_nm varchar(500)
, password varchar(500)
, moblphon_no varchar(200)
, moblphon_crtfc_sn varchar(100)
, moblphon_crtfc_at char(1)
, email varchar(320)
, email_crtfc_sn varchar(100)
, email_crtfc_at char(1)
, bsnm_regist_no decimal(15,0)
, file_upload_at char(1)
, file_no decimal(15,0)
, cmpny_nm varchar(500)
, pblinstt_nm varchar(500)
, dept_nm varchar(500)
, rspofc_nm varchar(500)
, user_se_code varchar(20)
, sbscrb_de varchar(8)
, password_change_de varchar(8)
, last_login_dt date
, last_login_ip varchar(100)
, error_co decimal(15,0)
, error_dt date
, use_at char(1)
, email_recptn_at char(1)
, email_recptn_dt date
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, bizrno_crtfc_at char(1)
, login_at char(1)
, refresh_tkn_cn varchar(4000)
, sms_recptn_at char(1)
, sms_recptn_dt date
, device_id varchar(100)
, induty_se_code varchar(20)
, writng_realm_nm varchar(500)
, user_sttus_code varchar(20)
, user_sttus_change_dt date
, PRIMARY KEY (user_no_pk)
);
CREATE UNIQUE INDEX iu_tb_com_user_01 ON sc_khb_srv.tb_com_user (user_id);
CREATE INDEX if_tb_com_user_01 ON sc_khb_srv.tb_com_user (parnts_user_no_pk);
CREATE UNIQUE INDEX pk_tb_com_user ON sc_khb_srv.tb_com_user (user_no_pk);

CREATE TABLE sc_khb_srv.tb_com_file_mapng (
  file_no_pk decimal(9,0) NOT NULL
-- , popup_no_pk decimal(9,0)
, recsroom_no_pk decimal(9,0)
, user_no_pk decimal(9,0)
, event_no_pk decimal(9,0)
, othbc_dta_no_pk decimal(9,0)
-- , estate_word_dicary_no_pk decimal(9,0)
, PRIMARY KEY (file_no_pk)
);
-- CREATE INDEX if_tb_com_file_mapng_07 ON sc_khb_srv.tb_com_file_mapng (estate_word_dicary_no_pk);
-- CREATE INDEX if_tb_com_file_mapng_01 ON sc_khb_srv.tb_com_file_mapng (popup_no_pk);
CREATE UNIQUE INDEX pk_tb_com_file_mapng ON sc_khb_srv.tb_com_file_mapng (file_no_pk);
CREATE INDEX if_tb_com_file_mapng_04 ON sc_khb_srv.tb_com_file_mapng (file_no_pk);
CREATE INDEX if_tb_com_file_mapng_03 ON sc_khb_srv.tb_com_file_mapng (user_no_pk);
CREATE INDEX if_tb_com_file_mapng_02 ON sc_khb_srv.tb_com_file_mapng (recsroom_no_pk);

CREATE TABLE sc_khb_srv.tb_com_stplat_mapng (
  com_stplat_mapng_pk decimal(9,0) NOT NULL
, com_stplat_info_pk decimal(9,0)
, user_no_pk decimal(9,0)
, stplat_agre_dt date
, stplat_reject_dt date
, PRIMARY KEY (com_stplat_mapng_pk)
);
CREATE UNIQUE INDEX pk_tb_com_stplat_mapng ON sc_khb_srv.tb_com_stplat_mapng (com_stplat_mapng_pk);
CREATE INDEX if_tb_com_stplat_mapng_01 ON sc_khb_srv.tb_com_stplat_mapng (com_stplat_info_pk);
CREATE INDEX if_tb_com_stplat_mapng_02 ON sc_khb_srv.tb_com_stplat_mapng (user_no_pk);

CREATE TABLE sc_khb_srv.tb_com_recsroom (
  recsroom_no_pk decimal(9,0) NOT NULL
, sj_nm varchar(500)
, rm_cn varchar(4000)
, inqire_co decimal(15,0)
, file_use_at char(1)
, regist_dt date DEFAULT current_timestamp
, regist_id varchar(100)
, updt_dt date
, updt_id varchar(100)
, PRIMARY KEY (recsroom_no_pk)
);
CREATE UNIQUE INDEX pk_tb_com_recsroom ON sc_khb_srv.tb_com_recsroom (recsroom_no_pk);

CREATE TABLE sc_khb_srv.tb_com_stplat_info (
  com_stplat_info_pk decimal(9,0) NOT NULL
, svc_pk decimal(9,0) NOT NULL
, stplat_se_code varchar(20)
, essntl_at char(1)
, file_cours_nm varchar(500)
, use_at char(1)
, register_id varchar(100)
, regist_dt date
, updusr_id varchar(100)
, updt_dt date
, chnnl_id varchar(100)
, PRIMARY KEY (com_stplat_info_pk)
);
CREATE INDEX if_tb_com_stplat_info_01 ON sc_khb_srv.tb_com_stplat_info (svc_pk);
CREATE UNIQUE INDEX pk_tb_com_stplat_info ON sc_khb_srv.tb_com_stplat_info (com_stplat_info_pk);

CREATE TABLE sc_khb_srv.tb_com_stplat_hist (
  com_stplat_hist_pk decimal(9,0) NOT NULL
, com_stplat_info_pk decimal(9,0) NOT NULL
, stplat_se_code varchar(20)
, essntl_at char(1)
, file_cours_nm varchar(500)
, stplat_begin_dt date
, stplat_end_dt date
, PRIMARY KEY (com_stplat_hist_pk)
);
CREATE INDEX if_tb_com_stplat_hist_01 ON sc_khb_srv.tb_com_stplat_hist (com_stplat_info_pk);
CREATE UNIQUE INDEX pk_tb_com_stplat_hist ON sc_khb_srv.tb_com_stplat_hist (com_stplat_hist_pk);

CREATE TABLE sc_khb_srv.tb_com_svc_ip_manage (
  ip_manage_pk decimal(9,0) NOT NULL
, author_no_pk decimal(9,0)
, ip_adres varchar(200)
, ip_use_instt_nm varchar(500)
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, PRIMARY KEY (ip_manage_pk)
);
CREATE UNIQUE INDEX pk_tb_com_svc_ip_manage ON sc_khb_srv.tb_com_svc_ip_manage (ip_manage_pk);
CREATE INDEX if_tb_com_svc_ip_manage_01 ON sc_khb_srv.tb_com_svc_ip_manage (author_no_pk);

CREATE TABLE sc_khb_srv.tb_com_gtwy_svc_author (
  com_gtwy_svc_author_pk decimal(9,0) NOT NULL
, author_no_pk decimal(9,0) NOT NULL
, gtwy_svc_pk decimal(9,0) NOT NULL
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, PRIMARY KEY (com_gtwy_svc_author_pk)
);
CREATE UNIQUE INDEX pk_tb_com_gtwy_svc_author ON sc_khb_srv.tb_com_gtwy_svc_author (com_gtwy_svc_author_pk);
CREATE INDEX if_tb_com_gtwy_svc_author_01 ON sc_khb_srv.tb_com_gtwy_svc_author (author_no_pk);
CREATE INDEX if_tb_com_gtwy_svc_author_02 ON sc_khb_srv.tb_com_gtwy_svc_author (gtwy_svc_pk);

CREATE TABLE sc_khb_srv.tb_com_gtwy_svc (
  gtwy_svc_pk decimal(9,0) NOT NULL
, gtwy_nm varchar(500)
, gtwy_url varchar(4000)
, rm_cn varchar(4000)
, use_at char(1)
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, gtwy_method_nm varchar(500)
, PRIMARY KEY (gtwy_svc_pk)
);
CREATE UNIQUE INDEX pk_tb_com_gtwy_svc ON sc_khb_srv.tb_com_gtwy_svc (gtwy_svc_pk);

CREATE TABLE sc_khb_srv.tb_com_faq (
  faq_no_pk decimal(9,0) NOT NULL
, qestn_cn varchar(4000)
, answer_cn varchar(4000)
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, ctgry_code varchar(20)
, svc_se_code varchar(20)
, PRIMARY KEY (faq_no_pk)
);
CREATE UNIQUE INDEX pk_tb_com_faq ON sc_khb_srv.tb_com_faq (faq_no_pk);

CREATE TABLE sc_khb_srv.tb_com_notice (
  notice_no_pk decimal(9,0) NOT NULL
, sj_nm varchar(500)
, inqire_co decimal(15,0)
, rm_cn varchar(4000)
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, notice_at char(1)
, notice_se_code varchar(20)
, svc_se_code varchar(20)
, PRIMARY KEY (notice_no_pk)
);
CREATE UNIQUE INDEX pk_tb_com_notice ON sc_khb_srv.tb_com_notice (notice_no_pk);

CREATE TABLE sc_khb_srv.tb_com_login_hist (
  login_hist_pk decimal(9,0) NOT NULL
, user_id varchar(100)
, login_ip_adres varchar(200)
, error_at char(1)
, error_code varchar(20)
, error_cn varchar(4000)
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, PRIMARY KEY (login_hist_pk)
);
CREATE UNIQUE INDEX pk_tb_com_login_hist ON sc_khb_srv.tb_com_login_hist (login_hist_pk);

CREATE TABLE sc_khb_srv.tb_com_error_log (
  error_log_pk decimal(9,0) NOT NULL
, user_id varchar(100)
, url varchar(4000)
, mthd_nm varchar(500)
, paramtr_cn varchar(4000)
, error_cn varchar(4000)
, requst_ip_adres varchar(200)
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, PRIMARY KEY (error_log_pk)
);
CREATE UNIQUE INDEX pk_tb_com_error_log ON sc_khb_srv.tb_com_error_log (error_log_pk);

CREATE TABLE sc_khb_srv.tb_com_crtfc_tmpr (
  crtfc_pk decimal(9,0) NOT NULL
, crtfc_se_code varchar(20)
, moblphon_no varchar(20)
, moblphon_crtfc_sn varchar(100)
, moblphon_crtfc_at char(1)
, email varchar(320)
, email_crtfc_sn varchar(100)
, email_crtfc_at char(1)
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, PRIMARY KEY (crtfc_pk)
);
CREATE UNIQUE INDEX pk_tb_com_crtfc_tmpr ON sc_khb_srv.tb_com_crtfc_tmpr (crtfc_pk);

CREATE TABLE sc_khb_srv.tb_com_qna (
  qna_no_pk decimal(9,0) NOT NULL
, parnts_qna_no_pk decimal(9,0)
, sj_nm varchar(500)
, rm_cn varchar(4000)
, secret_no_at char(1)
, secret_no decimal(15,0)
, inqire_co decimal(15,0)
, answer_dp_no decimal(15,0)
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, PRIMARY KEY (qna_no_pk)
);
CREATE UNIQUE INDEX pk_tb_com_qna ON sc_khb_srv.tb_com_qna (qna_no_pk);
CREATE INDEX if_tb_com_qna_01 ON sc_khb_srv.tb_com_qna (parnts_qna_no_pk);

CREATE TABLE sc_khb_srv.tb_com_code (
  code_pk decimal(9,0) NOT NULL
, parnts_code_pk decimal(9,0)
, code varchar(20) NOT NULL
, code_nm varchar(500) NOT NULL
, sort_ordr decimal(10,0)
, use_at char(1)
, regist_id varchar(100)
, regist_dt date DEFAULT current_timestamp
, updt_id varchar(100)
, updt_dt date
, rm_cn varchar(4000)
, PRIMARY KEY (code_pk)
);
CREATE INDEX if_tb_com_code_01 ON sc_khb_srv.tb_com_code (parnts_code_pk);
CREATE UNIQUE INDEX pk_tb_com_code ON sc_khb_srv.tb_com_code (code_pk);





-- 쿼리문없는 테이블
CREATE TABLE sc_khb_srv.tb_com_menu_author (
  com_menu_no_pk decimal(9,0) NOT NULL
, author_no_pk
, menu_no_pk
, regist_id
, regist_dt
, updt_id
, updt_dt
, PRIMARY KEY (com_menu_no_pk)
);





-- 테이블명 comment
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_FAQ', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_QNA', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_게이트웨이_서비스', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_게이트웨이_서비스_권한', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_공지사항', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_권한', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_그룹', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_그룹_권한', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_로그인_이력', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_메뉴', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_서비스_아이피_관리', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_매핑', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_이력', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_정보', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_에러_LOG', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_유저', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_유저_권한', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_유저_그룹', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_인증_임시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_자료실', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_파일_매핑', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_화면', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_화면_권한', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author';





-- 만들 테이블명 comment
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_메뉴_권한', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author'

-- 컬럼명 comment
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유효_기간_종료_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'valid_pd_end_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유효_기간_시작_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'valid_pd_begin_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'author_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부모_권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'parnts_author_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'author_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조직_관리_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'orgnzt_manage_at';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'code_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'정렬_순서', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'sort_ordr'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'코드_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'code_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부모_코드_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'parnts_code_pk';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'인증_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'crtfc_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'인증_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'crtfc_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'휴대폰_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'moblphon_no'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'휴대폰_인증_일련번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'moblphon_crtfc_sn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'휴대폰_인증_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'moblphon_crtfc_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이메일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'email'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이메일_인증_일련번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'email_crtfc_sn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이메일_인증_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'email_crtfc_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'updt_id';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'방식_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'mthd_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'요청_IP_주소', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'requst_ip_adres'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'에러_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'error_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파라미터_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'paramtr_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'에러_LOG_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'error_log_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'user_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'url';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'카테고리_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'ctgry_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'서비스_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'svc_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'FAQ_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'faq_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'질문_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'qestn_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'답변_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'answer_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'updt_id';

-- EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부동산_용어_사전_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'estate_word_dicary_no_pk'
-- EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'팝업_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'popup_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'자료실_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'recsroom_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'user_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이벤트_번호_pk', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'event_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공개_자료_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'othbc_dta_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파일_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'file_no_pk';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조직_관리_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'orgnzt_manage_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'그룹_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'group_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부모_그룹_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'parnts_group_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'그룹_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'group_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유효_기간_시작_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'valid_pd_begin_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유효_기간_종료_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'valid_pd_end_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조직_승인_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'orgnzt_confm_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'user_no_pk';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'author_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'그룹_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'group_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_그룹_권한_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'com_group_author_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'regist_dt';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'게이트웨이_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'gtwy_url'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'게이트웨이_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'gtwy_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_게이트웨이_서비스_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'gtwy_svc_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'게이트웨이_메소드_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'gtwy_method_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'updt_id';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'author_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_게이트웨이_서비스_권한_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'com_gtwy_svc_author_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_게이트웨이_서비스_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'gtwy_svc_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'updt_dt';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'로그인_이력_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'login_hist_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'user_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'로그인_IP_주소', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'login_ip_adres'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'에러_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'error_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'에러_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'error_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'에러_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'error_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'regist_dt';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'화면_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'scrin_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조직_관리_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'orgnzt_manage_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'메뉴_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'menu_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부모_메뉴_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'parnts_menu_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'메뉴_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'menu_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'정렬_순서', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'sort_ordr'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'regist_dt';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'제목_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'sj_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조회_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'inqire_co'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'서비스_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'svc_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공지_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'notice_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공지_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'notice_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공지사항_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'notice_no_pk';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조회_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'inqire_co'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'질의응답_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'qna_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부모_질의응답_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'parnts_qna_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'제목_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'sj_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비밀_번호_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'secret_no_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비밀_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'secret_no'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'답변_깊이_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'answer_dp_no'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'updt_dt';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파일_사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'file_use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조회_수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'inqire_co'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'제목_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'sj_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'자료실_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'recsroom_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'updt_dt';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'화면_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'scrin_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'엑셀_권한_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'excel_author_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'조회_권한_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'inqire_author_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'생성_권한_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'creat_author_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비고_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'화면_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'scrin_url'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'화면_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'scrin_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_권한_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'updt_author_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'삭제_권한_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'delete_author_at';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_화면_권한_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'com_scrin_author_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'author_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'화면_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'scrin_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'updt_dt';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'author_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'아이피_관리_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'ip_manage_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'아이피_사용_기관_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'ip_use_instt_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'아이피_주소', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'ip_adres';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이메일', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'email'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이메일_인증_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'email_crtfc_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사업자_등록_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'bsnm_regist_no'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파일_업로드_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'file_upload_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파일_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'file_no'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'회사_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'cmpny_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공공기관_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'pblinstt_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부서_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'dept_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_상태_변경_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_sttus_change_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사업자등록번호_인증_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'bizrno_crtfc_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이메일_수신_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'email_recptn_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이메일_수신_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'email_recptn_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'오류_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'error_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'오류_횟수', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'error_co'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'최종_로그인_아이피', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'last_login_ip'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'최종_로그인_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'last_login_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'암호_변경_일자', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'password_change_de'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'가입_일자', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'sbscrb_de'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'직책_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'rspofc_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'부모_유저_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'parnts_user_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'비밀번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'password'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'휴대폰_번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'moblphon_no'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'휴대폰_인증_일련번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'moblphon_crtfc_sn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'휴대폰_인증_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'moblphon_crtfc_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'이메일_인증_일련번호', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'email_crtfc_sn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_상태_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_sttus_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'작성_분야_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'writng_realm_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'업종_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'induty_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'디바이스 아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'device_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'SMS_수신_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'sms_recptn_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'SMS_수신_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'sms_recptn_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'리프레시_토큰_내용', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'refresh_tkn_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'로그인_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'login_at';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_권한_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'user_author_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'user_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'author_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'regist_id';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_유저_그룹_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'com_user_group_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'그룹_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'group_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'user_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'updt_id';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정자_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'updusr_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록자_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'register_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'사용_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파일_경로_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'file_cours_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'필수_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'essntl_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'약관_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'stplat_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'com_stplat_info_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'서비스_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'svc_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'채널_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'chnnl_id';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'약관_구분_코드', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'stplat_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'com_stplat_info_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_이력_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'com_stplat_hist_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'약관_종료_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'stplat_end_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'약관_시작_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'stplat_begin_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'파일_경로_명', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'file_cours_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'필수_여부', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'essntl_at';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'약관_동의_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng', @level2type=N'COLUMN', @level2name=N'stplat_agre_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_정보_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng', @level2type=N'COLUMN', @level2name=N'com_stplat_info_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_약관_매핑_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng', @level2type=N'COLUMN', @level2name=N'com_stplat_mapng_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'약관_거부_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng', @level2type=N'COLUMN', @level2name=N'stplat_reject_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'유저_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng', @level2type=N'COLUMN', @level2name=N'user_no_pk';





-- 만들 컬럼명 comment
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'공통_메뉴_권한_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'com_menu_author_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'권한_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'author_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'메뉴_번호_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'menu_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'등록_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_아이디', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'수정_일시', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'updt_dt';

-- com 유저에게 권한 부여
grant select, insert, update, delete on sc_khb_srv.tb_com_author to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_code to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_crtfc_tmpr to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_faq to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_file_mapng to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_group to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_group_author to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_gtwy_svc to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_gtwy_svc_author to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_login_hist to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_menu to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_notice to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_qna to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_recsroom to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_scrin to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_scrin_author to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_stplat_hist to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_stplat_info to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_stplat_mapng to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_svc_ip_manage to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_user to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_user_author to us_khb_com;
grant select, insert, update, delete on sc_khb_srv.tb_com_user_group to us_khb_com;

-- adm과 com 뺀 유저에게 tb_com_error_log DML권한 부여
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_dev;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_agent;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_exif;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_magnt;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_mptl;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_report;

-- 시퀀스 생성
CREATE SEQUENCE sc_khb_srv.sq_com_author
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_code
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_crtfc_tmpr
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_error_log
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_faq
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_file_mapng
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_group
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_group_author
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_gtwy_svc
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_gtwy_svc_author
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_login_hist
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_menu
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_notice
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_qna
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_recsroom
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_scrin
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_scrin_author
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_stplat_hist
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_stplat_info
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_stplat_mapng
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_svc_ip_manage
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_user
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_user_author
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_user_group
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO

-- com유저에게 시퀀스 권한
grant update on sc_khb_srv.sq_com_author to us_khb_com;
grant update on sc_khb_srv.sq_com_code to us_khb_com;
grant update on sc_khb_srv.sq_com_crtfc_tmpr to us_khb_com;
grant update on sc_khb_srv.sq_com_error_log to us_khb_com;
grant update on sc_khb_srv.sq_com_faq to us_khb_com;
grant update on sc_khb_srv.sq_com_file_mapng to us_khb_com;
grant update on sc_khb_srv.sq_com_group to us_khb_com;
grant update on sc_khb_srv.sq_com_group_author to us_khb_com;
grant update on sc_khb_srv.sq_com_gtwy_svc to us_khb_com;
grant update on sc_khb_srv.sq_com_gtwy_svc_author to us_khb_com;
grant update on sc_khb_srv.sq_com_login_hist to us_khb_com;
grant update on sc_khb_srv.sq_com_menu to us_khb_com;
grant update on sc_khb_srv.sq_com_notice to us_khb_com;
grant update on sc_khb_srv.sq_com_qna to us_khb_com;
grant update on sc_khb_srv.sq_com_recsroom to us_khb_com;
grant update on sc_khb_srv.sq_com_scrin to us_khb_com;
grant update on sc_khb_srv.sq_com_scrin_author to us_khb_com;
grant update on sc_khb_srv.sq_com_stplat_hist to us_khb_com;
grant update on sc_khb_srv.sq_com_stplat_info to us_khb_com;
grant update on sc_khb_srv.sq_com_stplat_mapng to us_khb_com;
grant update on sc_khb_srv.sq_com_svc_ip_manage to us_khb_com;
grant update on sc_khb_srv.sq_com_user to us_khb_com;
grant update on sc_khb_srv.sq_com_user_author to us_khb_com;
grant update on sc_khb_srv.sq_com_user_group to us_khb_com;

-- adm과 com을 뺀 나머지 유저에게 sq_com_error_log 권한 주기
grant update on sc_khb_srv.sq_com_error_log to us_khb_dev;
grant update on sc_khb_srv.sq_com_error_log to us_khb_agent;
grant update on sc_khb_srv.sq_com_error_log to us_khb_exif;
grant update on sc_khb_srv.sq_com_error_log to us_khb_magnt;
grant update on sc_khb_srv.sq_com_error_log to us_khb_mptl;
grant update on sc_khb_srv.sq_com_error_log to us_khb_report;

EXEC sp_primarykeys @table_server='';
EXEC sp_helpdb "db_khb_srv";
