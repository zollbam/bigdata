-- ��������
-- 1. ���� �������� ��� ������ ��� �϶�ǥ�� �ۼ��ϱ� ���� DB�����
--    �ϳ��� ���̺��� ���� ������ ����ϰ� 
--    �ٸ� ���̺��� �� ������ ���� ��ü���� ������ ���
CREATE TABLE animal_types (
    animal_type_id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY, -- ���� ���� ��ȣ
    common_name varchar(50) NOT NULL, -- ���� �̸�(=��Ī)
    scientific_name varchar(50) NOT NULL, -- ������ ��¥ �̸�
    conservation_status varchar(50) NOT NULL, -- ��ȣ ����
    CONSTRAINT common_name_unique UNIQUE (common_name) -- ��Ī�� �ߺ��� �� �� �� ����.
);

CREATE TABLE menagerie (
   menagerie_id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY, -- �߻����� ��ȣ
   common_name varchar(50) REFERENCES animal_types (common_name), -- ���� ��Ī
   date_acquired date NOT NULL, -- ������ ���� ��¥
   gender varchar(50), -- ����
   acquired_from varchar(50), -- ������ �̸�
   notes varchar(50) -- �߰� ����
);

INSERT INTO animal_types (common_name, scientific_name, conservation_status) VALUES
('Bengal Tiger', 'Panthera tigris tigris', 'Endangered'),
('Arctic Wolf', 'Canis lupus arctos', 'Least Concern');

INSERT INTO menagerie (common_name, date_acquired, gender, acquired_from, notes) VALUES
('Bengal Tiger', '1996-03-12', 'F', 'Dhaka Zoo', 'Healthy coat at last exam.'),
('Arctic Wolf', '2000-09-30', 'F', 'National Zoo', 'Strong appetite.');