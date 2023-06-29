/*
mssql에서 결과 쿼리를 txt로 만드는 파일
시작 일시: 23-06-28
수정 일시: 23-06-29
작 성 자 : 조건영
*/

-- tb_com_code
SELECT 
  ROW_NUMBER () OVER(ORDER BY parnts_code_pk, code_pk)+1131
, RANK () OVER(ORDER BY parnts_code_pk)+1131
, code_pk
, parnts_code_pk
, iif(code IS NULL OR len(code)=0, NULL, code)
, iif(code_nm IS NULL OR len(code_nm)=0, NULL, code_nm)
, iif(sort_ordr IS NULL OR len(sort_ordr)=0, NULL, sort_ordr)
, iif(use_at IS NULL OR len(use_at)=0, NULL, use_at)
, iif(regist_id IS NULL OR len(regist_id)=0, NULL, regist_id)
, iif(regist_dt IS NULL OR len(regist_dt)=0, NULL, regist_dt)
, iif(updt_id IS NULL OR len(updt_id)=0, NULL, updt_id)
, iif(updt_dt IS NULL OR len(updt_dt)=0, NULL, updt_dt)
, iif(rm_cn IS NULL OR len(rm_cn)=0, NULL, rm_cn)
, iif(parent_code IS NULL OR len(parent_code)=0, NULL, parent_code)
, iif(synchrn_pnttm_vl IS NULL OR len(synchrn_pnttm_vl)=0, null, synchrn_pnttm_vl)
  FROM sc_khb_srv.tb_com_code
 WHERE code_pk < 12 OR code_pk > 1231
 ORDER BY 1, 2;

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

-- 







































