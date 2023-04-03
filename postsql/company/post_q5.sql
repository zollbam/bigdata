-- 본건 거래 사례
-- * tbl_avm001: AVM 모형(AVM추정시세)
SELECT mgmbldrgstpk, mgmupbldrgstpk, pnu, cas_grb_mdl_id
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';
/*
cas_grb_mdl_id를 하면 avm_base_rtms_apt에서 최종쿼리 결과가 다르게 나온다.
*/

-- * tbl_avm007: AVM 모형(AVM추정시세)
SELECT *
FROM tbl_avm007
WHERE pnu = (SELECT pnu
             FROM tbl_avm001
             WHERE mgmbldrgstpk = '11110-100181034'); 

/*
총 행은 15344
나온 데이터들은 스페이스본에 대한 사례포착모형 거래사례로 avm_base_rtms_apt_id는 중복은 없다.
*/

SELECT avm_base_rtms_apt_id, count(*)
FROM tbl_avm007
GROUP BY avm_base_rtms_apt_id
ORDER BY count(*) desc;
/*
하지만 전체 데이터로 보면 하나의 avm_base_rtms_apt_id에 중복되어 있는 행들이 있는 것을 알 수 있다.
*/

SELECT *
FROM tbl_avm007
WHERE cas_grb_mdl_id = (SELECT cas_grb_mdl_id
                        FROM tbl_avm001
                        WHERE mgmbldrgstpk = '11110-100181034'); 
/*
cas_grb_mdl_id(사례포착모형 ID로 찾으면 29개 행만 나온다.
마지막 쿼리 결과에 21년 10월 데이터가 아닌 다른 데이터가 나오게 된다.
*/

-- * avm_base_rtms_apt(메인 테이블)
SELECT RANK() OVER (ORDER BY cdate desc) "순번",
       cdate "거래일" ,
       platplc || ' ' || beonji || ', ' || buildname "소재지 + 건물명",
       layer "층", 
       rtms_area || '㎡' "전유면적",
       to_char(deposit, 'FM9,999,999,999') || '(@' || to_char(round(deposit/rtms_area), 'FM99,999,999,999') || ')' "금액(@단가)"
FROM avm_base_rtms_apt
WHERE avm_base_rtms_apt_id IN (SELECT avm_base_rtms_apt_id
                               FROM tbl_avm007
                               WHERE pnu = (SELECT pnu
                                            FROM tbl_avm001
                                            WHERE mgmbldrgstpk = '11110-100181034'))
ORDER BY cdate DESC
LIMIT 3;




SELECT a.*, b.*
FROM (SELECT column_name
FROM information_schema.COLUMNS
WHERE table_name = 'tbl_avm001') a
INNER JOIN 
(SELECT column_name
FROM information_schema.COLUMNS
WHERE table_name= 'avm_base_rtms_apt') b ON a.column_name = b.column_name;








































