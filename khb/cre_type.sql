/*
사용자 타입을 생성하는 파일
작성 일시: 23-06-25
수정 일시: 23-06-29
작 성 자 : 조건영
*/

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

drop TYPE [sc_khb_srv].[sn_v100];
/*alter table [sc_khb_srv].tb_lttot_info alter column ctrt_pd [sc_khb_srv].[pd_nv50]*/

/*drop TYPE [sc_khb_srv].[day_v10]
 
alter table [sc_khb_srv].tb_atlfsl_reside_set_dtl_info alter column cmcn_day [sc_khb_srv].[day_nv100]
alter table [sc_khb_srv].tb_atlfsl_reside_gnrl_dtl_info alter column cmcn_day [sc_khb_srv].[day_nv100]
alter table [sc_khb_srv].tb_atlfsl_cmrc_dtl_info alter column cmcn_day [sc_khb_srv].[day_nv100]
alter table [sc_khb_srv].tb_atlfsl_etc_dtl_info alter column cmcn_day [sc_khb_srv].[day_nv100]
alter table [sc_khb_srv].tb_atlfsl_reside_set_dtl_info_t alter column cmcn_day [sc_khb_srv].[day_nv100]
  
alter table [sc_khb_srv].tb_lttot_info alter column rcrit_pbanc_day [sc_khb_srv].[day_nv100]
alter table [sc_khb_srv].tb_lttot_info alter column przwner_prsntn_day [sc_khb_srv].[day_nv100]
alter table [sc_khb_srv].tb_lttot_info alter column mvn_prnmnt_day [sc_khb_srv].[day_nv100]
alter table [sc_khb_srv].tb_lttot_info alter column mdlhs_opnng_day [sc_khb_srv].[day_nv100]
alter table [sc_khb_srv].tb_lttot_info alter column reg_day [sc_khb_srv].[day_nv100]*/



/*
alter table [sc_khb_srv].tb_lttot_info alter column lttot_info_ttl [sc_khb_srv].[ttl_nv100]
CREATE TYPE [ttl_nv100]
    FROM NATIONAL CHARACTER VARYING(100) NULL
go
*/


/*drop TYPE [sc_khb_srv].[day_v8]

alter table [sc_khb_srv].tb_atlfsl_reside_set_dtl_info alter column cmcn_day [sc_khb_srv].[day_v10]
alter table [sc_khb_srv].tb_atlfsl_reside_gnrl_dtl_info alter column cmcn_day [sc_khb_srv].[day_v10]
alter table [sc_khb_srv].tb_atlfsl_cmrc_dtl_info alter column cmcn_day [sc_khb_srv].[day_v10]
alter table [sc_khb_srv].tb_atlfsl_etc_dtl_info alter column cmcn_day [sc_khb_srv].[day_v10]
alter table [sc_khb_srv].tb_atlfsl_reside_set_dtl_info_t alter column cmcn_day [sc_khb_srv].[day_v10]*/

--drop TYPE [sc_khb_srv].[telno_v20];
--
--alter table [sc_khb_srv].tb_atlfsl_bsc_info alter column pic_telno [sc_khb_srv].[telno_v30]
--alter table [sc_khb_srv].tb_hsmp_info alter column mngoffice_telno [sc_khb_srv].[telno_v30]
--select *
--  from db_khb_srv.sc_khb_srv.tb_hsmp_info