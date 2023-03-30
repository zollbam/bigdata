-- 공시년도와 공시가격
-- * 가진 전체 연도 공시가격
SELECT substring(basedate,1,4), hsprc
FROM bbook_hprice
WHERE mgmbldrgstpk = '11110-100181034';
/*
2009년부터 2022년까지의 공시가격을 가지고 있습니다. 
*/

-- * 최근 3년 이내 연도 공시가격
SELECT substring(basedate,1,4) baseyear, hsprc
FROM bbook_hprice
WHERE mgmbldrgstpk = '11110-100181034' AND substring(basedate,1,4)::NUMERIC >= to_char(now(), 'yyyy')::NUMERIC - 3
ORDER BY 1 desc;
/*
- where절에서 해당 건물의 최근 3년이내 공시가격을 추출하였습니다. => 22/21/20년 공시가격
- ORDER BY로 년도가 높을 수록 윗 행에 보이게 만들었습니다.
-  
*/
SELECT y1.baseyear "공시가격 1번째년도", y1.hsprc "공시가격 1번째년도", y2.baseyear "공시가격 2번째년도", y2.hsprc "공시가격2번째 년도", y3.baseyear "공시가격 3번째년도", y3.hsprc "공시가격 3번째년도"
FROM (SELECT mgmbldrgstpk, substring(basedate,1,4) baseyear, hsprc
	  FROM bbook_hprice
	  WHERE mgmbldrgstpk = '11110-100181034' AND substring(basedate,1,4)::NUMERIC = to_char(now(), 'yyyy')::NUMERIC - 1) y1
      FULL JOIN 
	 (SELECT mgmbldrgstpk, substring(basedate,1,4) baseyear, hsprc
	  FROM bbook_hprice
	  WHERE mgmbldrgstpk = '11110-100181034' AND substring(basedate,1,4)::NUMERIC = to_char(now(), 'yyyy')::NUMERIC - 2) y2 ON y1.mgmbldrgstpk=y2.mgmbldrgstpk
	  FULL JOIN
	 (SELECT mgmbldrgstpk, substring(basedate,1,4) baseyear, hsprc
	  FROM bbook_hprice
	  WHERE mgmbldrgstpk = '11110-100181034' AND substring(basedate,1,4)::NUMERIC = to_char(now(), 'yyyy')::NUMERIC - 3) y3 ON y1.mgmbldrgstpk=y3.mgmbldrgstpk;

-- 개별공시지가
-- * mgmbldrgstpk에 해당하는 좌표 찾기
SELECT mgmbldrgstpk, dx, dy
FROM avm_bbook_pyo_count 
WHERE mgmbldrgstpk = '11110-100181034';

-- * 찾은 좌표가 해당 건물이 맞는지 확인
SELECT st_transform(st_setsrid(st_makepoint(dx,dy),5174),4326)
FROM avm_bbook_pyo_count 
WHERE mgmbldrgstpk = '11110-100181034';

-- 찾은 좌표와 동일한 데이터 찾기
-- ** 방법 1 => with문
WITH bilxy AS (
	SELECT mgmbldrgstpk, dx, dy
	FROM avm_bbook_pyo_count
	WHERE mgmbldrgstpk = '11110-100181034'
)
SELECT gakuka "개별공시지가(원/㎡)"
FROM bilxy, g2022 g22
WHERE (bilxy.dx = g22.dx) AND (bilxy.dy = g22.dy);

-- ** 방법 2 => where절에서 바로 찾기 
SELECT gakuka "개별공시지가(원/㎡)"
FROM g2022
WHERE dx=(SELECT dx FROM avm_bbook_pyo_count WHERE mgmbldrgstpk = '11110-100181034') AND 
      dy=(SELECT dy FROM avm_bbook_pyo_count WHERE mgmbldrgstpk = '11110-100181034');

-- ** 방법 3 => inner join으로 교집합 찾기
SELECT mgmbldrgstpk, gakuka
FROM (SELECT avm_bbook_pyo_count.mgmbldrgstpk, avm_bbook_pyo_count.dx, avm_bbook_pyo_count.dy
	  FROM avm_bbook_pyo_count 
	  WHERE mgmbldrgstpk = '11110-100181034') bilxy INNER JOIN 
	  g2022 g22 ON (bilxy.dx = g22.dx) AND (bilxy.dy = g22.dy);

-- ** 방법 4 => left join과 not null을 이용
SELECT mgmbldrgstpk, gakuka
FROM (SELECT avm_bbook_pyo_count.mgmbldrgstpk, avm_bbook_pyo_count.dx, avm_bbook_pyo_count.dy
	  FROM avm_bbook_pyo_count 
	  WHERE mgmbldrgstpk = '11110-100181034') bilxy LEFT JOIN 
	  g2022 g22 ON (bilxy.dx = g22.dx) AND (bilxy.dy = g22.dy)
WHERE mgmbldrgstpk IS NOT NULL;
/*
이 4개의 방법 모두 개별동시지가를 찾는데에 10초이상이 걸려 성능적으로 문제가 있다. 
그 이유는 무엇일지 찾아보자!!
*/

-- ** 방법 5 => 동일한 시군구 코드를 활용한 개별공시지가 찾기
WITH resu AS (SELECT sigungucd, bjdongcd, platgbcd, bun, ji
FROM avm_bbook_share_oneself_area 
WHERE mgmbldrgstpk = '11110-100181034'
)
SELECT gakuka "개별공시지가(원/㎡)"
FROM g2022, resu
WHERE resu.sigungucd = sreg AND 
      resu.bjdongcd = seub AND
      resu.platgbcd = ssan AND
      resu.bun = sbun1 AND 
      resu.ji = sbun2;
/*
1초 안으로 바로 값이 나온다.
dx,dy는 오래 걸리는데 4개의 and를 쓴 시군구 코드는 왜 이렇게 빨리 나오는 것일까?? 
*/

-- 쿼리 결과
-- * full join
WITH sigun_resu AS (
	SELECT sigungucd, bjdongcd, platgbcd, bun, ji
	FROM avm_bbook_share_oneself_area 
	WHERE mgmbldrgstpk = '11110-100181034'
), ind_app AS (
	SELECT gakuka "개별공시지가(원/㎡)"
	FROM g2022, sigun_resu sr
	WHERE sr.sigungucd = sreg AND 
          sr.bjdongcd = seub AND
          sr.platgbcd = ssan AND
      	  sr.bun = sbun1 AND 
          sr.ji = sbun2
), year_app AS (
	SELECT y1.baseyear "공시가격 1번째년도", y1.hsprc "공시가격 1번째년도", y2.baseyear "공시가격 2번째년도", y2.hsprc "공시가격 2번째년도", y3.baseyear "공시가격 3번째년도", y3.hsprc "공시가격 3번째년도"
	FROM (SELECT mgmbldrgstpk, substring(basedate,1,4) baseyear, hsprc
		  FROM bbook_hprice
	  	  WHERE mgmbldrgstpk = '11110-100181034' AND substring(basedate,1,4)::NUMERIC = to_char(now(), 'yyyy')::NUMERIC - 1) y1
      	 FULL JOIN 
	 	 (SELECT mgmbldrgstpk, substring(basedate,1,4) baseyear, hsprc
	  	  FROM bbook_hprice
	  	  WHERE mgmbldrgstpk = '11110-100181034' AND substring(basedate,1,4)::NUMERIC = to_char(now(), 'yyyy')::NUMERIC - 2) y2 ON y1.mgmbldrgstpk=y2.mgmbldrgstpk
	  	 FULL JOIN
	 	 (SELECT mgmbldrgstpk, substring(basedate,1,4) baseyear, hsprc
	  	  FROM bbook_hprice
	  	  WHERE mgmbldrgstpk = '11110-100181034' AND substring(basedate,1,4)::NUMERIC = to_char(now(), 'yyyy')::NUMERIC - 3) y3 ON y1.mgmbldrgstpk=y3.mgmbldrgstpk
)
SELECT ind_app.*, year_app.*
FROM ind_app, year_app;

-- * 각 결과를 만들어 테이블 합치기
WITH sigun_resu AS (
	SELECT sigungucd, bjdongcd, platgbcd, bun, ji
	FROM avm_bbook_share_oneself_area 
	WHERE mgmbldrgstpk = '11110-100181034'
), ind_app AS (
	SELECT gakuka "개별공시지가(원/㎡)"
	FROM g2022, sigun_resu sr
	WHERE sr.sigungucd = sreg AND sr.bjdongcd = seub AND sr.platgbcd = ssan AND sr.bun = sbun1 AND sr.ji = sbun2
), year22_app AS (
	SELECT substring(basedate,1,4) "공시가격 1번째년도", hsprc "공시가격 1번째년도"
	FROM bbook_hprice
	WHERE mgmbldrgstpk = '11110-100181034' AND substring(basedate,1,4)::NUMERIC = (to_char(now(), 'yyyy')::NUMERIC - 1)
), year21_app AS (
	SELECT substring(basedate,1,4) "공시가격 2번째년도", hsprc "공시가격 2번째년도"
	FROM bbook_hprice
	WHERE mgmbldrgstpk = '11110-100181034' AND substring(basedate,1,4)::NUMERIC = (to_char(now(), 'yyyy')::NUMERIC - 2)
), year20_app AS (
	SELECT substring(basedate,1,4) "공시가격 3번째년도", hsprc "공시가격 3번째년도"
	FROM bbook_hprice
	WHERE mgmbldrgstpk = '11110-100181034' AND substring(basedate,1,4)::NUMERIC = (to_char(now(), 'yyyy')::NUMERIC - 3) 
)
SELECT ind_app.*, year22_app.*, year21_app.*, year20_app.*
FROM ind_app, year22_app, year21_app, year20_app;

-- * 각 결과를 만들어 테이블 합치기(사용자 입력)
WITH sigun_resu AS (
	SELECT mgmbldrgstpk, sigungucd, bjdongcd, platgbcd, bun, ji
	FROM avm_bbook_share_oneself_area 
	WHERE mgmbldrgstpk = '${user_mgm}'
), ind_app AS (
	SELECT gakuka "개별공시지가(원/㎡)"
	FROM g2022, sigun_resu sr
	WHERE sr.sigungucd = sreg AND sr.bjdongcd = seub AND sr.platgbcd = ssan AND sr.bun = sbun1 AND sr.ji = sbun2
), year22_app AS (
	SELECT substring(basedate,1,4) "공시가격 1번째년도", hsprc "공시가격 1번째년도"
	FROM bbook_hprice bh, sigun_resu sr
	WHERE bh.mgmbldrgstpk = sr.mgmbldrgstpk AND substring(basedate,1,4)::NUMERIC = (to_char(now(), 'yyyy')::NUMERIC - 1)
), year21_app AS (
	SELECT substring(basedate,1,4) "공시가격 2번째년도", hsprc "공시가격 2번째년도"
	FROM bbook_hprice bh, sigun_resu sr
	WHERE bh.mgmbldrgstpk = sr.mgmbldrgstpk AND substring(basedate,1,4)::NUMERIC = (to_char(now(), 'yyyy')::NUMERIC - 2)
), year20_app AS (
	SELECT substring(basedate,1,4) "공시가격 3번째년도", hsprc "공시가격 3번째년도"
	FROM bbook_hprice bh, sigun_resu sr
	WHERE bh.mgmbldrgstpk = sr.mgmbldrgstpk AND substring(basedate,1,4)::NUMERIC = (to_char(now(), 'yyyy')::NUMERIC - 3) 
)
SELECT ind_app.*, year22_app.*, year21_app.*, year20_app.*
FROM ind_app, year22_app, year21_app, year20_app;
/*
만약에 21년 데이터가 없다면 최근 3년 데이터는 22,20,19의 데이터가 나와야 한다.
*/

-- 쿼리결과(보완점 고침)
WITH sigun_resu AS (
	SELECT mgmbldrgstpk, sigungucd, bjdongcd, platgbcd, bun, ji
	FROM avm_bbook_share_oneself_area 
	WHERE mgmbldrgstpk = '11110-100181034'
), ind_app AS (
	SELECT gakuka "개별공시지가(원/㎡)"
	FROM g2022, sigun_resu sr
	WHERE sr.sigungucd = sreg AND sr.bjdongcd = seub AND sr.platgbcd = ssan AND sr.bun = sbun1 AND sr.ji = sbun2
), year_third_in AS (
	SELECT mgmbldrgstpk, ROW_NUMBER() OVER (ORDER BY substring(basedate,1,4) desc) AS row_num, substring(basedate,1,4) "년도", hsprc
	FROM bbook_hprice 
	WHERE mgmbldrgstpk = '11110-100181034'
	ORDER BY row_num
), year_three_in AS (
	SELECT fir_ye."년도" "공시가격 1번째년도", fir_ye.hsprc "공시가격 1번째년도", sec_ye."년도" "공시가격 2번째년도", sec_ye.hsprc "공시가격 2번째년도", thr_ye."년도" "공시가격 3번째년도", thr_ye.hsprc "공시가격 3번째년도"
	FROM (SELECT "년도", hsprc FROM year_third_in WHERE row_num = 1) fir_ye,
		 (SELECT "년도", hsprc FROM year_third_in WHERE row_num = 2) sec_ye,
      	 (SELECT "년도", hsprc FROM year_third_in WHERE row_num = 3) thr_ye 
)
SELECT ind_app.*, year_three_in.*
FROM ind_app, year_three_in;

SELECT mgmbldrgstpk, ROW_NUMBER() OVER (ORDER BY substring(basedate,1,4) desc) AS row_num, substring(basedate,1,4) "년도", hsprc
	FROM bbook_hprice 
	WHERE mgmbldrgstpk = '11110-100181034'
	ORDER BY row_num
LIMIT 3;

-- 쿼리결과(보완점 고침 + 사용자 입력)
WITH sigun_resu AS (
	SELECT mgmbldrgstpk, sigungucd, bjdongcd, platgbcd, bun, ji
	FROM avm_bbook_share_oneself_area 
	WHERE mgmbldrgstpk = '${user_mgm}'
), ind_app AS (
	SELECT gakuka "개별공시지가(원/㎡)"
	FROM g2022, sigun_resu sr
	WHERE sr.sigungucd = sreg AND sr.bjdongcd = seub AND sr.platgbcd = ssan AND sr.bun = sbun1 AND sr.ji = sbun2
), year_third_in AS (
	SELECT mgmbldrgstpk, ROW_NUMBER() OVER (ORDER BY substring(basedate,1,4) desc) AS row_num, substring(basedate,1,4) "년도", hsprc
	FROM bbook_hprice 
	WHERE mgmbldrgstpk = '${user_mgm}'
	ORDER BY row_num
), year_three_in AS (
	SELECT fir_ye."년도" "공시가격 1번째년도", fir_ye.hsprc "공시가격 1번째년도", sec_ye."년도" "공시가격 2번째년도", sec_ye.hsprc "공시가격 2번째년도", thr_ye."년도" "공시가격 3번째년도", thr_ye.hsprc "공시가격 3번째년도"
	FROM (SELECT "년도", hsprc FROM year_third_in WHERE row_num = 1) fir_ye,
		 (SELECT "년도", hsprc FROM year_third_in WHERE row_num = 2) sec_ye,
      	 (SELECT "년도", hsprc FROM year_third_in WHERE row_num = 3) thr_ye 
)
SELECT ind_app.*, year_three_in.*
FROM ind_app, year_three_in;

-- 다른 테이블의 같은 이름 찾기
SELECT a.column_name "avm_bbook_pyo_count column", b.column_name "g2022 column"
FROM (SELECT column_name
      FROM information_schema.COLUMNS 
      WHERE table_name = 'avm_bbook_pyo_count') a INNER JOIN
     (SELECT column_name
      FROM information_schema.COLUMNS 
      WHERE table_name = 'g2022') b ON a.column_name=b.column_name;

-- 행번호를 입력받아 원하는 행 구간만 추출
-- * 행번호를 입력 받기
SELECT ROW_NUMBER() OVER (ORDER BY mgmbldrgstpk) AS row_num, *
FROM avm_bbook_share_oneself_area;

-- * 입력된 행번호를 이용하여 특정 구간의 행을 추출
SELECT *
FROM (SELECT ROW_NUMBER() OVER (ORDER BY mgmbldrgstpk) AS row_num, *
      FROM avm_bbook_share_oneself_area) AS subquery
WHERE row_num BETWEEN 5000 AND 5100;

-- 타입변경
-- * 1. cast
SELECT CAST(1 AS bool);
SELECT CAST(1 AS text);
SELECT CAST(1 AS int);
SELECT CAST(1 AS float8);

-- * 2. ::
SELECT 1::bool;
SELECT 1::TEXT;
SELECT 1::NUMERIC;
SELECT 1::float8;

-- * 3. 함수
SELECT text(1);
SELECT to_char(2132012,'FM999,999,999');
SELECT to_date('20190130','yyyymmdd');
SELECT to_timestamp('20190130','yyyymmdd');
