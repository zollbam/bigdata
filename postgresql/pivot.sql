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
















