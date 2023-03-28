-- 전유면적
SELECT mgmbldrgstpk, mgmbldrgstpk_pyo, private_area ||'㎡' "전유면적", flrno "해당 층"
FROM avm_bbook_share_oneself_area
WHERE mgmbldrgstpk = '11110-100181034';
/*
- mgmbldrgstpk는 mgmbldrgstpk_pyo와 다른지 비교하기 위해 뽑아 보았습니다.
- avm_bbook_check_elevator에서 mgmbldrgstpk_pyo가 필요해서 뽑아보았습니다.
- ㎡는 'ㄹ' + 한자를 이용해서 특수문자를 집어 넣었습니다.
*/

-- 주구조
SELECT strctcdnm "주구조"
FROM avm_bbook_check_elevator
WHERE mgmbldrgstpk_pyo = '11110-100180945';
/*
- avm_bbook_share_oneself_area테이블에서 건축물대장이 11110-100181034의 mgmbldrgstpk_pyo가 11110-100180945이다.
- mgmbldrgstpk_pyo는 not null이라 중복되는 값이 없으므로 11110-100180945는 한 개 행만 나오게 된다.
*/

-- 사용승인일
SELECT to_char(to_date(useaprday, 'YYYYMMDD'), 'YYYY.MM.DD') "사용승인일"
FROM avm_bbook_useaprday
WHERE mgmbldrgstpk_pyo = '11110-100180945';
/*
- to_date는 문자형을 날짜형으로 바꾸어 주는 함수로 해당 열에 입력된 문자의 순서대로 형태를 두번째 인수에 적어야 날짜형으로 변경이 가능하다.
   => 즉, useaprday에는 yyyyddmm순으로 입력되어 있어서 to_date의 두번째 인수에 'YYYYMMDD'를 적었습니다.
- to_char을 이용해서 날짜의 형태를 'YYYYMMDD'에서 년월일 사이에 점(.)을 넣는다.
*/

-- 총 층수(지상/지하)
SELECT grndflrcnt || ' / ' || ugrndflrcnt "총층수(지상/지하)"
FROM avm_bbook_pyo_count
WHERE mgmbldrgstpk = '11110-100181034';
/*
- avm_bbook_pyo_count테이블에서는 mgmbldrgstpk_pyo가 not null이 아니라
   mgmbldrgstpk_pyo = '11110-100180945'로 조건을 잡으면 102개의 행이 나오게 됩니다. 
   그래서 mgmbldrgstpk로 조건을 잡고 진행하였습니다.
*/

-- 세대수
SELECT mgmbldrgstpk_pyo,hhldcnt "세대수"
FROM avm_bbook_hhldcnt
WHERE mgmbldrgstpk_pyo = '11110-100180945';
/*
- avm_bbook_hhldcnt테이블에서는 mgmbldrgstpk_pyo가 not null이라 where절에 mgmbldrgstpk_pyo열을 사용
*/

-- 최종쿼리
-- * 테이블을 만들어서 전체 테이블 사용(사용자 입력 X)
SELECT tbl_mgm."전유면적", abce.strctcdnm "주구조", to_char(to_date(abu.useaprday, 'YYYYMMDD'), 'YYYY.MM.DD') "사용승인일", tbl_mgm."총층수(지상/지하)", tbl_mgm."해당 층", abh.hhldcnt "세대수"
FROM (SELECT absoa.mgmbldrgstpk_pyo, absoa.private_area ||'㎡' "전유면적", flrno "해당 층", abpc.grndflrcnt || ' / ' || ugrndflrcnt "총층수(지상/지하)"
			FROM avm_bbook_share_oneself_area absoa, avm_bbook_pyo_count abpc
			WHERE absoa.mgmbldrgstpk = '11110-100181034' AND abpc.mgmbldrgstpk = '11110-100181034') tbl_mgm,
		    avm_bbook_check_elevator abce,
		    avm_bbook_useaprday abu,
		    avm_bbook_hhldcnt abh
WHERE abce.mgmbldrgstpk_pyo = tbl_mgm.mgmbldrgstpk_pyo AND 
              abu.mgmbldrgstpk_pyo = tbl_mgm.mgmbldrgstpk_pyo AND
              abh.mgmbldrgstpk_pyo = tbl_mgm.mgmbldrgstpk_pyo;
/*
- 우선 mgmbldrgstpk열이 필요한 테이블이 avm_bbook_share_oneself_area와 avm_bbook_pyo_count이므로 이 2개의 테이블을 가지고
    mgmbldrgstpk_pyo와 전유면적, 해당층, 총층수의 데이터를 추출했습니다. => mgmbldrgstpk가 11110-100181034인 1행 4열의 tbl_mgm테이블을 볼 수 있습니다.
- 그 다음 남은 테이블과 tbl_mgm테이블의 mgmbldrgstpk_pyo값을 이용해 주구조, 사용승인일, 세대수의 값을 추출하여 건축물대장이 '11110-100181034'인 건물의 여러 정보를 추출한다. 
*/

-- * 테이블을 만들어서 전체 테이블 사용(사용자 입력 O)
SELECT tbl_mgm."전유면적", abce.strctcdnm "주구조", to_char(to_date(abu.useaprday, 'YYYYMMDD'), 'YYYY.MM.DD') "사용승인일", tbl_mgm."총층수(지상/지하)", tbl_mgm."해당 층", abh.hhldcnt "세대수"
FROM (SELECT absoa.mgmbldrgstpk_pyo, absoa.private_area ||'㎡' "전유면적", flrno "해당 층", abpc.grndflrcnt || ' / ' || ugrndflrcnt "총층수(지상/지하)"
			FROM avm_bbook_share_oneself_area absoa, avm_bbook_pyo_count abpc
			WHERE absoa.mgmbldrgstpk = '${user_mgm}' AND abpc.mgmbldrgstpk = '${user_mgm}') tbl_mgm,
		    avm_bbook_check_elevator abce,
		    avm_bbook_useaprday abu,
		    avm_bbook_hhldcnt abh
WHERE abce.mgmbldrgstpk_pyo = tbl_mgm.mgmbldrgstpk_pyo AND 
              abu.mgmbldrgstpk_pyo = tbl_mgm.mgmbldrgstpk_pyo AND
              abh.mgmbldrgstpk_pyo = tbl_mgm.mgmbldrgstpk_pyo;

-- * with문(사용자 입력 X)
WITH mgmpyo_to_mgm AS (
			SELECT mgmbldrgstpk, mgmbldrgstpk_pyo, private_area, flrno FROM avm_bbook_share_oneself_area WHERE mgmbldrgstpk = '11110-100181034'
), buil_info_mgm AS (
			SELECT mtm.private_area ||'㎡' "전유면적", mtm.flrno "해당 층", abpc.grndflrcnt || ' / ' || ugrndflrcnt "총층수(지상/지하)"
			FROM mgmpyo_to_mgm mtm,  avm_bbook_pyo_count abpc
			WHERE abpc.mgmbldrgstpk = mtm.mgmbldrgstpk
), buil_info_mgmpyo AS (
			SELECT abce.strctcdnm "주구조", to_char(to_date(abu.useaprday, 'YYYYMMDD'), 'YYYY.MM.DD') "사용승인일", abh.hhldcnt "세대수"
			FROM mgmpyo_to_mgm mtm,  avm_bbook_check_elevator abce, avm_bbook_useaprday abu, avm_bbook_hhldcnt abh
			WHERE abce.mgmbldrgstpk_pyo = mtm.mgmbldrgstpk_pyo AND 
                          abu.mgmbldrgstpk_pyo = mtm.mgmbldrgstpk_pyo AND
                          abh.mgmbldrgstpk_pyo = mtm.mgmbldrgstpk_pyo
)
SELECT bim."전유면적", bimp."주구조", bimp."사용승인일", bim."총층수(지상/지하)", bim."해당 층", bimp."세대수"
FROM buil_info_mgm bim, buil_info_mgmpyo bimp;

/*
- mgmpyo_to_mgm테이블은 mgmbldrgstpk를 mgmbldrgstpk_pyo로 바꾸어주고 "전유면적"과 "해당 층"에 관한 정보를 추출했다.
- buil_info_mgm테이블은 mgmpyo_to_mgm에서 전유면적과 해당층 열을 추출하고 avm_bbook_pyo_count에서 해당 건축물대장에 맞는 총층수를 추출
- buil_info_mgmpyo테이블은 mgmbldrgstpk_pyo의 조건에 맞는 데이터 중에서 "주구조", "사용승인일", "세대수"
*/

-- * with문(사용자 입력 O)
WITH mgmpyo_to_mgm AS (
			SELECT mgmbldrgstpk, mgmbldrgstpk_pyo, private_area, flrno FROM avm_bbook_share_oneself_area WHERE mgmbldrgstpk = '${user_mgm}'
), buil_info_mgm AS (
			SELECT mtm.private_area ||'㎡' "전유면적", mtm.flrno "해당 층", abpc.grndflrcnt || ' / ' || ugrndflrcnt "총층수(지상/지하)"
			FROM mgmpyo_to_mgm mtm,  avm_bbook_pyo_count abpc
			WHERE abpc.mgmbldrgstpk = mtm.mgmbldrgstpk
), buil_info_mgmpyo AS (
			SELECT abce.strctcdnm "주구조", to_char(to_date(abu.useaprday, 'YYYYMMDD'), 'YYYY.MM.DD') "사용승인일", abh.hhldcnt "세대수"
			FROM mgmpyo_to_mgm mtm,  avm_bbook_check_elevator abce, avm_bbook_useaprday abu, avm_bbook_hhldcnt abh
			WHERE abce.mgmbldrgstpk_pyo = mtm.mgmbldrgstpk_pyo AND 
                          abu.mgmbldrgstpk_pyo = mtm.mgmbldrgstpk_pyo AND
                          abh.mgmbldrgstpk_pyo = mtm.mgmbldrgstpk_pyo
)
SELECT bim."전유면적", bimp."주구조", bimp."사용승인일", bim."총층수(지상/지하)", bim."해당 층", bimp."세대수"
FROM buil_info_mgm bim, buil_info_mgmpyo bimp;

-- * with문 + 여러 개 테이블 full join(사용자 입력 O)
WITH mgmpyo_to_mgm AS (
			SELECT mgmbldrgstpk, mgmbldrgstpk_pyo, private_area, flrno FROM avm_bbook_share_oneself_area WHERE mgmbldrgstpk = '11530-100233831'
), buil_info_mgm AS (
			SELECT mtm.private_area ||'㎡' "전유면적", mtm.flrno "해당 층", abpc.grndflrcnt || ' / ' || ugrndflrcnt "총층수(지상/지하)"
			FROM mgmpyo_to_mgm mtm,  avm_bbook_pyo_count abpc
			WHERE abpc.mgmbldrgstpk = mtm.mgmbldrgstpk
), buil_info_mgmpyo AS (
			SELECT abce.strctcdnm "주구조", to_char(to_date(abu.useaprday, 'YYYYMMDD'), 'YYYY.MM.DD') "사용승인일", abh.hhldcnt "세대수"
			FROM mgmpyo_to_mgm mtm,
			            avm_bbook_check_elevator abce FULL join avm_bbook_useaprday abu ON abce.mgmbldrgstpk_pyo = abu.mgmbldrgstpk_pyo
            			                                                          FULL JOIN avm_bbook_hhldcnt abh ON abu.mgmbldrgstpk_pyo = abh.mgmbldrgstpk_pyo
			WHERE abh.mgmbldrgstpk_pyo = mtm.mgmbldrgstpk_pyo
)
SELECT bim."전유면적", bimp."주구조", bimp."사용승인일", bim."총층수(지상/지하)", bim."해당 층", bimp."세대수"
FROM buil_info_mgm bim, buil_info_mgmpyo bimp;







