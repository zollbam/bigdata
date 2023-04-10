-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- ����
/*
- postgresql�� ��ҹ��� ������� �ĺ��ڸ� �ҹ��ڷ� ����մϴ�.
  => create table Customer�̳� create table customer�� �����ϰ� �� �� �� �ϳ��� ���̺��� �����Ǹ�
     �̹� �ִ� �����̼��̶�� ������ ��Ÿ���� �˴ϴ�.
  => �̸� �ذ��ϱ� ���� �ο�ĺ��ڸ� ����Ͽ� 2���� ���̺���� �����մϴ�.
     create table "Customer"�� create table "customer"�� �ٸ� ���̺��̴�.
     �ҷ��� ���� select * from "Customer"�� �ٸ��ٴ� ���� �� �� �ְ� �ο�ĺ��ڸ� ���
- ���� �ĺ��ڷ� ����� �� �ֽ��ϴ�.
- �̷������� ���� �ο��ȣ�� ��������� �̸����� ������ �߻��� ���ɼ��� ���� ������ ����ϴ� ���� ����õ�Ѵ�.
  => ������ũ ���̽��� ���
  => �̸��� �����ϱ� ���� ���� ��ȣ ���� ��� ����� �����ϼ���
  => ���̺� �̸��� ������ �̸��� ����ϼ���
  => ���̺� �̸����δ� �������̸��� ����ϼ���
  => ���̸� �Ű澲���� (sql�� 128��, postgresql�� 63��, oracle�� 30��)
  => ���̺��� ������ �� ���߿� �����ϴµ� ������ �Ǵ� �̸��� ����ϼ���
- ���������� �����ϴ� �Ϳ��� ���̺� �������ǰ� �� �������� 2������ ����� �ֽ��ϴ�.

*/

-- ���Ͽ� �ڿ�Ű�� �⺻Ű�� ����
create table natural_key_examples (
    license_id text constraint license_key PRIMARY key,
    first_name text,
    last_name text
);
/*
license_id text PRIMARY key�� �ܾ� ��� �����ص� �ȴ�.
*/

insert into natural_key_examples VALUES
        ('T22990','Gem','Godfrey');

insert into natural_key_examples VALUES
        ('T22990','John','Mitchell');
/*
license_id�� �⺻Ű�ε� ���̺� T22990�� �ԷµǾ� �־ �� T22990�� �Է� �Ϸ��� �ϴ�
���� ���� ���� �����̶�� �޼����� �����鼭 ������ �߻��ϰ� �˴ϴ�.
*/

-- ���� �⺻Ű ����
create table natural_key_composite_example (
    student_id text,
    school_day date,
    present boolean,
    constraint student_key PRIMARY key (student_id, school_day)
);
/*
����Ű�� ������ ���� ��ȣ�� ����� �Ѵ�.
*/

insert into natural_key_composite_example VALUES
        (775, '2022-01-22', 'Y');

insert into natural_key_composite_example VALUES
        (775, '2022-01-23', 'Y');
/*
student_id�� ���������� school_day�� �޶� �������� ������ ����
*/

insert into natural_key_composite_example VALUES
        (775, '2022-01-23', 'N');
/*
student_id�� school_day�� ��� �����ؼ� ������ ���´�.
*/

-- �ڵ� ���� ���� Ű ����
create table surrogate_key_example (
    order_number bigint generated always as identity,
    product_name text,
    order_time timestamp with time zone,
    constraint order_number_key primary key (order_number)
);

insert into surrogate_key_example(product_name, order_time) VALUES
        ('Beachball Polisg', '2020-03-15 09:21-07'),
        ('Wrinkle De-Atomizer', '2017-05-22 14:00-07'),
        ('Flux Capacitor', '1985-10-26 01:18:00-07');

table surrogate_key_example;
/*
�ڵ����� �̹Ƿ� order_number�� ���� �Է����� �ʾƵ� �˾Ƽ� ���� ������ �ȴ�.
*/

-- * ���� ���԰� �ڵ� ���� �� �缳��
insert into surrogate_key_example values
            (4, 'Chicken Choop', '2021-09-03 10:33-07');
/*
�������� �� �� ���ٴ� �ǹ��� ������ ���´�.
*/

insert into surrogate_key_example overriding system value values 
            (4, 'Chicken Choop', '2021-09-03 10:33-07');
/*
���������� ���ؼ��� overriding system value�ɼ��� values�տ� �Է����־�� �Ѵ�.
*/

insert into surrogate_key_example(product_name, order_time) VALUES
        ('Aloe Plant', '2020-03-15 10:09-07');
/*
order_number�� ���� �ڵ����� 5�� �Ǿ� ���� ���ԵǴ��� �˾�����
�����Է��� �ϸ� ��ǻ�ʹ� �ν��� ���� ���� ����ؼ� 4�� ���¿���
���� �����Ϸ��� �Ѵ�. �׷��� ���̺� �ȿ� 4�� ���� �����Ƿ� ������ �߻�
*/

alter table surrogate_key_example alter COLUMN order_number restart with 5;
/*
�ڵ� ���� ������ �ٽ� 5���� ������ �ߴ�.
*/

-- * ����) 2�� ���� ����� �ٽ� �����ϱ�
delete from surrogate_key_example where order_number=2;

table surrogate_key_example;

insert into surrogate_key_example(product_name, order_time) VALUES
        ('Cho Gun', '2023-04-10 12:56-07');
/*
�̻��·� �����ϸ� order_number�� 5�� �Է��� �ȴ�.
*/

alter table surrogate_key_example alter order_number restart with 2;

insert into surrogate_key_example(product_name, order_time) VALUES
        ('Kim hack', '2023-04-10 13:00-07');
/*
�缳���� 2�� �Ͽ� 2�� �����Ͱ� ���ڵ�� �߰��� ������ ������ ���� �ʰ� ���� ������ �࿡ �߰��� �ȴ�.
*/

insert into surrogate_key_example(product_name, order_time) VALUES
        ('Lee Bab', '2023-04-10 13:02-07');
/*
3���� ���� �Է��� �ǹǷ� ���� �����Ϸ��� ������ ���´�.
*/

alter table surrogate_key_example alter order_number restart with 6;

insert into surrogate_key_example(product_name, order_time) VALUES
        ('Park Seri', '2023-04-10 13:03-07');

-- �ܷ�Ű
create table licenses (
    license_id text constraint licenses_key PRIMARY key,
    first_name text,
    last_name text
);

create table registrations (
    registration_id text,
    registration_date timestamp with time zone,
    license_id text references licenses(license_id),
    constraint registration_key PRIMARY key (registration_id, license_id)
);

insert into licenses VALUES
    ('T229901', 'Steve', 'Rothery');

insert into registrations VALUES
    ('A203391', '2022-03-17', 'T229901');

insert into registrations VALUES
    ('A75772', '2022-03-17', 'T000001');
/*
licenses���̺��� license_id���� T000001���� �����Ƿ� �����Ͱ� �Էµ��� �ʰ� ������ ������ �ȴ�.
*/

-- cascade
/*
�⺻Ű�� �ִ� ���̺��� ���� �����Ϸ��� �ϸ� �ܷ�Ű�� ���� �ִٰ� ���� �� �� ���ٴ� �޼�����
������ ��찡 �ִ�. �� ��� �ܷ�Ű�� �ش� �����͸� �����ϰ� �⺻Ű�� �ִ� �����͸� ������ �ϴµ�
�̸� �ڵ����� ���ִ� Ű���尡 cascade�̴�.
*/

-- * ���̺� ����
drop table registrations;

-- * ���̺� ����
create table registrations (
    registration_id text,
    registration_date timestamp with time zone,
    license_id text references licenses(license_id) on delete cascade,
    constraint registration_key PRIMARY key (registration_id, license_id)
);
/*
on delete cascade�� �⺻Ű ������ ������ �ܷ�Ű ������ �ڵ� ����
*/

-- * licenses�� ������ ����
insert into licenses VALUES
    ('T229902', 'Cho', 'Gun');

-- * registrations�� ������ ����
insert into registrations VALUES
    ('A301551', '2020-12-10', 'T229902');

-- * �⺻Ű ���̺� ������ ����
delete from licenses where license_id='T229901';
/*
�⺻���̺�/�ܷ��׾ƺ� ��ο��� license_id�� T229901�� ���� ��� ����
*/

-- * ���̺� Ȯ��
table licenses;
table registrations;

-- check
/*
check���������� ������ ������ ���� ������ �����ϴ��� ���θ� ���մϴ�.
������ �������� ������ DB���� ������ ��ȯ�մϴ�.

�� ��������: [���̸�] [������ Ÿ��] check (���ǽ�)
���̺� ��������: ��� �� ���� ��, constraint constraint_name check (���ǽ�)

and�� or�� ����Ͽ� �ϳ��� check���� �������� ������ ���� ���� �ִ�.

(���̸�1 < ���̸�2) ���·� �ϳ��� ���� �ϳ��� ������ �۾ƾ��� �ԷµǴ� �����͵鵵 �ִ�.
*/
create table check_constraint_example (
    user_id bigint generated always as identity,
    user_role text,
    salary numeric(10,2),
    constraint user_id_key PRIMARY key (user_id),
    constraint user_role_in_list check (user_role in('Admin', 'Staff')),
    constraint check_salary_not_below_zero check (salary >= 0)
);

-- unique
/*
�ߺ��Ǵ� ������ ���� ������ �ϳ��� ������ �ϳ��� ���� ������ �ȴ�.
�⺻Ű�� ��������� �ٸ����� null���� ��� �� �� �ִٴ� ���̴�. => null�� ���� �� ����
*/
create table uniqie_constraint_example (
    contact_id bigint generated always as identity,
    first_name text,
    last_name text,
    email text,
    constraint contact_id_key PRIMARY KEY (contact_id),
    constraint email unique(email)
);

insert into uniqie_constraint_example(first_name, last_name, email) values
                ('Samantha', 'Lee', 'slee@example.org');

insert into uniqie_constraint_example(first_name, last_name, email) values
                ('Betty', 'Diaz', 'bdiaz@example.org');

insert into uniqie_constraint_example(first_name, last_name, email) values
                ('Sasha', 'Lee', 'slee@example.org');
/*
ù���� �Է��� �������� email�����Ϳ� �ߺ��� �Ǿ� ���� �߻�
*/

-- not null
create table not_null_example (
    student_id bigint generated always as identity,
    first_name text not null,
    last_name text not null,
    constraint student_id_key PRIMARY KEY (student_id)
);

insert into not_null_example(first_name, last_name) values
            ('Cho', 'Young');
/*
first_name�� last_name���� null���� �����Ƿ� ������ �߻����� �ʽ��ϴ�.
*/

insert into not_null_example(first_name, last_name) values
            (null, 'Hack');
/*
first_name���� null�� �Է��� �� ���µ� �Է��� �Ǿ� ������ �߻�
*/

-- �������� ���� �� ����/�߰�
/*
���� ����: alter table [���̺��] drop constraint [�������Ǹ�];

�� �������� ���� ���� : alter table [���̺��] alter column [�÷���] drop [�������� Ű����];

�� �������� ���� ���� : alter table [���̺��] add column [�÷���] drop [�������� Ű����];
*/

alter table not_null_example alter column first_name drop not null;
/*
not_null_example���̺��� first_name���� not null���������� ����
*/

alter table not_null_example alter column first_name set not null;
/*
not_null_example���̺��� first_name���� not null���������� �ٽ� ����
*/

alter table not_null_example drop constraint student_id_key;
/*
not_null_example���̺��� first_name���� not null���������� �ٽ� ����
*/

alter table not_null_example add constraint student_id_key PRIMARY key (student_id);
/*
not_null_example���̺��� student_id���� student_id_key�̸����� �⺻Ű ���������� �߰�
*/

-- �ε���
/*
- postgresql�� �⺻Ű�� unique ���������� �߰��� ������ �������ǿ� ���Ե� ���� �ε����� �����ǰ�
  create index���� ������ �� �⺻������ �����Ǵ� �����̱⵵ ��
- �ε����� ���̺� �����Ϳ� ������ ����ǰ� ������ ������ �� �ڵ����� �׼����ǰ�
  ���� �߰��� ����, ������Ʈ �� �� ���� ������Ʈ �˴ϴ�.
- 
*/

-- * ����
/*
�˻� ���� �ӵ��� ���̱� ���� postgresql�� �⺻���� b-tree�ε����� ���
�� �����ʹ� 940374�� * 7���� ���� �ּҷ� �����Ǿ���.
*/

-- ** ������ �ҷ�����
CREATE TABLE new_york_address (
	longitude NUMERIC(9, 6),
	latitude NUMERIC(9, 6),
	street_number TEXT,
	street TEXT,
	unit TEXT,
	postcode TEXT,
	id integer CONSTRAINT new_york_key primary key 
);

COPY new_york_address
FROM 'D:\test\postgresql\practicalsql\practical-sql-main\Chapter_08\city_of_new_york.csv'
WITH (format CSV, header);

TABLE new_york_address;

-- * EXPLAIN�� ���� ���� ��
/*
�ε����� �߰��ϱ� ������ ������ �����ϱ� ���� postgresql������ �����ϴ� explain����� ���
analyzeŰ���带 �߰��ϸ� explain�� ������ �����ϰ� ���� �ð��� ǥ�� 

�ϵ���� ����, �ٸ� ���μ���, �ռ� ������ ����� ���� �޸� ���� �� �پ��� ������ ���� �ð��� ���ݾ� �ٸ���.
*/
EXPLAIN ANALYZE SELECT * FROM new_york_address WHERE street = 'BROADWAY';

EXPLAIN ANALYZE SELECT * FROM new_york_address WHERE street = '52 STREET';

EXPLAIN ANALYZE SELECT * FROM new_york_address WHERE street = 'ZWICKY AVENUE';

-- * �ε��� ����
CREATE INDEX street_idx ON new_york_address (street);
/*
new_york_address���̺��� street���� �������� �ε����� �����Ͽ����ϴ�.
����: CREATE INDEX [�ε�����] ON [���̺��(�÷���, �÷���, ...)]
*/

-- * �ε��� ���� �� ���� ��
EXPLAIN ANALYZE SELECT * FROM new_york_address WHERE street = 'BROADWAY';

EXPLAIN ANALYZE SELECT * FROM new_york_address WHERE street = '52 STREET';

EXPLAIN ANALYZE SELECT * FROM new_york_address WHERE street = 'ZWICKY AVENUE';

-- * �ε��� ����
DROP INDEX street_idx;
