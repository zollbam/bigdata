/*
작성일: 230906
수정일: 
작성자: 조건영
작성 목적: cs의 테이블을 이용하여 앱DB 안의 테이블에 데이터를 삽입하기 위해
*/



-- 테스트 데이터 찾기
SELECT *
  FROM MEMBER
 WHERE mem_no > 1566372
 ORDER BY 1 DESC;



/*
1. 
 => mem_no가 4873 다음 갑자기 100001로 건너 뜀
 => mem_no가 100802 다음 갑자기 900000로 건너 뜀
2. lrea_office_info_pk가 1566372까지만 이관하자
 => 그 이후 데이터는 테스트(쓰레기) 데이터
3. 
*/

-- tb_com_user
/*cs테이블에서 161번으로 이관 하기 위한 쿼리*/
SELECT ROW_NUMBER() OVER (ORDER BY m.mem_no) "user_no_pk"
     , ROW_NUMBER() OVER (ORDER BY m.mem_no) "parnts_user_no_pk"
     , um.user_id "user_id"
     , m.owner_nm "user_nm"
     , '' "password"
     , m.hp "moblphon_no"
     , m.email "email"
     , '02' "user_se_code"
     , m.comp_reg_date "sbscrb_de"
     , '' "password_change_de"
     , '' "last_login_dt"
     , '' "last_login_ip"
     , '' "error_co"
     , '' "error_dt"
     , um.use_yn "use_at"
     , '' "regist_id"
     , m.wdate "regist_dt"
     , '' "updt_id"
     , '' "updt_dt"
     , '' "refresh_tkn_cn"
     , '' "soc_lgn_ty_cd"
     , '' "user_img_url"
     , m.company "lrea_office_nm"
     , m.mem_no "lrea_office_info_pk"
     , m.branch_code "lrea_brffc_cd"
  FROM [MEMBER] m
       INNER JOIN
       user_mst um
               ON m.mem_no = um.mem_no
 WHERE um.master_yn = 'Y' 
   AND owner_nm NOT LIKE '%지부'
   AND wdate IS NOT NULL
   AND um.user_no != 179951
   AND m.mem_no <= 1566372;

SELECT count(*)
  FROM [MEMBER] m
       INNER JOIN
       user_mst um
               ON m.mem_no = um.mem_no
 WHERE um.master_yn = 'Y' 
   AND owner_nm NOT LIKE '%지부'
   AND wdate IS NOT NULL
   AND um.user_no != 179951
   AND m.mem_no <= 1566372; -- 165555행



/*
1. 처음 총 178402행 있다.
2. wdate와 regdate 2개 열 모두 등록 일자라고 적혀 있다.
 => 값이 다른 행은 12개사 나오지만 전부 밀리초 차이
 => regdate에는 많은 null값이 존재
 => wdate에도 12개의 null이 존재
 => wdate와 regdate 모두가 null인데이터 존재 => 지부 
3. owner_nm열에 지부,관리자
 => 지부: 울산(900005), 전남(900011), 경남(900013), 서울남부(1110987), 대구(1110988), 충뷱(1110994), 세종(1110996)
 => 관리자: 무주(1535258), 장수(1535259), 임실(1535260), 순창(1535261), 부안군(1535262)
4. jumin_no
 => A, B, C, Z -> A가 좋은건지? Z가 졸은건지
               -> Z에는 지부가 포함
 => 701223-2358213(임정순) => 주민번호???
5. user_id가 null인 데이터는 없지만 공백인 데이터는 존재
 => 하나의 mem_id에 여러 보조 중개사까지 같이 사용 중
    master_yn로 대표자 한명만 추출하는 쿼리 만들 생각
6. 비밀번호 이관시 user_pw?? user_pw_enc??
 => user_pw_enc가 null인 경우는 없다.
7. um.user_no != 179951 한 이유
 => mem_no이 여러개 있던 데이터들은 대표사용자여부가 대부분 1개 였다.
    하지만 mem_no이 1080558인 대표사용자여부가 2개라서 하나 삭제
8. 
*/



-- txt파일 만들기
SELECT CAST(ROW_NUMBER() OVER (ORDER BY m.mem_no) AS nvarchar(max)) + '|||' + -- "user_no_pk"
       CAST(ROW_NUMBER() OVER (ORDER BY m.mem_no) AS nvarchar(max)) + '|||' + -- "parnts_user_no_pk"
       CASE WHEN um.user_id IS NULL OR um.user_id = '' THEN ''
            ELSE CAST(um.user_id AS nvarchar(max))
       END + '|||' + -- "user_id"
       CASE WHEN m.owner_nm IS NULL OR m.owner_nm = '' THEN ''
            ELSE CAST(m.owner_nm AS nvarchar(max))
       END + '|||' + -- "user_nm"
       '' + '|||' + -- "password"
       CASE WHEN m.hp IS NULL OR m.hp = '' THEN ''
            ELSE CAST(m.hp AS nvarchar(max))
       END + '|||' + -- "moblphon_no"
       CASE WHEN m.email IS NULL OR m.email = '' THEN ''
            ELSE CAST(m.email AS nvarchar(max))
       END + '|||' + -- "email"
       '02' + '|||' + -- "user_se_code"
       CASE WHEN m.comp_reg_date IS NULL OR m.comp_reg_date = '' THEN ''
            ELSE CAST(m.comp_reg_date AS nvarchar(max))
       END + '|||' + -- "sbscrb_de"
       '' + '|||' + -- "password_change_de"
       '' + '|||' + -- "last_login_dt"
       '' + '|||' + -- "last_login_ip"
       '' + '|||' + -- "error_co"
       '' + '|||' + -- "error_dt"
       CASE WHEN um.use_yn IS NULL OR um.use_yn = '' THEN ''
            ELSE CAST(um.use_yn AS nvarchar(max))
       END + '|||' + -- "use_at"
       '' + '|||' + -- "regist_id"
       CASE WHEN m.wdate IS NULL OR m.wdate = '' THEN ''
            ELSE CAST(m.wdate AS nvarchar(max))
       END + '|||' + -- "regist_dt"
       '' + '|||' + -- "updt_id"
       '' + '|||' + -- "updt_dt"
       '' + '|||' + -- "refresh_tkn_cn"
       '' + '|||' + -- "soc_lgn_ty_cd"
       '' + '|||' + -- "user_img_url"
       CASE WHEN m.company IS NULL OR m.company = '' THEN ''
            ELSE CAST(m.company AS nvarchar(max))
       END + '|||' + -- "lrea_office_nm"
       CASE WHEN m.mem_no IS NULL OR m.mem_no = '' THEN ''
            ELSE CAST(m.mem_no AS nvarchar(max))
       END  + '|||' + -- "lrea_office_info_pk"
       CASE WHEN m.branch_code IS NULL OR m.branch_code = '' THEN ''
            ELSE CAST(m.branch_code AS nvarchar(max))
       END -- "lrea_brffc_cd"
  FROM [MEMBER] m
       INNER JOIN
       user_mst um
               ON m.mem_no = um.mem_no
 WHERE um.master_yn = 'Y' 
   AND owner_nm NOT LIKE '%지부'
   AND wdate IS NOT NULL
   AND um.user_no != 179951
   AND m.mem_no <= 1566372;



/*
1. com_user_new.txt 라는 파일로 생성
2. user_lrea_update.txt 라는 파일로 생성
2. 총 행은 165607
3. 63021 행의 조정옥 공인중개사의 lrea_office_nm에 '||'값이 들어 가 있다.
 => 
*/
















