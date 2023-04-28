-- ���̺� ���� Ȯ��
SELECT COLUMN_NAME "�÷���", COLUMN_COMMENT "�÷���", COLUMN_KEY, COLUMN_TYPE, IS_NULLABLE
FROM information_schema.columns 
WHERE TABLE_NAME=LOWER('user_info_hp')
/*
WHERE������ ������ �ϴ� ���̺���� �����ϸ� Ȯ�� ����
*/

-- hbtest�� �� ���̺� ���� ���� ������ 792��
SELECT * FROM information_schema.`COLUMNS` WHERE TABLE_schema='hanbang'


-- �ߺ��Ǵ� ���� �̸��� �����ϸ� 495��
-- ���� �̸����� ������ �����Ͱ� 297���� �ִٴ� �ǹ�
SELECT distinct COLUMN_NAME FROM information_schema.`COLUMNS` WHERE TABLE_schema='hanbang' 

-- �ߺ��Ǵ� ���� �̸� ������ 132��
SELECT COLUMN_NAME, COUNT(COLUMN_NAME)
FROM information_schema.`COLUMNS`
WHERE TABLE_schema='hanbang' 
GROUP BY COLUMN_NAME
HAVING COUNT(COLUMN_NAME)>1
ORDER BY 2 DESC 

-- �ߺ��Ǵ� ���� �̸��� �� ������ 429
SELECT SUM(a.ref)
from(SELECT COUNT(COLUMN_NAME) ref
     FROM information_schema.`COLUMNS`
     WHERE TABLE_schema='hanbang'
     GROUP BY COLUMN_NAME
     HAVING COUNT(COLUMN_NAME)>1) a

-- ���� �̸��� �ϳ��� �ִ� ���� 363
-- 429(�ΰ��̻�) + 363(�ϳ�) = 792(�� ���� ����)
SELECT COLUMN_NAME, COUNT(COLUMN_NAME)
FROM information_schema.`COLUMNS`
WHERE TABLE_schema='hanbang'
GROUP BY COLUMN_NAME
HAVING COUNT(COLUMN_NAME)=1
ORDER BY 2 DESC 

-- �ߺ��� ���̺� ������ ����
SELECT TABLE_NAME, COLUMN_NAME, DATA_type, column_key, column_comment
FROM information_schema.`COLUMNS` 
WHERE COLUMN_NAME IN (SELECT COLUMN_NAME
                      FROM information_schema.`COLUMNS`
                      WHERE TABLE_schema='hanbang'
                      GROUP BY COLUMN_NAME
                      HAVING COUNT(COLUMN_NAME)>1) 
		AND 
		TABLE_schema='hanbang'
ORDER BY COLUMN_NAME
