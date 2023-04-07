-- 본건 거래 사례
-- * 방법1
-- ** tbl_avm001: AVM 모형(AVM추정시세)
SELECT mgmbldrgstpk, mgmupbldrgstpk, pnu, cas_grb_mdl_id
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';
/*
cas_grb_mdl_id를 하면 avm_base_rtms_apt에서 최종쿼리 결과가 다르게 나온다.
*/

-- ** tbl_avm007: AVM 모형(AVM추정시세)
SELECT *
FROM tbl_avm007
WHERE pnu = (SELECT pnu
             FROM tbl_avm001
             WHERE mgmbldrgstpk = '11110-100181034')
ORDER BY 2 DESC; 

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
                        WHERE mgmbldrgstpk = '11110-100181034')
ORDER BY 2 DESC;
/*
cas_grb_mdl_id(사례포착모형 ID로 찾으면 29개 행만 나온다.
마지막 쿼리 결과에 21년 10월 데이터가 아닌 다른 데이터가 나오게 된다.
*/

-- ** avm_base_rtms_apt(메인 테이블)
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
/*
한국감정평가사협회 사이트에서 본 결과 그대로 쿼리를 만들었다.
pnu로 찾으면 
*/

SELECT RANK() OVER (ORDER BY cdate desc) "순번",
       cdate "거래일" ,
       platplc || ' ' || beonji || ', ' || buildname "소재지 + 건물명",
       layer "층", 
       rtms_area || '㎡' "전유면적",
       to_char(deposit, 'FM9,999,999,999') || '(@' || to_char(round(deposit/rtms_area), 'FM99,999,999,999') || ')' "금액(@단가)"
FROM avm_base_rtms_apt
WHERE avm_base_rtms_apt_id IN (SELECT avm_base_rtms_apt_id
                               FROM tbl_avm007
                               WHERE cas_grb_mdl_id = (SELECT cas_grb_mdl_id
                                                       FROM tbl_avm001
                                                       WHERE mgmbldrgstpk = '11110-100181034'))
ORDER BY cdate DESC
LIMIT 3;
/*
cas_grb_mdl_id는 스페이스본의 모든 사례정보를 담고 있는 것은 아닌걸로 보인다.
cas_grb_mdl_id로 찾으면 mgmbldrgstpk가 '11110-100181034'인 데이터만 찾는다.
*/

-- * 방법2
WITH buil_pnu AS (
	SELECT pnu
	FROM tbl_avm001 
	WHERE mgmbldrgstpk = '11110-100181034'
)
SELECT abra.platplc, abra.beonji, abra.buildname, abra.cdate, abra.layer, abra.deposit, abra.rtms_area
FROM avm_base_rtms_apt abra, buil_pnu bp
WHERE abra.sreg = substring(bp.pnu,1,5) AND 
      abra.seub = substring(bp.pnu,6,5) AND 
      abra.ssan = substring(bp.pnu,11,1) AND 
      abra.sbun1 = substring(bp.pnu,12,4) AND 
      abra.sbun2 = substring(bp.pnu,16,4)
ORDER BY cdate DESC;
/*
tbl_avm001테이블에서 바로 pnu를 찾아 문자열을 나누어 avm_base_rtms_apt테이블에서 시군구코드를 이용해 데이터 검색하기
pnu = sreg + seub + ssan + sbun1 + sbun2
*/
SELECT *
FROM avm_base_rtms_apt 
WHERE sreg = '11110' AND seub = '11500' AND ssan = '1' AND sbun1 = '0009' AND sbun2 = '0000';

-- 유사사례 단가 통계수치
-- * tbl_avm001: AVM 모형(AVM추정시세)
SELECT cas_grb_mdl_id
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';
/*
mgmbldrgstpk = '11110-100181034'에 해당하는 cas_grb_mdl_id(사례포착모형 ID)를 찾았다.
*/

-- * tbl_avm003: AVM 모형 사례포착모형
SELECT min_revise_unit_price "MIN", med_revise_unit_price "MED", avg_revise_unit_price "AVG", max_revise_unit_price "MAX"
FROM tbl_avm003
WHERE cas_grb_mdl_id = (SELECT cas_grb_mdl_id
                        FROM tbl_avm001
                        WHERE mgmbldrgstpk = '11110-100181034');
/*
찾은 사례포착모형 ID를 가지고 해당 건물의 거래사례 조정단가의 max/min/med/avg를 찾는다.
*/

-- 범위별(상, 중, 하) 대상 부동산 가격수준
-- * tbl_avm001: AVM 모형(AVM추정시세)
SELECT cas_grb_mdl_id
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';

-- * tbl_avm005: AVM 모형 사례포착모형
SELECT CASE WHEN rag_grp_div = '1' THEN '상위' 
            WHEN rag_grp_div = '2' THEN '중위'
            when rag_grp_div = '3' THEN '하위' END "범위", 
            range_med_unit_price * layerutility * rtms_area "대상부동산 가격수준", 
            layerutility "층별효용", 
            rtms_area "전유면적",
            '@' || to_char(range_max_unit_price, 'FM999,999,999') "단가_MAX",
            '@' || to_char(range_min_unit_price, 'FM999,999,999') "단가_MIN"
FROM tbl_avm005
WHERE cas_grb_mdl_id = (SELECT cas_grb_mdl_id
                        FROM tbl_avm001
                        WHERE mgmbldrgstpk = '11110-100181034') AND rag_grp_div <> '0';
/*
대상부동산 가격수준 = 거래(평가)금액단가_MED X 층별효용 X 대상물건 전유면적
rag_grp_div가 '0'인 거는 굳이 필요 없어서 뺌
*/

-- 거래사례비교법에 의한 대상물건의 비준가액
-- * tbl_avm001: AVM 모형(AVM추정시세)
SELECT cas_grb_mdl_id
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';

-- * tbl_avm007: AVM 사례포착모형 거래(평가)사례 List
SELECT avm_base_rtms_apt_id, region_factor, apt_outer_point, apt_inner_point, ho_point, etc_point
FROM tbl_avm007
WHERE cas_grb_mdl_id = (SELECT cas_grb_mdl_id
                        FROM tbl_avm001
                        WHERE mgmbldrgstpk = '11110-100181034');

-- * avm_base_rtms_apt
-- ** inner join방법
SELECT RANK() OVER (ORDER BY cdate DESC) "순번", cdate "거래시점", 
       platplc || ' ' || beonji || ', ' || buildname "소재지 + 건물명", 
       layer "층", rtms_area "전유면적", region_factor "지역요인", apt_outer_point "단지외부요인", apt_inner_point "단지내부요인", ho_point "호별요인", etc_point "기타요인",
       to_char(deposit, 'FM999,999,999,999') || '(@' || to_char(deposit/rtms_area, 'FM999,999,999,999') || ')' "금액(@단가)"
FROM avm_base_rtms_apt abra INNER JOIN (SELECT avm_base_rtms_apt_id, region_factor, apt_outer_point, apt_inner_point, ho_point, etc_point
                                        FROM tbl_avm007
                                        WHERE cas_grb_mdl_id = (SELECT cas_grb_mdl_id
                                                                FROM tbl_avm001
                                                                WHERE mgmbldrgstpk = '11110-100181034')) b
                            ON abra.avm_base_rtms_apt_id = b.avm_base_rtms_apt_id;


-- ** 테이블 2개를 따로 처리해서 만들기
SELECT RANK() OVER (ORDER BY cdate DESC) "순번", cdate "거래시점", 
       platplc || ' ' || beonji || ', ' || buildname "소재지 + 건물명", 
       layer "층", rtms_area "전유면적", region_factor "지역요인", apt_outer_point "단지외부요인", apt_inner_point "단지내부요인", ho_point "호별요인", etc_point "기타요인",
       to_char(deposit, 'FM999,999,999,999') || '(@' || to_char(deposit/rtms_area, 'FM999,999,999,999') || ')' "금액(@단가)"
FROM avm_base_rtms_apt abra, (SELECT avm_base_rtms_apt_id, region_factor, apt_outer_point, apt_inner_point, ho_point, etc_point
                              FROM tbl_avm007
                              WHERE cas_grb_mdl_id = (SELECT cas_grb_mdl_id
                                                      FROM tbl_avm001
                                                      WHERE mgmbldrgstpk = '11110-100181034')) b
WHERE abra.avm_base_rtms_apt_id = b.avm_base_rtms_apt_id;

-- 현실화율 통계(서울특별시 종로구)
-- * tbl_avm001: AVM 모형(AVM추정시세)
SELECT mkt_pri_etm_mdl_id
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';

-- * tbl_avm012: AVM 시세추정모형 범위별 현실화율
SELECT CASE WHEN rag_grp_div = '0' THEN '전체'
            WHEN rag_grp_div = '1' THEN '상위'
            WHEN rag_grp_div = '2' THEN '중위'
            WHEN rag_grp_div = '3' THEN '하위' END "범위",
            max_realrate "MAX 현실화율", 
            min_realrate "MIN 현실화율", 
            avg_realrate "AVG 현실화율", 
            med_realrate "MED 현실화율"
FROM tbl_avm012
WHERE mkt_pri_etm_mdl_id = (SELECT mkt_pri_etm_mdl_id
                            FROM tbl_avm001
                            WHERE mgmbldrgstpk = '11110-100181034');






-- 두 테이블 간의 열 이름 비교
SELECT a.*, b.*
FROM (SELECT column_name
      FROM information_schema.COLUMNS
      WHERE table_name = 'avm_base_rtms_apt') a
INNER JOIN 
     (SELECT column_name
      FROM information_schema.COLUMNS
      WHERE table_name= 'tbl_avm010') b ON a.column_name = b.column_name;






























