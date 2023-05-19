USE msdb
go
-- tables : ���̺� ����
SELECT * FROM information_schema.tables;

-- TABLE_CONSTRAINTS : �� ���̺� ���� ����
SELECT * FROM information_schema.TABLE_CONSTRAINTS;

-- TABLE_PRIVILEGES : ���̺� ����
SELECT * FROM information_schema.TABLE_PRIVILEGES;

-- CONSTRAINT_TABLE_USAGE : ��������/���̺��� catalog, schema, name�� ������ ����
/*TABLE_CONSTRAINTS���� ���� ������ ����*/
SELECT * FROM information_schema.CONSTRAINT_TABLE_USAGE;

-- COLUMNS : �÷� ����
SELECT * FROM information_schema.COLUMNS;

-- COLUMN_PRIVILEGES : �� ����
SELECT * FROM information_schema.COLUMN_PRIVILEGES;

-- CONSTRAINT_COLUMN_USAGE : CONSTRAINT_TABLE_USAGE�� �÷����� ����
SELECT * FROM information_schema.COLUMN_PRIVILEGES;

-- KEY_COLUMN_USAGE : ���������� key
SELECT * FROM information_schema.KEY_COLUMN_USAGE;

-- referential_constraints : FK
SELECT * FROM information_schema.referential_constraints;

-- check_constraints : CKECK��������
SELECT * FROM information_schema.check_constraints;

-- VIEWS : View
SELECT * FROM information_schema.VIEWS;

-- VIEW_TABLE_USAGE : VIEW/TABLE�� CATALOG, SCHEMA, NAME
SELECT * FROM information_schema.VIEW_TABLE_USAGE;

-- VIEW_COLUMN_USAGE : VIEW_TABLE_USAGE + COLUMN_NAME
SELECT * FROM information_schema.VIEW_COLUMN_USAGE;

-- ROUTINES : ���ν����� �Լ�
SELECT * FROM information_schema.ROUTINES;

-- ROUTINE_COLUMNS : COLUMNS���� ���� ������ ����
SELECT * FROM information_schema.ROUTINE_COLUMNS;

-- PARAMETERS : ����� ���� �Լ� �Ǵ� ���� ���ν���
SELECT * FROM information_schema.PARAMETERS;

-- DOMAINS : ��Ī ������
SELECT * FROM information_schema.DOMAINS;

-- COLUMN_DOMAIN_USAGE : ��Ī ������
SELECT * FROM information_schema.COLUMN_DOMAIN_USAGE;

-- SCHEMATA : ��Ű��
SELECT * FROM information_schema.SCHEMATA;

-- SEQUENCES: ������
SELECT * FROM information_schema.SEQUENCES;
