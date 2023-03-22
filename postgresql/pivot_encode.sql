-- 해당 건물의 데이터 정보 찾기
SELECT *
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';
/*
 광화문 스페이스본이라는 데이터는 한개 뿐이다.
 궁금점: 모든 건축물대장은 1개만 있을까?? PK니까 한개만 있겠지??
*/

-- 건축물 대장을 그룹으로 잡고 내림차순으로 카운트
SELECT mgmbldrgstpk, count(*)
FROM tbl_avm001
GROUP BY mgmbldrgstpk
ORDER BY 1 desc;
/*
제일 큰 값이 1이므로 모든 건축물대장들이 1개씩 있는 것을 확인
*/

-- 해당 건물의 가격과 단가의 최대값 찾기
SELECT max(max_price), max(max_price_danga) 
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';

SELECT min(max_price), min(max_price_danga) 
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';

SELECT max_price, max_price_danga
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';
/*
데이터가 1개뿐이라 max를 쓰던 min을 쓰던 아무것도 안 쓰던 결과는 동일하다!!!
*/

-- 해당 건물의 가격과 단가의 최소값 찾기
SELECT min_price, min_price_danga
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';
/*
가격과 단가의 최소값을 구한다.
*/

-- 값의 형태를 바꾸어 보기
SELECT min_price, '(@'|| to_char(min_price, 'FM999,999,999,999') ||')' 
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';
/*
min_price을 천단위로 형태를 변경하고 특수문자도 붙여 보았습니다.
*/

-- 쿼리 결과 반환
SELECT CONCAT('상한', '(MAX)') 구분,
               TO_CHAR(max_price,'FM999,999,999,999') || '원' 가격, 
               '(@' || TO_CHAR(max_price_danga,'FM999,999,999,999') || ')' 단가
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034'
UNION
SELECT CONCAT('하한', '(MIN)') 구분,
               TO_CHAR(min_price,'FM999,999,999,999') || '원' 가격, 
               '(@' || TO_CHAR(min_price_danga,'FM999,999,999,999') || ')' 단가
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';
/*
합집합을 해주는 union으로 행결합을 하였습니다.
*/

-- 건축물대장을 직접 입력하여 결과 보기
SELECT CONCAT('상한', '(MAX)') 구분,
               TO_CHAR(max_price,'FM999,999,999,999') || '원' 가격, 
               '(@' || TO_CHAR(max_price_danga,'FM999,999,999,999') || ')' 단가
FROM tbl_avm001
WHERE mgmbldrgstpk = '${a}'
UNION
SELECT CONCAT('하한', '(MIN)') 구분,
               TO_CHAR(min_price,'FM999,999,999,999') || '원' 가격, 
               '(@' || TO_CHAR(min_price_danga,'FM999,999,999,999') || ')' 단가
FROM tbl_avm001
WHERE mgmbldrgstpk =  '${a}';
/*
mgmbldrgstpk값을 변경 하면 다른 건물의 가격, 단가의 최대/최소값을 알 수 있다.
*/

-- 유니온을 쓰지 않고 해보기
-- * 피벗테이블
SELECT *
FROM tbl_avm001
           CROSS JOIN LATERAL unnest(ARRAY['상한(MAX)', '하한(MIN)'], 
                                                                ARRAY[max_price,min_price], 
                                                                ARRAY[max_price_danga,min_price_danga]) AS pv(com, price, danga);
 /*
기존에 있던 열의 데이터도 반환이 됩니다.
wide에서는 행 수가 499,608이었지만
long으로 바뀌고는 2배인 999,216이 되었습니다.

제가 피벗으로 만들고 싶어했던 열은 3개 였습니다. => 구분, 가격, 단가
CROSS JOIN LATERAL unnest로 피벗을 만들고 ARRAY[]를 이용해 본인이 원하고자 하는 형태의 테이블로 만들었다.
AS pv(com, price, danga)을 해서 새로 만든 열의 이름을 정한다.
 - ARRAY['상한(MAX)', '하한(MIN)'] => com
 - ARRAY[max_price,min_price] => price
 - ARRAY[max_price_danga,min_price_danga] => danga
 - pv어떤 이름이 와도 상관이 없다. => p(com, price, danga), x(com, price, danga) 등 이름을 지정할수만 있으면 모두 가능!!!
*/

-- 내가 만든 피벗테이블만 보기
SELECT com, price, danga, mgmbldrgstpk
FROM tbl_avm001
           CROSS JOIN LATERAL unnest(ARRAY['상한(MAX)', '하한(MIN)'], 
                                                                ARRAY[max_price,min_price], 
                                                                ARRAY[max_price_danga,min_price_danga]) AS pv(com, price, danga);
 /*
mgmbldrgstpk는 기존의 열인데 값은 값이 2번씩 반복되어 출력되는 것을 확인 할 수 있습니다.
where절을 쓰면 본인이 원하는 조건의 피벗테이블을 조회할 수 있습니다.
*/

-- 원하는 건축물대장의 쿼리 결과
SELECT com 구분, TO_CHAR(price, 'FM999,999,999,999') || '원' 가격,  '(@' || TO_CHAR(danga, 'FM999,999,999,999') || ')' 단가
FROM tbl_avm001
           CROSS JOIN LATERAL unnest(ARRAY['상한(MAX)', '하한(MIN)'], 
                                                                ARRAY[max_price,min_price], 
                                                                ARRAY[max_price_danga,min_price_danga]) AS x(com, price, danga)
WHERE mgmbldrgstpk = '11110-100181034';
 /*
형태/열이름을 바꾸고 where절을 활용하여 원하는 쿼리결과를 얻었습니다.
*/

-- 사용자가 건축물대장번호을 입력하여 쿼리 결과 얻기
SELECT com 구분, TO_CHAR(price, 'FM999,999,999,999') || '원' 가격,  '(@' || TO_CHAR(danga, 'FM999,999,999,999') || ')' 단가
FROM tbl_avm001
           CROSS JOIN LATERAL unnest(ARRAY['상한(MAX)', '하한(MIN)'], 
                                                                ARRAY[max_price,min_price], 
                                                                ARRAY[max_price_danga,min_price_danga]) AS x(com, price, danga)
WHERE mgmbldrgstpk = '${iput}';
 /*
iput에 보고자하는 건축물대장 번호를 입력하여 쿼리결과를 나타내는 것이다.
*/
















