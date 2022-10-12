rm(list=ls())

# R 파트1 8.데이터 전처리2.pdf
# subset()
st_df <- data.frame(state.x77)

st_df[st_df$Population==max(st_df$Population),c(3,6)]
comment('밑에 코드와 동일한 결과가 나옴')
subset(st_df,subset =st_df$Population==max(st_df$Population),select = c(3,6))
comment('위의 코드와 동일한 결과가 나옴')

iris[,-5]
subset(iris,select = -5)
comment('인덱스가 좋을지 subset이 좋을지는 그때 그때 상황을 보면서하자')

# iris데이터로 subset해보기
subset(iris,subset=Species=='setosa')
comment('품종이 setosa인 것만 추출')

subset(iris,select=c(1,2,5))
comment('Sepal.Length,Sepal.Width,Species열 추출')

subset(iris,select=c(5,1,2))
comment('열순서 바꾸어서 출력해보기')

subset(iris,subset=Sepal.Length>7.5 & Sepal.Width>3.0,select=c(1,2,5))
comment('여러 조건을 두고 특정 열만 추출')

# split()
# iris셋을 Species열 기준으로 여러 개 분할
split(iris,f=iris$Species)

names(iris)
commet('데프에서 names()를 쓰면 열이름이 출력')

length(iris)
comment('열의 길이 출력')

iris_sp<-split(iris,f=iris$Species)
length(iris_sp) # 분할된 범주형 값 개수를 출력
names(iris_sp)
class(sp)
comment('종류로 분할한 데이터셋을 names쓰면 분할 기준이 된 열의 범주형 값이 출력')

summary(iris_sp)
comment('length는 열의 길이
        class는 타입
        Mode는 각 분할된 모드를 출력')

iris_sp$setosa
iris_sp$versicolor
iris_sp$virginica
comment('리스트이므로 $을 사용하여 보고 싶은 분할된 이름을 입력하여 볼 수 있음')

dim(sp$setosa)
dim(sp$versicolor)

# aggregate()
df<-subset(iris,select=c(1,2))
aggregate(df,by=list(sp=iris$Species),FUN=length)

aggregate(df,by=list(sp=iris$Species),FUN=mean)

aggregate(df,by=list(sp=iris$Species),FUN=sd)

# 여러개의 범주를 사용한 aggregate()
str(mtcars)

df<-subset(mtcars,select=c('mpg','hp','wt'))
aggregate(df,by=list(cyl=mtcars$cyl,gear=mtcars$gear),FUN=mean)

# rbind(행결합)
df.2 <- rbind(sp$setosa,sp$versicolor)
df.2

iris.split<-split(iris,f=iris$Species)
class(iris.split)
class(iris.split$setosa)

iris.rbind<-rbind(iris.split$setosa,iris.split$versicolor)
str(iris.rbind)
comment('setosa와 versicolor 합쳐서 100개 행을 가짐')


# cbind(열결합)
df.3 <- cbind(iris[,1:2],iris[,3:4])
df.3

iris.sepal<-subset(iris,select=c(1,2))
str(iris.sepal)
iris.petal<-subset(iris,select=c(3,4))
str(iris.petal)
iris.cbind<-cbind(iris.sepal,iris.petal)
str(iris.cbind)
comment('열 2개씩있는 데프를 열결합 했으므로 총 4개 열이 있는 데프가 생성됨됨')

iris[,-5]
comment('df.3와 동일한 결과')

# merge()
x<-data.frame(name=c('A','B','C'),kor=c(60,70,70))
y<-data.frame(name=c('A','B','D'),eng=c(65,75,85))
cbind(x,y)
# rbind(x,y) 열은 2개로 같지만 열이름이 달라서 행결합 못함
merge(x,y)
comment('x와 y의 name을 기준으로 합치는데 name C나 D는 x와 y에 모두 있는 것이 아니라 출력되지 않음
        그럼 C와 D도 출력하고 싶을 때는 어떻게 해야 할까??')

# all=옵션
merge(x,y,all=T)
comment('C와 D도 같이 출력되지만 값이 없던 부분에는 NA로 대체 된것을 확인')

merge(x,y,all.x=T) # x에 있는 name열 값만 출력 => A,B,C
merge(x,y,all.y=T) # y에 있는 name열 값만 출력=> A,B,D

# 2개 데프의 이름이 다를 때 merge()
x<-data.frame(name=c('A','B','C'),kor=c(60,70,70))
y<-data.frame(NAME=c('A','B','D'),eng=c(65,75,85))

merge(x,y,by.x='name',by.y='NAME')
merge(x,y,by.x='name',by.y='NAME',all=T)
merge(x,y,by.x='name',by.y='NAME',all.x=T)
merge(x,y,by.x='name',by.y='NAME',all.y=T)

# 성적표.xlsx
df.1 <- read_excel('성적표.xlsx',sheet=1)
df.2 <- read_excel('성적표.xlsx',sheet=2)
df.1
df.2

cbind(df.1,df.2)
merge(df.1,df.2) # 열이름이 달라서 데카르트가 되어버림 5x5=25
merge(df.1,df.2,all=T) # 열이름이 다르므로 => 데카르트
merge(df.1,df.2,by.x=c('번호','이름'),by.y=c('No','Name'),all=T)

# sort와 order
mtcars$mpg

sort(mtcars$mpg) # 오름차순
sort(mtcars$mpg, decreasing=T) # 내림차순

order(mtcars$mpg)
comment('오름차순으로 정렬된 값의 원본에서의 인덱스 번호 반환')
order(mtcars$mpg,decreasing=T)
comment('내림차순으로 정렬된 값의 원본에서의 인덱스 번호 반환')

# order()로 상위 데이터만 추출해보기
ord_dec<-order(mtcars$mpg,decreasing=T)
mtcars[ord_dec,1:6]
comment('mpg열이 내림차순으로 정렬되고 1~6열만 보여줌')

mtcars[ord_dec[1:10],1:6]
comment('mpg의 상위 10개만 보여줌')

n<-length(ord_dec) # mtcars의 행의 수와 같음
mtcars[ord_dec[(n-9):n],1:6]

# order은 1개가 아닌 여러개의 변수로도 정렬할수도 있음
iris_ord<-order(iris$Petal.Length,iris$Sepal.Length)
iris[iris_ord,c(3,1)]
comment('Petal.Length값이 동일하면 Sepal.Length기준으로 정렬함')

iris_ord<-order(iris$Petal.Length, -iris$Sepal.Length)
iris[iris_ord,c(3,1)]
comment('Petal.Length오름차순, Sepal.Length은 내림차순')

iris_ord<-order(-iris$Sepal.Width, -iris$Petal.Width)
iris[iris_ord,c(2,4)]
comment('Petal.Length오름차순, Sepal.Length은 내림차순')

# 수업시간 sort
v <- c(40,50,20,40,10)
sort(v) # 오름차순, 원본은 변경되지 않음
sort(v,decreasing=T) # 내림차순

df <- data.frame(state.x77)
str(df)

org<-order(df$Illiteracy,decreasing = T)
org[1:10] # 상위 10개
df[org[1:10],c(3,2)]

# 연습문제 8-1
# state.x77 데이터 활용
# 1) Population열 기준으로 오름차순으로 정렬하시오
st_df<-data.frame(state.x77)
st_df[order(st_df$Population),] # 모든열 다보기

data.frame(population=st_df[order(st_df$Population),1])
comment('하나의 열만 빼면 벡터형식으로 되서 데프로 만듬')

# 2) Income을 기준으로 내림차순으로 정렬
st_df[order(st_df$Income,decreasing=T),] # 모든열 다보기

data.frame(income=st_df[order(st_df$Income,decreasing=T),2])

subset(st_df[order(st_df$Income,decreasing=T),],select = c(2))
comment('subset으로 열이름도 같이 나오게 만듬')

# 3) Illiteracy는 오름차순 Population은 내림차순
st_df[order(st_df$Illiteracy,-st_df$Population),c(3,1)]

subset(st_df[order(st_df$Illiteracy,-st_df$Population),],select = c(3,1))

# 연습문제 8-2
# mtcars셋을 활용
# 1) gear열 기준으로 그룹을 나누시오
df.split<-split(mtcars,f=mtcars$gear)
df.split

# 2) gear의 개수가 3과 4를 합치기
df.34<-rbind(df.split$`3`,df.split$`4`)
df.34

# 연습문제 8-3
# airquality데이터셋을 활용
# 1) 1~4열을 추출
df<-subset(airquality,select=1:4)
df

# 2) 1)의 df를 활용하여 월별로 평균구하기
aggregate(df,by=list(month=airquality$Month),FUN=mean,na.rm=T)

# 3) 1)의 df를 활용하여 일별로 표준편차구하기
aggregate(df,by=list(day=airquality$Day),FUN=sd,na.rm=T)
