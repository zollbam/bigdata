-- ���� �ŷ� ���
-- * tbl_avm001: AVM ����(AVM�����ü�)
SELECT mgmbldrgstpk, mgmupbldrgstpk, pnu, cas_grb_mdl_id
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';
/*
cas_grb_mdl_id�� �ϸ� avm_base_rtms_apt���� �������� ����� �ٸ��� ���´�.
*/

-- * tbl_avm007: AVM ����(AVM�����ü�)
SELECT *
FROM tbl_avm007
WHERE pnu = (SELECT pnu
             FROM tbl_avm001
             WHERE mgmbldrgstpk = '11110-100181034'); 

/*
�� ���� 15344
���� �����͵��� �����̽����� ���� ����������� �ŷ���ʷ� avm_base_rtms_apt_id�� �ߺ��� ����.
*/

SELECT avm_base_rtms_apt_id, count(*)
FROM tbl_avm007
GROUP BY avm_base_rtms_apt_id
ORDER BY count(*) desc;
/*
������ ��ü �����ͷ� ���� �ϳ��� avm_base_rtms_apt_id�� �ߺ��Ǿ� �ִ� ����� �ִ� ���� �� �� �ִ�.
*/

SELECT *
FROM tbl_avm007
WHERE cas_grb_mdl_id = (SELECT cas_grb_mdl_id
                        FROM tbl_avm001
                        WHERE mgmbldrgstpk = '11110-100181034'); 
/*
cas_grb_mdl_id(����������� ID�� ã���� 29�� �ุ ���´�.
������ ���� ����� 21�� 10�� �����Ͱ� �ƴ� �ٸ� �����Ͱ� ������ �ȴ�.
*/

-- * avm_base_rtms_apt(���� ���̺�)
SELECT RANK() OVER (ORDER BY cdate desc) "����",
       cdate "�ŷ���" ,
       platplc || ' ' || beonji || ', ' || buildname "������ + �ǹ���",
       layer "��", 
       rtms_area || '��' "��������",
       to_char(deposit, 'FM9,999,999,999') || '(@' || to_char(round(deposit/rtms_area), 'FM99,999,999,999') || ')' "�ݾ�(@�ܰ�)"
FROM avm_base_rtms_apt
WHERE avm_base_rtms_apt_id IN (SELECT avm_base_rtms_apt_id
                               FROM tbl_avm007
                               WHERE pnu = (SELECT pnu
                                            FROM tbl_avm001
                                            WHERE mgmbldrgstpk = '11110-100181034'))
ORDER BY cdate DESC
LIMIT 3;




SELECT a.*, b.*
FROM (SELECT column_name
FROM information_schema.COLUMNS
WHERE table_name = 'tbl_avm001') a
INNER JOIN 
(SELECT column_name
FROM information_schema.COLUMNS
WHERE table_name= 'avm_base_rtms_apt') b ON a.column_name = b.column_name;








































