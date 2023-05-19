/*
��¥ : 2023-05-19
�ѹ� �׽�Ʈ DB�� db_khb_srv���� �ε����� �����ϴ� ������ ����� �ִ� ������ �ۼ�
 */

-- db_khb_srv�� ��ü �ε��� ����
SELECT i.name "�ε�����", i.is_unique "����ũ ����", t.schema_id, s.name "��Ű����", ic.object_id, t.name "���̺��", ic.index_column_id, ic.column_id, c.name "�÷���"
FROM sys.index_columns ic 
     	INNER JOIN 
     sys.tables t 
     		ON ic.object_id = t.object_id 
     	INNER JOIN 
     sys.schemas s 
     		ON s.schema_id = t.schema_id
     	INNER JOIN
     sys.columns c 
     		ON c.object_id = ic.object_id AND c.column_id = ic.column_id
     	INNER JOIN
     sys.indexes i 
     		ON i.object_id = ic.object_id AND i.index_id = ic.index_id 
WHERE i.[type] = 2;

-- db_khb_srv�� �ε��� ���� ������
SELECT 'CREATE ' + 
        CASE WHEN "����ũ ����" = 0 THEN 'INDEX ' 
             ELSE 'UNIQUE INDEX ' END +
        "�ε�����" + ' ON ' +
        "��Ű����" + '.' +
        "���̺��" + ' (' + "�÷���" + ');'
FROM (
	SELECT i.name "�ε�����", i.is_unique "����ũ ����", t.schema_id, s.name "��Ű����", ic.object_id, t.name "���̺��", ic.index_column_id, ic.column_id, c.name "�÷���"
	FROM sys.index_columns ic /*��ü ��ȣ, �ε��� �÷� id, �÷� id*/
	     	INNER JOIN 
	     sys.tables t /*��Ű�� id, ���̺��*/
	     		ON ic.object_id = t.object_id 
	     	INNER JOIN 
	     sys.schemas s /*��Ű����*/
	     		ON s.schema_id = t.schema_id
	     	INNER JOIN
	     sys.columns c /*�÷���*/
	     		ON c.object_id = ic.object_id AND c.column_id = ic.column_id
	     	INNER JOIN
	     sys.indexes i /*�ε�����, ����ũ����*/
	     		ON i.object_id = ic.object_id AND i.index_id = ic.index_id 
	WHERE i.[type] = 2
) ii ;

/*
sys.indexes�� type
 - 0 = ��
 - 1 = Ŭ�������� rowstore(B-tree)
 - 2 = ��Ŭ�������� rowstore(B-tree)
 - 3 = XML
 - 4 = ����
 - 5 = Ŭ�������� columnstore �ε����Դϴ�. ���� ���: SQL Server 2014(12.x) �̻�
 - 6 = ��Ŭ�������� columnstore �ε����Դϴ�. ���� ���: SQL Server 2012(11.x) �̻�
 - 7 = ��Ŭ�������� �ؽ� �ε����Դϴ�. ���� ���: SQL Server 2014(12.x) �̻�
*/
