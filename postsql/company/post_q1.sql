-- �ش� �ǹ��� ������ ���� ã��
SELECT *
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';
/*
 ��ȭ�� �����̽����̶�� �����ʹ� �Ѱ� ���̴�.
 �ñ���: ��� ���๰������ 1���� ������?? PK�ϱ� �Ѱ��� �ְ���??
*/

-- ���๰ ������ �׷����� ��� ������������ ī��Ʈ
SELECT mgmbldrgstpk, count(*)
FROM tbl_avm001
GROUP BY mgmbldrgstpk
ORDER BY 1 desc;
/*
���� ū ���� 1�̹Ƿ� ��� ���๰������� 1���� �ִ� ���� Ȯ��
*/

-- �ش� �ǹ��� ���ݰ� �ܰ��� �ִ밪 ã��
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
�����Ͱ� 1�����̶� max�� ���� min�� ���� �ƹ��͵� �� ���� ����� �����ϴ�!!!
*/

-- �ش� �ǹ��� ���ݰ� �ܰ��� �ּҰ� ã��
SELECT min_price, min_price_danga
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';
/*
���ݰ� �ܰ��� �ּҰ��� ���Ѵ�.
*/

-- ���� ���¸� �ٲپ� ����
SELECT min_price, '(@'|| to_char(min_price, 'FM999,999,999,999') ||')' 
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';
/*
min_price�� õ������ ���¸� �����ϰ� Ư�����ڵ� �ٿ� ���ҽ��ϴ�.
*/

-- ���� ��� ��ȯ
SELECT CONCAT('����', '(MAX)') ����,
               TO_CHAR(max_price,'FM999,999,999,999') || '��' ����, 
               '(@' || TO_CHAR(max_price_danga,'FM999,999,999,999') || ')' �ܰ�
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034'
UNION
SELECT CONCAT('����', '(MIN)') ����,
               TO_CHAR(min_price,'FM999,999,999,999') || '��' ����, 
               '(@' || TO_CHAR(min_price_danga,'FM999,999,999,999') || ')' �ܰ�
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';
/*
�������� ���ִ� union���� ������� �Ͽ����ϴ�.
*/

-- ���๰������ ���� �Է��Ͽ� ��� ����
SELECT CONCAT('����', '(MAX)') ����,
               TO_CHAR(max_price,'FM999,999,999,999') || '��' ����, 
               '(@' || TO_CHAR(max_price_danga,'FM999,999,999,999') || ')' �ܰ�
FROM tbl_avm001
WHERE mgmbldrgstpk = '${a}'
UNION
SELECT CONCAT('����', '(MIN)') ����,
               TO_CHAR(min_price,'FM999,999,999,999') || '��' ����, 
               '(@' || TO_CHAR(min_price_danga,'FM999,999,999,999') || ')' �ܰ�
FROM tbl_avm001
WHERE mgmbldrgstpk =  '${a}';
/*
mgmbldrgstpk���� ���� �ϸ� �ٸ� �ǹ��� ����, �ܰ��� �ִ�/�ּҰ��� �� �� �ִ�.
*/

-- ���Ͽ��� ���� �ʰ� �غ���
-- * �ǹ����̺�
SELECT *
FROM tbl_avm001
           CROSS JOIN LATERAL unnest(ARRAY['����(MAX)', '����(MIN)'], 
                                                                ARRAY[max_price,min_price], 
                                                                ARRAY[max_price_danga,min_price_danga]) AS pv(com, price, danga);
 /*
������ �ִ� ���� �����͵� ��ȯ�� �˴ϴ�.
wide������ �� ���� 499,608�̾�����
long���� �ٲ��� 2���� 999,216�� �Ǿ����ϴ�.

���� �ǹ����� ����� �;��ߴ� ���� 3�� �����ϴ�. => ����, ����, �ܰ�
CROSS JOIN LATERAL unnest�� �ǹ��� ����� ARRAY[]�� �̿��� ������ ���ϰ��� �ϴ� ������ ���̺�� �������.
AS pv(com, price, danga)�� �ؼ� ���� ���� ���� �̸��� ���Ѵ�.
 - ARRAY['����(MAX)', '����(MIN)'] => com
 - ARRAY[max_price,min_price] => price
 - ARRAY[max_price_danga,min_price_danga] => danga
 - pv� �̸��� �͵� ����� ����. => p(com, price, danga), x(com, price, danga) �� �̸��� �����Ҽ��� ������ ��� ����!!!
*/

-- ���� ���� �ǹ����̺� ����
SELECT com, price, danga, mgmbldrgstpk
FROM tbl_avm001
           CROSS JOIN LATERAL unnest(ARRAY['����(MAX)', '����(MIN)'], 
                                                                ARRAY[max_price,min_price], 
                                                                ARRAY[max_price_danga,min_price_danga]) AS pv(com, price, danga);
 /*
mgmbldrgstpk�� ������ ���ε� ���� ���� 2���� �ݺ��Ǿ� ��µǴ� ���� Ȯ�� �� �� �ֽ��ϴ�.
where���� ���� ������ ���ϴ� ������ �ǹ����̺��� ��ȸ�� �� �ֽ��ϴ�.
*/

-- ���ϴ� ���๰������ ���� ���
SELECT com ����, TO_CHAR(price, 'FM999,999,999,999') || '��' ����,  '(@' || TO_CHAR(danga, 'FM999,999,999,999') || ')' �ܰ�
FROM tbl_avm001
           CROSS JOIN LATERAL unnest(ARRAY['����(MAX)', '����(MIN)'], 
                                                                ARRAY[max_price,min_price], 
                                                                ARRAY[max_price_danga,min_price_danga]) AS x(com, price, danga)
WHERE mgmbldrgstpk = '11110-100181034';
 /*
����/���̸��� �ٲٰ� where���� Ȱ���Ͽ� ���ϴ� ��������� ������ϴ�.
*/

-- ����ڰ� ���๰�����ȣ�� �Է��Ͽ� ���� ��� ���
SELECT com ����, TO_CHAR(price, 'FM999,999,999,999') || '��' ����,  '(@' || TO_CHAR(danga, 'FM999,999,999,999') || ')' �ܰ�
FROM tbl_avm001
           CROSS JOIN LATERAL unnest(ARRAY['����(MAX)', '����(MIN)'], 
                                                                ARRAY[max_price,min_price], 
                                                                ARRAY[max_price_danga,min_price_danga]) AS x(com, price, danga)
WHERE mgmbldrgstpk = '${iput}';
 /*
iput�� �������ϴ� ���๰���� ��ȣ�� �Է��Ͽ� ��������� ��Ÿ���� ���̴�.
*/

--�⺻ ������(���) ���� �����
-- * ���� ��ũ: https://mine-it-record.tistory.com/447
WITH RECURSIVE make_recu AS (
   SELECT 1 AS num1, 3 AS num2
   UNION ALL
   SELECT num1 + 1, num2 + 1 FROM make_recu WHERE num1 < 2 AND num2<4
)
SELECT * FROM make_recu;

-- �ش� ���๰������ ������ ������������ ���� ���
WITH RECURSIVE make_recu AS (
   SELECT 1 AS num1, 3 AS num2, 5 AS num3
   UNION ALL
   SELECT num1 + 1, num2 + 1, num3 + 1 FROM make_recu WHERE num1 < 2 AND num2 < 4 AND num3<6
)
SELECT CASE mr.num1 WHEN 1 THEN '����(MAX)' ELSE '����(MIN)' END ����,
               CASE mr.num2 WHEN 3 THEN TO_CHAR(tbl.max_price, 'FM999,999,999,999') || '��' 
                                                      ELSE TO_CHAR(tbl.min_price, 'FM999,999,999,999') || '��' END ����,
               CASE mr.num3 WHEN 5 THEN'(@' || TO_CHAR(tbl.max_price_danga, 'FM999,999,999,999') || ')' 
                                                      ELSE '(@' || TO_CHAR(tbl.min_price_danga, 'FM999,999,999,999') || ')' END �ܰ�
FROM make_recu mr, tbl_avm001 tbl
WHERE mgmbldrgstpk = '11110-100181034';

-- ���๰������ ����ڰ� ���� �Է��Ͽ� ������������ ���� ���
WITH RECURSIVE make_recu AS (
   SELECT 1 AS num1, 3 AS num2, 5 AS num3
   UNION ALL
   SELECT num1 + 1, num2 + 1, num3 + 1 FROM make_recu WHERE num1 < 2 AND num2 < 4 AND num3<6
)
SELECT CASE mr.num1 WHEN 1 THEN '����(MAX)' ELSE '����(MIN)' END ����,
               CASE mr.num2 WHEN 3 THEN TO_CHAR(tbl.max_price, 'FM999,999,999,999') || '��' 
                                                      ELSE TO_CHAR(tbl.min_price, 'FM999,999,999,999') || '��' END ����,
               CASE mr.num3 WHEN 5 THEN'(@' || TO_CHAR(tbl.max_price_danga, 'FM999,999,999,999') || ')' 
                                                      ELSE '(@' || TO_CHAR(tbl.min_price_danga, 'FM999,999,999,999') || ')' END �ܰ�
FROM make_recu mr, tbl_avm001 tbl
WHERE mgmbldrgstpk = '${mgm}';

-- cross join �⺻��
SELECT ta.avm_mdl_id, ta.mgmbldrgstpk, max_price, max_price_danga, min_price, min_price_danga, num
FROM tbl_avm001 ta CROSS JOIN generate_series(1,2) num;

-- cross join + case when
SELECT CASE WHEN num=1 THEN '����(MAX)' ELSE '����(MIN)' END "����",
               CASE WHEN num=1 THEN to_char(ta.max_price, 'FM999,999,999,999') || '��' ELSE to_char(ta.min_price, 'FM999,999,999,999') || '��' END "����",
               CASE WHEN num=1 THEN '(@' || to_char(ta.max_price_danga, 'FM999,999,999,999') || ')' ELSE '(@' || to_char(ta.min_price_danga, 'FM999,999,999,999') || ')' END "�ܰ�"
FROM tbl_avm001 ta CROSS JOIN generate_series(1,2) num
WHERE mgmbldrgstpk = '11110-100181034';

-- cross join + case when + ����ڰ� �Է��� ���๰����
SELECT CASE WHEN num=1 THEN '����(MAX)' ELSE '����(MIN)' END "����",
               CASE WHEN num=1 THEN to_char(ta.max_price, 'FM999,999,999,999') || '��' ELSE to_char(ta.min_price, 'FM999,999,999,999') || '��' END "����",
               CASE WHEN num=1 THEN '(@' || to_char(ta.max_price_danga, 'FM999,999,999,999') || ')' ELSE '(@' || to_char(ta.min_price_danga, 'FM999,999,999,999') || ')' END "�ܰ�"
FROM tbl_avm001 ta CROSS JOIN generate_series(1,2) num
WHERE mgmbldrgstpk = '${mbrgspk}';

-- �ɽ�Ǯ��: ���ڿ� ����
-- * ���� ������� ���ڿ� �ڸ���
WITH a AS (
	SELECT 1 no, '1:10|2:11|3:12|4:15' v
	UNION ALL SELECT 2, '1:17|3:15|4:25' 
	UNION ALL SELECT 3, '2:11|4:15'
	UNION ALL SELECT 4, '1:10|2:21|4:19'
)
SELECT NO,
               CASE WHEN length(substring(v, 3 , 2))=0 THEN  '0' ELSE substring(v, 3 , 2) END "1",
               CASE WHEN length(substring(v, 8 , 2))=0 THEN  '0' ELSE  substring(v, 8 , 2) END "2",
               CASE WHEN length(substring(v, 13 , 2))=0 THEN  '0' ELSE  substring(v, 13 , 2) END "3",
               CASE WHEN length(substring(v, 18 , 2))=0 THEN  '0' ELSE substring(v, 18 , 2) END "4"
FROM a;

-- * ���� ǥ���Ŀ� �°� ���ڿ� �ڸ���
WITH a AS (
	SELECT 1 no, '1:10|2:11|3:12|4:15' v
	UNION ALL SELECT 2, '1:17|3:15|4:25' 
	UNION ALL SELECT 3, '2:11|4:15'
	UNION ALL SELECT 4, '1:10|2:21|4:19'
)
SELECT NO,
               COALESCE(split_part(substring(v from '1:[^|]+'),':',2), NULL, '0') "v1",
               COALESCE(split_part(substring(v from '2:[^|]+'),':',2), NULL, '0') "v2",
               COALESCE(split_part(substring(v from '3:[^|]+'),':',2), NULL, '0') "v3",
               COALESCE(split_part(substring(v from '4:[^|]+'),':',2), NULL, '0') "v4"
FROM a;

-- * ��Ģ���� ������ �� �����
SELECT generate_series(1, 10) AS num;
/*
1�� �����ϴ� 10�� X 1�� ���̺��� ��������ϴ�. 
*/

SELECT generate_series(1, 30, 2) AS num;
/*
1���� 30���� 2�� �����ϴ� 15�� X 1�� ���̺��� ��������ϴ�. 
*/

SELECT generate_series(1, 30, 2) AS num1, generate_series(10, 150, 10) AS num2;
/*
15�� X 2���� ���̺��� ��������ϴ�.
*/
