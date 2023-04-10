-- ��������
/*
albums: ��ũ ��ü �뷡 ������ ���� ���� 
create table albums(
	album_id bigint generated always as identity,
	catalog_code text,
	title text,
	artist text,
	release_date date,
	genre text,
	description text
);

songs: �ٹ��� �� Ʈ��
create table songs (
	song_id bigint generated always as identity,
	title text,
	composers text,
	album_id bigint
);
*/

-- * 1��
/*
�⺻ �� �ܷ� Ű �� �� ���̺� ���� �߰� ���� ������ �����ϵ��� create table���� �����ϼ���. 
*/
CREATE TABLE albums(
	album_id bigint generated ALWAYS as identity,
	catalog_code TEXT NOT NULL,
	title TEXT NOT NULL,
	artist TEXT NOT NULL,
	release_date date,
	genre TEXT,
	description TEXT,
	CONSTRAINT album_id_key PRIMARY KEY (album_id) -- album_id�� �⺻Ű�� ����
);

create table songs (
	song_id bigint generated always as IDENTITY,
	title TEXT NOT NULL,
	composers TEXT NOT NULL,
	album_id bigint references albums(album_id)
);

-- * 2��
/*
albums���̺� �ȿ� �ִ� ���� �� �ڿ� Ű�� ����� ���� ���� �ֳ���??

title�� artist�� ���� �⺻Ű�� �����ҷ��� �Ѵ�.
�ϳ��� ������ ������ �̸��� ���� �뷡�� 2�� �̻� �߸������� ���� �Ŷ� �����Ͽ����ϴ�.
*/

-- * 3��
/*
���� ������ ���̱� ���� ������ ���� �ֳ���??

�⺻Ű���� �ε����� ���������� �ܷ�Ű���� �ε����� �������� �ʴ´�.
�׷��Ƿ� songs�� album_id�� �ε����� ��ų� title�� �˸�
�뷡�� ���� ������ ���� ���� �� �ֱ� ������ title�� �ε�����
���� ���� ���Դϴ�.
*/






























