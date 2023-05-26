/*
��¥ : 2023-05-23
�ѹ� �׽�Ʈ DB�� db_khb_srv���� ���̺� �����ϴ� ������ ����� �ִ� ������ �ۼ�
 */--object_name(major_id)='tb_com_banner_info'
-- ���̺��� �� ����
SELECT DISTINCT 
       c.TABLE_NAME"���̺��", c.COLUMN_NAME "�÷���", 
       CASE WHEN c.DATA_TYPE IN ('decimal', 'numeric') THEN c.DATA_TYPE + '(' + CAST(c.NUMERIC_PRECISION AS varchar) + ', ' + CAST(c.NUMERIC_SCALE AS varchar) + ')'
            WHEN c.DATA_TYPE IN ('char', 'varchar', 'nvarchar') THEN c.DATA_TYPE + '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
            ELSE c.DATA_TYPE
       END "Ÿ�� ����",
       CASE WHEN c.IS_NULLABLE = 'NO' THEN ' NOT NULL'
            ELSE ''
       END "NULL����",
       ep.value 
FROM information_schema.columns c
     INNER JOIN
     information_schema.constraint_column_usage ccu
     	ON c.TABLE_NAME = ccu.TABLE_NAME
     LEFT JOIN
     sys.extended_properties ep
     	ON c.TABLE_NAME = object_name(ep.major_id) AND c.ORDINAL_POSITION = ep.minor_id
WHERE c.COLUMN_NAME LIKE '%_'
ORDER BY 1;

-- �ʿ� ���� ����
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, IS_NULLABLE, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, 
       NUMERIC_PRECISION, NUMERIC_SCALE, DATETIME_PRECISION
FROM information_schema.columns;
/*IS_NULLABLE => NO(not null) YES(null)*/

-- �������� �ؽ�Ʈ�� ����
SELECT * FROM information_schema.columns;

-- �������� ���ڷ� ����
SELECT * FROM sys.columns;

-- ���̺� PK
SELECT * FROM information_schema.constraint_column_usage;
SELECT * FROM sys.objects WHERE type ='pk';

-- ���̺� ���� ��ũ��Ʈ �ۼ� �غ� ���̺�
SELECT c.TABLE_NAME "���̺��", 
       c.COLUMN_NAME + ' ' + 
       CASE WHEN c.DATA_TYPE IN ('decimal', 'numeric') THEN c.DATA_TYPE + '(' + CAST(c.NUMERIC_PRECISION AS varchar) + ', ' + CAST(c.NUMERIC_SCALE AS varchar) + ')'
            WHEN c.DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar') THEN c.DATA_TYPE + '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
            ELSE c.DATA_TYPE
       END + 
       CASE WHEN c.IS_NULLABLE = 'NO' THEN ' NOT NULL'
            ELSE ''
       END +
       CASE WHEN c.COLUMN_DEFAULT IS NOT NULL THEN ' defualt ' + c.COLUMN_DEFAULT
            ELSE ''
       END "�� ����", 
       ccu.COLUMN_NAME "pk_col"
FROM information_schema.columns c
     INNER JOIN
     information_schema.constraint_column_usage ccu
     	ON c.TABLE_NAME = ccu.TABLE_NAME;

-- �� ���̺� ���̺� �ۼ� ������
SELECT c2.TABLE_NAME "���̺��", 
       'CREATE TABLE ' + c2.TABLE_SCHEMA + '.' + c2.TABLE_NAME + ' (' +
	   stuff((SELECT ', ' + c1.COLUMN_NAME + ' ' + 
		          CASE WHEN c1.DATA_TYPE IN ('decimal', 'numeric') THEN c1.DATA_TYPE + '(' + CAST(c1.NUMERIC_PRECISION AS varchar) + ', ' + CAST(c1.NUMERIC_SCALE AS varchar) + ')'
	                   WHEN c1.DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar') THEN c1.DATA_TYPE + '(' + CAST(c1.CHARACTER_MAXIMUM_LENGTH AS varchar) + ')'
	                   ELSE c1.DATA_TYPE
	              END + 
	              CASE WHEN c1.IS_NULLABLE = 'NO' THEN ' NOT NULL'
	                   ELSE ''
	              END +
                  CASE WHEN c1.COLUMN_DEFAULT IS NOT NULL THEN ' default ' + c1.COLUMN_DEFAULT
                       ELSE ''
                  END 
              FROM information_schema.columns c1
              WHERE c1.TABLE_NAME = c2.TABLE_name
              	FOR xml PATH('')), 1, 2, '') + 
       CASE WHEN ccu.COLUMN_NAME != '' THEN ', primary key (' +  ccu.COLUMN_NAME + '));' END "���̺� �ۼ� ��ũ��Ʈ"
FROM information_schema.columns c2
     INNER JOIN
     information_schema.constraint_column_usage ccu
     	ON c2.TABLE_NAME = ccu.TABLE_NAME
GROUP BY c2.TABLE_NAME, c2.TABLE_SCHEMA, ccu.COLUMN_NAME;



