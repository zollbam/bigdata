/*
mssql에서 결과 쿼리를 txt로 만드는 파일
시작 일시: 23-06-28
수정 일시: 23-07-04
작 성 자 : 조건영
*/

-- 테이블명을 선언하여 bcp 쿼리문 만들기
DECLARE @table_name varchar(500) = 'tb_atlfsl_dlng_info';
SELECT 
  'declare @sql nvarchar(4000) = ''bcp '' +' + char(10) + 
  '''"SELECT '' + ' +
  stuff((
         SELECT char(10) +
                CASE WHEN COLUMN_NAME = (SELECT COLUMN_NAME FROM information_schema.columns WHERE ordinal_position=1 AND TABLE_NAME = @table_name)
                         THEN concat('''  iif(', COLUMN_NAME, ' is null or len(', COLUMN_NAME, ')=0, null, ', COLUMN_NAME, ')'' +')
--                     WHEN COLUMN_NAME = (SELECT TOP 1 COLUMN_NAME FROM information_schema.columns WHERE TABLE_NAME = @table_name ORDER BY ordinal_position DESC)
--                         THEN concat('''  iif(', COLUMN_NAME, ' is null or len(', COLUMN_NAME, ')=0, null, ', COLUMN_NAME, ')''')
                     ELSE concat(''', iif(', COLUMN_NAME, ' is null or len(', COLUMN_NAME, ')=0, null, ', COLUMN_NAME, ')'' +')
                END
           FROM information_schema.columns
          WHERE table_name = @table_name
          ORDER BY ordinal_position
            FOR xml PATH('')), 1, 1 ,char(10)) + char(10) +
  '''   FROM sc_khb_srv.' + @table_name + '" '' + ' + char(10) +
  '''queryout "D:\migra_data\' + replace(@table_name, 'tb_', 'mssql_') + '.txt" -w -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv'';' + char(10) +
  'EXEC xp_cmdshell @sql;';

-- 각 테이블별 bcp 쿼리문 만들기
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
  '''queryout "D:\migra_data\' + replace(table_name, 'tb_', 'mssql_') + '.txt" -w -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv'';' + char(10) +
  'EXEC xp_cmdshell @sql;'
  FROM information_schema.columns c2
 WHERE TABLE_SCHEMA='sc_khb_srv'
 GROUP BY TABLE_NAME;

-- tb_com_code
--SELECT 
--  ROW_NUMBER () OVER(ORDER BY parnts_code_pk, code_pk)+1131
--, RANK () OVER(ORDER BY parnts_code_pk)+1131
--, code_pk
--, parnts_code_pk
--, iif(code IS NULL OR len(code)=0, NULL, code)
--, iif(code_nm IS NULL OR len(code_nm)=0, NULL, code_nm)
--, iif(sort_ordr IS NULL OR len(sort_ordr)=0, NULL, sort_ordr)
--, iif(use_at IS NULL OR len(use_at)=0, NULL, use_at)
--, iif(regist_id IS NULL OR len(regist_id)=0, NULL, regist_id)
--, iif(regist_dt IS NULL OR len(regist_dt)=0, NULL, regist_dt)
--, iif(updt_id IS NULL OR len(updt_id)=0, NULL, updt_id)
--, iif(updt_dt IS NULL OR len(updt_dt)=0, NULL, updt_dt)
--, iif(rm_cn IS NULL OR len(rm_cn)=0, NULL, rm_cn)
--, iif(parent_code IS NULL OR len(parent_code)=0, NULL, parent_code)
--, iif(synchrn_pnttm_vl IS NULL OR len(synchrn_pnttm_vl)=0, null, synchrn_pnttm_vl)
--  FROM sc_khb_srv.tb_com_code
-- WHERE code_pk < 12 OR code_pk > 1231
-- ORDER BY 1, 2;

declare @sql nvarchar(4000) = 'bcp ' +
'"SELECT ' + 
'  ROW_NUMBER () OVER(ORDER BY parnts_code_pk, code_pk)+1131' +
', RANK () OVER(ORDER BY parnts_code_pk)+1131' +
', iif(code IS NULL OR len(code)=0, NULL, code)' +
', iif(code_nm IS NULL OR len(code_nm)=0, NULL, code_nm)' +
', iif(sort_ordr IS NULL OR len(sort_ordr)=0, NULL, sort_ordr)' +
', iif(use_at IS NULL OR len(use_at)=0, NULL, use_at)' +
', iif(regist_id IS NULL OR len(regist_id)=0, NULL, regist_id)' +
', iif(regist_dt IS NULL OR len(regist_dt)=0, NULL, regist_dt)' +
', iif(updt_id IS NULL OR len(updt_id)=0, NULL, updt_id)' +
', iif(updt_dt IS NULL OR len(updt_dt)=0, NULL, updt_dt)' +
', iif(rm_cn IS NULL OR len(rm_cn)=0, NULL, rm_cn)' +
', iif(parent_code IS NULL OR len(parent_code)=0, NULL, parent_code)' +
', iif(synchrn_pnttm_vl IS NULL OR len(synchrn_pnttm_vl)=0, null, synchrn_pnttm_vl)' +
' from sc_khb_srv.tb_com_code where code_pk < 12 OR code_pk > 1231" ' +
' queryout "D:\migra_data\mssql_com_code.txt" -w -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;

-- tb_com_bbs
declare @sql nvarchar(4000) = 'bcp ' +
'"SELECT ' + 
'  iif(bbs_pk is null or len(bbs_pk)=0, null, bbs_pk)' +
', iif(bbs_se_cd is null or len(bbs_se_cd)=0, null, bbs_se_cd)' +
', iif(ttl_nm is null or len(ttl_nm)=0, null, ttl_nm)' +
', iif(cn is null or len(cn)=0, null, cn)' +
', iif(del_yn is null or len(del_yn)=0, null, del_yn)' +
', iif(rgtr_nm is null or len(rgtr_nm)=0, null, rgtr_nm)' +
', iif(reg_id is null or len(reg_id)=0, null, reg_id)' +
', iif(reg_dt is null or len(reg_dt)=0, null, reg_dt)' +
', iif(mdfcn_id is null or len(mdfcn_id)=0, null, mdfcn_id)' +
', iif(mdfcn_dt is null or len(mdfcn_dt)=0, null, mdfcn_dt)' +
'   FROM sc_khb_srv.tb_com_bbs" ' + 
'queryout "D:\migra_data\mssql_com_bbs.txt" -w -t "||" -T -S 192.168.0.161\HBSERVER -U sa -d db_khb_srv';
EXEC xp_cmdshell @sql;






































