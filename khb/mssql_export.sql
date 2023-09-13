/*
mssql에서 결과 쿼리를 txt로 만드는 파일
시작 일시: 23-06-28
수정 일시: 230907
작 성 자 : 조건영
*/

-- sp_configure 활성화
-- To allow advanced options to be changed.  
EXECUTE sp_configure 'show advanced options', 1;  

-- To update the currently configured value for advanced options.  
RECONFIGURE;

-- To enable the feature.  
EXECUTE sp_configure 'xp_cmdshell', 1;  

-- To update the currently configured value for this feature.  
RECONFIGURE;  

-- 테이블명을 선언하여 bcp 쿼리문 만들기(단독 테이블)
--DECLARE @table_name varchar(500) = 'tb_atlfsl_bsc_info';
--SELECT 
--  'declare @sql varchar(8000) = ''bcp '' +' + char(10) + 
--  '''"SELECT '' + ' +
--  stuff((
--         SELECT char(10) +
--                CASE WHEN COLUMN_NAME = (SELECT COLUMN_NAME FROM information_schema.columns WHERE ordinal_position=1 AND TABLE_NAME = @table_name)
--                         THEN concat('''  iif(', COLUMN_NAME, ' is null or len(', COLUMN_NAME, ')=0, null, ', COLUMN_NAME, ')'' +')
----                     WHEN COLUMN_NAME = (SELECT TOP 1 COLUMN_NAME FROM information_schema.columns WHERE TABLE_NAME = @table_name ORDER BY ordinal_position DESC)
----                         THEN concat('''  iif(', COLUMN_NAME, ' is null or len(', COLUMN_NAME, ')=0, null, ', COLUMN_NAME, ')''')
--                     ELSE concat(''', iif(', COLUMN_NAME, ' is null or len(', COLUMN_NAME, ')=0, null, ', COLUMN_NAME, ')'' +')
--                END
--           FROM information_schema.columns
--          WHERE table_name = @table_name
--          ORDER BY ordinal_position
--            FOR xml PATH('')), 1, 1 ,char(10)) + char(10) +
--  '''   FROM sc_khb_srv.' + @table_name + '" '' + ' + char(10) +
--  '''queryout "D:\migra_data\' + replace(@table_name, 'tb_', 'mssql_') + '.txt" -w -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv'';' + char(10) +
--  'EXEC xp_cmdshell @sql;';
 
-- 테이블명을 선언하여 bcp 쿼리문 만들기(모든 테이블)
SELECT 
   c2.TABLE_NAME  
, 'declare @sql varchar(8000) = ''bcp '' +' + char(10) + 
  '''"SELECT '' + ' +
  stuff((
         SELECT char(10) +
                CASE WHEN c1.COLUMN_NAME IN (SELECT COLUMN_NAME FROM information_schema.columns WHERE ordinal_position=1)
                         THEN concat('''  iif(', c1.COLUMN_NAME, ' is null or len(', c1.COLUMN_NAME, ')=0, null, ', c1.COLUMN_NAME, ')'' +')
                     ELSE concat(''', iif(', c1.COLUMN_NAME, ' is null') + CASE WHEN RIGHT(c1.COLUMN_NAME, 5) = 'crdnt' THEN ''
                                                                                ELSE ' or len(' + c1.COLUMN_NAME + ')=0' 
                                                                           END +
                ', null, ' + c1.COLUMN_NAME + ')'' +'
                END 
           FROM information_schema.columns c1
          WHERE c1.TABLE_NAME = c2.TABLE_NAME 
          ORDER BY ordinal_position
            FOR xml PATH('')), 1, 1 ,char(10)) + char(10) +
  '''   FROM sc_khb_srv.' + c2.table_name + '" '' + ' + char(10) +
  '''queryout "D:\migra_data\' + replace(c2.table_name, 'tb_', 'mssql_') + '.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv'';' + char(10) +
  'EXEC xp_cmdshell @sql;'
  FROM information_schema.columns c2
 GROUP BY c2.TABLE_NAME 
 ORDER BY 1;

-- 특정 테이블 bcp 쿼리문 만들기
SELECT 
  TABLE_NAME ,
  'declare @sql nvarchar(4000) = ''bcp '' +' + char(10) + 
  '''"select ''+' + char(10) + '  ' +
  stuff((SELECT ''', iif(' + COLUMN_NAME + ' is null or len(' + COLUMN_NAME + ')=0, null, ' + COLUMN_NAME + ')'' +' + char(10)
           FROM information_schema.columns c1
          WHERE c1.TABLE_NAME = c2.TABLE_NAME
          ORDER BY ORDINAL_POSITION
            FOR xml PATH('')), 2, 2, '') + 
  '''   from sc_khb_srv.' + table_name + '" '' +'+ char(10) +
  '''queryout "D:\migra_data\' + replace(table_name, 'tb_', 'mssql_') + '.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv'';' + char(10) +
  'EXEC xp_cmdshell @sql;'
  FROM information_schema.columns c2
 WHERE TABLE_SCHEMA='sc_khb_srv'
       AND
       table_name = 'tb_com_job_schdl_info'
 GROUP BY TABLE_NAME;

-- tb_com_author
declare @sql nvarchar(4000) = 'bcp ' +
'"select '+
  'iif(author_no_pk is null or len(author_no_pk)=0, null, author_no_pk)' +
', iif(parnts_author_no_pk is null or len(parnts_author_no_pk)=0, null, parnts_author_no_pk)' +
', iif(author_nm is null or len(author_nm)=0, null, author_nm)' +
', iif(rm_cn is null or len(rm_cn)=0, null, rm_cn)' +
', iif(use_at is null or len(use_at)=0, null, use_at)' +
', iif(valid_pd_begin_dt is null or len(valid_pd_begin_dt)=0, null, valid_pd_begin_dt)' +
', iif(valid_pd_end_dt is null or len(valid_pd_end_dt)=0, null, valid_pd_end_dt)' +
', iif(regist_id is null or len(regist_id)=0, null, regist_id)' +
', iif(regist_dt is null or len(regist_dt)=0, null, regist_dt)' +
', iif(updt_id is null or len(updt_id)=0, null, updt_id)' +
', iif(updt_dt is null or len(updt_dt)=0, null, updt_dt)' +
', iif(orgnzt_manage_at is null or len(orgnzt_manage_at)=0, null, orgnzt_manage_at)' +
'   from sc_khb_srv.tb_com_author" ' +
'queryout "D:\migra_data\mssql_com_author.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;



-- tb_com_banner_info
declare @sql varchar(8000) = 'bcp ' +
'"SELECT ' + 
'  ROW_NUMBER() OVER (ORDER BY banner_ty_cd, banner_se_cd) + 13' +
', iif(banner_ty_cd is null or len(banner_ty_cd)=0, null, banner_ty_cd)' +
', iif(banner_se_cd is null or len(banner_se_cd)=0, null, banner_se_cd)' +
', iif(thumb_img_url is null or len(thumb_img_url)=0, null, thumb_img_url)' +
', iif(banner_ordr is null or len(banner_ordr)=0, null, banner_ordr)' +
', iif(use_yn is null or len(use_yn)=0, null, use_yn)' +
', iif(url is null or len(url)=0, null, url)' +
', iif(img_url is null or len(img_url)=0, null, img_url)' +
', iif(dtl_cn is null or len(dtl_cn)=0, null, dtl_cn)' +
', iif(reg_id is null or len(reg_id)=0, null, reg_id)' +
', iif(reg_dt is null or len(reg_dt)=0, null, reg_dt)' +
', iif(mdfcn_id is null or len(mdfcn_id)=0, null, mdfcn_id)' +
', iif(mdfcn_dt is null or len(mdfcn_dt)=0, null, mdfcn_dt)' +
'   FROM sc_khb_srv.tb_com_banner_info WHERE banner_info_pk >= 13" ' + 
'queryout "D:\migra_data\mssql_com_banner_info.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;

-- com_code
SELECT *
  FROM sc_khb_srv.tb_com_code
 WHERE code_pk < 12 OR code_pk > 1231
 ORDER BY parnts_code_pk;

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




-- tb_com_group
declare @sql nvarchar(4000) = 'bcp ' +
'"select '+
  'iif(group_no_pk is null or len(group_no_pk)=0, null, group_no_pk)' + -- group_no_pk
', iif(parnts_group_no_pk is null or len(parnts_group_no_pk)=0, null, parnts_group_no_pk)' + -- parnts_group_no_pk
', iif(group_nm is null or len(group_nm)=0, null, group_nm)' + -- group_nm
', iif(use_at is null or len(use_at)=0, null, use_at)' + -- use_at
', iif(rm_cn is null or len(rm_cn)=0, null, rm_cn)' +
', iif(valid_pd_begin_dt is null or len(valid_pd_begin_dt)=0, null, valid_pd_begin_dt)' +
', iif(valid_pd_end_dt is null or len(valid_pd_end_dt)=0, null, valid_pd_end_dt)' +
', iif(regist_id is null or len(regist_id)=0, null, regist_id)' +
', iif(regist_dt is null or len(regist_dt)=0, null, regist_dt)' +
', iif(updt_id is null or len(updt_id)=0, null, updt_id)' +
', iif(updt_dt is null or len(updt_dt)=0, null, updt_dt)' +
'   from sc_khb_srv.tb_com_group" ' +
'queryout "D:\migra_data\mssql_com_group.txt" -c -C 65001 -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
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


















