-- Active: 1679962641651@@127.0.0.1@5432@gydb
-- 개념
/*
- postgresql은 대소문자 관계없이 식별자를 소문자로 취급합니다.
  => create table Customer이나 create table customer을 동일하게 봐 둘 중 하나라도 테이블이 생성되면
     이미 있는 릴레이션이라며 오류가 나타나게 됩니다.
  => 이를 해결하기 위해 인용식별자를 사용하여 2개의 테이블명을 구분합니다.
     create table "Customer"과 create table "customer"은 다른 테이블이다.
     불러올 때도 select * from "Customer"로 다르다는 것을 알 수 있게 인용식별자를 사용
- 예약어를 식별자로 사용할 수 있습니다.
- 이런식으로 예약어나 인용부호로 만들어지는 이름들은 오류가 발생할 가능성이 높기 때문에 사용하는 것은 비추천한다.
  => 스네이크 케이스를 사용
  => 이름을 이해하기 쉽게 짓고 암호 같은 약어 사용을 지양하세요
  => 테이블 이름은 복수형 이름을 사용하세요
  => 테이블 이름으로는 복수형이름을 사용하세요
  => 길이를 신경쓰세요 (sql은 128자, postgresql은 63자, oracle은 30자)
  => 테이블을 복사할 때 나중에 관리하는데 도움이 되는 이름을 사용하세요
- 제약조건을 선언하는 것에는 테이블 제약조건과 열 제약조건 2가지의 방법이 있습니다.

*/

-- 단일열 자연키를 기본키로 설정
create table natural_key_examples (
    license_id text constraint license_key PRIMARY key,
    first_name text,
    last_name text
);
/*
license_id text PRIMARY key로 단어 몇개를 생략해도 된다.
*/

insert into natural_key_examples VALUES
        ('T22990','Gem','Godfrey');

insert into natural_key_examples VALUES
        ('T22990','John','Mitchell');
/*
license_id가 기본키인데 테이블에 T22990가 입력되어 있어서 또 T22990를 입력 하려고 하니
고유 제약 조건 위반이라는 메세지가 나오면서 오류가 발생하게 됩니다.
*/

-- 복합 기본키 생성
create table natural_key_composite_example (
    student_id text,
    school_day date,
    present boolean,
    constraint student_key PRIMARY key (student_id, school_day)
);
/*
복합키로 설정할 때는 괄호로 묶어야 한다.
*/

insert into natural_key_composite_example VALUES
        (775, '2022-01-22', 'Y');

insert into natural_key_composite_example VALUES
        (775, '2022-01-23', 'Y');
/*
student_id는 동일하지만 school_day가 달라서 오류없이 삽입이 가능
*/

insert into natural_key_composite_example VALUES
        (775, '2022-01-23', 'N');
/*
student_id와 school_day가 모두 동일해서 오류가 나온다.
*/

-- 자동 증가 인조 키 생성
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
자동증가 이므로 order_number은 값을 입력하지 않아도 알아서 값이 삽입이 된다.
*/

-- * 수동 삽입과 자동 증가 값 재설정
insert into surrogate_key_example values
            (4, 'Chicken Choop', '2021-09-03 10:33-07');
/*
수동삽입 할 수 없다는 의미인 오류가 나온다.
*/

insert into surrogate_key_example overriding system value values 
            (4, 'Chicken Choop', '2021-09-03 10:33-07');
/*
수동삽입을 위해서는 overriding system value옵션을 values앞에 입력해주어야 한다.
*/

insert into surrogate_key_example(product_name, order_time) VALUES
        ('Aloe Plant', '2020-03-15 10:09-07');
/*
order_number의 값이 자동으로 5로 되어 값이 삽입되는줄 알았지만
수동입력을 하면 컴퓨터는 인식을 하지 못해 계속해서 4인 상태에서
값을 삽입하려고 한다. 그래서 테이블 안에 4의 값이 있으므로 오류가 발생
*/

alter table surrogate_key_example alter COLUMN order_number restart with 5;
/*
자동 증가 시작을 다시 5부터 설정을 했다.
*/

-- * 예제) 2번 행을 지우고 다시 삽입하기
delete from surrogate_key_example where order_number=2;

table surrogate_key_example;

insert into surrogate_key_example(product_name, order_time) VALUES
        ('Cho Gun', '2023-04-10 12:56-07');
/*
이상태로 삽입하면 order_number가 5로 입력이 된다.
*/

alter table surrogate_key_example alter order_number restart with 2;

insert into surrogate_key_example(product_name, order_time) VALUES
        ('Kim hack', '2023-04-10 13:00-07');
/*
재설정을 2로 하여 2의 데이터가 레코드로 추가는 되지만 정렬은 되지 않고 제일 마지막 행에 추가가 된다.
*/

insert into surrogate_key_example(product_name, order_time) VALUES
        ('Lee Bab', '2023-04-10 13:02-07');
/*
3부터 값이 입력이 되므로 값을 삽입하려면 오류가 나온다.
*/

alter table surrogate_key_example alter order_number restart with 6;

insert into surrogate_key_example(product_name, order_time) VALUES
        ('Park Seri', '2023-04-10 13:03-07');

-- 외래키
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
licenses테이블의 license_id에는 T000001값이 없으므로 데이터가 입력되지 않고 오류가 나오게 된다.
*/

-- cascade
/*
기본키가 있는 테이블에서 행을 삭제하려고 하면 외래키랑 묶여 있다고 삭제 할 수 없다는 메세지가
나오는 경우가 있다. 이 경우 외래키의 해당 데이터를 삭제하고 기본키가 있는 데이터를 삭제를 하는데
이를 자동으로 해주는 키워드가 cascade이다.
*/

-- * 테이블 삭제
drop table registrations;

-- * 테이블 생성
create table registrations (
    registration_id text,
    registration_date timestamp with time zone,
    license_id text references licenses(license_id) on delete cascade,
    constraint registration_key PRIMARY key (registration_id, license_id)
);
/*
on delete cascade로 기본키 데이터 삭제시 외래키 데이터 자동 삭제
*/

-- * licenses에 데이터 삽입
insert into licenses VALUES
    ('T229902', 'Cho', 'Gun');

-- * registrations에 데이터 삽입
insert into registrations VALUES
    ('A301551', '2020-12-10', 'T229902');

-- * 기본키 테이블 데이터 삭제
delete from licenses where license_id='T229901';
/*
기본테이블/외래테아블 모두에서 license_id가 T229901인 행이 모두 삭제
*/

-- * 테이블 확인
table licenses;
table registrations;

-- check
/*
check제약조건은 지정된 조건이 예상 기준을 충족하는지 여부를 평가합니다.
기준이 충족되지 않으면 DB에서 오류를 반환합니다.

열 제약조건: [열이름] [데이터 타입] check (조건식)
테이블 제약조건: 모든 열 정의 후, constraint constraint_name check (조건식)

and나 or을 사용하여 하나의 check문에 여러개의 조건을 넣을 수도 있다.

(열이름1 < 열이름2) 형태로 하나의 열이 하나의 열보다 작아야지 입력되는 데이터들도 있다.
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
중복되는 데이터 없이 무조건 하나의 열에는 하나의 값만 가지게 된다.
기본키와 비슷하지만 다른점은 null값이 들어 갈 수 있다는 점이다. => null은 여러 개 가능
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
첫번쩨 입력한 데이터의 email데이터와 중복이 되어 오류 발생
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
first_name나 last_name에는 null값이 없으므로 오류가 발생하지 않습니다.
*/

insert into not_null_example(first_name, last_name) values
            (null, 'Hack');
/*
first_name에는 null을 입력할 수 없는데 입력이 되어 오류가 발생
*/

-- 제약조건 삭제 및 수정/추가
/*
삭제 문법: alter table [테이블명] drop constraint [제약조건명];

열 제약조건 삭제 문법 : alter table [테이블명] alter column [컬럼명] drop [제약조건 키워드];

열 제약조건 수정 문법 : alter table [테이블명] add column [컬럼명] drop [제약조건 키워드];
*/

alter table not_null_example alter column first_name drop not null;
/*
not_null_example테이블의 first_name열의 not null제약조건을 삭제
*/

alter table not_null_example alter column first_name set not null;
/*
not_null_example테이블의 first_name열의 not null제약조건을 다시 설정
*/

alter table not_null_example drop constraint student_id_key;
/*
not_null_example테이블의 first_name열의 not null제약조건을 다시 설정
*/

alter table not_null_example add constraint student_id_key PRIMARY key (student_id);
/*
not_null_example테이블의 student_id열에 student_id_key이름으로 기본키 제약조건을 추가
*/




















