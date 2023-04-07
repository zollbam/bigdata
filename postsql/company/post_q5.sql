-- ���� �ŷ� ���
-- * ���1
-- ** tbl_avm001: AVM ����(AVM�����ü�)
SELECT mgmbldrgstpk, mgmupbldrgstpk, pnu, cas_grb_mdl_id
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';
/*
cas_grb_mdl_id�� �ϸ� avm_base_rtms_apt���� �������� ����� �ٸ��� ���´�.
*/

-- ** tbl_avm007: AVM ����(AVM�����ü�)
SELECT *
FROM tbl_avm007
WHERE pnu = (SELECT pnu
             FROM tbl_avm001
             WHERE mgmbldrgstpk = '11110-100181034')
ORDER BY 2 DESC; 

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
                        WHERE mgmbldrgstpk = '11110-100181034')
ORDER BY 2 DESC;
/*
cas_grb_mdl_id(����������� ID�� ã���� 29�� �ุ ���´�.
������ ���� ����� 21�� 10�� �����Ͱ� �ƴ� �ٸ� �����Ͱ� ������ �ȴ�.
*/

-- ** avm_base_rtms_apt(���� ���̺�)
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
/*
�ѱ������򰡻���ȸ ����Ʈ���� �� ��� �״�� ������ �������.
pnu�� ã���� 
*/

SELECT RANK() OVER (ORDER BY cdate desc) "����",
       cdate "�ŷ���" ,
       platplc || ' ' || beonji || ', ' || buildname "������ + �ǹ���",
       layer "��", 
       rtms_area || '��' "��������",
       to_char(deposit, 'FM9,999,999,999') || '(@' || to_char(round(deposit/rtms_area), 'FM99,999,999,999') || ')' "�ݾ�(@�ܰ�)"
FROM avm_base_rtms_apt
WHERE avm_base_rtms_apt_id IN (SELECT avm_base_rtms_apt_id
                               FROM tbl_avm007
                               WHERE cas_grb_mdl_id = (SELECT cas_grb_mdl_id
                                                       FROM tbl_avm001
                                                       WHERE mgmbldrgstpk = '11110-100181034'))
ORDER BY cdate DESC
LIMIT 3;
/*
cas_grb_mdl_id�� �����̽����� ��� ��������� ��� �ִ� ���� �ƴѰɷ� ���δ�.
cas_grb_mdl_id�� ã���� mgmbldrgstpk�� '11110-100181034'�� �����͸� ã�´�.
*/

-- * ���2
WITH buil_pnu AS (
	SELECT pnu
	FROM tbl_avm001 
	WHERE mgmbldrgstpk = '11110-100181034'
)
SELECT abra.platplc, abra.beonji, abra.buildname, abra.cdate, abra.layer, abra.deposit, abra.rtms_area
FROM avm_base_rtms_apt abra, buil_pnu bp
WHERE abra.sreg = substring(bp.pnu,1,5) AND 
      abra.seub = substring(bp.pnu,6,5) AND 
      abra.ssan = substring(bp.pnu,11,1) AND 
      abra.sbun1 = substring(bp.pnu,12,4) AND 
      abra.sbun2 = substring(bp.pnu,16,4)
ORDER BY cdate DESC;
/*
tbl_avm001���̺��� �ٷ� pnu�� ã�� ���ڿ��� ������ avm_base_rtms_apt���̺��� �ñ����ڵ带 �̿��� ������ �˻��ϱ�
pnu = sreg + seub + ssan + sbun1 + sbun2
*/
SELECT *
FROM avm_base_rtms_apt 
WHERE sreg = '11110' AND seub = '11500' AND ssan = '1' AND sbun1 = '0009' AND sbun2 = '0000';

-- ������ �ܰ� ����ġ
-- * tbl_avm001: AVM ����(AVM�����ü�)
SELECT cas_grb_mdl_id
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';
/*
mgmbldrgstpk = '11110-100181034'�� �ش��ϴ� cas_grb_mdl_id(����������� ID)�� ã�Ҵ�.
*/

-- * tbl_avm003: AVM ���� �����������
SELECT min_revise_unit_price "MIN", med_revise_unit_price "MED", avg_revise_unit_price "AVG", max_revise_unit_price "MAX"
FROM tbl_avm003
WHERE cas_grb_mdl_id = (SELECT cas_grb_mdl_id
                        FROM tbl_avm001
                        WHERE mgmbldrgstpk = '11110-100181034');
/*
ã�� ����������� ID�� ������ �ش� �ǹ��� �ŷ���� �����ܰ��� max/min/med/avg�� ã�´�.
*/

-- ������(��, ��, ��) ��� �ε��� ���ݼ���
-- * tbl_avm001: AVM ����(AVM�����ü�)
SELECT cas_grb_mdl_id
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';

-- * tbl_avm005: AVM ���� �����������
SELECT CASE WHEN rag_grp_div = '1' THEN '����' 
            WHEN rag_grp_div = '2' THEN '����'
            when rag_grp_div = '3' THEN '����' END "����", 
            range_med_unit_price * layerutility * rtms_area "���ε��� ���ݼ���", 
            layerutility "����ȿ��", 
            rtms_area "��������",
            '@' || to_char(range_max_unit_price, 'FM999,999,999') "�ܰ�_MAX",
            '@' || to_char(range_min_unit_price, 'FM999,999,999') "�ܰ�_MIN"
FROM tbl_avm005
WHERE cas_grb_mdl_id = (SELECT cas_grb_mdl_id
                        FROM tbl_avm001
                        WHERE mgmbldrgstpk = '11110-100181034') AND rag_grp_div <> '0';
/*
���ε��� ���ݼ��� = �ŷ�(��)�ݾ״ܰ�_MED X ����ȿ�� X ��󹰰� ��������
rag_grp_div�� '0'�� �Ŵ� ���� �ʿ� ��� ��
*/

-- �ŷ���ʺ񱳹��� ���� ��󹰰��� ���ذ���
-- * tbl_avm001: AVM ����(AVM�����ü�)
SELECT cas_grb_mdl_id
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';

-- * tbl_avm007: AVM ����������� �ŷ�(��)��� List
SELECT avm_base_rtms_apt_id, region_factor, apt_outer_point, apt_inner_point, ho_point, etc_point
FROM tbl_avm007
WHERE cas_grb_mdl_id = (SELECT cas_grb_mdl_id
                        FROM tbl_avm001
                        WHERE mgmbldrgstpk = '11110-100181034');

-- * avm_base_rtms_apt
-- ** inner join���
SELECT RANK() OVER (ORDER BY cdate DESC) "����", cdate "�ŷ�����", 
       platplc || ' ' || beonji || ', ' || buildname "������ + �ǹ���", 
       layer "��", rtms_area "��������", region_factor "��������", apt_outer_point "�����ܺο���", apt_inner_point "�������ο���", ho_point "ȣ������", etc_point "��Ÿ����",
       to_char(deposit, 'FM999,999,999,999') || '(@' || to_char(deposit/rtms_area, 'FM999,999,999,999') || ')' "�ݾ�(@�ܰ�)"
FROM avm_base_rtms_apt abra INNER JOIN (SELECT avm_base_rtms_apt_id, region_factor, apt_outer_point, apt_inner_point, ho_point, etc_point
                                        FROM tbl_avm007
                                        WHERE cas_grb_mdl_id = (SELECT cas_grb_mdl_id
                                                                FROM tbl_avm001
                                                                WHERE mgmbldrgstpk = '11110-100181034')) b
                            ON abra.avm_base_rtms_apt_id = b.avm_base_rtms_apt_id;


-- ** ���̺� 2���� ���� ó���ؼ� �����
SELECT RANK() OVER (ORDER BY cdate DESC) "����", cdate "�ŷ�����", 
       platplc || ' ' || beonji || ', ' || buildname "������ + �ǹ���", 
       layer "��", rtms_area "��������", region_factor "��������", apt_outer_point "�����ܺο���", apt_inner_point "�������ο���", ho_point "ȣ������", etc_point "��Ÿ����",
       to_char(deposit, 'FM999,999,999,999') || '(@' || to_char(deposit/rtms_area, 'FM999,999,999,999') || ')' "�ݾ�(@�ܰ�)"
FROM avm_base_rtms_apt abra, (SELECT avm_base_rtms_apt_id, region_factor, apt_outer_point, apt_inner_point, ho_point, etc_point
                              FROM tbl_avm007
                              WHERE cas_grb_mdl_id = (SELECT cas_grb_mdl_id
                                                      FROM tbl_avm001
                                                      WHERE mgmbldrgstpk = '11110-100181034')) b
WHERE abra.avm_base_rtms_apt_id = b.avm_base_rtms_apt_id;

-- ����ȭ�� ���(����Ư���� ���α�)
-- * tbl_avm001: AVM ����(AVM�����ü�)
SELECT mkt_pri_etm_mdl_id
FROM tbl_avm001
WHERE mgmbldrgstpk = '11110-100181034';

-- * tbl_avm012: AVM �ü��������� ������ ����ȭ��
SELECT CASE WHEN rag_grp_div = '0' THEN '��ü'
            WHEN rag_grp_div = '1' THEN '����'
            WHEN rag_grp_div = '2' THEN '����'
            WHEN rag_grp_div = '3' THEN '����' END "����",
            max_realrate "MAX ����ȭ��", 
            min_realrate "MIN ����ȭ��", 
            avg_realrate "AVG ����ȭ��", 
            med_realrate "MED ����ȭ��"
FROM tbl_avm012
WHERE mkt_pri_etm_mdl_id = (SELECT mkt_pri_etm_mdl_id
                            FROM tbl_avm001
                            WHERE mgmbldrgstpk = '11110-100181034');






-- �� ���̺� ���� �� �̸� ��
SELECT a.*, b.*
FROM (SELECT column_name
      FROM information_schema.COLUMNS
      WHERE table_name = 'avm_base_rtms_apt') a
INNER JOIN 
     (SELECT column_name
      FROM information_schema.COLUMNS
      WHERE table_name= 'tbl_avm010') b ON a.column_name = b.column_name;






























