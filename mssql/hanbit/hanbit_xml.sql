/*
mssql
날짜 23-07-30

xml
https://youtu.be/vKeG2oM8-94


*/
restore database sqldb from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL13.GYCOM\MSSQL\Backup\sqldb.bak' with replace;

-- 테이블 타입
use sqldb;
go
create table xmltbl(id int primary key identity, xmlcol xml);
insert into xmltbl values(N'일반 텍스트 입력');
insert into xmltbl values(N'<html> <body> <b> 일반 텍스트 입력 </b> </body> </html>');
insert into xmltbl values(N'<?xml version="1.0" ?>
                            <document>
							<userTbl nmae="이승기" birthyear="1987" addr="서울" />
							<userTbl nmae="김범수" birthyear="1979" addr="경북" />
							<userTbl nmae="김경호" birthyear="1971" addr="서울" />
							<userTbl nmae="조용필" birthyear="1950" addr="충남" />
							</document>');
select * from xmltbl;

-- 변수 타입
declare @x xml;
set @x = N'<usertbl name="김범수" birthyear="1979" addr="경북" />';
print cast(@x as nvarchar(max));

-- 형식화된 xml
select * from usertbl for xml raw, elements, xmlschema;
/*테이블 안의 데이터가 xml 형태로 출력*/

-- xml 스키마
create xml schema collection schema_usertbl as N'
<xsd:schema targetNamespace="urn:schemas-microsoft-com:sql:SqlRowSet2" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:sqltypes="http://schemas.microsoft.com/sqlserver/2004/sqltypes" elementFormDefault="qualified">
  <xsd:import namespace="http://schemas.microsoft.com/sqlserver/2004/sqltypes" schemaLocation="http://schemas.microsoft.com/sqlserver/2004/sqltypes/sqltypes.xsd" />
  <xsd:element name="row">
    <xsd:complexType>
      <xsd:sequence>
        <xsd:element name="userID">
          <xsd:simpleType>
            <xsd:restriction base="sqltypes:char" sqltypes:localeId="1042" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
              <xsd:maxLength value="8" />
            </xsd:restriction>
          </xsd:simpleType>
        </xsd:element>
        <xsd:element name="name">
          <xsd:simpleType>
            <xsd:restriction base="sqltypes:nvarchar" sqltypes:localeId="1042" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
              <xsd:maxLength value="10" />
            </xsd:restriction>
          </xsd:simpleType>
        </xsd:element>
        <xsd:element name="birthYear" type="sqltypes:int" />
        <xsd:element name="addr">
          <xsd:simpleType>
            <xsd:restriction base="sqltypes:nchar" sqltypes:localeId="1042" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
              <xsd:maxLength value="2" />
            </xsd:restriction>
          </xsd:simpleType>
        </xsd:element>
        <xsd:element name="mobile1" minOccurs="0">
          <xsd:simpleType>
            <xsd:restriction base="sqltypes:char" sqltypes:localeId="1042" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
              <xsd:maxLength value="3" />
            </xsd:restriction>
          </xsd:simpleType>
        </xsd:element>
        <xsd:element name="mobile2" minOccurs="0">
          <xsd:simpleType>
            <xsd:restriction base="sqltypes:char" sqltypes:localeId="1042" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
              <xsd:maxLength value="8" />
            </xsd:restriction>
          </xsd:simpleType>
        </xsd:element>
        <xsd:element name="height" type="sqltypes:smallint" minOccurs="0" />
        <xsd:element name="mDate" type="sqltypes:date" minOccurs="0" />
      </xsd:sequence>
    </xsd:complexType>
  </xsd:element>
</xsd:schema>
';
/*schema_usertbl는 usertbl테이블에서 저장되어 있던 이름, 주소 등으로만 데이터가 입력 가능하다.*/
go
create table txmltbl(id int identity, xmlcol xml (schema_usertbl));
go
insert into txmltbl values(N'일반 텍스트 입력');
/*xml 형태가 안 맞아서 오류메세지*/
insert into txmltbl values(N'
<row xmlns="urn:schemas-microsoft-com:sql:SqlRowSet2">
  <userID>EJW     </userID>
  <name>은지원</name>
  <birthYear>1978</birthYear>
  <addr>경북</addr>
  <mobile1>011</mobile1>
  <mobile2>88888888</mobile2>
  <height>174</height>
  <mDate>2014-03-03</mDate>
</row>
');
select * from txmltbl;
go
insert into txmltbl values(N'
<row xmlns="urn:schemas-microsoft-com:sql:SqlRowSet2">
  <userID>KKH     </userID>
  <birthYear>1971</birthYear>
  <name>김경호</name>
  <addr>전남</addr>
  <mobile1>019</mobile1>
  <mobile2>33333333</mobile2>
  <height>177</height>
  <mDate>2007-07-07</mDate>
</row>
');
/*열 순서가 바뀌어도 안된다 무조건 맞춰주어야함*/

-- 변수 선언(xml 스키마)
declare @tx xml(schema_usertbl)
set @tx = N'
<row xmlns="urn:schemas-microsoft-com:sql:SqlRowSet2">
  <userID>LSG     </userID>
  <name>이승기</name>
  <birthYear>1987</birthYear>
  <addr>서울</addr>
  <mobile1>011</mobile1>
  <mobile2>11111111</mobile2>
  <height>182</height>
  <mDate>2008-08-08</mDate>
</row>
'
insert into txmltbl values(@tx);
select * from txmltbl;

-- xml 스키마 조회
select * from sys.xml_schema_collections;

-- xml 스키마 내용 확인
select XML_SCHEMA_NAMESPACE(N'dbo', N'schema_usertbl');

-- xml 스키마 삭제
drop table txmltbl;
drop xml schema collection schema_usertbl;







