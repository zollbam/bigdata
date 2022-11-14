import pandas as pd
import pymysql
from sql_setting import *

# SQL 연결 클래스
class Connect_DB:
    # 생성자
    # 객체를 만들면 객체 안에는 sql에서 불러온 DB들이 저장되어 있다. 
    def __init__(self, use_DB = True):
        if use_DB:
            self.action_dect_df=self.load_DB('action_dect_df')

    # DB에 있는 데이터 불러오기 함수
    # SQL에 있는 tableName을 입력하면 바로 파이썬으로 불러올수 있음
    def load_DB(self, tableName):
        conn = pymysql.connect(host=host_IP, user=user_ID, password=password, db=db_name, charset=charset, connect_timeout=1000) # mysql과 연결
        cur = conn.cursor() # Cursor객체를 가기고 옴
        sql = f"SELECT * FROM {tableName}"
        cur.execute(sql) # sql문장을 DB서버에 전송
        rows = cur.fetchall() # 서버로부터 가져온 데이터를 코드에서 활용 => fetchall(), fetchone(), fetchmany() 등을 이용함
        table = pd.DataFrame(rows, columns = [t[0] for t in cur.description]) 
        # description => 각 필드(칼럼) 특징 알아보기 (필드명,데이터형_코드, 표시크기, 내부크기, 정확도, 비율, nullable)
        cur.close() # 메시지 큐에서 연결된 리소스를 해제할 수 있도록 커서 닫기
        conn.close() # sql연결 닫기
        return table

    # SQL에 저장된 테이블들의 이름을 볼 수 있음
    def get_table_names(self):
        conn = pymysql.connect(host=host_IP, user =user_ID, password =password, db =db_name, charset =charset)
        cur = conn.cursor()
        cur.execute(f'SHOW TABLES IN {db_name}') # 데이터베이스 안에 있는 테이블 이름을 보여주는 쿼리문
        rows = cur.fetchall()
        tableList = [tb[0] for tb in rows]
        cur.close()
        conn.close()
        return tableList
