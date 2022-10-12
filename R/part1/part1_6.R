rm(list=ls())

# R 1파트 6.데이터 프레임.pdf
# 벡터에 이름 지정하기
v<-c(85,77,96)
v
names(v) # 이름을 확인시켜주는 함수
names(v) <- c('Kor','Eng','Math') # 이름을 지정해줌
names(v)
v
v['Kor']
v[c('Kor','Math')]
comment("v[-c('Kor','Math')]는 오류가 발생 => '-'는 문자에서는 사용불가")

# ifelse문
x <- 10
y <- 20
ifelse(x<y,x,y) # y가 크면 x, x가 크면 y반환
ifelse(x>y,x,y) # x가 크면 x, y가 크면 y반환

# 데이터 프레임
# 데프 만들어 보기
v1<-1:7
v2<-c('홍길동','전우치','주니온','아사달','아사녀','연오랑','세오녀')
v3<-factor(c('M','M','M','M','F','M','F'))
my_df<-data.frame(no=v1,name=v2,sex=v3)
View(my_df)

# 데프의 인덱싱과 슬라이싱
my_df[1:5,] # 1~5행
my_df[1:5,1:2] # 1~5행 1~2열
my_df[c(5,2),c(3,1)] # 보고싶은 열이나 행을 마음대로 정할 수도 있음
my_df[-2,-3] # 마이너스로 뺄수도 있음

# iris
iris_df <- iris
View(iris_df)
comment('원본을 안 건들이고 복사하여 사용하기위해')
str(iris_df)
class(iris_df)
dim(iris_df) # df차원
nrow(iris_df) # 행 수
ncol(iris_df) # 열 수
rownames(iris_df) # 행이름
colnames(iris_df) # 열이름

# $기호로 데프열을 벡터로 가지고옴
iris_df$Sepal.Length
iris_df[,1] # iris_df$Sepal.Length와 동일한 결과
iris_df[,'Sepal.Length'] # iris_df$Sepal.Length와 동일한 결과
comment('타입이 numeric으로 벡터')

iris_df['Sepal.Length'] # 열 자체를 뽑는거
comment('타입은 벡터가 아닌 데프임')

# 데프에서도 조건문을 이용한 필터링
summary(iris_df) # 각열의 통계값을 확인
summary(iris_df$Sepal.Length) # 하나의 열에서의 통계값 확인
iris_df[iris_df$Sepal.Length<5.1,]
comment('Sepal.Length가 Sepal.Length의 1분위수보다 작은 값')

attach(iris_df)
iris_df[Sepal.Length<5.1 & Species=='versicolor',]
comment('Sepal.Length가 Sepal.Length의 1분위수보다 작은 값이고 종류가 versicolor인 행들을 보기')

detach(iris_df)

# with로 행 추출해보기
with(iris_df,iris_df[Sepal.Length < 5.1 & Species=='versicolor',])
comment('df뒤에 $해서 열이름 적을 필요 없음')

# 새로운 열 만들기
iris_df$Sepal.Sum <- iris_df$Sepal.Length+iris_df$Sepal.Width
iris_df
comment('바로 View에 반영되어 보여줌')

attach(iris_df)
iris_df$Size <- ifelse(Sepal.Sum>=mean(Sepal.Sum),'Big','Small')
iris_df

detach(iris_df)
attach(iris_df)

# iris_df의 Size의 타입 바꾸기
str(Sepal.Length)
str(Size)
comment('새로만든 열은 attach()를 이용 할때는 다시 detach후 다시 attach을 해서 $을 사용할수 있음')
iris_df$Size<-as.factor(Size)

detach(iris_df)
attach(iris_df)

str(Size)

# iris_df의 Size의 빈도그래프 그려보기
table(iris_df$Size)
barplot(table(iris_df$Size))

detach(iris_df)

# state.x77데이터셋
# 미국 주의 데이터
# Population: 인구, Income: 소득, Illiteracy: 문맹률, Life Exp: 기대수명
# Murder: 인구 10만 명당 살인 및 과실치사율, HS Grad: 고등학교 졸업자 비율
# Frost: 수도나 대도시에서 최저기온이 영하(1931-1960) 이하인 평균 일수, Area: 면적
?state.x77 # 도움말
class(state.x77)
is.matrix(state.x77) # TRUE
is.array(state.x77) # TRUE
is.data.frame(state.x77) # FALSE
st_df <- as.data.frame(state.x77)
class(st_df)
str(st_df)
dim(st_df)
is.matrix(st_df) # FALSE
is.array(st_df) # FALSE
is.data.frame(st_df) # TRUE
View(st_df)

# 인구가 가장 많은 주의 이름은??
rownames(st_df[st_df$Population==max(st_df$Population),])

# 면적이 가장 큰 주의 이름은
rownames(st_df[st_df$Area==max(st_df$Area),])

# 고등졸업률과 소득의 산점도
plot(st_df$'HS Grad',st_df$Income)
cor(st_df$'HS Grad',st_df$Income)
comment('어느정도의 양의 상관관계를 보임')

# df를 csv파일로 저장
iris_df
write.csv(iris_df,file='iris_df.csv')
write.csv(iris_df,file='iris_df1.csv',row.names = F)
comment('row.names=옵션은 행의 이름을 없이 저장시켜주는 기능')

# 현재 있는 경로를 알려주는 함수
getwd()

# csv파일 읽기
iris_csv_df <- read.csv(file='iris_df.csv',header = T,stringsAsFactors = T)
View(iris_csv_df)
str(iris_csv_df)
comment('stringsAsFactors=옵션은 문자열인 열을 팩터타입으로 지정하고 출력해줌
        Size열과 Species열은 팩터형으로 지정
        그리고 X라는 열이 생겼는데 그이유는 write.csv할 때 row.names=T라고 했기때문임')

# readxl패키지 => csv파일을 읽어 들이는 패키지
# 성적표.xlsx라는 파일을 만들자!!!
library(readxl)
socre_df <- read_excel('성적표.xlsx',sheet=1)
str(socre_df)
class(socre_df)
comment('"tbl_df","tbl","data.frame"것을 가졌지만')

socre_df<-data.frame(socre_df)
str(socre_df)
class(socre_df)
comment('data.frame으로 "data.frame"만 출력되는 것을 확인')

View(socre_df)

# 평균열을 새로 만들기
# 기초적인 코딩
socre_df$평균 <- (socre_df$R+socre_df$파이썬+socre_df$머신러닝)/3

# apply함수를 이용한 새로운 열 만들기
apply(socre_df[,3:5],mean,MARGIN=1)
comment('MARGIN=1은 행별, MARGIN=2는 열별')
socre_df$avg<-apply(socre_df[,3:5],mean,MARGIN=1)

# 다시 파일로 저장
write.csv(file='socre.csv',socre_df,row.names = F)

round(apply(socre_df[,3:5],mean,MARGIN=1), 2)

# 연습문제 6-1
# state.x77데이터셋을 활용
# 1) 데이터셋을 st변수에 데프로 저장
st<-data.frame(state.x77)
str(st)
class(st)

View(st)
attach(st)

# 2) 변수와 관측치 수??
nrow(st) # 관측치 수
ncol(st) # 변수 수

# 3) 소득(Income)의 평균
mean(Income)

# 4) 인구(Population)가 10000보다 큰 주의 인구, 소득
st[Population>10000,c(1,2)]

# 5) Florida주의 인구와 소득??
st[rownames(st)=='Florida',1:2]

# 6) 인구수가 1000보다 작고 소득이 4436보다 작은 주의 모든 정보를 출력하라
st[Population<1000 & Income<4436,]

# 7) 문맹률(Illiteracy)의 평균 구하기
# 7-1) 소득이 5000보다 작은 주에 대해서
mean(st[Income<5000,'Illiteracy'])

# 7-2) 소득이 5000보다 큰 주에 대해서
mean(st[Income>5000,'Illiteracy'])

detach(st)

# 연습문제 6-2
# 6-1의 7)번 문제를 토대로 다음 진술이 타당하다고 할 수 있는가??
# 1) 소득이 높으면 문맹률이 낮아진다.
# 2) 소득이 낮으면 문맹률이 높아진다.
comment('2개의 변수로만 비교하여 확실하게 관계가 있다고 얘기 할 수는 없지만 소득이 5000초과일 때 는 0.9%이고 5000미만 일 때는 1.2%라는 것을 알 수 있으므로 다음 진술은 타당해 보임')

# 연습문제 6-3
# 1) scores.xlsx을 만드세요
# 2) scores.xlsx을 불러와 데프로 읽기
scores_df<-data.frame(read_excel('scores.xlsx'))
View(scores_df)
attach(scores_df)
comment('파일의 첫행에 열이름이 있는데 자동으로 열이름으로 지정됨')

# 3) 각 학생별 성적의 합계와 평균구하기
scores_df$Sum<-apply(scores_df[3:5],MARGIN = 1,FUN=sum)
scores_df$Mean<-apply(scores_df[3:5],MARGIN = 1,FUN=mean)
scores_df

# 4) scores_df을 result.csv파일을 만드세요
write.csv(scores_df,file='result.csv',row.names=F)

detach(scores_df)
