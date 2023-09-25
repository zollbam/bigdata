/*
작성 일자 : 230920
수정 일자 : 
작 성 자 : 조건영
작성 목적 : mssql에서 테이블 => txt 
*/



-- tb_com_author
declare @sql nvarchar(4000) = 'bcp ' +
'"select '+
  'iif(author_no_pk is null or len(author_no_pk)=0, null, author_no_pk)' + -- author_no_pk
', iif(parnts_author_no_pk is null or len(parnts_author_no_pk)=0, null, parnts_author_no_pk)' + -- parnts_author_no_pk
', iif(author_nm is null or len(author_nm)=0, null, author_nm)' + -- author_nm
', iif(rm_cn is null or len(rm_cn)=0, null, rm_cn)' + -- rm_cn
', iif(use_at is null or len(use_at)=0, null, use_at)' + -- use_at
', iif(valid_pd_begin_dt is null or len(valid_pd_begin_dt)=0, null, valid_pd_begin_dt)' + -- valid_pd_begin_dt
', iif(valid_pd_end_dt is null or len(valid_pd_end_dt)=0, null, valid_pd_end_dt)' + -- valid_pd_end_dt
', iif(regist_id is null or len(regist_id)=0, null, regist_id)' + -- regist_id
', iif(regist_dt is null or len(regist_dt)=0, null, regist_dt)' + -- regist_dt
', iif(updt_id is null or len(updt_id)=0, null, updt_id)' + -- updt_id
', iif(updt_dt is null or len(updt_dt)=0, null, updt_dt)' + -- updt_dt
', iif(orgnzt_manage_at is null or len(orgnzt_manage_at)=0, null, orgnzt_manage_at)' + -- orgnzt_manage_at
'   from sc_khb_srv.tb_com_author" ' +
'queryout "D:\migra_data\mssql_com_author.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;





-- com_code
declare @sql varchar(8000) = 'bcp ' +
'"SELECT ' + 
'  ROW_NUMBER () OVER(ORDER BY parnts_code_pk, code_pk)+1131' + -- code_pk
', RANK () OVER(ORDER BY parnts_code_pk)+1131' + -- parnts_code_pk
', iif(code IS NULL OR len(code)=0, NULL, code)' + -- code
', iif(code_nm IS NULL OR len(code_nm)=0, NULL, code_nm)' + -- code_nm
', iif(sort_ordr IS NULL OR len(sort_ordr)=0, NULL, sort_ordr)' + -- sort_ordr
', iif(use_at IS NULL OR len(use_at)=0, NULL, use_at)' + -- use_at
', iif(regist_id IS NULL OR len(regist_id)=0, NULL, regist_id)' + -- regist_id
', iif(regist_dt IS NULL OR len(regist_dt)=0, NULL, regist_dt)' + -- regist_dt
', iif(updt_id IS NULL OR len(updt_id)=0, NULL, updt_id)' + -- updt_id
', iif(updt_dt IS NULL OR len(updt_dt)=0, NULL, updt_dt)' + -- updt_dt
', iif(rm_cn IS NULL OR len(rm_cn)=0, NULL, rm_cn)' + -- rm_cn
', iif(parnts_code IS NULL OR len(parnts_code)=0, NULL, parnts_code)' + -- parnts_code
' from sc_khb_srv.tb_com_code where code_pk < 12 OR code_pk > 1231" ' +
' queryout "D:\migra_data\mssql_com_code.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;





-- tb_com_crtfc_tmpr
declare @sql nvarchar(4000) = 'bcp ' +
'"select '+
  'iif(crtfc_pk is null or len(crtfc_pk)=0, null, crtfc_pk)' + -- crtfc_pk
', iif(crtfc_se_code is null or len(crtfc_se_code)=0, null, crtfc_se_code)' + -- crtfc_se_code
', iif(soc_lgn_ty_cd is null or len(soc_lgn_ty_cd)=0, null, soc_lgn_ty_cd)' + -- soc_lgn_ty_cd
', iif(moblphon_no is null or len(moblphon_no)=0, null, moblphon_no)' + -- moblphon_no
', iif(moblphon_crtfc_sn is null or len(moblphon_crtfc_sn)=0, null, moblphon_crtfc_sn)' + -- moblphon_crtfc_sn
', iif(moblphon_crtfc_at is null or len(moblphon_crtfc_at)=0, null, moblphon_crtfc_at)' + -- moblphon_crtfc_at
', iif(email is null or len(email)=0, null, email)' + -- email
', iif(email_crtfc_sn is null or len(email_crtfc_sn)=0, null, email_crtfc_sn)' + -- email_crtfc_sn
', iif(email_crtfc_at is null or len(email_crtfc_at)=0, null, email_crtfc_at)' + -- email_crtfc_at
', iif(sns_crtfc_sn is null or len(sns_crtfc_sn)=0, null, sns_crtfc_sn)' + -- sns_crtfc_sn 
', iif(sns_crtfc_at is null or len(sns_crtfc_at)=0, null, sns_crtfc_at)' + -- sns_crtfc_at
', iif(regist_id is null or len(regist_id)=0, null, regist_id)' + -- regist_id
', iif(regist_dt is null or len(regist_dt)=0, null, regist_dt)' + -- regist_dt
', iif(updt_id is null or len(updt_id)=0, null, updt_id)' + -- updt_id
', iif(updt_dt is null or len(updt_dt)=0, null, updt_dt)' + -- updt_dt
'   from sc_khb_srv.tb_com_crtfc_tmpr" ' +
'queryout "D:\migra_data\mssql_com_crtfc_tmpr.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;





-- tb_com_group
declare @sql nvarchar(4000) = 'bcp ' +
'"select '+
  'iif(group_no_pk is null or len(group_no_pk)=0, null, group_no_pk)' + -- group_no_pk
', iif(parnts_group_no_pk is null or len(parnts_group_no_pk)=0, null, parnts_group_no_pk)' + -- parnts_group_no_pk
', iif(group_nm is null or len(group_nm)=0, null, group_nm)' + -- group_nm
', iif(use_at is null or len(use_at)=0, null, use_at)' + -- use_at
', iif(rm_cn is null or len(rm_cn)=0, null, rm_cn)' + -- rm_cn
', iif(valid_pd_begin_dt is null or len(valid_pd_begin_dt)=0, null, valid_pd_begin_dt)' + -- valid_pd_begin_dt
', iif(valid_pd_end_dt is null or len(valid_pd_end_dt)=0, null, valid_pd_end_dt)' + -- valid_pd_end_dt
', iif(regist_id is null or len(regist_id)=0, null, regist_id)' + -- regist_id
', iif(regist_dt is null or len(regist_dt)=0, null, regist_dt)' + -- regist_dt
', iif(updt_id is null or len(updt_id)=0, null, updt_id)' + -- updt_id
', iif(updt_dt is null or len(updt_dt)=0, null, updt_dt)' + -- updt_dt
'   from sc_khb_srv.tb_com_group" ' +
'queryout "D:\migra_data\mssql_com_group.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;





-- tb_com_group_author
declare @sql nvarchar(4000) = 'bcp ' +
'"select '+
  'iif(com_group_author_pk is null or len(com_group_author_pk)=0, null, com_group_author_pk)' + -- com_group_author_pk
', iif(group_no_pk is null or len(group_no_pk)=0, null, group_no_pk)' + -- group_no_pk
', iif(author_no_pk is null or len(author_no_pk)=0, null, author_no_pk)' + -- author_no_pk
', iif(regist_id is null or len(regist_id)=0, null, regist_id)' + -- regist_id
', iif(regist_dt is null or len(regist_dt)=0, null, regist_dt)' + -- regist_dt
', iif(updt_id is null or len(updt_id)=0, null, updt_id)' + -- updt_id
', iif(updt_dt is null or len(updt_dt)=0, null, updt_dt)' + -- updt_dt
'   from sc_khb_srv.tb_com_group_author" ' +
'queryout "D:\migra_data\mssql_com_group_author.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;





-- tb_com_gtwy_svc
declare @sql nvarchar(4000) = 'bcp ' +
'"select '+
  'iif(gtwy_svc_pk is null or len(gtwy_svc_pk)=0, null, gtwy_svc_pk)' + -- gtwy_svc_pk
', iif(gtwy_nm is null or len(gtwy_nm)=0, null, gtwy_nm)' + -- gtwy_nm
', iif(gtwy_url is null or len(gtwy_url)=0, null, gtwy_url)' + -- gtwy_url
', iif(rm_cn is null or len(rm_cn)=0, null, rm_cn)' + -- rm_cn
', iif(use_at is null or len(use_at)=0, null, use_at)' + -- use_at
', iif(regist_id is null or len(regist_id)=0, null, regist_id)' + -- regist_id
', iif(regist_dt is null or len(regist_dt)=0, null, regist_dt)' + -- regist_dt
', iif(updt_id is null or len(updt_id)=0, null, updt_id)' + -- updt_id
', iif(updt_dt is null or len(updt_dt)=0, null, updt_dt)' + -- updt_dt
', iif(gtwy_method_nm is null or len(gtwy_method_nm)=0, null, gtwy_method_nm)' + -- gtwy_method_nm
'   from sc_khb_srv.tb_com_gtwy_svc" ' +
'queryout "D:\migra_data\mssql_com_gtwy_svc.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;





-- tb_com_gtwy_svc_author
declare @sql nvarchar(4000) = 'bcp ' +
'"select '+
  'iif(com_gtwy_svc_author_pk is null or len(com_gtwy_svc_author_pk)=0, null, com_gtwy_svc_author_pk)' + -- com_gtwy_svc_author_pk
', iif(author_no_pk is null or len(author_no_pk)=0, null, author_no_pk)' + -- author_no_pk
', iif(gtwy_svc_pk is null or len(gtwy_svc_pk)=0, null, gtwy_svc_pk)' + -- gtwy_svc_pk
', iif(regist_id is null or len(regist_id)=0, null, regist_id)' + -- regist_id
', iif(regist_dt is null or len(regist_dt)=0, null, regist_dt)' + -- regist_dt
', iif(updt_id is null or len(updt_id)=0, null, updt_id)' + -- updt_id
', iif(updt_dt is null or len(updt_dt)=0, null, updt_dt)' + -- updt_dt
'   from sc_khb_srv.tb_com_gtwy_svc_author" ' +
'queryout "D:\migra_data\mssql_com_gtwy_svc_author.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;





-- tb_com_job_schdl_info
declare @sql nvarchar(4000) = 'bcp ' +
'"select '+
  'iif(job_schdl_info_pk is null or len(job_schdl_info_pk)=0, null, job_schdl_info_pk)' + -- job_schdl_info_pk
', iif(job_se_cd is null or len(job_se_cd)=0, null, job_se_cd)' + -- job_se_cd
', iif(job_nm is null or len(job_nm)=0, null, job_nm)' + -- job_nm
', iif(job_cycle is null or len(job_cycle)=0, null, job_cycle)' + -- job_cycle
', iif(last_excn_dt is null or len(last_excn_dt)=0, null, last_excn_dt)' + -- last_excn_dt
', iif(synchrn_pnttm_vl is null or len(synchrn_pnttm_vl)=0, null, synchrn_pnttm_vl)' + -- synchrn_pnttm_vl
', iif(excn_srvc_nm is null or len(excn_srvc_nm)=0, null, excn_srvc_nm)' + --excn_srvc_nm
', iif(job_expln_cn is null or len(job_expln_cn)=0, null, job_expln_cn)' + -- job_expln_cn
'   from sc_khb_srv.tb_com_job_schdl_info ' +
'  where job_se_cd != ''06''" ' + -- 우리쪽에서 새로 추가한 배치들
'queryout "D:\migra_data\mssql_com_job_schdl_info.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;





-- tb_com_menu
declare @sql nvarchar(4000) = 'bcp ' +
'"select '+
  'iif(menu_no_pk is null or len(menu_no_pk)=0, null, menu_no_pk)' + -- menu_no_pk
', iif(parnts_menu_no_pk is null or len(parnts_menu_no_pk)=0, null, parnts_menu_no_pk)' + -- parnts_menu_no_pk
', iif(menu_nm is null or len(menu_nm)=0, null, menu_nm)' + -- menu_nm
', iif(sort_ordr is null or len(sort_ordr)=0, null, sort_ordr)' + -- sort_ordr
', iif(use_at is null or len(use_at)=0, null, use_at)' + -- use_at
', iif(rm_cn is null or len(rm_cn)=0, null, rm_cn)' + -- rm_cn
', iif(regist_id is null or len(regist_id)=0, null, regist_id)' + -- regist_id
', iif(regist_dt is null or len(regist_dt)=0, null, regist_dt)' + -- regist_dt
', iif(updt_id is null or len(updt_id)=0, null, updt_id)' + -- updt_id
', iif(updt_dt is null or len(updt_dt)=0, null, updt_dt)' + -- updt_dt
', iif(scrin_no_pk is null or len(scrin_no_pk)=0, null, scrin_no_pk)' + -- scrin_no_pk
', iif(orgnzt_manage_at is null or len(orgnzt_manage_at)=0, null, orgnzt_manage_at)' + -- orgnzt_manage_at
', iif(aplctn_code is null or len(aplctn_code)=0, null, aplctn_code)' + -- aplctn_code
'   from sc_khb_srv.tb_com_menu" ' +
'queryout "D:\migra_data\mssql_com_menu.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;





-- tb_com_menu_author
declare @sql nvarchar(4000) = 'bcp ' +
'"select '+
  'iif(com_menu_author_pk is null or len(com_menu_author_pk)=0, null, com_menu_author_pk)' + -- com_menu_author_pk
', iif(author_no_pk is null or len(author_no_pk)=0, null, author_no_pk)' + -- author_no_pk
', iif(menu_no_pk is null or len(menu_no_pk)=0, null, menu_no_pk)' + -- menu_no_pk
', iif(regist_id is null or len(regist_id)=0, null, regist_id)' + -- regist_id
', iif(regist_dt is null or len(regist_dt)=0, null, regist_dt)' + -- regist_dt
', iif(updt_id is null or len(updt_id)=0, null, updt_id)' + -- updt_id
', iif(updt_dt is null or len(updt_dt)=0, null, updt_dt)' + -- updt_dt
'   from sc_khb_srv.tb_com_menu_author" ' +
'queryout "D:\migra_data\mssql_com_menu_author.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;





-- tb_com_push_meta_info
declare @sql nvarchar(4000) = 'bcp ' +
'"select '+
  'iif(push_meta_info_pk is null or len(push_meta_info_pk)=0, null, push_meta_info_pk)' + -- push_meta_info_pk
', iif(push_nm is null or len(push_nm)=0, null, push_nm)' + -- push_nm
', iif(trsm_se_cd is null or len(trsm_se_cd)=0, null, trsm_se_cd)' + -- trsm_se_cd
', iif(tpc_nm is null or len(tpc_nm)=0, null, tpc_nm)' + -- tpc_nm
', iif(user_se_cd is null or len(user_se_cd)=0, null, user_se_cd)' + -- user_se_cd
', iif(retransm_yn is null or len(retransm_yn)=0, null, retransm_yn)' + -- retransm_yn
', iif(retransm_cycle is null or len(retransm_cycle)=0, null, retransm_cycle)' + -- retransm_cycle
', iif(use_yn is null or len(use_yn)=0, null, use_yn)' + -- use_yn
', iif(dstrbnc_prhibt_excl_yn is null or len(dstrbnc_prhibt_excl_yn)=0, null, dstrbnc_prhibt_excl_yn)' + -- dstrbnc_prhibt_excl_yn
', iif(reg_id is null or len(reg_id)=0, null, reg_id)' + -- reg_id
', iif(reg_dt is null or len(reg_dt)=0, null, reg_dt)' + -- reg_dt
', iif(mdfcn_id is null or len(mdfcn_id)=0, null, mdfcn_id)' + -- mdfcn_id
', iif(mdfcn_dt is null or len(mdfcn_dt)=0, null, mdfcn_dt)' + -- mdfcn_dt
', iif(push_yn is null or len(push_yn)=0, null, push_yn)' + -- push_yn
'   from sc_khb_srv.tb_com_push_meta_info" ' +
'queryout "D:\migra_data\mssql_com_push_meta_info.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;




-- tb_com_scrin
declare @sql nvarchar(4000) = 'bcp ' +
'"select '+
  'iif(scrin_no_pk is null or len(scrin_no_pk)=0, null, scrin_no_pk)' + -- scrin_no_pk
', iif(scrin_nm is null or len(scrin_nm)=0, null, scrin_nm)' + -- scrin_nm
', iif(scrin_url is null or len(scrin_url)=0, null, scrin_url)' + -- scrin_url
', iif(rm_cn is null or len(rm_cn)=0, null, rm_cn)' + -- rm_cn
', iif(use_at is null or len(use_at)=0, null, use_at)' + -- use_at
', iif(creat_author_at is null or len(creat_author_at)=0, null, creat_author_at)' + -- creat_author_at
', iif(inqire_author_at is null or len(inqire_author_at)=0, null, inqire_author_at)' + -- inqire_author_at
', iif(updt_author_at is null or len(updt_author_at)=0, null, updt_author_at)' + -- updt_author_at
', iif(delete_author_at is null or len(delete_author_at)=0, null, delete_author_at)' + -- delete_author_at
', iif(excel_author_at is null or len(excel_author_at)=0, null, excel_author_at)' + -- excel_author_at
', iif(regist_id is null or len(regist_id)=0, null, regist_id)' + -- regist_id
', iif(regist_dt is null or len(regist_dt)=0, null, regist_dt)' + -- regist_dt
', iif(updt_id is null or len(updt_id)=0, null, updt_id)' + -- updt_id
', iif(updt_dt is null or len(updt_dt)=0, null, updt_dt)' + -- updt_dt
'   from sc_khb_srv.tb_com_scrin" ' +
'queryout "D:\migra_data\mssql_com_scrin.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;





-- tb_com_scrin_author
declare @sql nvarchar(4000) = 'bcp ' +
'"select '+
  'iif(com_scrin_author_pk is null or len(com_scrin_author_pk)=0, null, com_scrin_author_pk)' + -- com_scrin_author_pk
', iif(author_no_pk is null or len(author_no_pk)=0, null, author_no_pk)' + -- author_no_pk
', iif(scrin_no_pk is null or len(scrin_no_pk)=0, null, scrin_no_pk)' + -- scrin_no_pk
', iif(regist_id is null or len(regist_id)=0, null, regist_id)' + -- regist_id
', iif(regist_dt is null or len(regist_dt)=0, null, regist_dt)' + -- regist_dt
', iif(updt_id is null or len(updt_id)=0, null, updt_id)' + -- updt_id
', iif(updt_dt is null or len(updt_dt)=0, null, updt_dt)' + -- updt_dt
'   from sc_khb_srv.tb_com_scrin_author" ' +
'queryout "D:\migra_data\mssql_com_scrin_author.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;





-- tb_com_rss_info
declare @sql varchar(8000) = 'bcp ' +
'"SELECT ' + 
'  iif(rss_info_pk is null or len(rss_info_pk)=0, null, rss_info_pk)' + -- rss_info_pk
', iif(rss_se_cd is null or len(rss_se_cd)=0, null, rss_se_cd)' + -- rss_se_cd
', iif(ttl_nm is null or len(ttl_nm)=0, null, ttl_nm)' + -- ttl_nm
', iif(cn is null or len(cn)=0, null, cn)' + -- cn
', iif(hmpg_url is null or len(hmpg_url)=0, null, hmpg_url)' + -- hmpg_url
', iif(thumb_url is null or len(thumb_url)=0, null, thumb_url)' + -- thumb_url
', iif(hashtag_list is null or len(hashtag_list)=0, null, hashtag_list)' + -- hashtag_list
', iif(pstg_day is null or len(pstg_day)=0, null, pstg_day)' + -- pstg_day
', iif(inq_cnt is null or len(inq_cnt)=0, null, inq_cnt)' + -- inq_cnt
', iif(reg_id is null or len(reg_id)=0, null, reg_id)' + -- reg_id
', iif(reg_dt is null or len(reg_dt)=0, null, reg_dt)' + -- reg_dt
', iif(mdfcn_id is null or len(mdfcn_id)=0, null, mdfcn_id)' + -- mdfcn_id
', iif(mdfcn_dt is null or len(mdfcn_dt)=0, null, mdfcn_dt)' + -- mdfcn_dt
', iif(wrtr_nm is null or len(wrtr_nm)=0, null, wrtr_nm)' + -- wrtr_nm
', iif(id_vl is null or len(id_vl)=0, null, id_vl)' + -- id_vl
'   FROM sc_khb_srv.tb_com_rss_info" ' + 
'queryout "D:\migra_data\mssql_com_rss_info.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;








-- tb_user_atlfsl_thema_info
declare @sql nvarchar(4000) = 'bcp ' +
'"select '+
  'iif(user_atlfsl_thema_info_pk is null or len(user_atlfsl_thema_info_pk)=0, null, user_atlfsl_thema_info_pk)' + -- user_atlfsl_thema_info_pk
', iif(user_atlfsl_info_pk is null or len(user_atlfsl_info_pk)=0, null, user_atlfsl_info_pk)' + -- user_atlfsl_info_pk
', iif(thema_info_pk is null or len(thema_info_pk)=0, null, thema_info_pk)' + -- thema_info_pk
', iif(reg_id is null or len(reg_id)=0, null, reg_id)' + -- reg_id
', iif(reg_dt is null or len(reg_dt)=0, null, reg_dt)' + -- reg_dt
', iif(mdfcn_id is null or len(mdfcn_id)=0, null, mdfcn_id)' + -- mdfcn_id
', iif(mdfcn_dt is null or len(mdfcn_dt)=0, null, mdfcn_dt)' + -- mdfcn_dt
'   from sc_khb_srv.tb_user_atlfsl_thema_info" ' +
'queryout "D:\migra_data\mssql_user_atlfsl_thema_info.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;





----------------------------------------------insert-------------------------------------------------------
-- com_user
SELECT 'update sc_khb_srv.tb_com_user ' + 
       ' set parnts_user_no_pk ' + char(10) +
       ' set parnts_user_no_pk ' + char(10) +
       ' 
  FROM sc_khb_srv.tb_com_user tcu;
 WHERE user_se_code = '01'
   AND user_no_pk = 1;































































