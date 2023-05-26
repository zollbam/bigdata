-- ����Ȯ��
SELECT @@version;

-- DB ����
CREATE DATABASE db_khb_srv;

-- ��Ű�� ����
USE db_khb_srv
GO;
create schema sc_khb_srv;

-- �α��� ���� ����
USE master GO; -- ���� �� �ص� ��� X
create login us_khb_adm with password = 'adm!#24', default_database = db_khb_srv;
create login us_khb_com with password = 'com!#24', default_database = db_khb_srv;
create login us_khb_dev with password = 'dev!#24', default_database = db_khb_srv;
create login us_khb_agnt with password = 'agnt!#24', default_database = db_khb_srv;
create login us_khb_exif with password = 'exif!#24', default_database = db_khb_srv;
create login us_khb_magnt with password = 'magnt!#24', default_database = db_khb_srv;
create login us_khb_mptl with password = 'mptl!#24', default_database = db_khb_srv;
create login us_khb_report with password = 'report!#24', default_database = db_khb_srv;

-- ���� ����
USE db_khb_srv GO;
create user us_khb_adm for login us_khb_adm with default_schema = sc_khb_srv;
create user us_khb_com for login us_khb_com with default_schema = sc_khb_srv;
create user us_khb_dev for login us_khb_dev with default_schema = sc_khb_srv;
create user us_khb_agnt for login us_khb_agnt with default_schema = sc_khb_srv;
create user us_khb_exif for login us_khb_exif with default_schema = sc_khb_srv;
create user us_khb_magnt for login us_khb_magnt with default_schema = sc_khb_srv;
create user us_khb_mptl for login us_khb_mptl with default_schema = sc_khb_srv;
create user us_khb_report for login us_khb_report with default_schema = sc_khb_srv;

-- DROP login us_khb_agent;
-- DROP user us_khb_agent;

-- ��Ű�� ���� �ο�
-- user 'sa'���� ����
--GRANT CREATE SEQUENCE ON SCHEMA::sc_khb_srv TO us_khb_com;
--revoke CREATE SEQUENCE ON SCHEMA::sc_khb_srv TO us_khb_com;

-- ���� ���� �ο�
ALTER SERVER ROLE [dbcreator] ADD MEMBER [us_khb_adm];
ALTER SERVER ROLE [sysadmin] ADD MEMBER [us_khb_adm];

ALTER SERVER ROLE [dbcreator] DROP MEMBER [us_khb_adm];
ALTER SERVER ROLE [sysadmin] DROP MEMBER [us_khb_adm];

SELECT * FROM sys.server_principals;
SELECT * FROM sys.server_role_members;
-- ALTER SERVER ROLE [sysadmin] drop MEMBER [us_khb_adm];
/*create login���� ������ "�α���"�� ROLE�� �ο�*/

-- ��Ű�� ���� Ȯ��
SELECT * FROM sys.schemas;

-- db �뷮 Ȯ��
EXEC sp_helpdb "db_khb_srv";

use db_khb_srv;
EXEC sp_spaceused 'db_khb_srv.sc_khb_srv.tb_com_author';

-- ���̺� ����
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
CREATE TABLE sc_khb_srv.tb_com_file_mapng (
  file_no_pk decimal(9,0) NOT NULL
, recsroom_no_pk decimal(9,0)
, user_no_pk decimal(9,0)
, event_no_pk decimal(9,0)
, othbc_dta_no_pk decimal(9,0)
, PRIMARY KEY (file_no_pk)
);
CREATE UNIQUE INDEX pk_tb_com_file_mapng ON sc_khb_srv.tb_com_file_mapng (file_no_pk);
CREATE INDEX if_tb_com_file_mapng_04 ON sc_khb_srv.tb_com_file_mapng (file_no_pk);
CREATE INDEX if_tb_com_file_mapng_03 ON sc_khb_srv.tb_com_file_mapng (user_no_pk);
CREATE INDEX if_tb_com_file_mapng_02 ON sc_khb_srv.tb_com_file_mapng (recsroom_no_pk);
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
CREATE TABLE sc_khb_srv.tb_com_menu_author (
  com_menu_author_pk decimal(9,0) NOT NULL 
, author_no_pk decimal(9,0) NOT NULL 
, menu_no_pk decimal(9,0) NOT NULL
, regist_id varchar(100) 
, regist_dt date DEFAULT current_timestamp 
, updt_id varchar(100) 
, updt_dt date 
, PRIMARY KEY (com_menu_author_pk)
);
CREATE INDEX if_tb_com_menu_author_01 ON sc_khb_srv.tb_com_menu_author (author_no_pk);
CREATE INDEX if_tb_com_menu_author_02 ON sc_khb_srv.tb_com_menu_author (menu_no_pk);
CREATE UNIQUE INDEX pk_tb_com_menu_author ON sc_khb_srv.tb_com_menu_author (com_menu_author_pk);
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
REATE TABLE sc_khb_srv.tb_com_stplat_hist (
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------
CREATE TABLE sc_khb_srv.tb_svc_bass_info (
  svc_pk decimal(9,0) NOT NULL ,
  api_no_pk decimal(9,0),
  svc_nm nvarchar(500) ,
  svc_cl_code varchar(20),
  svc_ty_code varchar(20),
  svc_url varchar(4000),
  svc_cn nvarchar(4000),
  file_data_at char(1) ,
  othbc_at char(1) ,
  delete_at char(1) ,
  inqire_co decimal(15,0),
  use_provd_co decimal(15,0) ,
  regist_id varchar(100) ,
  regist_dt datetime DEFAULT current_timestamp,
  updt_id nvarchar(100),
  updt_dt datetime ,
  PRIMARY KEY (svc_pk)
);
CREATE UNIQUE INDEX pk_tb_svc_bass_info ON sc_khb_srv.tb_svc_bass_info (svc_pk);
-----------------------------------------------------------------------------------

-- ��Ÿ�� ����
/*varchar => nvarchar*/
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_author ALTER COLUMN author_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_author ALTER COLUMN rm_cn nvarchar(4000) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_author ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_author ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_crtfc_tmpr ALTER COLUMN moblphon_crtfc_sn nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_crtfc_tmpr ALTER COLUMN email_crtfc_sn nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_crtfc_tmpr ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_crtfc_tmpr ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_code ALTER COLUMN code_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS NOT NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_code ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_code ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_code ALTER COLUMN rm_cn nvarchar(4000) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_error_log ALTER COLUMN user_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_error_log ALTER COLUMN mthd_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_error_log ALTER COLUMN paramtr_cn nvarchar(4000) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_error_log ALTER COLUMN error_cn nvarchar(4000) COLLATE Korean_Wansung_CI_AS NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_error_log ALTER COLUMN requst_ip_adres nvarchar(200) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_error_log ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_error_log ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_faq ALTER COLUMN qestn_cn nvarchar(4000) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_faq ALTER COLUMN answer_cn nvarchar(4000) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_faq ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_faq ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group_author ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group_author ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group ALTER COLUMN group_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group ALTER COLUMN rm_cn nvarchar(4000) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_gtwy_svc_author ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_gtwy_svc_author ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_gtwy_svc ALTER COLUMN gtwy_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_gtwy_svc ALTER COLUMN rm_cn nvarchar(4000) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_gtwy_svc ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_gtwy_svc ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_gtwy_svc ALTER COLUMN gtwy_method_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_login_hist ALTER COLUMN user_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_login_hist ALTER COLUMN login_ip_adres nvarchar(200) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_login_hist ALTER COLUMN error_cn nvarchar(4000) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_login_hist ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_login_hist ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_menu ALTER COLUMN menu_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_menu ALTER COLUMN rm_cn nvarchar(4000) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_menu ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_menu ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_menu_author ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_menu_author ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_notice ALTER COLUMN sj_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_notice ALTER COLUMN rm_cn nvarchar(4000) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_notice ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_notice ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_qna ALTER COLUMN sj_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_qna ALTER COLUMN rm_cn nvarchar(4000) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_qna ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_qna ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_recsroom ALTER COLUMN sj_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_recsroom ALTER COLUMN rm_cn nvarchar(4000) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_recsroom ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_recsroom ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_stplat_info ALTER COLUMN file_cours_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_stplat_info ALTER COLUMN register_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_stplat_info ALTER COLUMN updusr_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_stplat_info ALTER COLUMN chnnl_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_svc_ip_manage ALTER COLUMN ip_adres nvarchar(200) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_svc_ip_manage ALTER COLUMN ip_use_instt_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_svc_ip_manage ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_svc_ip_manage ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_scrin ALTER COLUMN scrin_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_scrin ALTER COLUMN rm_cn nvarchar(4000) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_scrin ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_scrin ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_scrin_author ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_scrin_author ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_stplat_hist ALTER COLUMN file_cours_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;

DROP INDEX iu_tb_com_user_01 ON sc_khb_srv.tb_com_user;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN user_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
CREATE UNIQUE INDEX iu_tb_com_user_01 ON sc_khb_srv.tb_com_user (user_id);
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN user_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN moblphon_crtfc_sn nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN email_crtfc_sn nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN cmpny_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN pblinstt_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN dept_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN rspofc_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN refresh_tkn_cn nvarchar(4000) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN device_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN writng_realm_nm nvarchar(500) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user_group ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user_group ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user_author ALTER COLUMN regist_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user_author ALTER COLUMN updt_id nvarchar(100) COLLATE Korean_Wansung_CI_AS null;

/*���̺��̸��� �⺻�� �������Ǹ� ã��*/
SELECT name FROM sys.objects WHERE TYPE = 'D' AND parent_object_id = (SELECT object_id FROM sys.objects WHERE name = 'tb_com_user_group');

/*date => datetime*/
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_author ALTER COLUMN valid_pd_begin_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_author ALTER COLUMN valid_pd_end_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_author DROP CONSTRAINT DF__tb_com_au__regis__5D95E53A;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_author ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_author ADD CONSTRAINT DF_tb_com_author_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_author ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_code DROP CONSTRAINT DF__tb_com_co__regis__37703C52;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_code ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_code ADD CONSTRAINT DF_tb_com_code_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_code ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_crtfc_tmpr DROP CONSTRAINT DF__tb_com_cr__regis__31B762FC;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_crtfc_tmpr ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_crtfc_tmpr ADD CONSTRAINT DF_tb_com_crtfc_tmpr_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_crtfc_tmpr ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_error_log DROP CONSTRAINT DF__tb_com_er__regis__2EDAF651;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_error_log ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_error_log ADD CONSTRAINT DF_tb_com_error_log_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_error_log ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_faq DROP CONSTRAINT DF__tb_com_fa__regis__2645B050;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_faq ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_faq ADD CONSTRAINT DF_tb_com_faq_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_faq ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group ALTER COLUMN valid_pd_begin_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group ALTER COLUMN valid_pd_end_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group DROP CONSTRAINT DF__tb_com_gr__regis__7F2BE32F;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group ADD CONSTRAINT DF_tb_com_group_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group_author DROP CONSTRAINT DF__tb_com_gr__regis__5AB9788F;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group_author ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group_author ADD CONSTRAINT DF_tb_com_group_author_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_group_author ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_gtwy_svc DROP CONSTRAINT DF__tb_com_gt__regis__236943A5;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_gtwy_svc ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_gtwy_svc ADD CONSTRAINT DF_tb_com_gtwy_svc_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_gtwy_svc ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_gtwy_svc_author DROP CONSTRAINT DF__tb_com_gt__regis__208CD6FA;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_gtwy_svc_author ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_gtwy_svc_author ADD CONSTRAINT DF_tb_com_gtwy_svc_author_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_gtwy_svc_author ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_login_hist DROP CONSTRAINT DF__tb_com_lo__regis__2BFE89A6;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_login_hist ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_login_hist ADD CONSTRAINT DF_tb_com_login_hist_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_login_hist ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_menu DROP CONSTRAINT DF__tb_com_me__regis__797309D9;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_menu ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_menu ADD CONSTRAINT DF_tb_com_menu_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_menu ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_menu_author DROP CONSTRAINT DF__tb_com_me__regis__28ED12D1;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_menu_author ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_menu_author ADD CONSTRAINT DF_tb_com_menu_author_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_menu_author ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_notice DROP CONSTRAINT DF__tb_com_no__regis__29221CFB;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_notice ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_notice ADD CONSTRAINT DF_tb_com_notice_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_notice ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_qna DROP CONSTRAINT DF__tb_com_qn__regis__3493CFA7;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_qna ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_qna ADD CONSTRAINT DF_tb_com_qna_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_qna ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_recsroom DROP CONSTRAINT DF__tb_com_re__regis__17036CC0;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_recsroom ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_recsroom ADD CONSTRAINT DF_tb_com_recsroom_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_recsroom ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_scrin DROP CONSTRAINT DF__tb_com_sc__regis__04E4BC85;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_scrin ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_scrin ADD CONSTRAINT DF_tb_com_scrin_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_scrin ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_scrin_author DROP CONSTRAINT DF__tb_com_sc__regis__07C12930;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_scrin_author ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_scrin_author ADD CONSTRAINT DF_tb_com_scrin_author_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_scrin_author ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv. tb_com_stplat_hist ALTER COLUMN stplat_begin_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv. tb_com_stplat_hist ALTER COLUMN stplat_end_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_stplat_info ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_stplat_info ADD CONSTRAINT DF_tb_com_stplat_info_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_stplat_info ALTER COLUMN updt_dt datetime NULL;
/*
tb_com_stplat_info ���̺��� regist_dt���� ó������ �⺻���� X
���Ӱ� �߰�
*/

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_stplat_mapng ALTER COLUMN stplat_agre_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_stplat_mapng ALTER COLUMN stplat_reject_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_svc_ip_manage DROP CONSTRAINT DF__tb_com_sv__regis__70A8B9AE;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_svc_ip_manage ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_svc_ip_manage ADD CONSTRAINT DF_tb_com_svc_ip_manage_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_svc_ip_manage ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN last_login_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN error_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN email_recptn_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user DROP CONSTRAINT DF__tb_com_us__regis__10566F31;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ADD CONSTRAINT DF_tb_com_user_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN updt_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN sms_recptn_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user ALTER COLUMN user_sttus_change_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user_author DROP CONSTRAINT DF_tb_com_user_author_regis;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user_author ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user_author ADD CONSTRAINT DF_tb_com_user_author_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user_author ALTER COLUMN updt_dt datetime NULL;

ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user_group DROP CONSTRAINT DF_tb_com_user_group_regis;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user_group ALTER COLUMN regist_dt datetime NULL;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user_group ADD CONSTRAINT DF_tb_com_user_group_regis DEFAULT getdate() FOR regist_dt;
ALTER TABLE db_khb_srv.sc_khb_srv.tb_com_user_group ALTER COLUMN updt_dt datetime NULL;





-- ���̺�� comment
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_FAQ', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_QNA', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����Ʈ����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����Ʈ����_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��������', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�׷�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�׷�_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�α���_�̷�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�޴�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�޴�_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_������_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���_�̷�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_LOG', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_�׷�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_�ӽ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�ڷ��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�ڵ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_ȭ��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_ȭ��_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author';

-- �÷��� comment
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'��ȿ_�Ⱓ_����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'valid_pd_end_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'��ȿ_�Ⱓ_����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'valid_pd_begin_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'author_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�θ�_����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'parnts_author_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'author_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_author', @level2type=N'COLUMN', @level2name=N'orgnzt_manage_at';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�ڵ�_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'code_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'sort_ordr'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�ڵ�_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'code_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�ڵ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�θ�_�ڵ�_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_code', @level2type=N'COLUMN', @level2name=N'parnts_code_pk';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'crtfc_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_�ڵ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'crtfc_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�޴���_��ȣ', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'moblphon_no'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�޴���_����_�Ϸù�ȣ', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'moblphon_crtfc_sn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�޴���_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'moblphon_crtfc_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�̸���', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'email'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�̸���_����_�Ϸù�ȣ', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'email_crtfc_sn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�̸���_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'email_crtfc_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_crtfc_tmpr', @level2type=N'COLUMN', @level2name=N'updt_id';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'mthd_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'��û_IP_�ּ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'requst_ip_adres'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'error_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�Ķ����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'paramtr_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_LOG_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'error_log_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'user_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_error_log', @level2type=N'COLUMN', @level2name=N'url';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'ī�װ�_�ڵ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'ctgry_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_�ڵ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'svc_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'FAQ_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'faq_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'qestn_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�亯_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'answer_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_faq', @level2type=N'COLUMN', @level2name=N'updt_id';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�ڷ��_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'recsroom_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'user_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�̺�Ʈ_��ȣ_pk', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'event_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�ڷ�_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'othbc_dta_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'file_no_pk';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'orgnzt_manage_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�׷�_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'group_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�θ�_�׷�_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'parnts_group_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�׷�_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'group_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'��ȿ_�Ⱓ_����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'valid_pd_begin_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'��ȿ_�Ⱓ_����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'valid_pd_end_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'orgnzt_confm_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group', @level2type=N'COLUMN', @level2name=N'user_no_pk';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'author_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�׷�_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'group_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�׷�_����_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'com_group_author_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_group_author', @level2type=N'COLUMN', @level2name=N'regist_dt';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����Ʈ����_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'gtwy_url'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����Ʈ����_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'gtwy_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����Ʈ����_����_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'gtwy_svc_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����Ʈ����_�޼ҵ�_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'gtwy_method_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc', @level2type=N'COLUMN', @level2name=N'updt_id';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'author_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����Ʈ����_����_����_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'com_gtwy_svc_author_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����Ʈ����_����_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'gtwy_svc_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_gtwy_svc_author', @level2type=N'COLUMN', @level2name=N'updt_dt';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�α���_�̷�_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'login_hist_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'user_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�α���_IP_�ּ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'login_ip_adres'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'error_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�ڵ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'error_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'error_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_login_hist', @level2type=N'COLUMN', @level2name=N'regist_dt';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'ȭ��_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'scrin_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'orgnzt_manage_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�޴�_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'menu_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�θ�_�޴�_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'parnts_menu_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�޴�_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'menu_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'sort_ordr'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu', @level2type=N'COLUMN', @level2name=N'regist_dt';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�޴�_����_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'com_menu_author_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'author_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�޴�_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'menu_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'updt_dt';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'sj_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'��ȸ_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'inqire_co'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_�ڵ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'svc_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_�ڵ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'notice_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'notice_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'��������_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_notice', @level2type=N'COLUMN', @level2name=N'notice_no_pk';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'��ȸ_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'inqire_co'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'��������_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'qna_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�θ�_��������_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'parnts_qna_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'sj_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_��ȣ_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'secret_no_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_��ȣ', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'secret_no'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�亯_����_��ȣ', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'answer_dp_no'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_qna', @level2type=N'COLUMN', @level2name=N'updt_dt';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'file_use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'��ȸ_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'inqire_co'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'sj_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�ڷ��_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'recsroom_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_recsroom', @level2type=N'COLUMN', @level2name=N'updt_dt';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'ȭ��_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'scrin_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'excel_author_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'��ȸ_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'inqire_author_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'creat_author_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'rm_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'ȭ��_URL', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'scrin_url'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'ȭ��_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'scrin_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'updt_author_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin', @level2type=N'COLUMN', @level2name=N'delete_author_at';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_ȭ��_����_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'com_scrin_author_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'author_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'ȭ��_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'scrin_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_scrin_author', @level2type=N'COLUMN', @level2name=N'updt_dt';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'author_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'������_����_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'ip_manage_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'������_���_���_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'ip_use_instt_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'������_�ּ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_svc_ip_manage', @level2type=N'COLUMN', @level2name=N'ip_adres';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�̸���', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'email'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�̸���_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'email_crtfc_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�����_���_��ȣ', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'bsnm_regist_no'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���ε�_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'file_upload_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'file_no'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'ȸ��_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'cmpny_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�������_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'pblinstt_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�μ�_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'dept_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_sttus_change_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����ڵ�Ϲ�ȣ_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'bizrno_crtfc_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�̸���_����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'email_recptn_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�̸���_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'email_recptn_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'error_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_Ƚ��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'error_co'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�α���_������', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'last_login_ip'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�α���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'last_login_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'��ȣ_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'password_change_de'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'sbscrb_de'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_�ڵ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'��å_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'rspofc_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�θ�_����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'parnts_user_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'��й�ȣ', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'password'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�޴���_��ȣ', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'moblphon_no'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�޴���_����_�Ϸù�ȣ', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'moblphon_crtfc_sn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�޴���_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'moblphon_crtfc_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�̸���_����_�Ϸù�ȣ', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'email_crtfc_sn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_�ڵ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'user_sttus_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�ۼ�_�о�_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'writng_realm_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_�ڵ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'induty_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����̽� ���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'device_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'SMS_����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'sms_recptn_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'SMS_����_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'sms_recptn_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'��������_��ū_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'refresh_tkn_cn'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�α���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user', @level2type=N'COLUMN', @level2name=N'login_at';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'updt_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'user_author_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'user_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'author_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_author', @level2type=N'COLUMN', @level2name=N'regist_id';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_����_�׷�_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'com_user_group_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�׷�_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'group_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'user_no_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'regist_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_user_group', @level2type=N'COLUMN', @level2name=N'updt_id';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'������_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'updusr_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'regist_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'register_id'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'use_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'file_cours_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�ʼ�_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'essntl_at'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����_�ڵ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'stplat_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���_����_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'com_stplat_info_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'svc_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'updt_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'ä��_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_info', @level2type=N'COLUMN', @level2name=N'chnnl_id';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����_�ڵ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'stplat_se_code'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���_����_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'com_stplat_info_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���_�̷�_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'com_stplat_hist_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'stplat_end_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'stplat_begin_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���_��', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'file_cours_nm'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�ʼ�_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_hist', @level2type=N'COLUMN', @level2name=N'essntl_at';

EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng', @level2type=N'COLUMN', @level2name=N'stplat_agre_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���_����_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng', @level2type=N'COLUMN', @level2name=N'com_stplat_info_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���_����_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng', @level2type=N'COLUMN', @level2name=N'com_stplat_mapng_pk'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�ź�_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng', @level2type=N'COLUMN', @level2name=N'stplat_reject_dt'
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_stplat_mapng', @level2type=N'COLUMN', @level2name=N'user_no_pk';

-- com �������� ���� �ֱ�
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
grant select, insert, update, delete on sc_khb_srv.tb_com_menu_author to us_khb_com;
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
grant select, insert, update, delete on sc_khb_srv.tb_svc_bass_info to us_khb_com;

-- �������� tb_com_error_log DML���� �ֱ�
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_dev;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_agnt;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_exif;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_magnt;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_mptl;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_report;

-- ������ ����
CREATE SEQUENCE sc_khb_srv.sq_com_author
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_banner_info
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_bbs
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_bbs_cmnt
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
CREATE SEQUENCE sc_khb_srv.sq_com_ctpv_cd
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_com_emd_li_cd
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
CREATE SEQUENCE sc_khb_srv.sq_com_job_schdl_info
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
CREATE SEQUENCE sc_khb_srv.sq_com_menu_author
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
CREATE SEQUENCE sc_khb_srv.sq_com_sgg_cd
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
CREATE SEQUENCE sc_khb_srv.sq_svc_bass_info
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO
CREATE SEQUENCE sc_khb_srv.sq_svc_bass_info
     START WITH 1
     INCREMENT BY 1
     MINVALUE 1
     MAXVALUE 999999999
     CACHE
GO

-- ������ ���簪 �ľ�
SELECT name, object_name(schema_id), start_value FROM sys.sequences;

-- �������� �� �� �ľ�
SELECT count(*) FROM ;

-- ������ �� ����
ALTER SEQUENCE sc_khb_srv.sq_com_author RESTART WITH 5;
ALTER SEQUENCE sc_khb_srv.sq_com_banner_info RESTART WITH 13;
ALTER SEQUENCE sc_khb_srv.sq_com_bbs RESTART WITH 173;
ALTER SEQUENCE sc_khb_srv.sq_com_bbs_cmnt RESTART WITH 68;
ALTER SEQUENCE sc_khb_srv.sq_com_code RESTART WITH 8;
ALTER SEQUENCE sc_khb_srv.sq_com_crtfc_tmpr RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_ctpv_cd RESTART WITH 18;
ALTER SEQUENCE sc_khb_srv.sq_com_emd_li_cd RESTART WITH 23847;
ALTER SEQUENCE sc_khb_srv.sq_com_error_log RESTART WITH 153;
ALTER SEQUENCE sc_khb_srv.sq_com_faq RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_file_mapng RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_group RESTART WITH 5;
ALTER SEQUENCE sc_khb_srv.sq_com_group_author RESTART WITH 11;
ALTER SEQUENCE sc_khb_srv.sq_com_gtwy_svc RESTART WITH 68;
ALTER SEQUENCE sc_khb_srv.sq_com_gtwy_svc_author RESTART WITH 68;
ALTER SEQUENCE sc_khb_srv.sq_com_job_schdl_info RESTART WITH 13;
ALTER SEQUENCE sc_khb_srv.sq_com_login_hist RESTART WITH 52;
ALTER SEQUENCE sc_khb_srv.sq_com_menu RESTART WITH 18;
ALTER SEQUENCE sc_khb_srv.sq_com_menu_author RESTART WITH 31;
ALTER SEQUENCE sc_khb_srv.sq_com_notice RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_qna RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_recsroom RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_scrin RESTART WITH 17;
ALTER SEQUENCE sc_khb_srv.sq_com_scrin_author RESTART WITH 14;
ALTER SEQUENCE sc_khb_srv.sq_com_sgg_cd RESTART WITH 251;
ALTER SEQUENCE sc_khb_srv.sq_com_stplat_hist RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_stplat_info RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_stplat_mapng RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_svc_ip_manage RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_user RESTART WITH 12;
ALTER SEQUENCE sc_khb_srv.sq_com_user_author RESTART WITH 1;
ALTER SEQUENCE sc_khb_srv.sq_com_user_group RESTART WITH 12;
ALTER SEQUENCE sc_khb_srv.sq_svc_bass_info RESTART WITH 1;



-- com�������� ������ ����
grant UPDATE on sc_khb_srv.sq_com_author to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_banner_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_bbs to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_bbs_cmnt to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_code to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_crtfc_tmpr to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_ctpv_cd to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_emd_li_cd to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_error_log to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_faq to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_file_mapng to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_group to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_group_author to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_gtwy_svc to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_gtwy_svc_author to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_job_schdl_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_login_hist to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_menu to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_menu_author to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_notice to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_qna to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_recsroom to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_scrin to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_scrin_author to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_sgg_cd to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_stplat_hist to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_stplat_info to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_stplat_mapng to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_svc_ip_manage to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_user to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_user_author to us_khb_com;
grant UPDATE on sc_khb_srv.sq_com_user_group to us_khb_com;
grant UPDATE on sc_khb_srv.sq_svc_bass_info to us_khb_com;


-- adm�� com�� �� ������ �������� sq_com_error_log ���� �ֱ�
grant update on sc_khb_srv.sq_com_error_log to us_khb_dev;
grant update on sc_khb_srv.sq_com_error_log to us_khb_agnt;
grant update on sc_khb_srv.sq_com_error_log to us_khb_exif;
grant update on sc_khb_srv.sq_com_error_log to us_khb_magnt;
grant update on sc_khb_srv.sq_com_error_log to us_khb_mptl;
grant update on sc_khb_srv.sq_com_error_log to us_khb_report;
















