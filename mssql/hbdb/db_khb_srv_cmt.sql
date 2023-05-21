/*
mssql ����
    Microsoft SQL Server 2016 (SP3) (KB5003279) - 13.0.6300.2 (X64) 
	Aug  7 2021 01:20:37 
	Copyright (c) Microsoft Corporation
	Enterprise Evaluation Edition (64-bit) on Windows Server 2016 Standard Evaluation 10.0 <X64> (Build 14393: ) (Hypervisor)

��¥: 23-05-19

�ѹ� TESTDB�� ���� ������
*/

-- ����Ȯ��
SELECT @@version;

-- DB ����
CREATE DATABASE db_khb_srv;

-- ��Ű�� ����
USE db_khb_srv
GO
create schema sc_khb_srv;

-- �α��� ���� ����
USE master GO; /*���� �� �ص� ��� X*/
create login us_khb_adm with password = 'adm!#24', default_database = db_khb_srv;
create login us_khb_com with password = 'com!#24', default_database = db_khb_srv;
create login us_khb_dev with password = 'dev!#24', default_database = db_khb_srv;
create login us_khb_agent with password = 'agent!#24', default_database = db_khb_srv;
create login us_khb_exif with password = 'exif!#24', default_database = db_khb_srv;
create login us_khb_magnt with password = 'magnt!#24', default_database = db_khb_srv;
create login us_khb_mptl with password = 'mptl!#24', default_database = db_khb_srv;
create login us_khb_report with password = 'report!#24', default_database = db_khb_srv;

-- ���� ����
USE db_khb_srv GO;
create user us_khb_adm for login us_khb_adm with default_schema = sc_khb_srv;
create user us_khb_com for login us_khb_com with default_schema = sc_khb_srv;
create user us_khb_dev for login us_khb_dev with default_schema = sc_khb_srv;
create user us_khb_agent for login us_khb_agent with default_schema = sc_khb_srv;
create user us_khb_exif for login us_khb_exif with default_schema = sc_khb_srv;
create user us_khb_magnt for login us_khb_magnt with default_schema = sc_khb_srv;
create user us_khb_mptl for login us_khb_mptl with default_schema = sc_khb_srv;
create user us_khb_report for login us_khb_report with default_schema = sc_khb_srv;

-- ��Ű�� ���� �ο�
-- user 'sa'���� ����
GRANT control ON SCHEMA::sc_khb_srv TO us_khb_adm;
REVOKE control ON SCHEMA::sc_khb_srv from us_khb_adm;

-- ���� ���� �ο�
ALTER SERVER ROLE [dbcreator] ADD MEMBER [us_khb_adm];
ALTER SERVER ROLE [sysadmin] ADD MEMBER [us_khb_adm];

-- ALTER SERVER ROLE [dbcreator] drop MEMBER [us_khb_adm];
/*create login���� ������ "�α���"�� ROLE�� �ο�*/

-- ��Ű�� ���� Ȯ��
SELECT * FROM sys.schemas;

-- db �뷮 Ȯ��
EXEC sp_helpdb "db_khb_srv";

use db_khb_srv;
EXEC sp_spaceused 'db_khb_srv.sc_khb_srv.tb_com_author';

-- ���̺� ����
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





-- ���������� ���̺�
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





-- ���� ���̺�� comment
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�޴�_����', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author'

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

-- EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�ε���_���_����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'estate_word_dicary_no_pk'
-- EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�˾�_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_file_mapng', @level2type=N'COLUMN', @level2name=N'popup_no_pk'
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





-- ���� �÷��� comment
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�޴�_����_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'com_menu_author_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'author_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'�޴�_��ȣ_PK', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'menu_no_pk';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'regist_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'���_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'regist_dt';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_���̵�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'updt_id';
EXEC SP_ADDEXTENDEDPROPERTY @name=N'MS_Description', @value=N'����_�Ͻ�', @level0type=N'SCHEMA', @level0name=N'sc_khb_srv', @level1type=N'TABLE', @level1name=N'tb_com_menu_author', @level2type=N'COLUMN', @level2name=N'updt_dt';

-- com �������� ���� �ο�
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

-- adm�� com �� �������� tb_com_error_log DML���� �ο�
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_dev;
grant select, insert, update, delete on sc_khb_srv.tb_com_error_log to us_khb_agent;
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

-- com�������� ������ ����
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

-- adm�� com�� �� ������ �������� sq_com_error_log ���� �ֱ�
grant update on sc_khb_srv.sq_com_error_log to us_khb_dev;
grant update on sc_khb_srv.sq_com_error_log to us_khb_agent;
grant update on sc_khb_srv.sq_com_error_log to us_khb_exif;
grant update on sc_khb_srv.sq_com_error_log to us_khb_magnt;
grant update on sc_khb_srv.sq_com_error_log to us_khb_mptl;
grant update on sc_khb_srv.sq_com_error_log to us_khb_report;

EXEC sp_primarykeys @table_server='';
EXEC sp_helpdb "db_khb_srv";
