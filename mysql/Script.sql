# �����ͺ��̽� Ȯ��
SHOW DATABASES;
/*
������ �����ߴ� �ſ� ������ �ִ��� ��� ������
 */

# �������� ���� Ȯ��
SHOW GLOBAL variables LIKE 'c%';

# �����ͺ��̽� ����
CREATE DATABASE gydb;
SHOW DATABASES;

# �����ͺ��̽� ����
DROP DATABASE gytest;
SHOW DATABASES;

# ���� root����� ��ȸ
USE mysql;
SELECT USER, host FROM USER;

# ����� �߰�
CREATE USER 'user01'@'%' identified BY '1234'; 
/*
�����̸��� user01�̰� ����� 1234
 */

# �ܺ� ���� ���
GRANT ALL PRIVILEGES ON *.* TO 'user01'@'%';
GRANT GRANT OPTION ON *.* TO 'user01'@'%';
flush PRIVILEGES;
/*
privileges�� Ư��, Ư�� ���� �ǹ̸� ���� �ܾ�
flush�� �����ϴ�, ���ξľ���, ��ġ��, ȫ����
���� 2���� ��� ip�ּҿ��� ���� �����ϵ��� ����
������ ������ ��������� ������� ��
 */
























