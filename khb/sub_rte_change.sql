/*
작성일 : 23-08-03 
수정일 : 23-08-03
작성자 : 조건영
작성 목록 : 지역 지하철 명을 쉽게 알아보게 하기 위해 사용
*/

-- 노선명 : 역명
SELECT 
  CASE WHEN substring(rte_no, 2,2) = '11' THEN '수도권'
       WHEN substring(rte_no, 2,2) = '26' THEN '부산'
       WHEN substring(rte_no, 2,2) = '27' THEN '대구'
       WHEN substring(rte_no, 2,2) = '28' THEN '수도권'
       WHEN substring(rte_no, 2,2) = '29' THEN '광주'
       WHEN substring(rte_no, 2,2) = '30' THEN '대전'
       WHEN substring(rte_no, 2,2) = '41' THEN '수도권'
       WHEN substring(rte_no, 2,2) = '48' THEN '부산'
  END "region"
, rte_nm
, statn_nm
  FROM sc_khb_srv.tb_link_subway_statn_info
 ORDER BY 1,3;

-- 기존 노선 명
SELECT DISTINCT rte_nm
  FROM sc_khb_srv.tb_link_subway_statn_info
 ORDER BY 1;

/*
1호선
2호선
3호선
4호선
5호선
6호선
7호선
8호선
경강선
경부선
경원선
경의중앙선
경인선
경춘선
광주도시철도 1호선
김포골드라인
대구 도시철도 1호선
대구 도시철도 2호선
대구 도시철도 3호선
대전 도시철도 1호선
도시철도 7호선
동해선
부산 경량도시철도 4호선
부산 도시철도 1호선
부산 도시철도 2호선
부산 도시철도 3호선
부산김해경전철
분당선
서해선
수도권  도시철도 9호선
수도권 경량도시철도 신림선
수인선
신분당선
안산과천선
에버라인
우이신설선
의정부
인천국제공항선
인천지하철 1호선
인천지하철 2호선
일산선
자기부상철도
진접선
*/



-- 지하철 있는 지역 매칭
SELECT DISTINCT
  substring(rte_no, 2,2) "gugun_cd"
, CASE WHEN substring(rte_no, 2,2) = '11' THEN '수도권'
       WHEN substring(rte_no, 2,2) = '26' THEN '부산'
       WHEN substring(rte_no, 2,2) = '27' THEN '대구'
       WHEN substring(rte_no, 2,2) = '28' THEN '수도권'
       WHEN substring(rte_no, 2,2) = '29' THEN '광주'
       WHEN substring(rte_no, 2,2) = '30' THEN '대전'
       WHEN substring(rte_no, 2,2) = '41' THEN '수도권'
       WHEN substring(rte_no, 2,2) = '48' THEN '부산'
  END "region"
  FROM sc_khb_srv.tb_link_subway_statn_info
 ORDER BY 1;

SELECT DISTINCT
  substring(rte_no, 2,2) "gugun_cd"
, CASE WHEN substring(rte_no, 2,2) IN ('11', '28', '41') THEN '수도권'
       WHEN substring(rte_no, 2,2) IN ('26', '48') THEN '부산'
       WHEN substring(rte_no, 2,2) = '27' THEN '대구'
       WHEN substring(rte_no, 2,2) = '29' THEN '광주'
       WHEN substring(rte_no, 2,2) = '30' THEN '대전'
  END "region"
, rte_nm
  FROM sc_khb_srv.tb_link_subway_statn_info
 ORDER BY 2, 3;
 


-- 노선명 업데이트 쿼리
WITH rte_nm_up AS(
SELECT DISTINCT
--  substring(rte_no, 2,2) "gugun_cd"
  CASE WHEN substring(rte_no, 2,2) IN ('11', '28', '41') THEN '수도권'
       WHEN substring(rte_no, 2,2) IN ('26', '48') THEN '부산'
       WHEN substring(rte_no, 2,2) = '27' THEN '대구'
       WHEN substring(rte_no, 2,2) = '29' THEN '광주'
       WHEN substring(rte_no, 2,2) = '30' THEN '대전'
  END "region"
, rte_nm "before_rte_nm"
, CASE when rte_nm in ('1호선', '경부선', '경원선', '경인선') then '1호선'
       when rte_nm in ('2호선') then '2호선'
	   when rte_nm in ('3호선', '일산선') then '3호선'
	   when rte_nm in ('4호선', '안산과천선', '진접선') then '4호선'
	   when rte_nm in ('5호선') then '5호선'
	   when rte_nm in ('6호선') then '6호선'
	   when rte_nm in ('7호선', '도시철도 7호선') then '7호선'
	   when rte_nm in ('8호선') then '8호선'
	   when rte_nm in ('수도권  도시철도 9호선') then '9호선'
	   when rte_nm in ('인천국제공항선') then '공항'
	   when rte_nm in ('경의중앙선') then '경의중앙'
	   when rte_nm in ('경춘선') then '경춘'
	   when rte_nm in ('수인선', '분당선') then '수인분당'
	   when rte_nm in ('신분당선') then '신분당'
	   when rte_nm in ('경강선') then '경강'
	   when rte_nm in ('서해선') then '서해'
	   when rte_nm in ('인천지하철 1호선') then '인천1'
	   when rte_nm in ('인천지하철 2호선') then '인천2'
	   when rte_nm in ('에버라인') then '에버라인'
	   when rte_nm in ('의정부') then '의정부'
	   when rte_nm in ('우이신설선') then '우이신설'
	   when rte_nm in ('김포골드라인') then '김포골드'
	   when rte_nm in ('수도권 경량도시철도 신림선') then '신림'
	   when rte_nm in ('부산 도시철도 1호선') then '1호선'
	   when rte_nm in ('부산 도시철도 2호선') then '2호선'
	   when rte_nm in ('부산 도시철도 3호선') then '3호선'
	   when rte_nm in ('부산 경량도시철도 4호선') then '4호선'
	   when rte_nm in ('부산김해경전철') then '부산김해'
	   when rte_nm in ('동해선') then '동해'
	   when rte_nm in ('대구 도시철도 1호선') then '1호선'
	   when rte_nm in ('대구 도시철도 2호선') then '2호선'
	   when rte_nm in ('대구 도시철도 3호선') then '3호선'
	   when rte_nm in ('광주도시철도 1호선') then '1호선'
	   when rte_nm in ('대전 도시철도 1호선') then '1호선'
   END "after_rte_nm"
  FROM sc_khb_srv.tb_link_subway_statn_info
)
SELECT
  region
, before_rte_nm
, after_rte_nm
, 'update sc_khb_srv.tb_link_subway_statn_info set rte_nm = ''' + 
  after_rte_nm + ''' where rte_nm = ''' +
  before_rte_nm + ''';' "update_query"
  FROM rte_nm_up
 ORDER BY 1 DESC, 2;



update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '1호선' where rte_nm = '1호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '2호선' where rte_nm = '2호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '3호선' where rte_nm = '3호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '4호선' where rte_nm = '4호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '5호선' where rte_nm = '5호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '6호선' where rte_nm = '6호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '7호선' where rte_nm = '7호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '8호선' where rte_nm = '8호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '경강' where rte_nm = '경강선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '1호선' where rte_nm = '경부선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '1호선' where rte_nm = '경원선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '경의중앙' where rte_nm = '경의중앙선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '1호선' where rte_nm = '경인선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '경춘' where rte_nm = '경춘선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '김포골드' where rte_nm = '김포골드라인';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '7호선' where rte_nm = '도시철도 7호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '수인분당' where rte_nm = '분당선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '서해' where rte_nm = '서해선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '9호선' where rte_nm = '수도권  도시철도 9호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '신림' where rte_nm = '수도권 경량도시철도 신림선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '수인분당' where rte_nm = '수인선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '신분당' where rte_nm = '신분당선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '4호선' where rte_nm = '안산과천선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '에버라인' where rte_nm = '에버라인';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '우이신설' where rte_nm = '우이신설선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '의정부' where rte_nm = '의정부';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '공항' where rte_nm = '인천국제공항선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '인천1' where rte_nm = '인천지하철 1호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '인천2' where rte_nm = '인천지하철 2호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '3호선' where rte_nm = '일산선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '4호선' where rte_nm = '진접선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '동해' where rte_nm = '동해선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '4호선' where rte_nm = '부산 경량도시철도 4호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '1호선' where rte_nm = '부산 도시철도 1호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '2호선' where rte_nm = '부산 도시철도 2호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '3호선' where rte_nm = '부산 도시철도 3호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '부산김해' where rte_nm = '부산김해경전철';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '1호선' where rte_nm = '대전 도시철도 1호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '1호선' where rte_nm = '대구 도시철도 1호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '2호선' where rte_nm = '대구 도시철도 2호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '3호선' where rte_nm = '대구 도시철도 3호선';
update sc_khb_srv.tb_link_subway_statn_info set rte_nm = '1호선' where rte_nm = '광주도시철도 1호선';

SELECT * FROM sc_khb_srv.tb_link_subway_statn_info;



-- 자기부상철도 삭제
DELETE sc_khb_srv.tb_link_subway_statn_info WHERE rte_nm ='자기부상철도';

SELECT count(*) FROM sc_khb_srv.tb_link_subway_statn_info;









