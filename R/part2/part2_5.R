rm(list=ls())

# survey
library(MASS) # survey셋을 쓰기위한 패키지 불러오기
height<-survey$Height

## height열의 평균
h.mean<-mean(height,na.rm=T)
h.mean

## height열의 표준편차
h.sd<-sd(height,na.rm=T)
h.sd

## height열의 95% 신뢰구간
c(h.mean-1.96*h.sd,h.mean+1.96*h.sd)

## height열의 99% 신뢰구간
c(h.mean-2.58*h.sd,h.mean+2.58*h.sd)
comment('95%일 때 보다 범위가 넓어진 것을 확인
        => 기각할수 있는 영역이 줄어듬')

## qnorm(), pnorm()
qnorm(0.025,h.mean,h.sd)
qnorm(0.975,h.mean,h.sd)
pnorm(153.0801,h.mean,h.sd)
pnorm(191.6817,h.mean,h.sd,lower.tail=F)

## 신뢰구간으로 x의 범위 구하기
x<-seq(h.mean-3*h.sd,h.mean+3*h.sd,length=200)

## 누적확률로 확률변수값 구하기
lower<-qnorm(0.025,h.mean,h.sd) # 하위 2.5%
upper<-qnorm(0.975,h.mean,h.sd) # 상위 2.5%

## 확률변수에 맞는 확률구하기
y<-dnorm(x,h.mean,h.sd)

## 그래프 그리기
plot(x,y,type='l',col='lightgrey',lwd=2)
abline(0,0,col='blue',lwd=2)

## 95%의 구간을 색칠해보기
xlim<-x[lower<=x & x<=upper]
ylim<-y[lower<=x & x<=upper]-0.0001
xlim<-c(xlim[1],xlim,tail(xlim,1))
ylim<-c(0,ylim,0)
polygon(xlim,ylim,col='lightgrey')

# 이항분포 테스트
binom.test(x=60,n=100,p=0.5)
comment('유의확률인 p값이 0.05보다 크므로 귀무가설을 
        기각하지 못하므로 p=0.5라고 할 수 있음')

binom.test(x=50,n=100,p=0.5)
comment('유의확률인 p값이 0.05보다 크므로 귀무가설을 
        기각하지 못하므로 p=0.5라고 할 수 있음
        와!!!! p값이 1이네...... 딱 50%라 그런듯')

binom.test(x=80,n=100,p=0.5)
comment('유의확률인 p값이 0.05보다 작으므로 귀무가설을 
        기각하여 p는 0.5가 아니라고 할 수 있음')

binom.test(x=45,n=100,p=0.5,conf.level=0.99)
comment('conf.level=옵션으로 신뢰수준을 정할수 있음
        기본값은 0.95임')

binom.test(x=45,n=100,p=0.5,conf.level=0.99,alternative='greater')
comment('alternative=옵션은 양측/단측을 할지 정해주는 옵션으로
        two.sided(기본값), greater, less가 있음')

binom.test(x=35,n=100,p=0.5,conf.level=0.99,alternative='less')
comment('H0: p>=0.5, H1:p<0.5이라는 가설이고 ho가 기각=>h1 채택')

# 이항분포
x<-rbinom(10000,100,0.5)
comment('이항분포의 평균은 50, 분산은 25, 표준편차는 5')

hist(x,col='blue',freq=F)
curve(dnorm(x,50,5),30,70,col='red',add=T,lwd=2)

# lower.tail 옵션
pnorm(1,lower.tail=F)
comment('Z가 1일 때 오른쪽의 확률')

1-2*pnorm(1,lower.tail=F)
comment('양쪽에 Z가 1일 때을 얻애면 68%의 신뢰수준을 얻을 수 있음')

qnorm(0.75,lower.tail=F)

# iris상관계수
cor(iris[,-5])
comment('Petal.Length와 Petal.Width가 높은 상관계수가 나타나는 것으로 확인하고
        Sepal.Width와 Sepal.Length는 낮은 상관계수 가 나타남')

cor.test(iris$Petal.Width,iris$Petal.Length)
comment('p값이 엄청 낮으므로 의미가 있다라고 보시면 될거같음')

library(psych)
corr.test(iris[,1:4])
comment('df에 수치형만 있으면 사용하기 편하고 각 변수 각의 상관계수 및
        p값도 볼 수 있어서 사용하기 편함')

# 누적확률로 x값 예측해보기
qnorm(p=0.5,mean=50,sd=10)
comment('50+0*10')

qnorm(p=0.84,mean=50,sd=10)
comment('50+1*10')

qnorm(p=0.975,mean=50,sd=10)
comment('50+2*10')

qnorm(p=0.995,mean=50,sd=10)
comment('50+2.58*10')

pnorm(75.75829,mean=50,sd=10)
comment('100-(2*(75.75829-50)/10)')

pnorm()

# 샤피로-월크 검정
comment('데이터의 정규성을 검정')

## survey셋 Height열 정규성 검정
shapiro.test(survey$Height)
comment('Height열은 0.05보다 크므로 정규성을 따름')

hist(survey$Height,freq=F)
curve(dnorm(x,mean(survey$Height,na.rm=T),sd(survey$Height,na.rm=T)),150,200,add=T,col='red')
comment('데이터가 정규성을 따르는지 그래프를 통해 확인')

## survey셋 Age열 정규성 검정
shapiro.test(survey$Age)
comment('p값이 0.05보다 작으므로 귀무가설 기각되고 정규성을 따른다고 볼 수 없음')

hist(survey$Age,freq=F)
curve(dnorm(x,mean(survey$Age),sd(survey$Age)),20,50,add=T)
comment('20대 초반에 몰려있는 데이터로 정규성이 있다고 볼 수 없는 그래프 확인')

## iris셋 Petal.Length열 
shapiro.test(iris$Petal.Length) # 정규성X
hist(iris$Petal.Length)

## mtcars셋 mpg열
shapiro.test(mtcars$mpg) # 정규성 O
hist(mtcars$mpg,breaks=20)

# 균등분포와 정규분포의 정규성
## 해당 분포로 랜덤데이터 추출
x.unif<-runif(100,50,100)
x.norm<-rnorm(100,mean(x.unif),sd(x.unif)) # 균일분포로 정규분포 만듬

## 샤피로 월크 검정
shapiro.test(x.unif)
comment('균등분포는 ho가 기각되어 정규성이 없다고 봄')

shapiro.test(x.norm)
comment('정규분포는 ho가 기각이 안되어 정규성이 있다고 봄')

## qqplot그려보기
par(mfrow=c(1,2))
qqnorm(x.unif,col='tomato',main='UNIF')
qqline(x.unif,col='orange',lwd=3)
comment('점과 선이 일치하는 모습이 안보여 정규성이 없다고 봄')

qqnorm(x.norm,col='tomato',main='UNIF')
qqline(x.norm,col='orange',lwd=3)
comment('점과 선이 일치하는 모습이 보여 정규성이 있다고 봄')

par(mfrow=c(1,1))

# qqplot 예시
qqnorm(survey$Height,col='tomato',main='Uniform Distribution')
qqline(survey$Height,col='blue')
comment('정규성을 따른다고 볼 수 있음')

qqnorm(survey$Age,col='tomato',main='Uniform Distribution')
qqline(survey$Age,col='blue')
comment('정규성을 따른다고 볼 수 없음')
