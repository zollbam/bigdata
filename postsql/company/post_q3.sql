-- ��������
SELECT mgmbldrgstpk, mgmbldrgstpk_pyo, private_area ||'��' "��������", flrno "�ش� ��"
FROM avm_bbook_share_oneself_area
WHERE mgmbldrgstpk = '11110-100181034';
/*
- mgmbldrgstpk�� mgmbldrgstpk_pyo�� �ٸ��� ���ϱ� ���� �̾� ���ҽ��ϴ�.
- avm_bbook_check_elevator���� mgmbldrgstpk_pyo�� �ʿ��ؼ� �̾ƺ��ҽ��ϴ�.
- ���� '��' + ���ڸ� �̿��ؼ� Ư�����ڸ� ���� �־����ϴ�.
*/

-- �ֱ���
SELECT strctcdnm "�ֱ���"
FROM avm_bbook_check_elevator
WHERE mgmbldrgstpk_pyo = '11110-100180945';
/*
- avm_bbook_share_oneself_area���̺��� ���๰������ 11110-100181034�� mgmbldrgstpk_pyo�� 11110-100180945�̴�.
- mgmbldrgstpk_pyo�� not null�̶� �ߺ��Ǵ� ���� �����Ƿ� 11110-100180945�� �� �� �ุ ������ �ȴ�.
*/

-- ��������
SELECT to_char(to_date(useaprday, 'YYYYMMDD'), 'YYYY.MM.DD') "��������"
FROM avm_bbook_useaprday
WHERE mgmbldrgstpk_pyo = '11110-100180945';
/*
- to_date�� �������� ��¥������ �ٲپ� �ִ� �Լ��� �ش� ���� �Էµ� ������ ������� ���¸� �ι�° �μ��� ����� ��¥������ ������ �����ϴ�.
   => ��, useaprday���� yyyyddmm������ �ԷµǾ� �־ to_date�� �ι�° �μ��� 'YYYYMMDD'�� �������ϴ�.
- to_char�� �̿��ؼ� ��¥�� ���¸� 'YYYYMMDD'���� ����� ���̿� ��(.)�� �ִ´�.
*/

-- �� ����(����/����)
SELECT grndflrcnt || ' / ' || ugrndflrcnt "������(����/����)"
FROM avm_bbook_pyo_count
WHERE mgmbldrgstpk = '11110-100181034';
/*
- avm_bbook_pyo_count���̺����� mgmbldrgstpk_pyo�� not null�� �ƴ϶�
   mgmbldrgstpk_pyo = '11110-100180945'�� ������ ������ 102���� ���� ������ �˴ϴ�. 
   �׷��� mgmbldrgstpk�� ������ ��� �����Ͽ����ϴ�.
*/

-- �����
SELECT mgmbldrgstpk_pyo,hhldcnt "�����"
FROM avm_bbook_hhldcnt
WHERE mgmbldrgstpk_pyo = '11110-100180945';
/*
- avm_bbook_hhldcnt���̺����� mgmbldrgstpk_pyo�� not null�̶� where���� mgmbldrgstpk_pyo���� ���
*/

-- ��������
-- * ���̺��� ���� ��ü ���̺� ���(����� �Է� X)
SELECT tbl_mgm."��������", abce.strctcdnm "�ֱ���", to_char(to_date(abu.useaprday, 'YYYYMMDD'), 'YYYY.MM.DD') "��������", tbl_mgm."������(����/����)", tbl_mgm."�ش� ��", abh.hhldcnt "�����"
FROM (SELECT absoa.mgmbldrgstpk_pyo, absoa.private_area ||'��' "��������", flrno "�ش� ��", abpc.grndflrcnt || ' / ' || ugrndflrcnt "������(����/����)"
			FROM avm_bbook_share_oneself_area absoa, avm_bbook_pyo_count abpc
			WHERE absoa.mgmbldrgstpk = '11110-100181034' AND abpc.mgmbldrgstpk = '11110-100181034') tbl_mgm,
		    avm_bbook_check_elevator abce,
		    avm_bbook_useaprday abu,
		    avm_bbook_hhldcnt abh
WHERE abce.mgmbldrgstpk_pyo = tbl_mgm.mgmbldrgstpk_pyo AND 
              abu.mgmbldrgstpk_pyo = tbl_mgm.mgmbldrgstpk_pyo AND
              abh.mgmbldrgstpk_pyo = tbl_mgm.mgmbldrgstpk_pyo;
/*
- �켱 mgmbldrgstpk���� �ʿ��� ���̺��� avm_bbook_share_oneself_area�� avm_bbook_pyo_count�̹Ƿ� �� 2���� ���̺��� ������
    mgmbldrgstpk_pyo�� ��������, �ش���, �������� �����͸� �����߽��ϴ�. => mgmbldrgstpk�� 11110-100181034�� 1�� 4���� tbl_mgm���̺��� �� �� �ֽ��ϴ�.
- �� ���� ���� ���̺�� tbl_mgm���̺��� mgmbldrgstpk_pyo���� �̿��� �ֱ���, ��������, ������� ���� �����Ͽ� ���๰������ '11110-100181034'�� �ǹ��� ���� ������ �����Ѵ�. 
*/

-- * ���̺��� ���� ��ü ���̺� ���(����� �Է� O)
SELECT tbl_mgm."��������", abce.strctcdnm "�ֱ���", to_char(to_date(abu.useaprday, 'YYYYMMDD'), 'YYYY.MM.DD') "��������", tbl_mgm."������(����/����)", tbl_mgm."�ش� ��", abh.hhldcnt "�����"
FROM (SELECT absoa.mgmbldrgstpk_pyo, absoa.private_area ||'��' "��������", flrno "�ش� ��", abpc.grndflrcnt || ' / ' || ugrndflrcnt "������(����/����)"
			FROM avm_bbook_share_oneself_area absoa, avm_bbook_pyo_count abpc
			WHERE absoa.mgmbldrgstpk = '${user_mgm}' AND abpc.mgmbldrgstpk = '${user_mgm}') tbl_mgm,
		    avm_bbook_check_elevator abce,
		    avm_bbook_useaprday abu,
		    avm_bbook_hhldcnt abh
WHERE abce.mgmbldrgstpk_pyo = tbl_mgm.mgmbldrgstpk_pyo AND 
              abu.mgmbldrgstpk_pyo = tbl_mgm.mgmbldrgstpk_pyo AND
              abh.mgmbldrgstpk_pyo = tbl_mgm.mgmbldrgstpk_pyo;

-- * with��(����� �Է� X)
WITH mgmpyo_to_mgm AS (
			SELECT mgmbldrgstpk, mgmbldrgstpk_pyo, private_area, flrno FROM avm_bbook_share_oneself_area WHERE mgmbldrgstpk = '11110-100181034'
), buil_info_mgm AS (
			SELECT mtm.private_area ||'��' "��������", mtm.flrno "�ش� ��", abpc.grndflrcnt || ' / ' || ugrndflrcnt "������(����/����)"
			FROM mgmpyo_to_mgm mtm,  avm_bbook_pyo_count abpc
			WHERE abpc.mgmbldrgstpk = mtm.mgmbldrgstpk
), buil_info_mgmpyo AS (
			SELECT abce.strctcdnm "�ֱ���", to_char(to_date(abu.useaprday, 'YYYYMMDD'), 'YYYY.MM.DD') "��������", abh.hhldcnt "�����"
			FROM mgmpyo_to_mgm mtm,  avm_bbook_check_elevator abce, avm_bbook_useaprday abu, avm_bbook_hhldcnt abh
			WHERE abce.mgmbldrgstpk_pyo = mtm.mgmbldrgstpk_pyo AND 
                          abu.mgmbldrgstpk_pyo = mtm.mgmbldrgstpk_pyo AND
                          abh.mgmbldrgstpk_pyo = mtm.mgmbldrgstpk_pyo
)
SELECT bim."��������", bimp."�ֱ���", bimp."��������", bim."������(����/����)", bim."�ش� ��", bimp."�����"
FROM buil_info_mgm bim, buil_info_mgmpyo bimp;

/*
- mgmpyo_to_mgm���̺��� mgmbldrgstpk�� mgmbldrgstpk_pyo�� �ٲپ��ְ� "��������"�� "�ش� ��"�� ���� ������ �����ߴ�.
- buil_info_mgm���̺��� mgmpyo_to_mgm���� ���������� �ش��� ���� �����ϰ� avm_bbook_pyo_count���� �ش� ���๰���忡 �´� �������� ����
- buil_info_mgmpyo���̺��� mgmbldrgstpk_pyo�� ���ǿ� �´� ������ �߿��� "�ֱ���", "��������", "�����"
*/

-- * with��(����� �Է� O)
WITH mgmpyo_to_mgm AS (
			SELECT mgmbldrgstpk, mgmbldrgstpk_pyo, private_area, flrno FROM avm_bbook_share_oneself_area WHERE mgmbldrgstpk = '${user_mgm}'
), buil_info_mgm AS (
			SELECT mtm.private_area ||'��' "��������", mtm.flrno "�ش� ��", abpc.grndflrcnt || ' / ' || ugrndflrcnt "������(����/����)"
			FROM mgmpyo_to_mgm mtm,  avm_bbook_pyo_count abpc
			WHERE abpc.mgmbldrgstpk = mtm.mgmbldrgstpk
), buil_info_mgmpyo AS (
			SELECT abce.strctcdnm "�ֱ���", to_char(to_date(abu.useaprday, 'YYYYMMDD'), 'YYYY.MM.DD') "��������", abh.hhldcnt "�����"
			FROM mgmpyo_to_mgm mtm,  avm_bbook_check_elevator abce, avm_bbook_useaprday abu, avm_bbook_hhldcnt abh
			WHERE abce.mgmbldrgstpk_pyo = mtm.mgmbldrgstpk_pyo AND 
                          abu.mgmbldrgstpk_pyo = mtm.mgmbldrgstpk_pyo AND
                          abh.mgmbldrgstpk_pyo = mtm.mgmbldrgstpk_pyo
)
SELECT bim."��������", bimp."�ֱ���", bimp."��������", bim."������(����/����)", bim."�ش� ��", bimp."�����"
FROM buil_info_mgm bim, buil_info_mgmpyo bimp;

-- * with�� + ���� �� ���̺� full join(����� �Է� O)
WITH mgmpyo_to_mgm AS (
			SELECT mgmbldrgstpk, mgmbldrgstpk_pyo, private_area, flrno FROM avm_bbook_share_oneself_area WHERE mgmbldrgstpk = '11530-100233831'
), buil_info_mgm AS (
			SELECT mtm.private_area ||'��' "��������", mtm.flrno "�ش� ��", abpc.grndflrcnt || ' / ' || ugrndflrcnt "������(����/����)"
			FROM mgmpyo_to_mgm mtm,  avm_bbook_pyo_count abpc
			WHERE abpc.mgmbldrgstpk = mtm.mgmbldrgstpk
), buil_info_mgmpyo AS (
			SELECT abce.strctcdnm "�ֱ���", to_char(to_date(abu.useaprday, 'YYYYMMDD'), 'YYYY.MM.DD') "��������", abh.hhldcnt "�����"
			FROM mgmpyo_to_mgm mtm,
			            avm_bbook_check_elevator abce FULL join avm_bbook_useaprday abu ON abce.mgmbldrgstpk_pyo = abu.mgmbldrgstpk_pyo
            			                                                          FULL JOIN avm_bbook_hhldcnt abh ON abu.mgmbldrgstpk_pyo = abh.mgmbldrgstpk_pyo
			WHERE abh.mgmbldrgstpk_pyo = mtm.mgmbldrgstpk_pyo
)
SELECT bim."��������", bimp."�ֱ���", bimp."��������", bim."������(����/����)", bim."�ش� ��", bimp."�����"
FROM buil_info_mgm bim, buil_info_mgmpyo bimp;







