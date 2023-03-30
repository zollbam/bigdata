-- ���ó⵵�� ���ð���
-- * ���� ��ü ���� ���ð���
SELECT substring(basedate,1,4), hsprc
FROM bbook_hprice
WHERE mgmbldrgstpk = '11110-100181034';
/*
2009����� 2022������� ���ð����� ������ �ֽ��ϴ�. 
*/

-- * �ֱ� 3�� �̳� ���� ���ð���
SELECT substring(basedate,1,4) baseyear, hsprc
FROM bbook_hprice
WHERE mgmbldrgstpk = '11110-100181034' AND substring(basedate,1,4)::NUMERIC >= to_char(now(), 'yyyy')::NUMERIC - 3
ORDER BY 1 desc;
/*
- where������ �ش� �ǹ��� �ֱ� 3���̳� ���ð����� �����Ͽ����ϴ�. => 22/21/20�� ���ð���
- ORDER BY�� �⵵�� ���� ���� �� �࿡ ���̰� ��������ϴ�.
-  
*/
SELECT y1.baseyear "���ð��� 1��°�⵵", y1.hsprc "���ð��� 1��°�⵵", y2.baseyear "���ð��� 2��°�⵵", y2.hsprc "���ð���2��° �⵵", y3.baseyear "���ð��� 3��°�⵵", y3.hsprc "���ð��� 3��°�⵵"
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

-- ������������
-- * mgmbldrgstpk�� �ش��ϴ� ��ǥ ã��
SELECT mgmbldrgstpk, dx, dy
FROM avm_bbook_pyo_count 
WHERE mgmbldrgstpk = '11110-100181034';

-- * ã�� ��ǥ�� �ش� �ǹ��� �´��� Ȯ��
SELECT st_transform(st_setsrid(st_makepoint(dx,dy),5174),4326)
FROM avm_bbook_pyo_count 
WHERE mgmbldrgstpk = '11110-100181034';

-- ã�� ��ǥ�� ������ ������ ã��
-- ** ��� 1 => with��
WITH bilxy AS (
	SELECT mgmbldrgstpk, dx, dy
	FROM avm_bbook_pyo_count
	WHERE mgmbldrgstpk = '11110-100181034'
)
SELECT gakuka "������������(��/��)"
FROM bilxy, g2022 g22
WHERE (bilxy.dx = g22.dx) AND (bilxy.dy = g22.dy);

-- ** ��� 2 => where������ �ٷ� ã�� 
SELECT gakuka "������������(��/��)"
FROM g2022
WHERE dx=(SELECT dx FROM avm_bbook_pyo_count WHERE mgmbldrgstpk = '11110-100181034') AND 
      dy=(SELECT dy FROM avm_bbook_pyo_count WHERE mgmbldrgstpk = '11110-100181034');

-- ** ��� 3 => inner join���� ������ ã��
SELECT mgmbldrgstpk, gakuka
FROM (SELECT avm_bbook_pyo_count.mgmbldrgstpk, avm_bbook_pyo_count.dx, avm_bbook_pyo_count.dy
	  FROM avm_bbook_pyo_count 
	  WHERE mgmbldrgstpk = '11110-100181034') bilxy INNER JOIN 
	  g2022 g22 ON (bilxy.dx = g22.dx) AND (bilxy.dy = g22.dy);

-- ** ��� 4 => left join�� not null�� �̿�
SELECT mgmbldrgstpk, gakuka
FROM (SELECT avm_bbook_pyo_count.mgmbldrgstpk, avm_bbook_pyo_count.dx, avm_bbook_pyo_count.dy
	  FROM avm_bbook_pyo_count 
	  WHERE mgmbldrgstpk = '11110-100181034') bilxy LEFT JOIN 
	  g2022 g22 ON (bilxy.dx = g22.dx) AND (bilxy.dy = g22.dy)
WHERE mgmbldrgstpk IS NOT NULL;
/*
�� 4���� ��� ��� �������������� ã�µ��� 10���̻��� �ɷ� ���������� ������ �ִ�. 
�� ������ �������� ã�ƺ���!!
*/

-- ** ��� 5 => ������ �ñ��� �ڵ带 Ȱ���� ������������ ã��
WITH resu AS (SELECT sigungucd, bjdongcd, platgbcd, bun, ji
FROM avm_bbook_share_oneself_area 
WHERE mgmbldrgstpk = '11110-100181034'
)
SELECT gakuka "������������(��/��)"
FROM g2022, resu
WHERE resu.sigungucd = sreg AND 
      resu.bjdongcd = seub AND
      resu.platgbcd = ssan AND
      resu.bun = sbun1 AND 
      resu.ji = sbun2;
/*
1�� ������ �ٷ� ���� ���´�.
dx,dy�� ���� �ɸ��µ� 4���� and�� �� �ñ��� �ڵ�� �� �̷��� ���� ������ ���ϱ�?? 
*/

-- ���� ���
-- * full join
WITH sigun_resu AS (
	SELECT sigungucd, bjdongcd, platgbcd, bun, ji
	FROM avm_bbook_share_oneself_area 
	WHERE mgmbldrgstpk = '11110-100181034'
), ind_app AS (
	SELECT gakuka "������������(��/��)"
	FROM g2022, sigun_resu sr
	WHERE sr.sigungucd = sreg AND 
          sr.bjdongcd = seub AND
          sr.platgbcd = ssan AND
      	  sr.bun = sbun1 AND 
          sr.ji = sbun2
), year_app AS (
	SELECT y1.baseyear "���ð��� 1��°�⵵", y1.hsprc "���ð��� 1��°�⵵", y2.baseyear "���ð��� 2��°�⵵", y2.hsprc "���ð��� 2��°�⵵", y3.baseyear "���ð��� 3��°�⵵", y3.hsprc "���ð��� 3��°�⵵"
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

-- * �� ����� ����� ���̺� ��ġ��
WITH sigun_resu AS (
	SELECT sigungucd, bjdongcd, platgbcd, bun, ji
	FROM avm_bbook_share_oneself_area 
	WHERE mgmbldrgstpk = '11110-100181034'
), ind_app AS (
	SELECT gakuka "������������(��/��)"
	FROM g2022, sigun_resu sr
	WHERE sr.sigungucd = sreg AND sr.bjdongcd = seub AND sr.platgbcd = ssan AND sr.bun = sbun1 AND sr.ji = sbun2
), year22_app AS (
	SELECT substring(basedate,1,4) "���ð��� 1��°�⵵", hsprc "���ð��� 1��°�⵵"
	FROM bbook_hprice
	WHERE mgmbldrgstpk = '11110-100181034' AND substring(basedate,1,4)::NUMERIC = (to_char(now(), 'yyyy')::NUMERIC - 1)
), year21_app AS (
	SELECT substring(basedate,1,4) "���ð��� 2��°�⵵", hsprc "���ð��� 2��°�⵵"
	FROM bbook_hprice
	WHERE mgmbldrgstpk = '11110-100181034' AND substring(basedate,1,4)::NUMERIC = (to_char(now(), 'yyyy')::NUMERIC - 2)
), year20_app AS (
	SELECT substring(basedate,1,4) "���ð��� 3��°�⵵", hsprc "���ð��� 3��°�⵵"
	FROM bbook_hprice
	WHERE mgmbldrgstpk = '11110-100181034' AND substring(basedate,1,4)::NUMERIC = (to_char(now(), 'yyyy')::NUMERIC - 3) 
)
SELECT ind_app.*, year22_app.*, year21_app.*, year20_app.*
FROM ind_app, year22_app, year21_app, year20_app;

-- * �� ����� ����� ���̺� ��ġ��(����� �Է�)
WITH sigun_resu AS (
	SELECT mgmbldrgstpk, sigungucd, bjdongcd, platgbcd, bun, ji
	FROM avm_bbook_share_oneself_area 
	WHERE mgmbldrgstpk = '${user_mgm}'
), ind_app AS (
	SELECT gakuka "������������(��/��)"
	FROM g2022, sigun_resu sr
	WHERE sr.sigungucd = sreg AND sr.bjdongcd = seub AND sr.platgbcd = ssan AND sr.bun = sbun1 AND sr.ji = sbun2
), year22_app AS (
	SELECT substring(basedate,1,4) "���ð��� 1��°�⵵", hsprc "���ð��� 1��°�⵵"
	FROM bbook_hprice bh, sigun_resu sr
	WHERE bh.mgmbldrgstpk = sr.mgmbldrgstpk AND substring(basedate,1,4)::NUMERIC = (to_char(now(), 'yyyy')::NUMERIC - 1)
), year21_app AS (
	SELECT substring(basedate,1,4) "���ð��� 2��°�⵵", hsprc "���ð��� 2��°�⵵"
	FROM bbook_hprice bh, sigun_resu sr
	WHERE bh.mgmbldrgstpk = sr.mgmbldrgstpk AND substring(basedate,1,4)::NUMERIC = (to_char(now(), 'yyyy')::NUMERIC - 2)
), year20_app AS (
	SELECT substring(basedate,1,4) "���ð��� 3��°�⵵", hsprc "���ð��� 3��°�⵵"
	FROM bbook_hprice bh, sigun_resu sr
	WHERE bh.mgmbldrgstpk = sr.mgmbldrgstpk AND substring(basedate,1,4)::NUMERIC = (to_char(now(), 'yyyy')::NUMERIC - 3) 
)
SELECT ind_app.*, year22_app.*, year21_app.*, year20_app.*
FROM ind_app, year22_app, year21_app, year20_app;
/*
���࿡ 21�� �����Ͱ� ���ٸ� �ֱ� 3�� �����ʹ� 22,20,19�� �����Ͱ� ���;� �Ѵ�.
*/

-- �������(������ ��ħ)
WITH sigun_resu AS (
	SELECT mgmbldrgstpk, sigungucd, bjdongcd, platgbcd, bun, ji
	FROM avm_bbook_share_oneself_area 
	WHERE mgmbldrgstpk = '11110-100181034'
), ind_app AS (
	SELECT gakuka "������������(��/��)"
	FROM g2022, sigun_resu sr
	WHERE sr.sigungucd = sreg AND sr.bjdongcd = seub AND sr.platgbcd = ssan AND sr.bun = sbun1 AND sr.ji = sbun2
), year_third_in AS (
	SELECT mgmbldrgstpk, ROW_NUMBER() OVER (ORDER BY substring(basedate,1,4) desc) AS row_num, substring(basedate,1,4) "�⵵", hsprc
	FROM bbook_hprice 
	WHERE mgmbldrgstpk = '11110-100181034'
	ORDER BY row_num
), year_three_in AS (
	SELECT fir_ye."�⵵" "���ð��� 1��°�⵵", fir_ye.hsprc "���ð��� 1��°�⵵", sec_ye."�⵵" "���ð��� 2��°�⵵", sec_ye.hsprc "���ð��� 2��°�⵵", thr_ye."�⵵" "���ð��� 3��°�⵵", thr_ye.hsprc "���ð��� 3��°�⵵"
	FROM (SELECT "�⵵", hsprc FROM year_third_in WHERE row_num = 1) fir_ye,
		 (SELECT "�⵵", hsprc FROM year_third_in WHERE row_num = 2) sec_ye,
      	 (SELECT "�⵵", hsprc FROM year_third_in WHERE row_num = 3) thr_ye 
)
SELECT ind_app.*, year_three_in.*
FROM ind_app, year_three_in;

SELECT mgmbldrgstpk, ROW_NUMBER() OVER (ORDER BY substring(basedate,1,4) desc) AS row_num, substring(basedate,1,4) "�⵵", hsprc
	FROM bbook_hprice 
	WHERE mgmbldrgstpk = '11110-100181034'
	ORDER BY row_num
LIMIT 3;

-- �������(������ ��ħ + ����� �Է�)
WITH sigun_resu AS (
	SELECT mgmbldrgstpk, sigungucd, bjdongcd, platgbcd, bun, ji
	FROM avm_bbook_share_oneself_area 
	WHERE mgmbldrgstpk = '${user_mgm}'
), ind_app AS (
	SELECT gakuka "������������(��/��)"
	FROM g2022, sigun_resu sr
	WHERE sr.sigungucd = sreg AND sr.bjdongcd = seub AND sr.platgbcd = ssan AND sr.bun = sbun1 AND sr.ji = sbun2
), year_third_in AS (
	SELECT mgmbldrgstpk, ROW_NUMBER() OVER (ORDER BY substring(basedate,1,4) desc) AS row_num, substring(basedate,1,4) "�⵵", hsprc
	FROM bbook_hprice 
	WHERE mgmbldrgstpk = '${user_mgm}'
	ORDER BY row_num
), year_three_in AS (
	SELECT fir_ye."�⵵" "���ð��� 1��°�⵵", fir_ye.hsprc "���ð��� 1��°�⵵", sec_ye."�⵵" "���ð��� 2��°�⵵", sec_ye.hsprc "���ð��� 2��°�⵵", thr_ye."�⵵" "���ð��� 3��°�⵵", thr_ye.hsprc "���ð��� 3��°�⵵"
	FROM (SELECT "�⵵", hsprc FROM year_third_in WHERE row_num = 1) fir_ye,
		 (SELECT "�⵵", hsprc FROM year_third_in WHERE row_num = 2) sec_ye,
      	 (SELECT "�⵵", hsprc FROM year_third_in WHERE row_num = 3) thr_ye 
)
SELECT ind_app.*, year_three_in.*
FROM ind_app, year_three_in;

-- �ٸ� ���̺��� ���� �̸� ã��
SELECT a.column_name "avm_bbook_pyo_count column", b.column_name "g2022 column"
FROM (SELECT column_name
      FROM information_schema.COLUMNS 
      WHERE table_name = 'avm_bbook_pyo_count') a INNER JOIN
     (SELECT column_name
      FROM information_schema.COLUMNS 
      WHERE table_name = 'g2022') b ON a.column_name=b.column_name;

-- ���ȣ�� �Է¹޾� ���ϴ� �� ������ ����
-- * ���ȣ�� �Է� �ޱ�
SELECT ROW_NUMBER() OVER (ORDER BY mgmbldrgstpk) AS row_num, *
FROM avm_bbook_share_oneself_area;

-- * �Էµ� ���ȣ�� �̿��Ͽ� Ư�� ������ ���� ����
SELECT *
FROM (SELECT ROW_NUMBER() OVER (ORDER BY mgmbldrgstpk) AS row_num, *
      FROM avm_bbook_share_oneself_area) AS subquery
WHERE row_num BETWEEN 5000 AND 5100;

-- Ÿ�Ժ���
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

-- * 3. �Լ�
SELECT text(1);
SELECT to_char(2132012,'FM999,999,999');
SELECT to_date('20190130','yyyymmdd');
SELECT to_timestamp('20190130','yyyymmdd');
