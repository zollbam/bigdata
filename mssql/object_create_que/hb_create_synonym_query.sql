/*
시노님 테이블 만들기 + 쿼리문 작성
2023-05-24
*/

-- 시노님 테이블 생성 스크립트
SELECT replace((SELECT 'CREATE SYNONYM ' + table_name + ' for ' + TABLE_SCHEMA + '.' + table_name + ';' + char(13) + char(10)
                FROM information_schema.tables
                FOR xml PATH(''))
               , '&#x0D;', '');

CREATE SYNONYM tb_com_scrin for sc_khb_srv.tb_com_scrin;
CREATE SYNONYM tb_com_scrin_author for sc_khb_srv.tb_com_scrin_author;
CREATE SYNONYM tb_com_user_author for sc_khb_srv.tb_com_user_author;
CREATE SYNONYM tb_com_user for sc_khb_srv.tb_com_user;
CREATE SYNONYM tb_com_file_mapng for sc_khb_srv.tb_com_file_mapng;
CREATE SYNONYM tb_com_stplat_mapng for sc_khb_srv.tb_com_stplat_mapng;
CREATE SYNONYM tb_com_recsroom for sc_khb_srv.tb_com_recsroom;
CREATE SYNONYM tb_com_stplat_info for sc_khb_srv.tb_com_stplat_info;
CREATE SYNONYM tb_com_stplat_hist for sc_khb_srv.tb_com_stplat_hist;
CREATE SYNONYM tb_com_job_schdl_info for sc_khb_srv.tb_com_job_schdl_info;
CREATE SYNONYM tb_com_banner_info for sc_khb_srv.tb_com_banner_info;
CREATE SYNONYM tb_com_gtwy_svc_author for sc_khb_srv.tb_com_gtwy_svc_author;
CREATE SYNONYM tb_com_gtwy_svc for sc_khb_srv.tb_com_gtwy_svc;
CREATE SYNONYM tb_com_faq for sc_khb_srv.tb_com_faq;
CREATE SYNONYM tb_com_menu_author for sc_khb_srv.tb_com_menu_author;
CREATE SYNONYM tb_com_notice for sc_khb_srv.tb_com_notice;
CREATE SYNONYM tb_com_login_hist for sc_khb_srv.tb_com_login_hist;
CREATE SYNONYM tb_com_error_log for sc_khb_srv.tb_com_error_log;
CREATE SYNONYM tb_com_crtfc_tmpr for sc_khb_srv.tb_com_crtfc_tmpr;
CREATE SYNONYM tb_com_qna for sc_khb_srv.tb_com_qna;
CREATE SYNONYM tb_com_code for sc_khb_srv.tb_com_code;
CREATE SYNONYM tb_com_bbs for sc_khb_srv.tb_com_bbs;
CREATE SYNONYM tb_com_bbs_cmnt for sc_khb_srv.tb_com_bbs_cmnt;
CREATE SYNONYM tb_com_user_group for sc_khb_srv.tb_com_user_group;
CREATE SYNONYM tb_com_group_author for sc_khb_srv.tb_com_group_author;
CREATE SYNONYM tb_com_author for sc_khb_srv.tb_com_author;
CREATE SYNONYM tb_com_ctpv_cd for sc_khb_srv.tb_com_ctpv_cd;
CREATE SYNONYM tb_com_svc_ip_manage for sc_khb_srv.tb_com_svc_ip_manage;
CREATE SYNONYM tb_com_emd_li_cd for sc_khb_srv.tb_com_emd_li_cd;
CREATE SYNONYM tb_com_sgg_cd for sc_khb_srv.tb_com_sgg_cd;
CREATE SYNONYM tb_com_menu for sc_khb_srv.tb_com_menu;
CREATE SYNONYM tb_com_group for sc_khb_srv.tb_com_group;

-- 시퀀스 => mssql에서는 시퀀스를 시노님으로 생성 불가
-- 시노님 시퀀스 생성할 기본 정보 
SELECT schema_name(schema_id) "schema_name", schema_id, name "sequence_name", object_id
FROM sys.sequences s;

-- 시노님 시퀀스 생성 스크립트
SELECT replace((SELECT 'CREATE SYNONYM ' + name + ' for ' + schema_name(schema_id) + '.' + name + ';' + char(13) + char(10)
                FROM sys.sequences
                FOR xml PATH(''))
               , '&#x0D;', '');

CREATE SYNONYM sq_com_menu_author for sc_khb_srv.sq_com_menu_author;
CREATE SYNONYM sq_com_author for sc_khb_srv.sq_com_author;
CREATE SYNONYM sq_com_code for sc_khb_srv.sq_com_code;
CREATE SYNONYM sq_com_crtfc_tmpr for sc_khb_srv.sq_com_crtfc_tmpr;
CREATE SYNONYM sq_com_error_log for sc_khb_srv.sq_com_error_log;
CREATE SYNONYM sq_com_faq for sc_khb_srv.sq_com_faq;
CREATE SYNONYM sq_com_file_mapng for sc_khb_srv.sq_com_file_mapng;
CREATE SYNONYM sq_com_group for sc_khb_srv.sq_com_group;
CREATE SYNONYM sq_com_group_author for sc_khb_srv.sq_com_group_author;
CREATE SYNONYM sq_com_gtwy_svc for sc_khb_srv.sq_com_gtwy_svc;
CREATE SYNONYM sq_com_gtwy_svc_author for sc_khb_srv.sq_com_gtwy_svc_author;
CREATE SYNONYM sq_com_login_hist for sc_khb_srv.sq_com_login_hist;
CREATE SYNONYM sq_com_menu for sc_khb_srv.sq_com_menu;
CREATE SYNONYM sq_com_notice for sc_khb_srv.sq_com_notice;
CREATE SYNONYM sq_com_qna for sc_khb_srv.sq_com_qna;
CREATE SYNONYM sq_com_recsroom for sc_khb_srv.sq_com_recsroom;
CREATE SYNONYM sq_com_scrin for sc_khb_srv.sq_com_scrin;
CREATE SYNONYM sq_com_scrin_author for sc_khb_srv.sq_com_scrin_author;
CREATE SYNONYM sq_com_stplat_hist for sc_khb_srv.sq_com_stplat_hist;
CREATE SYNONYM sq_com_stplat_info for sc_khb_srv.sq_com_stplat_info;
CREATE SYNONYM sq_com_stplat_mapng for sc_khb_srv.sq_com_stplat_mapng;
CREATE SYNONYM sq_com_svc_ip_manage for sc_khb_srv.sq_com_svc_ip_manage;
CREATE SYNONYM sq_com_user for sc_khb_srv.sq_com_user;
CREATE SYNONYM sq_com_user_author for sc_khb_srv.sq_com_user_author;
CREATE SYNONYM sq_com_user_group for sc_khb_srv.sq_com_user_group;



CREATE SYNONYM sq_com_user_group for sc_khb_srv.PK__tb_com_a__53DDB1248A6843F9;
