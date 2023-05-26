/*
mssql ������
��¥ 23-05-19
json���·� �� ������ geometry���� �ٲٱ� ���� �ۼ�
*/

-- ���̺� ����
DROP TABLE json_data_tbl;

-- ���̺� ����
CREATE TABLE json_data_tbl(
	json_lng_lat NVARCHAR(MAX)
);
/*NVARCHAR���� ������ json_value�Լ��� ����� �� ����
  json_value�� ù��° �μ��� textŸ���� �ν����� �� ��*/

-- json���·� ���ڵ� ����
INSERT INTO json_data_tbl VALUES (N'{"lng":127.64545, "lat":37.41153}');

-- ������ ���� Ȯ��
SELECT * FROM json_data_tbl;

-- json�� ����
SELECT json_value(json_lng_lat,'$.lng'), json_value(json_lng_lat,'$.lat')
FROM json_data_tbl;
/*mariadb�� json_extract �Լ��� ���� ���*/

-- geometryŸ�� �� �����
SELECT geometry::Point(json_value(json_lng_lat,'$.lng'), json_value(json_lng_lat,'$.lat'),4326)
FROM json_data_tbl;

-- 
SELECT * FROM information_schema.constraint_table_usage;
SELECT * FROM information_schema.constraint_table_usage;