rm(list=ls())

# R 1파트 2.내장데이터셋.pdf
# 데이터셋의 윗부분 행을 보여주는 함수
head(iris)
head(iris,10)

# 데이터셋의 아랫부분 행을 보여주는 함수
tail(mtcars)
tail(mtcars,15)

# 데이터셋 열의 타입을 알아보는 함수
class(iris$Sepal.Length)
class(iris$Species)

# 데이터셋의 factor타입의 levels을 보여줌
levels(iris$Species)
levels(iris$Sepal.Length)
comment('factor타입이 아니라면 NULL을 반환')

# 도수분포표
table(iris$Species)
comment('각 levels들의 개수를 보여줌')

# 막대그래프
barplot(table(iris$Species))

# 꽃잎길이에 대한 히스토그램
# 꽃잎길이는 연속형데이터
class(iris$Petal.Length)
mean(iris$Petal.Length)
var(iris$Petal.Length)
sd(iris$Petal.Length)
hist(iris$Petal.Length,col='steelblue')

# mtcars데이터셋
str(mtcars)
mtcars$mpg # 연비
mtcars$wt # 중량

summary(mtcars)
comment('데이터셋의 각 열의 통계값들을 확인')

summary(mtcars$mpg)
comment('하나의 열로도 확인할 수 있음')

hist(mtcars$mpg,col='steelblue')
comment('연비도 연속형 데이터로 히스토그램을 그려봄')

hist(mtcars$wt,col='orange',xlim=c(1,6),ylim=c(0,10))
comment('중량도 연속형 데이터로 히스토그램을 그려봄')

plot(mtcars$mpg,mtcars$wt,col='tomato',pch=19)
comment('중량과 연비의 산점도 그려봄
        그래프 확인 결과 연비와 중량은
        반비례 관계인 것으로 확인!!!
        pch=옵션은 점모양')

# R 검색경로에 추가해주는 함수
attach(iris)

# 검색경로에 있는 것을 찾아서 알려주는 함수
search()

# R 검색경로에 추가해주는 함수
detach(iris)

# 연습문제 2-1
# 1)아래와 같이 iris 데이터셋의 Species변수에 대해 막대그래프를 그리시오
plot(iris$Species,col='tomato',main='품좀의 막대그래프',xlab='품종',ylab='개수')

attach(iris)

# 연습문제 2-2
# 1)Petal.Width 통계량 구하기
mean(Petal.Width)
var(Petal.Width)
sd(Petal.Width)

# 2)Petal.Width에 대해 히스토그램 구하기
hist(Petal.Width,col='tomato',main='꽃잎의 너비에 대한 히스토그램',xlab='꽃잎의 너비',ylab='빈도수')

# 연습문제 2-3
# 1)mtcars셋의 hp의 히스토그램을 그려보시오
# 1-0)축범위 지정x
hist(hp)
# 1-1)축범위 지정o
hist(hp,xlim=c(0,400),ylim=c(0,12))

# 2)hp와 mpg의 관계 산점도 그리기
plot(hp,mpg,pch=3,col='tomato')

# 연습문제2-4
# 1)변수와 관측값의 개수
str(cars)
nrow(cars) # 행 개수
ncol(cars) # 열 개수

# 2)변수에 대해서 다음 통계량을 구해보시오
summary(cars)

# 3)속력과 제동거리의 비교
plot(cars$speed,cars$dist,col='tomato',pch=4,xlim=c(0,30),ylim=c(0,150))
